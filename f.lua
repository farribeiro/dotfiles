#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

x = os.execute
local u = require "util"
local sai = require "sai"
local wd = "~/work/kernel_test"
local cd = ("cd %s ;"):format(wd)
local kb = ("%s koji download-build --arch=%s --rpm %s"):format(cd, "%s", "%s")
Kp = {"modules-core", "core", "modules", "modules-extra" }

local function override() u.writecmd_x(("%s rpm-ostree override replace %s"):format(cd, table.concat(Kp, " "))) end

local function down_and_replace(kp_args, k_args, version)
	x(("rm -rf %s && mkdir -p %s"):format(wd, wd))
	local cmd = ""
	for i, item in ipairs(Kp) do
		Kp[i] = (kp_args):format(Kp[i], version, u.sbversion(), u.arch())
		cmd = kb:format(u.arch(), Kp[i])
		u.writecmd_x(cmd)
	end

	cmd = kb:format(u.arch(), (k_args):format(version, u.sbversion(), u.arch()))
	u.writecmd_x(cmd)

	table.insert(Kp, (k_args):format(version, u.sbversion(), u.arch()))
	override()
end

local handlers = {
	["off-selinux"] = function() x "semanage boolean -m --off selinuxuser_execheap" end,

	["install-tools"] = function()
		local list = { "make", "libtirpc-devel", "gcc", "python3-fedora", "koji", "fastfetch" }
		local s = " \\\n--install="
		x(("rpm-ostree upgrade %s%s && cd ~ ; git clone https://pagure.io/kernel-tests.git"):format(s, table.concat(list, s)))
	end,

	["check"] = function()
		arg[2] = not arg[2] and u.sbversion() or arg[2]
		cmd = ([[koji list-builds --package=kernel --pattern "*fc%d*"]]):format(arg[2])
		u.writecmd_x(cmd)

		io.write "\n\nLink para o koji: https://koji.fedoraproject.org/koji/packageinfo?packageID=8\n"
	end,

	["override-reset"] = function()
		for i, item in ipairs(Kp) do Kp[i] = ("kernel-%s"):format(Kp[i]) end
		table.insert(Kp, "kernel")
		x(("rpm-ostree override reset %s"):format(table.concat(Kp, " ")))
	end,

	["force-override"] = function ()
		arg[2] = u.getoutput "uname -r":match "(%d+)" -- Executa o comando uname -r para obter a versão do kernel e Divide a versão do kernel em partes usando o ponto como delimitador
		override()
	end,

	["newer-patch"] = function()
		local major, minor, patch = u.getoutput "uname -r":match "(%d+)%.(%d+)%.(%d+)" -- Executa o comando uname -r para obter a versão do kernel
		local version = ("-%s.%s.%d"):format(major, minor, patch + 1) -- Converte o valor do Patch para número e incrementa 1 e constrói a nova versão do kernel
		down_and_replace("kernel-%s%s-200.fc%d.%s.rpm", "kernel%s-200.fc%d.%s.rpm", version)
	end,

	["newer"] = function() down_and_replace("kernel-%s-%s.fc%d.%s.rpm", "kernel-%s.fc%d.%s.rpm", arg[2] ) end,

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

if sai.ca() then handlers["help"]() os.exit(1) end
handlers[arg[1]]()
