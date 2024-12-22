bits = 1024
bitsinbyte = 8

function lerTamanho(mensagem)
	io.write(mensagem)
	return io.read("*line")
end

local function changebits2bytes(size) return size / bitsinbyte end
local function changebytes2bits(size) return size * bitsinbyte end
local function increase_bits(size) return size * bits end
local function decresase_bits(size) return size / bits end
local function tombits(size) return increase_bits(size) end
local function tokbits(size) return tombits(size) * 10 end
local function tombytes(size) return changebits2bytes(tombits(size)) end
local function togbytes(size) return changebits2bytes(size) end

line = lerTamanho("Entre com o tamanho da internet: ")
number, option = line:gsub("[%a]", ""), line:gsub("[^%a]", "")

if option == "G" then
	io.write("Tamanho da banda é ", tombits(number), " Megabits\n")
	io.write("Tamanho da banda é ", tokbits(number), " Kilobits\n")
	io.write("Taxa de download é ", tombytes(number), " Megabytes")
elseif option == "M" then
	io.write("Tamanho da banda é ", tokbits(number), " Kilobits")
end

io.write("\n")
