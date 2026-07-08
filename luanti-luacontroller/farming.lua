-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2023 João Rocha Braga Filho and contributors
-- Copyright 2024-2026 Fabio Rodrigues Ribeiro and contributors
 
if pin.b then
  port.a = not port.a
  interrupt(2) -- Segundos
  digiline_send("Mulch", { -- Tabelas com as propeiedades
    slotseq = "priority",
    exmatch = false,
    name    = "bonemeal:fertiliser", -- Tipo de Ferlizantes pode ser bonemeal:mulch
    count   = 8 -- Qt de Fertilizantes
})
end
