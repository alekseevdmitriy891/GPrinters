AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self.Dead = false
    self.Color = self.Color:ToTable()
    self:SetColors(util.TableToJSON({self.Color}))
    self:SetUseType( SIMPLE_USE )
    self:SetModel( "models/props_c17/consolebox01a.mdl" )
    self:SetMaterial( self.Material )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetMaxHealth(self.DefaultHealth)
    self:SetHealth(self.DefaultHealth)
    self.NextPrint = CurTime()+self.PrintTime
    self.LoopSound = CreateSound(self,"ambient/levels/labs/equipment_printer_loop1.wav")
    self.LoopSound:Play()
    self:SetCriticalHeat(self.CriticalHeat)
    self:SetHeat(self.Heat)
    self:SetIncrement(self.Increment)
    self:SetAmount(self.Amount)
    self:SetPrintTime(self.PrintTime)
    self:SetHeatResistance(self.HeatResistance)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:CanProperty(plr, property) return false end
function ENT:CanTool(plr,tr,toolname,tool,button) return false end
function ENT:PhysgunPickup(plr,ent) return false end
function ENT:OnTakeDamage(damage)
    if not self.Dead then
    local newhp = (self:Health() - damage:GetDamage())
    if newhp > 0 then 
        self:SetHealth(newhp) 
        local edata = EffectData()
	    edata:SetOrigin(damage:GetDamagePosition())
	    edata:SetMagnitude(2)
        util.Effect("ElectricSpark",edata)
    else
        self:SetHealth(0)
        local edata = EffectData()
	    edata:SetOrigin(self:GetPos())
	    edata:SetMagnitude(220)
        util.Effect("Explosion",edata)
        self.Dead = true
        self:Remove()
    end 
    end
end
if not isfunction(ENT.PrintFunc) then
    function ENT:PrintFunc() 
        self:SetAmount(self:GetAmount() + self:GetIncrement())
    end
end
if not isfunction(ENT.OutTake) then
    function ENT:OutTake() 
        if self:GetAmount() < 1 then return end
        self:SetAmount(self:GetAmount() - 1)
        local prop = ents.Create("prop_physics")
        prop:SetModel("models/props_interiors/pot01a.mdl")
        prop:Spawn()
        prop:SetPos(self:GetPos() + (self:GetForward() * 16.9) + (self:GetUp() * 5.25))
        timer.Simple(2,function() 
            local edata = EffectData()
	        edata:SetEntity(prop)
            util.Effect("entity_remove",edata)
            timer.Simple(0.01,function() prop:Remove() end)
        end)
    end
end
function ENT:Think()
    if self.NextPrint <= CurTime() then
        self:PrintFunc() 
        self.NextPrint = CurTime()+self:GetPrintTime()
    end
    local WaterLevel = self:WaterLevel()
    if WaterLevel > 1 and WaterLevel < 3 then self:Ignite(10,10) elseif WaterLevel == 3 then self:Ignite(10,10) self:TakeDamage(5, self) end
    local isblue = 1
    for i,v in pairs(ents.FindInSphere(self:GetPos(), 250)) do if v:GetModel() == "models/props_borealis/bluebarrel001.mdl" then isblue = 1.3 break end end
    local increment = ((((self:GetMaxHealth() - self:Health())/200)+0.1)/self:GetHeatResistance())/isblue
    if (self:GetHeat() + increment) < self:GetCriticalHeat() then self:SetHeat(self:GetHeat() + increment) else self:SetHeat(self:GetCriticalHeat()) end
    self:SetColor(Color(self.Color[1],self.Color[2]*((155 - self:GetHeat())/155),self.Color[3]*((100 - self:GetHeat())/100),255))
    if self:GetHeat() == self:GetCriticalHeat() and not self:IsOnFire() then self:Ignite(25,10) end
end
function ENT:PhysicsCollide(colData, collider)
    if IsValid(colData.HitEntity) and colData.HitEntity:GetClass() == "item_battery" and (self:Health() < self.DefaultHealth or self:GetHeat() > 10) then
        colData.HitEntity:Remove()
        self:EmitSound("items/battery_pickup.wav")
        if self:Health() + 20 > self.DefaultHealth then self:SetHealth(self.DefaultHealth) else self:SetHealth(self:Health() + 20) end
        if self:GetHeat() - 10 < 0 then self:SetHeat(0) else self:SetHeat(self:GetHeat() - 10) end
    end
end
function ENT:Use(activaor,caller,useType,value)
    self:OutTake(activaor,caller,useType,value)
end
function ENT:OnRemove()
    self.LoopSound:Stop()
end