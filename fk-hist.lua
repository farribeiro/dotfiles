#!/usr/bin/env lua
-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2026 - Fábio Rodrigues Ribeiro and contributors
os.execute [[gum spin --spinner dot --title "🔍 Buscando..." -- sleep 0.5 &&\
gum pager \
< <(flatpak history --reverse) \
< <(sed -E '/master|origin|uninstall/d;s/(deploy|stable|system.*$)//Ig') < <(column -t)]]
