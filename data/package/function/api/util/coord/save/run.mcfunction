execute store result storage game main.instance.value.x int 1 run data get entity @s transformation.translation.[0]
execute store result storage game main.instance.value.y int 1 run data get entity @s transformation.translation.[1]
execute store result storage game main.instance.value.z int 1 run data get entity @s transformation.translation.[2]
data modify storage game main.instance.value.type set value "id.resource"
function package:api/util/coord/save/generation with storage game main.instance.value