AddCSLuaFile()

local ExploSnds = {}
ExploSnds[1]     			=	"wac/tank/tank_shell_01.wav"
ExploSnds[2]     			=	"wac/tank/tank_shell_02.wav"
ExploSnds[3]     			=	"wac/tank/tank_shell_03.wav"
ExploSnds[4]     			=	"wac/tank/tank_shell_04.wav"
ExploSnds[5]     			=	"wac/tank/tank_shell_05.wav"

ENT.Spawnable		       	=	true
ENT.AdminSpawnable		   	=	true

ENT.PrintName		      	=	"Hydra 70"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"SW Bombs"
ENT.Base					=	"base_rocket"

ENT.Model                	=	"models/sw/avia/bombs/hydra70.mdl"
ENT.RocketTrail          	=	"rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.Effect               	=	"high_explosive_air"
ENT.EffectAir            	=	"high_explosive_air"
ENT.EffectWater          	=	"water_torpedo"
ENT.AngEffect						 =	true
ENT.StartSound             	=	"sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"sw/bombs/rocket_idle.wav"
ENT.StartSoundFollow		=	true

ENT.ExplosionDamage                  =  910
ENT.PhysForce                        =  500
ENT.ExplosionRadius                  =  750
ENT.Mass           			=	20
ENT.EnginePower    			=	60000
ENT.TNTEquivalent			=	1.19
ENT.FuelBurnoutTime			=   0.35
ENT.LinearPenetration		=	290
ENT.MaxVelocity				=	9999999
ENT.Caliber					=	70
ENT.ShellType				=	"HEAT"

function ENT:SpawnFunction( ply, tr )
    if (!tr.Hit) then return end
	
    local ent = ents.Create(self.ClassName)
	ent:SetPhysicsAttacker(ply)
	ent.Owner = ply
    ent:SetPos(tr.HitPos + tr.HitNormal * 16) 
    ent:Spawn()
    ent:Activate()
	
    return ent
end

function ENT:DoPreInit()
	self.ExplosionSound = ExploSnds[math.random(#ExploSnds)]
end
AddCSLuaFile()

local ExploSnds = {}
ExploSnds[1]     			=	"wac/tank/tank_shell_01.wav"
ExploSnds[2]     			=	"wac/tank/tank_shell_02.wav"
ExploSnds[3]     			=	"wac/tank/tank_shell_03.wav"
ExploSnds[4]     			=	"wac/tank/tank_shell_04.wav"
ExploSnds[5]     			=	"wac/tank/tank_shell_05.wav"

ENT.Spawnable		       	=	true
ENT.AdminSpawnable		   	=	true

ENT.PrintName		      	=	"Hydra 70"
ENT.Author			      	=	""
ENT.Contact			      	=	""
ENT.Category              	=	"SW Bombs"
ENT.Base					=	"base_rocket"

ENT.Model                	=	"models/sw/avia/bombs/hydra70.mdl"
ENT.RocketTrail          	=	"rockettrail"
ENT.RocketBurnoutTrail   	=	"grenadetrail"
ENT.Effect               	=	"high_explosive_air"
ENT.EffectAir            	=	"high_explosive_air"
ENT.EffectWater          	=	"water_torpedo"
ENT.AngEffect						 =	true
ENT.StartSound             	=	"sw/bombs/rocket_start_0"..math.random(1,4)..".wav"
ENT.ArmSound               	=	""
ENT.ActivationSound        	=	"buttons/button14.wav"
ENT.EngineSound				=	"sw/bombs/rocket_idle.wav"
ENT.StartSoundFollow		=	true

ENT.ExplosionDamage                  =  910
ENT.PhysForce                        =  500
ENT.ExplosionRadius                  =  750
ENT.Mass           			=	20
ENT.EnginePower    			=	60000
ENT.TNTEquivalent			=	1.19
ENT.FuelBurnoutTime			=   0.35
ENT.LinearPenetration		=	290
ENT.MaxVelocity				=	9999999
ENT.Caliber					=	70
ENT.ShellType				=	"HEAT"

function ENT:SpawnFunction( ply, tr )
    if (!tr.Hit) then return end
	
    local ent = ents.Create(self.ClassName)
	ent:SetPhysicsAttacker(ply)
	ent.Owner = ply
    ent:SetPos(tr.HitPos + tr.HitNormal * 16) 
    ent:Spawn()
    ent:Activate()
	
    return ent
end

function ENT:DoPreInit()
	self.ExplosionSound = ExploSnds[math.random(#ExploSnds)]
end