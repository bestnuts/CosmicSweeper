function main:core/global/tick

execute as @e[type=#package:shared_tick] at @s run function main:core/entity/shared/tick

#data remove storage game main.instance