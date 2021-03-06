--[[ traps.lua ]]

function tablefirstkey( T )
	for k, _ in pairs( T ) do return k end
	return nil
end

function tablehaselements( T )
	return tablefirstkey( T ) ~= nil
end


---------------------------------------------------------------------------
-- Fire and Venom Traps
---------------------------------------------------------------------------
function CConquestGameMode:OnTrapStartTouch( index, team, level, hActivatingHero )

	m_trap_info[index].touchers[team][hActivatingHero] = true

	local trapName = m_trap_info[index].npc_name
	local button = trapName .. "_button"

	local ownerTeam = m_trap_info[index].owner

	--Animate the button model
	if m_trap_info[index].isButtonReady == true then
		EmitGlobalSound("ui_menu_activate_open")
		--DoEntFire( button, "SetAnimation", "ancient_trigger001_down_up", 0, self, self )
		--DoEntFire( button, "SetDefaultAnimation", "ancient_trigger001_down_idle", 0.5, self, self )
		m_trap_info[index].isButtonReady = false
	end

	--Check to see if it is blocked
	local bBlocked = tablehaselements( m_trap_info[index].touchers[DOTA_TEAM_GOODGUYS] ) and tablehaselements( m_trap_info[index].touchers[DOTA_TEAM_BADGUYS] )
	if bBlocked then
		print("Button is blocked")
		EmitGlobalSound("Conquest.TrapButton.Blocked")
		m_trap_info[index].isTrapActivated = false
	elseif team == ownerTeam then
		print("Activate the trap")
		local trapName = m_trap_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		m_trap_info[index].isTrapActivated = true
		npc.KillerToCredit = tablefirstkey( m_trap_info[index].touchers[ownerTeam] )
		npc:SetContextThink( "ActivateTrap", function() return CConquestGameMode:TrapActivate( index ) end, 0 )
	end
end

function CConquestGameMode:TrapActivate( index )
	--print("Attempting to activate trap")
	if m_trap_info[index].isTrapActivated == true then
		--print("Trap is activated")
		local trapName = m_trap_info[index].npc_name
		local trapTarget = m_trap_info[index].targetName
		local target = Entities:FindByName( nil, trapTarget )
		local npc = Entities:FindByName( nil, trapName )
		--Secondary Traps
		local altTrapName = m_trap_info[index].npc_name_alt
		local altTrapTarget = m_trap_info[index].targetName_alt
		local altTarget = Entities:FindByName( nil, altTrapTarget )
		local altNPC = Entities:FindByName( nil, altTrapName )
		--Animating Models
		local modelName = m_trap_info[index].modelName
		local model = Entities:FindByName( nil, modelName )
		local altModelName = m_trap_info[index].modelName_alt
		local altModel = Entities:FindByName( nil, altModelName )

		local fireTrap = npc:FindAbilityByName("breathe_fire")
		local venomTrap = npc:FindAbilityByName("breathe_poison")

		-- Tell the Alt NPC about the Killer to Credit from the proper NPC
		if altNPC ~= nil then
			altNPC.KillerToCredit = npc.KillerToCredit
		end

		local trapUsed = nil
		--print(level)
		if target ~= nil then
			if index < 7 then
				--print("Activating Fire Trap")
				fireTrap.targetLevel = level
				trapUsed = fireTrap
				if model ~= nil then
					DoEntFire( modelName, "SetAnimation", "bark_attack", 0, self, self )
				end
				npc:CastAbilityOnPosition(target:GetOrigin(), fireTrap, -1 )
				if altTarget ~= nil then
					if altModel ~= nil then
						DoEntFire( altModelName, "SetAnimation", "bark_attack", 0, self, self )
					end
					local altFireTrap = altNPC:FindAbilityByName("breathe_fire")
					altFireTrap.targetLevel = level
					altNPC:CastAbilityOnPosition(altTarget:GetOrigin(), altFireTrap, -1 )
				end
				return 2
			else
				--print("Activating Venom Trap")
				trapUsed = venomTrap
				DoEntFire( modelName, "SetAnimation", "fang_attack", 0, self, self )
				npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
				if altTarget ~= nil then
					DoEntFire( altModelName, "SetAnimation", "fang_attack", 0, self, self )
					local altVenomTrap = altNPC:FindAbilityByName("breathe_poison")
					altNPC:CastAbilityOnPosition(altTarget:GetOrigin(), altVenomTrap, -1 )
				end
				return 4
			end
		end
	end
	return -1
end

function CConquestGameMode:OnTrapEndTouch( index, team, hActivatingHero )

	m_trap_info[index].touchers[team][hActivatingHero] = nil

	local ownerTeam = m_trap_info[index].owner
	local ownerOpponentTeam = DOTA_TEAM_BADGUYS
	if ownerTeam == DOTA_TEAM_BADGUYS then
		ownerOpponentTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_trap_info[index].touchers[ownerTeam] )
	local bHasEnemies = tablehaselements( m_trap_info[index].touchers[ownerOpponentTeam] )

	--Reset the button model animation
	if goodTouchCount == 0 and badTouchCount == 0 then
		--DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 0, self, self )
		--DoEntFire( button, "SetDefaultAnimation", "ancient_trigger001_idle", 1, self, self )
		m_trap_info[index].isButtonReady = true
	end

	if team == ownerTeam and not bHasAllies then 
		print("Owning team has left")
		m_trap_info[index].isTrapActivated = false
	elseif bHasAllies and team == ownerOpponentTeam and not bHasEnemies then
		print("Button is no longer blocked")
		m_trap_info[index].isTrapActivated = true
		local trapName = m_trap_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_trap_info[index].touchers[ownerTeam] )
		npc:SetContextThink( "ActivateTrap", function() return CConquestGameMode:TrapActivate( index ) end, 0 )
	end
end

---------------------------------------------------------------------------
-- Pendulum Trap
---------------------------------------------------------------------------

function CConquestGameMode:PendulumSetup()
	-- Spawning an env_shake for the pendulum
	local shakeTable = {
		spawnflags = "5", --Global Shake, In Air
		targetname = "pendulum_shake",
		origin = "0 0 192",
		amplitude = "4",
		radius = "5000",
		duration = "5",
		frequency = "2.5"
		}
	local shakeEntity = SpawnEntityFromTableSynchronous( "env_shake", shakeTable )
	local cp3Entity = Entities:FindByName( nil, "cp_particle_03" )
	local shakePosition = cp3Entity:GetAbsOrigin()
	shakeEntity:SetAbsOrigin( shakePosition )
	-- Spawning a particle effect for the pendulum
	local debrisTable = {
		targetname = "pendulum_debris",
		origin = "0 0 512",
		effect_name = "particles/newplayer_fx/npx_landslide_debris.vpcf",
		start_active = "0"
		}
	local debrisEntity = SpawnEntityFromTableSynchronous( "info_particle_system", debrisTable )
	local globalEntity = Entities:FindByName( nil, "global_xp" )
	if globalEntity ~= nil then
		local debrisPosition = globalEntity:GetAbsOrigin()
		debrisEntity:SetAbsOrigin( debrisPosition )
	end
end

function CConquestGameMode:OnPendulumStartTouch( index, team, hActivatingHero )
	EmitGlobalSound("ui_menu_activate_open")

	m_pendulum_info[index].touchers[team][hActivatingHero] = true

	local bBlocked = tablehaselements( m_pendulum_info[index].touchers[DOTA_TEAM_GOODGUYS] ) and tablehaselements( m_pendulum_info[index].touchers[DOTA_TEAM_BADGUYS] )
	if bBlocked then
		--print("Button is blocked")
		EmitGlobalSound("Conquest.TrapButton.Blocked")
	elseif team == m_pendulum_info[index].owner then
		--Activate the trap
		local trapName = m_pendulum_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_pendulum_info[index].touchers[team] )
		npc:SetContextThink( "EnableTrap", function() return CConquestGameMode:EnablePendulum( index, team ) end, 0 )
	end
end

function CConquestGameMode:OnPendulumEndTouch( index, team, hActivatingHero )

	m_pendulum_info[index].touchers[team][hActivatingHero] = nil

	local ownerTeam = m_pendulum_info[index].owner
	local ownerOpponentTeam = DOTA_TEAM_BADGUYS
	if ownerTeam == DOTA_TEAM_BADGUYS then
		ownerOpponentTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_pendulum_info[index].touchers[ownerTeam] )
	local bHasEnemies = tablehaselements( m_pendulum_info[index].touchers[ownerOpponentTeam] )

	if bHasAllies and not bHasEnemies then
		local trapName = m_pendulum_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_pendulum_info[index].touchers[team] )
		npc:SetContextThink( "EnableTrap", function() return CConquestGameMode:EnablePendulum( index, team ) end, 0 )
	end
end

function CConquestGameMode:EnablePendulum( index, team )
	if m_pendulum_info[index].isPendulumReady == true then
		--print("Enabling Pendulum")
		m_pendulum_info[index].isPendulumReady = false
		EmitGlobalSound("Conquest.Pendulum.Trigger")
		EmitGlobalSound("tutorial_rockslide")
		EmitGlobalSound( "Conquest.Pendulum.Scrape" )
		local pendulumName = m_pendulum_info[index].pendulum_name
		DoEntFire( "pendulum_shake", "StartShake", "", 0, self, self )
		DoEntFire( "pendulum_debris", "Start", "", 0, self, self )
		DoEntFire( pendulumName .. "_model", "SetAnimation", "pendulum_swing", 0, self, self )

		local pendulumName = m_pendulum_info[index].pendulum_name
		--print(pendulumName)
		DoEntFire( pendulumName .. "_trigger", "Enable", "", 4, self, self )
		DoEntFire( pendulumName .. "_trigger_backup", "Enable", "", 4, self, self )
		DoEntFire( pendulumName .. "_trigger", "Disable", "", 9, self, self )
		DoEntFire( pendulumName .. "_trigger_backup", "Disable", "", 9, self, self )

		local trapName = m_pendulum_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc:SetContextThink( "DisableTrap", function() return CConquestGameMode:DisablePendulum( index, team ) end, 16.67 )
	end
	return -1
end

function CConquestGameMode:DisablePendulum( index, team )
	--print( "Disabling Pendulum" )
	local pendulumName = m_pendulum_info[index].pendulum_name
	DoEntFire( "pendulum_shake", "StopShake", "", 0, self, self )
	DoEntFire( "pendulum_debris", "Stop", "", 0, self, self )
	DoEntFire( pendulumName .. "_trigger", "Disable", "", 0, self, self )
	m_pendulum_info[index].isPendulumReady = true

	local opposingTeam = DOTA_TEAM_BADGUYS
	if team == DOTA_TEAM_BADGUYS then
		opposingTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_pendulum_info[index].touchers[team] )
	local bHasEnemies = tablehaselements( m_pendulum_info[index].touchers[opposingTeam] )

	if bHasAllies and bHasEnemies then
		--print("Button is blocked")
		EmitGlobalSound("Conquest.TrapButton.Blocked")
		return -1
	elseif bHasAllies then
		--Activate the trap
		--print("Reactivate the trap")
		--CConquestGameMode:EnablePendulum( index, team )
		local trapName = m_pendulum_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_pendulum_info[index].touchers[team] )
		npc:SetContextThink( "EnableTrap", function() return CConquestGameMode:EnablePendulum( index, team ) end, 0 )
		return 0
	end
end

---------------------------------------------------------------------------
-- Cheat convar for testing pendulum
---------------------------------------------------------------------------
function CConquestGameMode:TestPendulum( cmdName, index, team )
	CConquestGameMode:EnablePendulum( index, team )
end

