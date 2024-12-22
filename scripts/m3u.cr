class M3u
	def initialize
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
	end
end

m3u = M3u.new
