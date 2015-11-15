require("utils")

if Pet == nil then
	Pet = class({})
end

default_lvluptable = {
	
}

for i=1, 100 do
	default_lvluptable[i] = i
end

function Pet:Load( unit,HPGain,AttackTimeGain,DamageGain, HPRegenGain,ArmorGain,MagicResistanceGain,team,lvluptable)

	self.alive = true
	self.unit = unit
	self.HPg = HPGain
    self.atg = AttackTimeGain
    self.dg = DamageGain
    self.hprg = HPRegenGain
    self.ag = ArmorGain
    self.mr = MagicResistanceGain
    self.team = team

    unit:SetHPGain(self.HPg) 
	unit:SetAttackTimeGain(self.atg)
	unit:SetDamageGain(self.dg) 	
	unit:SetHPRegenGain(self.hprg) 
	unit:SetArmorGain(self.ag) 
	unit:SetMagicResistanceGain(self.mr) 
	unit:SetXPGain(1)
	unit:SetBountyGain(1)
	self.currentlvl_kills_lvls = 0
	self.kills = 0
	-- 当前升级需要消耗的kills_lvls数
	self.lvluptable = lvluptable or default_lvluptable
end

function Pet:UpdateKills(killedUnit)
	if not self.alive then
		return
	end

	if self.team ~= DOTA_TEAM_BADGUYS and self.team ~=  DOTA_TEAM_GOODGUYS and killedUnit:GetTeam()  ~= DOTA_TEAM_BADGUYS and killedUnit:GetTeam()  ~=  DOTA_TEAM_GOODGUYS then
		self.unit:Heal(self.unit:GetMaxHealth()-self.unit:GetHealth() , nil) 
	end

	-- print ("self.currentlvl_kills_lvls" .. self.currentlvl_kills_lvls)
	self.kills = self.kills + 1
	self.currentlvl_kills_lvls= self.currentlvl_kills_lvls+killedUnit:GetLevel() 
	if self.currentlvl_kills_lvls>=self.lvluptable[self.unit:GetLevel()] then
		self.unit:CreatureLevelUp(1) 
		self.currentlvl_kills_lvls = 0
	end
	
end

