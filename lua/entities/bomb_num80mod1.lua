AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "Number 80 Model 1"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/Num80Mod1.mdl"
ENT.Effect                           =  "cloudmaker_ground"             
ENT.EffectAir                        =  "cloudmaker_ground"
ENT.EffectWater                      =  "water_huge"
ENT.ExplosionSound                   =  "explosions/gbomb_3.mp3"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound                  =  "buttons/button14.wav"     

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  true
ENT.UseRandomSounds                  =  false
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  20000
ENT.PhysForce                        =  2000
ENT.ExplosionRadius                  =  2000
ENT.SpecialRadius                    =  3000
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  100
ENT.MaxDelay                         =  0                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  2000
ENT.ArmDelay                         =  0.1   
ENT.Timer                            =  0

ENT.Shocktime                        = 0
ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

ENT.Decal                            = "scorch_gigantic"


function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
     self.GBOWNER = ply
     local ent = ents.Create( self.ClassName )
     ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
     ent:Spawn()
     ent:Activate()

     return ent
end
AddCSLuaFile()

DEFINE_BASECLASS( "base_bomb" )

ENT.Spawnable		            	 =  true         
ENT.AdminSpawnable		             =  true 

ENT.PrintName		                 =  "Number 80 Model 1"
ENT.Author			                 =  "Shermann Wolf"
ENT.Contact		                     =  "shermannwolf@gmail.com"
ENT.Category                         =  "SW Bombs"

ENT.Model                            =  "models/sw/avia/bombs/Num80Mod1.mdl"
ENT.Effect                           =  "cloudmaker_ground"             
ENT.EffectAir                        =  "cloudmaker_ground"
ENT.EffectWater                      =  "water_huge"
ENT.ExplosionSound                   =  "explosions/gbomb_3.mp3"
ENT.ArmSound                         =  "npc/roller/mine/rmine_blip3.wav"            
ENT.ActivationSound                  =  "buttons/button14.wav"     

ENT.ShouldUnweld                     =  true
ENT.ShouldIgnite                     =  false
ENT.ShouldExplodeOnImpact            =  true
ENT.Flamable                         =  true
ENT.UseRandomSounds                  =  false
ENT.UseRandomModels                  =  false
ENT.Timed                            =  false

ENT.ExplosionDamage                  =  20000
ENT.PhysForce                        =  2000
ENT.ExplosionRadius                  =  2000
ENT.SpecialRadius                    =  3000
ENT.MaxIgnitionTime                  =  0 
ENT.Life                             =  100
ENT.MaxDelay                         =  0                                 
ENT.TraceLength                      =  1000
ENT.ImpactSpeed                      =  200
ENT.Mass                             =  2000
ENT.ArmDelay                         =  0.1   
ENT.Timer                            =  0

ENT.Shocktime                        = 0
ENT.GBOWNER                          =  nil             -- don't you fucking touch this.

ENT.Decal                            = "scorch_gigantic"


function ENT:SpawnFunction( ply, tr )
     if ( !tr.Hit ) then return end
     self.GBOWNER = ply
     local ent = ents.Create( self.ClassName )
     ent:SetPhysicsAttacker(ply)
     ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
     ent:Spawn()
     ent:Activate()

     return ent
end