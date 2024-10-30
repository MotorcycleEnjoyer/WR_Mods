--!strict

local partitions = require("./partitions")

local Spas12Frag = {}

function Spas12Frag:OnWeaponBlueprintLoaded(p_SoldierWeaponBlueprint: SoldierWeaponBlueprint)
  local s_SoldierWeaponData: SoldierWeaponData = p_SoldierWeaponBlueprint.object :: SoldierWeaponData
  local s_Spas12FragWeaponModifier = s_SoldierWeaponData.weaponModifierData[18]
  local s_Spas12FragWeaponFiringDataModifier = s_Spas12FragWeaponModifier.modifiers[1] :: WeaponFiringDataModifier
  
  local s_WeaponFiring= s_Spas12FragWeaponFiringDataModifier.weaponFiring
  local s_FiringFunctionData = s_WeaponFiring.primaryFire
  local s_Shot = s_FiringFunctionData.shot
  s_Shot.initialSpeed = Vec3.fromTable({x = 0, y = 0.775, z = 300}) -- default 0, 1.55, 150
end

partitions.onInstanceLoad(
  Guid("03A1F835-6326-4E3A-82BF-EA39876CE9CB"), 
  Guid("040A0BA8-9FB8-46CE-8949-340EB646FFFA"),
  Spas12Frag, 
  Spas12Frag.OnWeaponBlueprintLoaded)

return nil