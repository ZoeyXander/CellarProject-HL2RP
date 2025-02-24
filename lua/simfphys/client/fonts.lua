surface.CreateFont( "simfphysworldtip", {font="coolvetica", size=24, weight=500, antialias=true, additive=false} )

surface.CreateFont( "simfphysfont", {
	font = "Verdana",
	extended = false,
	size = ScrH() >= 900 and (ScrH() >= 1080 and 20 or 18) or 12,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "simfphysfont2", {font = "Verdana",
	extended = false,
	size = (ScrH() >= 900 and (ScrH() >= 1080 and 20 or 18) or 12) * 2.8,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "simfphysfont3", {
	font = "Verdana",
	extended = false,
	size = (ScrH() >= 900 and (ScrH() >= 1080 and 20 or 18) or 12) * 1.3,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "simfphysfont4", {
	font = "Verdana",
	extended = false,
	size = (ScrH() >= 900 and (ScrH() >= 1080 and 20 or 18) or 12) * 6,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "DSimfphysFont", {
	font = "Arial", 
	extended = false,
	size = 22,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "DSimfphysFont_hint", {
	font = "Arial", 
	extended = false,
	size = 21,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = true,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "SimfphysFont_seatswitcher", {
	font = "Verdana",
	extended = false,
	size = 16,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )