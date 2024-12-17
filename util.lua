-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

local util = {}

function util.sbversion() return util.getoutput "rpm -E %fedora" end
function util.arch() return util.getoutput "uname -m":gsub("[\n\r]", "") end

function util.getoutput(command)
	local handle = io.popen(command)
	if not handle then return nil, "Failed to execute command" end
	local result = handle:read("*a")
	handle:close()
	if not result or result == "" then return nil, "Command output is empty" end
	return result
end

return util
