#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

if not arg or #arg == 0 then
	os.exit(1)
else
	os.execute(("curl \"cht.sh/lua/%s\""):format(arg[1]))
end