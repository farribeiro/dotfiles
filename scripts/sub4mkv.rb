#!~/jruby/jruby
# (c) Fábio Rodrigues Ribeiro - http://farribeiro.blogspot.com

# Copying and distribution of this file, with or without modification, are permitted
# in any medium without royalty provided the copyright notice and this notice are
# preserved.	This file is offered as-is, without any warranty.

#Este script junta o video e legenda externa no container MASTROSKA

class Sub4mkv
	def initialize
		@vin = ARGV[0]
		@vout = ARGV[1]
		system "mkvmerge -o "+@vout.to_s+" "+@vin.to_s+" --language 0:por "+ @vin.chomp(".mkv").to_s+".sub"
	end
end

s = Sub4mkv.new
