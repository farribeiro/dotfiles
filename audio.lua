#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023-2024 - Fábio Rodrigues Ribeiro and contributors

local yt = "yt-dlp -x %s --audio-format %s %s"

local handelrs ={
	["mp3"] = function()
		 return yt:format("","mp3", arg[2])
	end,

	["opus"] = function()
		return yt:format("--embed-thumbnail --embed-metadata", "opus", arg[2])
	end
}

handelrs["r"] = handelrs["mp3"]
handelrs["radinho"] = handelrs["mp3"]
handelrs["c"] = handelrs["opus"]
handelrs["celular"] = handelrs["opus"]

if not arg or #arg == 0 then
	os.exit(1)
end
os.execute(handelrs[arg[1]])
