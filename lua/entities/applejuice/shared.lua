ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Apple Juice"
ENT.Author = "SaDow4100"
ENT.Contact = "Steam"
ENT.Purpose = "A small carton of apple juice"
ENT.Instructions = "E" 
ENT.Category = "Food"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupModel()

	self.Entity:SetModel("models/FoodNHouseholdItems/juicesmall.mdl")
	
end