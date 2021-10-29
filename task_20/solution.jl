using HorizonSideRobots
include("../basics.jl")


md"""
# Посчитать число всех горизонтальных прямолинейных перегородок (вертикальных - нет)
"""

"""
Считает кол-во горизонтальных перегородок в строке, двигаясь в направлении {side}
"""
function count_borders_inline(r, side)
    counter = 0
    is_under_border = false
    while !isborder(r, side)
        if !is_under_border && isborder(r, Nord)
            counter+=1
            is_under_border = true
        elseif !isborder(r, Nord)
            is_under_border = false
        end
        move!(r, side)
    end
    return counter
end


"""Решение задачи 20"""
function solve_20!(r)
    path = move_to_corner!(r, West, Sud)

    counter = 0    
    while !isborder(r, Nord)
        counter += count_borders_inline(r, Ost)
        carefull_move!(r, Nord)
        if !isborder(r, Nord)
            counter += count_borders_inline(r, West)
            carefull_move!(r, Nord)
        end
    end
    
    move_to_corner!(r, West, Sud)
    move_back_from_corner!(r, West, Sud, reverse(path))
    return counter     
end