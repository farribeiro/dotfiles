--Interrupt-Driven Clock
--Continually pulses pin A, turning on/off once per second.
local s = 5
function i(clock) interrupt(s, clock, true) end
--[[
if pin.a then
  port.c = true
  -- i("clockb")
else
--elseif event.type == "program" or event.iid == "clockb" then
  port.c = false
end ]]--
-- port.c = pin.a and true or false
port.c = pin.a and true
i("clock")
