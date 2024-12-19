-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

local function check_args()
	return not arg or #arg == 0
end

return {
["ca_none"] = function ()
	if check_args() then io.write("Nenhum argumento foi passado, saindo...\n") os.exit(1) end
end,

["ca"] = function()
	return check_args()
end
}
