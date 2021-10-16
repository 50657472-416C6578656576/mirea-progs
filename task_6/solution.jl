using HorizonSideRobots
include("../basics.jl")


md"""
        ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется ровно одна внутренняя перегородка в форме прямоугольника. 
            Робот - в произвольной клетке поля между внешней и внутренней перегородками.

        РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру внутренней перегородки поставлены маркеры.
"""


# Приводит робота к прямоугольнику
function find_the_square!(r)
    (M, N), (I, J) = r.field_size, position(r)
    for side in [Nord, Sud, West, Ost]
        x = move_till_border!(r, side)
        i, j = position(r)
        if (i == M || i == 1) || (j == N || j == 1)
            move_for!(r, opposite_side(side), x)
        else
            return (x, side)
        end
    end
    return false
end


# Возвращает сторону в которой есть барьер
function where_is_border(r)
    for side in [Nord, Sud, West, Ost]
        if isborder(r, side)
            return side
        end
    end
    return false
end


# Маркирует внешний периметр всего прямоугольника, рядом с которым находится
function mark_whole_daBorder!(r)
    border_side = where_is_border(r)
    side = HorizonSide((Int(border_side) + 1) % 4)

    start = position(r)
    
    putmarker!(r)
    move!(r, side)
    for i in 0:4
        while isborder(r, border_side)
            if position(r) == start
                return "going back"
            end
            putmarker!(r)
            move!(r, side)
        end

        border_side = opposite_side(side)
        side = next_side(side)
        
        move!(r, side)
    end
end


function solve_6!(r)
    r = SuperCheatRobot(r)
    x, side = find_the_square!(r)
    mark_whole_daBorder!(r)
    move_for!(r, opposite_side(side), x)
    show(r)
end