--[[
Dota PvP game mode
]]
if OOW == nil then
	_G.OOW = class({}) -- put OOW in the global scope
end


require( "itemfunctions" )
require("dota_pvp")
require("utils")
require("heroes")
require("data")
require("Spawner")
require("Wave")
require("Hero")
require("amhc_library/amhc")
require("sounds")
require("libraries/notifications")
require("libraries/timers")
require("events")

print( "Dota PvP game mode loaded." )

AMHCInit()


MAX_LEVEL = 50
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = i * 200
end

-- Current_Hard_Level = 2

GAIN = 0.5

GOODGUY_TEAM = 2

BADGUY_TEAM = 3

HistoryBoss = {}

IS_PVP = false

SCORE = {good =0,bad=0}

WIN_SCORE = 999

-- DOTA_TEAM_NEUTRALS , DOTA_TEAM_GOODGUYS  , DOTA_TEAM_BADGUYS

function Precache( context )
	print("precache start")
	--Cache the creature models
	PrecacheItemByNameSync( "item_blessing_of_heaven", context )
	PrecacheModel( "item_blessing_of_heaven", context )

	PrecacheItemByNameSync( "item_bag_of_gold", context )
	PrecacheModel( "item_bag_of_gold", context )

	PrecacheItemByNameSync( "item_fountain_potion", context )
	PrecacheModel( "item_fountain_potion", context )

	PrecacheItemByNameSync( "item_mango_juice", context )
	PrecacheModel( "item_mango_juice", context )

	PrecacheItemByNameSync( "item_halloween_candy", context )
	PrecacheModel( "item_halloween_candy", context )

	PrecacheItemByNameSync( "item_roshan_call", context )
	PrecacheModel( "item_roshan_call", context )


	-- PrecacheUnitByNameAsync( "npc_dota_creature_basic_zombie", function(unit) end )
 --    PrecacheModel( "npc_dota_creature_basic_zombie", context )
 --    PrecacheUnitByNameAsync( "npc_dota_creature_berserk_zombie", function(unit) end )
 --    PrecacheModel( "npc_dota_creature_berserk_zombie", context )
 --    PrecacheUnitByNameAsync( "slark", function(unit) end )
 --    PrecacheModel( "slark", context )
 --    PrecacheUnitByNameAsync( "meepo", function(unit) end )
 --    PrecacheModel( "meepo", context )
 --    PrecacheUnitByNameAsync( "npc_dota_lone_druid_bear1", function(unit) end )
 --    PrecacheModel( "npc_dota_lone_druid_bear1", context )
 --    PrecacheUnitByNameAsync( "npc_dota_brewmaster_earth_1", function(unit) end )
 --    PrecacheModel( "npc_dota_brewmaster_earth_1", context )
 --    PrecacheUnitByNameAsync( "npc_dota_brewmaster_fire_1", function(unit) end )
 --    PrecacheModel( "npc_dota_brewmaster_fire_1", context )
 --    PrecacheUnitByNameAsync( "npc_dota_brewmaster_storm_1", function(unit) end )
 --    PrecacheModel( "npc_dota_brewmaster_storm_1", context )
 --    PrecacheUnitByNameAsync( "npc_dota_necronomicon_warrior_1", function(unit) end )
 --    PrecacheModel( "npc_dota_necronomicon_warrior_1", context )
 --    PrecacheUnitByNameAsync( "npc_dota_beastmaster_boar", function(unit) end )
 --    PrecacheModel( "npc_dota_beastmaster_boar", context )
 --    PrecacheUnitByNameAsync( "npc_dota_flag", function(unit) end )
 --    PrecacheModel( "npc_dota_flag", context )
 --    PrecacheUnitByNameAsync( "npc_dota_good_flag", function(unit) end )
 --    PrecacheModel( "npc_dota_good_flag", context )
 --    PrecacheUnitByNameAsync( "npc_dota_bad_flag", function(unit) end )
 --    PrecacheModel( "npc_dota_bad_flag", context )
 --    PrecacheUnitByNameAsync( "boss_roshan", function(unit) end )
 --    PrecacheModel( "boss_roshan", context )
 --    PrecacheUnitByNameAsync( "boss_spider", function(unit) end )
 --    PrecacheModel( "boss_spider", context )
 --    PrecacheUnitByNameAsync( "boss_green_dragon", function(unit) end )
 --    PrecacheModel( "boss_green_dragon", context )
 --    PrecacheUnitByNameAsync( "dotb_buiding_defender_fort", function(unit) end )
 --    PrecacheModel( "dotb_buiding_defender_fort", context )

    PrecacheUnitByNameAsync( "npc_dota_dummy_caster", function(unit) end )
    PrecacheModel( "npc_dota_dummy_caster", context )
    PrecacheUnitByNameAsync( "npc_dota_dummy_caster_bad", function(unit) end )
    PrecacheModel( "npc_dota_dummy_caster_bad", context )
    PrecacheUnitByNameAsync( "npc_dota_creep_dire_golem", function(unit) end )
    PrecacheModel( "npc_dota_creep_dire_golem", context )

	-- PrecacheResource( "model", "models/projectiles/mirana_arrow.vmdl", context )
	-- PrecacheResource( "model", "*.vmdl", context )
	-- PrecacheResource( "model", "models/heroes/death_prophet/death_prophet_ghost.vmdl", context )
	-- PrecacheResource( "model", "models/heroes/warlock/warlock_demon.vmdl", context )
	-- PrecacheResource( "soundfile", "*.vsndevts", context )
	-- PrecacheResource( "particle", "*.vpcf", context )
	-- 预存mirana的一些特效，否则其他它的技能无法赋予其他英雄
	-- PrecacheResource( "particle_folder", "particles/units/heroes/hero_tidehunter", context )
	-- PrecacheResource( "soundfile", "soundevents/game_sounds_tidehunter.vsndevts", context )
	-- PrecacheResource( "particle_folder", "particles/units/heroes/hero_broodmother", context )
	-- PrecacheResource( "soundfile", "soundevents/game_sounds_broodmother.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_luna", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_spirit_breaker", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context )
	-- PrecacheResource( "particle_folder", "particles/units/heroes/hero_death_prophet_ghost", context )
	-- PrecacheResource( "soundfile", "soundevents/game_sounds_death_prophet.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_sandking", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_crystalmaiden", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_invoker", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_warlock", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_skeletonking", context )
	
	-- PrecacheResource("particle_folder","particles/units/heroes/hero_vengeful/vengeful_magic_missle",context)
	-- PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_main.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_triggers.vsndevts", context )
	
	PrecacheResource( "particle_folder", "particles/basic_projectile", context )
	PrecacheResource( "particle_folder", "particles/base_attacks", context )
	PrecacheResource( "particle_folder", "particles/econ/items/mirana/mirana_crescent_arrow", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_mirana", context )
	PrecacheResource( "particle_folder", "particles/econ/items/drow/drow_bow_monarch", context )

	PrecacheResource( "particle_folder", "particles/items_fx", context )
	-- PrecacheResource( "particle_folder", "particles/msg_fx", context )
	PrecacheResource( "particle_folder", "particles/econ/items/spectre/spectre_phantasmal", context )
	PrecacheResource( "particle_folder", "particles/econ/items/luna/luna_lucent_ti5", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_omniknight", context )
	PrecacheResource( "particle_folder", "particles/econ/events/fall_major_2015", context )
	PrecacheResource( "particle_folder", "particles/customgames/capturepoints", context )

	print("precache end")
end


--------------------------------------------------------------------------------
-- ACTIVATE
--------------------------------------------------------------------------------
function Activate()
	-- GameRules.OOW = OOW()
	OOW:InitGameMode()
end

function sendTips( msg)
	GameRules:SendCustomMessage(msg,0,0)
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------s------------------------------------------
function OOW:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity()
	GameRules:GetGameModeEntity().OOW = self
	self._startTime = GameRules:GetGameTime() 
	self._gameTime = GameRules:GetGameTime() 
	self._nRoundNumber = 1
	self._currentRound = nil
	self._flLastThinkGameTime = nil
	-- self._entAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	self.isLoad = false
	self.spawners ={}
	self.DropTable = LoadKeyValues("scripts/kv/item_drops.kv")
	self.weatherUnit = nil
	self.ScoreQuest = nil
	-- self.LevelQuest = nil
	-- self.heroes = Heroes()
	-- self.skillGroups = {}
	-- self._tPlayerHeroInitStatus = {}	
	-- Enable the standard Dota PvP game rules
	-- GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( true )
	-- GameRules:SetUseCustomHeroXPValues ( true )
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(MAX_LEVEL)
		-- 必须在SetUseCustomHeroLevels之前调用 --还是没用
	-- GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
	-- GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true) 


	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
	-- GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	-- Show the ending scoreboard immediately	
	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetCustomVictoryMessageDuration( 10 )
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:SetCustomGameSetupAutoLaunchDelay(8)
	GameRules:SetTimeOfDay( 0.01 )
	GameRules:SetHeroRespawnEnabled( true )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetHeroSelectionTime( 20.0 )
	GameRules:SetPreGameTime( 10.0 )
	-- GameRules:SetPostGameTime( 8.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( 18 )	
	-- GameRules:SetHeroMinimapIconSize( 400 )
	-- GameRules:SetCreepMinimapIconScale( 0.7 )
	-- GameRules:SetRuneMinimapIconScale( 0.7 )i
	-- GameRules:GetGameModeEntity():SetFogOfWarDisabled( true )
	-- GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( false )
	GameRules:SetGoldTickTime( 3 )
	GameRules:SetGoldPerTick( 5 )
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	-- GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled( false )
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( false )
	-- GameRules:GetGameModeEntity():SetRuneEnabled( 0, true ) --双倍
	-- GameRules:GetGameModeEntity():SetRuneEnabled( 1, true ) --极速
	-- GameRules:GetGameModeEntity():SetRuneEnabled( 2, true ) --回复
	-- GameRules:GetGameModeEntity():SetRuneEnabled( 3, true ) --Invis
	-- GameRules:GetGameModeEntity():SetRuneEnabled( 4, false ) --幻象
	-- GameRules:GetGameModeEntity():SetRuneEnabled( 5, false ) --Bounty
	GameRules:SetRuneSpawnTime (30)
	GameRules:GetGameModeEntity():SetStickyItemDisabled( true ) --Remove TP Scroll
	-- Register Think
	print("HELLO DOTA**********************************************")
	-- if not IS_PVP then
	-- 	sendTips("#tips")
	-- else
	-- 	sendTips("#tips_pvp")
	-- end
	GameRules:GetGameModeEntity():SetThink( "GameThink", self, 1 ) 

  -- Event Hooks
  -- All of these events can potentially be fired by the game, though only the uncommented ones have had
  -- Functions supplied for them.  If you are interested in the other events, you can uncomment the
  -- ListenToGameEvent line and add a function to handle the event
  -- ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(OOW, 'OnPlayerLevelUp'), self)
  -- ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(OOW, 'OnAbilityChannelFinished'), self)
  -- ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(OOW, 'OnPlayerLearnedAbility'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(OOW, 'OnEntityKilled'), self)
  -- ListenToGameEvent('player_connect_full', Dynamic_Wrap(OOW, 'OnConnectFull'), self)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(OOW, 'OnDisconnect'), self)
  -- ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(OOW, 'OnItemPurchased'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(OOW, 'OnItemPickUp'), self)
  -- ListenToGameEvent('last_hit', Dynamic_Wrap(OOW, 'OnLastHit'), self)
  -- ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(OOW, 'OnNonPlayerUsedAbility'), self)
  -- ListenToGameEvent('player_changename', Dynamic_Wrap(OOW, 'OnPlayerChangedName'), self)
  -- ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(OOW, 'OnRuneActivated'), self)
  -- ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(OOW, 'OnPlayerTakeTowerDamage'), self)
  -- ListenToGameEvent('tree_cut', Dynamic_Wrap(OOW, 'OnTreeCut'), self)
  -- ListenToGameEvent('entity_hurt', Dynamic_Wrap(OOW, 'OnEntityHurt'), self)
  ListenToGameEvent('player_connect', Dynamic_Wrap(OOW, 'PlayerConnect'), self)
  -- ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(OOW, 'OnAbilityUsed'), self)
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(OOW, 'OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(OOW, 'OnNPCSpawned'), self)
  -- ListenToGameEvent("player_reconnected", Dynamic_Wrap(OOW, 'OnPlayerReconnect'), self)
  ListenToGameEvent('player_spawn', Dynamic_Wrap(OOW, 'OnPlayerSpawn'), self)
  --ListenToGameEvent('dota_unit_event', Dynamic_Wrap(GameMode, 'OnDotaUnitEvent'), self)
  --ListenToGameEvent('nommed_tree', Dynamic_Wrap(GameMode, 'OnPlayerAteTree'), self)
  --ListenToGameEvent('player_completed_game', Dynamic_Wrap(GameMode, 'OnPlayerCompletedGame'), self)
  --ListenToGameEvent('dota_match_done', Dynamic_Wrap(GameMode, 'OnDotaMatchDone'), self)
  --ListenToGameEvent('dota_combatlog', Dynamic_Wrap(GameMode, 'OnCombatLogEvent'), self)
  --ListenToGameEvent('dota_player_killed', Dynamic_Wrap(GameMode, 'OnPlayerKilled'), self)
  --ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)
  -- ListenToGameEvent('player_hurt',  Dynamic_Wrap(OOW, 'OnPlayerHurt'), self)
  -- ListenToGameEvent('entity_hurt',  Dynamic_Wrap(OOW, 'OnEntityHurt'), self)
  ListenToGameEvent('dota_player_pick_hero',  Dynamic_Wrap(OOW, 'OnHeroSelected'), self)

  GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( OOW, "ModifyGoldFilter" ), self )
  GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( OOW, "ModifyExperienceFilter" ), self )
  -- 监听PUI的事件
  -- CustomGameEventManager:RegisterListener( "OnHardLevelSelect", OnHardLevelSelect )
  -- CustomGameEventManager:RegisterListener( "OnContinueOrCancel", OnContinueOrCancel )


  -- self:BuildTrees()
  self:LoadSpawners()
  self:SetUpFountains()

end

function OOW:ModifyGoldFilter( filterTable )
	--[[for k, v in pairs( filterTable ) do
		print("ModifyGold: " .. k .. " " .. tostring(v) )
	end
	]]
	--local reason = filterTable["reason_const"]
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return false
	end
	return true
end


function OOW:ModifyExperienceFilter( filterTable )
	--[[for k, v in pairs( filterTable ) do
		print("ModifyXP: " .. k .. " " .. tostring(v) )
	end
	]]
	--local reason = filterTable["reason_const"]
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return false
	end
	return true
end


function OOW:SetUpFountains()

	LinkLuaModifier( "modifier_fountain_aura_lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_fountain_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

	local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
	for _,fountainEnt in pairs( fountainEntities ) do
		--print("fountain unit " .. tostring( fountainEnt ) )
		fountainEnt:AddNewModifier( fountainEnt, nil, "modifier_fountain_aura_lua", {} )

	end
end


function OOW:EnableWaypoint( )
	local entranceRadiant = Entities:FindByName( nil, "teleport_ent" )
	local exitRadiant = Entities:FindByName( nil, "teleport_exit" )
	if entranceRadiant ~= nil and exitRadiant ~= nil then
		print ("AddMinimapDebugPoint")
		GameRules:AddMinimapDebugPoint( -entranceRadiant:entindex(), entranceRadiant:GetAbsOrigin(), 0, 255,0, 300, 100)
		GameRules:AddMinimapDebugPoint( -exitRadiant:entindex(), exitRadiant:GetAbsOrigin(), 0, 255, 0, 200, 300)
		PingMiniMapAtLocation(entranceRadiant:GetAbsOrigin() )
		PingMiniMapAtLocation(exitRadiant:GetAbsOrigin() )
	end
end

function OOW:EnableBosspoint()
	for i=1,4 do
		local cp = Entities:FindByName( nil, "sp_boss"..i )
		if cp~=nil then
	  		PingMiniMapAtLocation(cp:GetAbsOrigin() )
	  		GameRules:AddMinimapDebugPoint( -cp:entindex(), cp:GetAbsOrigin(), 255,0, 255, 300, 100)	
	  	end	
	end
end

function OOW:EnableRunepoint()
	for i=1,4 do
		local cp = Entities:FindByName( nil, "dota_item_rune_spawner"..i )
		if cp~=nil then
	  		PingMiniMapAtLocation(cp:GetAbsOrigin() )
	  		GameRules:AddMinimapDebugPoint( -cp:entindex(), cp:GetAbsOrigin(), 0,0, 255, 300, 100)	
	  	end	
	end
end

function OOW:EnableBlessingPoint(  )


	-- 固定地点宝箱
	for i=1,2 do

		local cp = Entities:FindByName( nil, "cp_"..i )
		if cp~=nil then
	  		PingMiniMapAtLocation(cp:GetAbsOrigin() )
	  		GameRules:AddMinimapDebugPoint( -cp:entindex(), cp:GetAbsOrigin(), 255, 255, 0, 300, 100)

  Timers:CreateTimer(30*i, function()
  	  local cp = Entities:FindByName( nil, "cp_"..i )
      local item_name = "item_blessing_of_heaven"
      -- print("Creating "..item_name)
      local item = CreateItem(item_name, nil, nil)
      item:SetPurchaseTime(0)
      local pos = cp:GetAbsOrigin()
      local drop = CreateItemOnPositionSync( pos, item )
      EmitAnnouncerSound( "announcer_ann_custom_adventure_alerts_45" )
      -- local pos_launch = pos+RandomVector(RandomFloat(150,200))
      StartSoundEvent( "RPG_Main.ItemLanded", item)
      PingMiniMapAtLocation(pos)
      item:LaunchLoot(false, 200, 0.75, pos)
      -- return 10.0
      return 60.0
    end
  )
	end
	end

	-- 随机地点宝箱
  Timers:CreateTimer(45, function()
  	  -- local cp = Entities:FindByName( nil, "cp_"..i )

      local item_name = "item_blessing_of_heaven"
      -- print("Creating "..item_name)
      local item = CreateItem(item_name, nil, nil)
      item:SetPurchaseTime(0)
      local pos = FindClearSpacePos(2000,100)
      local drop = CreateItemOnPositionSync( pos, item )
      EmitAnnouncerSound( "announcer_ann_custom_generic_alert_73" )
      -- local pos_launch = pos+RandomVector(RandomFloat(150,200))
      StartSoundEvent( "RPG_Main.ItemLanded", item)
      -- PingMiniMapAtLocation(pos)
      item:LaunchLoot(false, 200, 0.75, pos)
      -- return 20.0
      return RandomInt(30, 60) 
    end
  )


end



function OOW:BuildTrees(  )
	for i=1,20 do
  		self:PlantTrees()
	end
end

function OOW:PlantTrees(  )
	local nextPos = RandomVector(RandomFloat(600,7000))
	CreateTempTree(nextPos,999999999)	
	for i=1,200 do
		nextPos = nextPos+RandomVector(RandomInt(40, 90))
		if not GridNav:IsNearbyTree(nextPos,39,true) then
			CreateTempTree(nextPos,999999999)
		end
	end

end




continue_count = 0

function OnContinueOrCancel( index,keys )
	local dec = tonumber(keys.select)
	print ("OnContinueOrCancel " .. keys.select)
	continue_count =  continue_count + dec
end

function OnHardLevelSelect(  index,keys )
	print (index)
	-- DeepPrintTable(keys.table) 
	local lvl = keys.table
	print("hard level" .. lvl)
	local nLvl = tonumber(string.sub(lvl,5))
	Current_Hard_Level = nLvl
	GAIN = hard_level[nLvl]
	print(tostring(GAIN))
end

function OOW:OnEntityHurt( event )
	print("entity_hurt>>>>>>>>>>>")
	-- PrintTable(event)
	DeepPrintTable(evetn)
	print("<<<<<<<<<<<entity_hurt")
end

function OOW:OnPlayerHurt( event )
	print("player_hurt>>>>>>>>>>>")
	PrintTable(event)
	print("<<<<<<<<<<<player_hurt")
end

function OOW:OnPlayerLevelUp( event )
	print("OnPlayerLevelUp")
	PrintTable(event)	
end

function OOW:OnAbilityChannelFinished( event )
	print("OnAbilityChannelFinished")
	PrintTable(event)
end

function OOW:OnPlayerLearnedAbility( event )
	print("OnPlayerLearnedAbility")
	PrintTable(event)
end

function OOW:RollDrops(unit)
    local DropInfo = self.DropTable[unit:GetUnitName()]
    if not DropInfo then
    	DropInfo = self.DropTable["Default"]
    end
    if DropInfo then
        -- print("Rolling Drops for "..unit:GetUnitName())
        for k,ItemTable in pairs(DropInfo) do
            -- If its an ItemSet entry, decide which item to drop
            local item_name
            if ItemTable.ItemSets then
                -- Count how many there are to choose from
                local count = 0
                for i,v in pairs(ItemTable.ItemSets) do
                    count = count+1
                end
                local random_i = RandomInt(1,count)
                item_name = ItemTable.ItemSets[tostring(random_i)]
            else
                item_name = ItemTable.Item
            end
            local chance = ItemTable.Chance or 100
            local max_drops = ItemTable.Multiple or 1
            for i=1,max_drops do
                -- print("Rolling chance "..chance)
                if RollPercentForFloat(chance) then
                    print("Creating "..item_name)
                    local item = CreateItem(item_name, nil, nil)
                    item:SetPurchaseTime(0)
                    local pos = unit:GetAbsOrigin()
                    local drop = CreateItemOnPositionSync( pos, item )
                    local pos_launch = pos+RandomVector(RandomFloat(150,200))
                    item:LaunchLoot(false, 200, 0.75, pos_launch)
                end
            end
        end
    end
end

function RollPercentForFloat(chance)
	if chance>=1 then 
		return RollPercentage(chance)
	elseif chance>=0.1 then
		return RollPercentage(chance*10) and RollPercentage(10)
	elseif chance>=0.01 then 
		return RollPercentage(chance*100) and RollPercentage(1)
	elseif chance>=0.001 then
		return RollPercentage(chance*1000) and RollPercentage(1) and RollPercentage(10)
	elseif chance>=0.0001 then
		return RollPercentage(chance*10000) and RollPercentage(1) and RollPercentage(1)
	else return false
		end
end

-- 清理物品
function OOW:ThinkLootExpiration()
	local flCutoffTime = GameRules:GetGameTime() - 30
	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if containedItem ~= nil then
			if containedItem:GetAbilityName() == "item_bag_of_gold" 
				or containedItem:GetAbilityName() == "item_fountain_potion" 
				or containedItem:GetAbilityName() == "item_mango_juice"
				-- or containedItem:GetAbilityName() == "item_blessing_of_heaven"
				or containedItem:GetAbilityName() == "item_halloween_candy" then
					OOW:ProcessItemForLootExpiration( item, flCutoffTime )
			end
		end
	end
end

function OOW:ProcessItemForLootExpiration( item, flCutoffTime )
	if item:IsNull() then
		return false
	end
	if item:GetCreationTime() >= flCutoffTime then
		return true
	end

	local containedItem = item:GetContainedItem()
	if containedItem and containedItem:GetAbilityName() == "item_bag_of_gold" then
		if self._currentRound and self._currentRound.OnGoldBagExpired then
			self._currentRound:OnGoldBagExpired()
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
	ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	local inventoryItem = item:GetContainedItem()
	if inventoryItem then
		UTIL_Remove( inventoryItem )
	end
	EmitGlobalSound("Item.PickUpWorld")
	UTIL_Remove( item )
	return false

end



function OOW:OnConnectFull( event )
	print("OnConnectFull")
	PrintTable(event)
end
function OOW:OnItemPurchased( event )
	print("OnItemPurchased")
	PrintTable(event)
end
function OOW:OnItemPickedUp( event )
	print("OnItemPickedUp")
	PrintTable(event)
end
function OOW:OnLastHit( event )
	print("OnLastHit")
	PrintTable(event)
end
function OOW:OnAbilityUsed( event )
	-- print("OnAbilityUsed")
	-- Notifications:TopToAll({hero="npc_dota_hero_axe", duration=5.0})
	-- Notifications:TopToAll({hero="npc_dota_hero_axe", imagestyle="landscape", continue=true})
	-- Notifications:TopToAll({hero="npc_dota_hero_axe", imagestyle="portrait", continue=true})
	-- EmitGlobalSound( "announcer_ann_custom_adventure_alerts_41" )
	-- GameRules:SetGameWinner( 2 )
	-- PrintTable(event)
end
function OOW:OnPlayerChangedName( event )
	print("OnPlayerChangedName")
	PrintTable(event)
end
function OOW:OnRuneActivated( event )
	print("OnRuneActivated")
	PrintTable(event)
end
function OOW:OnPlayerTakeTowerDamage( event )
	print("OnPlayerTakeTowerDamage")
	PrintTable(event)
end

function OOW:OnPlayerSpawn( event )
	print("OnPlayerSpawn")
	PrintTable(event)
end

function OOW:OnHeroSelected( event )
	print("OnHeroSelected")
	-- local hero = EntIndexToHScript( event.heroindex )
 --  	OOW:InitHeroAttribute(hero) 	

end



function OOW:DeleyThink()
	if GameRules:GetGameModeEntity():GetCameraDistanceOverride()>1134 then
		for i=0,4 do
			PlayerResource:SetCameraTarget(i,get_hero_by_player(i))
		end
		GameRules:GetGameModeEntity():SetCameraDistanceOverride(1134)
		return 0.2
	else
		for i=0,4 do
			PlayerResource:SetCameraTarget(i,nil)
		end
		return nil
	end
end

function OOW:InitHeroAttribute( hero )
	print ("InitHeroAttribute  player id ".. hero:GetPlayerID()  )
  	InitHeroInfo(hero)
	-- print ("InitHeroAttribute" .. DeepPrintTable(hero:GetOwner())   )

end



function OOW:OnPlayerReconnect( event )
	print("OnPlayerReconnect")
	PrintTable(event)
end
function OOW:OnGameRulesStateChange( event )
	print("OnGameRulesStateChange")
	-- PrintTable(event)
 --         local state = GameRules:State_Get()
  
 --         if state == DOTA_GAMERULES_STATE_PRE_GAME then
 --                   --调用UI
 --                   CustomUI:DynamicHud_Create(-1,"mainWin","file://{resources}/layout/custom_game/game_info.xml",nil)
 --         end
end

function OOW:LoadSpawners(  )
	print("OOW:LoadSpawners" ..#spawner_table)
	for i=1,#spawner_table do
		local spawner = Entities:FindByName(nil, spawner_table[i].name)
		if spawner then
			print("player number"..PlayerResource:GetPlayerCount())
			if (spawner_table[i].name=="sp_ore" or spawner_table[i].name=="sp_mill") and PlayerResource:GetPlayerCount()<=2 then
				print("Player less than 3")
			else
				print(spawner_table[i])
				local sp = Spawner()
				sp:Load(spawner_table[i])
				sp:Begin()
				table.insert(self.spawners,sp)
			end
		end
	end
end




weather_interval = 300
lastCastTime = 0
weather_abilities = {
	"crystal_maiden_freezing_field",
	"invoker_tornado",
	"warlock_rain_of_chaos",	
	-- "invoker_sun_strike",
}
casters = {}
function OOW:CreateWeatherCaster(  )
		self.weatherUnit = CreateUnitByName("npc_dota_dummy_caster_bad",Entities:FindByName( nil, "npc_dota_smithy"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
		-- DeepPrintTable(entUnit:FindAbilityByName("crystal_maiden_freezing_field"))
		lastCastTime = GameRules:GetGameTime()
		

		self.Quest = SpawnEntityFromTableSynchronous( "quest", {
        name = "QuestName",
        title = "#BadWeather" 
    	})
		self.subQuest = SpawnEntityFromTableSynchronous( "subquest_base", {
    	show_progress_bar = true,
    	progress_bar_hue_shift = -119
		} )
		self.Quest.EndTime = weather_interval
		self.Quest:AddSubquest( self.subQuest )

		-- 启动时文本
		self.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.Quest.EndTime )
		self.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, self.Quest.EndTime )

		-- 进度条上的值
		self.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.Quest.EndTime )
		self.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, self.Quest.EndTime )

		for i=1,2 do
			for m=1,25 do
				if not casters[m] then
					local caster = CreateUnitByName("npc_dota_dummy_caster_bad",Entities:FindByName( nil, "npc_dota_smithy"):GetAbsOrigin()+ RandomVector( RandomFloat( -5000, 5000 )), true, nil, nil, BADGUY_TEAM)
					table.insert(casters,caster)
				end				
				-- caster:SetAbsOrigin(Entities:FindByName( nil, "npc_dota_smithy"):GetAbsOrigin() + RandomVector( RandomFloat( -5000, 5000 )) )
				casters[m]:CastAbilityOnPosition(casters[m]:GetAbsOrigin()+ RandomVector( RandomFloat( -50, 50)), casters[m]:FindAbilityByName(weather_abilities[i]),-1)
			end
		end
		self.weatherUnit:SetThink( "WeatherThink", self, 1)
end

function OOW:WeatherThink( )
	self.Quest.EndTime = weather_interval - GameRules:GetGameTime() + lastCastTime
	-- if GameRules:GetGameTime()-lastCastTime>=weather_interval then

	-- self.Quest.EndTime = self.Quest.EndTime -1
	if self.Quest.EndTime <=0 then
		self.Quest.EndTime = weather_interval
		-- print("cast "..abl)
		
		for i=1,25 do
			local abl = weather_abilities[RandomInt(1, #weather_abilities)]
			-- local abl = weather_abilities[RandomInt(1, 4)]
			-- print("cast "..abl)			
			-- casters[i]:CastAbilityImmediately( casters[i]:FindAbilityByName(abl),-1)
			if  abl=="invoker_tornado" then
				casters[i]:CastAbilityImmediately(casters[i]:FindAbilityByName(abl),-1)
			else
				casters[i]:CastAbilityOnPosition(casters[i]:GetAbsOrigin()+ RandomVector( RandomFloat( -5000, 5000)), casters[i]:FindAbilityByName(abl),-1)
			end
			casters[i]:SetAbsOrigin(Entities:FindByName( nil, "npc_dota_smithy"):GetAbsOrigin() + RandomVector( RandomFloat( -8000, 8000 )) )
			-- self.weatherUnit:CastAbilityImmediately( self.weatherUnit:FindAbilityByName(abl),-1)
		end
		lastCastTime = GameRules:GetGameTime()
	end
	self.Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.Quest.EndTime )
	self.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.Quest.EndTime )	
	return 1
end

function OOW:ShowHardLevel(  )
		CustomGameEventManager:Send_ServerToAllClients( "hard_change", {hard = Current_Hard_Level} )
end

function OOW:ShowScore()
		self.ScoreQuest = SpawnEntityFromTableSynchronous( "quest", {
        name = "QuestName",
        title = "#Score"
    	})	
		-- 启动时文本
		self.ScoreQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, SCORE.good )
		self.ScoreQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, SCORE.bad )
end

--------------------------------------------------------------------------------
function OOW:GameThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- 定期清理物品
		OOW:ThinkLootExpiration()
		-- print( "Template addon script is running." )
		-- if GameRules:GetGameTime() > self.gameTime+9   then
			
		-- end
		if not self.isLoad then
		-- if not IS_PVP then
		-- 	self:ShowHardLevel()
		-- 	sendTips("#tips")
		-- else
		-- 	sendTips("#tips_pvp")
		-- end
		-- self:LoadSpawners()
		-- self:LoadSkillGroups()
		continue_count =  PlayerResource:GetPlayerCount()
		self:EnableBlessingPoint()
		self:EnableWaypoint()
		self:EnableRunepoint()
		self:EnableBosspoint()
		self.isLoad = true
		-- self:CreateWeatherCaster()
		-- EmitGlobalSound("Bgm.Bgm")
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 10 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 10 )
		self.flPreGameTime = GameRules:GetGameTime()
		self:StartDisconnectDetection()
		end


	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
			return nil
	end
		self._gameTime = GameRules:GetGameTime() 
		BADBOY_LVL = (self._gameTime - self._startTime) / 120 
		if 	BADBOY_LVL < 1 then
			BADBOY_LVL = 1
		end
		-- print("Game Time "..self._gameTime .. " "..BADBOY_LVL)
		local fort1 = Entities:FindByName( nil, "dotb_buiding_defender_fort1")
		local fort2 = Entities:FindByName( nil, "dotb_buiding_defender_fort2")
		local fort_good = Entities:FindByName( nil, "dota_goodguys_fort")
		if fort_good then
			fort_good:SetThink("CameraThink",self,0.1)
		end

	return 1.5
end

function OOW:DefenseWin( )
   -- local change =
   --   {
   --     building = name,
   --     team = team
   --   }
  --  -- 发送事件到所有客户端UI
	if Current_Hard_Level<7 then
  		CustomGameEventManager:Send_ServerToAllClients( "game_round_end", nil )
  		self:StartDecisionThink()
  	else
  		GameRules:SetGameWinner(GOODGUY_TEAM)
  	end
end

function OOW:StartDecisionThink(  )
	local fort_good = Entities:FindByName( nil, "dota_goodguys_fort")
	if fort_good then
		fort_good:SetThink("DecisionThink",self,4.0)
	end
end

function OOW:DecisionThink()
	if continue_count > 0 then
		Current_Hard_Level = Current_Hard_Level + 1
		SCORE.good = 0
		continue_count = PlayerResource:GetPlayerCount()
		CustomGameEventManager:Send_ServerToAllClients( "game_continue", {hard = Current_Hard_Level} )
		self:ShowHardLevel()
	else
		GameRules:SetGameWinner(GOODGUY_TEAM)
	end
	return nil
end

function OOW:CameraThink()
	local dis = GameRules:GetGameModeEntity():GetCameraDistanceOverride()
	if dis>1144 then
		GameRules:GetGameModeEntity():SetCameraDistanceOverride(dis-5)
		return 0.01
	elseif dis>1139 then
		GameRules:GetGameModeEntity():SetCameraDistanceOverride(1134)
		return nil
	end
end

function OOW:EndGame( victoryTeam )
	GameRules:SetGameWinner( victoryTeam )
end

function UpdateState(  )
end

function CalExDamage( hero )
	local int  = hero:GetIntellect() 
	return int*4
end

function OOW:TestBaseCommand( args )
	local cmd,parms = args[0] , args[1]

	if cmd == "print"  then
		print(parms)
	elseif 
		cmd == "cast" then
		self.CastSkill(parms)
	end
	-- body
end

function OOW:CastSkill( skill )
	-- body
	print("cast skill" .. skill)
end


