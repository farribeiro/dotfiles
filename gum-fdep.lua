#!/usr/bin/env lua
-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2025 - Fábio Rodrigues Ribeiro and contributors
local op = io.open
local x = os.execute
local u = require "util"
local app_query = u.getoutput_all('gum input --placeholder "Digite o nome da aplicação"')
if not app_query or app_query == "" then os.exit(0) end
local cmd_rq = "dnf -q repoquery "
local cmd_rq_pv = cmd_rq .. "%s --providers-of=%s"
local handlers = {
	["filepackage"] = function() return cmd_rq_pv:format(app_query, "provides") end,
	["showdeps"] = function() return cmd_rq_pv:format(app_query, "depends") end,
	["whatdepends"] = function() return ("%s --whatdepends %s"):format(cmd_rq, app_query) end
}
local choice = u.getoutput_all(
	"echo -e 'filepackage\nshowdeps\nwhatsdepends\nCancelar' | gum filter --placeholder 'O que deseja fazer?'")
if choice and handlers[choice] then x(handlers[choice]) else print("🛑 Operação cancelada.") end
