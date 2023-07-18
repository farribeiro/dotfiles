#!/usr/bin/lua

-- (c) Fábio Rodrigues Ribeiro - http://farribeiro.blogspot.com

-- Copying and distribution of this file, with or without modification, are
-- permitted in any medium without royalty provided the copyright notice and this
-- notice are preserved.  This file is offered as-is, without any warranty.

function sbversion()
	local handle = io.popen("rpm -E %fedora")
	local result = handle:read("*a")
	handle:close()
	return tonumber(result)
end

handlers = {
-- ["reinstall"] = function() os.execute("rpm-ostree upgrade --install=flatpak-builder") end

	["cb"] = function()
		os.execute(("ostree remote refs fedora | grep -E %d | grep -E x86_64/silverblue$"):format(sbversion()+1))
	end,

	["upgsb"] = function()
		os.execute(("rpm-ostree rebase fedora:fedora/%d/x86_64/silverblue"):format(sbversion()+1))
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
		os.execute("rpm-ostree upgrade && flatpak update -y && toolbox run sudo dnf update -y")
	end,

	["mesa-drm-freeworld"] = function()
		os.execute("rpm-ostree override remove mesa-va-drivers --install=mesa-va-drivers-freeworld --install=mesa-vdpau-drivers-freeworld --install=ffmpeg")
	end,

	["in"] = function()
		os.execute(("rpm-ostree upgrade --install=%s"):format(arg[2]))
	end,

	["help"] = function()
		io.write("Options:\n\n",
			"reinstall:\n  reinstall removed dependencies\n",
			"change:\n  change to next version of silverblue\n",
			"cleanall:\n  clean everting of rpm-ostree\n",
			"preview:\n  dry run of rpmostree upgrade\n",
			"pin:\n  Pin the Ostree Deployment\n"
		)
	end
}

if not arg or #arg == 0 then
	handlers["help"]()
	os.exit(1)
end

handlers[arg[1]]()
