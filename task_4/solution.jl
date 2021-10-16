using HorizonSideRobots
include("../basics.jl")


md"""
    ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля

    РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так: нижний ряд - полностью, следующий - весь,
                за исключением одной последней клетки на Востоке,следующий - за исключением двух последних клеток на Востоке, и т.д.
"""

"""Двигается в переданную сторону до границы и возвращает пройденное расстояние"""
function moveNcount_to_border!(r, side)
    cnt = 1
    while isborder(r, side) == 0
        move!(r, side)
        cnt += 1
    end
    return cnt
end
move_to_corner_and_get_start!(r) = (moveNcount_to_border!(r, West), moveNcount_to_border!(r, Sud))  # Двигает робота в начальный угол и возвращает координаты страта

"""Двигаться на {steps} шагов или до "упора" в сторону {side}"""
function move_for_x!(r, side::HorizonSide, steps::Int)
    for _ in 1:steps
        if isborder(r, side)
            return false
        end
        move!(r, side)
        putmarker!(r)        
    end
    return true
end

"""Двигает робота на {steps} клеток вверх, возвращается назад и двигается направо на одну клетку, если может."""
function do_movements!(r, steps::Int)
    move_for_x!(r, Nord, steps)
    move_for_x!(r, Sud, steps)
    if isborder(r, Ost) == 0
        move!(r, Ost)
        return true
    else
        return false
    end
end


 """Решение задачи 4"""
 function solve_problem_4!(r)
    x, y = move_to_corner_and_get_start!(r)
    i = 0
    while do_movements!(r, i)
        i += 1
    end
    while ismarker(r)
        move!(r, West)
    end
    putmarker!(r)
    move_to!(r, x, y)
    show(r)
end
