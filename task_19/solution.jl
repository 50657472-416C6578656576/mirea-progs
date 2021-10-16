using HorizonSideRobots
include("../basics.jl")


md"""
            task_9 c перегородками
"""


"""Двигает робота на {x} шагов или останавливается на маркере"""
function super_move_for_x_or_find_marker!(r, side, x)
    for _ in 1:x
        super_move!(r, side)
        if ismarker(r)
            return false
        end
    end
    return true
end


"""Двигает робота по спирали пока он не найдет маркер"""
function super_radial_search!(r)
    x = 1
    count = 0
    side = Nord

    while super_move_for_x_or_find_marker!(r, side, x)
        count += 1
        side = next_side(side)
        if count % 2 == 0
            x += 1
        end
    end

end


 """Решение задачи 19"""
 function solve_19!(r)
    super_radial_search!(r)

    show(r)
end