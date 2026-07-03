-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2024-2026 Fabio Rodrigues Ribeiro and contributors
 
--Interrupt-Driven Clock
--Continually pulses pin A, turning on/off once per second.

if pin.c then
  port.b = false
  port.d = true
  interrupt(1, -- Segundos
  "1",
  true)
elseif event.iid == "1" then
  port.d = false
  port.a = true
  interrupt(1, -- Segundos
  "2",
  true) 
elseif event.iid == "2" then
  port.a = false
  i(8, -- Segundos
  "3",
  true) 
elseif event.iid == "3" then
  port.b = true
end
