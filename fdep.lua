#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2025 - Fábio Rodrigues Ribeiro and contributors

local cmd_rq = "dnf -q repoquery "
local cmd_rq_pv = cmd_rq .. "%s --providers-of=%s"

local handlers = {
    ["filepackage"] = function (q) return cmd_rq_pv:format(q, "provides") end,
    ["showdeps"] = function (q) return cmd_rq_pv:format(q, "depends") end,
	["whatdepends"] = function (q) return cmd_rq .. ("--whatdepends %s"):format(q) end
}

handlers["fp"] = handlers["filepackage"]
handlers["wd"] = handlers["whatdepends"]
handlers["sd"] = handlers["showdeps"]

if require"sai":ca() then handlers["help"]() os.exit(1) end
os.execute(handlers[arg[1]](arg[2]))
