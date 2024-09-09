#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local function createlist()
	local handle = io.popen("\\ls -1")
	local result = handle:read "*a"
	handle:close()

	local filename = "list.txt"
	local file = assert(io.open(filename, "w"))
	if not file then error "Erro ao abrir o arquivo world.mt para escrita." end

	print (result)
	for linha in string.gmatch(result, "[^\n]+") do file:write(("file '%s'\n"):format(linha)) end  -- Imprime diretamente a linha no formato 'file'

	file:close()
	print (("%s criado com sucesso."):format(filename))
end


createlist()
os.execute("ffmpeg -f concat -safe 0 -i list.txt -c copy output.mp3")
