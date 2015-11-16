require("data")



if Hero == nil then
	Hero = class({})
end



function Hero:Load( unit )
	self.name = unit:GetName() 
	self.unit = unit
	self.player_id = unit:GetPlayerID() 
	self.spawnPos = nil
	self.team = unit:GetTeam()
	-- self.had_died = false
	-- self.unit.heroinfo = self
end


function Hero:AddModifier( mod_name )
	MOD_MASTER:ApplyDataDrivenModifier(self.unit,self.unit, mod_name, nil) 
end