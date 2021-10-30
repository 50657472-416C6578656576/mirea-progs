using HorizonSideRobots
include("../basics.jl")


md"""
        # Подсчитать число и вертикальных и горизонтальных прямолинейных перегородок (прямоугольных - нет)
"""

"""
Считает кол-во горизонтальных перегородок со стороны {border_side} в строке/столбце, двигаясь в направлении {side}
"""
function count_borders_inline_at!(r, side, border_side)
    counter = 0
    is_under_border = false
    cond = true
    while cond
        if !is_under_border && isborder(r, border_side)
            counter+=1
            is_under_border = true
        elseif !isborder(r, border_side)
            is_under_border = false
        end
        cond = try_move!(r, side)
    end
    return counter
end


"""
Считает количество линейных перегородок в стороне {border_side}
"""
function count_linear_borders_at!(r, border_side)
    counter = 0    
    while !isborder(r, border_side)
        counter += count_borders_inline_at!(r, next_side(border_side), border_side)
        carefull_move!(r, border_side)
        if !isborder(r, border_side)
            counter += count_borders_inline_at!(r, previous_side(border_side), border_side)
            carefull_move!(r, border_side)
        end
    end
    return counter
end


"""Решение задачи 21"""
function solve_21!(r)
    path = move_to_corner!(r, West, Sud)

    horizontal_counter = count_linear_borders_at!(r, Nord)
    move_to_corner!(r, West, Nord)
    vertical_counter = count_linear_borders_at!(r, Ost)
    
    move_to_corner!(r, West, Sud)
    move_back_from_corner!(r, West, Sud, reverse(path))

    return horizontal_counter + vertical_counter 
end