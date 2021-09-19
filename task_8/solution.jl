using HorizonSideRobots
include("../basics.jl")


"""
            ДАНО: Робот - рядом с горизонтальной перегородкой (под ней), бесконечно продолжающейся в обе стороны, 
                    в которой имеется проход шириной в одну клетку.
            
            РЕЗУЛЬТАТ: Робот - в клетке под проходом
"""

# проверяет {x}-овую клетку в сторону {side} от места старта робота
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

    while true                                  # Робот двигается поочередно влево-вправо (с каждой итерацией проверяя на одну клетку с каждой стороны больше), пока не наткнется на выход
        for side in [Ost, West]
            if find_or_move!(r, side, count)
                return show(r)
            end
        end
        count += 1
    end
end