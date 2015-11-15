require("data")
require("skills")

function HeartSeeker( keys )
	print("Cast HeartSeeker")
	local  caster = keys.caster
	local target = keys.target
	local add = keys.Additon
	local damage = 200 * RemoveAndCountStars(target) *(1+add)
	DoDamage(target,damage,DAMAGE_TYPE_PHYSICAL,caster)
	-- caster:CastAbilityOnTarget(target, caster:FindAbilityByName("dotb_omni_slash"), caster:GetPlayerOwnerID() ) 
end