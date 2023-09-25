#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

function sbversion()
	return tonumber(getoutput("rpm -E %fedora"))
end

function getoutput(command)
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	return result
end

handlers = {
-- ["reinstall"] = function() os.execute("rpm-ostree upgrade --install=flatpak-builder") end

	["cb"] = function()
		os.execute(("ostree remote refs fedora | grep -E %d | grep -E x86_64/silverblue$"):format(sbversion()+1))
	end,

	["nextsb"] = function()
		os.execute(("rpm-ostree rebase fedora:fedora/%d/x86_64/testing/silverblue"):format(sbversion()+1))
		--uninstall=rpmfusion-free-release-",self.__sbversion,"-1.noarch --uninstall=rpmfusion-nonfree-release-",self.__sbversion,"-1.noarch --install=https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-",self.__sbversion+1,".noarch.rpm --install=https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-",self.__sbversion+1,".noarch.rpm")
	end,
	
	["cleanall"] = function()
		os.execute("rpm-ostree cleanup -p -b -m")
	end,

	["preview"] = function()
		os.execute("rpm-ostree upgrade --preview")
	end,

	["pin"] = function()
		os.execute("sudo ostree admin pin 0")
	end,

	["up"] = function()
		io.write (("Versão do kernel: %s\n"):format(getoutput("uname -r")))
		os.execute("rpm-ostree upgrade && flatpak update -y && toolbox run sudo dnf update -y")
	end,

	["mesa-drm-freeworld"] = function()
		os.execute("rpm-ostree override remove mesa-va-drivers --install=mesa-va-drivers-freeworld --install=mesa-vdpau-drivers-freeworld --install=ffmpeg")
	end,

	["in"] = function()
		os.execute(("rpm-ostree upgrade --install=%s"):format(arg[2]))
	end,

	["ostree-unpinall"] = function()
		for i = 2, 5 do
			os.execute(("sudo ostree admin pin --unpin %d"):format(i))
		end
	end,

	["lc"] = function()
		os.execute("rpm-ostree db diff")
	end,

	["help"] = function()
		io.write([[
Options:

cb:
  check new branch
nextsb:
  upgrade to next version of silverblue
up:
  upgrade the role system to latest commit
cleanall:
  clean everting of rpm-ostree
preview:
  dry run of rpmostree upgrade
pin:
  Pin the Ostree Deployment
mesa-drm-freeworld:
  Install RPMFusion's mesa-drm freeworld (need configure rpmfusion repo)
search-inrpm:
  Search for installed package
can:
  Cancel transaction
lc:
  Show last changes in rpm-ostree
]]
		)
	end
}

-- Extra functions
-- handlers["checkbranch"] = handlers['cb']

if not arg or #arg == 0 then
	handlers["help"]()
	os.exit(1)
else
	handlers[arg[1]]()
end
