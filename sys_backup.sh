#!/bin/bash

output="/home/$(date '+%d.%m.%Y')_ArchLinux.backup"
hp="/home/pumpurumprumpum"

rsync -aAXHv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found",\
	"/home/data/packages","/home/data/system","/home/data/media",\
	"${hp}/.cache/mozilla","${hp}/.cache/luakit","${hp}/.cache/wine","${hp}/.cache/winetricks",\
	"${hp}.cache/thumbnails","${hp}/.cache/mesa_shader_cache","${hp}/.cache/sxiv","${hp}/.cache/yarn",\
	"${hp}/.local/share/Steam","${hp}/.local/share/torbrowser","${hp}/.local/share/luakit-*",\
	"${hp}/.ccache",\
	"${hp}.config/whatsapp*","${hp}/.config/discord",\
	"${hp}/.trash","${hp}/.wine","${hp}/downloads",\
	"${output}"} / "${output}"
