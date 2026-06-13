tag @s remove new
data merge entity @s {data:{platform:{coordinate:[0,0]}}}

execute store result storage game main.instance.math.a float 1 run data get entity @s Pos.[2] 10000
execute store result storage game main.instance.math.b float -1 run data get entity @s Pos.[0] 10000
function package:api/math/arctan/run
execute store result score #math.arctan V run data get storage game main.instance.math.result 1
scoreboard players operation #math.arctan V %= #180 C
execute if function package:api/place/platform/angle/abs45 run return 1
execute if score #math.arctan V matches -1..1 run scoreboard players set #math.arctan V 0
execute if score #math.arctan V matches 89..91 run scoreboard players set #math.arctan V 90

execute store result storage game main.instance.math.degree float 1 run scoreboard players get #math.arctan V
function package:api/math/sincos/run with storage game main.instance.math

execute store result score #math.sin V run data get storage game main.instance.math.result.[0] 10000
execute store result score #math.cos V run data get storage game main.instance.math.result.[1] 10000

execute if score #math.sin V matches ..-1 run scoreboard players operation #math.sin V *= #-1 C
execute if score #math.cos V matches ..-1 run scoreboard players operation #math.cos V *= #-1 C

scoreboard players operation #math.max V = #math.sin V
scoreboard players operation #math.max V > #math.cos V

execute store result score #math.x V run data get entity @s Pos.[0] 10000
execute store result score #math.z V run data get entity @s Pos.[2] 10000

execute store result entity @s data.platform.coordinate.[0] int 1 run scoreboard players operation #math.x V /= #math.max V
execute store result entity @s data.platform.coordinate.[1] int 1 run scoreboard players operation #math.z V /= #math.max V