#!/usr/bin/env lua

local op = io.open
local x = os.execute

local function shell_read(cmd)
	local tmp = os.tmpname()

	local function success(cmd)
		local r1, r2, r3 = x(cmd)
		if type(r1) == "boolean" then
			return r1
		elseif type(r1) == "number" then
			return r1 == 0
		else
			return false
		end
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

x('gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5')

local display_list = {}

for line in shell_read(
	"flatpak history --reverse | grep -Ev \"master|origin\" | sed 's/deploy//Ig' | sed 's/stable.*$//Ig'"):gmatch("[^\r\n]+") do
	table.insert(display_list, line)
end

local tmp_list = os.tmpname()
local f = assert(op(tmp_list, "w"))
f:write(table.concat(display_list, "\n"))
f:close()
local selected_short = shell_read("gum filter --placeholder 'Escolha o app...' < " .. tmp_list)
os.remove(tmp_list)

if not selected_short or selected_short == "" then os.exit(0) end
