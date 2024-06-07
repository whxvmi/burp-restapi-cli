#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <URL or File>"
    exit 1
fi

if [[ -f "$1" ]]; then
    urls=()
    while IFS= read -r line; do
        urls+=("$line")
    done < "$1"
    location=$(curl -v --silent -POST http://127.0.0.1:1337/v0.1/scan  2>&1 \
        -H "Content-Type: application/json" \
        -d '{"urls": '"$(printf '%s\n' "${urls[@]}" | jq -R . | jq -s .)"'}' | grep Location | cut -d ':' -f2- | tr -d '[:space:]')
else
    url="$1"
    location=$(curl -v --silent -POST http://127.0.0.1:1337/v0.1/scan  2>&1 \
        -H "Content-Type: application/json" \
        -d '{"urls": ["'"$url"'"]}' | grep Location | cut -d ':' -f2- | tr -d '[:space:]')
fi

echo "Launched. TaskID: $location"
sleep 5
curl -X GET --url "http://localhost:1337/v0.1/scan/$location"
