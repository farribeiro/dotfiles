--Interrupt-Driven Clock
--Continually pulses pin A, turning on/off once per second.
function i(clock) 
port.c = pin.a and true
interrupt(5, -- Segundos
    clock,
    true)
