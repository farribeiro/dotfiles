#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local input_file = "entrada.md"
local output_file = "rascunho.md"
local patterns = {}

-- Abrir um arquivo, realizar a substituição e gravar o conteúdo modificado em um novo arquivo
local function open_replace()
	local f = assert(io.open(input_file, "r")) -- Abre o arquivo de entrada para leitura
	local md = f:read "*all" -- Lê todo o conteúdo do arquivo
	f:close() -- Fecha o arquivo de entrada

	os.execute(("rm -rf %s"):format(output_file))
	f = assert(io.open(output_file, "w")) -- Abre o arquivo de saída para escrita
	for i, item in ipairs(patterns) do
		md = md:gsub(item[1], item[2]) -- Escreve o conteúdo modificado no arquivo de saída -- Aplica a substituição
	end

	f:write(md)
	f:close() -- Fecha o arquivo de saída
end

local function add_patterns(s, r) table.insert(patterns, {s, r}) end
local function espaco() add_patterns(" ", " ") end -- Espaços alienigenas por espaços simples.
local function dash() add_patterns("%-%-", "–") end -- Dois menos por dash. ( -- por – )
local function trave() add_patterns("%-%-%-", "—") end -- Três menos por travessão. ( --- por — )
local function dots() add_patterns("%.%.%.", "…") end -- Pontos suspensivos por um caractere especial. (... por … )

local handlers ={
	["espaco"] = espaco,
	["dash"] = dash,
	["trave"] = trave,
	["dots"] = dots,
	-- ["run"] = function() os.execute "flatpak run nz.mega.MEGAsync & flatpak run md.obsidian.Obsidian & disown" end,
	["all"] = function() dots() trave() dash() espaco() end
}

if not arg or #arg == 0 then arg[1] = "all" end
handlers[arg[1]]()
open_replace()
print(([[Resultado gravado em "%s".]]):format(output_file))
