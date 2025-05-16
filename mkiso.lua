#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2025 - Fábio Rodrigues Ribeiro and contributors

require "sai":ca_none()
os.execute(("sudo dd if=/dev/sr0 of=%s/%s.iso bs=4M status=progress"):format(os.getenv("PWD"), arg[1]))
