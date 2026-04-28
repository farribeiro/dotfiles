#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute
local _ = require "sai".ca() and x "rpm-ostree override reset -a" or
	x("rpm-ostree override replace " .. arg[1] .. " && rpm-ostree upgrade --reboot")
