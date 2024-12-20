-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

local function getoutput(cmd)
	local handle = assert(io.popen(cmd))
	if not handle then error(("Erro ao chamar o comando: %s."):format(cmd)) end
	local result = handle:read "*l"
	handle:close()
	if not result or result == "" then return nil, "Command output is empty" end
	return result
end

return {
["sbversion"] = function() return getoutput "rpm -E %fedora" end,
["arch"] = function() return getoutput "uname -m" end,
["writecmd_x"] = function(cmd) io.write(cmd .. "\n") x(cmd) end,
["x_writemsg"] = function(cmd, msg) x(cmd) io.write(msg) end,
["writemsg_x"] = function(cmd, msg) io.write(msg) x(cmd) end,
["openfile_match"] = function(filename, string)
	local file = assert(io.open(filename, "r"))
	if not file then error("Erro ao abrir o arquivo %s para escrita."):format(filename) end
	local result
	for line in file:lines() do
		result = line:match(string)
		if result then break end
	end
	file:close()
	-- if not result or result == "" then return nil, "File is empty" end
	return result
end,
getoutput = getoutput
}
