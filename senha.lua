#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

-- Função para obter bytes seguros do /dev/urandom
local function secure_random_bytes(n)
	local f = assert(io.open("/dev/urandom", "rb"))
	local bytes = f:read(n)
	f:close()
	return bytes
end

io.write "Entre com o tamanho da senha: "
local tamanho = io.read ("*number") -- Você pode alterar o tamanho aqui
local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=<>?/{}[]|"
local senha = ""
local random_bytes = secure_random_bytes(tamanho) -- Gera bytes aleatórios

-- Converte cada byte em um índice para a tabela de caracteres
for i = 1, tamanho do
	local byte = random_bytes:byte(i) -- Obtém o valor do byte como índice (convertendo para o intervalo 1..#chars)
	local index = (byte % #chars) + 1
	senha = senha .. chars:sub(index, index)
end

print("Senha gerada: " .. senha) -- Exibir a senha gerada
