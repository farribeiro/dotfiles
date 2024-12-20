-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors

local function ca() return not arg or #arg == 0 end

return {
["ca_none"] = function () if ca() then io.write("Nenhum argumento foi passado, saindo...\n") os.exit(1) end end,
ca = ca
}
