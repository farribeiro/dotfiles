-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

return {
["sbversion"] = function() return getoutput "rpm -E %fedora" end,

["arch"] = function() return getoutput "uname -m":gsub("[\n\r]", "") end,

["getoutput"] = function(command)
	local handle = io.popen(command)
	if not handle then return nil, "Failed to execute command" end
	local result = handle:read("*a")
	handle:close()
	if not result or result == "" then return nil, "Command output is empty" end
	return result
end,

["check_arg"] = function()
	if not arg or #arg == 0 then os.exit(1) end
end,

["write_x"]= function(cmd) io.write(cmd .. "\n") os.execute(cmd) end
}
