--[[
   
]]
Attribution={}


-- 全局变量或常量

MOD_MASTER = CreateItem("modifier_master", nil, nil) 

skill_table={
	{name="SkillGroup1",abilities={"WildStrike","WildStrike","WildStrike","WildStrike","FireStrike","FireStrike","AoeStrike"}}
}
-- 全局难度等级 随时间而增大
BADBOY_LVL = 1
Current_Hard_Level = 2

s_numbers = 1
m_numbers = 2
large_number = 4
huge_number = 6
s_count =300
ss_interval = 60
s_interval = 60
m_interval = 80
l_interval = 160
h_interval = 240

continue_count  = 0

hard_level = {
	0, --hard1
	0, --hard2
	0, --hard3
	0, --hard4
	0, --hard5
	0, --hard6
	0, --hard7

}



-- 怪物生成流，class="怪物类"，waiting=当前大波开始到下一个大波开始的间隔时间,wavespan=初始时间到下一个大波开始的时间(不包含前置休息时间，一般可以不用),count=波数,interval=小波产怪间隔,nums=每小波怪物数量,waypoint="怪物的目的path_corner"}
-- interval 时间必须大于2秒以上
wave_flow={
			{class="slark",waiting=3,count=s_count,interval=4,nums=20},
			{class="meepo",waiting=3,count=s_count,interval=4,nums=20}, --米波
			-- {class="creep_vulture",waiting=20,count=s_count,interval=l_interval,nums=m_numbers},
			-- {class="npc_dota_brewmaster_storm_1",waiting=60,count=s_count,interval=h_interval,nums=s_numbers}, --熊猫分身			
			-- {class="npc_dota_creature_basic_zombie",waiting=25,count=s_count,interval=l_interval,nums=large_number},
			-- {class="npc_dota_necronomicon_warrior_1",waiting=300,count=s_count,interval=h_interval,nums=m_numbers},
			-- {class="npc_dota_creature_berserk_zombie",waiting=60,count=s_count,interval=l_interval,nums=large_number},			
			-- {class="npc_dota_brewmaster_fire_1",waiting=400,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- {class="npc_dota_lone_druid_bear2",waiting=220,count=s_count,interval=h_interval,nums=s_numbers}, --德鲁伊的熊
			-- {class="npc_dota_necronomicon_warrior_2",waiting=220,count=s_count,interval=h_interval,nums=m_numbers},
			-- {class="npc_dota_beastmaster_boar",waiting=220,count=s_count,interval=l_interval,nums=m_numbers},  --野猪
			-- {class="npc_dota_beastmaster_greater_boar",waiting=220,count=s_count,interval=m_interval,nums=s_numbers}, --大野猪
			-- {class="npc_dota_brewmaster_earth_1",waiting=325,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- -- {class="npc_dota_lone_druid_bear1",waiting=15,count=s_count,interval=h_interval,nums=s_numbers}, --德鲁伊的熊
			-- -- {class="npc_dota_brewmaster_earth_2",waiting=65,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- {class="npc_dota_brewmaster_earth_3",waiting=320,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- {class="npc_dota_brewmaster_fire_2",waiting=405,count=s_count,interval=h_interval,nums=s_numbers},  --熊猫分身
			-- {class="npc_dota_brewmaster_fire_3",waiting=605,count=s_count,interval=h_interval,nums=s_numbers},  --熊猫分身
			-- -- {class="npc_dota_brewmaster_storm_2",waiting=120,count=s_count,interval=l_interval,nums=s_numbers}, --熊猫分身
			-- {class="npc_dota_brewmaster_storm_3",waiting=220,count=s_count,interval=h_interval,nums=s_numbers}, --熊猫分身
			-- -- {class="npc_dota_lone_druid_bear3",waiting=205,count=s_count,interval=m_interval,nums=s_numbers}, --德鲁伊的熊
			-- {class="npc_dota_lone_druid_bear4",waiting=405,count=s_count,interval=h_interval,nums=s_numbers}, --德鲁伊的熊


			-- {class="npc_dota_neutral_alpha_wolf",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --狼 不会自动走
			-- {class="npc_dota_neutral_big_thunder_lizard",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --雷兽 不会自动走
			-- {class="npc_dota_neutral_black_dragon",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --龙 不会自动走
			-- {class="npc_dota_neutral_black_drake",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --龙 不会自动走
			-- {class="npc_dota_neutral_centaur_khan",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --半人马 不会自动走
			-- {class="npc_dota_neutral_centaur_outrunner",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --半人马 不会自动走
			-- {class="npc_dota_neutral_dark_troll",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --巨魔 不会自动走
			-- {class="npc_dota_neutral_harpy_storm",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --不会自动走
			-- {class="npc_dota_neutral_jungle_stalker",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --巨魔 不会自动走
			-- {class="npc_dota_neutral_kobold_taskmaster",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --不会自动走
			-- {class="npc_dota_neutral_mud_golem",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --不会自动走
			-- {class="npc_dota_neutral_ogre_mauler",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --不会自动走
			-- {class="npc_dota_neutral_polar_furbolg_champion",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --不会自动走
			-- {class="npc_dota_neutral_polar_furbolg_ursa_warrior",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --不会自动走
			-- {class="npc_dota_neutral_rock_golem",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --不会自动走
			-- {class="npc_dota_neutral_satyr_soulstealer",wavespan=5,count=s_count,interval=40,nums=m_numbers}, --不会自动走
			-- {class="npc_dota_neutral_small_thunder_lizard",wavespan=5,count=s_count,interval=40,nums=m_numbers},	 --不会自动走	 

} 
small_flow={
			{class="slark",waiting=40,count=s_count,interval=m_interval,nums=huge_number},
			{class="meepo",waiting=30,count=s_count,interval=m_interval,nums=huge_number}, --米波
			{class="creep_vulture",waiting=20,count=s_count,interval=l_interval,nums=m_numbers},
			{class="npc_dota_brewmaster_storm_1",waiting=60,count=s_count,interval=h_interval,nums=s_numbers}, --熊猫分身			
			{class="npc_dota_creature_basic_zombie",waiting=25,count=s_count,interval=l_interval,nums=large_number},
			{class="npc_dota_necronomicon_warrior_1",waiting=300,count=s_count,interval=h_interval,nums=m_numbers},
			{class="npc_dota_creature_berserk_zombie",waiting=60,count=s_count,interval=l_interval,nums=large_number},			
			{class="npc_dota_brewmaster_fire_1",waiting=400,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			{class="npc_dota_lone_druid_bear2",waiting=220,count=s_count,interval=h_interval,nums=s_numbers}, --德鲁伊的熊
			{class="npc_dota_necronomicon_warrior_2",waiting=220,count=s_count,interval=h_interval,nums=m_numbers},
			{class="npc_dota_beastmaster_boar",waiting=220,count=s_count,interval=l_interval,nums=m_numbers},  --野猪
			{class="npc_dota_beastmaster_greater_boar",waiting=220,count=s_count,interval=m_interval,nums=s_numbers}, --大野猪
			{class="npc_dota_brewmaster_earth_1",waiting=325,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- {class="npc_dota_lone_druid_bear1",waiting=15,count=s_count,interval=h_interval,nums=s_numbers}, --德鲁伊的熊
			-- {class="npc_dota_brewmaster_earth_2",waiting=65,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- {class="npc_dota_brewmaster_earth_3",waiting=320,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- {class="npc_dota_brewmaster_fire_2",waiting=305,count=s_count,interval=h_interval,nums=s_numbers},  --熊猫分身
			-- {class="npc_dota_brewmaster_fire_3",waiting=305,count=s_count,interval=h_interval,nums=s_numbers},  --熊猫分身
			-- {class="npc_dota_brewmaster_storm_2",waiting=120,count=s_count,interval=l_interval,nums=s_numbers}, --熊猫分身
			{class="npc_dota_brewmaster_storm_3",waiting=420,count=s_count,interval=h_interval,nums=s_numbers}, --熊猫分身
			-- {class="npc_dota_lone_druid_bear3",waiting=205,count=s_count,interval=m_interval,nums=s_numbers}, --德鲁伊的熊
			-- {class="npc_dota_lone_druid_bear4",waiting=405,count=s_count,interval=h_interval,nums=s_numbers}, --德鲁伊的熊
}

camp_wave = {
		{class="npc_dota_neutral_centaur_khan",waiting=60,count=s_count,interval=m_interval,nums=s_numbers},
		{class="npc_dota_neutral_black_dragon",waiting=300,count=s_count,interval=m_interval,nums=s_numbers},		
		{class="npc_dota_lone_druid_bear1",waiting=300,count=s_count,interval=m_interval,nums=s_numbers}, --德鲁伊的熊
		{class="npc_dota_neutral_harpy_storm",waiting=300,count=s_count,interval=m_interval,nums=s_numbers},		
}

camp_wave_s = {
		{class="slark",waiting=30,count=s_count,interval=ss_interval,nums=m_numbers},
		{class="meepo",waiting=0,count=s_count,interval=ss_interval,nums=m_numbers},		
}



smithy_wave = {
			{class="slark",waiting=30,count=s_count,interval=s_interval,nums=m_numbers},
			{class="meepo",waiting=1,count=s_count,interval=s_interval,nums=m_numbers}, --米波
			{class="npc_dota_necronomicon_warrior_1",waiting=1,count=s_count,interval=s_interval,nums=m_numbers}, --米波			
}

boss_wave = {
			-- {class="boss_roshan",waiting=10,count=s_count,interval=10,nums=s_numbers,isQuest=true},
			-- {class="boss_spider",waiting=20,count=s_count,interval=10,nums=s_numbers, waypoint="bad_top_way2",isQuest=true},
			-- {class="boss_green_dragon",waiting=25,count=s_count,interval=10,nums=s_numbers,waypoint="bad_top_way2",isQuest=true},
			{class="boss_roshan",waiting=400,count=s_count,interval=480,nums=s_numbers,isQuest=true},
			{class="boss_spider",waiting=240,count=s_count,interval=480,nums=s_numbers, waypoint="bad_top_way2",isQuest=true},
			{class="boss_green_dragon",waiting=600,count=s_count,interval=480,nums=s_numbers,waypoint="bad_top_way2",isQuest=true},
}


boss_wave_not_move = {
			{class="npc_dota_creep_dire_golem",waiting=77,count=s_count,interval=300,nums=1,isQuest=false},
}

boss_wave_pvp1 = {
			{class="boss_spider",waiting=300,count=s_count,interval=360,nums=s_numbers,isQuest=true},
}

boss_wave_pvp2 = {
			{class="boss_green_dragon",waiting=300,count=s_count,interval=360,nums=s_numbers,isQuest=true},
}

boss_wave_pvp3 = {
			{class="boss_roshan",waiting=300,count=s_count,interval=360,nums=s_numbers,isQuest=true},
}

wave_pvp={
			{class="@random",waiting=1,count=20,interval=20,nums=7},
			-- {class="meepo",waiting=1,count=s_count,interval=8,nums=4}, --米波
			-- {class="creep_vulture",waiting=120,count=s_count,interval=l_interval,nums=m_numbers},
			-- -- {class="npc_dota_brewmaster_storm_1",waiting=60,count=s_count,interval=h_interval,nums=s_numbers}, --熊猫分身			
			-- {class="npc_dota_creature_basic_zombie",waiting=25,count=s_count,interval=l_interval,nums=large_number},
			-- -- {class="npc_dota_necronomicon_warrior_1",waiting=30,count=s_count,interval=l_interval,nums=large_number},
			-- -- {class="npc_dota_creature_berserk_zombie",waiting=60,count=s_count,interval=l_interval,nums=large_number},			
			-- {class="npc_dota_brewmaster_fire_1",waiting=200,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- -- {class="npc_dota_lone_druid_bear2",waiting=220,count=s_count,interval=m_interval,nums=s_numbers}, --德鲁伊的熊
			-- {class="npc_dota_necronomicon_warrior_2",waiting=220,count=s_count,interval=l_interval,nums=large_number},
			-- {class="npc_dota_beastmaster_boar",waiting=220,count=s_count,interval=l_interval,nums=m_numbers},  --野猪
			-- {class="npc_dota_beastmaster_greater_boar",waiting=220,count=s_count,interval=m_interval,nums=s_numbers}, --大野猪
			-- {class="npc_dota_brewmaster_earth_1",waiting=325,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- -- {class="npc_dota_lone_druid_bear1",waiting=15,count=s_count,interval=h_interval,nums=s_numbers}, --德鲁伊的熊
			-- -- {class="npc_dota_brewmaster_earth_2",waiting=65,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- -- {class="npc_dota_brewmaster_earth_3",waiting=320,count=s_count,interval=l_interval,nums=s_numbers},  --熊猫分身
			-- -- {class="npc_dota_brewmaster_fire_2",waiting=305,count=s_count,interval=h_interval,nums=s_numbers},  --熊猫分身
			-- -- {class="npc_dota_brewmaster_fire_3",waiting=305,count=s_count,interval=h_interval,nums=s_numbers},  --熊猫分身
			-- -- {class="npc_dota_brewmaster_storm_2",waiting=120,count=s_count,interval=l_interval,nums=s_numbers}, --熊猫分身
			-- {class="npc_dota_brewmaster_storm_3",waiting=220,count=s_count,interval=h_interval,nums=s_numbers}, --熊猫分身
			-- {class="npc_dota_lone_druid_bear3",waiting=205,count=s_count,interval=m_interval,nums=s_numbers}, --德鲁伊的熊
			-- {class="npc_dota_lone_druid_bear4",waiting=405,count=s_count,interval=h_interval,nums=s_numbers}, --德鲁伊的熊
}

-- 产怪点
spawner_table = 
{
	{
	name="sp_boss1",waves=boss_wave_not_move,max=2,team=DOTA_TEAM_NEUTRALS
	},
	{
	name="sp_good1",waves=wave_pvp,waypoint="good_top_way-1",team=DOTA_TEAM_GOODGUYS
	},
	{
	name="sp_good2",waves=wave_pvp,waypoint="good_mid_way1",team=DOTA_TEAM_GOODGUYS
	},
	{
	name="sp_bad1",waves=wave_pvp,waypoint="bad_bot_wayb1",team=DOTA_TEAM_BADGUYS
	},
	{
	name="sp_bad2",waves=wave_pvp,waypoint="bad_top_way1",team=DOTA_TEAM_BADGUYS
	},
	{
	name="good_top_spawner",waves=wave_flow,waypoint="good_top_way-1"
	},
	{
	name="good_mid_spawner",waves=wave_flow,waypoint="good_mid_way1"
	},
	{
	name="bad_top_spawner",waves=wave_flow,waypoint="bad_bot_wayb1"
	},
	{
	name="bad_bot_spawner",waves=wave_flow,waypoint="bad_top_way1"
	},
	{
	name="sp_ore",waves=small_flow,waypoint="good_top_way0"
	},
	{
	name="sp_mill",waves=small_flow,waypoint="bad_top_way2"
	},
	{
	name="sp_pit",waves=camp_wave,max=4,team=DOTA_TEAM_NEUTRALS
	},
	{
	name="sp_farm",waves=camp_wave,max=4,team=DOTA_TEAM_NEUTRALS
	},
	{
	name="sp_smithy1",waves=smithy_wave,max=18,waypoint="end1"
	},
	{
	name="sp_smithy2",waves=smithy_wave,max=18,waypoint="end2"
	},
	{
	name="boss_spawner",waves=boss_wave,waypoint="end2"
	},
	{
	name="boss_pvp1",waves=boss_wave_pvp1,max=2,team=DOTA_TEAM_NEUTRALS
	},
	{
	name="boss_pvp2",waves=boss_wave_pvp2,max=2,team=DOTA_TEAM_NEUTRALS
	},
	{
	name="boss_pvp3",waves=boss_wave_pvp3,max=2,team=DOTA_TEAM_NEUTRALS
	},
	{
	name="sp_camp1",waves=smithy_wave,max=6,team=DOTA_TEAM_NEUTRALS
	},	
	{
	name="sp_camp2",waves=smithy_wave,max=6,team=DOTA_TEAM_NEUTRALS
	},	
	{
	name="sp_camp3",waves=smithy_wave,max=6,team=DOTA_TEAM_NEUTRALS
	},	
	{
	name="sp_camp4",waves=smithy_wave,max=6,team=DOTA_TEAM_NEUTRALS
	},	
	{
	name="sp_camp5",waves=smithy_wave,max=6,team=DOTA_TEAM_NEUTRALS
	},	
	{
	name="sp_camp6",waves=smithy_wave,max=6,team=DOTA_TEAM_NEUTRALS
	},	
}

world_boos_flag=false





