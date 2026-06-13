execute if entity @s[tag=entity.tick.ignore] run return 1
execute if entity @s[tag=entity.util.timestamp] run function main:core/entity/shared/util/timestamp
execute if entity @s[type=item_display] run return run function main:core/entity/item_display/tick
execute if entity @s[type=happy_ghast] run return run function main:core/entity/happy_ghast/tick
execute if entity @s[type=marker] run return run function main:core/entity/marker/tick
execute if entity @s[type=player] run return run function main:core/entity/player/tick