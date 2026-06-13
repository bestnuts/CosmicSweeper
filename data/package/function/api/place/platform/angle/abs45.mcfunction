scoreboard players operation #math.compare V = #math.arctan V
scoreboard players operation #math.compare V %= #45 C
execute unless score #math.compare V matches 0 unless score #math.compare V matches 44..46 unless score #math.compare V matches -46..-44 run return fail
execute store result entity @s data.platform.coordinate.[0] int 1 run data get entity @s Pos.[0]
execute store result entity @s data.platform.coordinate.[1] int 1 run data get entity @s Pos.[2]
return 1