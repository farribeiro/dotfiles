#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute
if require "sai".ca() then
	x "rpm-ostree override reset -a"
else
	x("rpm-ostree override replace " ..
		arg[1] .. " && rpm-ostree upgrade --reboot")
end
