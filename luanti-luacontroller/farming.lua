-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2023 João Rocha Braga Filho and contributors
-- Copyright 2024-2026 Fabio Rodrigues Ribeiro and contributors
 
local s            = 2 -- Segundos
local tubos, chave = "a", "b"
local function i(vf) interrupt(s, "on", vf) end
if pin[chave] then
  port[tubos] = not port[tubos]
  i(true)
  digiline_send("Mulch", {
    slotseq = "priority",
    exmatch = false,
    name    = "bonemeal:fertiliser",
    count   = 8 -- Qt de Fertilizantes
})
end
