#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

kp = {"modules-core", "core", "modules", "modules-extra" }

local function kernelpackages()
	local kv = tonumber(arg[2]:match("^(%d)"))
	for i, item in ipairs(kp) do kp[i] = ("kernel-%s-%d*.rpm"):format(kp[i], kv) end
	table.insert(kp, ("kernel-%d*"):format(kv))
end

local function getoutput(command)
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	return result
end

local function sbversion() return getoutput("rpm -E %fedora") end
local function sbarch() return getoutput("uname -m"):gsub("[\n\r]", "") end
local function upoverride() os.execute(("rpm-ostree upgrade && cd ~/work/kernel_test ; rpm-ostree override replace %s"):format(table.concat(kp, " "))) end
function prepareworkdir() kernelpackages() os.execute("rm -rf ~/work && mkdir -p ~/work/kernel_test") end

local handlers = {
	["off-selinux"] = function() os.execute("semanage boolean -m --off selinuxuser_execheap") end,

	["install-tools"] = function()
		local list = { "make", "libtirpc-devel", "gcc", "python3-fedora", "koji", "fastfetch" }

		s = " \\\n--install="
		os.execute([[rpm-ostree upgrade %s%s && cd ~ ; git clone https://pagure.io/kernel-tests.git && systemctl reboot]])
		:format(s, table.concat(list, s))
	end,

	["check"] = function()
		os.execute("koji list-builds --package=kernel --pattern \"kernel-%s*\" | grep fc%d"):format(arg[2], sbversion())
		io.write("\n\nLink para o koji: https://koji.fedoraproject.org/koji/packageinfo?packageID=8\n")
	end,

	["override-reset"] = function()
		for i, item in ipairs(kp) do kp[i] = ("kernel-%s"):format(kp[i]) end
		table.insert(kp, "kernel")
		os.execute(("rpm-ostree override reset %s"):format(table.concat(kp, " ")))
	end,

	["force-override"] = function ()
		-- Executa o comando uname -r para obter a versão do kernel e Divide a versão do kernel em partes usando o ponto como delimitador
		arg[2] = getoutput("uname -r"):match("(%d+)")
		kernelpackages() upoverride()
	end,

	["newer-patch"] = function()
		-- Executa o comando uname -r para obter a versão do kernel
		local major, minor, patch = getoutput("uname -r"):match("(%d+)%.(%d+)%.(%d+)")

		-- Converte o valor do Patch para número e incrementa 1
		-- Constrói a nova versão do kernel

		arg[2] = major
		prepareworkdir()
		os.execute(("cd ~/work/kernel_test ; koji download-build --arch=%s kernel-%s-200.fc%d"):format(sbarch(), ("%s.%s.%d"):format(major, minor, patch + 1), sbversion()))
		upoverride()
	end,

	["newer"] = function()
		prepareworkdir()
		os.execute(("cd ~/work/kernel_test ; koji download-build --arch=%s kernel-%s.fc%d"):format(sbarch(), arg[2], sbversion()))
		upoverride()
	end,

	["kernel-regressions"] = function()
		os.execute([[cd ~/kernel-tests;
		sudo -s <<< "semanage boolean -m --on selinuxuser_execheap &&\
		git pull &&\
		./runtests.sh &&\
		./runtests.sh -t performance &&\
		semanage boolean -m --off selinuxuser_execheap"]])
	end,

	["help"] = function()
		io.write([[Options:

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

]])
	end
}

-- Extra functions
handlers["off-selinux"] = handlers["off"]
handlers["np"] = handlers["newer-patch"]
handlers["n"] = handlers["newer"]
handlers["c"] = handlers["check"]
handlers["kr"] = handlers["kernel-regressions"]
handlers["fo"] = handlers["force-override"]
handlers["or"] = handlers["override-reset"]
handlers["in"] = handlers["install-tools"]

if not arg or #arg == 0 then
	handlers["help"]()
	os.exit(1)
end
handlers[arg[1]]()
