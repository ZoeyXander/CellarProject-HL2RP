
local ang1 = Angle(90)
local ParticleEffect = ParticleEffect

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local ang = data:GetAngles()
	ParticleEffect("500lb_ground",pos,ang,nil)
end
function EFFECT:Think()
	return false
end

function EFFECT:Render()
end