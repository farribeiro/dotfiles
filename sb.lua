#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute

local function getoutput(command)
	local handle = io.popen(command)
	local result = handle:read "*a"
	handle:close()
	return result
end

local function sbversion() return getoutput "rpm -E %fedora" end
local function arch() return getoutput("uname -m"):gsub("[\n\r]", "") end
local function kv () io.write (("Versão do kernel: %s"):format(getoutput "uname -r" )) end
local function rebasesb(plus) x(("dnf rebase fedora:fedora/%d/%s/testing/silverblue"):format(sbversion()+plus, arch())) end

function open_override()
	local pct = {}
	local file = assert(io.open("override.txt", "r"))
	for line in file:lines() do pct = table.insert(pct, line) end
	file:close()
	return table.concat(pct, " ")
end

local function lastdeploy ()
	local output = getoutput "cat /etc/os-release"
	io.write(("Data do último deploy: %s"):format(output:match "VERSION=\"(.-)\"" ))
end

local function rpmostree_upgrade(opts) kv() lastdeploy() io.write "\n\n" x(("dnf cancel && dnf upgrade %s"):format(opts)) end

local handlers = {
	-- ["reinstall"] = function() x "dnf upgrade --install=flatpak-builder" end
	-- ["mesa-drm-freeworld"] = function() x "dnf override remove mesa-va-drivers --install=mesa-va-drivers-freeworld --install=mesa-vdpau-drivers-freeworld --install=ffmpeg" end,
	-- --uninstall=rpmfusion-free-release-",self.__sbversion,"-1.noarch --uninstall=rpmfusion-nonfree-release-",self.__sbversion,"-1.noarch --install=https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-",self.__sbversion+1,".noarch.rpm --install=https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-",self.__sbversion+1,".noarch.rpm")
	["cb"] = function() x(("ostree remote refs fedora | grep -E %d | grep -E \"%s/silverblue$\""):format(sbversion()+1, arch())) end,
	["testsb"] = function() rebasesb(0) end,
	["nexttest"] = function() rebasesb(1) end,
	["clean"] = function() x "sudo -s <<< \"dnf cleanup -p -b -m && ostree admin cleanup\" && toolbox run dnf clean all" end,
	["preview"] = function() x "dnf upgrade --preview" end,
	["pin"] = function() x "sudo ostree admin pin 0" end,
	["in"] = function() x(("dnf upgrade --install=%s"):format(arg[2])) end,
	["search"] = function() x(("dnf search %s"):format(arg[2])) end,
	["search-inrpm"] = function() x(("rpm -qa | grep -E %s"):format(arg[2])) end,
	["lc"] = function() x "dnf db diff" end,
	["lastdeploy"] = function () lastdeploy() io.write "\n" end,
	-- ["c-up"] = function() handlers["clean"]() handlers["up"]() end, Funciona mas precisa fazer funções fora da tabela
	["up"] = function() rpmostree_upgrade "&& flatpak update -y" end,-- && toolbox run sudo dnf5 update -y")
	["up-r"] = function() rpmostree_upgrade "-r" end, -- && flatpak update -y" && toolbox run sudo dnf5 update -y")
	["bulk-override-replace"] = function () print(("dnf override replace%s"):format(open_override())) end,
	["dnf"] = function()
		local opts = ""
		for i = 2, #arg do opts = ("%s %s"):format(opts, arg[i]) end
		print(("dnf cancel && dnf%s"):format(opts))
	end,
	["ostree-unpinall"] = function()
		for i = 2, 5 do x(("sudo ostree admin pin --unpin %d"):format(i)) end
	end,

	["help"] = function()
		io.write
[[
Options:

cb:
  Check new branch
testsb:
  Rebase to testing branch
nt, nexttest:
  Upgrade to next version of silverblue
up:
  Upgrade the role system to latest commit
up-r:
  Upgrade the role system to latest commit and reboot
in:
  Install a layered package
c, clean:
  Cleanup ostree based metadatas and cache
c-up:
  Cleanup ostree based metadatas, cache and upgrade the role system to latest commit
pw, preview:
  Dry-run of rpmostree upgrade
pin:
  Pin the Ostree Deployment
mesa-drm-freeworld:
  Install RPMFusion's mesa-drm freeworld (need configure rpmfusion repo)
search-inrpm:
  Search for installed package
s, search:
  Search for package
lc:
  Show last changes in dnf
ld, lastdeploy:
  Show the last deploy in Silverblue
oua, ostree-unpinall:
  Unpin all pinned commits

]]
	end
}

-- Extra functions
-- handlers['cb'] = handlers["check-branch"]
handlers["oua"] = handlers["ostree-unpinall"]
handlers["c"] = handlers["clean"]
handlers["s"] = handlers["search"]
handlers["pw"] = handlers["preview"]
handlers["nt"] = handlers["nexttest"]
handlers["ld"] = handlers["lastdeploy"]

if not arg or #arg == 0 then handlers["help"]() os.exit(1) end 
handlers[arg[1]]()
