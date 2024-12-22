#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

local s = require "sai"

os.execute(("curl \"cht.sh/lua/%s\""):format(s.ca() and ":list" or arg[1]))
