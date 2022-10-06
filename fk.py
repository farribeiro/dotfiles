#!/usr/bin/python

# (c) Fábio Rodrigues Ribeiro - http://farribeiro.blogspot.com

# Copying and distribution of this file, with or without modification, are
# permitted in any medium without royalty provided the copyright notice and this
# notice are preserved.  This file is offered as-is, without any warranty.

import os
import sys
import subprocess as sp
import argparse

class Fk:
	def n_runtimes(self):
		self.__n_runtimes = int(sp.getoutput("flatpak list --app --columns=runtime | sort | uniq -c | sort -n | wc -l"))
	
	def n_apps(self):
		self.__n_apps = int(sp.getoutput("flatpak list --app --columns=name | sort | uniq -c | sort -n | wc -l"))

	def n_things(self):
		self.n_runtimes()
		self.n_apps()
		self.show_napps()
		self.show_nruntimes()
	
	def show_napps(self):
		self.n_apps()
		print ("Numbers of applications: ", self.__n_apps)
		
	def show_nruntimes(self):
		self.n_runtimes()
		print ("Numbers of runtimes: ", self.__n_runtimes)

	def list_runtime (self):
		return sp.getoutput("flatpak list --app --columns=runtime | sort | uniq -c | sort -n")

	def list_apps (self):
		return sp.getoutput("flatpak list --app --columns=name | sort | uniq -c | sort -n")

	def size_runtimes (self):
		return sp.getoutput("cd /var/lib/flatpak/runtime; flatpak list --app --columns=runtime | sort | uniq | xargs du -sh --total")

	def __init__ (self):
		match sys.argv[1]:
			case "n-things":
				self.n_things()
			case "list-runtimes":
				self.show_nruntimes()
				print ("Runtimes installed:\n")
				print (self.list_runtime())
			case "list-apps":
				self.show_napps()
				print ("Apps installed:\n")
				print (self.list_apps())
			case "repair":
				os.system("flatpak repair --user && flatpak repair")
			case "cleanall":
				os.system("flatpak remove --unused --delete-data")

f = Fk()
