#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute
x "rm -rf list.txt output.flac output.mp3"
local handle = assert(io.popen "\\ls -1 | sort -V")
if not handle then error "Erro ao executar o comando." end
local result = handle:read "*a"
handle:close()

local filename = "list.txt"
local file = assert(io.open(filename, "w"))
if not file then error ("Erro ao abrir o arquivo %s para escrita."):format(filename) end

for linha in result:gmatch("[^\n]+") do file:write(("file '%s'\n"):format(linha)) end  -- Imprime diretamente a linha no formato 'file'

file:close()
print (("%s criado com sucesso."):format(filename))

x "ffmpeg -f concat -safe 0 -i list.txt -c:a flac output.flac"
x "ffmpeg -i output.flac -vn -ar 44100 -ac 2 -b:a 192k output.mp3"
