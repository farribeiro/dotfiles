#!/usr/bin/env lua
-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors

os.execute("flatpak run --runtime-version=" .. require "fkutil".v .. " com.google.ChromeDev &")
