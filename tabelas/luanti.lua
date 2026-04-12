#!/usr/bin/env lua

local u = require "util_tables"
local c = ""
local canais = {
	["atcraft"] = { { animetrom = "" } },
	["bigferias"] = { { darcksama = "minetest-biglinux2.ddns.net:30003" } },
	["bigworld"] = { { darcksama = "minetest-biglinux2.ddns.net:30000" } },
	["brazucas"] = { { lunovox = "" } },
	["comitenerd"] = { { gustavo = "mine.comitenerd.com.br:30000" } },
	["joseworld_revolution"] = { { darcksama = "minetest-biglinux2.ddns.net:30002" } },
	["mercurio"] = { { ronoaldo = "mercurio.ronoaldo.dev.br:30000" } },
	["mercurio_beta"] = { { ronoaldo = "" } },
	["mercurio_dev"] = { { ronoaldo = "" } },
	["outhere"] = { { apercy = "132.226.251.210:30000" } },
	["chuia"] = { { chuia = "" } },
	["espertamente"] = { { espertamente = "minetest.espertamente.com.br:30000" } },
	["luizinhosrv"] = {{ luizinho_lfl = ""}}
}

-- 2. Definir o cabeçalho e formato da linha (TTY)
-- Larguras: Canal (12), Matrix (25), OFTC (15), RedeSul (12), Telegram (30)
--[[
local function h(qt) return ("%%-%ss"):format(qt) end
local valores = { h(20), h(34), h(34), h(34), h(34), h(34), h(34) }

local header_fmt = ("| %s |"):format(table.concat(valores, " | "))
]] --

local valores = {}

for i = 1, 7 do valores[i] = "%s" end

local header_fmt = ("%s;"):format(table.concat(valores, ";"))
print((header_fmt:format("Server",
	"Animetrom",
	"APercy",
	"Darcksama",
	"Gustavo",
	"lunovox",
	"ronoaldo",
	"luizinho_lfl"
)))

--[[
local function r(qt) return ("-"):rep(qt) end
valores = nil
valores = { r(22), r(36), r(36), r(36), r(36), r(36), r(36) }
print(("|%s|"):format(table.concat(valores, "|")))
]] --

-- 3. Iterar pelos canais ordenados e extrair valores das sub-tabelas

for _, nome in ipairs(u.nomes_ordenados(canais)) do
	local info = canais[nome]

	local row = {
		animetrom = c,
		apercy = c,
		darcksama = c,
		gustavo = c,
		lunovox = c,
		ronoaldo = c,
		luizinho_lfl = c
	}

	-- Varre a lista de objetos de cada canal
	for _, obj in ipairs(info) do for k, v in pairs(obj) do if v ~= "" then row[k] = v end end end

	print((header_fmt):format(nome,
		row.animetrom,
		row.apercy,
		row.darcksama,
		row.gustavo,
		row.lunovox,
		row.ronoaldo,
		row.luizinho_lfl
	))
end
