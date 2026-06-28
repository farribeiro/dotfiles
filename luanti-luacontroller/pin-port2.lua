-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2024-2026 Fabio Rodrigues Ribeiro and contributors
 
--Interrupt-Driven Clock
--Continually pulses pin A, turning on/off once per second.

function i(_) interrupt(30, -- Segundos
  _,
  true) 
end

if pin.a then
  port.c = false
  i("nc")
elseif event.iid == "nc" then
  port.c = true
  i("c")
end
