-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2024-2026 Fabio Rodrigues Ribeiro and contributors
 
--Interrupt-Driven Clock
--Continually pulses pin A, turning on/off once per second.

local function i (s, _)
  interrupt(s, _, true)
end 

if pin.c then
  port.b, port.d = true, false
  i(1, -- Segundos
  "1")
elseif event.iid == "1" then
  port.a = true
  i(1, -- Segundos
  "2") 
elseif event.iid == "2" then
  i(8, -- Segundos
  "3") 
elseif event.iid == "3" then
  port.a, port.b = false, false
  port.d = true
end
