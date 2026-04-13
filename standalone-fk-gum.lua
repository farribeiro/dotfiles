#!/usr/bin/env lua

local op = io.open
local x = os.execute
local fk = "flatpak "

local function shell_read(cmd)
	local tmp = os.tmpname()

	local function success(cmd2)
		local r1, r2, r3 = x(cmd2)
		if type(r1) == "boolean" then return r1 elseif type(r1) == "number" then return r1 == 0 else return false end
	end

	if not success(cmd .. " > " .. tmp) then
		os.remove(tmp)
		return nil
	end

	local f = op(tmp, "r")
	local content = f:read("*a"):gsub("^%s*(.-)%s*$", "%1")
	f:close()
	f = nil
	os.remove(tmp)
	return content
end

local function escape(str) return "'" .. str:gsub("'", "'\\''") .. "'" end

-- Inicio
local deps = { "gum", "flatpak" }
for _, dep in ipairs(deps) do
	local status = x("command -v " .. dep .. " > /dev/null 2>&1")
	local ok = (type(status) == "boolean" and status) or (status == 0)
	if not ok then
		io.stderr:write("❌ Erro: A ferramenta '" .. dep .. "' não está instalada.\n")
		os.exit(1)
	end
end

local app_query = shell_read('gum input --placeholder "Digite o nome da aplicação"')
if not app_query or app_query == "" then
	os.exit(0)
elseif app_query == "fkunused" then
	local rm = ("%s remove "):format(fk)
	x(rm .. "--unused")
	x(rm .. "--delete-data")
	os.exit(0)
end

x('gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5')

local raw_list = shell_read("flatpak search " .. escape(app_query) .. " --columns=application")
if not raw_list or raw_list == "" then
	print("⚠️  Nenhum app encontrado.")
	os.exit(1)
end

local installed_raw = shell_read("flatpak list --columns=application")
local installed_apps = {}
if installed_raw then
	for id in installed_raw:gmatch("[^\r\n]+") do installed_apps[id:gsub("%s+", "")] = true end
end

local ids_reais = {}
local display_list = {}

for line in raw_list:gmatch("[^\r\n]+") do
	local id_completo = line:gsub("%s+", "")
	local short_name = id_completo:match("([^.]+)$") or id_completo

	local label = short_name
	if installed_apps[id_completo] then label = short_name .. "[JÁ INSTALADO]" end

	table.insert(display_list, label)
	ids_reais[label] = id_completo -- Mapeia: firefox -> org.mozilla.firefox
end

local tmp_list = os.tmpname()
local f = assert(op(tmp_list, "w"))
f:write(table.concat(display_list, "\n"))
f:close()
local selected_short = shell_read("gum filter --placeholder 'Escolha o app...' < " .. tmp_list)
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
		print("🗑️  Removido com sucesso.")
	end,
	["Force_Reinstall"] = function()
		x(("%s remove %s %s %s"):format(fk, ay, dd, es))
		x(("%s install %s %s"):format(fk, ay, es))
		print("🗑️  Reinstação forçada com sucesso.")
	end,
	["Force_Uninstall"] = function()
		x(('%s remove %s %s %s'):format(fk, ay, dd, es))
		print("🗑️  Expurgado com sucesso.")
	end,
	["Instalar"] = function()
		if x('gum confirm "Deseja instalar ' .. selected_id .. '?"') then
			print("\n📦 Instalando " .. selected_id .. "...")
			x(('%s install %s %s'):format(fk, ay, es))
		else
			print("\n🛑 Operação cancelada.")
		end
	end
}

if installed_apps[selected_id] then
	-- print("\nℹ️  O app '" .. selected_id .. "' já está instalado.")
	local choice = shell_read(
		"echo -e 'Desinstalar\nForce_Uninstall\nReinstalar\nForce_Reinstall\nInfo\nCancelar' | gum filter --placeholder 'O que deseja fazer?'")
	if choice and handlers[choice] then handlers[choice]() else print("🛑 Operação cancelada.") end
	os.exit(0)
end

handlers["Instalar"]()
