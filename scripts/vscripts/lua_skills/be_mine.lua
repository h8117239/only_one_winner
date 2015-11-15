require("utils")
--[[Author: Pizzalol
    Date: 06.04.2015.
    Takes ownership of the target unit]]
function HolyPersuasion( keys )
    local caster = keys.caster
    local target = keys.target
    local caster_team = caster:GetTeamNumber()
    local player = caster:GetPlayerOwnerID()
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1

    -- Initialize the tracking data
    ability.holy_persuasion_unit_count = ability.holy_persuasion_unit_count or 0
    ability.holy_persuasion_table = ability.holy_persuasion_table or {}

    -- Ability variables
    local max_units = ability:GetLevelSpecialValueFor("max_units", ability_level)
    local health_bonus = ability:GetLevelSpecialValueFor("health_bonus", ability_level)

    if GridNav:IsNearbyTree(target:GetAbsOrigin(),10,true) then
        GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(),10,true)
        return
    end

    if caster_team == target:GetTeam() then
        target:Heal(100, ability)
        return
    end

    -- Change the ownership of the unit and restore its mana to full
    -- add modifier
    if target:GetTeam() ~= DOTA_TEAM_GOODGUYS and target:GetTeam() ~= DOTA_TEAM_BADGUYS and target:GetLevel()<=caster:GetLevel() and target:GetHealth() <=target:GetMaxHealth()/2 then
    	
    	target:SetTeam(caster_team)
    	target:SetOwner(caster)
    	target:SetControllableByPlayer(player, true)
    	target:SetMaxHealth(target:GetMaxHealth() + health_bonus)
    	target:Heal(target:GetMaxHealth()-target:GetHealth(), ability)
    	target:GiveMana(target:GetMaxMana())
    	caster.pet = target.pet   	
        target.pet.team = caster_team
    	-- Track the unit
    	ability.holy_persuasion_unit_count = ability.holy_persuasion_unit_count + 1
    	table.insert(ability.holy_persuasion_table, target)
    	ability:ApplyDataDrivenModifier(caster, target, "modifier_holy_persuasion_datadriven", nil) 
        ability:ApplyDataDrivenModifier(caster, target, "modifier_reincarnation", nil) 
    end

    -- If the maximum amount of units is reached then kill the oldest unit
    if ability.holy_persuasion_unit_count > max_units then
        ability.holy_persuasion_table[1]:ForceKill(true) 
    end

end

--[[Author: Pizzalol
    Date: 06.04.2015.
    Removes the target from the table]]
function HolyPersuasionRemove( keys )
    local target = keys.target
    local ability = keys.ability

    -- Find the unit and remove it from the table
    for i = 1, #ability.holy_persuasion_table do
        if ability.holy_persuasion_table[i] == target then
            table.remove(ability.holy_persuasion_table, i)
            ability.holy_persuasion_unit_count = ability.holy_persuasion_unit_count - 1
            break
        end
    end
end

