#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

math.randomseed(os.time())
io.write (("Saiu %s\n"):format(math.random(1, 2) == 1 and "Cara" or "Coroa"))
