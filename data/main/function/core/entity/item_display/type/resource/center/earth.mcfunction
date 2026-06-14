execute store result score #math.degree V run data get entity @s data.resource.value.degree 1000
execute store result score #math.temp0 V run data get entity @s data.resource.constant.degree 1000
scoreboard players operation #math.degree V += #math.temp0 V
execute if score #math.degree V matches 180001.. run scoreboard players remove #math.degree V 360000
execute if score #math.degree V matches ..-180001 run scoreboard players add #math.degree V 360000
execute store result entity @s data.resource.value.degree float 0.001 run scoreboard players get #math.degree V

function package:api/math/sincos/run with entity @s data.resource.value

execute store result score #math.x V run data get storage game main.instance.data.earth.translation.[0] 100
execute store result score #math.z V run data get storage game main.instance.data.earth.translation.[2] 100
execute store result score #math.dx V run data get entity @s data.resource.constant.radius 100
execute store result score #math.dz V run data get entity @s data.resource.constant.radius 100
scoreboard players operation #math.x V += #math.dx V
scoreboard players operation #math.z V += #math.dz V

execute store result score #math.sin V run data get storage game main.instance.math.result.[0] -10000
execute store result score #math.cos V run data get storage game main.instance.math.result.[1] 10000

execute store result entity @s transformation.translation.[0] float 0.000001 run scoreboard players operation #math.x V *= #math.cos V
execute store result entity @s transformation.translation.[2] float 0.000001 run scoreboard players operation #math.z V *= #math.sin V