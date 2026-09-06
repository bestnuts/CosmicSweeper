execute store result score #math.x V run data get entity @s Pos.[0]
execute store result score #math.y V run data get entity @s Pos.[1]
execute store result score #math.z V run data get entity @s Pos.[2]
scoreboard players remove #math.y V 64
execute store result storage game main.instance.value.x int 1 run scoreboard players get #math.x V
execute store result storage game main.instance.value.y int 1 run scoreboard players get #math.y V
execute store result storage game main.instance.value.z int 1 run scoreboard players get #math.z V
function package:api/util/coord/load/run with storage game main.instance.value