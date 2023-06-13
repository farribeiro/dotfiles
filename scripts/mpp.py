#!/usr/bin/python
# -*- coding: utf8 -*-

# (c) Fábio Rodrigues Ribeiro - http://farribeiro.blogspot.com

# Copying and distribution of this file, with or without modification, are permitted
# in any medium without royalty provided the copyright notice and this notice are 
# preserved.  This file is offered as-is, without any warranty.

# Este script faz a conversão de qualquer formato para DIVX da MSque é comum em players
# de mesa e automotivo, usando container AVI

import os
import sys

class mpplus:
	hd720 = "1280:720"
	sd480 = "720:480"
	hd480 = "854:480"

	def __init__(self):
		opcao = sys.argv[1]
		if (opcao == "dx"):
			self.divx()
		elif (opcao == "ass"):
			self.ass()
		elif (opcao == "dvd"):
			self.dvdnav()

	def converte(self, res):
		os.system("mencoder \"" + sys.argv[2] + "\" -oac mp3lame -lameopts cbr=128 -ovc " +
				"lavc -lavcopts vcodec=msmpeg4:vbitrate=1800:aspect=16/9 -ofps 23.976 -vf scale="
				+ res + " -o \"" + sys.argv[2][:-4] + "_divx.avi\"")
	
	def divx(self):
		print "Escolha a resolução"
		print "1 => SD480 (720x480)"
		print "2 => HD480 (854x480)"
		print "3 => HD720 (1280x720)"

		resolucao = raw_input("Opção: ")

		if (resolucao == "1"):
			self.converte(self.sd480)
		elif (resolucao == "2"):
			self.converte(self.hd480)
		elif (resolucao == "3"):
			self.converte(self.hd720)
		else:
			print "Opção inválida"

	def ass(self):
		os.system("mplayer -utf8 -ass -ass-font-scale 2 " + sys.argv[2])

	def dvdnav(self):
		os.system("mplayer -mouse-movements dvdnav://")

m = mpplus()
