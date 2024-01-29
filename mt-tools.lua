#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

local handlers ={
	["bootstrap"] = function ()
		local modules = {}

		local arquivo = io.open("git.txt", "r") -- Abre o arquivo para leitura
		if not arquivo then
			print("Erro ao abrir o arquivo.")
			return nil
		end
		for linha in arquivo:lines() do
			os.execute(("git clone %s"):format(linha)) -- Clona repositório
		end

		arquivo:close()
		arquivo = nil

		local arquivo = io.open("modules.txt", "r") -- Abre o arquivo para leitura
		if not arquivo then
			print("Erro ao abrir o arquivo.")
			return nil
		end
		-- Loop através das linhas do arquivo
		for linha in arquivo:lines() do
			table.insert(modules, linha) -- Adiciona a linha à tabela
		end
		arquivo:close()

		for i, item in ipairs(modules) do
			modules[i] = ("load_mod_%s = true"):format(modules[i])
		end

		-- Abre ou cria um arquivo chamado "exemplo.txt" no modo de escrita ("w")
		local arquivo = io.open("world.mt", "w")
		if not arquivo then
			print("Erro ao abrir o arquivo.")
			return nil
		end

		-- Escreve no arquivo
		arquivo:write("gameid = minetest\nworld_name =\n\n")
		arquivo:write(table.concat(modules, "\n"))
		-- Fecha o arquivo após terminar de escrever
		arquivo:close()

		print("world.mt criado com sucesso.")
	end,

	["up-mods"] = function()
		os.execute("find . -maxdepth 1 -type d -exec bash -c \"cd '{}' && git pull\" \\;")
	end,

	["up-secfix"] = function()
		os.execute("dnf5 up -y")
	end,

	["up"] = function ()
		handlers["up-mods"]()
		handlers["up-secfix"]()
	end,

	["start"] = function()
		os.execute("minetest --server --terminal --gameid minetest")
	end,

	["stop"] = function()
		os.execute("killall minetest")
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
