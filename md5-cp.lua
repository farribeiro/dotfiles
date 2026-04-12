#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

require "sai":ca_none()
os.execute(("rsync -av %s %s && rsync -cavn %s %s"):format(arg[1], arg[2], arg[1], arg[2])) -- copia e checa checksum
