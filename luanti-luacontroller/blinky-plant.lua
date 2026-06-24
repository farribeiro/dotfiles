-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2026 Fabio Rodrigues Ribeiro and contributors

port.a = event.type == "program" and true or not port.a
interrupt(1)
