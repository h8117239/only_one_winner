require("abilities")
require("libraries/notifications")
require("amhc_library/amhc")

blesses = {
	"blessing_of_heaven",
	"modifier_blessing_of_hell",
	"modifier_think_momian",
	"modifier_think_invis"

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
	if event.itemname == "item_blessing_of_heaven" then
		--print("Potion picked up")
		--StartSoundEvent( "DOTA_Item.HealingSalve.Activate", owner )
		local min_idx = RandomInt(1,#blesses) 
		local modifier_name = blesses[min_idx]
		-- modifier_name = blesses[2]
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
  			Notifications:TopToAll({hero=owner:GetName(), imagestyle="portrait", duration=4.0})
  			Notifications:TopToAll({text="#Add_blessing_of_heaven",style={color="white"}, continue=true})
    	else
        	owner:SetModifierStackCount(modifier_name, owner, count+1)
        	if count==5 or count>8 then 
  				Notifications:TopToAll({hero=owner:GetName(), imagestyle="portrait", duration=4.0})
  				Notifications:TopToAll({text="#Add_blessing_of_heaven_too_much",style={color="red"}, continue=true})
  			else
   				Notifications:TopToAll({hero=owner:GetName(), imagestyle="portrait", duration=4.0})
  				Notifications:TopToAll({text="#Add_blessing_of_heaven",style={color="white"}, continue=true}) 				
  			end
    	end

    	else

    		MakeMod(owner,owner,modifier_name,nil)
  			Notifications:TopToAll({hero=owner:GetName(), imagestyle="portrait", duration=4.0})
  			Notifications:TopToAll({text="#Add_"..modifier_name,style={color="white"}, continue=true})

    	end
		--owner:GiveMana(m * 0.5)
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
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