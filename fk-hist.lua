#!/usr/bin/env lua
-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2026 - Fábio Rodrigues Ribeiro and contributors
local x = os.execute
x 'gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5'
local tmp = os.tmpname()
"flatpak history --reverse | sed -E 's/master|origin|uninstall//d;s/(deploy|stable|system.*$)//Ig' > " .. tmp
x("gum filter --placeholder 'Entradas...' < " .. tmp)
os.remove(tmp)
