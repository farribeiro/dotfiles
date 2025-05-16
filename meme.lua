#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

require "sai":ca_none()
os.execute(("ffmpeg -i %s -vf \"split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse\" -loop 0 %s"):format(arg[1], arg[1]:gsub("%.mp4", ".webp")))
