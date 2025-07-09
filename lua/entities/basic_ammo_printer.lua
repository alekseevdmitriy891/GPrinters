AddCSLuaFile()

DEFINE_BASECLASS("basic_money_printer")

ENT.Base = "basic_money_printer"

ENT.Spawnable = true 

ENT.PrintName = "Ammo Printer"
ENT.Purpose = "Prints Ammo"
ENT.Color = Color(0,200,0,255)
ENT.AmmoEnts = {"item_ammo_pistol","item_ammo_smg1","item_box_buckshot","item_ammo_357"}

function ENT:OutTake() 
    if self:GetAmount() < 1 then return end
    self:SetAmount(self:GetAmount() - 1)
    local prop = ents.Create(self.AmmoEnts[math.random(1,table.Count(self.AmmoEnts))])
    prop:Spawn()
    prop:SetPos(self:GetPos() + (self:GetForward() * 20) + (self:GetUp() * 5.25))
end
