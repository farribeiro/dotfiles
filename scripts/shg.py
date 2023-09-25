#!/usr/bin/python
# -*- coding: utf8 -*-

# (c) Fábio Rodrigues Ribeiro - http://farribeiro.blogspot.com

# Copying and distribution of this file, with or without modification, are permitted
# in any medium without royalty provided the copyright notice and this notice are
# preserved.  This file is offered as-is, without any warranty.

# Este script tem objetivo de simplificar os comandos do SSH
# Opções usadas no ssh
# -C Compactação
# -L ligacao em um host e porta atrás do SSH
# -N não executa comandos

import os
import sys

class shpy:
	# host = None
	# alvo = None
	# gateway = None

	porta_localhost = "5000"
	default_cmd = "sudo ssh -fCN"

	def dynamic_bridge(self, host):
		os.system(self.default_cmd+"D " + self.porta_localhost + " " + host)
		print "Configure seu navegador para usar sockets no endereço 127.0.0.1:" +self.porta_localhost

	def forward(self, gateway, alvo):
		# alvo = sys.argv[4] # sintaxe 0.0.0.0:0000
		os.system(self.default_cmd+"L "+ self.porta_localhost +":"+ alvo + " " + gateway)
		print "Apontar aplicativo para 127.0.0.1:"+self.porta_localhost

	# def reverse(self, host):
		# os.system(self.default_cmd+"R "+host)

	def kill(self):
		os.system("sudo killall ssh")
		print "Matando processo... ok"

	def rsync_cp(self, caminho_host, caminho):
		os.system("sudo rsync -avz "+ caminho +" -e ssh://"+caminho_host) # rsync -avz /home -e ssh://user@0.0.0.0:/path

	def argumentos(self):
		print "Faltando argumentos"

	def __init__(self):
		opcao = sys.argv[1]

		if(opcao == "dbg"):
			# if (sys.argv[1] or sys.argv[2] == None):
				# self.argumentos()
			# else:
			self.dynamic_bridge(sys.argv[2])
		elif(opcao == "frw"):
			self.forward(sys.argv[2], sys.argv[3])
		elif(opcao == "sh"):
			os.system("sudo ssh -C "+sys.argv[2])
		# elif(opcao == "rev"):
			# self.reverse(sys.argv[2])
		elif (opcao == "kill"):
			self.kill()
		elif (opcao == "cp"):
			self.rsync_cp(sys.argv[2], sys.argv[3])
		else:
			print "\
Sintaxe: shg.py [option] <host> \n\n\
Options:\n\
--------\n\
dbg\t\tDynamic bridge\n\
frw\t\tTuneling and forwarding\n\
kill\t\tKill the all ssh process\n\
Any option\tPrint this help\n\n\
Enjoy with the tool!"
#rev\t\tReverse tuneling\n\

s = shpy()
