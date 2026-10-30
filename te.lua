#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

os.execute(("toolbox enter %s"):format(require "sai":ca() and "" or arg[1]))
