#!/usr/bin/lua

-- SPDX-License-Identifier: GPL-2.0
-- Copyright 2022-2024 - Fábio Rodrigues Ribeiro and contributors

function loadmodformat(name)
	return ("load_mod_%s = true"):format(name)
end

local handlers ={
	["bootstrap"] = function ()
		local list = {}
		local world = {}

		local function listadd(n, u)
			table.insert(list, {name = n, url = u})
		end

		listadd("accountmgr", "https://gitlab.com/rubenwardy/accountmgr.git")
		listadd("areas", "https://github.com/minetest-mods/areas.git")
		listadd("automobiles_pck", "https://github.com/APercy/automobiles_pck.git")
		listadd("biofuel", "https://github.com/Lokrates/Biofuel.git")
		listadd("bonemeal", "https://codeberg.org/tenplus1/bonemeal.git")
		listadd("digilines", "https://github.com/minetest-mods/digilines.git")
		listadd("digistuff", "https://cheapiesystems.com/git/digistuff")
		listadd("drawers", "https://github.com/minetest-mods/drawers.git")
		listadd("mesecons", "https://github.com/minetest-mods/mesecons.git")
		listadd("pipeworks", "https://github.com/mt-mods/pipeworks.git")
		listadd("void_chest", "https://github.com/MeseCraft/void_chest.git")
		listadd("worldedit", "https://github.com/Uberi/Minetest-WorldEdit.git")
		listadd("tpr", "https://github.com/minetest-mods/teleport-request.git")
		listadd("unified_inventory", "https://github.com/minetest-mods/unified_inventory.git")
		listadd("ethereal", "https://codeberg.org/tenplus1/ethereal")
		listadd("etherium_stuff", "https://gitlab.com/alerikaisattera/etherium_stuff.git")
		listadd("steampunk_blimp", "https://github.com/APercy/steampunk_blimp.git")
		listadd("airutils", "https://github.com/APercy/airutils.git")

		for i, item in ipairs(list) do
			table.insert(world, loadmodformat(item.name))
		end

		for i, item in ipairs(list) do
			os.execute(("git clone %s"):format(item.url))
		end

		local submodules ={
			"automobiles_beetle",
			"automobiles_buggy",
			"automobiles_catrelle",
			"automobiles_coupe",
			"automobiles_delorean",
			"automobiles_lib",
			"automobiles_motorcycle",
			"automobiles_roadster",
			"automobiles_trans_am",
			"automobiles_vespa",
			"mesecons_alias",
			"mesecons_blinkyplant",
			"mesecons_button",
			"mesecons_commandblock",
			"mesecons_delayer",
			"mesecons_detector",
			"mesecons_doors",
			"mesecons_extrawires",
			"mesecons_fpga",
			"mesecons_gamecompat",
			"mesecons_gates",
			"mesecons_hydroturbine",
			"mesecons_insulated",
			"mesecons_lamp",
			"mesecons_lightstone",
			"mesecons_luacontroller",
			"mesecons_materials",
			"mesecons_microcontroller",
			"mesecons_movestones",
			"mesecons_mvps",
			"mesecons_noteblock",
			"mesecons_pistons",
			"mesecons_powerplant",
			"mesecons_pressureplates",
			"mesecons_random",
			"mesecons_receiver",
			"mesecons_solarpanel",
			"mesecons_stickyblocks",
			"mesecons_switch",
			"mesecons_torch",
			"mesecons_walllever",
			"mesecons_wires",
			"worldedit_brush", 
			"worldedit_commands",
			"worldedit_gui",
			"worldedit_shortcommands"
		}

		for i, item in ipairs(submodules) do
			submodules[i] = loadmodformat(submodules[i])
		end

		-- Abre ou cria um arquivo chamado "exemplo.txt" no modo de escrita ("w")
		local arquivo = io.open("world.mt", "w")

		-- Verifica se o arquivo foi aberto com sucesso
		if arquivo then
			-- Escreve no arquivo
			arquivo:write("gameid = minetest\nworld_name =\n\n")
			arquivo:write(table.concat(world, "\n"))
			arquivo:write(table.concat(submodules, "\n"))

			-- Fecha o arquivo após terminar de escrever
			arquivo:close()

			print("world.mt criado com sucesso.")
		else
			print("Erro ao abrir o arquivo.")
		end
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
