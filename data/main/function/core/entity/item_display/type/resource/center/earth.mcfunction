execute store result score #math.x V run data get storage game main.instance.data.earth.translation.[0] 100
execute store result score #math.z V run data get storage game main.instance.data.earth.translation.[2] 100
execute store result score #math.dx V run data get entity @s data.transformation.translation.[0] 100
execute store result score #math.dz V run data get entity @s data.transformation.translation.[2] 100
scoreboard players operation #math.x V += #math.dx V
scoreboard players operation #math.z V += #math.dz V
execute store result entity @s transformation.translation.[0] float 0.01 run scoreboard players get #math.x V
execute store result entity @s transformation.translation.[2] float 0.01 run scoreboard players get #math.z V