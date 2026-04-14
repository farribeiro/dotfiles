#!/usr/bin/env lua

local op = io.open
local x = os.execute

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

	local f = assert(op(tmp, "r"))
	local content = f:read("*a"):gsub("^%s*(.-)%s*$", "%1")
	f:close()
	f = nil
	os.remove(tmp)
	return content
end

local function escape(str) return "'" .. str:gsub("'", "'\\''") .. "'" end

-- Inicio
local app_query = shell_read('gum input --placeholder "Digite o nome da aplicação"')
if not app_query or app_query == "" then os.exit(0) end

x('gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5')

local raw_list = shell_read("rpm -qa | grep " .. escape(app_query))
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
shell_read("gum filter --placeholder 'Filtro...' <" .. tmp_list)
os.remove(tmp_list)
