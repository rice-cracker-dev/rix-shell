#!/usr/bin/env bash

basePath=$(dirname "$(dirname "$0")")
imagePath=$(realpath "${basePath}/assets/wallpaper/ba1.jpg")

notify-send \
  -h "string:image-path:${imagePath}" \
  -A "action1=Open Url" \
  -A "action1=Open Url" \
  "Lorem ipsum" \
  "This is a test notification"
