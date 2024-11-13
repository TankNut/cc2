local PLAYER = {}

PLAYER.DisplayName			= "CombineControl"
PLAYER.TeammateNoCollide	= false
PLAYER.AvoidPlayers			= false

PLAYER.WalkSpeed 			= 95
PLAYER.RunSpeed 			= 150
PLAYER.JumpPower 			= 160


function PLAYER:GetHandsModel()
end

function PLAYER:StartMove(move)
end

function PLAYER:FinishMove(move)
end

player_manager.RegisterClass("player_cc", PLAYER, "player_sandbox")