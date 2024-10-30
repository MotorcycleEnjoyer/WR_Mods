--!strict

local partitions = require("./partitions")

local MultiplayerSoldier_ = {}
MultiplayerSoldier_.__index = MultiplayerSoldier_
local MultiplayerSoldier = MultiplayerSoldier_

local SoldierBlueprintGuids = {
  partitionGuid = Guid("9697F666-AFF6-4035-AC81-148AC0E840F3"),
  instanceGuid = Guid("B70DB8C3-C043-41E4-971D-C997970D35A5")
}

function MultiplayerSoldier:OnSoldierBlueprintLoaded(p_SoldierBlueprint: SoldierBlueprint)
    print("***** Found MultiplayerSoldier Blueprint!!!")

    local s_SoldierEntity= p_SoldierBlueprint.object :: SoldierEntityData
    local s_CharacterPhysics = s_SoldierEntity.characterPhysics

    local s_OnGroundState = s_CharacterPhysics.states[1] :: OnGroundStateData
    local s_OnGroundStanding = s_OnGroundState.poseInfo[1]

    local s_JumpState= s_CharacterPhysics.states[2] :: JumpStateData
    local s_StandingJump= s_JumpState.poseInfo[1]

    local s_InAirState = s_CharacterPhysics.states[3] :: InAirStateData
    local s_StandingInAir= s_InAirState.poseInfo[1]

    -- reducing standing movement by 10%
    s_OnGroundStanding.velocity = 3.6 -- original 4
    s_StandingJump.velocity = 3.6 -- original 4
    s_StandingInAir.velocity = 5.4 -- original 6

    -- use same accel / decel values as onGroundStanding
    s_StandingInAir.accelerationGain = 0.28
    s_StandingInAir.accelerationGain_TickRateMult = 0.038
    s_StandingInAir.accelerationGain_TickRatePower = 0.35
    s_StandingJump.decelerationGain = -14
    s_StandingJump.decelerationGain_TickRateMult = -0.24
    s_StandingJump.decelerationGain_TickRatePower = 0.63


end

partitions.onInstanceLoad(
    SoldierBlueprintGuids.partitionGuid,
    SoldierBlueprintGuids.instanceGuid,
    MultiplayerSoldier,
    MultiplayerSoldier.OnSoldierBlueprintLoaded
)

return nil