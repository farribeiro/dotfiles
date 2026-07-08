-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2024-2026 Fabio Rodrigues Ribeiro and contributors
 
--Interrupt-Driven Clock
--Continually pulses pin A, turning on/off once per second.

if pin.a then
  port.c = false
  interrupt(30, -- Segundos
    "nc") 
elseif event.iid == "nc" then port.c = true end
