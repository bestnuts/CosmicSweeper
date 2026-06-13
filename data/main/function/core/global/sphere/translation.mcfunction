execute store result score #math.x V run data get entity @s transformation.translation.[0] 100
execute store result score #math.z V run data get entity @s transformation.translation.[2] 100
scoreboard players operation #math.x V += #global.dx V
scoreboard players operation #math.z V += #global.dz V
execute store result entity @s transformation.translation.[0] float 0.01 run scoreboard players get #math.x V
execute store result entity @s transformation.translation.[2] float 0.01 run scoreboard players get #math.z V