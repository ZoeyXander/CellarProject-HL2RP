AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )


ENT.Spawnable		            	 =  false
ENT.AdminSpawnable		             =  false     

ENT.PrintName		                 =  ""        
ENT.Author			                 =  ""      
ENT.Contact			                 =  ""      

ENT.GBOWNER                          =  nil            
ENT.MAX_RANGE                        = 0
ENT.DELAY                            = 0
ENT.SOUND                            = ""
ENT.Burst                            = 0 
function ENT:Initialize()
     if (SERVER) then
		 self.FILTER                           = {}
         self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	     self:SetSolid( SOLID_NONE )
	     self:SetMoveType( MOVETYPE_NONE )
	     self:SetUseType( ONOFF_USE ) 
		 self.Bursts = 0
		 self.CURRENTRANGE = 0
		 self.GBOWNER = self:GetVar("GBOWNER")
		 self.SOUND = self:GetVar("SOUND")
		 self.DEFAULT_PHYSFORCE  = self:GetVar("DEFAULT_PHYSFORCE")
		 self.DEFAULT_PHYSFORCE_PLYAIR  = self:GetVar("DEFAULT_PHYSFORCE_PLYAIR")
	     self.DEFAULT_PHYSFORCE_PLYGROUND = self:GetVar("DEFAULT_PHYSFORCE_PLYGROUND")

     end
end

function ENT:Think(ply)		
     if (SERVER) then
     if !self:IsValid() then return end
	 local pos = self:GetPos()
	 for k, v in pairs(ents.FindInSphere(pos,self.MAX_RANGE)) do
		 if (v:IsValid() or v:IsPlayer()) and (v.forcefielded==false or v.forcefielded==nil) then
			 local i = 0
			 while i < v:GetPhysicsObjectCount() do
				 local dmg = DamageInfo()
			         dmg:SetDamage(math.random(25,100))
			         dmg:SetDamageType(DMG_RADIATION)
			         dmg:SetAttacker(self.GBOWNER)
				 phys = v:GetPhysicsObjectNum(i)
				 if (phys:IsValid()) then
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE
					 local dist = (pos - v:GetPos()):Length()
					 local relation = math.Clamp((self.CURRENTRANGE - dist) / self.CURRENTRANGE, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE 
					 phys:AddAngleVelocity(Vector(F_ang, F_ang, F_ang) * relation)
					 phys:AddVelocity(F_dir)
					 if(GetConVar("sw_shockwave_unfreeze"):GetInt() >= 1) then
						 phys:Wake()
						 phys:EnableMotion(true)
						 constraint.RemoveAll(v)
					 end
				 end
				 if (v:IsPlayer()) then
					
					 v:SetMoveType( MOVETYPE_WALK )
				     v:TakeDamageInfo(dmg)
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE_PLYAIR
					 local dist = (pos - v:GetPos()):Length()
					 local relation = math.Clamp((self.CURRENTRANGE - dist) / self.CURRENTRANGE, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE_PLYAIR
					 v:SetVelocity( F_dir )		
				 end

				 if (v:IsPlayer()) and v:IsOnGround() then
					 v:SetMoveType( MOVETYPE_WALK )
				     v:TakeDamageInfo(dmg)
					 local mass = phys:GetMass()
					 local F_ang = self.DEFAULT_PHYSFORCE_PLYGROUND
					 local dist = (pos - v:GetPos()):Length()
					 local relation = math.Clamp((self.CURRENTRANGE - dist) / self.CURRENTRANGE, 0, 1)
					 local F_dir = (v:GetPos() - pos):GetNormal() * self.DEFAULT_PHYSFORCE_PLYGROUND	 
					 v:SetVelocity( F_dir )		
				 end
				 if (v:IsNPC()) then
					 v:TakeDamageInfo(dmg)
				 end
			 i = i + 1
			 end
		 end
 	 end
	 self.Bursts = self.Bursts + 1
	 if (self.Bursts >= self.Burst) then
	     self:Remove()
	 end
	 self:NextThink(CurTime() + self.DELAY)
	 return true
	 end
end

function ENT:Draw()
     return false
end