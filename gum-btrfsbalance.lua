#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute
local u = require "util"
local url =  "https://dl.flathub.org/repo/flathub.flatpakrepo"
local fh = "flathub "
local fkargs = "--if-not-exists " .. fh
local fk = "flatpak "
local fkrmt = "remote-add "
local fkucmd = fk .. fkrmt .. "--user " .. fkargs .. url
local fkcmd = fk .. fkrmt .. fkargs .. url
local fkencmd = fk .. " remote-modify --enable" .. fh
x(fk .. "remove --unused --delete-data --assumeyes && " .. fkucmd .. " && " .. fkcmd .. " && " .. fkencmd)
x "sudo -s <<< 'journalctl --rotate && journalctl --vacuum-time=2d'"
local w = u.getoutput_all("echo -e '/var\n/var/home/fribeiro/Games' | gum filter --placeholder 'O que deseja fazer?'")
local cmd_use = "sudo  btrfs filesystem usage " .. w
x(cmd_use)
io.write("\n" .. ("*"):rep(10) .. "\nDusage: ")
local n = io.read "*n" or 0
require "sai".ca_zero(n)
x(("sudo btrfs balance start -dusage=%d %s"):format(n, w))
x(cmd_use)
