#!/usr/bin/env lua
-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors
local x = os.execute
local u = require "util"
local fk = "flatpak "
local sbtrfs = "sudo btrfs "
u.writecmd_x(fk .. "remove --unused --delete-data -y")
u.writecmd_x "sudo -s <<< 'journalctl --rotate && journalctl --vacuum-time=2d'"
local w = u.getoutput_all("echo -e '/var\n/var/home/fribeiro/Games' | gum filter --placeholder 'O que deseja fazer?'")
local cmd_use = sbtrfs .. "filesystem usage " .. w
x(cmd_use)
io.write("\n" .. ("*"):rep(10) .. "\nDusage: ")
local n = io.read "*n"
x(("%s balance start -dusage=%d %s"):format(sbtrfs, n, w))
x(cmd_use)
