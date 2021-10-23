#!/bin/bash

die() {
	echo "Terminating $1"
	exit 1
}

[[ -z $(which psd 2>/dev/null) ]] && die "no psd installed"

for target in $(psd p | grep sync\ target); do
	if [[
done
