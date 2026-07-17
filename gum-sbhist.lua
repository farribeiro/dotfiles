#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2026 - Fábio Rodrigues Ribeiro and contributors

-- x('gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5')
local p_in = assert(io.popen("rpm -qa --nodigest --nosignature --last", "r"))
local t = {}
for l in p_in:lines() do t[#t + 1] = l end
p_in:close()
os.execute("gum pager << EOF\n" .. table.concat(t, "\n") .. "EOF")
