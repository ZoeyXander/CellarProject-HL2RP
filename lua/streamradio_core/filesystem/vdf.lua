local RADIOFS = RADIOFS
if not istable( RADIOFS ) then
	StreamRadioLib.Filesystem.Load()
	return
end

RADIOFS.name = "VDF"
RADIOFS.type = "vdf"
RADIOFS.extension = "vdf"
RADIOFS.icon = StreamRadioLib.GetPNGIcon("table")

RADIOFS.priority = 1000

function RADIOFS:Read(globalpath, vpath, callback)
	file.AsyncRead(globalpath, "DATA", function(fileName, gamePath, status, data)
		if status ~= FSASYNC_OK then
			callback(false, nil)
			return
		end

		local RawPlaylist = string.Trim(data or "")
		if RawPlaylist == "" then
			callback(true, {})
			return
		end

		local Playlist = util.KeyValuesToTable(RawPlaylist, false, true) or {}

		callback(true, Playlist)
	end)

	return true
end

function RADIOFS:Write(globalpath, vpath, data, callback)
	if not self:CreateDirForFile(globalpath) then
		callback(false)
		return false
	end

	local f = file.Open(globalpath, "w", "DATA")
	if not f then
		callback(false)
		return false
	end

	local DataString = util.TableToKeyValues(data)
	DataString = string.Trim(DataString)
	DataString = DataString .. "\n\n"

	f:Write(DataString)
	f:Close()

	callback(true)
	return true
end

local RADIOFS = RADIOFS
if not istable( RADIOFS ) then
	StreamRadioLib.Filesystem.Load()
	return
end

RADIOFS.name = "VDF"
RADIOFS.type = "vdf"
RADIOFS.extension = "vdf"
RADIOFS.icon = StreamRadioLib.GetPNGIcon("table")

RADIOFS.priority = 1000

function RADIOFS:Read(globalpath, vpath, callback)
	file.AsyncRead(globalpath, "DATA", function(fileName, gamePath, status, data)
		if status ~= FSASYNC_OK then
			callback(false, nil)
			return
		end

		local RawPlaylist = string.Trim(data or "")
		if RawPlaylist == "" then
			callback(true, {})
			return
		end

		local Playlist = util.KeyValuesToTable(RawPlaylist, false, true) or {}

		callback(true, Playlist)
	end)

	return true
end

function RADIOFS:Write(globalpath, vpath, data, callback)
	if not self:CreateDirForFile(globalpath) then
		callback(false)
		return false
	end

	local f = file.Open(globalpath, "w", "DATA")
	if not f then
		callback(false)
		return false
	end

	local DataString = util.TableToKeyValues(data)
	DataString = string.Trim(DataString)
	DataString = DataString .. "\n\n"

	f:Write(DataString)
	f:Close()

	callback(true)
	return true
end
