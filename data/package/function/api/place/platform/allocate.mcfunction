tag @s remove new
data merge entity @s {data:{platform:{coordinate:[0,0]}}}
execute store result entity @s data.platform.coordinate.[0] int 1 run data get entity @s Pos.[0]
execute store result entity @s data.platform.coordinate.[1] int 1 run data get entity @s Pos.[2]