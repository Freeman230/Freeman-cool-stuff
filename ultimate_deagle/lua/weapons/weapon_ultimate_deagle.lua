SWEP.PrintName			= "Freeman's Ultimate Admin Gun"	-- The name for the SWEP		
SWEP.Author			= "Freeman" -- SWEP's Author
SWEP.Slot			= 1 -- Which slot the SWEP should at be?
SWEP.SlotPos			= 1 -- The slot position for the SWEP
SWEP.Base			= "weapon_base" -- The SWEP's Base

SWEP.Spawnable			= true -- Is it spawnable?
SWEP.AdminSpawnable		= true -- Is it spawnable by admins?
SWEP.AdminOnly = true -- Is the weapon admin only?
SWEP.Purpose = "" -- The SWEP's Purpose
SWEP.Instructions = "The functions are pretty self explanatory. " -- The Instructions for the SWEP
SWEP.UseHands           = true -- Should the SWEP Use hands?
SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl" -- The View Model for the SWEP. Only c_ and v_ models are supported 
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl" -- The World Model for the SWEP
SWEP.ViewModelFOV		= 70 -- The SWEP's FoV, A.K.A "Field of Vision"
SWEP.ViewModelFlip 		= true -- Should the SWEP show in the right or show in the left?

SWEP.Weight			= 1 -- The SWEP's weight
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.UseHands = true

SWEP.HoldType = "pistol" -- The SWEP's hold type
SWEP.FiresUnderwater = true -- Does the SWEP fire underwater?
SWEP.DrawCrosshair = true -- Should the SWEP draw the crosshair?
SWEP.Category = "Freeman's Admin Gun Pack" -- The Category of the SWEP. If you don't put a category then it will show up in the 'Others' section
 
SWEP.DrawAmmo = true -- Should the SWEP draw ammo?
SWEP.ReloadSound = "" -- The reload sound for the SWEP

SWEP.CSMuzzleFlashes = true
SWEP.Primary.Sound = "weapons/deagle/deagle-1.wav" -- The primary sound for the SWEP
SWEP.Primary.Damage = math.huge
SWEP.Primary.TakeAmmo = 0.1 -- How much ammo should the SWEP take?
SWEP.Primary.ClipSize = 999999999  -- The SWEP's magazine size
SWEP.Primary.Ammo = "pistol" -- Which ammo type should the SWEP use?
SWEP.Primary.DefaultClip = 999999999 -- How many bullets are loaded when using the SWEP?
SWEP.Primary.Spread = 0.2 -- The SWEP's amount of spread.
SWEP.Primary.NumberofShots = 10 -- How many bullets should the SWEP fire?
SWEP.Primary.Automatic = true -- Is the SWEP automatic ? 
SWEP.Primary.Recoil = 0 -- How much we should punch the view? Leave it at 0 if you don't want any recoil
SWEP.Primary.Delay = 0.005 -- The SWEP's shoot delay
SWEP.Primary.Force = math.huge -- The force of the shot


function SWEP:Deploy() -- The SWEP's deploy function
_G.lin1 = self.Owner:Health() -- Health Function
_G.lin2 = self.Owner:Armor() -- Armor Function
_G.lin3 = self.Owner:GetWalkSpeed() -- Walk Speed Function
_G.lin4 = self.Owner:GetRunSpeed() -- Running Speed Function
_G.lin5 = self.Owner:GetJumpPower() -- Jump Power Function
self.Owner:SetHealth(10^9) -- How much health should you have when you use the SWEP?
self.Owner:SetArmor(10^9) -- How much armor should you have when you use the SWEP?
self.Owner:SetRunSpeed(650) -- How much running speed should you have when using the SWEP?
return true
end
function SWEP:Holster()
if not IsFirstTimePredicted() then return end
self.Owner:SetHealth(_G.lin1)
self.Owner:SetHealth(_G.lin2)
self.Owner:SetWalkSpeed(_G.lin3)
self.Owner:SetRunSpeed(_G.lin4)
self.Owner:SetJumpPower(_G.lin5)
return true
end

SWEP.Secondary.Sound = ""
SWEP.Secondary.Damage = math.huge
SWEP.Secondary.TakeAmmo = 0 
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.Ammo = "pistol" 
SWEP.Secondary.DefaultClip = 9999
SWEP.Secondary.Spread = 0.1 
SWEP.Secondary.NumberofShots = 0.5
SWEP.Secondary.Automatic = true
SWEP.Secondary.Recoil = 0.0
SWEP.Secondary.Delay = 0.025
SWEP.Secondary.Force = math.huge

function SWEP:Initialize() -- Initializes stuff
	util.PrecacheSound(self.Primary.Sound) 
	util.PrecacheSound(self.Secondary.Sound) 
        self:SetWeaponHoldType( self.HoldType )
end 
function SWEP:PrimaryAttack() -- The primary attack function
	if ( !self:CanPrimaryAttack() ) then return end 
	
	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots 
		bullet.Src = self.Owner:GetShootPos() 
		bullet.Dir = self.Owner:GetAimVector() 
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0) 
		bullet.Tracer = 0 -- Should the SWEP have a bullet tracer? Leave the value at 0 if you don't want any tracers. If you want bullet tracers then set the value to 1 
	bullet.TracerName 	= 'ToolTracer' -- Which tracer should the SWEP use?
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
 
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
 
	self:ShootEffects() 
 
	self.Owner:FireBullets( bullet ) 
	self:EmitSound(Sound(self.Primary.Sound)) 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
 
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
end 

function SWEP:SecondaryAttack() -- The secondary attack function
self:Boom()  
	if ( !self:CanSecondaryAttack() ) then return end 
 
	local rnda = -self.Secondary.Recoil 
	local rndb = self.Secondary.Recoil * math.random(-1, 1) 
 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
	local eyetrace = self.Owner:GetEyeTrace() 
	self:EmitSound ( self.Secondary.Sound ) 
	self:ShootEffects() 
	if SERVER then
		local ent =  ents.Create ("env_explosion")
			ent:SetPos( eyetrace.HitPos ) 
			ent:SetOwner( self.Owner ) 
			ent:Spawn() 
			ent:SetKeyValue("iMagnitude","175") 
			ent:Fire("Explode", 0, 0 ) 
			ent:EmitSound("BaseGrenade.Explode", 1000, 1000 ) 
	 
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay ) 
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
		self:TakePrimaryAmmo(self.Secondary.TakeAmmo) 
	end
end 
function SWEP:Boom2() 
	if ( !self:CanSecondaryAttack() ) then return end 
 
	local rnda = -self.Secondary.Recoil 
	local rndb = self.Secondary.Recoil * math.random(-1, 1) 
 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
	local eyetrace = self.Owner:GetEyeTrace() 
	self:EmitSound ( self.Secondary.Sound ) 
	self:ShootEffects() 
	if SERVER then
		local ent =  ents.Create ("env_explosion")
			ent:SetPos( eyetrace.HitPos ) 
			ent:SetOwner( self.Owner ) 
			ent:Spawn() 
			ent:SetKeyValue("iMagnitude","175") 
			ent:Fire("Explode", 1000, 0 ) 
			ent:EmitSound("BaseGrenade.Explode", 1000, 1000) 
	 
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay ) 
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
		self:TakePrimaryAmmo(self.Secondary.TakeAmmo) 
	end
end 
function SWEP:Boom() 
	if ( !self:CanSecondaryAttack() ) then return end 
 
	local rnda = -self.Secondary.Recoil 
	local rndb = self.Secondary.Recoil * math.random(-1, 1) 
 
	self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
	local eyetrace = self.Owner:GetEyeTrace() 
	self:EmitSound ( self.Secondary.Sound ) 
	self:ShootEffects() 
	if SERVER then
		local ent =  ents.Create ("env_explosion")
			ent:SetPos( eyetrace.HitPos ) 
			ent:SetOwner( self.Owner ) 
			ent:Spawn() 
			ent:SetKeyValue("iMagnitude","175") 
			ent:Fire("Explode", 1000, 0 ) 
			ent:EmitSound("BaseGrenade.Explode", 1000, 1000 ) 
	 
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay ) 
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
		self:TakePrimaryAmmo(self.Secondary.TakeAmmo) 
	end
end 
function SWEP:Reload()
self:EmitSound(Sound(self.ReloadSound)) 
        self.Weapon:DefaultReload( ACT_VM_RELOAD );
end