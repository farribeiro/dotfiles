#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

require "sai":ca_none()
os.execute(("ffmpeg -i %s -c:v libaom-av1 -crf 30 -b:v 0 -strict experimental %s "):format(arg[1],
	arg[1]:gsub("%.mp4", ".avif")))
