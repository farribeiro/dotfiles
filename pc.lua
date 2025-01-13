#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

x = os.execute
local s = require "sai"

local function limpa()
	x "rm -rf list.txt output.flac output.mp3 *.mp3"
end

local function arquivos()
	local handle = assert(io.popen "\\ls -1 | sort -V")
	if not handle then error "Erro ao executar o comando." end
	local result = handle:read "*a"
	handle:close()
	return result
end

local function gera_lista(result)
	local filename = "list.txt"
	local file = assert(io.open(filename, "w"))
	if not file then error ("Erro ao abrir o arquivo %s para escrita."):format(filename) end
	for linha in result:gmatch("[^\n]+") do file:write(("file '%s'\n"):format(linha)) end  -- Imprime diretamente a linha no formato 'file'
	file:close()
	print (("%s criado com sucesso."):format(filename))
end

local function ind_mp3(result)
	for linha in result:gmatch("[^\n]+") do x (("ffmpeg -i '%s' -vn -ar 44100 -ac 2 -b:a 192k '%s'"):format(linha, linha:gsub("%.flac", ".mp3"))) end -- Converte arquivos flac para mp3
end

local function podcast_flac()
	limpa()
	gera_lista(arquivos())
	x "ffmpeg -f concat -safe 0 -i list.txt -c:a flac output.flac"
end

local function podcast_mp3()
	local cmd = "ffmpeg -i output.flac -vn -ar 44100 -ac 2 -b:a 192k output.mp3"
	limpa()
	local file = io.open("output.flac", "r")
	if file then
		file.close()
		x(cmd)
	else
		podcast_flac()
		x(cmd)
	end
end

handlers ={
	limpa = limpa,
	["ind_mp3"] = function ()
		limpa()
		ind_mp3(arquivos())
	end,
	podcast_flac = podcast_flac,
	podcast_mp3 = podcast_mp3,
	["all"] = function ()
		local result = arquivos()
		limpa()
		gera_lista(result)
		ind_mp3(result)
		podcast_flac()
		podcast_mp3()
	end
}

s.ca_none()
handlers[arg[1]]()
