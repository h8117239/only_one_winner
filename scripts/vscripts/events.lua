require("abilities")
require("libraries/notifications")
require("amhc_library/amhc")
require("heroes")

blesses = {
	-- "blessing_of_heaven",
	"modifier_blessing_of_hell",
	"modifier_think_momian",
	"modifier_think_invis"

}

blesses_abbility_image = {
	blessing_of_heaven="attribute_bonus",
	modifier_blessing_of_hell="dazzle_shallow_grave",
	modifier_think_momian="item_black_king_bar",
	modifier_think_invis="clinkz_wind_walk"


}
---------------------------------------------------------------------------
-- Event: Item picked up
---------------------------------------------------------------------------、
function OOW:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	local playerID = owner:GetPlayerID()
	item:SetPurchaser( owner )
	--print("Item has been picked up")
	r = 100
	if event.itemname == "item_bag_of_gold" then
		--EmitSoundOn( "General.Coins", item )
		StartSoundEvent( "General.Coins", owner )
		PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
	if event.itemname == "item_fountain_potion" then
		--print("Potion picked up")
		--StartSoundEvent( "DOTA_Item.HealingSalve.Activate", owner )
		local health = owner:GetHealth()
		local maxHealth = owner:GetMaxHealth()
		--owner:ModifyHealth( health + (maxHealth * 0.5), nil, true, 0 )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
	if event.itemname == "item_mango_juice" then
		--print("Potion picked up")
		--StartSoundEvent( "DOTA_Item.HealingSalve.Activate", owner )
		local m = owner:GetMaxMana()
		--owner:GiveMana(m * 0.5)
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
	if event.itemname == "item_halloween_candy" then
		--print("Bag of gold picked up")
		--EmitSoundOn( "General.Coins", item )
		StartSoundEvent( "General.Coins", owner )
		PlayerResource:ModifyGold( owner:GetPlayerID(), 300, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, 300, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
	if event.itemname == "item_roshan_call" then
		local entUnit = CreateUnitByName("npc_dota_creep_dire_golem", owner:GetAbsOrigin()+RandomVector(RandomFloat(150,200)), true, nil, nil, owner:GetTeam())
    	if entUnit then
    		entUnit:SetOwner(owner)
    		entUnit:SetControllableByPlayer(playerID, true)
    	end
	end
	if event.itemname == "item_blessing_of_heaven" then
    	EmitGlobalSound("General.PingWarning")
		local min_idx = RandomInt(1,#blesses) 
		local modifier_name = "blessing_of_heaven"
		if RandomInt(1, 4) == 1 then
			modifier_name = blesses[min_idx]
		end
		local modifier = owner:FindModifierByName(modifier_name)
    	local count = owner:GetModifierStackCount(modifier_name, owner)
		StartSoundEvent( "DOTA_Item.BlackKingBar.Activate", owner )
    	nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_CUSTOMORIGIN, owner)
        ParticleManager:SetParticleControl(nFXIndex, 0, owner:GetAbsOrigin() )
		-- ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		if modifier_name=="blessing_of_heaven" then

    		if not modifier then
    		MakeMod(owner,owner,modifier_name,nil)
        	owner:SetModifierStackCount(modifier_name, owner, 1) 
    		else
        	owner:SetModifierStackCount(modifier_name, owner, count+1)
    		end
    	else
    		MakeMod(owner,owner,modifier_name,nil) 
    	end
    	Notifications:TopToAll({hero=owner:GetName(), imagestyle="portrait", duration=4.0})
  		Notifications:TopToAll({image="file://{images}/econ/tools/gift_lockless_luckbox.png", continue=true})
  		NotifyItemOrAblity(blesses_abbility_image[modifier_name])
  		Notifications:TopToAll({text="#"..owner:GetName(),style={color="DodgerBlue", ["font-size"]="30px"},duration=4.0}) 			
  		Notifications:TopToAll({text="#Add",style={color="white"}, continue=true})
		Notifications:TopToAll({text="#DOTA_Tooltip_"..modifier_name,style={color="gold", ["font-size"]="30px"}, continue=true})
		--owner:GiveMana(m * 0.5)
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end

function NotifyItemOrAblity( name )
	if string.find(name,"item") then
		Notifications:TopToAll({item=name, continue=true})
	else
		Notifications:TopToAll({ability=name, continue=true})
	end
end

function OOW:OnEntityKilled( keys )
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( keys.entindex_attacker )
	local heroTeam = hero:GetTeam()
	if killedUnit:IsRealHero() then
        self:RollDrops(killedUnit)
        killedUnit:SetRespawnPosition(FindClearSpacePos(2000,100))
        for i=1, #blesses do 
        	if killedUnit:HasModifier(blesses[i]) then
	      		local item_name = "item_blessing_of_heaven"
      			local item = CreateItem(item_name, nil, nil)
      			item:SetPurchaseTime(0)
      			local pos = killedUnit:GetAbsOrigin()
      			local drop = CreateItemOnPositionSync( pos, item )
      			StartSoundEvent( "RPG_Main.ItemLanded", item)
      			local pos_launch = pos+RandomVector(RandomFloat(150,200))
      			item:LaunchLoot(false, 200, 0.75, pos_launch)
      		end
        end

	end
	if killedUnit:IsCreature() then
		print("Die ".. killedUnit:GetName() )
        self:RollDrops(killedUnit)
        -- killedUnit.pet.alive = false
        -- if heroTeam==DOTA_TEAM_GOODGUYS or heroTeam==DOTA_TEAM_BADGUYS then
        -- 	local m = CreateUnitByName("creep_vulture", RandomVector(5999) , true, nil, nil, RandomInt(6, 13))
        -- 	FindClearSpace(m,6000,200)
        -- else
        -- 	local s =  CreateUnitByName("creep_vulture", RandomVector(5999) , true, nil, nil, killedTeam)
        -- 	FindClearSpace(s,6000,200)
        -- end
    end
	if hero:IsCreature() or hero:IsRealHero() then
		if hero.pet then
			hero.pet:UpdateKills(killedUnit)
		end
	end

    if killedUnit:IsRealHero() and  (heroTeam==DOTA_TEAM_GOODGUYS or heroTeam==DOTA_TEAM_BADGUYS) and heroTeam~=killedTeam then
    	local modifier_name = "modifier_kill_rewards"
    	local modifier = hero:FindModifierByName(modifier_name)
    	if not modifier then
     		MakeMod(hero,hero,modifier_name,nil)
        	hero:SetModifierStackCount(modifier_name, hero, 1) 
    	else
    		local count = hero:GetModifierStackCount(modifier_name, hero)
        	hero:SetModifierStackCount(modifier_name, hero, count+1)
    	end   		
    	ChangeOnePlayerToOtherTeam(hero)
    end

end






isFirst = true
function OOW:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	-- print("OnNPCSpawned" .. spawnedUnit:GetUnitName() .. " teamnumber" .. spawnedUnit:GetTeamNumber())

	if spawnedUnit:IsRealHero() then
  		-- 初始化英雄
  		-- print("OnNPCSpawned  hero")
  		if isFirst  and  not IS_PVP then
  			-- GameRules:GetGameModeEntity():SetCameraDistanceOverride(3000)
  			isFirst = false
  			-- EmitGlobalSound("Bgm.Bgm")
  		end
  		self:ShowHardLevel()
  		OOW:InitHeroAttribute(spawnedUnit) 	
  	elseif string.find(spawnedUnit:GetUnitName(),"flag")==nil then

  	-- if spawnedUnit:GetTeamNumber() ~= GOODGUY_TEAM then
  		-- levelup_crature(spawnedUnit,BADBOY_LVL)
		-- custom_levelup(spawnedUnit,BADBOY_LVL,GAIN)
		if  not IS_PVP then
		if string.find(spawnedUnit:GetUnitName(),"boss")~=nil then
			-- local waveinfo= "#boss_warn"
			-- local waveinfo_e=string.format("<font color='#FF0000'>WARNING！WARNING！A Strong Boss Is Coming ！</font>")
			-- GameRules:SendCustomMessage(waveinfo, 0,0) 
			DeepPrintTable(HistoryBoss)
			if not intable (spawnedUnit:GetUnitName() , HistoryBoss) then
				GameRules:GetGameModeEntity():SetCameraDistanceOverride(1800)
				for i=0,4 do					
					PlayerResource:SetCameraTarget(i,spawnedUnit)
				end
				table.insert(HistoryBoss,spawnedUnit:GetUnitName())
				spawnedUnit:SetThink( "DeleyThink", self, 1.5)
			end
		end
		end
  	end
end





function OOW:OnWaypointStartTouch( hero, team, heroIndex )
	local teleportUnit = EntIndexToHScript( heroIndex )
	if teleportUnit:IsRealHero() ~= true then
		return
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print(hero .. " is using the waypoint" )
		local heroHandle = EntIndexToHScript(heroIndex)
		local player = heroHandle:GetPlayerID()
		
		heroHandle:Stop()
		--DoEntFire( "death_".. m_team_name[team] .."_teleport", "TeleportEntity", hero, 0, self, self )
		local exit = Entities:FindByName( nil, "teleport_exit" )
		-- if team == DOTA_TEAM_BADGUYS then
		-- 	exit = Entities:FindByName( nil, "death_dire_teleport" )
		-- end
		local exitPosition = exit:GetAbsOrigin()
		-- Teleport the hero
		FindClearSpaceForUnit( heroHandle, exitPosition, true );

		local tpEffects = ParticleManager:CreateParticle( "particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015.vpcf", PATTACH_ABSORIGIN, heroHandle )
		ParticleManager:SetParticleControlEnt( tpEffects, PATTACH_ABSORIGIN, heroHandle, PATTACH_ABSORIGIN, "attach_origin", heroHandle:GetAbsOrigin(), true )
		heroHandle:Attribute_SetIntValue( "effectsID", tpEffects )

		DoEntFire( "teleport_ent", "Start", "", 0, self, self )
		PlayerResource:SetCameraTarget( player, heroHandle )
		StartSoundEvent( "Portal.Hero_Appear", heroHandle )
		heroHandle:SetContextThink( "KillSetCameraTarget", function() return PlayerResource:SetCameraTarget( player, nil ) end, 0.2 )
		heroHandle:SetContextThink( "KillTPEffects", function() return ParticleManager:DestroyParticle( tpEffects, true ) end, 3 )
	end
end

function OOW:OnTrapStartTouch( hero, team, heroIndex )
	local teleportUnit = EntIndexToHScript( heroIndex )
	if teleportUnit:IsRealHero() ~= true then
		return
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print(hero .. " is using the waypoint" )
		local heroHandle = EntIndexToHScript(heroIndex)
		local player = heroHandle:GetPlayerID()
		
		heroHandle:Stop()
		--DoEntFire( "death_".. m_team_name[team] .."_teleport", "TeleportEntity", hero, 0, self, self )
		local exit = Entities:FindByName( nil, "teleport_exit" )
		-- if team == DOTA_TEAM_BADGUYS then
		-- 	exit = Entities:FindByName( nil, "death_dire_teleport" )
		-- end
		local exitPosition = exit:GetAbsOrigin()
		-- Teleport the hero
		FindClearSpaceForUnit( heroHandle, exitPosition, true );

		local tpEffects = ParticleManager:CreateParticle( "particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015.vpcf", PATTACH_ABSORIGIN, heroHandle )
		ParticleManager:SetParticleControlEnt( tpEffects, PATTACH_ABSORIGIN, heroHandle, PATTACH_ABSORIGIN, "attach_origin", heroHandle:GetAbsOrigin(), true )
		heroHandle:Attribute_SetIntValue( "effectsID", tpEffects )

		DoEntFire( "teleport_ent", "Start", "", 0, self, self )
		PlayerResource:SetCameraTarget( player, heroHandle )
		StartSoundEvent( "Portal.Hero_Appear", heroHandle )
		heroHandle:SetContextThink( "KillSetCameraTarget", function() return PlayerResource:SetCameraTarget( player, nil ) end, 0.2 )
		heroHandle:SetContextThink( "KillTPEffects", function() return ParticleManager:DestroyParticle( tpEffects, true ) end, 3 )
	end
end


function OOW:OnDisconnect( event )
	print("OnDisconnect")
	-- PrintTable(event)
end

function OOW:PlayerConnect( event )
	print("PlayerConnect")
	-- PrintTable(event)
end

function OOW:StartDisconnectDetection()

	print ("StartDisconnectDetection ")
	self.bStartDisconnectStateTracking = true
	GameRules.vDisconnectedHeroes = {}

	-- 初始化双方连接玩家的数量
	self.nConnectedPlayersGoodGuys = 0
	self.nConnectedPlayersBadGuys = 0

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("connect_timer"), function() 

		if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
			return nil
		end

		local vDisconnecteThisTime = {}
		local vReconnectedThisTime = {}
		for id = 0, DOTA_MAX_TEAM_PLAYERS do
			self.vPlayerState = self.vPlayerState or {}
			self.vPlayerState[id] = self.vPlayerState[id] or {}
			self.vPlayerState[id].nConnectionState = self.vPlayerState[id].nConnectionState or nil
			if self.vPlayerState[id].nConnectionState ~= PlayerResource:GetConnectionState(id) then
				self.vPlayerState[id].nConnectionState = PlayerResource:GetConnectionState(id)
				if PlayerResource:GetConnectionState(id) == DOTA_CONNECTION_STATE_DISCONNECTED then
					print(id .. string.format("DISCONNECTED state detected %s", PlayerResource:GetConnectionState(id)))
					self.vPlayerState[id].bDisconnected = true
					vDisconnecteThisTime[id] = true
				end
				if PlayerResource:GetConnectionState(id) == DOTA_CONNECTION_STATE_CONNECTED then
					print(id .. string.format("RECONNECTED state detected %s", PlayerResource:GetConnectionState(id)))
					self.vPlayerState[id].bDisconnected = false
					vReconnectedThisTime[id] = true
				end
			end
		end

		for id = 0, DOTA_MAX_TEAM_PLAYERS do
			if self.vPlayerState[id] and self.vPlayerState[id].bDisconnected and vDisconnecteThisTime[id] then
				print ("disconnect player id "..id)
				local hero  = get_hero_by_player(id)

				if hero then
					local hero_name = hero:GetUnitName()
					local player_name = PlayerResource:GetPlayerName(id)
					local display_duration = 5
					Notifications:BottomToAll({hero = hero_name, duration = display_duration})
					Notifications:BottomToAll({text = player_name.." ", duration = display_duration, continue = true})
					Notifications:BottomToAll({text = "#has_abaddon_the_game", duration = display_duration, style = {color = "red"}, continue = true})
					hero:RemoveModifierByName("modifier_invulnerable")
					hero:RemoveModifierByName("modifier_invisible")
					hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
					hero:AddNewModifier(hero, nil, "modifier_phased", {})
					hero:AddNewModifier(hero, nil, "modifier_silence", {})
					hero:AddNewModifier(hero, nil, "modifier_invisible", {})
					hero:AddNewModifier(hero, nil, "modifier_disarmed", {})
					hero:AddNewModifier(hero, nil, "modifier_rooted", {})
					-- hero:SetAbsOrigin(Vector(9999,9999,0))
					GameRules.vDisconnectedHeroes[hero] = GameRules:GetGameTime() - self.flPreGameTime
				end
			end
			if self.vPlayerState[id] and not self.vPlayerState[id].bDisconnected and vReconnectedThisTime[id] then
				local player = PlayerResource:GetPlayer(id)
				local hero = player:GetAssignedHero()
				if hero then
				local hero_name = hero:GetUnitName()
					local player_name = PlayerResource:GetPlayerName(id)
					-- local   = false
					local display_duration = 1
					Notifications:BottomToAll({hero = hero_name, duration = display_duration})
					Notifications:BottomToAll({text = player_name.." ", duration = display_duration, continue = true})
					Notifications:BottomToAll({text = "#reconnected_to_game", duration = display_duration, style = {color = "DodgerBlue"}, continue = true})
					GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("reconnect_delay"), function()
						hero:RemoveModifierByName("modifier_invulnerable")
						hero:RemoveModifierByName("modifier_invisible")
						hero:RemoveModifierByName("modifier_silence")
						hero:RemoveModifierByName("modifier_phased")
						hero:RemoveModifierByName("modifier_disarmed")
						hero:RemoveModifierByName("modifier_rooted")
						-- local random_pos =  GetRandomElement(GameRules.CreepSystem.WorldSpawnLocations)
						-- FindClearSpaceForUnit(hero, random_pos, true)
						-- FindClearSpace(hero,3000,100)
						GameRules.vDisconnectedHeroes[hero] = nil
					end, 2)
				end
			end
		end

		-- local nConnectedPlayersBadGuys = 0
		-- local nConnectedPlayersGoodGuys = 0

		-- for id = 0, DOTA_MAX_TEAM_PLAYERS do
		-- 	if not self.vPlayerState[id].bDisconnected then
		-- 		local team = PlayerResource:GetTeam(id)
		-- 		if team == DOTA_TEAM_GOODGUYS then
		-- 			nConnectedPlayersGoodGuys = nConnectedPlayersGoodGuys + 1
		-- 		end
		-- 		if team == DOTA_TEAM_BADGUYS then
		-- 			nConnectedPlayersBadGuys = nConnectedPlayersBadGuys + 1
		-- 		end
		-- 	end	
		-- end
		return 1
	end, 1)

end