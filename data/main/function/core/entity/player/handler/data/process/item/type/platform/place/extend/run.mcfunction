scoreboard players set #math.compare V 0
execute positioned ~ ~ ~-4.0 if entity @n[type=happy_ghast,tag=entity.type.platform,dx=0,dy=0,dz=0] run scoreboard players add #math.compare V 1
execute positioned ~ ~ ~4.0 if entity @n[type=happy_ghast,tag=entity.type.platform,dx=0,dy=0,dz=0] run scoreboard players add #math.compare V 1
execute positioned ~-4.0 ~ ~ if entity @n[type=happy_ghast,tag=entity.type.platform,dx=0,dy=0,dz=0] run scoreboard players add #math.compare V 1
execute positioned ~4.0 ~ ~ if entity @n[type=happy_ghast,tag=entity.type.platform,dx=0,dy=0,dz=0] run scoreboard players add #math.compare V 1
execute unless score #math.compare V matches 0 run return run function main:core/entity/player/handler/data/process/item/type/platform/place/extend/type/true
function main:core/entity/player/handler/data/process/item/type/platform/place/extend/type/false