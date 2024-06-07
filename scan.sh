#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

url="$1"
location=$(curl -v --silent -POST http://127.0.0.1:1337/v0.1/scan  2>&1 \
    -H "Content-Type: application/json" \
    -d '{"urls": ["'"$url"'"]}' | grep Location | cut -d ':' -f2- | tr -d '[:space:]')

echo "Launched. TaskID: $location"

while true; do
    sleep 5
    curl -X GET --url "http://localhost:1337/v0.1/scan/$location"
done
