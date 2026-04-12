#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

os.execute(("curl \"cht.sh/lua/%s\""):format(require "sai":ca() and ":list" or arg[1]))
