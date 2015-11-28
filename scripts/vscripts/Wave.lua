require("Spawner")
require("utils")

if Wave == nil then
	Wave = class({})
end


 -- wave_table {class="creature_01",wavespan=20,count=4,delay=5,nums=3,waypoint="path_02_01"},
 function Wave:Load(spawner,wave_table,wave_order)


	-- self.isWaiting = true
	self.curCount = 1

	self.spawner = spawner
	self.waveOrder = wave_order or 0
	self.waiting = wave_table.waiting or 0
	self.creatureClass = wave_table.class
	self.wavespan = wave_table.wavespan or 1
	self.count = wave_table.count
	self.interval = wave_table.interval
	self.nums = wave_table.nums
	self.waypoint =  wave_table.waypoint or spawner.waypoint or ""
	self.level = wave_table.level or 1
	self.lastTime = 0
	self.startTime = 0
	self.max = spawner.max
	-- self.target = wave_table.target or self.spawner.target or Entities:FindByName(nil,"dota_goodguys_fort")
	self.isQuest = wave_table.isQuest or false

end
-- 在waiting之前
function Wave:Init( )
	if self.isQuest then
		self.Quest = SpawnEntityFromTableSynchronous( "quest", {
        name = "QuestName",
        title = "#"..self.creatureClass.."Timer"
    	})
		self.subQuest = SpawnEntityFromTableSynchronous( "subquest_base", {
    	show_progress_bar = true,
    	progress_bar_hue_shift = -119
		} )
		self.Quest.EndTime = self.waiting
		self.Quest:AddSubquest( self.subQuest )

		-- 启动时文本
		self.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.Quest.EndTime )
		self.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, self.Quest.EndTime )

		-- 进度条上的值
		self.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.Quest.EndTime )
		self.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, self.Quest.EndTime )
	end	-- body
end
-- 在waiting之后
function Wave:Begin(  )
	-- self.thinker = CreateUnitByName("npc_dota_thinker", Vector(0,0,0), false, nil, nil, 0) 
	-- self.thinker:SetThink( "OnThink", self, self.wavespan)
	-- local waveinfo=string.format("%s%s%d","#","waveinfo_",self.waveOrder)

	self.startTime =  GameRules:GetGameTime()
	self.spawner.spawner:SetThink( "OnThink", self, "Wave "..self.spawner:GetName().. self.waveOrder, 0.1)
end
------------------------------------
function  Wave:OnThink(  )

	-- print("Wave: OnThink " .. GameRules:GetGameTime() .. "   ".. self.lastTime .. "   ".. self.interval)
	if self.curCount>self.count then
		-- print("wave return nil " .. self.curCount .." "..self.count)
		if self.isQuest then
			self.Quest:CompleteQuest() 
		end
		return nil
	elseif GameRules:GetGameTime()+1 >=self.lastTime + self.interval or self.curCount == 1 then

			if self.max~=0 then
				ents_in_sp = Entities:FindAllInSphere(self.spawner.positon, 300)
				-- PrintTable(ents_in_sp)
				-- print ("wave ent number " .. #ents_in_sp)
				if #ents_in_sp>=self.max then
					-- print("wave return " .. self.interval)
					return self.interval
				end
			end

			self.lastTime = GameRules:GetGameTime()
			self.curCount = self.curCount+1
			
			local team = self.spawner.spawner:GetTeamNumber()
			local real_numer = calc_number(team , self.nums)
			if real_numer >= 1 then
				for i=1,real_numer do
					local spawnPos = self.spawner.positon + RandomVector( RandomFloat( 0, 100 ) )	
					local entUnit = nil
					if self.creatureClass=="@random" then
						entUnit = CreateUnitByName("creep_vulture", spawnPos, true, nil, nil, RandomInt(6, 13))
					else
						entUnit = CreateUnitByName(self.creatureClass, spawnPos, true, nil, nil, team)
					end
					if entUnit then
						EmitAnnouncerSound("announcer_ann_custom_adventure_alerts_48")
						PingMiniMapAtLocation(entUnit:GetAbsOrigin() )
						-- local origin=RandomVector( RandomFloat( 0, 7000 ) )
						-- print ("Spawn Ent on ".. tostring(origin) )
						-- FindClearSpace(entUnit,6000,300)
						-- entUnit:SetAbsOrigin(origin)
						-- FindClearSpaceForUnit(entUnit, origin, true)

						local entWp = Entities:FindByNameNearest(self.waypoint, self.spawner.positon , 0) 
						local sp = Entities:FindByName( nil, self.spawner.name)
						if entWp ~= nil then
							entUnit:SetMustReachEachGoalEntity(true)
							entUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=3})
							entUnit:SetInitialGoalEntity( entWp )
							entUnit:MoveToPositionAggressive(entWp:GetOrigin()) 

						end
					end
				end
			end
		if self.isQuest	then
			self.Quest.EndTime = self.interval
			self.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, self.Quest.EndTime )
			self.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, self.Quest.EndTime )
		end
		return 1
	elseif self.isQuest then
		self.Quest.EndTime = self.lastTime  + self.interval - GameRules:GetGameTime()
  		self.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.Quest.EndTime )
  		self.subQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.Quest.EndTime )		 
	end
	-- print("wave return " .. 4)
	return 1
end

