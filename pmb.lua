#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

os.execute("podman build -t " .. require "util".getoutput("basename " .. os.getenv "PWD") .. " .")
