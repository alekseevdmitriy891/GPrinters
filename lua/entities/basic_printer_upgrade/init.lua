AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel( "models/props_lab/reciever01d.mdl" )
    self:SetMaterial( self.Material )
    self:SetColor( self.Color )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:CanProperty(plr, property) return false end
function ENT:CanTool(plr,tr,toolname,tool,button) return false end
function ENT:PhysgunPickup(plr,ent) return false end

function ENT:PhysicsCollide(colData, collider)
    local b = self.Value
    local hit = colData.HitEntity
    if IsValid(hit) and isfunction(hit.GetHeat) then
        if self.Upgrade == "Increment" and hit:GetIncrement() < 5 then local a = hit:GetIncrement() local ab = math.Clamp(a + math.ceil(b),0,5) hit:SetIncrement( ab ) self.Upgrade = "" self:Remove() self:EmitSound("items/battery_pickup.wav") end
        if self.Upgrade == "HeatResistance" and hit:GetHeatResistance() < 5 then local a = hit:GetHeatResistance() local ab = math.Clamp(a + b,0,5) hit:SetHeatResistance( ab ) self.Upgrade = "" self:Remove() self:EmitSound("items/battery_pickup.wav") end
        if self.Upgrade == "PrintTime" and hit:GetPrintTime() > 0.5 then  local a = hit:GetPrintTime() local ab = math.Clamp(a - b,0.5,15) hit:SetPrintTime( ab ) self.Upgrade = "" print(ab) self:Remove() self:EmitSound("items/battery_pickup.wav") end
    end
end