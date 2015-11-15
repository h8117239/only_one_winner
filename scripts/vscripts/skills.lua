require("data")
require("SkillGroup")
require("utils")


skill_groups = {}

for i=1,#skill_table do
	print(skill_table[i])
	local sg = SkillGroup()
	sg:Load(skill_table[i])
	table.insert(skill_groups,sg)
end


function GetSkillGroup( group )
	for i=1,#skill_groups do
		if skill_groups[i].name==group then
			return skill_groups[i]
		end
	end
end

function NextSkill( keys )
	local  caster= EntIndexToHScript( keys.caster_entindex )
	local ab = keys.ability
	-- local target = keys.Target
	local sg = keys.SkillGroup  
	-- print(sg)
	-- local ab_count=ab:GetAbilityIndex()
	local level = ab:GetLevel()
	-- ab:SetHidden(true)
	caster:RemoveAbility(ab:GetName())
	local nextsk = GetSkillGroup(sg):Next(level)
	caster:AddAbility(nextsk)
	local extra=caster:FindAbilityByName(nextsk)
	print("set level" .. level)
	extra:SetLevel(level) 
	local cd =extra:GetCooldown(level) 
	extra:StartCooldown(cd) 
end





function  MiranaStunArrow( args )
	local target = args.Target
	local caster = args.caster
	local ability = args.ability
	local basedamage = args.ability:GetAbilityDamage() 
	local cooldown = ability:GetCooldown(ability:GetLevel() )
	local targets = args.target
	local targetsNum = 1
	local stun = 
	{
	duration = 0.1
}
local totalDamage = CalExMagicDamage(basedamage,cooldown,caster:GetIntellect(),targetsNum) + basedamage
print("damage =============== " .. totalDamage)
PrintTable(args)

DoDamage(targets,totalDamage,DAMAGE_TYPE_MAGICAL,caster)
targets:AddNewModifier(caster, ability, STUNED_MODIFIER, stun) 

end



-- MOD_MASTER = CreateItem("modifier_master", nil, nil) 


-- function WildStrike( keys )
-- 	local caster = keys.caster
-- 	-- caster:AddNewModifier(caster,keys.ability, "phys_dmg", nil) 
-- 	MOD_MASTER:ApplyDataDrivenModifier(caster, caster, "phys_dmg",nil)
-- end

-- function FireStrike( keys )
-- 	local caster = keys.caster
-- 	-- caster:AddNewModifier(caster,keys.ability, "phys_dmg", nil) 
-- 	MOD_MASTER:ApplyDataDrivenModifier(caster, caster, "fire_dmg",nil)
-- end

function FireDamage( keys )
	local  caster = keys.caster
	local target = keys.target
	DoDamage(target,400,DAMAGE_TYPE_MAGICAL,caster)
end



function AoeStrike( keys )
	local caster = keys.caster
	local targets = keys.target_entities
	print("AoeStrike targets " .. #targets)
	-- DoDamage(target,300,DAMAGE_TYPE_MAGICAL,caster)
	for i,v in pairs(targets) do
		if v then
			DoDamage(v,300,DAMAGE_TYPE_MAGICAL,caster)
		end
	end
end


-- function HeartSeeker( keys )
-- 	print("Cast HeartSeeker")
-- 	local  caster = keys.caster
-- 	local target = keys.target
-- 	local damage = 200 * RemoveAndCountStars(target)
-- 	DoDamage(target,damage,DAMAGE_TYPE_PHYSICAL,caster)
-- 	caster:CastAbilityOnTarget(target, caster:FindAbilityByName("dotb_omni_slash"), caster:GetPlayerOwnerID() ) 
-- end

function RemoveAndCountStars( target )
	local stars = target:HasModifier("star_modifier")
	local count = 0 
	while stars  do
		target:RemoveModifierByName("star_modifier")
		count=count+1
		stars = target:HasModifier("star_modifier") 
	end
	if count > 5 then
		count = 5
	end
	return count
end

last_reduce = 0

function SuperSpeed( keys )
	print("Cast SuperSpeed")
	local  caster = keys.caster
	local target = keys.target
	caster:SetModelScale(3.0) 

	local ability = caster:FindAbilityByName("SuperSpeed") 
	-- ability:ApplyDataDrivenModifier(caster,caster, "speed_mod",nil) 
	-- caster:AddNewModifier(caster, ability,"speed_mod",nil)

	local base = caster:GetBaseAttackTime()
	print("Cast SuperSpeed set SetBaseAttackTime base " .. base)
	if base<0.1 then
		return
	end 
	local reduce  =0.17 * RemoveAndCountStars(target)
	caster:SetModelScale(reduce+1) 
	local new = base - reduce
	if new <=0.1 then
		new = 0.1
	end
	last_reduce = base - new
	print("Cast SuperSpeed set SetBaseAttackTime new " .. new)
	caster:SetBaseAttackTime(new) 
end


function SuperSpeedEnd( keys )
	local  caster = keys.caster
	caster:SetModelScale(1)
	if last_reduce==0 then 
		return
	end
	local base = caster:GetBaseAttackTime()
	caster:SetBaseAttackTime(base+last_reduce) 
end




-- 通用技能 添加星数
function AddStar( keys )
	local caster = keys.caster
	local target = keys.target
	local stars = keys.Stars or 1
	for i=1,stars do
		MOD_MASTER:ApplyDataDrivenModifier(caster, target, "star_modifier",nil)
	end
end