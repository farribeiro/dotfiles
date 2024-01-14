#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

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
	return getoutput("uname -m")
end

handlers = {
	["off"] = function()
		os.execute("semanage boolean -m --off selinuxuser_execheap")
	end,

	["in"] = function()
		os.execute([[rpm-ostree upgrade\
		--install=make\
		--install=libtirpc-devel\
		--install=gcc\
		--install=python3-fedora\
		--install=koji\
		--install=fastfetch &&\
		cd ~ ; git clone https://pagure.io/kernel-tests.git &&\
		systemctl reboot]])
	end,

	["ok"] = function()
		kv = tonumber(arg[2]:match("^(%d)"))
		os.execute(([[mkdir -p ~/work/kernel_test &&\
		cd ~/work/kernel_test &&\
		koji download-build --arch=%s kernel-%s-300.fc%d &&\ 
		rpm-ostree override replace\
		kernel-modules-core-%d*.rpm\
		kernel-core-%d*.rpm\
		kernel-modules-%d*.rpm\
		kernel-%d*.rpm\
		kernel-modules-extra-6*.rpm &&\
		cd ~; rm -rf work &&\
		systemctl reboot]]):format(sbarch(), arg[2], sbversion(), kv, kv, kv, kv))
	end,

	["kr"] = function()
		os.execute([[cd ~/kernel-tests;
		sudo -s <<< "semanage boolean -m --on selinuxuser_execheap &&\
		git pull &&\
		./runtests.sh &&\
		semanage boolean -m --off selinuxuser_execheap"]])
		-- ./runtests.sh -t performance &&\
	end
}

-- Extra functions
handlers["off-selinux"] = handlers["off"]

if not arg or #arg == 0 then
	handlers["help"]()
	os.exit(1)
else
	handlers[arg[1]]()
end
