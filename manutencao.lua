#!/usr/bin/env lua
-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors
local x = os.execute
local u = require "util"
local sbtrfs = "sudo btrfs "
u.writecmd_x("flatpak remove --unused --delete-data -y")
u.writecmd_x "sudo -s <<< 'journalctl --rotate && journalctl --vacuum-time=2d'"
local w = u.getoutput_all("echo -e '/var\n/var/home/fribeiro/Games' | gum filter --placeholder 'O que deseja fazer?'")
local cmd_use = sbtrfs .. "filesystem usage " .. w
local function bal(_)
	x(cmd_use)
	io.write("\n" .. ("*"):rep(10) .."\n" .. _ .. "usage: ")
	x(("%s balance start -%susage=%d %s"):format(sbtrfs, io.read "*n", w))
end
bal("d")
bal("m")
