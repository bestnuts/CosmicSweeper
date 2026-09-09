execute store result score #gametime V run time query gametime
function main:core/global/generator/tick
execute as @n[type=happy_ghast,tag=entity.type.platform,x=0,y=60,z=0,distance=..0.001] run function main:core/global/center/tick
execute as @e[type=item_display,tag=entity.type.sphere,limit=2] run function main:core/global/sphere/tick