#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023-2024 - Fábio Rodrigues Ribeiro and contributors

local sai = require "sai"
sai.ca_none()
local aria = "aria2c %s " .. arg[2]

local handlers = {
	["bittorrent"] = function () return aria:format("-V") end,
	["download"] = function () return aria:format("-j 20 -c") end
}

handlers["t"] = handlers["bittorrent"]
handlers["d"] = handlers["download"]

os.execute(handlers[arg[1]]())
