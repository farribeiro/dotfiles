#!/usr/bin/env lua

local x = os.execute
local p = print
local u = require "util"
local fk = "flatpak "

local function escape(str) return "'" .. str:gsub("'", "'\\''") .. "'" end
local app_query = u.getoutput_all 'gum input --placeholder "Digite o nome da aplicação"'
if not app_query or app_query == "" then os.exit(0) end
x 'gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5'
local raw_list = u.getoutput_all("flatpak search " .. escape(app_query) .. " --columns=application")
if not raw_list or raw_list == "" then
	p "⚠️  Nenhum app encontrado."
	os.exit(1)
end
local installed_raw = u.getoutput_all "flatpak list --columns=application"
local installed_apps = {}
if installed_raw then for id in installed_raw:gmatch "[^\r\n]+" do installed_apps[id:gsub("%s+", "")] = true end end
local ids_reais = {}
local display_list = {}
for line in raw_list:gmatch "[^\r\n]+" do
	local id_completo = line:gsub("%s+", "")
	local short_name = id_completo:match "([^.]+)$" or id_completo
	local label = short_name
	if installed_apps[id_completo] then label = short_name .. "[JÁ INSTALADO]" end
	table.insert(display_list, label)
	ids_reais[label] = id_completo -- Mapeia: firefox -> org.mozilla.firefox
end
local tmp_list = os.tmpname()
local f = assert(io.open(tmp_list, "w"))
f:write(table.concat(display_list, "\n"))
f:close()
local selected_short = u.getoutput_all("gum filter --placeholder 'Escolha o app...' < " .. tmp_list)
os.remove(tmp_list)
if not selected_short or selected_short == "" then os.exit(0) end
local selected_id = ids_reais[selected_short] or selected_short
local dd = " --delete-data "
local ay = " --assumeyes "
local es = escape(selected_id)
local handlers = {
	["Reinstalar"] = function() x(("%s install --reinstall %s %s"):format(fk, ay, es)) end,
	["Cancelar"] = function() os.exit(0) end,
	["Info"] = function() x(("%s info %s"):format(fk, es)) end,
	["Desinstalar"] = function()
		x(("%s remove %s %s"):format(fk, ay, escape(selected_id)))
		p "🗑️  Removido com sucesso."
	end,
	["Force_Reinstall"] = function()
		x(("%s remove %s %s %s"):format(fk, ay, dd, es))
		x(("%s install %s %s"):format(fk, ay, es))
		p "🗑️  Reinstação forçada com sucesso."
	end,
	["Force_Uninstall"] = function()
		x(('%s remove %s %s %s'):format(fk, ay, dd, es))
		p "🗑️  Expurgado com sucesso."
	end,
	["Instalar"] = function()
		if x('gum confirm "Deseja instalar ' .. selected_id .. '?"') then
			p(("📦 Instalando %s ..."):format(selected_id))
			x(('%s install %s %s'):format(fk, ay, es))
		else
			p "🛑 Operação cancelada."
		end
	end
}
if installed_apps[selected_id] then
	-- p(("ℹ️  O app ' %s ' já está instalado."):format(selected_id))
	local choice = u.getoutput_all "echo -e 'Desinstalar\nForce_Uninstall\nReinstalar\nForce_Reinstall\nInfo\nCancelar' | gum filter --placeholder 'O que deseja fazer?'"
	if choice and handlers[choice] then handlers[choice]() else print("🛑 Operação cancelada.") end
	os.exit(0)
end
handlers["Instalar"]()
