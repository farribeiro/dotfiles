-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2024-2026 Fabio Rodrigues Ribeiro and contributors
 
--Interrupt-Driven Clock
--Continually pulses pin A, turning on/off once per second.

port.c = pin.a and true
interrupt(5) -- Segundos
