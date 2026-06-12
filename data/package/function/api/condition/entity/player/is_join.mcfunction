execute unless score @s id.player = @s id.player run return 1
execute if score @s player.custom.leave_game matches 1.. run return 1
return fail