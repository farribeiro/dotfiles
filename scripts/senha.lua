#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local tamanho = 12 -- Você pode alterar o tamanho aqui
local caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=<>?/{}[]|"
local senha = ""
math.randomseed(os.time()) -- Semente para números aleatórios
for _ = 1, tamanho do local i = math.random(1, #caracteres) senha = senha .. caracteres:sub(i, i) end
print("Senha gerada: " .. senha) -- Exibir a senha gerada
