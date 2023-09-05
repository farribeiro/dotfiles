-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

-- Funções Utilitários
function lerNumero(mensagem)
	io.write(mensagem)
	return io.read("*number") or 0
end

function fmt(valor)
	return ("%.2f"):format(valor)
end

-- Funções de calculo
function escrevecustodiames(tipo)
	io.write("Custo de R$ ")
	if tipo == "dia" then return io.write(fmt(custo4dia()), "/dia\n") end
	if tipo == "mes" then return io.write(fmt(custo4mes()), "/mês (24x7)\n") end
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

io.write("\n********** ESTIMATIVAS ***************\n")
io.write(fmt(KWh), "KWh x R$ ", fmt(preco), " = R$ ", fmt(custo4hora()), "/hora\n")
io.write(fmt(KWh), " x ", horas4dia, " x ", dias, " = ", fmt(kwh4mes()), "kWh/mês\n")
escrevecustodiames("dia")
escrevecustodiames("mes")
io.write("\n***************************************\n\n")

-- io.write("\n\n*** Custo ***\n")
io.write("Custo de R$ ", fmt(custo4hora() * horas4dia * dias), "\n")

io.write("\n")
