#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023-2024 - Fábio Rodrigues Ribeiro and contributors

local sai = require "sai"
sai.ca_none()
local yt = "yt-dlp -x --embed-thumbnail --embed-metadata --audio-format %s " .. arg[2]

local handlers = {
	["mp3"] = function() return yt:format("mp3") end,
	["opus"] = function() return yt:format("opus") end
}

handlers["r"] = handlers["mp3"] handlers["radinho"] = handlers["mp3"]
handlers["c"] = handlers["opus"] handlers["celular"] = handlers["opus"]

os.execute(handlers[arg[1]]())
