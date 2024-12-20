# SPDX-License-Identifier: GPL-2.0
# Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

def generate_str
	String.build do |io|
		io << "crystal build --release " << ARGV[0] << " -o ../" << ARGV[0].chomp(".cr")
	end
end

unless ARGV.empty?
	system generate_str
end
