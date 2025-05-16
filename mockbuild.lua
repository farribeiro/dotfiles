#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2025 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute
local version = require "util":sbversion()

handlers={
	["cd"] = function () x(("cd /var/lib/mock/fedora-%d-x86_64-bootstrap/root"):format(version)) end,
	["build"] = function () x(("fedpkg --release f%d mockbuild"):format(version)) end
}

handlers["b"] = handlers["build"]
if require "sai":ca() then handlers["b"]() os.exit(0) end
handlers[arg[1]]()
