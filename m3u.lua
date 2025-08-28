#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

require "sai":ca_none()
local filename = arg[1] .. ".m3u"
local file = require "util".open_file(filename, "w")
file:write("#EXTM3U\n") file:write(arg[2] .. "\n") file:close()
print(("%s criado com sucesso."):format(filename))
