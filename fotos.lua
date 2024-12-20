#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

x = os.execute
local util = require "util"
local sai = require "sai"

local function ls() return util.getoutput([[\ls -1]]):gsub("[\n\r]", "") end
local function mkdir() x("mkdir -p resultado") end

local function corre(file, opt)
	if file:match "%.avif$" or file:match "%.jpg$" or file:match "%.jpeg$" or file:match "%.png$" or file:match "%.webp$" or file:match "%.jxl$" then x(("convert %s"):format(opt)) end
end

local function resize(size)
	mkdir() for file in ls() do corre(file, ([[-resize %s "%s" "resultado/%s"]]):format(size, file, file)) end
end

local function normalize_ppi()
	mkdir() for file in ls() do corre(file, ([[-depth 72 "%s" "www/%s"]]):format(file, file)) end
end

handlers ={
	["resize-800600"] = function() resize "800x600" end,
	["resize-hd"] = function() resize "1280x720" end,
	["normalize-ppi"] = function() normalize_ppi() end
}

sai.ca_none()
handlers[arg[1]]()
