#!/bin/sh

# YYMMDD
date=$(git log -1 --date=format:"%Y%m%d" --format="%ad")

# shor hash
hash=$(git rev-parse --short HEAD)

# $1 - tool name, $2 - patch name
tool=${1} # rewrite with "shift"
patchname=${2:-"patch"}
patchfile="$tool-$patchname-$date-$hash.diff"

git format-patch --stdout HEAD^ > "$patchfile"
echo "Patch $patchfile created"
