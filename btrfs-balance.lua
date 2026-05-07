#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute
x 'sudo -s <<< "journalctl --rotate && journalctl --vacuum-time=2d"'
local w = require "util".getoutput_all("echo -e '/var\n/var/home/fribeiro/Games' | gum filter --placeholder 'O que deseja fazer?'")
x("sudo  btrfs filesystem usage " .. w)
io.write("\n" .. ("*"):rep(10) .. "\nDusage: ")
local n = io.read "*n" or 0
if n == 0 then print "Argumentos inválidos passados" os.exit(1) end
x(("sudo btrfs balance start -dusage=%d %s"):format(n, w))
