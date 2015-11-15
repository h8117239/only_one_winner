
-- Trigger to allow winning team to teleport to the forward position

function OnStartTouch(trigger)
	local team = trigger.activator:GetTeam()
	local hero = trigger.activator:GetName()
	local heroIndex = trigger.activator:GetEntityIndex()
	--print("Waypoint " .. m_waypoint_name .. " Entered by Team " .. team)
	-- local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	GameRules:GetGameModeEntity().OOW:OnWaypointStartTouch( hero, team, heroIndex )
end
