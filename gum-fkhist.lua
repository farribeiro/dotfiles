#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2026 - Fábio Rodrigues Ribeiro and contributors

local pop = io.popen
-- Abertua Pipes / Stream Lua
local pin = assert(pop("flatpak list --app | sed -E 's/stable|flathub|system|master|cosmic|user//g' < <(column -t)", "r"))
local pout = assert(pop("gum pager", "w"))
local t = {}
for l in pin:lines() do t[#t + 1] = l:gsub("%d+$", "") end
pin:close()
pout:write(table.concat(t, "\n")):close()
