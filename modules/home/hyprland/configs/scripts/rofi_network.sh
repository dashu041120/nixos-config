#!/usr/bin/env bash
# NetworkManager shell script for rofi
# A shell replacement for the Python rofi_network script

# Configuration
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CONFIG_DIR="$HOME/.config/hypr/rofi"
CONFIG_FILE="$CONFIG_DIR/networkmenu_config.ini"

# Default values
DMENU_CMD="rofi -dmenu"
WIFI_CHARS="▂▄▆█"
ACTIVE_CHARS="=="
HIGHLIGHT=true
COMPACT=false
RESCAN_DELAY=5

# Test mode for debugging
TEST_MODE=false
if [[ "$1" == "--test" ]]; then
    TEST_MODE=true
    DMENU_CMD="echo 'TEST MODE - Would show:'; cat; echo '--- End of menu ---'; echo"
fi

# Colors
HIGHLIGHT_FG=""
HIGHLIGHT_BG=""
HIGHLIGHT_BOLD=true

# Load configuration if exists
if [[ -f "$CONFIG_FILE" ]]; then
    # Simple ini parser for basic options
    while IFS='=' read -r key value; do
        # Remove whitespace and comments
        key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s/#.*//')
        
        case "$key" in
            "dmenu_command") DMENU_CMD="$value" ;;
            "wifi_chars") WIFI_CHARS="$value" ;;
            "active_chars") ACTIVE_CHARS="$value" ;;
            "highlight") [[ "$value" =~ ^(true|True|1)$ ]] && HIGHLIGHT=true || HIGHLIGHT=false ;;
            "compact") [[ "$value" =~ ^(true|True|1)$ ]] && COMPACT=true || COMPACT=false ;;
            "rescan_delay") RESCAN_DELAY="$value" ;;
        esac
    done < <(grep -E '^[^#]*=' "$CONFIG_FILE" 2>/dev/null)
fi

# Utility functions
notify() {
    local message="$1"
    local urgency="${2:-low}"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u "$urgency" -a "networkmanager-dmenu" -t $((RESCAN_DELAY * 1000)) "$message"
    fi
}

is_enabled() {
    local service="$1"
    case "$service" in
        "networking")
            nmcli networking connectivity | grep -q "full\|limited"
            ;;
        "wifi")
            [[ "$(nmcli radio wifi)" == "enabled" ]]
            ;;
        "bluetooth")
            if command -v bluetoothctl >/dev/null 2>&1; then
                bluetoothctl show 2>/dev/null | grep -q "Powered: yes"
            else
                # Fallback to rfkill
                rfkill list bluetooth 2>/dev/null | grep -q "Soft blocked: no"
            fi
            ;;
    esac
}

get_signal_bars() {
    local signal="$1"
    local bars=""
    local num_bars=$((signal / 25))
    
    for ((i=0; i<4; i++)); do
        if [[ $i -lt $num_bars ]]; then
            bars+="${WIFI_CHARS:$i:1}"
        else
            bars+=" "
        fi
    done
    echo "$bars"
}

get_wifi_security() {
    local bssid="$1"
    local security=$(nmcli -t -f SECURITY dev wifi list bssid "$bssid" 2>/dev/null | head -1)
    [[ -z "$security" || "$security" == "--" ]] && echo "--" || echo "$security"
}

get_wifi_list() {
    # Get available wifi networks
    nmcli -t -f ACTIVE,SSID,BSSID,MODE,CHAN,FREQ,RATE,SIGNAL,BARS,SECURITY dev wifi list | \
    while IFS=':' read -r active ssid bssid mode chan freq rate signal bars security; do
        [[ -z "$ssid" ]] && continue
        
        # Format signal bars
        if [[ -n "$WIFI_CHARS" ]]; then
            bars=$(get_signal_bars "$signal")
        fi
        
        # Mark active connections
        local prefix=""
        if [[ "$active" == "yes" ]]; then
            prefix="$ACTIVE_CHARS "
        else
            prefix="$(printf "%*s" ${#ACTIVE_CHARS} "")"
        fi
        
        # Format security
        [[ -z "$security" ]] && security="--"
        
        if [[ "$COMPACT" == "true" ]]; then
            echo "${prefix} ${ssid}  ${security}  ${bars}"
        else
            printf "%s %-32s  %-12s %4s\n" "$prefix" "$ssid" "$security" "$bars"
        fi
    done
}

get_connections() {
    local type="$1"
    case "$type" in
        "vpn")
            nmcli -t -f NAME,TYPE,ACTIVE con show | grep ":vpn:" | while IFS=':' read -r name type active; do
                local prefix=""
                [[ "$active" == "yes" ]] && prefix="$ACTIVE_CHARS " || prefix="$(printf "%*s" ${#ACTIVE_CHARS} "")"
                echo "${prefix} ${name}:VPN"
            done
            ;;
        "ethernet"|"eth")
            nmcli -t -f NAME,TYPE,ACTIVE con show | grep ":ethernet:" | while IFS=':' read -r name type active; do
                local prefix=""
                [[ "$active" == "yes" ]] && prefix="$ACTIVE_CHARS " || prefix="$(printf "%*s" ${#ACTIVE_CHARS} "")"
                echo "${prefix} ${name}:ETH"
            done
            ;;
        "bluetooth")
            nmcli -t -f NAME,TYPE,ACTIVE con show | grep ":bluetooth:" | while IFS=':' read -r name type active; do
                local prefix=""
                [[ "$active" == "yes" ]] && prefix="$ACTIVE_CHARS " || prefix="$(printf "%*s" ${#ACTIVE_CHARS} "")"
                echo "${prefix} ${name}:BLUETOOTH"
            done
            ;;
    esac
}

get_other_actions() {
    local actions=()
    
    # Wifi toggle
    if is_enabled wifi; then
        actions+=("Disable Wifi")
    else
        actions+=("Enable Wifi")
    fi
    
    # Networking toggle
    if is_enabled networking; then
        actions+=("Disable Networking")
    else
        actions+=("Enable Networking")
    fi
    
    # Bluetooth toggle
    if is_enabled bluetooth; then
        actions+=("Disable Bluetooth")
    else
        actions+=("Enable Bluetooth")
    fi
    
    # Other actions
    actions+=("Launch Connection Manager")
    actions+=("Rescan Wifi Networks")
    actions+=("Delete a Connection")
    
    printf "%s\n" "${actions[@]}"
}

toggle_wifi() {
    local enable="$1"
    if [[ "$enable" == "true" ]]; then
        nmcli radio wifi on
        notify "Wifi enabled"
    else
        nmcli radio wifi off
        notify "Wifi disabled"
    fi
}

toggle_networking() {
    local enable="$1"
    if [[ "$enable" == "true" ]]; then
        nmcli networking on
        notify "Networking enabled"
    else
        nmcli networking off
        notify "Networking disabled"
    fi
}

toggle_bluetooth() {
    local enable="$1"
    if command -v bluetoothctl >/dev/null 2>&1; then
        if [[ "$enable" == "true" ]]; then
            bluetoothctl power on 2>/dev/null
            notify "Bluetooth enabled"
        else
            bluetoothctl power off 2>/dev/null
            notify "Bluetooth disabled"
        fi
    else
        # Fallback to rfkill
        if [[ "$enable" == "true" ]]; then
            rfkill unblock bluetooth 2>/dev/null
            notify "Bluetooth enabled"
        else
            rfkill block bluetooth 2>/dev/null
            notify "Bluetooth disabled"
        fi
    fi
}

connect_wifi() {
    local ssid="$1"
    
    # Check if connection already exists
    if nmcli con show "$ssid" >/dev/null 2>&1; then
        nmcli con up "$ssid"
        notify "Connected to $ssid"
    else
        # Need password for new connection
        local password
        password=$(echo "" | $DMENU_CMD -p "Password for $ssid:" -password)
        
        if [[ -n "$password" ]]; then
            nmcli dev wifi connect "$ssid" password "$password"
            if [[ $? -eq 0 ]]; then
                notify "Connected to $ssid"
            else
                notify "Failed to connect to $ssid" "critical"
            fi
        fi
    fi
}

disconnect_wifi() {
    local ssid="$1"
    nmcli con down "$ssid"
    notify "Disconnected from $ssid"
}

rescan_wifi() {
    nmcli dev wifi rescan
    sleep "$RESCAN_DELAY"
    notify "Wifi scan complete"
    main # Restart the menu
}

launch_connection_manager() {
    if command -v nm-connection-editor >/dev/null 2>&1; then
        nm-connection-editor &
    elif command -v nmtui >/dev/null 2>&1; then
        "${TERMINAL:-alacritty}" -e nmtui &
    else
        notify "No network connection editor found" "critical"
    fi
}

delete_connection() {
    local connections
    connections=$(nmcli -t -f NAME con show | tr '\n' '\n')
    
    local selected
    selected=$(echo "$connections" | $DMENU_CMD -p "Delete connection:")
    
    if [[ -n "$selected" ]]; then
        nmcli con delete "$selected"
        notify "Deleted connection: $selected"
    fi
}

process_selection() {
    local selection="$1"
    
    # Remove active prefix if present
    selection=$(echo "$selection" | sed "s/^$ACTIVE_CHARS //")
    
    case "$selection" in
        "Enable Wifi")
            toggle_wifi true
            ;;
        "Disable Wifi")
            toggle_wifi false
            ;;
        "Enable Networking")
            toggle_networking true
            ;;
        "Disable Networking")
            toggle_networking false
            ;;
        "Enable Bluetooth")
            toggle_bluetooth true
            ;;
        "Disable Bluetooth")
            toggle_bluetooth false
            ;;
        "Launch Connection Manager")
            launch_connection_manager
            ;;
        "Rescan Wifi Networks")
            rescan_wifi
            ;;
        "Delete a Connection")
            delete_connection
            ;;
        *":VPN")
            local name=$(echo "$selection" | sed 's/:VPN$//')
            # Check if already connected
            if nmcli con show --active | grep -q "$name"; then
                nmcli con down "$name"
                notify "Disconnected VPN: $name"
            else
                nmcli con up "$name"
                notify "Connected VPN: $name"
            fi
            ;;
        *":ETH")
            local name=$(echo "$selection" | sed 's/:ETH$//')
            # Check if already connected
            if nmcli con show --active | grep -q "$name"; then
                nmcli con down "$name"
                notify "Disconnected: $name"
            else
                nmcli con up "$name"
                notify "Connected: $name"
            fi
            ;;
        *":BLUETOOTH")
            local name=$(echo "$selection" | sed 's/:BLUETOOTH$//')
            # Check if already connected
            if nmcli con show --active | grep -q "$name"; then
                nmcli con down "$name"
                notify "Disconnected: $name"
            else
                nmcli con up "$name"
                notify "Connected: $name"
            fi
            ;;
        *)
            # Assume it's a wifi network
            local ssid=$(echo "$selection" | awk '{print $1}')
            # Check if it's currently active
            if nmcli -t -f ACTIVE,SSID dev wifi list | grep "^yes:$ssid$" >/dev/null; then
                disconnect_wifi "$ssid"
            else
                connect_wifi "$ssid"
            fi
            ;;
    esac
}

main() {
    # Check if NetworkManager is running
    if ! pgrep -x NetworkManager >/dev/null; then
        notify "NetworkManager is not running" "critical"
        exit 1
    fi
    
    # Build menu options
    local options=()
    
    # Add ethernet connections
    mapfile -t eth_connections < <(get_connections "ethernet")
    if [[ ${#eth_connections[@]} -gt 0 ]]; then
        options+=("${eth_connections[@]}")
        [[ "$COMPACT" != "true" ]] && options+=("")
    fi
    
    # Add wifi networks
    if is_enabled wifi; then
        mapfile -t wifi_list < <(get_wifi_list)
        if [[ ${#wifi_list[@]} -gt 0 ]]; then
            options+=("${wifi_list[@]}")
            [[ "$COMPACT" != "true" ]] && options+=("")
        fi
    fi
    
    # Add VPN connections
    mapfile -t vpn_connections < <(get_connections "vpn")
    if [[ ${#vpn_connections[@]} -gt 0 ]]; then
        options+=("${vpn_connections[@]}")
        [[ "$COMPACT" != "true" ]] && options+=("")
    fi
    
    # Add bluetooth connections
    mapfile -t bt_connections < <(get_connections "bluetooth")
    if [[ ${#bt_connections[@]} -gt 0 ]]; then
        options+=("${bt_connections[@]}")
        [[ "$COMPACT" != "true" ]] && options+=("")
    fi
    
    # Add other actions
    mapfile -t other_actions < <(get_other_actions)
    options+=("${other_actions[@]}")
    
    # Show menu
    local selected
    selected=$(printf "%s\n" "${options[@]}" | $DMENU_CMD -p "Networks:")
    
    # Process selection
    if [[ -n "$selected" ]]; then
        process_selection "$selected"
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
