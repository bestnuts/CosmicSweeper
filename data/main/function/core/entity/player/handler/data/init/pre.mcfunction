function main:core/entity/player/handler/data/init/item/data/run
function main:core/entity/player/handler/data/init/item/swap/run
scoreboard players operation #origin.id.player V = @s id.player
scoreboard players set #storage.boolean V 1
title @s subtitle ""