--[[
	SimpleAI
	A simple Lua AI to demonstrate implementation of a simple AI for dota 2.

	By: Perry
	Date: August, 2015
]]

--AI parameter constants
AI_THINK_INTERVAL = 1 -- The interval in seconds between two think ticks

--AI state constants
AI_STATE_IDLE = 0
AI_STATE_AGGRESSIVE = 1
AI_STATE_RETURNING = 2

--Define the SimpleAI class
if SimpleAI == nil then
	SimpleAI = class({})
end


--[[ Create an instance of the SimpleAI class for some unit 
  with some parameters. ]]
function SimpleAI:MakeInstance( unit, params )
	--Construct an instance of the SimpleAI class
	--Set the core fields for this AI
	self.unit = unit --The unit this AI is controlling
	self.state = AI_STATE_IDLE --The initial state
	self.speed = unit:GetBaseMoveSpeed() 
	self.stateThinks = { --Add thinking functions for each state
		[AI_STATE_IDLE] = 'IdleThink',
		[AI_STATE_AGGRESSIVE] = 'AggressiveThink',
		[AI_STATE_RETURNING] = 'ReturningThink'
	}

	--Set parameters values as fields for later use
	self.spawnPos = params.spawnPos
	self.aggroRange = params.aggroRange
	self.leashRange = params.leashRange

	--Start thinking
	-- Timers:CreateTimer( ai.GlobalThink, ai )
	unit:SetThink( "GlobalThink", self, 1)
	--Return the constructed instance
	return self
end

--[[ The high-level thinker this AI will do every tick, selects the correct
  state-specific think function and executes it. ]]
function SimpleAI:GlobalThink()
	--If the unit is dead, stop thinking
	if not self.unit:IsAlive() then
		return nil
	end

	--Execute the think function that belongs to the current state
	Dynamic_Wrap(SimpleAI, self.stateThinks[ self.state ])( self )

	--Reschedule this thinker to be called again after a short duration
	return AI_THINK_INTERVAL
end

--[[ Think function for the 'Idle' state. ]]
function SimpleAI:IdleThink()
	--Find any enemy units around the AI unit inside the aggroRange
	local units = FindUnitsInRadius( self.unit:GetTeam(), self.unit:GetAbsOrigin(), nil,
		self.aggroRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, false )

	--If one or more units were found, start attacking the first one
	if #units > 0 then
		self.unit:SetBaseMoveSpeed(self.speed) 
		self.unit:MoveToTargetToAttack( units[1] ) --Start attacking
		self.aggroTarget = units[1]
		self.state = AI_STATE_AGGRESSIVE --State transition
		return true
	else
		oldSp = self.unit:GetBaseMoveSpeed() 
		self.unit:SetBaseMoveSpeed(self.speed/2) 
		self.unit:MoveToPositionAggressive(self.unit:GetAbsOrigin()+RandomVector(500) )
		return true
	end

	--State behavior
	--Whistle a tune
end

--[[ Think function for the 'Aggressive' state. ]]
function SimpleAI:AggressiveThink()
	--Check if the unit has walked outside its leash range
	if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() > self.leashRange then
		self.unit:SetBaseMoveSpeed(self.speed) 
		self.unit:MoveToPosition( self.spawnPos ) --Move back to the spawnpoint
		self.state = AI_STATE_RETURNING --Transition the state to the 'Returning' state(!)
		return true --Return to make sure no other code is executed in this state
	end

	--Check if the unit's target is still alive (self.aggroTarget will have to be set when transitioning into this state)
	if not self.aggroTarget:IsAlive() then
		self.unit:SetBaseMoveSpeed(self.speed) 
		self.unit:MoveToPosition( self.spawnPos ) --Move back to the spawnpoint
		self.state = AI_STATE_RETURNING --Transition the state to the 'Returning' state(!)
		return true --Return to make sure no other code is executed in this state
	end

	--State behavior
	--Here we can just do any behaviour you want to repeat in this state
	-- print('Attacking!')
end

--[[ Think function for the 'Returning' state. ]]
function SimpleAI:ReturningThink()
	--Check if the AI unit has reached its spawn location yet
	if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() < 10 then
		--Go into the idle state
		self.state = AI_STATE_IDLE
		return true
	end
end