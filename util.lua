-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

local op = io.open
local pop = io.popen

local function getoutput_base(cmd, opts)
	local handle = assert(pop(cmd))
	if not handle then error(("Erro ao chamar o comando: %s."):format(cmd)) end

	local function success(cmd2)
		local r1, r2, r3 = os.execute(cmd2)
		if type(r1) == "boolean" then return r1 elseif type(r1) == "number" then return r1 == 0 else return false end
	end

	if not success(cmd) then return nil end

	local result = handle:read(opts)
	handle:close()
	-- handle = nil
	if not result or result == "" then return nil, "Command output is empty" end
	return result
end

local function getoutput(cmd, opts) return getoutput_base(cmd, "*l") end

local function getoutput_all(cmd) return getoutput_base(cmd, "*a") end

local function open_stream(filename, opts)
	local f = assert(op(filename, opts))
	if not f then error(("Erro ao abrir o arquivo %s para leitura."):format(filename)) else return f end
end

local function open_iter(filename)
	local f = open_stream(filename, "r")
	return
		function()
			f:seek("set", 0) -- volta pro início
			local line = f and f:read "*a"
			if not line then
				f:close()
				f = nil
			end
			return line
		end
end

local function openfile_match(filename, string)
	local result
	for line in open_iter(filename) do
		result = line:match(string)
		if result then break end
	end
	return result
end

local function xargs()
	local opts = ""
	for i = 2, #arg do opts = ("%s %s"):format(opts, arg[i]) end
	return opts
end

local function get_fullkernelversion()
	return getoutput "uname -r":match "(%d+)%.(%d+)%.(%d+)" -- Executa o comando uname -r para obter a versão do kernel
end

local function get_kernelminorwithoutpatch()
	local major, minor = get_fullkernelversion()
	return ("%s.%d"):format(major, minor) -- Converte o valor do Minor para número e incrementa 1 e constrói a nova versão do kernel
end

local function get_nextkernelversion()
	local major, minor, patch = get_fullkernelversion()
	return ("%s.%s.%d"):format(major, minor, patch + 1) -- Converte o valor do Patch para número e incrementa 1 e constrói a nova versão do kernel
end

local function get_nextkernelminorwithoutpatch()
	local major, minor = get_fullkernelversion()
	return ("%s.%d"):format(major, minor + 1) -- Converte o valor do Minor para número e incrementa 1 e constrói a nova versão do kernel
end

local function sbversion() return getoutput "rpm -E %fedora" end
local function arch() return getoutput "uname -m" end

local function writecmd_x(cmd)
	io.write(cmd .. "\n")
	x(cmd)
end

local function writemsg_x(cmd, msg)
	io.write(msg)
	x(cmd)
end

local function x_writemsg(cmd, msg)
	x(cmd)
	io.write(msg)
end

local function escape(str) return "'" .. str:gsub("'", "'\\''") .. "'" end

return {
	sbversion = sbversion,
	arch = arch,
	writecmd_x = writecmd_x,
	writemsg_x = writemsg_x,
	x_writemsg = x_writemsg,
	openfile_match = openfile_match,
	xargs = xargs,
	get_nextkernelversion = get_nextkernelversion,
	get_nextkernelminorwithoutpatch = get_nextkernelminorwithoutpatch,
	get_kernelminorwithoutpatch = get_kernelminorwithoutpatch,
	escape = escape,
	getoutput_all = getoutput_all,
	getoutput = getoutput
}
