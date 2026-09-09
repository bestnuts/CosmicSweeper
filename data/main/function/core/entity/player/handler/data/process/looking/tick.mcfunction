execute if items entity @s weapon.mainhand * run return fail
execute on vehicle run return fail
data remove storage game main.instance.interaction.data
execute anchored eyes positioned ^ ^ ^ run function #package:util/raycast {with:{condition:"main:core/entity/player/handler/data/process/looking/raycast/condition",do:12}}
execute if data storage game main.instance.interaction.data run function main:core/entity/player/handler/data/process/looking/process