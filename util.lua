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

local function openfile_match(filename, string)
	local file = assert(io.open(filename, "r"))
	if not file then error(("Erro ao abrir o arquivo %s para escrita."):format(filename)) end
	local result
	for line in file:lines() do
		result = line:match(string)
		if result then break end
	end
	file:close()
	-- if not result or result == "" then return nil, "File is empty" end
	return result
end

local function xargs()
	local opts = ""
	for i = 2, #arg do opts = ("%s %s"):format(opts, arg[i]) end
	return opts
end

local function sbversion() return getoutput "rpm -E %fedora" end
local function arch() return getoutput "uname -m" end
local function writecmd_x(cmd) io.write(cmd .. "\n") x(cmd) end
local function writemsg_x(cmd, msg) io.write(msg) x(cmd) end
local function x_writemsg(cmd, msg) x(cmd) io.write(msg) end

return {
	sbversion = sbversion,
	arch = arch,
	writecmd_x = writecmd_x,
	writemsg_x = writemsg_x,
	x_writemsg = x_writemsg,
	openfile_match = openfile_match,
	getoutput = getoutput
}
