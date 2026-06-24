local function i() interrupt(1) end

if event.type == "program" then
	port.a = true
	i()
else
	port.a = not port.a
	i()
end
