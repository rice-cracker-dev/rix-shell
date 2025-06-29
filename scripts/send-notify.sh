#!/usr/bin/env bash

basePath=$(dirname "$(dirname "$0")")
imagePath=$(realpath "${basePath}/assets/wallpaper/ba1.jpg")

if [[ "$1" = "action" ]]; then
  notify-send \
    -h "string:image-path:${imagePath}" \
    -A "action1=Open Url" \
    -A "action2=Do something" \
    "Lorem ipsum" \
    "This is a test notification"
elif [[ "$1" = "timeout" ]]; then
  notify-send \
    -h "string:image-path:${imagePath}" \
    -t 5000 \
    "Lorem ipsum" \
    "This is a test notification"
else
  notify-send \
    -h "string:image-path:${imagePath}" \
    "Lorem ipsum" \
    "This is a test notification"
fi
