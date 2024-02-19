#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023-2024 - Fábio Rodrigues Ribeiro and contributors

local yt = "yt-dlp -x --embed-thumbnail --embed-metadata --audio-format %s " .. arg[2]

local handlers ={
	["mp3"] = function() return yt:format("mp3") end,
	["opus"] = function() return yt:format("opus") end
}

handlers["r"] = handlers["mp3"] handlers["radinho"] = handlers["mp3"]
handlers["c"] = handlers["opus"] handlers["celular"] = handlers["opus"]

if not arg or #arg == 0 then os.exit(1) end
os.execute(handlers[arg[1]]())
