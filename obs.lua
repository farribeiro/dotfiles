#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local input_file = "entrada.md"
local output_file = "rascunho.md"

-- Função para abrir um arquivo, realizar a substituição e gravar o conteúdo modificado em um novo arquivo
local function open_replace(pattern, new_pattern)
  local f = assert(io.open(input_file, "r")) -- Abre o arquivo de entrada para leitura
  local md = f:read("*all") -- Lê todo o conteúdo do arquivo
  f:close() -- Fecha o arquivo de entrada

  f = assert(io.open(output_file, "w")) -- Abre o arquivo de saída para escrita
  f:write(md:gsub(pattern, new_pattern)) -- Escreve o conteúdo modificado no arquivo de saída -- Aplica a substituição
  f:close() -- Fecha o arquivo de saída
end

handlers ={
  ["dots"] = function() open_replace("%.%.%.", "…") end -- Função para substituir os pontos suspensivos por um caractere especial. (... por … )
}


if not arg or #arg == 0 then os.exit(1) end
handlers[arg[1]]()
print(([[Resultado gravado em "%s".]]):format(output_file))
