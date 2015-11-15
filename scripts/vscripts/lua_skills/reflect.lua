function reflect( keys )
    -- Variables
    local caster = keys.caster
    local attacker = keys.attacker
    local damageTaken = keys.DamageTaken
    
    -- Check if it's not already been hit
    if  not attacker:IsMagicImmune() then
        attacker:SetHealth( attacker:GetHealth() - damageTaken )
        keys.ability:ApplyDataDrivenModifier( caster, attacker, "modifier_spiked_carapaced_stun_datadriven", { } )
        caster:SetHealth( caster:GetHealth() + damageTaken )
        -- caster.carapaced_units[ attacker:entindex() ] = attacker

    end
end

function silence_disarm( keys )
    local caster = keys.caster
    MakeMod(caster,caster,"modifier_silence",{duration=4})   
    MakeMod(caster,caster,"modifier_disarm",{duration=4}) 
end