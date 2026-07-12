#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2026 - Fábio Rodrigues Ribeiro and contributors

local pop = io.popen
-- Abertua Pipes / Stream Lua
local p_in = assert(pop("flatpak list --app | sed -E 's/stable|flathub|system|master|cosmic|user//g' < <(column -t)", "r"))
local p_out = assert(pop("gum pager", "w"))
local t = {}
for l in p_in:lines() do t[#t + 1] = l:gsub("%d+$", "") end
p_in:close()
p_out:write(table.concat(t, "\n")):close()
