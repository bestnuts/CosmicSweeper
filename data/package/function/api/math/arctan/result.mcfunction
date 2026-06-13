$execute positioned 0.0 0.0 0.0 facing $(a) 0.0 $(b) run tp @s 0.0 0.0 0.0 ~ ~
data modify storage game main.instance.math.result set value 0f
execute store result storage game main.instance.math.result float 1 run data get entity @s Rotation.[0]
kill @s