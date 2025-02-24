local RADIOMDL = RADIOMDL
if not istable( RADIOMDL ) then
	StreamRadioLib.Model.LoadModelSettings()
	return
end

-- Wire Monitor, Big
RADIOMDL.model = "models/kobilica/wiremonitorbig.mdl"

RADIOMDL.SpawnAng = Angle(0, 0, 0)
RADIOMDL.FlatOnWall = true
RADIOMDL.SoundPosOffset = Vector(0.25, 0, 11.75)
RADIOMDL.SoundAngOffset = Angle(0, 0, 0)

RADIOMDL.DisplayAngles = Angle(0, 90, 90)

                              --      F,      R,      U
RADIOMDL.DisplayOffset    = Vector(0.25, -11.25,  24.25) -- Top Left
RADIOMDL.DisplayOffsetEnd = Vector(0.25,  11.25,   1.75) -- Bottom Right

RADIOMDL.DisplayWidth = 1400
RADIOMDL.DisplayHeight, RADIOMDL.DisplayScale = RADIOMDL:GetDisplayHeight(RADIOMDL.DisplayOffset, RADIOMDL.DisplayOffsetEnd, RADIOMDL.DisplayWidth)

RADIOMDL.FontSizes = {
--  Name 	= Size,	Weight, Parentname
	Header	= {45,	1000},
	Small	= {36,	700},
	Default	= {42,	700},
	Tooltip	= {42,	800},
	Big		= {50,	700},
}

function RADIOMDL:SetupGUI(ent, gui_controller, mainpanel)
	gui_controller:SetPos(0, 0)
	gui_controller:SetSize(self.DisplayWidth, self.DisplayHeight)

	mainpanel:SetSize(gui_controller:GetClientSize())

	local modelsetup = {}
	if CLIENT then
		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/header/text", "font", self.Fonts.Header)
		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/header/pretext", "font", self.Fonts.Header)
		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlists/button", "font", self.Fonts.Default)
		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlistview/button", "font", self.Fonts.Default)

		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/header", "font", self.Fonts.Header)
		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/controls/progressbar/label", "font", self.Fonts.Small)
		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/button", "font", self.Fonts.Big)

		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/spectrum/volume/progressbar/label", "font", self.Fonts.Default)
		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/spectrum/error/textbox", "font", self.Fonts.Big)
		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/spectrum/error/button", "font", self.Fonts.Big)

		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/error/textbox", "font", self.Fonts.Big)
		StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/error/button", "font", self.Fonts.Big)

		StreamRadioLib.SetSkinTableProperty(modelsetup, "tooltip", "font", self.Fonts.Tooltip)
	end

	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/header", "sizeh", 80)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/header", "sizeh", 80)

	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlists", "gridsize", {x = 2, y = 10})
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlistview", "gridsize", {x = 1, y = 10})
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlists/scrollbar", "sizew", 60)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlistview/scrollbar", "sizew", 60)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/sidebutton", "sizew", 100)

	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/spectrum/error/textbox/scrollbar", "sizew", 60)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/error/textbox/scrollbar", "sizew", 60)

	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/button", "sizeh", 90)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/player/spectrum/error/button", "sizeh", 80)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/error/button", "sizeh", 80)

	StreamRadioLib.SetSkinTableProperty(modelsetup, "", "cornersize", 0)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "", "borderwidth", 16)

	local shadow = 10
	local padding = 10
	local margin = 10

	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlists/button", "shadowwidth", shadow)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlistview/button", "shadowwidth", shadow)

	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlists/button", "padding", padding)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlistview/button", "padding", padding)

	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlists/button", "margin", margin)
	StreamRadioLib.SetSkinTableProperty(modelsetup, "main/browser/list-playlistview/button", "margin", margin)

	gui_controller:SetModelSetup(modelsetup)

	mainpanel:ForEachChildRecursive(function(panel, child)
		if child.SetShadowWidth and child:GetShadowWidth() == 5 then
			child:SetShadowWidth(shadow)
		end

		if child.SetPadding and child:GetPadding() == 5 then
			child:SetPadding(padding)
		end

		if child.SetMargin and child:GetMargin() == 5 then
			child:SetMargin(margin)
		end
	end)
end
