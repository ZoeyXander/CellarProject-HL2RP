if not istable(CLASS) then
	StreamRadioLib.ReloadClasses()
	return
end

local BASE = CLASS:GetBaseClass()

local g_listcache = CLASS:GetGlobalVar("list_listcache", {})
CLASS:SetGlobalVar("list_listcache", g_listcache)

function CLASS:Create()
	BASE.Create(self)

	self.ScrollBar = self:AddPanelByClassname("scrollbar", true)
	self.ScrollBar:SetName("scrollbar")
	self.ScrollBar:SetSkinIdentifyer("scrollbar")
	self.ScrollBar:SetSize(30, 30)

	self.ScrollBar.OnScroll = function()
		self:UpdateButtons()
	end

	self.Hash = self:CreateListener({
		hex = "",
		crc = 0,
		raw = {},
	}, function(this, k, v, oldv)
		self:SetNWHash("Hash", self.Hash)

		if SERVER then return end
		self:NetworkButtons()
	end)

	self.Buttons = {}
	self.Data = {}
	self.IconIDs = {}

	self.Layout.IsHorizontal = false
	self.Layout.ListGridX = 2
	self.Layout.ListGridY = 6

	self.Layout = self.Layout + function(this, k, v)
		if k == "ListGridX" then
			self:RecreateButtons()
			self:SetNWInt("ListGridX", v)
		end

		if k == "ListGridY" then
			self:RecreateButtons()
			self:SetNWInt("ListGridY", v)
		end

		if k == "Margin" then
			self:UpdateButtons()
		end

		if k == "IsHorizontal" then
			self:UpdateButtons()
			self:SetNWBool("IsHorizontal", v)
		end

		if k == "Visible" then
			if v then
				self:NetworkButtons()
			end
		end
	end

	self.Size = self.Size + function(this, k, v)
		self:UpdateButtons()
	end

	self:RecreateButtons()

	if CLIENT then
		self:NetReceive("data", function(this, id, len, ply)
			self._waitfordata = nil
			local count = net.ReadUInt(16)
			local data = {}

			for index = 1, count do
				local text, icon = StreamRadioLib.Net.ReceiveListEntry( )

				table.insert(data, {
					text = text,
					icon = icon,
				})
			end

			local hash = self:GetHashID()
			local datahash = self:GetHashID(self:GetHashFromData(data))

			self:SetCache(data, datahash)

			if datahash == hash then
				self:SetData(data)
			end
		end)
	else
		self:NetReceive("datarequest", function(this, id, len, ply)
			self.NetworkPlayerList = self.NetworkPlayerList or {}
			self.NetworkPlayerList[ply] = true

			self:NetworkButtons()
		end)
	end
end

function CLASS:PerformLayout(...)
	BASE.PerformLayout(self, ...)

	local scrollbar = self.ScrollBar

	if not IsValid(scrollbar) then
		return
	end

	local ishorizontal = self:GetHorizontal()
	local w, h = self:GetClientSize()

	if ishorizontal then
		local barwidth = scrollbar:GetHeight()
		scrollbar:SetSize(w, barwidth)
		scrollbar:SetPos(0, h - barwidth)
	else
		local barwidth = scrollbar:GetWidth()
		scrollbar:SetSize(barwidth, h)
		scrollbar:SetPos(w - barwidth, 0)
	end

	scrollbar:AutoSetHorizontal()
end

function CLASS:ClearButtons()
	for k, v in pairs(self.Buttons or {}) do
		v:Remove()
	end

	self.Buttons = {}
	self._iscleared = true
	self._curhash = nil
	self._loadcounter = nil

	local scrollbar = self.ScrollBar
	if IsValid(scrollbar) then
		scrollbar:SetVisible(false)
	end
end

function CLASS:GetButton(buttonindex)
	if not self.Buttons then
		return nil
	end

	return self.Buttons[buttonindex]
end

function CLASS:GetOrCreateButton(buttonindex)
	self.Buttons = self.Buttons or {}
	local button = self.Buttons[buttonindex]

	if not IsValid(button) then
		button = self:AddPanelByClassname("button", true)
		button:SetName("button" .. buttonindex)
		button:SetSkinIdentifyer("button")

		self:CallHook("OnItemCreate", button, buttonindex)
		self.Buttons[buttonindex] = button
	end

	return button
end

function CLASS:RecreateButtons()
	self:ClearButtons()
	self:UpdateButtons()
end

function CLASS:UpdateButtons()
	self:QueueCall("UpdateButtonsInternal")
end

function CLASS:NetworkButtons()
	self:QueueCall("NetworkButtonsInternal")
end

function CLASS:GetCache(hashstr)
	hashstr = hashstr or ""
	if hashstr == "" then return nil end

	local data = g_listcache[hashstr] or {}
	if #data <= 0 then return nil end

	return data
end

function CLASS:SetCache(data, hashstr)
	hashstr = hashstr or ""
	if hashstr == "" then return end

	g_listcache[hashstr] = data
end

function CLASS:NetworkButtonsInternal()
	if not self:IsVisible() then return end

	if CLIENT then
		local hash = self:GetHashID()
		local cache = self:GetCache(hash)

		if cache then
			-- Workaround a glitch on first use on spawn
			if self._firstcachedone then
				self:SetData(cache)
				return
			end

			self._firstcachedone = true
		end

		self:NetSend("datarequest")

		self.LastButtonNW = RealTime()
		self._loadcounter = nil
		self._waitfordata = true

		return
	end

	local playerlist = table.GetKeys(self.NetworkPlayerList or {})
	local data = self.Data or {}

	self.NetworkPlayerList = nil
	if #playerlist <= 0 then return end

	self:NetSend("data", function()
		net.WriteUInt(#data, 16)

		for k, v in pairs(data) do
			StreamRadioLib.Net.SendListEntry(v.text, v.icon)
		end

	end, "Send", playerlist)

end

function CLASS:Think()
	if SERVER then return end
	if not self:IsVisible() then return end
	if not self.Network.Active then return end
	if self._waitfordata then return end

	local lastnw = self.LastButtonNW or RealTime()
	local delta = RealTime() - lastnw

	local count = (self._loadcounter or 0) + 1
	local mindelta = ((count * 0.5) ^ 2)

	if delta < mindelta then return end
	self.LastButtonNW = RealTime()

	local load = false

	if not load and self._iscleared then
		load = true
	end

	if not load and not self._curhash then
		load = true
	end

	if not load then
		local h1 = self:GetHashID()
		local h2 = self:GetHashID(self._curhash)

		if not h1 then
			load = true
		end

		if not h2 then
			load = true
		end

		if h1 ~= h2 then
			load = true
		end
	end

	if not load then
		self._loadcounter = nil
		return
	end

	self:NetworkButtonsInternal()
	self._loadcounter = count
end

function CLASS:UpdateButtonsInternal()
	local scrollbar = self.ScrollBar
	local data = self.Data or {}
	local ListSizeX = self.Layout.ListGridX
	local ListSizeY = self.Layout.ListGridY

	self:CalcHash()

	if not IsValid(scrollbar) then
		self:ClearButtons()
		return
	end

	if ListSizeX <= 0 then
		self:ClearButtons()
		return
	end

	if ListSizeY <= 0 then
		self:ClearButtons()
		return
	end

	local listsize = #data

	if listsize <= 0 then
		self:ClearButtons()
		return
	end

	self._iscleared = false
	self._curhash = self:GetHashFromData(data)
	self._loadcounter = nil

	local ishorizontal = scrollbar:GetHorizontal()
	local listviewsize = ListSizeX * ListSizeY
	local startindex = 0
	local scroll = 0
	local maxscroll = 0
	local barwidth = 0

	local w, h = self:GetClientSize()
	local margin = self:GetMargin()

	local buttonarea_w = w
	local buttonarea_h = h

	if ishorizontal then
		maxscroll = listsize / ListSizeY - ListSizeX
		maxscroll = math.ceil(maxscroll)

		scrollbar:SetMaxScroll(maxscroll)
		scroll = scrollbar:GetScroll()

		startindex = listviewsize / ListSizeX * scroll
		barwidth = scrollbar:GetHeight() + margin
		buttonarea_h = buttonarea_h - barwidth
	else
		maxscroll = listsize / ListSizeX - ListSizeY
		maxscroll = math.ceil(maxscroll)

		scrollbar:SetMaxScroll(maxscroll)
		scroll = scrollbar:GetScroll()

		startindex = listviewsize / ListSizeY * scroll
		barwidth = scrollbar:GetWidth() + margin
		buttonarea_w = buttonarea_w - barwidth
	end

	local hasscrollbar = scrollbar:GetMaxScroll() > 0
	scrollbar:SetVisible(hasscrollbar)

	if not hasscrollbar then
		if ishorizontal then
			barwidth = scrollbar:GetHeight() + margin
			buttonarea_h = buttonarea_h + barwidth
		else
			barwidth = scrollbar:GetWidth() + margin
			buttonarea_w = buttonarea_w + barwidth
		end
	end

	local endindex = startindex + listviewsize
	local buttonindex = 0

	local buttonsize_w = (buttonarea_w - (margin * (ListSizeX - 1))) / ListSizeX
	local buttonsize_h = (buttonarea_h - (margin * (ListSizeY - 1))) / ListSizeY

	for i = startindex + 1, endindex do
		local buttonposindex = buttonindex
		buttonindex = buttonindex + 1

		local button = self:GetOrCreateButton(buttonindex)
		if not IsValid(button) then
			continue
		end

		local v = data[i] or {}

		local text = v.text or ""
		local icon = v.icon or -1
		local value = v.value
		local hasdata = text ~= "" or value ~= nil

		if not hasdata then
			button:Remove()
			continue
		end

		local ListX = 0
		local ListY = 0

		if ishorizontal then
			ListX = buttonposindex % ListSizeY
			ListY = buttonposindex / ListSizeY
		else
			ListX = buttonposindex % ListSizeX
			ListY = buttonposindex / ListSizeX
		end

		ListX = math.floor(ListX)
		ListY = math.floor(ListY)

		button:SetText(text)
		button:SetIcon(self:GetIDIcon(icon))
		button:SetAlign(TEXT_ALIGN_RIGHT)
		button:SetTextAlign(TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		button:SetSize(buttonsize_w, buttonsize_h)

		local buttonsizemargin_w = buttonsize_w + margin
		local buttonsizemargin_h = buttonsize_h + margin

		if ishorizontal then
			button:SetPos(buttonsizemargin_w * ListY, buttonsizemargin_h * ListX)
		else
			button:SetPos(buttonsizemargin_w * ListX, buttonsizemargin_h * ListY)
		end

		button._listvaluedata = v

		button.DoClick = function(this)
			self:CallHook("OnItemClickInternal", this, value, buttonindex, ListX, ListY, i)
			self:CallHook("OnItemClick", this, value, buttonindex, ListX, ListY, i)
		end

		self:CallHook("OnItemUpdate", button, value, buttonindex, ListX, ListY, i)
	end
end

function CLASS:GetHashFromData(data)
	data = data or {}
	local datastring = {}
	local count = 0

	for k, v in ipairs(data) do
		local text = v.text or ""
		local icon = v.icon or -1

		table.insert(datastring, "{[" .. text .. "][" .. icon .. "][" .. k .. "]}")
		count = count + 1
	end

	datastring = table.concat(datastring, "\n")
	datastring = datastring .. "\nlen: {[" .. count .. "][" .. #datastring .. "]}"

	local hash = StreamRadioLib.Hash(datastring)
	return hash
end

function CLASS:CalcHash()
	if CLIENT then return end
	if not self.Network.Active then return end

	local hash = self:GetHashFromData(self.Data)
	self.Hash.raw = hash.raw or {}
	self.Hash.hex = hash.hex or ""
	self.Hash.crc = hash.crc or 0
end

function CLASS:SetData(data)
	self.Data = {}

	for k, v in pairs(data or {}) do
		self:AddData(v, true)
	end

	self:UpdateButtons()
end

function CLASS:AddData(data, noupdate)
	self.Data = self.Data or {}

	local v = {
		text = data.text or "",
		value = data.value,
		icon = data.icon or -1,
	}

	table.insert(self.Data, v)

	if not noupdate then
		self:UpdateButtons()
	end
end

function CLASS:UpdateData(index, data, noupdate)
	if not self.Data then return end
	if not self.Data[index] then return end

	self.Data[index] = {
		text = data.text or "",
		value = data.value,
		icon = data.icon or -1,
	}

	if not noupdate then
		self:UpdateButtons()
	end
end

function CLASS:ClearData()
	self.Data = {}
	self:RecreateButtons()
end

function CLASS:SetHorizontal(horizontal)
	self.Layout.IsHorizontal = horizontal or false
end

function CLASS:GetHorizontal()
	return self.Layout.IsHorizontal or false
end

function CLASS:GetScrollBar()
	return self.ScrollBar
end

function CLASS:ForEachButton(func, ...)
	self:ForEachChild(function(this, panel)
		if panel == self.ScrollBar then return end
		func(this, panel)
	end, ...)
end

function CLASS:SetGridSize(x, y)
	x = x or 0
	y = y or 0

	if x < 0 then
		x = 0
	end

	if y < 0 then
		y = 0
	end

	self.Layout.ListGridX = x
	self.Layout.ListGridY = y
end

function CLASS:GetGridSize()
	return self.Layout.ListGridX or 0, self.Layout.ListGridY or 0
end

function CLASS:GetMaxButtonCount()
	return self.Layout.ListGridX * self.Layout.ListGridY
end

function CLASS:ActivateNetworkedMode()
	BASE.ActivateNetworkedMode(self)
	self.ScrollBar:ActivateNetworkedMode()

	if SERVER then
		self:SetNWInt("ListGridX", self.Layout.ListGridX)
		self:SetNWInt("ListGridY", self.Layout.ListGridY)
		self:SetNWBool("IsHorizontal", self:GetHorizontal())

		self:CalcHash()
		return
	end

	self:SetGridSize(self:GetNWInt("ListGridX", 0), self:GetNWInt("ListGridY", 0))
	self:SetHorizontal(self:GetNWBool("IsHorizontal", false))

	local hash = self:GetNWHash("Hash") or {}
	self.Hash.raw = hash.raw or {}
	self.Hash.hex = hash.hex or ""
	self.Hash.crc = hash.crc or 0

	self:SetNWVarProxy("ListGridX", function(this, nwkey, oldvar, newvar)
		self.Layout.ListGridX = newvar
	end)

	self:SetNWVarProxy("ListGridY", function(this, nwkey, oldvar, newvar)
		self.Layout.ListGridY = newvar
	end)

	self:SetNWVarProxy("IsHorizontal", function(this, nwkey, oldvar, newvar)
		self:SetHorizontal(newvar)
	end)

	self:SetNWHashProxy("Hash", function(this, nwkey, oldvar, newvar)
		self.Hash.raw = newvar.raw or {}
		self.Hash.hex = newvar.hex or ""
		self.Hash.crc = newvar.crc or 0
	end)

	self:NetworkButtons()
	self:UpdateButtons()
end

function CLASS:SetIDIcon(ID, icon)
	ID = ID or -1
	if ID < 0 then return end

	self.IconIDs[ID] = icon or ID
	self:UpdateButtons()
end

function CLASS:GetIDIcon(ID)
	ID = ID or -1
	if ID < 0 then return end

	return self.IconIDs[ID]
end

function CLASS:GetHash()
	local curhash = self.Hash or {}

	if CLIENT and self.Network.Active then
		curhash = self:GetNWHash("Hash") or {}
	end

	local hash = {
		raw = curhash.raw or {},
		hex = curhash.hex or "",
		crc = curhash.crc or 0,
	}

	return hash
end

function CLASS:GetHashID(hash)
	hash = hash or self:GetHash() or {}

	local hex = hash.hex or ""
	local crc = hash.crc or 0

	if hex == "" then return "" end
	if crc == 0 then return "" end

	return "[" .. hex .. "]_[" .. crc .. "]"
end

function CLASS:OnModelSetup(setup)
	BASE.OnModelSetup(self, setup)

	if setup.gridsize then
		local s = setup.gridsize
		local w = s.width or s.w or s.x or s[1] or 0
		local h = s.height or s.y or s[2] or 0

		self:SetGridSize(w, h)
	end
end
