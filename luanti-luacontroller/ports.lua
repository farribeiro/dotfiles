-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2026 - Fábio Rodrigues Ribeiro and contributors

-- LUT (Lookup Table): Mapeia a string do evento direto para os estados (A, B, C) e o próximo timer
local LUT = {
  ["clock"]  = { true, false, false, false, next_id = "clockb" },
  ["clockb"] = { false, true, false, false, next_id = "clockc" },
  ["clockc"] = { false, false, true, false, next_id = "clockd" },
  ["clockd"] = { false, false, false, true, next_id = "clock" },
}

-- Resolve o gatilho inicial ("program" vira "clock") ou pega o ID do evento atual
local id = (event.type == "program") and "clock" or event.iid
local row = LUT[id]

if row then
  -- Atribuição múltipla em uma linha usando os índices da tabela
  port.a, port.b, port.c, port.d = row[1], row[2], row[3], row[4]
  -- Dispara o próximo timer usando a string correta
  interrupt(1, row.next_id)
end
