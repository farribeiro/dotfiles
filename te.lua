#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local s = require "sai"
os.execute(("toolbox enter %s"):format(s.ca() and "" or arg[1]))
