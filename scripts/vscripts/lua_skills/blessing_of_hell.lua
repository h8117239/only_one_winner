require("abilities")

function blessing_of_hell( event )
    local caster = event.caster
    -- local attacker = event.attacker
    local ability = event.ability
    -- local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
    local casterHP = caster:GetHealth()
    -- local casterMana = caster:GetMana()
    -- local abilityManaCost = ability:GetManaCost( ability:GetLevel() - 1 )

    -- Change it to your game needs
    local respawnTimeFormula = caster:GetLevel() * 4
    print(caster:GetName() .." hp " .. casterHP)   
    if casterHP <=1  then
        caster:SetHealth(1)
        print("hp less than 1")
        MakeMod(caster,caster,"modifier_shallow_grave_datadriven",{duration=6})
        caster:RemoveModifierByName("modifier_blessing_of_hell")
    end 


end

    
