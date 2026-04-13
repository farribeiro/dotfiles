#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2025 - Fábio Rodrigues Ribeiro and contributors

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
if not app_query or app_query == "" then os.exit(0) end

local cmd_rq = "dnf -q repoquery "
local cmd_rq_pv = cmd_rq .. "%s --providers-of=%s"

local handlers = {
	["filepackage"] = function() return cmd_rq_pv:format(app_query, "provides") end,
	["showdeps"] = function() return cmd_rq_pv:format(app_query, "depends") end,
	["whatdepends"] = function() return cmd_rq .. ("--whatdepends %s"):format(app_query) end
}

local choice = shell_read("echo -e 'filepackage\nshowdeps\nwhatsdepends\nCancelar' | gum filter --placeholder 'O que deseja fazer?'")
if choice and handlers[choice] then x(handlers[choice]) else print("🛑 Operação cancelada.") end
