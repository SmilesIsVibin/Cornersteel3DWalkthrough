#!/bin/sh
echo -ne '\033c\033]0;Cornersteel-Office-Walkthrough-Latest\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Cornersteel-Office-Walkthrough-Latest.x86_64" "$@"
