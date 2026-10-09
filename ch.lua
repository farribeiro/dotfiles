#!/usr/bin/env lua
-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors
local _ = "26.08"
os.execute("flatpak run --runtime-version=" .. _ .. " com.google.ChromeDev")
