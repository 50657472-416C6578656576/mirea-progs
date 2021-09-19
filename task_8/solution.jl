using HorizonSideRobots
include("../basics.jl")


"""
            ДАНО: Робот - рядом с горизонтальной перегородкой (под ней), бесконечно продолжающейся в обе стороны, 
                    в которой имеется проход шириной в одну клетку.
            
            РЕЗУЛЬТАТ: Робот - в клетке под проходом
"""

function find_or_move!(r, side, x)
    move_for!(r, side, x)
    if isborder(r, Nord) == false
        return true
    end
    move_for!(r, opposite_side(side), x)
    return false
end

function solve_8!(r)
    count = 1

    while true
        for side in [Ost, West]
            if find_or_move!(r, side, count)
                return show(r)
            end
        end
    end
end