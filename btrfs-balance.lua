#!/usr/bin/env lua

local x = os.execute

x "sudo  btrfs filesystem usage /var"
print ("\n" .. ("*"):rep(10))
io.write "Dusage: "
local _ = io.read "*n" or 0
x ("sudo btrfs balance start -dusage=" .. _ .. " /var")
