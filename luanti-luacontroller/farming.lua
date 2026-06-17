-- SPDX-License-Indentifier: GPL-2.0
-- Copyright 2023 João Rocha Braga Filho and contributors
-- Copyright 2024-2026 Fabio Rodrigues Ribeiro and contributors

--local LUT_fert = { mulch = "bonemeal:mulch", fert = "bonemeal:fertiliser" }
--fert = "bonemeal:mulch"
--fert = "bonemeal:fertiliser"
 
local s            = 2 -- Segundos
local tubos, chave = "a", "b"
local propriedades = {
  slotseq = "priority",
  exmatch = false,
  --name    = LUT_fert.fert,
  --name    = fert,
  --name      = "bonemeal:mulch"
  name      = "bonemeal:fertiliser",
  count   = 8 -- Qt de Fertilizantes
}
local function i(vf) interrupt(s, "on", vf) end
-- if not pin[chave] then
if pin[chave] then
  --i(false) -- Maquina parada
-- else
  port[tubos] = not port[tubos]
  i(true)
  digiline_send("Mulch", propriedades)
end
