#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2025 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute

local handlers = {
    ["findfile"] = function () x(("dnf provides %s"):format(arg[2])) end,
	["whatsdepends"] = function () x(("dnf repoquery --whatdepends %s"):format(arg[2])) end
}

handlers["ff"] = handlers["findfile"]
handlers["wd"] = handlers["whatsdepends"]


if require"sai":ca() then handlers["help"]() os.exit(1) end
handlers[arg[1]]()
