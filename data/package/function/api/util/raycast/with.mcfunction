data modify storage game main.instance.raycast set value { \
    run:"function package:api/call/empty", \
    end:"return 1", \
    condition:"package:api/condition/shared/always_false", \
    do: 100, \
}
$data modify storage game main.instance.raycast merge value $(with)