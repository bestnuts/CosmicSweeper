execute store result storage game main.instance.value.degree float 1 run data get entity @s Rotation.[0]
function package:api/math/sincos/run with storage game main.instance.value
execute store result score #math.sin V run data get storage game main.instance.math.result.[0] -100
execute store result score #math.cos V run data get storage game main.instance.math.result.[1] 100

execute as @n[type=happy_ghast,tag=entity.type.platform,x=0,y=60,z=0,distance=..0.001] run function main:core/entity/player/handler/data/process/drive/load_center_data
execute if predicate package:player/input/forward run function main:core/entity/player/handler/data/process/drive/input/forward
execute if predicate package:player/input/backward run function main:core/entity/player/handler/data/process/drive/input/backward
execute if predicate package:player/input/left run function main:core/entity/player/handler/data/process/drive/input/left
execute if predicate package:player/input/right run function main:core/entity/player/handler/data/process/drive/input/right
execute as @n[type=happy_ghast,tag=entity.type.platform,x=0,y=60,z=0,distance=..0.001] run function main:core/entity/player/handler/data/process/drive/save_center_data