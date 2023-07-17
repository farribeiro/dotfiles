#!/usr/bin/python

# (c) Fábio Rodrigues Ribeiro - http://farribeiro.blogspot.com

# Copying and distribution of this file, with or without modification, are
# permitted in any medium without royalty provided the copyright notice and this
# notice are preserved.  This file is offered as-is, without any warranty.

import os
import sys
import subprocess as sp

class sbrebase:

	def sbversion(self):
		return int(sp.getoutput("rpm -E %fedora"))

	def showhelp(self):
		print ("Options:\n\nreinstall:\n  reinstall removed dependencies\nchange:\n  change to next version of silverblue\ncleanall:\n  clean everting of rpm-ostree\npreview:\n  dry run of rpmostree upgrade\npin:\n  Pin the Ostree Deployment")

	def __init__(self):
		try:
			match sys.argv[1]:
				case "reinstall":
					os.system("rpm-ostree upgrade --install=flatpak-builder")
				case "cb":
					c = "ostree remote refs fedora | grep -E " + str(self.sbversion()+1) + " | grep -E x86_64/silverblue$"
					os.system(c)
				case "change":
					print("Syntax:\n\nrpm-ostree rebase fedora:fedora/",self.sbversion()+1,"/x86_64/silverblue")
					#--uninstall=rpmfusion-free-release-",self.__sbversion,"-1.noarch --uninstall=rpmfusion-nonfree-release-",self.__sbversion,"-1.noarch --install=https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-",self.__sbversion+1,".noarch.rpm --install=https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-",self.__sbversion+1,".noarch.rpm")
				case "cleanall":
					os.system("rpm-ostree cleanup -p -b -m")
				case "preview":
					os.system("rpm-ostree upgrade --preview")
				case "pin":
					os.system("sudo ostree admin pin 0")
				case "upg":
					os.system("rpm-ostree upgrade && flatpak update -y && toolbox run sudo dnf update -y")
				case "mesa-drm-freeworld":
					os.system("rpm-ostree override remove mesa-va-drivers --install=mesa-va-drivers-freeworld --install=mesa-vdpau-drivers-freeworld --install=ffmpeg")
				case "-h":
					self.showhelp()
				case _:
					self.showhelp()
		except ValueError:
			self.showhelp()

sb = sbrebase()

