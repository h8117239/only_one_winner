-- 组合技能

if SkillGroup == nil then
	SkillGroup = class({})
end


function SkillGroup:Load( skill_table )
	self.name = skill_table.name
	self.abilities = skill_table.abilities

	-- for i=0,#skill_table.abilities do
	self.max = #skill_table.abilities
	self.cur = 1
end


-- function SkillGroup:First( ... )
-- 	-- body
-- end

function SkillGroup:Next( level )
	local skill = nil
	local max = nil
	if level < self.max then 
		max = level
	else
		max = self.max
	end
	if self.cur<  max then
		skill = self.abilities[self.cur+1]
		self.cur = self.cur+1
	else
		skill = self.abilities[1]
		self.cur = 1
	end
	return skill
end




