#!/bin/bash

if [ -z "$1" ]; then
  echo "No link provided" >&2
fi

NEW_URL=$(sed -r -n 's/URL=(.*)/\1/p' "$1")

cat <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=${1//.url}
Type=Link
URL=$NEW_URL
Icon=text-html
EOF
