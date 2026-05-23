#!/usr/bin/env lua

local op = io.open
local x = os.execute
local u = require "util"
local function escape(str) return "'" .. str:gsub("'", "'\\''") .. "'" end
-- Inicio
local app_query = u.getoutput_all('gum input --placeholder "Digite o nome da aplicação"')
if not app_query or app_query == "" then os.exit(0) end
x('gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5')
local raw_list = u.getoutput_all("rpm -qa | grep " .. escape(app_query))
if not raw_list or raw_list == "" then
	print("⚠️  Nenhum app encontrado.")
	os.exit(1)
end
local display_list = {}
for line in raw_list:gmatch("[^\r\n]+") do table.insert(display_list, line) end
local tmp_list = os.tmpname()
local f = assert(op(tmp_list, "w"))
f:write(table.concat(display_list, "\n"))
f:close()
u.getoutput_all("gum filter --placeholder 'Filtro...' <" .. tmp_list)
os.remove(tmp_list)
