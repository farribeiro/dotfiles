#!/usr/bin/env lua
-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors
local x = os.execute
local u = require "util"
local sbtrfs = "sudo btrfs "
u.p_x "flatpak remove --unused --delete-data -y"
u.p_x "sudo -s <<< 'journalctl --rotate && journalctl --vacuum-time=2d'"
local w = u.getoutput_all("echo -e '/var\n/var/home/fribeiro/Games' | gum filter --placeholder 'Onde deseja fazer o balance?'")
local cmd_use = sbtrfs .. "filesystem usage " .. w .. " | grep -E '^(Me|Da)ta'"
local function bal(_)
	local function b() x(cmd_use) end
	b()
	io.write("\n" .. ("*"):rep(10) .."\n" .. _ .. "usage: ")
	x(("%s balance start -%susage=%d %s"):format(sbtrfs, _, io.read "*n", w))
	b()
end
bal "d"
bal "m"
