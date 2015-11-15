

cm_slow = "modifier_crystal_maiden_freezing_field_slow"
invi = "modifier_riki_permanent_invisibility"

MOD_MASTER = CreateItem("modifier_master", nil, nil) 

function MakeMod(source,target, modifier_name, modifierArgs)
	 return MOD_MASTER:ApplyDataDrivenModifier(source,target,modifier_name,modifierArgs)
end




MODIFIER_INVISIBLE_AURE = function ( target )
	return MakeMod(target,target,"aure_modifer",{})
end


MODIFIER_SLOW = function ( target )
	return MakeMod(target,target,"modifier_slow",{})
end

dur =     {
    duration  = 1.1
  }

function Invisibility( args )
	local target = args.Target
    local caster = args.caster
    local ability = args.ability
  -- local basedamage = args.ability:GetAbilityDamage() 
  -- local cooldown = ability:GetCooldown(ability:GetLevel() )
  	local targets = args.target_entities
  	local targetsNum = table.getn(targets)
  	local hasgood = false 
  	local hasbad = false
	for k,v in pairs(targets) do
        -- print(k,v)
        -- if v:IsRealHero() then
        if v ~= caster then
          if v:GetTeamNumber()==DOTA_TEAM_GOODGUYS and v:IsRealHero() then
            hasgood = true
            elseif v:GetTeamNumber()==DOTA_TEAM_BADGUYS then
              hasbad = true
            end
         end
    end

    if hasbad and hasgood then
    	for k,v in pairs(targets) do
			v:RemoveModifierByName(invi) 
    	end
    elseif targets~=nil then
    	for k,v in pairs(targets) do
    		if v ~= caster and v:GetTeamNumber()==caster:GetTeamNumber()  then
    			v:AddNewModifier(caster, ability, invi, dur) 
    		end
    	end   	
    end
end

