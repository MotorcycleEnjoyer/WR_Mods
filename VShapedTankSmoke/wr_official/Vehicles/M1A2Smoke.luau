--!strict

local partitions = require("./partitions")

local M1A2Abrams = {}

local M1A2VehicleBlueprint = {
	partitionGuid = "B069BA89-EECF-11DD-8117-9421284A74E5",
	instanceGuid = "B06A08AB-EECF-11DD-8117-9421284A74E5",
}

local m_SmokeVerticalSpeed = 6
local m_SmokeCenterSpeedSideways = 0
local m_SmokeInnerSpeedSideways = 10
local m_SmokeMiddleSpeedSideways = 15
local m_SmokeOuterSpeedSideways = 20
local m_SmokeCenterSpeedForwards = 30
local m_SmokeInnerSpeedForwards = 23
local m_SmokeMiddleSpeedForwards = 15
local m_SmokeOuterSpeedForwards = 9

function M1A2Abrams:OnLoad(p_VehicleBlueprint: VehicleBlueprint)
	print("Abrams Vehicle Loaded!!!")
  local s_VehicleEntity = p_VehicleBlueprint.object :: VehicleEntityData
  local s_VehicleComponentData = s_VehicleEntity.components[1] :: VehicleComponentData
  local s_VehicleSmokeUnlockComponent = s_VehicleComponentData.components[1] :: UnlockComponentData
  
  local s_VehicleSmokeUnlockComponentCopy = s_VehicleSmokeUnlockComponent:clone()

  local s_VehicleTurret  = s_VehicleComponentData.components[7] :: ChildComponentData

	-- storing copy of smoke unlock inside turret
  s_VehicleTurret.components:push(s_VehicleSmokeUnlockComponentCopy)

  -- deleting original smoke unlock
  s_VehicleComponentData.components:remove(1)

	-- turning the copied smoke unlock into V-Shaped smoke
  M1A2Abrams:vSmoke(s_VehicleSmokeUnlockComponentCopy)

  -- +9: adding [unlock component] which holds [7 smoke components] and [1 jam component]
  -- -3: removing [unlock component] which held [1 jam] and [1 wep component] 
  -- TOTAL: 6 new components
  s_VehicleEntity.serverRuntimeComponentCount += 6
  s_VehicleEntity.serverRuntimeTransformationCount += 6
  s_VehicleEntity.clientRuntimeComponentCount += 6
  s_VehicleEntity.clientRuntimeTransformationCount += 6
end

function M1A2Abrams:TweakSmoke(p_WeaponComponentData: WeaponComponentData, p_InitialSpeed: Vec3)
	-- Make copies of WeaponFiring and PrimaryFire and attach those copies to the WeaponComponent
	local s_CustomWeaponFiringData = p_WeaponComponentData.weaponFiring:clone()
	local s_CustomFiringFunctionData = s_CustomWeaponFiringData.primaryFire:clone()

	local s_Shot = s_CustomFiringFunctionData.shot

	s_Shot.initialSpeed = p_InitialSpeed
	s_Shot.initialDirection = Vec3.fromTable({x = 0, y = 0, z = 1})
	s_Shot.initialPosition = Vec3.fromTable({x = 0, y = 0, z = 0})
	s_Shot.forceSpawnToCamera = true

	local s_Projectile  = s_Shot.projectileData :: BulletEntityData

	-- make the smoke appear ONLY when projectile explodes
	if s_Shot.muzzleExplosion then
		s_Projectile.explosion = s_Shot.muzzleExplosion:clone()
		s_Projectile.dudExplosion = s_Shot.muzzleExplosion:clone()
		-- NOT when the projectile appears (muzzle explosion)
		s_Shot.muzzleExplosion = nil :: any
	end

	-- airburst the smoke
	s_Projectile.timeToLive = 1.0
	s_Projectile.detonateOnTimeout = true 

	-- attach the modified copies to the weapon component
	s_CustomWeaponFiringData.primaryFire = s_CustomFiringFunctionData
	p_WeaponComponentData.weaponFiring = s_CustomWeaponFiringData
end

function M1A2Abrams:vSmoke(p_VehicleSmokeUnlockComponent: UnlockComponentData)
  local s_SmokeWeaponComponent = p_VehicleSmokeUnlockComponent.components[2] :: WeaponComponentData

	local s_CenterSmoke = s_SmokeWeaponComponent:clone()
	local s_LeftInnerSmoke = s_SmokeWeaponComponent:clone()
	local s_RightInnerSmoke = s_SmokeWeaponComponent:clone()
	local s_LeftMiddleSmoke = s_SmokeWeaponComponent:clone()
	local s_RightMiddleSmoke = s_SmokeWeaponComponent:clone()
	local s_LeftOuterSmoke = s_SmokeWeaponComponent:clone()
	local s_RightOuterSmoke = s_SmokeWeaponComponent:clone()

  -- remove the smoke in middle
  p_VehicleSmokeUnlockComponent.components:remove(2)

	M1A2Abrams:TweakSmoke(s_CenterSmoke, Vec3.fromTable({x = m_SmokeCenterSpeedSideways, y = m_SmokeVerticalSpeed, z = m_SmokeCenterSpeedForwards}))
	M1A2Abrams:TweakSmoke(s_LeftInnerSmoke, Vec3.fromTable({x = -m_SmokeInnerSpeedSideways, y = m_SmokeVerticalSpeed,z =  m_SmokeInnerSpeedForwards}))
	M1A2Abrams:TweakSmoke(s_RightInnerSmoke, Vec3.fromTable({x = m_SmokeInnerSpeedSideways, y = m_SmokeVerticalSpeed, z = m_SmokeInnerSpeedForwards}))
	M1A2Abrams:TweakSmoke(s_LeftMiddleSmoke, Vec3.fromTable({x = -m_SmokeMiddleSpeedSideways, y = m_SmokeVerticalSpeed, z = m_SmokeMiddleSpeedForwards}))
	M1A2Abrams:TweakSmoke(s_RightMiddleSmoke, Vec3.fromTable({x = m_SmokeMiddleSpeedSideways,y =  m_SmokeVerticalSpeed, z = m_SmokeMiddleSpeedForwards}))
	M1A2Abrams:TweakSmoke(s_LeftOuterSmoke, Vec3.fromTable({x = -m_SmokeOuterSpeedSideways, y = m_SmokeVerticalSpeed, z = m_SmokeOuterSpeedForwards}))
	M1A2Abrams:TweakSmoke(s_RightOuterSmoke, Vec3.fromTable({x = m_SmokeOuterSpeedSideways, y = m_SmokeVerticalSpeed, z = m_SmokeOuterSpeedForwards}))

	p_VehicleSmokeUnlockComponent.components:push(s_CenterSmoke)
	p_VehicleSmokeUnlockComponent.components:push(s_LeftInnerSmoke)
	p_VehicleSmokeUnlockComponent.components:push(s_RightInnerSmoke)
	p_VehicleSmokeUnlockComponent.components:push(s_LeftMiddleSmoke)
	p_VehicleSmokeUnlockComponent.components:push(s_RightMiddleSmoke)
	p_VehicleSmokeUnlockComponent.components:push(s_LeftOuterSmoke)
	p_VehicleSmokeUnlockComponent.components:push(s_RightOuterSmoke)
end

partitions.onAllInstancesLoaded(M1A2Abrams, M1A2Abrams.OnLoad, {
	partition = Guid(M1A2VehicleBlueprint.partitionGuid),
	instance = Guid(M1A2VehicleBlueprint.instanceGuid),
})

return nil