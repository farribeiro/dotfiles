# (c) Fábio Rodrigues Ribeiro - http://farribeiro.blogspot.com

# Copying and distribution of this file, with or without modification, are permitted
# in any medium without royalty provided the copyright notice and this notice are
# preserved.	This file is offered as-is, without any warranty.

#Este script junta o video e legenda externa no container MASTROSKA

def generate_str
	String.build(7) do |io| # omitido return
		io << "mkvmerge -o " << ARGV[1] << " " << ARGV[0] << " --language 0:por " << ARGV[0].chomp(".mkv") << ".sub"
	end
end

unless ARGV.empty? || ARGV[1].empty?
	puts generate_str
end
