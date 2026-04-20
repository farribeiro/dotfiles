#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute
x "sudo  btrfs filesystem usage /var"
io.write("\n" .. ("*"):rep(10) .. "\nDusage: ")
local _ = io.read "*n" or 0
x("sudo btrfs balance start -dusage=" .. _ .. " /var")
