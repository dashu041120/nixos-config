#!/usr/bin/env bash

set -e

# ========== Image Quality Settings ==========
FORMAT="png"        # png / jpeg / webp
PNG_LEVEL="1"       # 0-9 for png; 0 for not compress
JPEG_QUALITY="90"   # 0-100 for jpeg/webp

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

# ========== Always copy to clipboard first ==========
wl-copy < "$TMP_FILE" &
xclip -selection clipboard -t "image/${FORMAT}" < "$TMP_FILE" &
wait

# keep temp file a bit in case clipboard implementation still needs it
(sleep 60 && rm -f "$TMP_FILE") &
trap - EXIT

# ========== Notify with optional extra actions ==========
ACTION=$(
  notify-send "niri screenshot" \
    "Copied to clipboard. Extra action?" \
    -A save="Save to file" \
    -A edit="Edit with satty" \
    -A rspin="Show with rspin" \
    --wait
)

# If user does nothing / dismisses notification: just keep clipboard, no extra work
[ -z "$ACTION" ] && exit 0

case "$ACTION" in
  save)
    SAVE_PATH="${SAVE_DIR}/$(date +'%Y-%m-%d_%H-%M-%S').${FORMAT}"
    # if TMP_FILE already deleted by background cleanup, recreate from clipboard
    if [ ! -f "$TMP_FILE" ]; then
      TMP_FILE="$(mktemp "${TMP_DIR}/niri-shot-XXXXXX.${FORMAT}")"
      wl-paste > "$TMP_FILE"
    fi
    cp "$TMP_FILE" "$SAVE_PATH"
    notify-send "niri screenshot" "Saved to: ${SAVE_PATH}"
    ;;

  edit)
    # re-create temp file if needed
    if [ ! -f "$TMP_FILE" ]; then
      TMP_FILE="$(mktemp "${TMP_DIR}/niri-shot-XXXXXX.${FORMAT}")"
      wl-paste > "$TMP_FILE"
    fi
    satty --filename "$TMP_FILE" --fullscreen \
      --copy-command "sh -c 'tee >(wl-copy) | xclip -selection clipboard -t image/png'" \
      --output-filename "${SAVE_DIR}/satty-$(date +'%Y%m%d-%H%M%S').png"
    notify-send "niri screenshot" "Opened in satty"
    ;;

  rspin)
    # re-create temp file if needed
    if [ ! -f "$TMP_FILE" ]; then
      TMP_FILE="$(mktemp "${TMP_DIR}/niri-shot-XXXXXX.${FORMAT}")"
      wl-paste > "$TMP_FILE"
    fi
    cat "$TMP_FILE" | rspin --opacity 0.9
    notify-send "niri screenshot" "Displayed with rspin"
    ;;
    
  *)
    notify-send "niri screenshot" "Unknown action: ${ACTION}"
    exit 1
    ;;
esac

