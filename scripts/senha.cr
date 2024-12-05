# SPDX-License-Identifier: GPL-2.0
# Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

tamanho = 12 # Tamanho da senha - Você pode alterar o tamanho aqui
chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=<>?/{}[]|" # Conjunto de caracteres
senha = "" # Inicializando a senha

# Gerando a senha
senha = String.build(tamanho) do |io|
	tamanho.times do io.write_byte chars.to_slice.sample random: Random::Secure end
end

puts "Senha gerada: #{senha}" # Exibir a senha gerada
