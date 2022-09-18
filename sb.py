#!/usr/bin/python
import os
import sys
import subprocess as sp

class sbrebase:

	__sbversion = int(sp.getoutput("rpm -E %fedora"))	

	def showhelp(self):
		print ("Options:\n\nreinstall:\n  reinstall removed dependencies\nchange:\n  change to next version of silverblue\ncleanall:\n  clean everting of rpm-ostree\npreview:\n  dry run of rpmostree upgrade\npin:\n  Pin the Ostree Deployment")


	def __init__(self):
		try:
			match sys.argv[1]:	
				case "reinstall":
					os.system("rpm-ostree upgrade --install=akmod-nvidia-470xx --install=xorg-x11-drv-nvidia-470xx --install=xorg-x11-drv-nvidia-470xx-power --install=nvidia-settings-470xx --install=rtl88x2bu-kmod --install=flatpak-builder")
				case "change":
					os.system("rpm-ostree rebase fedora:fedora/",self.__sbversion+1,"/x86_64/silverblue --uninstall=rpmfusion-free-release-",self.__sbversion,"-1.noarch --uninstall=rpmfusion-nonfree-release-",self.__sbversion,"-1.noarch --install=https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-",self.__sbversion+1,".noarch.rpm --install=https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-",self.__sbversion+1,".noarch.rpm")
				case "cleanall":
					os.system("rpm-ostree cleanup -p -b -m")
				case "preview":
					os.system("rpm-ostree upgrade --preview")
				case "pin":
					os.system("sudo ostree admin pin 0")
				case "upg":
					os.system("rpm-ostree upgrade && flatpak update -y && toolbox run sudo dnf update -y")
				case "-h":
					self.showhelp()
				case _:
					self.showhelp()
		except ValueError:
			self.showhelp()

sb = sbrebase()

