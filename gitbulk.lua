#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute
local sai = require "sai"

local handlers = {
	["clone"] = function ()
		local file = assert(io.open("git.txt", "r"))
		for line in file:lines() do x(("git clone %s"):format(line)) end
		file:close()
	end,
	["sm"] = function() x "git submodule update && git submodule update --init" end,
	["pull"] = function() x "find . -maxdepth 1 -type d -exec bash -c \"cd '{}' && git pull\" \\;" end
}

sai.ca_none()
handlers[arg[1]]()
