execute unless score @s id.player = @s id.player store result score @s id.player run scoreboard players add #id id.player 1
scoreboard players operation #id.player V = @s id.player
scoreboard players reset @s player.custom.leave_game
execute positioned 0 0 0 summon marker run function main:core/entity/player/handler/join/entity_setter