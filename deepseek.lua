#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute

local container_name = "ollama" -- Define o nome do container que você quer verificar

local function podman_run()
	x "podman run -d --rm --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm" -- AMD
end

local function podman_exec()
	x("podman exec -it " .. container_name .. " bash -c \"ollama run deepseek-r1:7b\"")
end

-- O comando `docker inspect` tenta inspecionar o container.
-- O `x` retorna `true` se o comando for executado com sucesso (código 0) e `false` em caso de erro.
-- O redirecionamento de saída `&>/dev/null` é crucial para evitar que qualquer saída seja impressa no terminal.
local image_status = x("podman inspect " .. container_name .. " &>/dev/null")

if image_status then x("podman start " .. container_name) else podman_run() end

-- O comando `docker inspect` retorna `true` se o container está rodando e `false` caso contrário.
-- A saída de erro é redirecionada para `/dev/null` para evitar que a mensagem de erro
-- "no such object" apareça no console se o container não existir.
-- Abre um canal para ler a saída do comando
local container_status = require "util".getoutput_all("podman inspect -f '{{.State.Running}}' " ..
	container_name .. " 2>/dev/null")

-- A saída do `docker inspect` é uma string com quebra de linha no final.
-- A função `string.match` com `"%S+"` remove espaços em branco (whitespaces)
-- e captura a string "true" ou "false".
if container_status and container_status:match("%S+") == "true" then
	podman_exec()
else
	podman_run()
	podman_exec()
end
