tag @s add entity.type.storage
scoreboard players operation @s id.matched = #id id.player
function package:api/database/entity/storage/setup
data modify entity @s data set from storage game main.instance.database