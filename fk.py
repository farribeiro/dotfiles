#!/usr/bin/python

# SPDX-License-Identifier: GPL-2.0
# Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

import os
import sys
import subprocess as sp

class Fk:
	def n_runtimes(self): self.__n_runtimes = int(sp.getoutput("flatpak list --app --columns=runtime | sort | uniq -c | sort -n | wc -l"))
	def n_apps(self): self.__n_apps = int(sp.getoutput("flatpak list --app --columns=name | sort | uniq -c | sort -n | wc -l"))
	def n_sdks(self): self.__n_sdks = int(sp.getoutput("flatpak list | sort | uniq -c | grep -E \"[Ss][Dd][Kk]\" | sort -n | wc -l"))
	def show_napps(self): self.n_apps();print("Numbers of applications: ", self.__n_apps)
	def show_nruntimes(self): self.n_runtimes();print("Numbers of runtimes: ", self.__n_runtimes)
	def show_nsdks(self): self.n_sdks();print("Numbers of Sdks: ", self.__n_sdks)
	def list_runtime(self): return sp.getoutput("flatpak list --app --columns=runtime | sort | uniq -c | sort -n")
	def list_apps(self): return sp.getoutput("flatpak list --app --columns=name | sort | uniq -c | sort -n | sed \"s/1/-/\"")
	def list_sdk(self): return sp.getoutput("flatpak list | sort | uniq -c | grep -E \"[Ss][Dd][Kk]\" | sort -n") # | sed \"s/\d\d?/-/\"")
	def size_runtimes(self): return sp.getoutput("cd /var/lib/flatpak/runtime; flatpak list --app --columns=runtime | sort | uniq | xargs du -sh --total")
	def export(self): os.system("flatpak list --app --columns=application > ~/flatpak-list-bk.txt")
	def remove_fedora(self): self.export();self.exp_list = sp.getoutput("cat ~/flatpak-list-bk.txt | xargs");c = "flatpak remove -y " + list;os.system(c)
	def n_things(self): self.n_runtimes();self.n_apps();self.n_sdks();self.show_napps();self.show_nruntimes();self.show_nsdks()
	def __init__(self):
		match sys.argv[1]:
			case "exp": self.export()
			case "remove-fedora": self.remove_fedora()
			case "repair": os.system("flatpak repair --user && sudo flatpak repair")
			case "cleanall": os.system("flatpak remove --unused --delete-data")
			case "up": os.system("flatpak update")
			case "fup": os.system("flatpak update --no-static-deltas")
			case "n-things": self.n_things()
			case "list-runtimes": self.show_nruntimes();print("Runtimes installed:\n");print(self.size_runtimes())
			case "list-apps": self.show_napps();print("Apps installed:\n");print(self.list_apps())
			case "b": c = "flatpak run org.flatpak.Builder --install --user --force-clean build-dir " + sys.argv[2];os.system(c)
			case "in": c = "flatpak install flathub " + sys.argv[2];os.system(c)
			case "pg": c = "flatpak remove --delete-data " + sys.argv[2];os.system(c)
			case "convert-flathub": self.remove_fedora();c = "flatpak install flathub --system -y " + self.exp_list;os.system(c)
			case "info": c = "flatpak info " + self.getfqdn(sys.argv[2]);os.system(c)
			case "run": c = "flatpak run " + self.getfqdn(sys.argv[2]);os.system(c)

f = Fk()
