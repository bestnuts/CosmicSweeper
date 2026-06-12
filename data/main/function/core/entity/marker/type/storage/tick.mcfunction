function main:core/entity/marker/type/storage/data/load
scoreboard players operation #storage.id.matched V = @s id.matched
scoreboard players set #storage.boolean V 0
execute as @a if score @s id.player = #storage.id.matched V at @s run function main:core/entity/player/from_storage_tick
function main:core/entity/marker/type/storage/data/save
execute if score #storage.boolean V matches 0 run function main:core/entity/shared/util/kill