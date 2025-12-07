#!/usr/bin/env bash

set -e

# ========== Image Quality Settings ==========
FORMAT="png"        # Output format: png / jpeg / webp
PNG_LEVEL="6"       # PNG compression level: 0-9 (0 fastest, 9 highest compression)
JPEG_QUALITY="90"   # JPEG/WebP quality: 0-100 (higher = better quality)

# ========== Save Directory ==========
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

# ========== Temp File ==========
TMP_DIR="${XDG_RUNTIME_DIR:-/tmp}"
TMP_FILE="$(mktemp "${TMP_DIR}/niri-shot-XXXXXX.${FORMAT}")"

cleanup() { rm -f "$TMP_FILE"; }
trap cleanup EXIT

# ========== Region Screenshot ==========
if [ "$FORMAT" = "png" ]; then
    grim -t png -l "$PNG_LEVEL" -g "$(slurp)" "$TMP_FILE" || exit 1
else
    grim -t "$FORMAT" -q "$JPEG_QUALITY" -g "$(slurp)" "$TMP_FILE" || exit 1
fi

# ========== Fuzzel Menu ==========
CHOICE=$(printf "Save to file\nCopy to clipboard\nSave and copy to clipboard\nEdit with satty" | \
    fuzzel --dmenu --prompt "Screenshot action: ")

[ -z "$CHOICE" ] && exit 0

# ========== Execute Based on Choice ==========
case "$CHOICE" in
    "Save to file")
        SAVE_PATH="${SAVE_DIR}/$(date +'%Y-%m-%d_%H-%M-%S').${FORMAT}"
        cp "$TMP_FILE" "$SAVE_PATH"
        ;;

    "Copy to clipboard")
        # Write to both Wayland and X11 clipboard
        wl-copy < "$TMP_FILE" &
        xclip -selection clipboard -t "image/${FORMAT}" < "$TMP_FILE" &
        wait
        # Keep temp file to prevent clipboard content loss
        (sleep 60 && rm -f "$TMP_FILE") &
        trap - EXIT
        ;;

    "Save and copy to clipboard")
        # Save to file
        SAVE_PATH="${SAVE_DIR}/$(date +'%Y-%m-%d_%H-%M-%S').${FORMAT}"
        cp "$TMP_FILE" "$SAVE_PATH"
        # Copy to both Wayland and X11 clipboard
        wl-copy < "$TMP_FILE" &
        xclip -selection clipboard -t "image/${FORMAT}" < "$TMP_FILE" &
        wait
        ;;

    "Edit with satty")
        satty --filename "$TMP_FILE" --fullscreen \
            --copy-command "sh -c 'tee >(wl-copy) | xclip -selection clipboard -t image/png'" \
            --output-filename "${SAVE_DIR}/satty-$(date +'%Y%m%d-%H%M%S').png"
        ;;
esac

