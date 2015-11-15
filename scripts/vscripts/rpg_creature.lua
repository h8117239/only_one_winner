require("pet")
function Spawn( entityKeyValues )

    -- local nGoldReward = 0
    -- if RandomFloat( 0, 1 ) > 0.75 then
    --     nGoldReward = thisEntity:GetGoldBounty()
    -- end
    -- thisEntity:SetMinimumGoldBounty( nGoldReward )
    -- thisEntity:SetMaximumGoldBounty( nGoldReward )

    local HPg = RandomInt(50, 100)
    local atg = RandomFloat(-0.005, -0.02)
    local dg = RandomInt(5, 15)
    local hprg = RandomFloat(0.5, 1.5)
    local ag = RandomFloat(0.2, 0.4)
    local mr = RandomFloat(0.2, 0.6)
	local team=thisEntity:GetTeam() 
	-- thisEntity:SetTeam(team)
	-- FindClearSpace(thisEntity,6000,200)
	local pet = Pet()
	pet:Load(thisEntity,HPg,atg,dg,hprg,ag,mr,team,nil) 
	thisEntity.pet = pet
	local think = RandomInt(1, 5) 
	if think==1 then
		thisEntity:SetThink(OnThink, "OnThink", 0.1 )	
	end

end

lastGoalEntity= nil



function OnThink()
	-- print("OnThink ")
	if not thisEntity:IsAlive() then
		return nil
	end

	if thisEntity.pet.team ~= thisEntity:GetTeam() then
		thisEntity.pet.team = thisEntity:GetTeam()
		return nil
	end

	-- if findTarget() then
	-- 	return 1
	if not thisEntity:IsIdle() then
		return 5
	end

	local tar = thisEntity:GetAbsOrigin() +RandomVector(800)
	if GridNav:CanFindPath(thisEntity:GetAbsOrigin(),tar) then
		thisEntity:MoveToPositionAggressive(tar)
	end
	return 5

end

function findTarget( )
	-- print("findTarget " ..thisEntity:GetUnitName() )
    local tNearbyCreatures = Entities:FindAllInSphere(thisEntity:GetOrigin(), 700 )
    if tNearbyCreatures then
    	for k, hCreature in pairs( tNearbyCreatures ) do
    		if isEnemy(hCreature,thisEntity)  then
    	       thisEntity:MoveToTargetToAttack( hCreature )
    	    end
    	end
    	return true
    else
    	return false
    end
end

function isEnemy( target ,ent )
	local targetTeam = target:GetTeamNumber()
	return targetTeam ~=ent:GetTeamNumber() 
end