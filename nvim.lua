#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

local s = require "sai"

os.execute(("flatpak run io.neovim.nvim %s"):format(s.ca() and " " or arg[1] == "s" and "${HOME}/.var/app/io.neovim.nvim/config" or ("%s/%s"):format(os.getenv("PWD"), arg[1])))
