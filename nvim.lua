#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2023 - Fábio Rodrigues Ribeiro and contributors

os.execute(("flatpak run io.neovim.nvim %s"):format(require "sai":ca() and " " or arg[1] == "s" and "${HOME}/.var/app/io.neovim.nvim/config" or ("%s/%s"):format(os.getenv("PWD"), arg[1])))
