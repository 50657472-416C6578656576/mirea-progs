using HorizonSideRobots
include("../basics.jl")


"""
            ДАНО: Где-то на неограниченном со всех сторон поле и без внутренних перегородок имеется единственный маркер. 
                            Робот - в произвольной клетке поля.
            
            РЕЗУЛЬТАТ: Робот - в клетке с тем маркером.
"""


# Двигает робота на {x} шагов или останавливается на маркере
function move_for_x_or_find_marker!(r, side, x)
    for _ in 1:x
        move!(r, side)
        if ismarker(r)
            return false
        end
    end
    return true
end


# Двигает робота по спирали пока он не найдет маркер
function radial_search!(r)
    x = 1
    count = 0
    side = Nord

    while move_for_x_or_find_marker!(r, side, x)
        count += 1
        side = next_side(side)
        if count % 2 == 0
            x += 1
        end
    end
end


function solve_9!(r)
    radial_search!(r)

    show(r)
end