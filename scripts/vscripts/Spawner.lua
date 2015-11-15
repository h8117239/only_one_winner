require("data")
require("heroes")


if Spawner == nil then
	Spawner = class({})
end


function Spawner:Load( spawner_table )


	self.name = spawner_table.name
	self.waypoint = spawner_table.waypoint
	-- DeepPrintTable(spawner_table.waves)
	self.spawner = Entities:FindByName(nil, self.name)
	self.waves= {}
	self.positon = self.spawner:GetAbsOrigin() 
	self.curWave = 1
	-- self.lastWaveTime = 0
	self.nextWaveStartTime = 0
	self.max = spawner_table.max or 0
	self.team = spawner_table.team or DOTA_TEAM_BADGUYS
	for i=1,#spawner_table.waves do
			local wave = Wave()
			wave:Load(self,spawner_table.waves[i],i)
		-- print("wave"..i)
		-- DeepPrintTable(wave)
			table.insert(self.waves,wave)
	end
	-- print("wave"..#self.waves)
end


function Spawner:GetName(  )
	if self.name then
		return self.name
	else
		return nil
	end
end


function Spawner:GetWaves(  )
	if self.waves then
		return self.waves
	else
		return nil
	end
end

TICK = 0


function Spawner:Begin(  )
	-- self.thinker = CreateUnitByName("npc_dota_thinker", Vector(0,0,0), false, nil, nil, 0) 
	self.nextWaveStartTime = GameRules:GetGameTime() + self.waves[self.curWave].waiting
	self.waves[self.curWave]:Init()
	-- self.thinker:SetThink( "OnThink", self, 2)
	self.spawner:SetTeam(self.team) 
	TICK = TICK+0.5
	self.spawner:SetThink( "OnThink", self, TICK)
	print("AAAAAABBBBBBB" .. self.name)	
end

function Spawner:OnThink(  )
	local time = GameRules:GetGameTime() 
	-- print("cur wave ".. self.curWave .. "self.waves " ..  #self.waves .. "time" .. time ..  "self.nextWaveStartTime" .. self.nextWaveStartTime)
	if self.curWave>#self.waves then
		-- print("end end end")
		return nil
	elseif time> self.nextWaveStartTime then
		-- print("Spawner: new wave begin " .. GameRules:GetGameTime() .. " spawner " .. self.spawner:GetName() .." curWave " .. self.curWave)		
		self.waves[self.curWave]:Begin()
		self.curWave = self.curWave+1
		if self.curWave>#self.waves then
			return nil
		end
		self.nextWaveStartTime = time  + self.waves[self.curWave].waiting	
		self.waves[self.curWave]:Init()
		return 1
	elseif self.waves[self.curWave].isQuest then
		self.waves[self.curWave].Quest.EndTime = self.nextWaveStartTime-time
		local time_q = self.waves[self.curWave].Quest.EndTime
  		self.waves[self.curWave].Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, time_q )
  		self.waves[self.curWave].subQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, time_q )
  		return 1
	end
	  return 1
end