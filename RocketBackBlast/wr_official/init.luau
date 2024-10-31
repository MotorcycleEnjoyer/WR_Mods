--!strict

local partitions = require("./partitions")

print("******************************************************")
print("****************** Hello World! ********************")
print("******************************************************")

local RPGBackBlast = {}

function RPGBackBlast:OnWeaponBlueprintLoaded(p_SoldierWeaponBlueprint: SoldierWeaponBlueprint)
  print("Added Backblast to RPG7")
  local s_SoldierWeaponData: SoldierWeaponData = p_SoldierWeaponBlueprint.object :: SoldierWeaponData
  local s_WeaponFiring= s_SoldierWeaponData.weaponFiring
  local s_FiringFunctionData = s_WeaponFiring.primaryFire
  local s_Shot = s_FiringFunctionData.shot
  local s_RPG7ProjectileData  = s_Shot.projectileData :: MissileEntityData
  
  local s_ClonedExplosion = s_RPG7ProjectileData.explosion:clone()
  s_ClonedExplosion.spawnDelay = 0.1
  s_ClonedExplosion.blastDamage = 100
  s_ClonedExplosion.innerBlastRadius = 1
  s_ClonedExplosion.blastRadius = 1.5
  s_ClonedExplosion.blastImpulse = 1000
  s_ClonedExplosion.triggerImpairedHearing = false
  -- hide the visual explosion
  s_ClonedExplosion.detonationEffect = nil :: any

  -- muzzle explosion happens at projectile spawnpoint, so move spawnpoint back
  -- this causes damage to self too often, needs a SoldierDamage hook to prevent
  s_Shot.initialPosition = Vec3.fromTable({x = -0.3, y = -0.1, z = -2.25}) -- default -0.3, -0.1, 2.0
  s_Shot.muzzleExplosion = s_ClonedExplosion
end

partitions.onInstanceLoad(
  Guid("E7F8EC1A-E8F5-11DF-AC96-84E6B0EFF32E"), 
  Guid("5AEB6BE2-1D46-8857-6CBE-17ADB6625809"),
  RPGBackBlast, 
  RPGBackBlast.OnWeaponBlueprintLoaded)

return nil