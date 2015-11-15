require("utils")
require("Hero")
require("libraries/notifications")
require("libraries/timers")
HeroTable  = {

}

player_number  = 0


if HeroInfo == nil then
	print ( '[HeroInfo] creating HeroInfo' )
	HeroInfo = class({})
end



 function HeroInfo:GetExDamage(  )
 	return self.externalDamage
 end

 function HeroInfo:UpdateExDanage(args)
 	externalDamage = args
 end

function GetPlayerNumber()
	-- if #HeroTable>5 then
	-- 	return 5
	-- else
		return #HeroTable
	-- end
end


-- return HeroInfo instance
function GetHeroInfoByHeroId( hero )
	print("size ......" .. table.getn(HeroInfos))
	for i,v in pairs(HeroInfos) do
		if v.heroid == hero then
			return v
		end
	end
end

DEFAULT_COUNT = 10
count = DEFAULT_COUNT

function ChangeOnePlayerToOtherTeam( attack_hero_unit )	

    if HeroList:GetHeroCount() < 4 then
    	Notifications:TopToAll({text="#PlayerNumberWarning",style={color="red"}, duration=5.0})
    	-- GameRules:SetGameWinner( attack_hero_unit:GetTeam() )
    	return
    end   		

	local num = RandomInt(0, HeroList:GetHeroCount()-1)
	local hero = get_hero_by_player(num)
	if hero:GetTeam()==attack_hero_unit:GetTeam() and num~=attack_hero_unit:GetPlayerID() then
    	if hero:GetTeam()==DOTA_TEAM_GOODGUYS then
    		PlayerResource:SetCustomTeamAssignment(num,DOTA_TEAM_BADGUYS)
    		-- 背叛
    		EmitAnnouncerSound( "announcer_ann_custom_adventure_alerts_41" )
  			Notifications:TopToAll({hero=hero:GetName(), imagestyle="portrait", duration=3.0})
  			Notifications:TopToAll({text="#Team_Change_"..DOTA_TEAM_BADGUYS,style={color="white"}, continue=true})
    		hero:SetTeam(DOTA_TEAM_BADGUYS)     		
    	elseif hero:GetTeam()==DOTA_TEAM_BADGUYS then
    		PlayerResource:SetCustomTeamAssignment(num,DOTA_TEAM_GOODGUYS)
    		-- 背叛
    		EmitAnnouncerSound( "announcer_ann_custom_adventure_alerts_41" )
  			Notifications:TopToAll({hero=hero:GetName(), imagestyle="portrait", duration=3.0})
  			Notifications:TopToAll({text="#Team_Change_"..DOTA_TEAM_GOODGUYS,style={color="white"}, continue=true})
    		hero:SetTeam(DOTA_TEAM_GOODGUYS) 
    	end
    	
    	if PlayerResource:GetPlayerCountForTeam(attack_hero_unit:GetTeam())==1 then
    		Timers:CreateTimer(3,function()
  				Notifications:TopToAll({hero=attack_hero_unit:GetName(), imagestyle="portrait", duration=3.0})
  				Notifications:TopToAll({text="#Team_Win",style={color="red"}, continue=true}) 
  				EmitGlobalSound("General.PingWarning")
  			return nil
  			end
  			)

  			Timers:CreateTimer(6, function()
      			if PlayerResource:GetPlayerCountForTeam(attack_hero_unit:GetTeam())==1 and count >= 0 then
    				Notifications:TopToAll({text=tostring(count),style={
    					color="red", ["font-size"]="110px",
    				 -- border="10px solid blue"
    					}, duration=1.0})  
    				EmitGlobalSound("General.PingWarning")
    				count = count-1
    				-- print(tostring(count))
      				return 1.0
      			elseif count<0 then
      				GameRules:SetGameWinner( attack_hero_unit:GetTeamNumber() )
      				return nil
      			else
      				count = DEFAULT_COUNT
      				return nil
      			end
      		end
      		)
    	end
    else
    	ChangeOnePlayerToOtherTeam(attack_hero_unit)
    end


end




function SetNextRespawnPos(killedHero)

end

function InitHeroInfo(hero_info) 
	local hero = hero_info:GetUnitName() 
	local player_id = hero_info:GetPlayerID() 
	-- local player = hero_info:GetPlayerName(player_id) 
	-- print(type(hero))
	-- print("size ......" .. table.getn(HeroInfos))
	local exsit = false;
	for i,v in pairs(HeroTable) do
		if v.player_id == player_id then
			v:Load(hero_info)
			exsit = true
			break
		end
	end
	if exsit	then
		print("Player HeroInfo already inited")
	else
		print("inite player " .. hero)
		local hero_obj = Hero()
		hero_obj:Load(hero_info)
		-- 飞
		local item = CreateItem("item_fly", nil, nil) 
		local item1 = CreateItem("item_bottle", nil, nil) 
		-- local item = CreateItem("item_force_staff", nil, nil) 
  		hero_info:AddItem(item)
  		hero_info:AddItem(item1)
		-- local health = hero_info:GetHealth()*2
		-- print("inite player " .. hero_info:GetHealth())
		-- print("inite player " .. hero_info:GetMaxHealth())
		-- print("inite player " .. hero_info:GetBaseMaxHealth())
		-- hero_info:SetMaxHealth(health)
		-- hero_info:SetBaseMaxHealth(health)
  --       hero_info:SetHealth(health)
		PlayerResource:SetGold(player_id,2000,false)
			-- for i=1,6 do
			-- 	PlayerResource:HeroLevelUp(player_id)
			-- end



		table.insert(HeroTable,hero_obj)

	end
	local time = hero_info:GetLevel() 
	if time < 8 then
		time = 8 
	end
	hero_info:SetTimeUntilRespawn(time)
	if IsPvp then 
		BASE_XP = 15 + 4*GetPlayerNumber()
	else
		BASE_XP = 25 + 6*GetPlayerNumber()
	end

	-- print("GAIN" .. GAIN)
	print("BASE_XP" .. BASE_XP) 
end

function get_hero_by_player( player_id )
	print ("get_hero_by_player" .. player_id )
	for i,v in pairs(HeroTable) do
		if v.player_id == player_id then
			print ("get_hero_by_player return true")
			return v.unit
		end
	end
	return nil
end

-- 根据对象查询exdmaage
function GetExDamageByHero( hero_unit )
	local heroinfo =  GetHeroInfoByHeroId(hero_unit:GetUnitName() ) 
	if heroinfo then
		return heroinfo:GetExDamage()
	end

end