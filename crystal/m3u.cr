require "option_parser"

parser = OptionParser.new do |parser|
	parser.banner = "Uso: seu_programa [opções] <nome_do_arquivo> <conteúdo_m3u>"
end

# Analisa os argumentos da linha de comando
#parser.parse!

# Verifica se os argumentos essenciais estão presentes
if ARGV.size < 2
	puts parser
	exit
end

unless ARGV.empty?
	filename = String.build(2) do |io|
		io << ARGV[0] << ".m3u"
	end

	File.open(filename, "w") do |file| # Abre o arquivo no modo "write" (escrita), criando-o se não existir
		file.puts "#EXTM3U"
		file.puts ARGV[1]
		file.puts
	end
	puts "#{filename} gravado com sucesso!"
end
