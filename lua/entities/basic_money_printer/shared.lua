AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Author = "alekseevdmitriy891"
ENT.Contact = "STEAM_0:0:846162841" 
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "Colors" )
	self:NetworkVar( "Float", 0, "Heat" )
    self:NetworkVar( "Float", 1, "CriticalHeat" )
    self:NetworkVar( "Float", 2, "Amount" )
    self:NetworkVar( "Float", 3, "PrintTime" )
    self:NetworkVar( "Float", 4, "Increment" )
    self:NetworkVar( "Float", 5, "HeatResistance" )
end

--Default Values--
ENT.Material = "models/XQM//Deg360"
ENT.Color = Color(255,255,255,255)

ENT.PrintTime = 2

ENT.Amount = 0

ENT.DefaultHealth = 100

ENT.Heat = 0
ENT.CriticalHeat = 100
ENT.HeatResistance = 1

ENT.Increment = 1

--Texts--
ENT.AmountText = "Amount Printed: "

ENT.HeatText = "Temperature: "

ENT.PrintTimeText = "Printing Time: "

ENT.IncrementText = "Printing Multiplier: "

ENT.HeatResistanceText = "Temperature Resistance: "

--DO NOT EDIT--
ENT.NextPrint = CurTime()+ENT.PrintTime