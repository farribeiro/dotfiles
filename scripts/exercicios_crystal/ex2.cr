class Anfitriao
	def initialize(nome = "Mundo")
		@nome = nome.capitalize

		if ARGV[0] == "ola"
			diz_ola
		elsif ARGV[0] == "adeus"
			diz_adeus
		else
			puts "..."
		end
	end

	def diz_ola
		puts "Olá, #{@nome}!"
	end

	def diz_adeus
		puts "Adeus, #{@nome}, volte sempre!"
	end
end

Anfitriao.new(ARGV[1])
