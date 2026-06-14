execute store result score #gametime V run time query gametime
function main:core/global/generator/tick
execute as @e[type=item_display,tag=entity.type.sphere,limit=2] run function main:core/global/sphere/tick
scoreboard players set #global.dx V 0
scoreboard players set #global.dz V 0