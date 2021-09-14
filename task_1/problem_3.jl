using HorizonSideRobots
include("../basics.jl")


"""
    ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля

    РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы
"""

# Двигается в переданную сторону до границы и возвращает пройденное расстояние
function moveNcount_to_border!(r, side)
    cnt = 1
    while isborder(r, side) == 0
        move!(r, side)
        cnt += 1
    end
    return cnt
end
move_to_corner_and_get_start!(r) = (moveNcount_to_border!(r, West), moveNcount_to_border!(r, Sud))  # Двигает робота в начальный угол и возвращает координаты страта

opposite_side(side) = HorizonSide((Int(side) + 2) % 4)     # Возвращает противоположную передаваемой сторону.

# Рекурсивно двигает робота по красивой спирали, по пути маркирую клетки
function moveNfill(r, side)
    is_actual = false
    while isborder(r, side) == 0
        putmarker!(r)
        move!(r, side)
        if ismarker(r) == 1
            move!(r, opposite_side(side))
            break
        end
        is_actual = true
    end
    if is_actual == false
        return false
    end
    return moveNfill(r, HorizonSide((Int(side)+1)%4))
end

function solve_problem_3!(r)
    x, y = move_to_corner_and_get_start!(r)
    println(x, " ", y)
    moveNfill(r, Ost)
    move_to!(r, x, y)
    show(r)
end