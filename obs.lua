#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local input_file = "entrada.md"
local output_file = "rascunho.md"
local patterns = {}

-- Função para abrir um arquivo, realizar a substituição e gravar o conteúdo modificado em um novo arquivo
local function open_replace()
	local f = assert(io.open(input_file, "r")) -- Abre o arquivo de entrada para leitura
	local md = f:read("*all") -- Lê todo o conteúdo do arquivo
	f:close() -- Fecha o arquivo de entrada

	os.execute(("rm -rf %s"):format(output_file))
	f = assert(io.open(output_file, "w")) -- Abre o arquivo de saída para escrita
	for i, item in ipairs(patterns) do
		md = md:gsub(item[1], item[2]) -- Escreve o conteúdo modificado no arquivo de saída -- Aplica a substituição
	end

	f:write(md)
	f:close() -- Fecha o arquivo de saída
end

local function add_patterns(p)
	table.insert(patterns, p)
end

handlers ={
	["all"] = function()
		add_patterns({"%.%.%.", "…"})
		add_patterns({" ", " "})
		open_replace()
	end,
	["dots"] = function() add_patterns({"%.%.%.", "…"}) open_replace() end -- Função para substituir os pontos suspensivos por um caractere especial. (... por … )
}


if not arg or #arg == 0 then os.exit(1) end
handlers[arg[1]]()
print(([[Resultado gravado em "%s".]]):format(output_file))
