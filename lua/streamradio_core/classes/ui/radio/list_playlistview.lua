if not istable(CLASS) then
	StreamRadioLib.ReloadClasses()
	return
end

local BASE = CLASS:GetBaseClass()
local g_mat_sound = StreamRadioLib.GetPNGIcon("sound")

function CLASS:Create()
	BASE.Create(self)

	self.Playlist = {}
	self.EntryOpen = 0

	self.Path.Type = StreamRadioLib.TYPE_FOLDER
	self.Path = self.Path + function(this, k, v_new, v_old)
		if k ~= "Type" then return end

		local v = v_new or StreamRadioLib.TYPE_FOLDER
		local v_old = v_old or StreamRadioLib.TYPE_FOLDER

		if v_new ~= v then
			self.Path.Type = v
			return
		end

		self:SetNWInt("PathType", v)
		self:BuildList()
	end

	self.State = self:CreateListener({
		Error = false,
	}, function(this, k, v)
		self:SetNWBool("Error", v)
		self:QueueCall("CallErrorState")
	end)

	self:SetIDIcon(0, g_mat_sound)
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

function CLASS:OnItemClickInternal(button, value, buttonindex, ListX, ListY, i)
	if CLIENT and self.Network.Active then return end
	self:Play(value)
end

function CLASS:Play(value)
	if CLIENT then return end
	if not self.Network.Active then return end
	if not value then return end

	local name = value.name
	local url = value.url

	self.EntryOpen = math.Clamp(value.index or 1, 1, #self.Playlist)
	self:CallHook("OnPlay", name, url)
end

function CLASS:Stop()
	if CLIENT then return end
	if not self.Network.Active then return end

	self.EntryOpen = 0
	self:CallHook("OnStop")
end

function CLASS:CallErrorState()
	if self.State.Error then
		self:CallHook("OnError", self.Path.Value, self.Path.Type)
	else
		self:CallHook("OnErrorClose", self.Path.Value, self.Path.Type)
	end
end

function CLASS:UpdateErrorState()
	if CLIENT then return end
	self.State.Error = self.tmperror or false
end

function CLASS:BuildListInternal()
	if CLIENT then return end
	if not self.Network.Active then return end

	self:ClearData()
	self:ApplaDataFromDupe()

	self.State.Error = false
	self.tmperror = nil

	self:QueueCall("UpdateErrorState")

	if not self:IsVisible() then
		self:UpdateButtons()
		self:RestoreScrollPos()
		return
	end

	self.DupeData = nil

	if self.Path.Value == "" then
		self:UpdateButtons()
		self:RestoreScrollPos()
		return
	end

	self._read_playlist = nil
	self._read_curdata = {
		path = self.Path.Value,
		type = self.Path.Type,
	}

	StreamRadioLib.Filesystem.Read(self.Path.Value, self.Path.Type, function(success, data)
		if self._read_curdata.path ~= self.Path.Value then
			return
		end

		if self._read_curdata.type ~= self.Path.Type then
			return
		end

		if not success then
			self.tmperror = true
			return
		end

		self._read_playlist = data
		self:QueueCall("_BuildListInternalAsyc")
	end)
end

function CLASS:_BuildListInternalAsyc()
	if not self._read_playlist then
		return
	end

	if self._read_curdata.path ~= self.Path.Value then
		return
	end

	if self._read_curdata.type ~= self.Path.Type then
		return
	end

	self:ClearData()
	self:QueueCall("UpdateErrorState")

	self.Playlist = {}
	for i, v in ipairs(self._read_playlist) do
		local entry = {
			name = v.name,
			url = v.url,
			index = i,
		}

		local data = {}
		data.value = entry
		data.text = entry.name
		data.icon = 0

		self.Playlist[i] = entry
		self:AddData(data, true)
	end

	local len = #self.Playlist
	if len <= 0 then
		self.tmperror = true
		return
	end

	if len == 1 then
		local entry = self.Playlist[1]
		self:Play(entry)
	end

	self:UpdateButtons()
	self:QueueCall("RestoreScrollPos")
end

function CLASS:IsSingleItem()
	if CLIENT then
		return false
	end

	if not self.Playlist then
		return true
	end

	return #self.Playlist <= 1
end

function CLASS:GetFile()
	return self.Path.Value or "", self.Path.Type or StreamRadioLib.TYPE_FOLDER
end

function CLASS:SetFile(path, ty)
	if CLIENT and self.Network.Active then return end

	self.Path.Value = path or ""
	self.Path.Type = ty or StreamRadioLib.TYPE_FOLDER
end

function CLASS:PlayNext()
	if CLIENT and self.Network.Active then return end

	local len = #self.Playlist
	if len <= 1 then return end

	local index = self.EntryOpen + 1
	if index > len then
		index = 1
	end

	local value = self.Playlist[index]
	self:Play(value)
end

function CLASS:PlayPrevious()
	if CLIENT and self.Network.Active then return end

	local len = #self.Playlist
	if len <= 1 then return end

	local index = self.EntryOpen - 1
	if index <= 0 then
		index = len
	end

	local value = self.Playlist[index]
	self:Play(value)
end

function CLASS:ActivateNetworkedMode()
	BASE.ActivateNetworkedMode(self)
	if SERVER then
		self:SetNWInt("PathType", self.Path.Type)
		self:SetNWBool("Error", self.State.Error)
		return
	end

	self:SetNWVarProxy("PathType", function(this, nwkey, oldvar, newvar)
		self.Path.Type = newvar
	end)

	self:SetNWVarProxy("Error", function(this, nwkey, oldvar, newvar)
		self.State.Error = newvar
	end)

	self.Path.Type = self:GetNWInt("PathType", StreamRadioLib.TYPE_FOLDER)
	self.State.Error = self:GetNWBool("Error", false)
end

function CLASS:PreDupe(ent)
	local data = {}
	local path, ty = self:GetFile()

	data.Path = path
	data.PathType = ty

	data.Playlist = self.Playlist
	data.EntryOpen = self.EntryOpen

	return data
end

function CLASS:ApplaDataFromDupe()
	local data = self.DupeData
	if not data then return end

	local tmp = data.Playlist or {}
	table.SortByMember(tmp, "index", true)

	self.Playlist = {}
	for k, v in pairs(data.Playlist or {}) do
		local url = string.Trim(tostring(v.url or v.uri or v.link or v.source or v.path or ""))
		local name = string.Trim(tostring(v.name or v.title or ""))

		if url == "" then
			continue
		end

		if name == "" then
			name = url
		end

		if StreamRadioLib.IsBlockedCustomURL(url) then
			continue
		end

		local i = #self.Playlist + 1

		local entry = {
			name = name,
			url = url,
			index = i,
		}

		self.Playlist[i] = entry
	end

	self.EntryOpen = math.Clamp(data.EntryOpen or 1, 1, #self.Playlist)
	self:CallHook("OnDupePlaylistApply")
end

function CLASS:PostDupe(ent, dupedata)
	local path = dupedata.Path
	local type = dupedata.PathType

	self._read_curdata = {
		path = path,
		type = type,
	}

	StreamRadioLib.Filesystem.Read(path, type, function(success, data)
		if self._read_curdata.path ~= path then
			return
		end

		if self._read_curdata.type ~= type then
			return
		end

		if not success then
			self:SetFile("", type)
			self:CallHook("OnInvalidDupeFilepath")

			self.DupeData = dupedata
			self:ApplaDataFromDupe()
			return
		end

		if #data <= 0 then
			self:SetFile("", type)
			self:CallHook("OnInvalidDupeFilepath")

			self.DupeData = dupedata
			self:ApplaDataFromDupe()
			return
		end

		self:SetFile(path, type)

		self.DupeData = dupedata
		self:ApplaDataFromDupe()
	end)
end

if not istable(CLASS) then
	StreamRadioLib.ReloadClasses()
	return
end

local BASE = CLASS:GetBaseClass()
local g_mat_sound = StreamRadioLib.GetPNGIcon("sound")

function CLASS:Create()
	BASE.Create(self)

	self.Playlist = {}
	self.EntryOpen = 0

	self.Path.Type = StreamRadioLib.TYPE_FOLDER
	self.Path = self.Path + function(this, k, v_new, v_old)
		if k ~= "Type" then return end

		local v = v_new or StreamRadioLib.TYPE_FOLDER
		local v_old = v_old or StreamRadioLib.TYPE_FOLDER

		if v_new ~= v then
			self.Path.Type = v
			return
		end

		self:SetNWInt("PathType", v)
		self:BuildList()
	end

	self.State = self:CreateListener({
		Error = false,
	}, function(this, k, v)
		self:SetNWBool("Error", v)
		self:QueueCall("CallErrorState")
	end)

	self:SetIDIcon(0, g_mat_sound)
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

function CLASS:OnItemClickInternal(button, value, buttonindex, ListX, ListY, i)
	if CLIENT and self.Network.Active then return end
	self:Play(value)
end

function CLASS:Play(value)
	if CLIENT then return end
	if not self.Network.Active then return end
	if not value then return end

	local name = value.name
	local url = value.url

	self.EntryOpen = math.Clamp(value.index or 1, 1, #self.Playlist)
	self:CallHook("OnPlay", name, url)
end

function CLASS:Stop()
	if CLIENT then return end
	if not self.Network.Active then return end

	self.EntryOpen = 0
	self:CallHook("OnStop")
end

function CLASS:CallErrorState()
	if self.State.Error then
		self:CallHook("OnError", self.Path.Value, self.Path.Type)
	else
		self:CallHook("OnErrorClose", self.Path.Value, self.Path.Type)
	end
end

function CLASS:UpdateErrorState()
	if CLIENT then return end
	self.State.Error = self.tmperror or false
end

function CLASS:BuildListInternal()
	if CLIENT then return end
	if not self.Network.Active then return end

	self:ClearData()
	self:ApplaDataFromDupe()

	self.State.Error = false
	self.tmperror = nil

	self:QueueCall("UpdateErrorState")

	if not self:IsVisible() then
		self:UpdateButtons()
		self:RestoreScrollPos()
		return
	end

	self.DupeData = nil

	if self.Path.Value == "" then
		self:UpdateButtons()
		self:RestoreScrollPos()
		return
	end

	self._read_playlist = nil
	self._read_curdata = {
		path = self.Path.Value,
		type = self.Path.Type,
	}

	StreamRadioLib.Filesystem.Read(self.Path.Value, self.Path.Type, function(success, data)
		if self._read_curdata.path ~= self.Path.Value then
			return
		end

		if self._read_curdata.type ~= self.Path.Type then
			return
		end

		if not success then
			self.tmperror = true
			return
		end

		self._read_playlist = data
		self:QueueCall("_BuildListInternalAsyc")
	end)
end

function CLASS:_BuildListInternalAsyc()
	if not self._read_playlist then
		return
	end

	if self._read_curdata.path ~= self.Path.Value then
		return
	end

	if self._read_curdata.type ~= self.Path.Type then
		return
	end

	self:ClearData()
	self:QueueCall("UpdateErrorState")

	self.Playlist = {}
	for i, v in ipairs(self._read_playlist) do
		local entry = {
			name = v.name,
			url = v.url,
			index = i,
		}

		local data = {}
		data.value = entry
		data.text = entry.name
		data.icon = 0

		self.Playlist[i] = entry
		self:AddData(data, true)
	end

	local len = #self.Playlist
	if len <= 0 then
		self.tmperror = true
		return
	end

	if len == 1 then
		local entry = self.Playlist[1]
		self:Play(entry)
	end

	self:UpdateButtons()
	self:QueueCall("RestoreScrollPos")
end

function CLASS:IsSingleItem()
	if CLIENT then
		return false
	end

	if not self.Playlist then
		return true
	end

	return #self.Playlist <= 1
end

function CLASS:GetFile()
	return self.Path.Value or "", self.Path.Type or StreamRadioLib.TYPE_FOLDER
end

function CLASS:SetFile(path, ty)
	if CLIENT and self.Network.Active then return end

	self.Path.Value = path or ""
	self.Path.Type = ty or StreamRadioLib.TYPE_FOLDER
end

function CLASS:PlayNext()
	if CLIENT and self.Network.Active then return end

	local len = #self.Playlist
	if len <= 1 then return end

	local index = self.EntryOpen + 1
	if index > len then
		index = 1
	end

	local value = self.Playlist[index]
	self:Play(value)
end

function CLASS:PlayPrevious()
	if CLIENT and self.Network.Active then return end

	local len = #self.Playlist
	if len <= 1 then return end

	local index = self.EntryOpen - 1
	if index <= 0 then
		index = len
	end

	local value = self.Playlist[index]
	self:Play(value)
end

function CLASS:ActivateNetworkedMode()
	BASE.ActivateNetworkedMode(self)
	if SERVER then
		self:SetNWInt("PathType", self.Path.Type)
		self:SetNWBool("Error", self.State.Error)
		return
	end

	self:SetNWVarProxy("PathType", function(this, nwkey, oldvar, newvar)
		self.Path.Type = newvar
	end)

	self:SetNWVarProxy("Error", function(this, nwkey, oldvar, newvar)
		self.State.Error = newvar
	end)

	self.Path.Type = self:GetNWInt("PathType", StreamRadioLib.TYPE_FOLDER)
	self.State.Error = self:GetNWBool("Error", false)
end

function CLASS:PreDupe(ent)
	local data = {}
	local path, ty = self:GetFile()

	data.Path = path
	data.PathType = ty

	data.Playlist = self.Playlist
	data.EntryOpen = self.EntryOpen

	return data
end

function CLASS:ApplaDataFromDupe()
	local data = self.DupeData
	if not data then return end

	local tmp = data.Playlist or {}
	table.SortByMember(tmp, "index", true)

	self.Playlist = {}
	for k, v in pairs(data.Playlist or {}) do
		local url = string.Trim(tostring(v.url or v.uri or v.link or v.source or v.path or ""))
		local name = string.Trim(tostring(v.name or v.title or ""))

		if url == "" then
			continue
		end

		if name == "" then
			name = url
		end

		if StreamRadioLib.IsBlockedCustomURL(url) then
			continue
		end

		local i = #self.Playlist + 1

		local entry = {
			name = name,
			url = url,
			index = i,
		}

		self.Playlist[i] = entry
	end

	self.EntryOpen = math.Clamp(data.EntryOpen or 1, 1, #self.Playlist)
	self:CallHook("OnDupePlaylistApply")
end

function CLASS:PostDupe(ent, dupedata)
	local path = dupedata.Path
	local type = dupedata.PathType

	self._read_curdata = {
		path = path,
		type = type,
	}

	StreamRadioLib.Filesystem.Read(path, type, function(success, data)
		if self._read_curdata.path ~= path then
			return
		end

		if self._read_curdata.type ~= type then
			return
		end

		if not success then
			self:SetFile("", type)
			self:CallHook("OnInvalidDupeFilepath")

			self.DupeData = dupedata
			self:ApplaDataFromDupe()
			return
		end

		if #data <= 0 then
			self:SetFile("", type)
			self:CallHook("OnInvalidDupeFilepath")

			self.DupeData = dupedata
			self:ApplaDataFromDupe()
			return
		end

		self:SetFile(path, type)

		self.DupeData = dupedata
		self:ApplaDataFromDupe()
	end)
end
