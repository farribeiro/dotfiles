#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2025 - Fábio Rodrigues Ribeiro and contributors

-- os.execute "koji-tool install kernel"
local cmd = "koji-tool install kernel"
local x = os.execute

if require "sai".ca() then x(cmd) else x(cmd .. "*" .. require "util".get_nextkernelminorwithoutpatch() .. "*") end
