function main:core/global/sphere/translation
execute if entity @s[tag=sphere.earth] run data modify storage game main.instance.data.earth.translation set from entity @s transformation.translation
execute if entity @s[tag=sphere.sun] run data modify storage game main.instance.data.sun.translation set from entity @s transformation.translation