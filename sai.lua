-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2024 - Fábio Rodrigues Ribeiro and contributors
local function ca_exit()
    io.write("Nenhum argumento foi passado, saindo...\n")
    os.exit(1)
end
local function ca() return not arg or #arg == 0 end
local function ca_none() if ca() then ca_exit() end end
local function ca_zero(_) if _ == 0 then ca_exit() end end
return { ca_none = ca_none, ca_zero = ca_zero, ca = ca }
