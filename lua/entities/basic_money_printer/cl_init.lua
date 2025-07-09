include("shared.lua")

function ENT:Initialize()
	self.Color = util.JSONToTable(self:GetColors())[1]
	hook.Add("PreDrawHalos", "HeatEffect_"..self:EntIndex(), function() 
		if (self:GetPos() - LocalPlayer():GetPos()):Length() > 1500 then return end
		local color = Color(self.Color[1],self.Color[2]*((155 - self:GetHeat())/155),self.Color[3]*((100 - self:GetHeat())/100),(self:GetHeat()/self:GetCriticalHeat())*255)
		halo.Add( {self}, color, (self:GetHeat()/self:GetCriticalHeat())*20, (self:GetHeat()/self:GetCriticalHeat())*20, 2, true, false)
	end)
end

function ENT:Think()
	if (self:GetPos() - LocalPlayer():GetPos()):Length() > 2000 then return end
	local color = Color(self.Color[1],self.Color[2]*((155 - self:GetHeat())/155),self.Color[3]*((100 - self:GetHeat())/100),255):ToTable()
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.pos = self:GetPos()
		dlight.r = color[1]
		dlight.g = color[2]
		dlight.b = color[3]
		dlight.brightness = self:GetHeat()/self:GetCriticalHeat()
		dlight.decay = 1000
		dlight.size = 1000*(self:GetHeat()/self:GetCriticalHeat())
		dlight.dietime = CurTime() + 1
	end
end

function ENT:Draw( flags )
    self:DrawModel( flags ) 
	if (self:GetPos() - LocalPlayer():GetPos()):Length() > 1500 then return end
    local ang = self:GetAngles()
	ang:RotateAroundAxis( self:GetUp(), 90 )
	ang:RotateAroundAxis( self:GetRight(), -90 )
	ang:RotateAroundAxis( self:GetForward(), 0 )

	local pos = self:GetPos()
	pos = pos + self:GetForward() * 16.9
	pos = pos + self:GetRight() * 14.5
	pos = pos + self:GetUp() * 10.25

	local resolution = 1
	
    cam.Start3D2D( pos, ang, 0.05 / resolution )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, 595 * resolution, 200 * resolution )

		draw.SimpleText( self.AmountText..tostring(self:GetAmount()), "CloseCaption_Normal", 10, 10, color_white )
		draw.SimpleText( self.HeatText..tostring(math.Round(self:GetHeat())+10).." С°", "CloseCaption_Normal", 10, 40, color_white )
		draw.SimpleText( self.PrintTimeText..tostring(self:GetPrintTime()), "CloseCaption_Normal", 10, 70, color_white )
		draw.SimpleText( self.IncrementText..tostring(self:GetIncrement()), "CloseCaption_Normal", 10, 100, color_white )
		draw.SimpleText( self.HeatResistanceText..tostring(self:GetHeatResistance()), "CloseCaption_Normal", 10, 130, color_white )
	cam.End3D2D()
end

function ENT:OnRemove()
	hook.Remove("PreDrawHalos","HeatEffect_"..self:EntIndex())
end