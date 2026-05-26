#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

require "sai":ca_none()
local filename = arg[1] .. ".m3u"
local f = assert(io.open(filename, "w"))
f:write("#EXTM3U\n" .. arg[2] .. "\n"):close()
print(("%s criado com sucesso."):format())
