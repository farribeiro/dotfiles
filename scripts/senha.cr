# SPDX-License-Identifier: GPL-2.0
# Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

class Password
	def generate
		print "Entre com o tamanho da senha: "
		len = gets.to_s.to_i # Tamanho da senha - Você pode alterar o tamanho aqui

		chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+=<>?/{}[]|" # Conjunto de caracteres
		pass = "" # Inicializando a senha

		# Gerando a senha
		pass = String.build(len) do |io|
			len.times do io.write_byte chars.to_slice.sample random: Random::Secure end
		end

		puts "Senha gerada: #{pass}" # Exibir a senha gerada
	end

	def initialize
		#unless ARGV.empty?
			generate
		#end
	end
end

p = Password.new
