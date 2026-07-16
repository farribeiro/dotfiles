-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2024-2026 Fabio Rodrigues Ribeiro and contributors
 
local i = interrupt
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
