function package:api/util/coord/save/remove with entity @s data.coord
$execute store result storage game main.data.coord."$(x).$(y).$(z)".id int 1 run scoreboard players get @s $(type)
$data modify entity @s data.coord.delta set value "$(x).$(y).$(z)"