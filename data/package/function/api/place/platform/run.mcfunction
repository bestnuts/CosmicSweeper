summon happy_ghast ~ 60 ~ {Tags:["world.entity","entity.type.platform","new"],Silent:1b,Invulnerable:1b,NoAI:1b}
execute as @n[type=happy_ghast,tag=new] run function package:api/place/platform/allocate
return 1