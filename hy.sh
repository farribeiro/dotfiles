#!/usr/bin/env sh

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors

cd ~/Downloads
wget2 https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak
flatpak remove com.hypixel.HytaleLauncher
flatpak --user install ~/Downloads/hytale-launcher-latest.flatpak
rm -rf hytale-launcher-latest.flatpak
