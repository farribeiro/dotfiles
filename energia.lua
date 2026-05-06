-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2026 - Fábio Rodrigues Ribeiro and contributors

local horas4dia = 24
local dias = 30
function ler(mensagem)
	io.write(mensagem)
	return io.read("*number") or 0
end

local function fmt(_) return ("%.2f"):format(_) end
local function escrevecustodiames(tipo) -- Funções de calculo
	io.write("Custo de R$ " ..
		(tipo == "dia" and fmt(custo4dia()) .. "/dia" or fmt(custo4mes()) .. "/mês") .. "\n")
end

-- local function potencia(amp, volts) return amp * volts end
local function potencia4kwh(_) return _ / 1000 end
local function custo4hora() return KWh * preco end
function custo4dia() return custo4hora() * horas4dia end

function custo4mes() return custo4dia() * dias end

local function kwh4mes() return KWh * horas4dia * dias end
preco = ler "Preço(KWh): "
ptnc = ler "Potência(W): "
horas4dia = ler("Quantas horas por dias usa o equipamento (horas decimais): ")
-- dias = ler("Quantos dias usa o equipamento: ")
-- try:
-- amp = float(input("Amperes: "))
-- volts = float(input("Voltagem: "))
-- ptnc = self.potencia(amp,volts)
-- except ValueError:
KWh = potencia4kwh(ptnc)
io.write "\n*** ESTIMATIVAS ***\n"
io.write(fmt(KWh), "KWh x R$ ", fmt(preco), " = R$ ", fmt(custo4hora()), "/hora\n")
io.write(fmt(KWh), " x ", horas4dia, " x ", dias, " = ", fmt(kwh4mes()), "kWh/mês\n")
escrevecustodiames "dia"
escrevecustodiames "mes"
io.write(("*"):rep(20) .. "\n\n")
--[[
io.write("\n\n* Custo *\n")
io.write("Custo de R$ ", fmt(custo4hora() * horas4dia * dias), "\n")
io.write("\n")
]] --
