-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

return {
["sbversion"] = function() return getoutput "rpm -E %fedora" end,

["arch"] = function() return getoutput "uname -m":gsub("[\n\r]", "") end,

["getoutput"] = function(cmd)
	local handle = io.popen(cmd)
	if not handle then return nil, "Failed to execute command" end
	local result = handle:read("*a")
	handle:close()
	if not result or result == "" then return nil, "Command output is empty" end
	return result
end,

["write_x"]= function(cmd) io.write(cmd .. "\n") os.execute(cmd) end
}
