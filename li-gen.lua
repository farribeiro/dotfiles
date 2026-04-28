#!/usr/bin/env lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2023 - Fábio Rodrigues Ribeiro and contributors

os.execute [[
cd ~/fkmtcustom &&\
git pull &&\
git submodule update --init &&\
flatpak run org.flatpak.Builder --install --user --force-clean build-dir org.luanti.luanti.yaml
]]
