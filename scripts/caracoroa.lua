math.randomseed(os.time())
local n = math.random(1, 2)
io.write (("Saiu %s\n"):format(n == 1 and "Cara" or "Coroa"))
