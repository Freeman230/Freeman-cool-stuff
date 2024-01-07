if CLIENT then
local laser = Material("sprites/physgbeamb")

function EFFECT:Init(data)
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

end	

function EFFECT:Think()
if !IsValid(self.WeaponEnt) or !IsValid(self.WeaponEnt.Owner) or not(self.WeaponEnt.Owner:IsPlayer() and self.WeaponEnt.Owner:Alive()) or self.WeaponEnt.Owner:GetActiveWeapon()~=self.WeaponEnt then return false end
	 local trace={}
	 trace.start=self.WeaponEnt.Owner:GetShootPos()
              trace.endpos=trace.start+self.WeaponEnt.Owner:GetAimVector()*100000000000
              trace.filter=function(ent) if ent:IsWorld() then return true end end 
					 
                                local tr=util.TraceLine(trace)			
if self.WeaponEnt.Owner:KeyDown(IN_ATTACK) then
self:SetRenderBoundsWS(self.WeaponEnt.Owner:GetShootPos(),tr.HitPos)
							end
							return true 
								end
								

function EFFECT:Render()	
if IsValid(self.WeaponEnt) then
self.Position = self.WeaponEnt.Owner:GetShootPos()
 self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)		

	 local trace={}
	 trace.start=self.WeaponEnt.Owner:GetShootPos()
              trace.endpos=trace.start+self.WeaponEnt.Owner:GetAimVector()*100000000000
              trace.filter=function(ent) if ent:IsWorld() then return true end end 
					 
                                local tr=util.TraceLine(trace)							  
								 
if self.WeaponEnt.Owner:KeyDown(IN_ATTACK) then
render.SetMaterial(laser)
for i=1,2 do
render.DrawBeam(self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment),tr.HitPos, 1.1, 1, 1, Color(255,0,0, 255))
end

end
end
end

end