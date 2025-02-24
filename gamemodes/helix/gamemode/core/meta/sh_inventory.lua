
--[[--
Holds items within a grid layout.

Inventories are an object that contains `Item`s in a grid layout. Every `Character` will have exactly one inventory attached to
it, which is the only inventory that is allowed to hold bags - any item that has its own inventory (i.e a suitcase). Inventories
can be owned by a character, or it can be individually interacted with as a standalone object. For example, the container plugin
attaches inventories to props, allowing for items to be stored outside of any character inventories and remain "in the world".
]]
-- @classmod Inventory

local META = ix.meta.inventory or ix.middleclass("ix_inventory")

META.slots = META.slots or {}
META.w = META.w or 4
META.h = META.h or 4
META.vars = META.vars or {}
META.receivers = META.receivers or {}

--- Returns a string representation of this inventory
-- @realm shared
-- @treturn string String representation
-- @usage print(ix.item.inventories[1])
-- > "inventory[1]"
function META:__tostring()
	return "inventory[" .. (self.id or 0) .. "]"
end

--- Initializes the inventory with the provided arguments.
-- @realm shared
-- @internal
-- @number id The `Inventory`'s database ID.
-- @number width The inventory's width.
-- @number height The inventory's height.
function META:Initialize(id, width, height)
	self.id = id
	self.w = width
	self.h = height

	self.slots = {}
	self.vars = {}
	self.receivers = {}
end

--- Returns this inventory's database ID. This is guaranteed to be unique.
-- @realm shared
-- @treturn number Unique ID of inventory
function META:GetID()
	return self.id or 0
end

--- Sets the grid size of this inventory.
-- @internal
-- @realm shared
-- @number width New width of inventory
-- @number height New height of inventory
function META:SetSize(width, height)
	self.w = width
	self.h = height
end

--- Returns the grid size of this inventory.
-- @realm shared
-- @treturn number Width of inventory
-- @treturn number Height of inventory
function META:GetSize()
	return self.w, self.h
end

-- this is pretty good to debug/develop function to use.
function META:Print(printPos)
	for k, v in pairs(self:GetItems()) do
		local str = k .. ": " .. v.name

		if (printPos) then
			str = str .. " (" .. v.gridX .. ", " .. v.gridY .. ")"
		end

		print(str)
	end
end

--- Searches the inventory to find any stacked items.
-- A common problem with developing, is that items will sometimes error out, or get corrupt.
-- Sometimes, the server knows things you don't while developing live
-- This function can be helpful for getting rid of those pesky errors.
-- @realm shared
function META:FindError()
	for _, v in pairs(self:GetItems()) do
		if (v.width == 1 and v.height == 1) then
			continue
		end

		print("Finding error: " .. v.name)
		print("Item Position: " .. v.gridX, v.gridY)

		for x = v.gridX, v.gridX + v.width - 1 do
			for y = v.gridY, v.gridY + v.height - 1 do
				local item = self.slots[x][y]

				if (item and item.id != v.id) then
					print("Error Found: " .. item.name)
				end
			end
		end
	end
end

--- Prints out the id, width, height, slots and each item in each slot of an `Inventory`, used for debugging.
-- @realm shared
function META:PrintAll()
	print("------------------------")
		print("INVID", self:GetID())
		print("INVSIZE", self:GetSize())

		if (self.slots) then
			for x = 1, self.w do
				for y = 1, self.h do
					local item = self.slots[x] and self.slots[x][y]
					if (item and item.id) then
						print(item.name .. "(" .. item.id .. ")", x, y)
					end
				end
			end
		end

		print("INVVARS")
		PrintTable(self.vars or {})
	print("------------------------")
end

--- Returns the player that owns this inventory.
-- @realm shared
-- @treturn[1] Player Owning player
-- @treturn[2] nil If no connected player owns this inventory
function META:GetOwner()
	for _, v in ipairs(player.GetAll()) do
		if (v:GetCharacter() and v:GetCharacter().id == self.owner) then
			return v
		end
	end
end

--- Sets the player that owns this inventory.
-- @realm shared
-- @player owner The player to take control over the inventory.
-- @bool fullUpdate Whether or not to update the inventory immediately to the new owner.
function META:SetOwner(owner, fullUpdate)
	if (type(owner) == "Player" and owner:GetNetVar("char")) then
		owner = owner:GetNetVar("char")
	elseif (!isnumber(owner)) then
		return
	end

	if (SERVER) then
		if (fullUpdate) then
			for _, v in ipairs(player.GetAll()) do
				if (v:GetNetVar("char") == owner) then
					self:Sync(v, true)

					break
				end
			end
		end

		local query = mysql:Update("ix_inventories")
			query:Update("character_id", owner)
			query:Where("inventory_id", self:GetID())
		query:Execute()
	end

	self.owner = owner
end

--- Checks whether a player has access to an inventory
-- @realm shared
-- @internal
-- @player client Player to check access for
-- @treturn bool Whether or not the player has access to the inventory
function META:OnCheckAccess(client)
	local bAccess = false

	for _, v in ipairs(self:GetReceivers()) do
		if (v == client) then
			bAccess = true
			break
		end
	end

	return bAccess
end

--- Checks whether or not an `Item` can fit into the `Inventory` starting from `x` and `y`.
-- Internally used by FindEmptySlot, in most cases you are better off using that.
-- This function will search if all of the slots within `x + width` and `y + width` are empty,
-- ignoring any space the `Item` itself already occupies.
-- @realm shared
-- @internal
-- @number x The beginning x coordinate to search for.
-- @number y The beginning y coordiate to search for.
-- @number w The `Item`'s width.
-- @number h The `Item`'s height.
-- @item[opt=nil] item2 An `Item`, if any, to ignore when searching.
function META:CanItemFit(x, y, w, h, item2)
	local canFit = true

	for x2 = 0, w - 1 do
		for y2 = 0, h - 1 do
			local item = (self.slots[x + x2] or {})[y + y2]

			if ((x + x2) > self.w or item) then
				if (item2) then
					if (item and item.id == item2.id) then
						continue
					end
				end

				canFit = false
				break
			end
		end

		if (!canFit) then
			break
		end
	end

	return canFit
end


--- Returns the amount of slots currently filled in the Inventory.
-- @realm shared
-- @treturn number The amount of slots currently filled.
function META:GetFilledSlotCount()
	local count = 0

	for x = 1, self.w do
		for y = 1, self.h do
			if ((self.slots[x] or {})[y]) then
				count = count + 1
			end
		end
	end

	return count
end

--- Finds an empty slot of a specified width and height.
-- In most cases, to check if an `Item` can actually fit in the `Inventory`,
-- as if it can't, it will just return `nil`.
--
-- FindEmptySlot will loop through all the slots for you, as opposed to `CanItemFit`
-- which you specify an `x` and `y` for.
-- this will call CanItemFit anyway.
-- If you need to check if an item will fit *exactly* at a position, you want CanItemFit instead.
-- @realm shared
-- @number w The width of the `Item` you are trying to fit.
-- @number h The height of the `Item` you are trying to fit.
-- @bool onlyMain Whether or not to search any bags connected to this `Inventory`
-- @treturn[1] number x The `x` coordinate that the `Item` can fit into.
-- @treturn[1] number y The `y` coordinate that the `Item` can fit into.
-- @treturn[2] number x The `x` coordinate that the `Item` can fit into.
-- @treturn[2] number y The `y` coordinate that the `Item` can fit into.
-- @treturn[2] Inventory bagInv If the item was in a bag, it will return the inventory it was in.
-- @see CanItemFit
function META:FindEmptySlot(w, h, onlyMain)
	w = w or 1
	h = h or 1

	if (w > self.w or h > self.h) then
		return
	end

	for y = 1, self.h - (h - 1) do
		for x = 1, self.w - (w - 1) do
			if (self:CanItemFit(x, y, w, h)) then
				return x, y
			end
		end
	end

	if (onlyMain != true) then
		local bags = self:GetBags()

		if (#bags > 0) then
			for _, invID in ipairs(bags) do
				local bagInv = ix.item.inventories[invID]

				if (bagInv) then
					local x, y = bagInv:FindEmptySlot(w, h)

					if (x and y) then
						return x, y, bagInv
					end
				end
			end
		end
	end
end

--- Returns the item that currently exists within `x` and `y` in the `Inventory`.
-- Items that have a width or height greater than 0 occupy more than 1 x and y.
-- @realm shared
-- @number x The `x` coordindate to search in.
-- @number y The `y` coordinate to search in.
-- @treturn number x The `x` coordinate that the `Item` is located at.
-- @treturn number y The `y` coordinate that the `Item` is located at.
function META:GetItemAt(x, y)
	if (self.slots and self.slots[x]) then
		return self.slots[x][y]
	end
end

--- Removes an item from the inventory.
-- @realm shared
-- @number id The item instance ID to remove
-- @bool[opt=false] bNoReplication Whether or not the item's removal should not be replicated
-- @bool[opt=false] bNoDelete Whether or not the item should not be fully deleted
-- @bool[opt=false] bTransferring Whether or not the item is being transferred to another inventory
-- @treturn number The X position that the item was removed from
-- @treturn number The Y position that the item was removed from
function META:Remove(id, bNoReplication, bNoDelete, bTransferring)
	local x2, y2

	for x = 1, self.w do
		if (self.slots[x]) then
			for y = 1, self.h do
				local item = self.slots[x][y]

				if (item and item.id == id) then
					self.slots[x][y] = nil

					x2 = x2 or x
					y2 = y2 or y
				end
			end
		end
	end

	if (SERVER and !bNoReplication) then
		local receivers = self:GetReceivers()

		if (istable(receivers)) then
			net.Start("ixInventoryRemove")
				net.WriteUInt(id, 32)
				net.WriteUInt(self:GetID(), 32)
			net.Send(receivers)
		end

		-- we aren't removing the item - we're transferring it to another inventory
		if (!bTransferring) then
			hook.Run("InventoryItemRemoved", self, ix.item.instances[id])
		end

		if (!bNoDelete) then
			local item = ix.item.instances[id]

			if (item and item.OnRemoved) then
				item:OnRemoved()
			end

			local query = mysql:Delete("ix_items")
				query:Where("item_id", id)
			query:Execute()

			ix.item.instances[id] = nil
		end
	end

	return x2, y2
end

--- Adds a player as a receiver on this `Inventory`
-- Receivers are players who will be networked the items inside the inventory.
--
-- Calling this will *not* automatically sync it's current contents to the client.
-- All future contents will be synced, but not anything that was not synced before this is called.
--
-- This function does not check the validity of `client`, therefore if `client` doesn't exist, it will error.
-- @realm shared
-- @player client The player to add as a receiver.
function META:AddReceiver(client)
	self.receivers[client] = true
end

--- The opposite of `AddReceiver`.
-- This function does not check the validity of `client`, therefore if `client` doesn't exist, it will error.
-- @realm shared
-- @player client The player to remove from the receiver list.
function META:RemoveReceiver(client)
	self.receivers[client] = nil
end

--- Get all of the receivers this `Inventory` has.
-- Receivers are players who will be networked the items inside the inventory.
--
-- This function will automatically sort out invalid players for you.
-- @realm shared
-- @treturn table result The players who are on the server and allowed to see this table.
function META:GetReceivers()
	local result = {}

	if (self.receivers) then
		for k, _ in pairs(self.receivers) do
			if (IsValid(k) and k:IsPlayer()) then
				result[#result + 1] = k
			end
		end
	end

	return result
end

--- Returns a count of a *specific* `Item`s in the `Inventory`
-- @realm shared
-- @string uniqueID The Unique ID of the item.
-- @bool onlyMain Whether or not to exclude bags that are present from the search.
-- @treturn number The amount of `Item`s this inventory has.
-- @usage local curHighest, winner = 0, false
-- for client, character in ix.util.GetCharacters() do
--  local itemCount = character:GetInventory():GetItemCount('water', false)
--  if itemCount > curHighest then
--   curHighest = itemCount
--   winner = character
--  end
-- end
-- -- Finds the thirstiest character on the server and returns their Character ID or false if no character has water.
function META:GetItemCount(uniqueID, onlyMain)
	local i = 0

	for _, v in pairs(self:GetItems(onlyMain)) do
		if (v.uniqueID == uniqueID) then
			i = i + 1
		end
	end

	return i
end

--- Returns a table of all `Item`s in the `Inventory` by their Unique ID.
-- Not to be confused with `GetItemsByID` or `GetItemByID` which take in an Item Instance's ID instead.
-- @realm shared
-- @string uniqueID The Unique ID of the item.
-- @bool onlyMain Whether or not to exclude bags that are present from the search.
-- @treturn number The table of specified `Item`s this inventory has.
function META:GetItemsByUniqueID(uniqueID, onlyMain)
	local items = {}

	for _, v in pairs(self:GetItems(onlyMain)) do
		if (v.uniqueID == uniqueID) then
			items[#items + 1] = v
		end
	end

	return items
end

--- Returns a table of `Item`s by their base.
-- @realm shared
-- @string baseID The base to search for.
-- @bool bOnlyMain Whether or not to exclude bags that are present from the search.
function META:GetItemsByBase(baseID, bOnlyMain)
	local items = {}

	for _, v in pairs(self:GetItems(bOnlyMain)) do
		if (v.base == baseID) then
			items[#items + 1] = v
		end
	end

	return items
end

--- Get an item by it's specific Database ID.
-- @realm shared
-- @number id The ID to search for.
-- @bool onlyMain Whether or not to exclude bags that are present from the search.
-- @treturn item The item if it exists.
function META:GetItemByID(id, onlyMain)
	for _, v in pairs(self:GetItems(onlyMain)) do
		if (v.id == id) then
			return v
		end
	end
end

--- Get a table of `Item`s by their specific Database ID.
-- It's important to note that while in 99% of cases,
-- items will have a unique Database ID, developers or random GMod weirdness could
-- cause a second item with the same ID to appear, even though, `ix.item.instances` will only store one of those.
-- The inventory only stores a reference to the `ix.item.instance` ID, not the memory reference itself.
-- @realm shared
-- @number id The ID to search for.
-- @bool onlyMain Whether or not to exclude bags that are present from the search.
-- @treturn item The item if it exists.
function META:GetItemsByID(id, onlyMain)
	local items = {}

	for _, v in pairs(self:GetItems(onlyMain)) do
		if (v.id == id) then
			items[#items + 1] = v
		end
	end

	return items
end

-- This function may pretty heavy.

--- Returns a table of all the items that an `Inventory` has.
-- @realm shared
-- @bool onlyMain Whether or not to exclude bags from this search.
-- @treturn table The items this `Inventory` has.
function META:GetItems(onlyMain)
	local items = {}

	for _, v in pairs(self.slots) do
		for _, v2 in pairs(v) do
			if (istable(v2) and !items[v2.id]) then
				items[v2.id] = v2

				v2.data = v2.data or {}
				local isBag = (((v2.base == "base_bags") or v2.isBag) and v2.data.id)

				if (isBag and isBag != self:GetID() and onlyMain != true) then
					local bagInv = ix.item.inventories[isBag]

					if (bagInv) then
						local bagItems = bagInv:GetItems()

						table.Merge(items, bagItems)
					end
				end
			end
		end
	end

	return items
end

-- This function may pretty heavy.
--- Returns a table of all the items that an `Inventory` has.
-- @realm shared
-- @bool onlyMain Whether or not to exclude bags from this search.
-- @treturn table The items this `Inventory` has.
function META:GetBags()
	local invs = {}

	for _, v in pairs(self.slots) do
		for _, v2 in pairs(v) do
			if (istable(v2) and v2.data) then
				local isBag = (((v2.base == "base_bags") or v2.isBag) and v2.data.id)

				if (!table.HasValue(invs, isBag)) then
					if (isBag and isBag != self:GetID()) then
						invs[#invs + 1] = isBag
					end
				end
			end
		end
	end

	return invs
end
--- Returns the item with the given unique ID (e.g `"handheld_radio"`) if it exists in this inventory.
-- This method checks both
-- this inventory, and any bags that this inventory has inside of it.
-- @realm shared
-- @string targetID Unique ID of the item to look for
-- @tab[opt] data Item data to check for
-- @treturn[1] Item Item that belongs to this inventory with the given criteria
-- @treturn[2] bool `false` if the item does not exist
-- @see HasItems
-- @see HasItemOfBase
-- @usage local item = inventory:HasItem("handheld_radio")
--
-- if (item) then
-- 	-- do something with the item table
-- end
function META:HasItem(targetID, data)
	local items = self:GetItems()

	for _, v in pairs(items) do
		if (v.uniqueID == targetID) then
			if (data) then
				local itemData = v.data
				local bFound = true

				for dataKey, dataVal in pairs(data) do
					if (itemData[dataKey] != dataVal) then
						bFound = false
						break
					end
				end

				if (!bFound) then
					continue
				end
			end

			return v
		end
	end

	return false
end

--- Checks whether or not the `Inventory` has a table of items.
-- This function takes a table with **no** keys and runs in order of first item > last item,
--this is due to the usage of the `#` operator in the function.
--
-- @realm shared
-- @tab targetIDs A table of `Item` Unique ID's.
-- @treturn[1] bool true Whether or not the `Inventory` has all of the items.
-- @treturn[1] table targetIDs Your provided targetIDs table, but it will be empty.
-- @treturn[2] bool false
-- @treturn[2] table targetIDs Table consisting of the items the `Inventory` did **not** have.
-- @usage local itemFilter = {'water', 'water_sparkling'}
-- if not Entity(1):GetCharacter():GetInventory():HasItems(itemFilter) then return end
-- -- Filters out if this player has both a water, and a sparkling water.
function META:HasItems(targetIDs)
	local items = self:GetItems()
	local count = #targetIDs -- assuming array
	targetIDs = table.Copy(targetIDs)

	for _, v in pairs(items) do
		for k, targetID in ipairs(targetIDs) do
			if (v.uniqueID == targetID) then
				table.remove(targetIDs, k)
				count = count - 1

				break
			end
		end
	end

	return count <= 0, targetIDs
end

--- Whether or not an `Inventory` has an item of a base, optionally with specified data.
-- This function has an optional `data` argument, which will take a `table`.
-- it will match if the data of the item is correct or not.
--
-- Items which are a base will automatically have base_ prefixed to their Unique ID, if you are having
-- trouble finding your base, that is probably why.
-- @realm shared
-- @string baseID The Item Base's Unique ID.
-- @tab[opt] data The Item's data to compare against.
-- @treturn[1] item The first `Item` of `baseID` that is found and there is no `data` argument or `data` was matched.
-- @treturn[2] false If no `Item`s of `baseID` is found or the `data` argument, if specified didn't match.
-- @usage local bHasWeaponEquipped = Entity(1):GetCharacter():GetInventory():HasItemOfBase('base_weapons', {['equip'] = true})
-- if bHasWeaponEquipped then
--  Entity(1):Notify('One gun is fun, two guns is Woo-tastic.')
-- end
-- -- Notifies the player that they should get some more guns.
function META:HasItemOfBase(baseID, data)
	local items = self:GetItems()

	for _, v in pairs(items) do
		if (v.base == baseID) then
			if (data) then
				local itemData = v.data
				local bFound = true

				for dataKey, dataVal in pairs(data) do
					if (itemData[dataKey] != dataVal) then
						bFound = false
						break
					end
				end

				if (!bFound) then
					continue
				end
			end

			return v
		end
	end

	return false
end

if (SERVER) then
	--- Sends a specific slot to a character.
	-- This will *not* send all of the slots of the `Item` to the character, items can occupy multiple slots.
	--
	-- This will call `OnSendData` on the Item using all of the `Inventory`'s receivers.
	--
	-- This function should *not* be used to sync an entire inventory, if you need to do that, use `AddReceiver` and `Sync`.
	-- @realm server
	-- @internal
	-- @number x The Inventory x position to send.
	-- @number y The Inventory y position to send.
	-- @item[opt] item The item to send, if any.
	-- @see AddReceiver
	-- @see Sync
	function META:SendSlot(x, y, item)
		local receivers = self:GetReceivers()
		local sendData = item and item.data and !table.IsEmpty(item.data) and item.data or {}

		net.Start("ixInventorySet")
			net.WriteUInt(self:GetID(), 32)
			net.WriteUInt(x, 6)
			net.WriteUInt(y, 6)
			net.WriteString(item and item.uniqueID or "")
			net.WriteUInt(item and item.id or 0, 32)
			net.WriteUInt(self.owner or 0, 32)
			net.WriteTable(sendData)
		net.Send(receivers)

		if (item) then
			for _, v in pairs(receivers) do
				item:Call("OnSendData", v)
			end
		end
	end

	--- Sets whether  or not an `Inventory` should save.
	-- This will prevent an `Inventory` from updating in the Database, if the inventory is already saved,
	-- it will not be deleted when unloaded.
	-- @realm server
	-- @bool bNoSave Whether or not the Inventory should save.
	function META:SetShouldSave(bNoSave)
		self.noSave = bNoSave
	end

	--- Gets whether or not an `Inventory` should save.
	-- Inventories that are marked to not save will not update in the Database, if they inventory is already saved,
	-- it will not be deleted when unloaded.
	-- @realm server
	-- @treturn[1] bool Returns the field `noSave`.
	-- @treturn[2] bool Returns true if the field `noSave` is not registered to this inventory.
	function META:GetShouldSave()
		return self.noSave or true
	end

	--- Add an item to the inventory.
	-- @realm server
	-- @param uniqueID The item unique ID (e.g `"handheld_radio"`) or instance ID (e.g `1024`) to add to the inventory
	-- @number[opt=1] quantity The quantity of the item to add
	-- @tab data Item data to add to the item
	-- @number[opt=nil] x The X position for the item
	-- @number[opt=nil] y The Y position for the item
	-- @bool[opt=false] noReplication Whether or not the item's addition should not be replicated
	-- @treturn[1] bool Whether the add was successful or not
	-- @treturn[1] string The error, if applicable
	-- @treturn[2] number The X position that the item was added to
	-- @treturn[2] number The Y position that the item was added to
	-- @treturn[2] number The inventory ID that the item was added to
	function META:Add(uniqueID, quantity, data, x, y, noReplication)
		quantity = quantity or 1

		if (quantity < 1) then
			return false, "noOwner"
		end

		if (!isnumber(uniqueID) and quantity > 1) then
			for _ = 1, quantity do
				local bSuccess, error = self:Add(uniqueID, 1, data)

				if (!bSuccess) then
					return false, error
				end
			end

			return true
		end

		local client = self.GetOwner and self:GetOwner() or nil
		local item = isnumber(uniqueID) and ix.item.instances[uniqueID] or ix.item.list[uniqueID]
		local targetInv = self
		local bagInv

		if (!item) then
			return false, "invalidItem"
		end

		if (isnumber(uniqueID)) then
			local oldInvID = item.invID

			if (!x and !y) then
				x, y, bagInv = self:FindEmptySlot(item.width, item.height)
			end

			if (bagInv) then
				targetInv = bagInv
			end

			-- we need to check for owner since the item instance already exists
			if (!item.bAllowMultiCharacterInteraction and IsValid(client) and client:GetCharacter() and
				item:GetPlayerID() == client:SteamID64() and item:GetCharacterID() != client:GetCharacter():GetID()) then
				return false, "itemOwned"
			end

			if (hook.Run("CanTransferItem", item, ix.item.inventories[0], targetInv) == false) then
				return false, "notAllowed"
			end

			if (x and y) then
				targetInv.slots[x] = targetInv.slots[x] or {}
				targetInv.slots[x][y] = true

				item.gridX = x
				item.gridY = y
				item.invID = targetInv:GetID()

				for x2 = 0, item.width - 1 do
					local index = x + x2

					for y2 = 0, item.height - 1 do
						targetInv.slots[index] = targetInv.slots[index] or {}
						targetInv.slots[index][y + y2] = item
					end
				end

				if (!noReplication) then
					targetInv:SendSlot(x, y, item)
				end

				if (!self.noSave) then
					local query = mysql:Update("ix_items")
						query:Update("inventory_id", targetInv:GetID())
						query:Update("x", x)
						query:Update("y", y)
						query:Where("item_id", item.id)
					query:Execute()
				end

				hook.Run("InventoryItemAdded", ix.item.inventories[oldInvID], targetInv, item)

				return x, y, targetInv:GetID()
			else
				return false, "noFit"
			end
		else
			if (!x and !y) then
				x, y, bagInv = self:FindEmptySlot(item.width, item.height)
			end

			if (bagInv) then
				targetInv = bagInv
			end

			if (hook.Run("CanTransferItem", item, ix.item.inventories[0], targetInv) == false) then
				return false, "notAllowed"
			end

			if (x and y) then
				for x2 = 0, item.width - 1 do
					local index = x + x2

					for y2 = 0, item.height - 1 do
						targetInv.slots[index] = targetInv.slots[index] or {}
						targetInv.slots[index][y + y2] = true
					end
				end

				local characterID
				local playerID

				if (self.owner) then
					local character = ix.char.loaded[self.owner]

					if (character) then
						characterID = character.id
						playerID = character.steamID
					end
				end

				ix.item.Instance(targetInv:GetID(), uniqueID, data, x, y, function(newItem)
					newItem.gridX = x
					newItem.gridY = y

					for x2 = 0, newItem.width - 1 do
						local index = x + x2

						for y2 = 0, newItem.height - 1 do
							targetInv.slots[index] = targetInv.slots[index] or {}
							targetInv.slots[index][y + y2] = newItem
						end
					end

					if (!noReplication) then
						targetInv:SendSlot(x, y, newItem)
					end

					hook.Run("InventoryItemAdded", nil, targetInv, newItem)
				end, characterID, playerID)

				return x, y, targetInv:GetID()
			else
				return false, "noFit"
			end
		end
	end

	function META:Sync(receiver, fullUpdate)
		local slots = {}

		for x, items in pairs(self.slots) do
			for y, item in pairs(items) do
				if (istable(item) and item.gridX == x and item.gridY == y) then
					local data = table.Copy(item.data)
					data["T"] = nil

					slots[#slots + 1] = {x, y, item.uniqueID, item.id, data}
				end
			end
		end

		net.Start("ixInventorySync")
			net.WriteTable(slots)
			net.WriteUInt(self:GetID(), 32)
			net.WriteUInt(self.w, 6)
			net.WriteUInt(self.h, 6)
			net.WriteType(self.owner)
			net.WriteTable(self.vars or {})
		net.Send(receiver)

		for _, v in pairs(self:GetItems()) do
			v:Call("OnSendData", receiver)
		end
	end
end

ix.meta.inventory = META
