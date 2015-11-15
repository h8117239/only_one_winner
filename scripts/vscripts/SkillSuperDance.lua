require("data")
require("skills")

function SuperDance( keys )
	local  caster = keys.caster
	local target = keys.target
	local avoid = RemoveAndCountStars(target)
	print("SuperDance" .. string.format("avoid_%d",avoid*18))
	if avoid>0 then
	MOD_MASTER:ApplyDataDrivenModifier(caster, caster, string.format("avoid_%d",avoid*18), {duration = 20}) 
	end	
	MOD_MASTER:ApplyDataDrivenModifier(caster, caster, "critical_90", {duration = 20}) 	
end