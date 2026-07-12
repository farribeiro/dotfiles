#!/usr/bin/env lua

local op = io.open
local x = os.execute
local u = require "util"
-- Inicio
local app_query = u.getoutput_all('gum input --placeholder "Digite o nome da aplicação"')
if not app_query or app_query == "" then os.exit(0) end
x('gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5')
local raw_list = u.getoutput_all("rpm -qa | grep " .. u.escape(app_query))
if not raw_list or raw_list == "" then
	print("⚠️  Nenhum app encontrado.")
	os.exit(1)
end
local display_list = {}
for l in raw_list:gmatch("[^\r\n]+") do table.insert(display_list, l) end
local tmp_list = os.tmpname()
local f = assert(op(tmp_list, "w"))
f:write(table.concat(display_list, "\n"))
f:close()
x("gum pager < " .. tmp_list)
os.remove(tmp_list)
