#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

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
		os.execute(([[mkdir -p ~/work/kernel_test &&\
		cd ~/work/kernel_test &&\
		koji download-build --arch=$(uname -m) %s &&\ 
		sudo rpm-ostree override replace kernel-modules-core-6*.rpm\
		kernel-core-6*.rpm\
		kernel-modules-6*.rpm\
		kernel-6*.rpm\
		kernel-modules-extra-6*.rpm]]):format(arg[2]))
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
