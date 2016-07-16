#!/usr/bin/python
# -*- coding: utf-8 -*-

# Calculadora de energia
# ======================
# Esta calculadora é uma reimplementação com objetivo de
# aprimorar um script bash

# (c) Fábio Rodrigues Ribeiro - http://farribeiro.blogspot.com

# Copying and distribution of this file, with or without modification, are permitted
# in any medium without royalty provided the copyright notice and this notice are
# preserved.  This file is offered as-is, without any warranty.

import os

class energia:
	__horas4dia = 24.0
	__dias = 30.0

	def potencia(self,amp,volts):
		return amp * volts

	def potencia4kwh(self,ptnc):
		return ptnc / 1000

	def custo4hora(self):
		return self.__KWh * self.__preco

	def custo4dia(self):
		return self.custo4hora() * self.__horas4dia

	def custo4mes(self):
		return self.custo4dia() * self.__dias

	def kwh4mes(self):
		return self.__KWh * self.__horas4dia * self.__dias
	def __init__(self):
		# amp  = raw_input("Amperes: ")
		# volts = raw_input("Voltagem: ")
		# ptnc = self.potencia(amp,volts)
		ptnc = raw_input("Digite a Potencia(W): ")
		KW = float(ptnc) / 1000;

		preco = raw_input ("Digite o preço(KW): ")

		horas4dia = float(raw_input("Quantas horas por dias usa o equipamento: "))
		dias = float(raw_input("Quantos dias usa o equipamento: "))

		preco_final = self.custo4hora() * horas4dia * dias
		print "\nO gasto é de R$ %.2f" % preco_final

g = energia();
