#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

os.execute(("curl \"cht.sh/lua/%s\""):format(not arg or #arg == 0 and "" or arg[1]))