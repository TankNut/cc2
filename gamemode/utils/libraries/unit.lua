module("unit", package.seeall)

function Convert(tab, val, from, to)
	local convertFrom = tab[from]
	local convertTo = tab[to]


	val = isnumber(convertFrom) and val / convertFrom or convertFrom.From(val)

	return isnumber(convertTo) and val * convertTo or convertTo.To(val)
end

-- Default unit: Inches
LengthTable = {
	-- Source
	u = 1 / 0.75,
	-- Metric
	mm = 25.4,
	cm = 2.54,
	dm = 0.254,
	m = 0.0254,
	km = 0.0000254,
	-- Imperial
	["in"] = 1,
	ft = 1 / 12,
	yd = 1 / 36,
	mi = 1 / 63360,
	nmi = 127 / 9260000
}

function Length(val, from, to)
	return Convert(LengthTable, val, from, to)
end

-- Default unit: Kilograms
MassTable = {
	-- Metric
	mg = 1000000,
	g = 1000,
	kg = 1,
	t = 1000,
	-- Imperial
	oz = 1 / 0.028349523125,
	lb = 1 / 0.45359237
}

function Mass(val, from, to)
	return Convert(MassTable, val, from, to)
end

-- Default unit: Kelvin
TemperatureTable = {
	-- Metric
	C = {
		From = function(val) return val + 273.15 end,
		To = function(val) return val - 273.15 end
	},
	K = 1,
	-- Imperial
	F = {
		From = function(val) return (val - 32) * (5 / 9) + 273.15 end,
		To = function(val) return (val - 273.15) * (9 / 5) + 32 end
	}
}

function Temperature(val, from, to)
	return Convert(TemperatureTable, val, from, to)
end
