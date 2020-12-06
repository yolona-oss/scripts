#!/bin/bash

[[ -f patch.diff ]] && cp patch.diff patch.diff.save.$(wc -l <<< $(ls -l patch.diff.save*))
>patch.diff
pkg=$(grep "pkgname=" PKGBUILD | cut -d= -f2 | sed 's/-git//')
while read file; do
	diff -up "$pkg-orig$file" "$pkg-modif$file" >> patch.diff
done <<< `find $pkg-modif/ -not -path '*/\.*' -type f | awk -F/ 'BEGIN{OFS = FS} {$1=""; print}'`
