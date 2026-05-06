local function md_h(qt) return ("%%-%ss"):format(qt) end
local function md_s(valores) return ("| %s |"):format(table.concat(valores, " | ")) end

local function nomes_ordenados(canais)
	local nomes = {}
	for nome in pairs(canais) do table.insert(nomes, nome) end
	table.sort(nomes)
	return nomes
end

return {
	md_h = md_h,
	md_s = md_s,
	nomes_ordenados = nomes_ordenados
}
