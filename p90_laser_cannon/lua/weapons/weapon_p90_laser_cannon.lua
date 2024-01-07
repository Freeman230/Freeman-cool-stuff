SWEP.Category            = "Freeman's Admin Gun Pack"
SWEP.Spawnable           = true
SWEP.AdminSpawnable          = true
SWEP.AdminOnly = true
SWEP.Base = "weapon_base"
 
SWEP.ViewModel		= "models/weapons/v_smg_p90t.mdl"
SWEP.WorldModel		= "models/weapons/w_smg_p90.mdl"
SWEP.DrawWorldModel=true

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Recoil = 0
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo                = ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.UseHands=true
SWEP.ViewModelFlip = true

	SWEP.PrintName    = "Freeman's P90 Laser Cannon Mark I"                        
    SWEP.Author       = "Freeman"
        SWEP.Instructions = ""
    SWEP.ViewModelFOV = 63
    SWEP.Slot         = 2    
 
	SWEP.DrawCrosshair = true
 
	SWEP.Weight = 5

	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
	

function SWEP:Initialize()
self:SetWeaponHoldType( "AR2" )
if SERVER then
self.sound=CreateSound(self.Weapon,"")
end

end

function SWEP:SecondaryAttack()

	if(Zoom == 0) then
		if(SERVER) then
			self.Owner:SetFOV( 10, 0.15 )
		end
		self:EmitSound("Weapon_AR2.Special1")
		Zoom = 1
	else
		if(SERVER) then
			self.Owner:SetFOV( 0, 0.15 )
		end
		self:EmitSound("Weapon_AR2.Special2")
		Zoom = 0
	end
end

function SWEP:Deploy()
local effect = EffectData()
effect:SetEntity(self.Weapon)
effect:SetAttachment(1)
util.Effect("effect_ulaser8", effect)
_G.lin1 = self.Owner:Health() -- Health Function
_G.lin2 = self.Owner:Armor() -- Armor Function
_G.lin3 = self.Owner:GetWalkSpeed() -- Walk Speed Function
_G.lin4 = self.Owner:GetRunSpeed() -- Running Speed Function
_G.lin5 = self.Owner:GetJumpPower() -- Jump Power Function
self.Owner:SetHealth(500) -- How much health should you have when you use the SWEP?
self.Owner:SetArmor(500) -- How much armor should you have when you use the SWEP?
self.Owner:SetRunSpeed(700) -- How much running speed should you have when using the SWEP?
return true
end

function SWEP:Think()
if CLIENT and self.Owner:KeyPressed(IN_ATTACK) then
self.Weapon:EmitSound("")
end
if SERVER then
if self.Owner:KeyDown(IN_ATTACK) then
self.sound:Play()
self.sound:ChangeVolume(0.5,0)
end
if self.Owner:KeyReleased(IN_ATTACK) and self.sound then
self.sound:Stop()
end

end
end

function SWEP:DrawWorldModel()
self:DrawModel()	
end

function SWEP:FireAnimationEvent(pos,ang,event,options)
return true
end

function SWEP:Holster()
	if SERVER and self.sound then
    self.sound:Stop()
    end
if not IsFirstTimePredicted() then return end
self.Owner:SetHealth(_G.lin1) 
self.Owner:SetHealth(_G.lin2) 
self.Owner:SetWalkSpeed(_G.lin3) 
self.Owner:SetRunSpeed(_G.lin4) 
self.Owner:SetJumpPower(_G.lin5) 
return true
end

function SWEP:OnRemove()
self:Holster()
end
	
function SWEP:PrimaryAttack()

self:SetNextPrimaryFire(CurTime()+0.01)
self.Owner:SetAnimation(PLAYER_ATTACK1)
self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)


 local trace={start=self.Owner:GetShootPos(),
              endpos=self.Owner:GetShootPos()+self.Owner:GetAimVector()*2^63,
              filter=function(ent) if ent:IsWorld() then return true end end }
					   
                                local tr=util.TraceLine(trace)	

	local ef = EffectData()
	ef:SetOrigin(tr.HitPos)
    ef:SetNormal(tr.HitNormal)
    ef:SetRadius(2)
    util.Effect("", ef)		

for k,v in pairs(ents.FindAlongRay(self.Owner:GetShootPos(),tr.HitPos)) do								 
								 
if v~=self.Owner then

local trace1={start=self.Owner:GetShootPos(),
              endpos=self.Owner:GetShootPos()+self.Owner:GetAimVector()*2^63,
              filter=function(ent) if ent==v then return true end end,
			  mins=Vector(-5,-5,-5),
			  maxs=Vector(5,5,5)}
					   
                                local tr1=util.TraceHull(trace1)

if tr1.Entity==v then

if v:IsNPC() or (v:IsPlayer() and v:Alive()) or type(v)=="NextBot" then

	local effect = EffectData()
	effect:SetOrigin(v:WorldSpaceCenter())
	util.Effect("", effect)

v:SetHealth(0)
							
local dmginfo= DamageInfo()

dmginfo:SetAttacker(self.Owner)
dmginfo:SetInflictor(self.Weapon)
dmginfo:SetDamage(2^63)
dmginfo:SetDamageForce(self.Owner:GetAimVector()*2^63)
dmginfo:SetDamageType(bit.bor(DMG_AIRBOAT,DMG_BLAST,DMG_NEVERGIB))

v:DispatchTraceAttack(dmginfo,tr1,tr1.HitNormal)

if SERVER and v:IsPlayer() and v:Alive() then
v:KillSilent()
end	

end
if SERVER then	
if v:GetClass()~="predicted_viewmodel" and not(v:IsWeapon() and v:GetOwner()==self.Owner) and v:GetClass()~="gmod_hands" then
print(v)

v.OnRemove = function(self,...) self:Remove() end
v.Think = function(self,...) self:Remove() end

v:Remove()			
end
end		
 
end
end
end

end