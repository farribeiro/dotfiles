#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

kp = {
	"modules-core",
	"core",
	"modules",
	"modules-extra"
}

local function getoutput(command)
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	return result
end

local function sbversion()
	return tonumber(getoutput("rpm -E %fedora"))
end

local function sbarch()
	return getoutput("uname -m"):gsub("[\n\r]", "")
end

local handlers = {
	["off"] = function()
		os.execute("semanage boolean -m --off selinuxuser_execheap")
	end,

	["in"] = function()
		local list ={
			"make",
			"libtirpc-devel",
			"gcc",
			"python3-fedora",
			"koji",
			"fastfetch"
			}
		
		s = " \\\n--install="
		print(([[rpm-ostree upgrade %s%s && cd ~ ; git clone https://pagure.io/kernel-tests.git && systemctl reboot]])
		:format(s, table.concat(list, s)))
	end,

	["ck"] = function()
		os.execute(([[koji list-builds --package=kernel --pattern "kernel-%s*" | grep fc%d]]):format(arg[2], sbversion()))
		io.write("\n\nLink para o koji: https://koji.fedoraproject.org/koji/packageinfo?packageID=8\n")
	end,

	["ork"] = function()
		for i, item in ipairs(kp) do
			kp[i] = ("kernel-%s"):format(kp[i])
		end

		table.insert(kp, "kernel")

		os.execute(("rpm-ostree override reset %s"):format(table.concat(kp, " ")))
	end,

	["ok"] = function()
		local kv = tonumber(arg[2]:match("^(%d)"))

		for i, item in ipairs(kp) do
			kp[i] = ("kernel-%s-%d*.rpm"):format(kp[i], kv)
		end

		table.insert(kp, ("kernel-%d*"):format(kv))

		os.execute(([[cd ~; rm -rf work &&\
		mkdir -p ~/work/kernel_test &&\
		cd ~/work/kernel_test ;\
		koji download-build --arch=%s kernel-%s.fc%d &&\
		rpm-ostree upgrade &&\
		rpm-ostree override replace %s]]):format(sbarch(), arg[2], sbversion(), table.concat(kp, " ")))
	end,

	["kr"] = function()
		os.execute([[cd ~/kernel-tests;
		sudo -s <<< "semanage boolean -m --on selinuxuser_execheap &&\
		git pull &&\
		./runtests.sh &&\
		./runtests.sh -t performance &&\
		semanage boolean -m --off selinuxuser_execheap"]])
	end
}

-- Extra functions
handlers["off-selinux"] = handlers["off"]

if not arg or #arg == 0 then
	handlers["help"]()
	os.exit(1)
end
handlers[arg[1]]()
