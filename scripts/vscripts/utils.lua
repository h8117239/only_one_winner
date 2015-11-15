-- 帮助类
function BroadcastMessage( sMessage, fDuration )
    local centerMessage = {
        message = sMessage,
        duration = fDuration
    }
    FireGameEvent( "show_center_message", centerMessage )
end

function levelup_hero( hero ,level)
    if hero:IsRealHero() then
        for i=1,level-1 do
            hero:HeroLevelUp(true)  
        end
        -- print ("Levelup hero " .. hero:GetLevel() )
        return true
    end
    return false
end


BASE_XP = 35 -- config in heros
BASE_GOLD = 45
MIN_XP = 15
MIN_GOLD = 15

function custom_levelup(creep, level, GAIN)
    -- print("GAIN"..GAIN)
    -- print("level"..level)
    local GAIN_p_lvl = 1 + GAIN * (level-1)
        -- if GAIN_p_lvl <1 then
        --     GAIN_p_lvl = 1
        -- end    
    -- if  level>creep:GetLevel()  then
        -- local add_lvl = level+1 - creep:GetLevel()
        local health = creep:GetHealth() * GAIN_p_lvl
        local armor = creep:GetPhysicalArmorValue() * GAIN_p_lvl
        local xp = BASE_XP -level/2
        local gold = BASE_GOLD -level/2
        if xp < MIN_XP then
            xp = MIN_XP
        end
        -- if creep:GetDeathXP()  then
        --     if xp < xp  then
        --         xp =  creep:GetDeathXP() 
        --     end   
        -- end 
        if gold < MIN_GOLD then
            gold = MIN_GOLD
        end   
        -- if creep:GetMinimumGoldBounty() then
        --     if gold < creep:GetMinimumGoldBounty()  then
        --         gold =  creep:GetMinimumGoldBounty() 
        --     end   
        -- end 

        if creep:IsRealHero() then
            creep:SetMaxHealth(health)
            creep:SetPhysicalArmorBaseValue(armor) 
            -- 英雄的xp和gold暂时按照配置的最小值来，除非它更小
            if creep:GetDeathXP() > xp then
                xp = creep:GetDeathXP() 
            end
            if creep:GetMinimumGoldBounty() > gold then
                gold = creep:GetMinimumGoldBounty()
            end
        else
            creep:SetBaseMaxHealth(health)
            creep:SetMaxHealth(health)
            creep:SetPhysicalArmorBaseValue(armor) 
        end
        creep:SetHealth(health)
        creep:SetBaseDamageMin(creep:GetBaseDamageMin() * GAIN_p_lvl)
        creep:SetBaseDamageMax(creep:GetBaseDamageMax() * GAIN_p_lvl)
        creep:SetDeathXP(xp) 
        creep:SetMaximumGoldBounty(gold)
        creep:SetMinimumGoldBounty(gold)
        -- print ("Levelup creep "..creep:GetUnitName() .." " ..level.." health " .. health .." "..creep:GetMaxHealth())
        return true
    -- end
    -- return false
end

function levelup_crature( crature, level )
    if crature:IsCreature() and  level>1 then
            crature:CreatureLevelUp(level) 
            -- print ("Levelup crature " .. crature:GetLevel() )
            return true
    end
    return false
end

function isbad( unit_name )
    local unit = Entities:FindByName( nil, unit_name)
    return (not unit) or unit:GetTeamNumber() == DOTA_TEAM_BADGUYS
end

function isgood( unit_name )
    local unit = Entities:FindByName( nil, unit_name)
    return  unit and unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS
end
-- isbad("npc_dota_smithy") and isbad("npc_dota_ore") and isbad("npc_dota_mill")  and  isbad("npc_dota_pit")   and isbad("npc_dota_farm") 
function cal_bad()
    local bad = 0
    if isbad("npc_dota_smithy") then
        bad = bad +1
    end
    if isbad("npc_dota_ore") then
        bad = bad +1
    end
    if isbad("npc_dota_mill") then
        bad = bad +1
    end
    if isbad("npc_dota_pit") then
        bad = bad +1
    end
    if isbad("npc_dota_farm") then
        bad = bad +1
    end

    return bad
end

function cal_good()
    local bad = 0
    if isgood("npc_dota_smithy") then
        bad = bad +1
    end
    if isgood("npc_dota_ore") then
        bad = bad +1
    end
    if isgood("npc_dota_mill") then
        bad = bad +1
    end
    if isgood("npc_dota_pit") then
        bad = bad +1
    end
    if isgood("npc_dota_farm") then
        bad = bad +1
    end

    return bad
end

function calc_number(team, basenumber)
    if basenumber==1 then
        return basenumber
    end
    local bad_building = cal_bad()
    local good_buiding = cal_good()
    if team == DOTA_TEAM_GOODGUYS then
        if good_buiding<3 then
            return basenumber
        else
            return (6 - good_buiding)*basenumber/5
        end
    elseif team == DOTA_TEAM_BADGUYS then
        if bad_building<3 then
            return basenumber
        else
            return (6 - bad_building)*basenumber/5
        end
    end
    return basenumber
end

function DoDamage( target,damage,damage_type,attacker )
        local damageTable = {
        victim = target,
        damage = damage,
        damage_type = damage_type,
        attacker = attacker,
      -- damage_flags = 0,
      -- ability = args.ability,
  }
      -- PrintTable(damageTable)
      -- print("DO DAMAGE " .. damage)
       ApplyDamage(damageTable)   
  end

function IsPvp( )
  return GetMapName()=="pvp_mode" 
end

-- 可直接通过PrintTable(table)来调用，V社提供了DeepPrintTable(args)的方法信息更全。
function PrintTable(t, indent, done)
    --print ( string.format ('PrintTable type %s', type(keys)) )
    if type(t) ~= "table" then return end

    done = done or {}
    done[t] = true
    indent = indent or 0

    local l = {}
    for k, v in pairs(t) do
        table.insert(l, k)
    end

    table.sort(l)
    for k, v in ipairs(l) do
        -- Ignore FDesc
        if v ~= 'FDesc' then
            local value = t[v]

            if type(value) == "table" and not done[value] then
                done [value] = true
                print(string.rep ("\t", indent)..tostring(v)..":")
                PrintTable (value, indent + 2, done)
                elseif type(value) == "userdata" and not done[value] then
                    done [value] = true
                    print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                    PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
                else
                    if t.FDesc and t.FDesc[v] then
                        print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
                    else
                        print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
                    end
                end
            end
        end
    end

function  intable( value, tb )

    for i,v in pairs(tb) do
        if v==value then
            return true
        end
    end
    return false
end

function SetTeamValue(  team, value )
    GameRules:GetGameModeEntity():SetTopBarTeamValue(team, value )
end

function FindClearSpace( unit, bond ,radios)
    local origin=RandomVector( RandomFloat(-bond,bond ) )
    if not HasEnemy(origin,radios,unit) and not GridNav:IsNearbyTree(origin,radios,true) then
        originn = origin + Vector(0,0,200)
        unit:SetAbsOrigin(originn)
        FindClearSpaceForUnit(hero, origin, false)
        unit:AddNewModifier(nil, nil, "modifier_phased", {duration=2})
        if unit:IsRealHero() then
            PlayerResource:SetCameraTarget( unit:GetPlayerID() , unit )
            unit:SetContextThink( "KillSetCameraTarget", function() return PlayerResource:SetCameraTarget( unit:GetPlayerID(), nil ) end, 0.2 )
            -- heroHandle:SetContextThink( "KillTPEffects", function() return ParticleManager:DestroyParticle( tpEffects, true ) end, 3 )
        end
    else
        FindClearSpace( unit, bond,radios)
    end
end

function FindClearSpacePos(bond ,radios)
    local origin=RandomVector( RandomFloat(-bond,bond ) )
    if not GridNav:IsNearbyTree(origin,radios,true) then
        originn = origin + Vector(0,0,200)  
        return originn      
    else
        return FindClearSpacePos(bond,radios)
    end
end

function HasEnemy( origin,radios,unit)
    local ents = Entities:FindAllInSphere(origin,radios)

    if ents then
        for k, ent in pairs( ents ) do
            if isEnemy(ent,unit) then
               return true
            end
        end
    end
    return false
end

function isEnemy( target ,ent )
    local targetTeam = target:GetTeamNumber()
    return targetTeam ~=ent:GetTeamNumber()
end


function Timer( ... )
    local name,fun,delay,entity = ...

    delay = delay or 0

    local ent = GameRules:GetGameModeEntity();
    local time = GameRules:GetGameTime()
    ent:SetContextThink(DoUniqueString(name),function( )

        if GameRules:GetGameTime()-time >= delay then
            ent:SetContextThink(DoUniqueString(name),function( )

                if not GameRules:IsGamePaused() then
                    return fun();
                end

                return 0.01
            end,0)
            return nil
        end

        return 0.01
    end,0)
        
end
-- AMHC:Reload( AMHC, "Timer", "string,function,number,table" )

function printEvent( event )
    for i,v in pairs(event) do
        print(tostring(i).."="..tostring(v))
    end
end

function PingMiniMapAtLocation( positon )

   local change =
     {
       pos = positon
     }
  --  -- 发送事件到所有客户端UI
   CustomGameEventManager:Send_ServerToAllClients( "ping_minimap", change )

end
