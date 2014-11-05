if HuoQiangGameMode == nil then
	HuoQiangGameMode = class({})

end
 


CUSTOM_STATE_PREPARE = 0
CUSTOM_STATE_IN_ROUND = 1
CUSTOM_STATE_ROUND_REST = 2
CUSTOM_STATE_GAME_END = 3


local killed_0_hero = true
local killed_1_hero = true
local killed_2_hero = true
local killed_3_hero = true

local killed_5_hero = true
local killed_6_hero = true
local killed_7_hero = true
local killed_8_hero = true

local player_0_bingying
local player_1_bingying
local player_2_bingying
local player_3_bingying

local player_5_bingying
local player_6_bingying
local player_7_bingying
local player_8_bingying

local bingying_0_created = false
local bingying_1_created = false
local bingying_2_created = false
local bingying_3_created = false

local bingying_5_created = false
local bingying_6_created = false
local bingying_7_created = false
local bingying_8_created = false

local bingying_0_destroyed = false
local bingying_1_destroyed = false
local bingying_2_destroyed = false
local bingying_3_destroyed = false

local bingying_5_destroyed = false
local bingying_6_destroyed = false
local bingying_7_destroyed = false
local bingying_8_destroyed = false

local shengling = false
local kuandong = false



--单位记数
unitcount = unitcount or {}
for i=-1,9 do
	unitcount[i] = 0
end

local unitcountmax = 0

local counter = 10


--飞机起飞降落
shaota = shaota or {}
for i=0,9 do
	 shaota[i] = 0
end



--------------------------------

--------------------------------------


function Activate()
    HuoQiangGameMode:InitGameMode()
end

function HuoQiangGameMode:InitGameMode()

	--GameRules:SetUseCustomHeroXPValues (true) 					--使用自定义经验
	--GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true) 	--使用自定义等级
	--GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( 60 ) 	--最高等级60级
	--GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( CUSTOM_XP_TABLE ) --定义等级表
	-- GameRules:SetHeroRespawnEnabled( false )					--英雄是否使用默认重生
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )	--是否可以买活

	GameRules:SetHeroSelectionTime(1)			--选择英雄时间
	GameRules:SetPreGameTime(10)						--准备时间
	GameRules:SetSameHeroSelectionEnabled( true )				--复选英雄

	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride(true)--物品禁用启用？
	GameRules:SetGoldPerTick( 0 )
    GameRules:SetFirstBloodActive(false) 

	ListenToGameEvent('entity_killed', Dynamic_Wrap(HuoQiangGameMode, 'OnEntityKilled'), self) --死亡计数
	--游戏状态改变事件
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap(HuoQiangGameMode, "OnGameRulesStateChange" ), self )--游戏正在开始的一刻

	--单位出生时设置技能
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap(HuoQiangGameMode, "OnNPCSpawned" ), self )--dota_player_pick_hero
	--ListenToGameEvent( "hero_picker_hidden", Dynamic_Wrap(HuoQiangGameMode, "OnHeroPickerHidden" ), self )
	--英雄重生
	--ListenToGameEvent( "npc_spawned", Dynamic_Wrap(HuoQiangGameMode, "HeroSpawn" ), self )
	--英雄数量
	ListenToGameEvent("player_connect_full", Dynamic_Wrap( HuoQiangGameMode, "InitAllotCourier" ), self)

	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( HuoQiangGameMode, "OnPlayerLevelUp" ), self ) -- 英雄设计


 	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )
end

----------


function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]

	PrecacheResource( "particle","particles/econ/paodan.vpcf", context)
	PrecacheResource( "particle","particles/econ/items/mirana_spell_arrow.vpcf", context)

	PrecacheResource( "particle","particles/econ/items/sniper_base_attack.vpcf", context)
	PrecacheResource( "models","models/items/rattletrap/clockmaster_misc/clockmaster_misc.vmdl", context)
	PrecacheResource( "particle","particles/base_attacks/ranged_tower_bad_trail_d.vpcf", context)--2
	
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context )
  PrecacheResource( "particle_folder", "particles/units/heroes/hero_rattletrap", context )

end
--------------------------------
if InitPart_one == nil then
	InitPart_one = {}

end


function HuoQiangGameMode:InitAllotCourier(keys)
	local entindex = keys.index+1
	local player = EntIndexToHScript(entindex)
	local plyID = player:GetPlayerID()
	table.insert(InitPart_one,entindex)
	print("length:",#InitPart_one)
	if plyID == -1 then
	end
		if #InitPart_one <=4 then
			if #InitPart_one <=2 then
				unitcountmax = 60 
			else
				unitcountmax = 35 
			end
		else
				unitcountmax = 30
		end
		print("unitcountmax:",unitcountmax)
end






function HuoQiangGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		counter = counter + 1
	self:Spawn(0,player_0_bingying, bingying_0_created, bingying_0_destroyed)
	self:Spawn(1,player_1_bingying, bingying_1_created, bingying_1_destroyed)
	self:Spawn(2,player_2_bingying, bingying_2_created, bingying_2_destroyed)
	self:Spawn(3,player_3_bingying, bingying_3_created, bingying_3_destroyed)
	self:Spawn(5,player_5_bingying, bingying_5_created, bingying_5_destroyed)
	self:Spawn(6,player_6_bingying, bingying_6_created, bingying_6_destroyed)
	self:Spawn(7,player_7_bingying, bingying_7_created, bingying_7_destroyed)
	self:Spawn(8,player_8_bingying, bingying_8_created, bingying_8_destroyed)

		if counter == 15 then
			counter = 0
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end



	if bingying_0_destroyed == true then
	GameRules:SetGameWinner(DOTA_TEAM_BADGUYS) 
	elseif bingying_5_destroyed == true then
	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) 
	end
	return 1
end	

function HuoQiangGameMode:Spawn(player, player_bingying, bingying_created, bingying_destroyed)
	if bingying_created == true  then
		if player_bingying:IsAlive() then
			if counter == 15 and unitcount[player] <= unitcountmax then
				player_bingying:CastAbilityNoTarget(player_bingying:GetAbilityByIndex(0), 0)
				
			end
		elseif player == 0 then bingying_0_destroyed = true	
		elseif player == 1 then bingying_1_destroyed = true	
		elseif player == 2 then bingying_2_destroyed = true	
		elseif player == 3 then bingying_3_destroyed = true	
		elseif player == 5 then bingying_5_destroyed = true	
		elseif player == 6 then bingying_6_destroyed = true	
		elseif player == 7 then bingying_7_destroyed = true	
		elseif player == 8 then bingying_8_destroyed = true	
		end
	end
end
        	

function HuoQiangGameMode:OnGameRulesStateChange( keys )
        print("OnGameRulesStateChange")
        if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
			shengling = CreateUnitByName( "npc_bingying_shengling", Vector(-1185,4265,128) , false, nil, nil, DOTA_TEAM_NEUTRALS )
        	kuandong = CreateUnitByName( "npc_bingying_kuandong", Vector(-885,-2479,128) , false, nil, nil, DOTA_TEAM_NEUTRALS )
        	shaota[1] = CreateUnitByName( "npc_shaota_shaota", Vector(-3458,1272,128) , false, nil, nil, DOTA_TEAM_GOODGUYS )
        	shaota[2] = CreateUnitByName( "npc_shaota_shaota", Vector(1518,1280,128) , false, nil, nil, DOTA_TEAM_BADGUYS )
        	shaota[3] = CreateUnitByName( "npc_shaota_shaota", Vector(-882,-196,512) , false, nil, nil, DOTA_TEAM_NEUTRALS )
			shaota[1]:SetControllableByPlayer(0, true)
			shaota[2]:SetControllableByPlayer(5, true)
        	shengling:SetAngles(0, 105, 0)
        	--kuandong:SetAngles(0, 90, 0)
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("kuandonggold"), 
		function()

				for i=0,9 do
				PlayerResource:SetGold(i,PlayerResource:GetGold(i) + 50 ,false) 
				end
            	return 60
			
		end,0)
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("kuandonggold"), 
		function()
			local kuandongteam = kuandong:GetTeamNumber()  
			print(kuandongteam)
			if kuandongteam == 3 then
				for i=5,9 do
				PlayerResource:SetGold(i,PlayerResource:GetGold(i) + 50 ,false) 
				end
               	return 60
            elseif kuandongteam == 2 then
            	for i=0,4 do
				PlayerResource:SetGold(i,PlayerResource:GetGold(i) + 50 ,false) 
			
				end
            	return 60
            else
            	return 60
			end
		end,0)
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("shenglinggold"), 
		function()
			print(shenglingteam)
			local shenglingteam = shengling:GetTeamNumber()  

			if shenglingteam == 3 then
				for i=5,9 do
				--local player = PlayerResource:GetPalyer(GetPlayerID(i))
				PlayerResource:SetGold(i,PlayerResource:GetGold(i) + 25 ,false) 

				end
               	return 45
            elseif shenglingteam == 2 then
            	for i=0,4 do
				--local player = PlayerResource:GetPalyer(GetPlayerID(i))
				PlayerResource:SetGold(i,PlayerResource:GetGold(i) + 25 ,false) 

				end
            	return 45
           	else
            	return 45
			end
		end,0)
        end


end





function HuoQiangGameMode:OnNPCSpawned( event )
	print (event.entindex)
	local spawnedUnit = EntIndexToHScript( event.entindex )
	local abilitycount = spawnedUnit:GetAbilityCount() 
	if spawnedUnit:GetTeam() == DOTA_TEAM_BADGUYS then
		if spawnedUnit:GetPlayerOwnerID() == 1 then spawnedUnit:SetPlayerID(5) 
		elseif spawnedUnit:GetPlayerOwnerID() == 2 then spawnedUnit:SetPlayerID(6) 
		elseif spawnedUnit:GetPlayerOwnerID() == 3 then spawnedUnit:SetPlayerID(7) end
	end
	if killed_0_hero == true and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 0 then
		spawnedUnit:ForceKill(true)
		killed_0_hero = false
		spawnedUnit:SetTimeUntilRespawn(0)  
		spawnedUnit:SetGold(1000, false)
		spawnedUnit:SetAbilityPoints(0) 
	elseif bingying_0_created == false and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 0  then
			player_0_bingying = CreateUnitByName( "npc_bingying_bubing", Vector(-4457,-228,128) , false, spawnedUnit, spawnedUnit, spawnedUnit:GetTeam() )
			player_0_bingying:SetControllableByPlayer(spawnedUnit:GetOwner():GetPlayerID(), true)
			bingying_0_created = true
			if   spawnedUnit:GetUnitName() == "npc_dota_hero_gyrocopter" then
				local a = spawnedUnit:FindAbilityByName("movement_up") 
				local b = spawnedUnit:FindAbilityByName('shejishu')
				local c = spawnedUnit:FindAbilityByName('xiaohao_zidan_1')
				local d = spawnedUnit:FindAbilityByName('missyi')
				local e = spawnedUnit:FindAbilityByName('feiji_siwang')
				local f = spawnedUnit:FindAbilityByName('movement_auto_ability')
				f:SetLevel(1)
				--local e = spawnedUnit:FindAbilityByName('wufagongji_jinzhan')


					a:SetLevel(1)
					b:SetLevel(1)
					c:SetLevel(1)
					d:SetLevel(4)
					e:SetLevel(1)
					

			else
				for i=0,abilitycount do
					if	spawnedUnit:GetAbilityByIndex(i) then
					spawnedUnit:GetAbilityByIndex(i):SetLevel(1)
					end
				end
		end
		
	end
	if killed_1_hero == true and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 1 then
		spawnedUnit:ForceKill(true)
		killed_1_hero = false
		spawnedUnit:SetTimeUntilRespawn(0) 
		spawnedUnit:SetGold(200, false)
		spawnedUnit:SetAbilityPoints(0) 		
	elseif bingying_1_created == false and spawnedUnit:IsHero()  and spawnedUnit:GetPlayerOwnerID() == 1  then
			player_1_bingying = CreateUnitByName( "npc_bingying_bubing", Vector(-3284,-1806,128) , false, spawnedUnit, spawnedUnit, spawnedUnit:GetTeam() )
			player_1_bingying:SetControllableByPlayer(spawnedUnit:GetOwner():GetPlayerID(), true)
			
			bingying_1_created = true
			if   spawnedUnit:GetUnitName() == "npc_dota_hero_gyrocopter" then
				local a = spawnedUnit:FindAbilityByName("movement_up") 
				local b = spawnedUnit:FindAbilityByName('shejishu')
				local c = spawnedUnit:FindAbilityByName('xiaohao_zidan_1')
				local d = spawnedUnit:FindAbilityByName('missyi')
				local e = spawnedUnit:FindAbilityByName('feiji_siwang')
			local f = spawnedUnit:FindAbilityByName('movement_auto_ability')
				f:SetLevel(1)
					a:SetLevel(1)
					b:SetLevel(1)
					c:SetLevel(1)
					d:SetLevel(4)
					e:SetLevel(1)
			else
				for i=0,abilitycount do
					if	spawnedUnit:GetAbilityByIndex(i) then
					spawnedUnit:GetAbilityByIndex(i):SetLevel(1)
					end
				end
		end
		
	end
		if killed_2_hero == true and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 0 then
		spawnedUnit:ForceKill(true)
		killed_2_hero = false
		spawnedUnit:SetTimeUntilRespawn(0)  
				spawnedUnit:SetGold(200, false)
		spawnedUnit:SetAbilityPoints(0) 
	elseif bingying_2_created == false and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 2  then
			player_2_bingying = CreateUnitByName( "npc_bingying_bubing", Vector(-4863,1405,128) , false, spawnedUnit, spawnedUnit, spawnedUnit:GetTeam() )
			player_2_bingying:SetControllableByPlayer(spawnedUnit:GetOwner():GetPlayerID(), true)
			bingying_2_created = true
			if   spawnedUnit:GetUnitName() == "npc_dota_hero_gyrocopter" then
				local a = spawnedUnit:FindAbilityByName("movement_up") 
				local b = spawnedUnit:FindAbilityByName('shejishu')
				local c = spawnedUnit:FindAbilityByName('xiaohao_zidan_1')
				local d = spawnedUnit:FindAbilityByName('missyi')
				local e = spawnedUnit:FindAbilityByName('feiji_siwang')
			local f = spawnedUnit:FindAbilityByName('movement_auto_ability')
				f:SetLevel(1)
					a:SetLevel(1)
					b:SetLevel(1)
					c:SetLevel(1)
					d:SetLevel(4)
					e:SetLevel(1)
			else
				for i=0,abilitycount do
					if	spawnedUnit:GetAbilityByIndex(i) then
					spawnedUnit:GetAbilityByIndex(i):SetLevel(1)
					end
				end
		end
		
	end
		if killed_5_hero == true and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 0 then
		spawnedUnit:ForceKill(true)
		killed_5_hero = false
		spawnedUnit:SetTimeUntilRespawn(0)  
				spawnedUnit:SetGold(200, false)
		spawnedUnit:SetAbilityPoints(0) 
	elseif bingying_5_created == false and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 5  then
			player_5_bingying = CreateUnitByName( "npc_bingying_bubing", Vector(2460,-173,128) , false, spawnedUnit, spawnedUnit, spawnedUnit:GetTeam() )
			player_5_bingying:SetControllableByPlayer(spawnedUnit:GetOwner():GetPlayerID(), true)
			player_5_bingying:SetAngles(0,180,0) 
			bingying_5_created = true
			if   spawnedUnit:GetUnitName() == "npc_dota_hero_gyrocopter" then
				local a = spawnedUnit:FindAbilityByName("movement_up") 
				local b = spawnedUnit:FindAbilityByName('shejishu')
				local c = spawnedUnit:FindAbilityByName('xiaohao_zidan_1')
				local d = spawnedUnit:FindAbilityByName('missyi')
				local e = spawnedUnit:FindAbilityByName('feiji_siwang')
				local f = spawnedUnit:FindAbilityByName('movement_auto_ability')
				f:SetLevel(1)
					a:SetLevel(1)
					b:SetLevel(1)
					c:SetLevel(1)
					d:SetLevel(4)
					e:SetLevel(1)
			else
				for i=0,abilitycount do
					if	spawnedUnit:GetAbilityByIndex(i) then
					spawnedUnit:GetAbilityByIndex(i):SetLevel(1)
					end
				end
		end
		
	end
		if killed_6_hero == true and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 0 then
		spawnedUnit:ForceKill(true)
		killed_6_hero = false
		spawnedUnit:SetTimeUntilRespawn(0)  
				spawnedUnit:SetGold(200, false)
		spawnedUnit:SetAbilityPoints(0) 
	elseif bingying_6_created == false and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 6  then
			player_6_bingying = CreateUnitByName( "npc_bingying_bubing", Vector(1714,-1806,128) , false, spawnedUnit, spawnedUnit, spawnedUnit:GetTeam() )
			player_6_bingying:SetControllableByPlayer(spawnedUnit:GetOwner():GetPlayerID(), true)
			player_6_bingying:SetAngles(0,180,0) 
			bingying_6_created = true
			if   spawnedUnit:GetUnitName() == "npc_dota_hero_gyrocopter" then
				local a = spawnedUnit:FindAbilityByName("movement_up") 
				local b = spawnedUnit:FindAbilityByName('shejishu')
				local c = spawnedUnit:FindAbilityByName('xiaohao_zidan_1')
				local d = spawnedUnit:FindAbilityByName('missyi')
				local e = spawnedUnit:FindAbilityByName('feiji_siwang')
				local f = spawnedUnit:FindAbilityByName('movement_auto_ability')
				f:SetLevel(1)
					a:SetLevel(1)
					b:SetLevel(1)
					c:SetLevel(1)
					d:SetLevel(4)
					e:SetLevel(1)
			else
				for i=0,abilitycount do
					if	spawnedUnit:GetAbilityByIndex(i) then
					spawnedUnit:GetAbilityByIndex(i):SetLevel(1)
					end
				end
		end
		
	end
		if killed_7_hero == true and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 0 then
		spawnedUnit:ForceKill(true)
		killed_7_hero = false
		spawnedUnit:SetTimeUntilRespawn(0) 
				spawnedUnit:SetGold(200, false)
		spawnedUnit:SetAbilityPoints(0)  
	elseif bingying_7_created == false and spawnedUnit:IsHero() and spawnedUnit:GetPlayerOwnerID() == 7  then
			player_7_bingying = CreateUnitByName( "npc_bingying_bubing", Vector(3311,1405,128) , false, spawnedUnit, spawnedUnit, spawnedUnit:GetTeam() )
			player_7_bingying:SetControllableByPlayer(spawnedUnit:GetOwner():GetPlayerID(), true)
			player_7_bingying:SetAngles(0,180,0) 
			bingying_7_created = true
			if   spawnedUnit:GetUnitName() == "npc_dota_hero_gyrocopter" then
				local a = spawnedUnit:FindAbilityByName("movement_up") 
				local b = spawnedUnit:FindAbilityByName('shejishu')
				local c = spawnedUnit:FindAbilityByName('xiaohao_zidan_1')
				local d = spawnedUnit:FindAbilityByName('missyi')
				local e = spawnedUnit:FindAbilityByName('feiji_siwang')
		local f = spawnedUnit:FindAbilityByName('movement_auto_ability')
				f:SetLevel(1)
					a:SetLevel(1)
					b:SetLevel(1)
					c:SetLevel(1)
					d:SetLevel(4)
					e:SetLevel(1)
			else
				for i=0,abilitycount do
					if	spawnedUnit:GetAbilityByIndex(i) then
					spawnedUnit:GetAbilityByIndex(i):SetLevel(1)
					end
				end
		end
		
	end
	if   spawnedUnit:GetUnitName() == "npc_bingying_shengling" then
		shengling = spawnedUnit
		shengling:SetAngles(0, 105, 0)
		if shengling:GetTeamNumber() == 2 then

			 player_0_bingying:GetAbilityByIndex(3):SetHidden(false) 
			 player_1_bingying:GetAbilityByIndex(3):SetHidden(false) 
			 player_2_bingying:GetAbilityByIndex(3):SetHidden(false) 

			 player_5_bingying:GetAbilityByIndex(3):SetHidden(true) 
			 player_6_bingying:GetAbilityByIndex(3):SetHidden(true) 
			 player_7_bingying:GetAbilityByIndex(3):SetHidden(true) 
		elseif shengling:GetTeamNumber() == 3 then
			 player_0_bingying:GetAbilityByIndex(3):SetHidden(true) 
			 player_1_bingying:GetAbilityByIndex(3):SetHidden(true) 
			 player_2_bingying:GetAbilityByIndex(3):SetHidden(true) 

			 player_5_bingying:GetAbilityByIndex(3):SetHidden(false) 
			 player_6_bingying:GetAbilityByIndex(3):SetHidden(false) 
			 player_7_bingying:GetAbilityByIndex(3):SetHidden(false) 
		end
	end
	if   spawnedUnit:GetUnitName() == "npc_bingying_kuandong" then
		kuandong = spawnedUnit
			if kuandong:GetTeamNumber() == 2 then
			 player_0_bingying:GetAbilityByIndex(2):SetHidden(false) 
			 player_1_bingying:GetAbilityByIndex(2):SetHidden(false) 
			 player_2_bingying:GetAbilityByIndex(2):SetHidden(false) 

			 player_5_bingying:GetAbilityByIndex(2):SetHidden(true) 
			 player_6_bingying:GetAbilityByIndex(2):SetHidden(true) 
			 player_7_bingying:GetAbilityByIndex(2):SetHidden(true) 
			 elseif kuandong:GetTeamNumber() == 3 then
			 player_0_bingying:GetAbilityByIndex(2):SetHidden(true) 
			 player_1_bingying:GetAbilityByIndex(2):SetHidden(true) 
			 player_2_bingying:GetAbilityByIndex(2):SetHidden(true) 

			 player_5_bingying:GetAbilityByIndex(2):SetHidden(false) 
			 player_6_bingying:GetAbilityByIndex(2):SetHidden(false) 
			 player_7_bingying:GetAbilityByIndex(2):SetHidden(false) 
		end

	end	

	if   spawnedUnit:IsCreature()  then
		local player = spawnedUnit:GetPlayerOwnerID() 
		unitcount[player] = unitcount[player] + 1
	end

	if   spawnedUnit:GetUnitName() == "npc_shibing_jujishou" then
		spawnedUnit:GetAbilityByIndex(4):SetLevel(2) 
	end
	if   spawnedUnit:GetUnitName() == "npc_shibing_zhengchabing" then
		spawnedUnit:GetAbilityByIndex(4):SetLevel(2) 
	end
	if   spawnedUnit:GetUnitName() == "npc_shaota_shaota" then
		spawnedUnit:AddNewModifier(nil, nil, 'modifier_rooted',{Duration=7200})
	end

	if   spawnedUnit:GetUnitName() == "npc_dota_hero_gyrocopter" then
		spawnedUnit:AddNewModifier(nil, nil, 'modifier_rooted',{Duration=7200})
	end
end

function HuoQiangGameMode:OnEntityKilled(event)	
	    --PrintTable(event)
	    local killedUnit = EntIndexToHScript(event.entindex_killed)
	    local killedattacker = EntIndexToHScript(event.entindex_attacker)
	  if killedUnit:IsCreature()  then

		  	if  killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS or killedUnit:GetTeam() ==  DOTA_TEAM_BADGUYS then
		  	local ID = killedUnit:GetPlayerOwnerID()
		  	unitcount[ID] = unitcount[ID] - 1
		  end

	  end
	--	if killedUnit:IsHero()  then
	--	local gold = killedUnit:GetGold
	--	killedUnit:SetGold(gold+killedUnit:GetDeathGoldCost() , false)
	--	 end
end



function HuoQiangGameMode:OnPlayerLevelUp(event)
        local id=event.player-1 
        local heroEnt=PlayerResource:GetSelectedHeroEntity(id)
        PlayerResource:SpendGold(heroEnt:GetPlayerOwnerID(),-100,0) 
        heroEnt:SetAbilityPoints(0) 
end
