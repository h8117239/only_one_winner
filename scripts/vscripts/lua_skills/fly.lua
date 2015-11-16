require("abilities")

function item_fly_spell_start(keys)


	local target = keys.target
    local caster = keys.caster



	ProjectileManager:ProjectileDodge(target)  --Disjoints disjointable incoming projectiles.
    

    target:EmitSound("DOTA_Item.BlinkDagger.Activate")
    
    -- local origin_point = keys.caster:GetAbsOrigin()
    -- local target_point = keys.target_points[1]
    -- local difference_vector = target_point - origin_point
    
    -- if difference_vector:Length2D() > keys.MaxBlinkRange then  --Clamp the target point to the BlinkRangeClamp range in the same direction.
    --     target_point = origin_point + (target_point - origin_point):Normalized() * keys.BlinkRangeClamp
    -- end

    if target==caster then
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, target)
        FindClearSpace(target,2000,100)  
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, target)
    else
        local i  = RandomInt(1, 100) 
        if i>0 and i<50 then
            -- 反射
            MakeMod(caster,target,"modifier_spiked_carapace_buff_datadriven",{duration=100})
            return
        end

        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, target)
        FindClearSpace(target,2000,100)  
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, target)
    end

    -- 冲向队友


end