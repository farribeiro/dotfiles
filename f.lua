#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute
local kb = "cd ~/work/kernel_test ; koji download-build --arch=%s kernel-%s"

kp = {"modules-core", "core", "modules", "modules-extra" }
kp2 = kp

local function kernelpackages()
	local kv = tonumber(arg[2]:match "^(%d)")
	for i, item in ipairs(kp) do kp[i] = ("kernel-%s-%d*.rpm"):format(kp[i], kv) end
	table.insert(kp, ("kernel-%d*"):format(kv))
end

local function getoutput(command)
	local handle = io.popen(command)
	local result = handle:read "*a"
	handle:close()
	return result
end

local function sbversion() return getoutput "rpm -E %fedora" end
local function arch() return getoutput("uname -m"):gsub("[\n\r]", "") end
local function override() x(("cd ~/work/kernel_test ; rpm-ostree override replace %s"):format(table.concat(kp, " "))) end
function prepareworkdir() x "rm -rf ~/work && mkdir -p ~/work/kernel_test" end

local handlers = {
	["off-selinux"] = function() x "semanage boolean -m --off selinuxuser_execheap" end,

	["install-tools"] = function()
		local list = { "make", "libtirpc-devel", "gcc", "python3-fedora", "koji", "fastfetch" }
		local s = " \\\n--install="
		x([[rpm-ostree upgrade %s%s && cd ~ ; git clone https://pagure.io/kernel-tests.git && systemctl reboot]]):format(s, table.concat(list, s))
	end,

	["check"] = function()
		x("koji list-builds --package=kernel --pattern \"kernel-%s*\" | grep fc%d"):format(arg[2], sbversion())
		io.write "\n\nLink para o koji: https://koji.fedoraproject.org/koji/packageinfo?packageID=8\n"
	end,

	["override-reset"] = function()
		for i, item in ipairs(kp) do kp[i] = ("kernel-%s"):format(kp[i]) end
		table.insert(kp, "kernel")
		x(("rpm-ostree override reset %s"):format(table.concat(kp, " ")))
	end,

	["force-override"] = function ()
		-- Executa o comando uname -r para obter a versão do kernel e Divide a versão do kernel em partes usando o ponto como delimitador
		arg[2] = getoutput "uname -r" :match "(%d+)"
		kernelpackages() override()
	end,

	["newer-patch"] = function()
		-- Executa o comando uname -r para obter a versão do kernel
		local major, minor, patch = getoutput"uname -r":match "(%d+)%.(%d+)%.(%d+)"
	
		-- Converte o valor do Patch para número e incrementa 1
		-- Constrói a nova versão do kernel
	
		arg[2] = major
		prepareworkdir()
		for i, item in ipairs(kp2) do x(("%s-200.fc%d"):format(kb:format(arch(), kp2[i] .. ("-%s.%s.%d"):format(major, minor, patch + 1)), sbversion())) end
		kernelpackages()
		override()
	end,
	
	["newer"] = function()
		prepareworkdir()
		for i, item in ipairs(kp2) do x(("%s.fc%d"):format(kb:format(arch(), kp2[i] .. "-" .. arg[2]), sbversion())) end
		kernelpackages()
		override()
	end,

	["kernel-regressions"] = function()
		x [[cd ~/kernel-tests;
		sudo -s <<< "semanage boolean -m --on selinuxuser_execheap &&\
		git pull &&\
		./runtests.sh &&\
		./runtests.sh -t performance &&\
		semanage boolean -m --off selinuxuser_execheap"]]
	end,

	["help"] = function()
		io.write
[[Options:

n, newer:
  Download and Install a newer kernel (eg f.lua n 6.8.1-200)
np, newer-patch:
  Download and Install a newer kernel patch (eg. f.lua np)
fo, force-override:
  Force a kernel installation
or, override-reset:
  Reset the installed kernel and goes to repo kernel
kr, kernel-regressions:
  Performs test regressions

]]
	end
}

-- Extra functions
handlers["c"] = handlers["check"]
handlers["fo"] = handlers["force-override"]
handlers["in"] = handlers["install-tools"]
handlers["kr"] = handlers["kernel-regressions"]
handlers["n"] = handlers["newer"]
handlers["np"] = handlers["newer-patch"]
handlers["off"] = handlers["off-selinux"]
handlers["or"] = handlers["override-reset"]

if not arg or #arg == 0 then handlers["help"]() os.exit(1) end
handlers[arg[1]]()
