--!strict

function GetFirstPlayerServerSide(): ServerPlayer|nil
  local allPlayers = ServerPlayerManager:players()
  return allPlayers[1]
end

function LinearTransformToString(pos:LinearTransform):string
  return `\nLinearTransform.fromTable(\{\nright = {Vec3ToString(pos.right)},\nup = {Vec3ToString(pos.up)},\nforward = {Vec3ToString(pos.forward)},\ntrans = {Vec3ToString(pos.trans)}})`
end

function Vec3ToString(pos:Vec3):string
  return `Vec3.fromTable(\{x = {pos.x}, y = {pos.y}, z = {pos.z}})`
end

-- This command can be executed from the PROCON console
if isServer() then
  RCONManager:registerCommand("print.position", true, false, function(): { string }
    local player: ServerPlayer | nil = GetFirstPlayerServerSide()
    if player and player.controlledControllable then
      local playerPosition = player.controlledControllable.transform
      
      return {LinearTransformToString(playerPosition)}
    else
      return {"Could not find player!"}
    end
  end)
end

return nil