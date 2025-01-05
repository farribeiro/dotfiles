#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

x = os.execute
local u = require "util"
local s = require "sai"
local ro = "rpm-ostree"
local roc = ("%s cancel && "):format(ro)

local function kv () io.write (("Versão do kernel: %s\n"):format(u.getoutput "uname -r" )) end
local function lastdeploy () io.write(("Data do último deploy: %s\n"):format(u.openfile_match("/etc/os-release",[[VERSION="(.-)"]]))) end
local function rebasesb(plus,testing) x(("%s rebase fedora:fedora/%d/%s%s/silverblue"):format(ro,u.sbversion()+plus,u.arch(),testing)) end
local function pin() u.writemsg_x("sudo ostree admin pin 0","\n*** Pinning: \n") end

--[[
function open_override()
	local pct = {}
	local file = assert(io.open("override.txt","r"))
	for line in file:lines() do pct = table.insert(pct,line) end
	file:close()
	return table.concat(pct," ")
end
]]--

local function rpmostree_upgrade(opts)
	kv() lastdeploy() io.write "\n"
	if os.getenv("DESKTOP_SESSION") == "gnome" then u.x_writemsg("gnome-software --quit","*** Parado gnome-software ***\n\n") end
	x(("%s %s upgrade %s"):format(roc,ro,opts))
end

local function up()
	rpmostree_upgrade ""
	u.x_writemsg("flatpak update -y","\n*** Termiado atualizar flatpak ***\n*** Atualizando toolbox ***\n")
	u.x_writemsg("toolbox run sudo dnf update -y", "\n*** Termiado atualizar toolbox ***\n\n")
end

local function clean() x(("sudo -s <<< \"%s cleanup -b -m && ostree admin cleanup\" && toolbox run dnf clean all"):format(ro)) end

local handlers = {
	-- ["reinstall"] = function() x "rpm-ostree upgrade --install=flatpak-builder" end
	-- ["mesa-drm-freeworld"] = function() x "rpm-ostree override remove mesa-va-drivers --install=mesa-va-drivers-freeworld --install=mesa-vdpau-drivers-freeworld --install=ffmpeg" end,
	-- --uninstall=rpmfusion-free-release-",self.__sbversion,"-1.noarch --uninstall=rpmfusion-nonfree-release-",self.__sbversion,"-1.noarch --install=https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-",self.__sbversion+1,".noarch.rpm --install=https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-",self.__sbversion+1,".noarch.rpm")
	-- ["bulk-override-replace"] = function() print(("rpm-ostree override replace%s"):format(open_override())) end,
	-- ["preview"] = function() x "rpm-ostree upgrade --preview" end,-- obsoleto
	["c-up"] = function() clean() up() end,-- Funciona mas precisa fazer funções fora da tabela, solucionado
	["check-branch"] = function() x(("ostree remote refs fedora | grep -E %d | grep -E \"%s/silverblue$\""):format(util.sbversion()+1,util.arch())) end,
	["in"] = function() x(("%s%s upgrade --install=%s"):format(roc,ro,u.xargs())) end,
	["lastchange"] = function() x(("%s db diff"):format(ro)) end,
	["nextsb"] = function() rebasesb(1,"") end,
	["nexttest"] = function() rebasesb(1,"/testing") end,
	["ro"] = function() x(("%s%s%s"):format(roc,ro,u.xargs())) end,
	["search"] = function() x(("%s search %s"):format(ro,u.xargs())) end,
	["search-inrpm"] = function() x(("rpm -qa | grep -E %s"):format(u.xargs())) end,
	["testsb"] = function() rebasesb(0,"/testing") end,
	["up-r"] = function() rpmostree_upgrade "-r" end,
	clean = clean,
	lastdeploy = lastdeploy,
	pin = pin,
	up = up,
	["ostree-unpinall-pin"] = function()
		for i = 2,5 do x(("sudo ostree admin pin --unpin %d"):format(i)) end
		pin()
	end,

	["help"] = function()
		io.write
[[
Options:

cb, check-branch:
  Check new branch
testsb:
  Rebase to testing branch
nt, nexttest:
  Upgrade to next testing version of silverblue
nsb, nextsb:
  Upgrade to next version of silverblue
up:
  Upgrade the role system to latest commit
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
lc, lastchage:
  Show last changes in rpm-ostree
ld, lastdeploy:
  Show the last deploy in Silverblue
ouap, ostree-unpinall-pin:
  Unpin all pinned commits

]]
	end
}

-- Extra functions
handlers['cb'] = handlers["check-branch"]
handlers["ouap"] = handlers["ostree-unpinall-pin"]
handlers["c"] = handlers["clean"]
handlers["s"] = handlers["search"]
handlers["pw"] = handlers["preview"]
handlers["nt"] = handlers["nexttest"]
handlers["ld"] = handlers["lastdeploy"]
handlers["lc"] = handlers["lastchange"]
handlers["nsb"] = handlers["nextsb"]

if s.ca() then handlers["help"]() os.exit(1) end
handlers[arg[1]]()
