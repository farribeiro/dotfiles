#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

local yt = "yt-dlp -x"

local handelrs ={
	["mp3"] = function()
		os.execute(("%s --audio-format mp3 %s"):format(yt, arg[2]))
	end,

	["opus"] = function()
		os.execute(("%s --embed-thumbnail --embed-metadata --audio-format opus %s"):format(yt, arg[2]))
	end
}

handelrs["r"] = handelrs["mp3"]
handelrs["radinho"] = handelrs["mp3"]
handelrs["c"] = handelrs["opus"]
handelrs["celular"] = handelrs["opus"]

if not arg or #arg == 0 then
	os.exit(1)
end
handelrs[arg[1]]()
