#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

os.execute "podman run -it --rm -v ~/bin:/fabio:Z crystallang/crystal bash"
