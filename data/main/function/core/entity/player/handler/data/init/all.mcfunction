data modify storage game main.instance.player.item.components set from entity @s SelectedItem.components
execute store result score #storage.item.last_id V run data get storage game main.instance.storage.item.last_id
execute store result score #storage.item.id V store result storage game main.instance.storage.item.last_id int 1 run data get storage game main.instance.player.item.components.minecraft:custom_data.id
scoreboard players operation #origin.id.player V = @s id.player
scoreboard players set #storage.boolean V 1