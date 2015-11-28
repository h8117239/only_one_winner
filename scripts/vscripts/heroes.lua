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
		-- for i,v in pairs(HeroTable) do
		-- 	print (tostring(i).."   ".. tostring(#HeroTable))
		-- 	if v then
		-- 		print (v.unit:GetName()) 
		-- 	end
		-- -- if v:GetPlayerID() == hero then
		-- -- 	return v
		-- -- end
		-- end
		return #HeroTable+1
	-- end
end


-- return HeroInfo instance
function GetHeroInfoByHeroId( hero )
	print("size ......" .. table.getn(HeroTable))
	for i,v in pairs(HeroTable) do
		if v:GetPlayerID() == hero then
			return v
		end
	end
end

DEFAULT_COUNT = 75
count = DEFAULT_COUNT

function ChangeOnePlayerToOtherTeam( attack_hero_unit )	

    if GetPlayerNumber() < 4 then	
    	Notifications:TopToAll({text="#PlayerNumberWarning",style={color="white"}, duration=5.0})
    	Notifications:TopToAll({text="#PlayerNumberWarningEnd",style={color="red"}, duration=5.0})
    	return
    end   	

    if GetConnectedPlayerForTeam(attack_hero_unit:GetTeam())==1 then
    	print("only 1 player in team".. attack_hero_unit:GetTeam())
    	return
    end

    local random_players = {} 
    for n = 0, DOTA_MAX_TEAM_PLAYERS do
    	local i = RandomInt(0, DOTA_MAX_TEAM_PLAYERS)
    	if intable(i,random_players) then
    		table.insert(random_players,n,i)
    	else
    		for m = 0, DOTA_MAX_TEAM_PLAYERS do
    			if not random_players[m] then
    				table.insert(random_players,m,i)
    				break
    			end
    		end
    	end
    end


    for k = 0, DOTA_MAX_TEAM_PLAYERS do
    	local num = random_players[k]
    	print("index .. "..k.." num " ..  num)
		local hero = get_hero_by_player(num)
		if not hero then
			print("no  hero with player id ".. num)
		else 

	if hero:GetTeam()==attack_hero_unit:GetTeam() and num~=attack_hero_unit:GetPlayerOwnerID() and PlayerResource:GetConnectionState(num) ~= DOTA_CONNECTION_STATE_DISCONNECTED then
    	if hero:GetTeam()==DOTA_TEAM_GOODGUYS then
    		PlayerResource:SetCustomTeamAssignment(num,DOTA_TEAM_BADGUYS)
    		-- 背叛
    		EmitAnnouncerSound( "announcer_ann_custom_adventure_alerts_41" )
    		Notifications:TopToAll({hero=hero:GetName(), imagestyle="portrait", duration=3.0})
			Notifications:TopToAll({image="file://{images}/custom_game/arrow2.png", continue=true})
			Notifications:TopToAll({image="file://{images}/custom_game/team_icons/team_icon_monkey_01.png", continue=true})	

    		Notifications:TopToAll({text="#"..hero:GetName(),style={color="DodgerBlue", ["font-size"]="30px"},duration=3.0})  			
  			Notifications:TopToAll({text="#Team_Change",style={color="white"}, continue=true})
  			Notifications:TopToAll({text="#DOTA_BadGuys",style={color="gold", ["font-size"]="30px"}, continue=true})
  			print("change DOTA_TEAM_BADGUYS of player "..num)
    		hero:SetTeam(DOTA_TEAM_BADGUYS)  
    		if hero:GetChildren() then
    			for _,child in pairs( hero:GetChildren() ) do
    				print (child:GetName() )
					child:SetTeam(DOTA_TEAM_BADGUYS) 
					child:SetOwner(hero)
    				-- child:SetControllableByPlayer(num, true)
				end
    		end  	
    		break	
    	elseif hero:GetTeam()==DOTA_TEAM_BADGUYS then
    		PlayerResource:SetCustomTeamAssignment(num,DOTA_TEAM_GOODGUYS)
    		-- 背叛
    		EmitAnnouncerSound( "announcer_ann_custom_adventure_alerts_41" )
    		
    		Notifications:TopToAll({image="file://{images}/custom_game/team_icons/team_icon_tiger_01.png", duration=3.0})
			Notifications:TopToAll({image="file://{images}/custom_game/arrow3.png", continue=true})
			Notifications:TopToAll({hero=hero:GetName(), imagestyle="portrait", continue=true})	

    		Notifications:TopToAll({text="#"..hero:GetName(),style={color="DodgerBlue", ["font-size"]="30px"},duration=3.0}) 
  			Notifications:TopToAll({text="#Team_Change",style={color="white"}, continue=true})
  			Notifications:TopToAll({text="#DOTA_GoodGuys",style={color="gold", ["font-size"]="30px"}, continue=true})
  			print("change DOTA_TEAM_GOODGUYS of player "..num)
    		hero:SetTeam(DOTA_TEAM_GOODGUYS) 
    		if hero:GetChildren() then
    			for _,child in pairs( hero:GetChildren() ) do
    				print (child:GetName() )
					child:SetTeam(DOTA_TEAM_GOODGUYS) 
					child:SetOwner(hero)
    				-- child:SetControllableByPlayer(num, true)
				end
    		end
    		break
    	end
    end
    	end

    end




        	if GetConnectedPlayerForTeam(attack_hero_unit:GetTeam())==1 then
      			if attack_hero_unit:GetTeamNumber() ==DOTA_TEAM_GOODGUYS then
      				count = DEFAULT_COUNT - 6 * GetConnectedPlayerForTeam(DOTA_TEAM_BADGUYS)
      			else	
      				count = DEFAULT_COUNT - 6 * GetConnectedPlayerForTeam(DOTA_TEAM_GOODGUYS)				
      			end          		
    			Timers:CreateTimer(3,function()
  				Notifications:TopToAll({hero=attack_hero_unit:GetName(), imagestyle="portrait", duration=3.0})
  				Notifications:TopToAll({text="#"..attack_hero_unit:GetName(),style={color="gold"} ,duration=3.0})
  				Notifications:TopToAll({text="#Team_Win",style={color="white"}, continue=true}) 
  				Notifications:TopToAll({text=tostring(count),style={color="red"}, continue=true})
  				Notifications:TopToAll({text="#Team_Win_End",style={color="white"}, continue=true})
  				Notifications:TopToAll({text="#Team_Win_End_End",style={color="white"},duration=3.0})
  				EmitGlobalSound("General.PingWarning")
  				return nil
  				end
  				)
  			
  				Timers:CreateTimer(6, function()
      			if GetConnectedPlayerForTeam(attack_hero_unit:GetTeam())==1 and count >= 0 then
      				local team = 0 
      				if attack_hero_unit:GetTeamNumber() ==DOTA_TEAM_GOODGUYS then
      					team = DOTA_TEAM_BADGUYS
      				else	
      					team = DOTA_TEAM_GOODGUYS			
      				end   
    				Notifications:TopToAll({text=tostring(count),style={
    					color="red", ["font-size"]="110px",
    				 -- border="10px solid blue"
    					}, duration=1.0})  
    				if count ==10 then
    					EmitAnnouncerSound("announcer_ann_custom_timer_sec_10")
    				elseif count<10 and count > 0 then
    					EmitAnnouncerSound("announcer_ann_custom_countdown_0".. tostring(count))
    				else
    					EmitGlobalSound("General.PingWarning")
    				end
    				count = count-1
    				AddRevealInvisForTeam(team,3)
      				return 1.0
      			elseif count<0 then
      				EmitAnnouncerSoundForTeam("announcer_ann_custom_end_10",attack_hero_unit:GetTeamNumber() )
      				EmitAnnouncerSoundForTeam("announcer_ann_custom_end_01",attack_hero_unit:GetTeamNumber() )
      				if attack_hero_unit:GetTeamNumber() ==DOTA_TEAM_GOODGUYS then
      					EmitAnnouncerSoundForTeam("announcer_ann_custom_end_04",DOTA_TEAM_BADGUYS )
      				else
          				EmitAnnouncerSoundForTeam("announcer_ann_custom_end_04",DOTA_TEAM_GOODGUYS )  					
      				end     				
      				GameRules:SetGameWinner( attack_hero_unit:GetTeamNumber() )
      				return nil
      			else
      				count = DEFAULT_COUNT
      				return nil
      			end
      			end
      			)
    		end
end

mod_real_invi = CreateItem("dota_ability_reveal_invis_large", nil, nil) 
function AddRevealInvisForTeam( team_id,delay )
    	for id = 0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:GetConnectionState(id) ~= DOTA_CONNECTION_STATE_DISCONNECTED and get_hero_by_player(id)  then
				local team = PlayerResource:GetTeam(id)
				local hero = get_hero_by_player(id)
				if team == team_id and not hero:HasModifier("modifier_dota_ability_reveal_invis_large")  then
					mod_real_invi:ApplyDataDrivenModifier(hero, hero, "modifier_dota_ability_reveal_invis_large", {duration=delay}) 
				end
			end	
		end	 
end

function GetConnectedPlayerForTeam( team_id )
	    -- local nConnectedPlayersOfTeam = {}
    	-- table.insert(nConnectedPlayersOfTeam,DOTA_TEAM_GOODGUYS,0)
    	-- table.insert(nConnectedPlayersOfTeam,DOTA_TEAM_BADGUYS,0)
    	local good_count = 0
    	local bad_cound = 0
    	for id = 0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:GetConnectionState(id) ~= DOTA_CONNECTION_STATE_DISCONNECTED and get_hero_by_player(id) then
				local team = PlayerResource:GetTeam(id)
				-- print("team " .. team .." players " .. nConnectedPlayersOfTeam[team]+1)
				-- table.insert(nConnectedPlayersOfTeam,team,nConnectedPlayersOfTeam[team]+1)
				if team == DOTA_TEAM_GOODGUYS then
					good_count = good_count + 1
				elseif team == DOTA_TEAM_BADGUYS then
					bad_cound = bad_cound + 1
				end
			end	
		end
		-- print("team good" .. good_count)
		-- print("team bad" .. bad_cound)
		if team_id==DOTA_TEAM_GOODGUYS then 
			return good_count
		elseif team_id == DOTA_TEAM_BADGUYS then
			return bad_cound
		end
		return 0 

end





function InitHeroInfo(hero_info) 
	local hero = hero_info:GetUnitName() 
	local player_id = hero_info:GetPlayerID() 
	-- local player = hero_info:GetPlayerName(player_id) 
	-- print(type(hero))
	-- print("size ......" .. table.getn(HeroInfos))
	local exsit = false;
	print ("index hero table")
	if HeroTable[player_id] then
		HeroTable[player_id]:Load(hero_info)
		exsit = true
	end
	for i,v in pairs(HeroTable) do
		if v then
			print ("index" .. i .. " name ".. v.name)
		end
		-- if v:GetPlayerID() == player_id then
		-- 	print (" hero id"..v:GetPlayerID()  )
		-- 	v:Load(hero_info)
		-- 	exsit = true
		-- 	break
		-- end
	end
	-- FindClearSpace(hero_info,2000,400)
	if exsit	then
		print("Player HeroInfo already inited")
		-- if hero_info.heroinfo.had_died then
			-- FindClearSpace(hero_info,2000,400)
		-- end
		if not hero_info:HasModifier("modifier_invulnerable") then
			hero_info:AddNewModifier(hero_info, nil, "modifier_invulnerable", {Duration = 3})
			hero_info:AddNewModifier(hero_info, nil, "modifier_invisible", {Duration = 3})
			hero_info:AddNewModifier(hero_info, nil, "modifier_disarmed", {Duration = 3})
			hero_info:AddNewModifier(hero_info, nil, "modifier_silence", {Duration = 3})
		end

	else
		print("inite player " .. hero)
		FindClearSpace(hero_info,2000,100)  
		local hero_obj = Hero()
		hero_obj:Load(hero_info)
		-- 飞
		local item = CreateItem("item_fly", nil, nil) 
		local item1 = CreateItem("item_bottle", nil, nil) 
		-- local item = CreateItem("item_force_staff", nil, nil) 
  		hero_info:AddItem(item)
  		hero_info:AddItem(item1)
		PlayerResource:SetGold(player_id,2000,false)
		-- HeroTable[player_id+1 ] = hero_obj
		table.insert(HeroTable,player_id,hero_obj)
		-- DeepPrintTable(HeroTable)
		
		if not hero_info:HasModifier("modifier_invulnerable") then
			hero_info:AddNewModifier(hero_info, nil, "modifier_invulnerable", {Duration = 10})
			hero_info:AddNewModifier(hero_info, nil, "modifier_invisible", {Duration = 10})
			hero_info:AddNewModifier(hero_info, nil, "modifier_disarmed", {Duration = 10})
			hero_info:AddNewModifier(hero_info, nil, "modifier_silence", {Duration = 10})
		end
		-- for i=0,6 do 
		-- 	hero_info:HeroLevelUp(false)
		-- end
	end
	local time = hero_info:GetLevel() 
	if time < 8 then
		time = 8 
	end
	hero_info:SetTimeUntilRespawn(time)


	-- print("GAIN" .. GAIN)
end

function get_hero_by_player( player_id )
	if HeroTable[player_id] then
		return HeroTable[player_id].unit
	end
	-- print ("get_hero_by_player" .. player_id )
	-- for i,v in pairs(HeroTable) do
	-- 	if v.player_id == player_id then
	-- 		print ("get_hero_by_player return true")
	-- 		return v.unit
	-- 	end
	-- end
	return nil
end

-- 根据对象查询exdmaage
function GetExDamageByHero( hero_unit )
	local heroinfo =  GetHeroInfoByHeroId(hero_unit:GetUnitName() ) 
	if heroinfo then
		return heroinfo:GetExDamage()
	end

end