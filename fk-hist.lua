#!/usr/bin/env lua

local op = io.open
local u = require "util"
local x = os.execute

-- Inicio
x('gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5')

local display_list = {}

for line in u.getoutput_all(
	"flatpak history --reverse | grep -Ev \"master|origin|uninstall\" | sed -E 's/(deploy|stable|system.*$)//Ig'"):gsub("^%s*(.-)%s*$", "%1"):gmatch(
	"[^\r\n]+") do
	table.insert(display_list, line)
end

local tmp_list = os.tmpname()
local f = assert(op(tmp_list, "w"))
f:write(table.concat(display_list, "\n"))
f:close()
x("gum filter --placeholder 'Entradas...' < " .. tmp_list)
os.remove(tmp_list)
