execute store result score #math.x V run data get entity @s Pos.[0] 0.25
execute store result score #math.z V run data get entity @s Pos.[2] 0.25
execute store result storage game main.instance.value.x double 4 run scoreboard players get #math.x V
execute store result storage game main.instance.value.z double 4 run scoreboard players get #math.z V
kill @s