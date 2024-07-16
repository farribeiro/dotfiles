#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

os.execute "cd ~/net.minetest.Minetest ; flatpak run org.flatpak.Builder --install --user --force-clean build-dir net.minetest.Minetest.yaml"