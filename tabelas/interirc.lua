#!/usr/bin/env lua

local u = require "util_tables"
local c = " "
local tnw = "#tanaweb"
local ii = "#interirc"
local canais = {
	["#brasil"] = {
		{ brasport = c },
		{ brirc = c },
		{ brnet = c },
		{ dalnet = c },
		{ discord = c },
		{ freenode = c },
		{ hubforeverorg = c },
		{ hybridirc = c },
		{ interirc = c },
		{ irchighway = c },
		{ ircmania = c },
		{ jacksoownet = c },
		{ liberachat = c },
		{ matrix = "#brasil:interirc.net" },
		{ oftc = "#br" },
		{ onezeroonesystems = c },
		{ pylink = c },
		{ quakenet = c },
		{ radiocast = c },
		{ ravenx = c },
		{ redejampa = c },
		{ redesul = "#brasil" },
		{ snoonet = "#br" },
		{ svipchat = c },
		{ telegram = "https://t.me/brasil_interirc" },
		{ unirc = c },
		{ virtualife = c },
		{ whatsapp = c },
		{ xmpp = c }
	},
	["#warez"] = {
		{ matrix = "#informatica:interirc.net" },
		{ oftc = "#informatica" },
		{ redesul = "#warez" },
		{ snoonet = "#informatica" },
		{ virtualife = c }
	},
	[tnw] = {
		{ brasport = tnw },
		{ brirc = tnw },
		{ brnet = tnw },
		{ dalnet = tnw },
		{ freenode = tnw },
		{ hubforeverorg = tnw },
		{ hybridirc = tnw },
		{ interirc = tnw },
		{ irchighway = tnw },
		{ ircmania = tnw },
		{ jacksoownet = tnw },
		{ liberachat = tnw },
		{ matrix = "#tanaweb:interirc.net" },
		{ oftc = tnw },
		{ onezeroonesystems = tnw },
		{ pylink = tnw },
		{ quakenet = tnw },
		{ radiocast = tnw },
		{ ravenx = tnw },
		{ redejampa = tnw },
		{ redesul = tnw },
		{ svipchat = tnw },
		{ snoonet = tnw },
		{ telegram = "https://t.me/canaltanaweb" },
		{ unirc = tnw },
		{ virtualife = tnw },
	},
	["#linux"] = { { redesul = "#linux" } },
	["##linux"] = {},
	["#InterIRC"] = {
		{ brasport = ii },
		{ brirc = ii },
		{ brnet = ii },
		{ dalnet = ii },
		{ discord = ii },
		{ freenode = ii },
		{ hubforeverorg = ii },
		{ hybridirc = ii },
		{ interirc = ii },
		{ irchighway = ii },
		{ ircmania = ii },
		{ jacksoownet = ii },
		{ liberachat = ii },
		{ matrix = "#interirc:interirc.net" },
		{ oftc = ii },
		{ onezeroonesystems = ii },
		{ pylink = ii },
		{ quakenet = ii },
		{ radiocast = ii },
		{ ravenx = ii },
		{ redejampa = ii },
		{ redesul = ii },
		{ snoonet = ii },
		{ svipchat = ii },
		{ unirc = ii },
		{ virtualife = ii },
		{ whatsapp = ii },
	},
	["#BBB"] = {},
	["#SertaoVibe"] = {},
	["#GamaGame"] = {},
	["#RadioPassatempo"] = {},
	["#IRCMania"] = {},
	["#RadioLightHits"] = {},
	["#Metal_Puro"] = {}
}

-- 2. Definir o cabeçalho e formato da linha (TTY)
-- Larguras: Canal (12), Matrix (25), OFTC (15), RedeSul (12), Telegram (30)

local h16, h30 = u.md_h(16), u.md_h(30)
local header_fmt = u.md_s({ h16, h16, h16, h16, h16, h16, h16, h16, h16, h16, h16, h16, h16, h16, h16, h16, h30, h30, h30,
	h30 })
valores = nil

print((header_fmt:format("InterIRC",
	"BrasPort",
	"BRIrc",
	"Dalnet",
	"IRCHighway",
	"IRCMania",
	"JacksoowNET",
	"OFTC",
	"Quakenet",
	"RadioCast",
	"RavenX",
	"RedeJampa",
	"RedeSul",
	"Snoonet",
	"sVIPChat",
	"Virtualife",
	"Telegram",
	"WhatsApp",
	"XMPP",
	"Matrix"
)))

local function r(qt) return ("-"):rep(qt) end
r18, r32 = r(18), r(32)
valores = { r18, r18, r18, r18, r18, r18, r18, r18, r18, r18, r18, r18, r18, r18, r18, r18, r32, r32, r32, r32 }
print(("|%s|"):format(table.concat(valores, "|")))

-- 3. Iterar pelos canais ordenados e extrair valores das sub-tabelas

for _, nome in ipairs(u.nomes_ordenados(canais)) do
	local info = canais[nome] or {}

	local row = {
		brasport = c,
		brirc = c,
		dalnet = c,
		irchighway = c,
		ircmania = c,
		jacksoownet = c,
		oftc = c,
		quakenet = c,
		radiocast = c,
		ravenx = c,
		redejampa = c,
		redesul = c,
		snoonet = c,
		svipchat = c,
		virtualife = c,
		telegram = c,
		whatsapp = c,
		xmpp = c,
		matrix = c
	}

	-- Varre a lista de objetos de cada canal
	for _, obj in ipairs(info) do for k, v in pairs(obj) do if v ~= "" then row[k] = v end end end

	print((header_fmt):format(nome,
		row.brasport,
		row.brirc,
		row.dalnet,
		row.irchighway,
		row.ircmania,
		row.jacksoownet,
		row.oftc,
		row.quakenet,
		row.radiocast,
		row.ravenx,
		row.redejampa,
		row.redesul,
		row.snoonet,
		row.svipchat,
		row.virtualife,
		row.telegram,
		row.whatsapp,
		row.xmpp,
		row.matrix
	))
end
