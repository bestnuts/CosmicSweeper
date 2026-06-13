data modify storage game main.instance.player.item.components set from entity @s SelectedItem.components
execute store result score #storage.item.last_id V run data get storage game main.instance.storage.item.last.id
execute unless items entity @s weapon.mainhand * run data modify storage game main.instance.player.item.components.minecraft:custom_data.id set value 0
execute store result score #storage.item.id V store result storage game main.instance.storage.item.last.id int 1 run data get storage game main.instance.player.item.components.minecraft:custom_data.id