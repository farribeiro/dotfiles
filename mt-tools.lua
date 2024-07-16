#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

local x = os.execute

local function readLinesFromFile(filename)
	local tabela = {}
	local file = assert(io.open(filename, "r"))
	for line in file:lines() do table.insert(tabela, line) end
	file:close()
	return tabela
end

local function cloneRepositories(filename)
	for _, repo in ipairs(readLinesFromFile(filename)) do x(("git clone %s"):format(repo)) end
end

local function writeWorldMtFile(modules)
	local file = io.open("world.mt", "w")
	if not file then error "Erro ao abrir o arquivo world.mt para escrita." end

	file:write "gameid = minetest\nworld_name =\n\n"
	file:write(table.concat(modules, "\n"))

	file:close()
	print "world.mt criado com sucesso."
end

local handlers ={
	["bootstrap"] = function ()
		local repositoriesFile = "git.txt"
		local modulesFile = "modules.txt"

		local count_repo = 0
		for _ in ipairs(readLinesFromFile(repositoriesFile)) do count_repo = count_repo + 1 end

		cloneRepositories(repositoriesFile)

		local count_modules = 0
		local modules = readLinesFromFile(modulesFile)
		for i, item in ipairs(modules) do
			modules[i] = ("load_mod_%s = true"):format(modules[i])
			count_modules = count_modules +1
		end

		writeWorldMtFile(modules)

		io.write(("Quantidade de repositórios: %d\nQuantidade de mods: %d\n"):format(count_repo, count_modules))
	end,

	["up-mods"] = function() x "find . -maxdepth 1 -type d -exec bash -c \"cd '{}' && git pull\" \\;" end,
	["up-secfix"] = function() x "dnf up -y" end,
	["start"] = function() x "minetest --server --terminal --gameid minetest" end,
	["stop"] = function() x "killall minetest" end,

	["up"] = function ()
		handlers["up-mods"]()
		handlers["up-secfix"]()
	end,

	["restart"] = function()
		handlers["stop"]()
		handlers["start"]()
	end

--[[
	["in-up-game"]
		print(sudo dnf install make \
		automake \
		gcc \
		gcc-c++ \
		kernel-devel \
		cmake \
		libcurl-devel \
		openal-soft-devel \
		libpng-devel \
		libjpeg-devel \
		libvorbis-devel \
		libXi-devel \
		libogg-devel \
		freetype-devel \
		mesa-libGL-devel \
		zlib-devel \
		jsoncpp-devel \
		gmp-devel \
		sqlite-devel \
		luajit-devel \
		leveldb-devel \
		ncurses-devel \
		spatialindex-devel \
		libzstd-devel \
		gettext \
		SDL2-devel\
		ninja
		)
end
--]]

--[[
 cmake -G Ninja /usr/src/minetest \
        -DENABLE_POSTGRESQL=TRUE \
        -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE=RelWithDebug \
        -DBUILD_SERVER=TRUE \
        -DBUILD_CLIENT=FALSE \
        -DBUILD_UNITTESTS=FALSE \
        -DVERSION_EXTRA=unofficial &&\
    ninja -j$(nproc) &&\
    ninja install
--]]

}

-- Extra functions
handlers["bs"] = handlers["bootstrap"]

if not arg or #arg == 0 then
	--handlers["help"]()
	os.exit(1)
end
handlers[arg[1]]()
