bits = 1024
bitsinbyte = 8

function lerTamanho(mensagem)
	io.write(mensagem)
	return io.read("*line")
end

function changebits2bytes(size)
	return size / bitsinbyte
end

function changebytes2bits(size)
	return size * bitsinbyte
end

function increase_bits(size)
	return size * bits
end

function decresase_bits(size)
	return size / bits
end

function tombits(size)
	return increase_bits(size)
end

function tokbits(size)
	return tombits(size) / 10
end

function tombytes(size)
	return changebits2bytes(tombits(size))
end

function togbytes(size)
	return changebits2bytes(size)
end

line = lerTamanho("Entre com o tamanho da internet: ")
number = line:gsub("%D", "")
option = line:gsub("[^%a]", "")

if option == "G" then
	io.write("Tamanho da banda é ", tombits(number), " Megabits\n")
	io.write("Tamanho da banda é ", tokbits(number), " Kilobits\n")
	io.write("Taxa de download é ", tombytes(number), " Megabytes")
elseif option == "M" then
	io.write("Tamanho da banda é ", tokbits(number), " Kilobits")
end

io.write("\n")
