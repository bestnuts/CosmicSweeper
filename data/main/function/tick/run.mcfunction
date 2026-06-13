execute store result score #gametime V run time query gametime

execute as @e[type=#package:shared_tick] at @s run function main:core/entity/shared/tick
execute positioned 0.0 60.0 0.0 as @e[type=happy_ghast,sort=nearest] at @s run function main:core/entity/happy_ghast/tick

#data remove storage game main.instance