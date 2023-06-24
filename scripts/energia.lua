-- Funções Utilitários
function lerNumero(mensagem)
	io.write(mensagem)
	return io.read("*number") or 0
end

function potencia(amp,volts)
	return amp * volts
end

function potencia4kwh(ptnc)
	return ptnc / 1000
end

function custo4hora()
	return KWh * preco
end

function custo4dia()
	return custo4hora() * horas4dia
end

function custo4mes()
	return custo4dia() * dias
end

function kwh4mes()
	return KWh * horas4dia * dias
end

function estimativas()
	io.write("\n**********ESTIMATIVAS GLOBAIS**********\n")
	io.write(KWh, "KWh x ", preco, "= R$ ", custo4hora(), "/hora\n")
	io.write("Custo de R$ ", custo4dia(), "/dia\n")
	io.write("Custo de R$ ", custo4mes(), "/mês (24x7)\n")
	io.write(KWh, " x ", horas4dia, " x ", dias, " = ", kwh4mes(), "kWh/mês\n")
	io.write("***************************************\n\n")
end

horas4dia = 24
dias = 30

preco = lerNumero("Preço(KWh): ")
ptnc = lerNumero("Potência(W): ")
horas4dia = lerNumero("Quantas horas por dias usa o equipamento (horas decimais): ")
dias = lerNumero("Quantos dias usa o equipamento: ")
-- try:
	-- amp = float(input("Amperes: "))
	-- volts = float(input("Voltagem: "))
	-- ptnc = self.potencia(amp,volts)
-- except ValueError:
KWh = potencia4kwh(ptnc)

estimativas()


io.write("\nCusto de R$ ", custo4hora() * horas4dia * dias)
