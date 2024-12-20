#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local s = require "sai"
os.execute(("flatpak run dev.zed.Zed %s"):format(s.ca() and " " or ("%s/%s"):format(os.getenv("PWD"), arg[1])))
