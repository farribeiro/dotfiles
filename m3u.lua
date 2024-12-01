#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

if not arg or #arg == 0 then io.write("Nenhum argumento foi passado, saindo...\n") os.exit(1) end
local filename = arg[1] .. ".m3u"
local file = assert(io.open(filename, "w"))
if not file then error ("Erro ao abrir o arquivo %s para escrita."):format(filename) end
file:write("#EXTM3U\n") file:write(arg[2] .. "\n") file:close()
print (("%s criado com sucesso."):format(filename))
