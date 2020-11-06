#!/bin/bash

while read line; do
	ffmpeg -i "$line" -q:v 4 "$(basename "${line%.*}")".avi
done <<< $(find $(pwd) -type f -name "*.mp4")

