#!/usr/bin/python

# SPDX-License-Identifier: GPL-2.0
# Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

import os
import sys
import subprocess as sp

class sbrebase:

	def sbversion(self):
		return int(sp.getoutput("rpm -E %fedora"))

	def showhelp(self):
		print ("Options:\n\n",
			"reinstall:\n  reinstall removed dependencies\n",
			"change:\n  change to next version of silverblue\n",
			"cleanall:\n  clean everting of rpm-ostree\n",
			"preview:\n  dry run of rpmostree upgrade\n",
			"pin:\n  Pin the Ostree Deployment"
		)

	def __init__(self):
		try:
			match sys.argv[1]:
				case "reinstall":
					os.system("rpm-ostree upgrade --install=flatpak-builder")
				case "cb":
					c = "ostree remote refs fedora | grep -E " + str(self.sbversion()+1) + " | grep -E x86_64/silverblue$"
					os.system(c)
				case "upgsb":
					print("Syntax:\n\nrpm-ostree rebase fedora:fedora/",self.sbversion()+1,"/x86_64/silverblue")
					#--uninstall=rpmfusion-free-release-",self.__sbversion,"-1.noarch --uninstall=rpmfusion-nonfree-release-",self.__sbversion,"-1.noarch --install=https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-",self.__sbversion+1,".noarch.rpm --install=https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-",self.__sbversion+1,".noarch.rpm")
				case "cleanall":
					os.system("rpm-ostree cleanup -p -b -m")
				case "preview":
					os.system("rpm-ostree upgrade --preview")
				case "pin":
					os.system("sudo ostree admin pin 0")
				case "up":
					os.system("rpm-ostree upgrade && flatpak update -y && toolbox run sudo dnf update -y")
				case "mesa-drm-freeworld":
					os.system("rpm-ostree override remove mesa-va-drivers --install=mesa-va-drivers-freeworld --install=mesa-vdpau-drivers-freeworld --install=ffmpeg")
				case "in":
					c = "rpm-ostree upgrade --install=" + sys.argv[2]
					os.system(c)
				case "help":
					self.showhelp()
				case _:
					self.showhelp()
		except ValueError:
			self.showhelp()

sb = sbrebase()

