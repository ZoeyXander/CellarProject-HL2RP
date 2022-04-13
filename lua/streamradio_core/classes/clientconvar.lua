if not istable(CLASS) then
	StreamRadioLib.ReloadClasses()
	return
end

local BASE = CLASS:GetBaseClass()

local g_types = {
	["string"] = {
		get = function(this, cv)
			return cv:GetString()
		end,

		set = function(this, cv, val)
			cv:SetString(tostring(val or ""))
		end,

		panel_function = function(this, mainpanel, ...)
			return mainpanel:AddControl("textbox", {
				label = this:GetPanellabel(),
				command = this:GetCMD(),
			})
		end,
	},

	["float"] = {
		get = function(this, cv)
			local val = cv:GetFloat()
			val = math.Clamp(val, this:GetMin(), this:GetMax())

			return val
		end,

		set = function(this, cv, val)
			local val = tonumber(val or 0) or 0
			val = math.Clamp(val, this:GetMin(), this:GetMax())

			cv:SetFloat(val)
		end,

		panel_function = function(this, mainpanel, ...)
			return mainpanel:AddControl("slider", {
				type = "float",
				label = this:GetPanellabel(),
				command = this:GetCMD(),
				min = this:GetMin(),
				max = this:GetMax(),
			})
		end,
	},

	["int"] = {
		get = function(this, cv)
			local val = cv:GetInt()
			val = math.Clamp(val, this:GetMin(), this:GetMax())

			return val
		end,

		set = function(this, cv, val)
			local val = tonumber(val or 0) or 0
			val = math.Clamp(val, this:GetMin(), this:GetMax())

			cv:SetInt(val)
		end,

		panel_function = function(this, mainpanel, ...)
			return mainpanel:AddControl("slider", {
				label = this:GetPanellabel(),
				command = this:GetCMD(),
				min = this:GetMin(),
				max = this:GetMax(),
			})
		end,
	},

	["bool"] = {
		get = function(this, cv)
			return cv:GetBool()
		end,

		set = function(this, cv, val)
			cv:SetBool(tobool(val) and (val ~= ""))
		end,

		panel_function = function(this, mainpanel, ...)
			return mainpanel:AddControl("checkbox", {
				label = this:GetPanellabel(),
				command = this:GetCMD(),
			})
		end,
	},

	["numpad"] = {
		get = function(this, cv)
			local val = cv:GetInt()
			val = math.Clamp(val, 0, 255)

			return val
		end,

		set = function(this, cv, val)
			local val = tonumber(val or 0) or 0
			val = math.Clamp(val, 0, 255)

			cv:SetInt(val)
		end,

		panel_function = function(this, mainpanel, ...)
			return mainpanel:AddControl("Numpad", {
				label = this:GetPanellabel(),
				command = this:GetCMD(),
			})
		end,
	},

	["dropdown"] = {
		get = function(this, cv)
			local options = this:GetOptions()
			local value = cv:GetString()

			if not options[value] then
				return ""
			end

			return value
		end,

		set = function(this, cv, val)
			local options = this:GetOptions()
			local val = tostring(val or "")

			if not options[val] then
				val = ""
			end

			cv:SetString(value)
		end,

		panel_function = function(this, mainpanel, ...)
			local tmp = {}
			local options = this:GetOptions()
			local cmd = this:GetCMD()

			local count = 0
			for k,v in pairs(options) do
				tmp[v] = {[cmd] = k}
				count = count + 1
			end

			return mainpanel:AddControl("ListBox", {
				label = this:GetPanellabel(),
				options = tmp,
				height = math.min(count * 20 + 1, 225)
			})
		end,
	},
}

function CLASS:Create()
	BASE.Create(self)

	self.cmd = ""
	self.defaultvalue = ""
	self.save = true
	self.userdata = false
	self.helptext = ""
	self.type = "string"
	self.hidden = false
	self.disabled = false
	self.options = {}

	self._convar = nil
end

function CLASS:SetCMD(var)
	if self._convar then return end
	self.cmd = tostring(var or "")
end

function CLASS:GetCMD()
	return self.cmd or ""
end

function CLASS:SetDefault(var)
	if self._convar then return end
	self.defaultvalue = tostring(var or "")
end

function CLASS:GetDefault()
	return self.defaultvalue or ""
end

function CLASS:SetSave(var)
	if self._convar then return end
	self.save = var or false
end

function CLASS:GetSave()
	return self.save or false
end

function CLASS:SetUserdata(var)
	if self._convar then return end
	self.userdata = var or false
end

function CLASS:GetUserdata()
	return self.userdata or false
end

function CLASS:SetDefault(var)
	if self._convar then return end
	self.defaultvalue = tostring(var or "")
end

function CLASS:GetDefault()
	return self.defaultvalue or ""
end

function CLASS:SetHelptext(var)
	if self._convar then return end
	self.helptext = tostring(var or "")
end

function CLASS:GetHelptext()
	return self.helptext or ""
end

function CLASS:SetOptions(var)
	if self._convar then return end
	self.options = var or {}
end

function CLASS:GetOptions()
	return self.options or {}
end

function CLASS:SetHidden(var)
	if self._convar then return end
	self.hidden = var or false
end

function CLASS:GetHidden()
	return self.hidden or false
end

function CLASS:SetDisabled(var)
	if self._convar then return end
	self.disabled = var or false
end

function CLASS:GetDisabled()
	return self.disabled or false
end

function CLASS:SetPanellabel(var)
	if self._convar then return end
	self.panellabel = tostring(var or "")
end

function CLASS:GetPanellabel()
	return self.panellabel or ""
end

function CLASS:GetConvar()
	return self._convar
end

function CLASS:SetType(var)
	if self._convar then return end

	var = tostring(var or "")
	var = string.lower(var)
	var = string.Trim(var)

	if var == "" then
		var = "string"
	end

	self.type = var
end

function CLASS:GetType(var)
	return self.type or ""
end

function CLASS:GetTypeData()
	local t = self:GetType()
	local data = g_types[t] or g_types["string"] or {}

	return data
end

function CLASS:GetMax()
	return self.MaxValue or 0
end

function CLASS:GetMin()
	return self.MinValue or 0
end

function CLASS:SetMax(var)
	if self._convar then return end
	self.MaxValue = var or 0
end

function CLASS:SetMin(var)
	if self._convar then return end
	self.MinValue = var or 0
end

function CLASS:GetValue(...)
	if not self._convar then
		return nil
	end

	local td = self:GetTypeData()
	local getter = td.get

	if not getter then
		return nil
	end

	return getter(self, self._convar, ...)
end

function CLASS:SetValue(...)
	if not self._convar then
		return nil
	end

	local td = self:GetTypeData()
	local setter = td.set

	if not setter then
		return nil
	end

	return setter(self, self._convar, ...)
end

function CLASS:BuildPanel(mainpanel, ...)
	if not self._convar then
		return nil
	end

	if not IsValid(mainpanel) then
		return nil
	end

	local td = self:GetTypeData()
	local panel_function = td.panel_function

	if not panel_function then
		return nil
	end

	if self:GetHidden() then
		return nil
	end

	local panel = panel_function(self, mainpanel, ...)
	if not IsValid(panel) then
		return nil
	end

	if self:GetDisabled() then
		panel:SetDisabled(true)
	end

	return panel
end

function CLASS:Setup()
	if SERVER then return end

	local cmd = self:GetCMD()

	self._convar = CreateClientConVar(cmd, self:GetDefault(), self:GetSave(), self:GetUserdata(), self:GetHelptext())
	if not self._convar then return end

	self:AddCallback()
end

function CLASS:RemoveCallback()
	if SERVER then return end
	if not self._convar then return end

	local cmd = self:GetCMD()
	cvars.RemoveChangeCallback(cmd, cmd .. "_callback")
end

function CLASS:AddCallback()
	if SERVER then return end
	if not self._convar then return end

	self:RemoveCallback()

	local oldvalue = self:GetValue()

	local cmd = self:GetCMD()
	cvars.AddChangeCallback(cmd, function()
		if not IsValid(self) then return end

		local newvalue = self:GetValue()
		if oldvalue == newvalue then return end

		self:CallHook("OnChange", oldvalue, newvalue)

		oldvalue = newvalue
	end, cmd .. "_callback")
end

function CLASS:Remove()
	self:RemoveCallback()
	self._convar = nil
	BASE.Remove(self)
end
