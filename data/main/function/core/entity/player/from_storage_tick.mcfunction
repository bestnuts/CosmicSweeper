execute if function package:api/condition/entity/player/is_join run return 0
tag @s add this.origin.player
function main:core/entity/player/handler/data/init/all
function main:core/entity/player/handler/data/process/all

tag @s remove this.origin.player
tag @s remove player.offhand
tag @s remove player.leftclick
tag @s remove player.rightclick