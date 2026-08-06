tag @s remove new
execute store result entity @s data.resource.value.degree float 1 run random value -240..-220
execute store result entity @s data.resource.constant.degree float -0.01 run random value 1..5
execute store result entity @s data.resource.constant.radius float 1 run random value -480..-446
execute store result entity @s Pos.[1] float 1 run random value 64..76
function main:core/entity/item_display/type/resource/center/apply
data modify entity @s item set value {id:"minecraft:leather_horse_armor",count:1,components:{"minecraft:item_model":"world:scrap"}}