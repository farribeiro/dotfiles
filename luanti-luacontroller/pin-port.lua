--Interrupt-Driven Clock
--Continually pulses pin A, turning on/off once per second.
local s = 5
function i(clock) interrupt(s, clock, true) end
port.c = pin.a and true
i("clock")
