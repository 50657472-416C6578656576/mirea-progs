include("practic_8.jl")

"""

"""
function  shuttle!(condition::Function, robot, side)
    n=0 # число шагов от начального положения
    while condition() == false # condition(robot) - как вариант
        n += 1
        movements!(() -> !condition(), robot, side, n)
        side = inverse(side)
    end
end


"""
movements!(condition::Function, robot::AbstractBorderRobot2, side, num_steps) 

-- делает не более чем num_steps шагов в заданном направлении, пока выпоняется условие condition()==true", 
и возвращает число сделанных шагов

-- condition - функция без аргументов, возвращающая логическое значение
"""
function movements!(condition::Function, robot::AbstractBorderRobot2, side, max_num_steps)
    n = 0
    while n < max_num_steps && condition()
        try_move!(robot, side) # try_move! - позволяет обходить прямоугольные перегородки (если они есть), как бы по прямой
        n += 1
    end  
    return n 
end

struct BorderRobot <: AbstractBorderRobot2{Robot}
    robot::Robot
end

get(r::BorderRobot) = r.robot
action!(r::BorderRobot) = nothing


#= Примеры вызова вункции shuttle:

julia> include("practic_9.jl")
movements!

julia> shuttle!(() -> ismarker(r), r, Ost) # - робот ходит влево-вправо пока не наткнется на маркер

julia> shuttle!(() -> isborder(r,Nord), r, Ost) # - робот ходит влево-вправо пока не наткнется на перегородку сверху

julia> shuttle!(() -> isborder(r,Ost) || isborder(r,West), r, Ost) # - робот ходит влево-вправо пока не наткнется на перегородку по ходу движения

julia> 

julia> border_robot = BorderRobot(r);

julia> shuttle!(() -> ismarker(border_robot), border_robot, Ost) # - робот ходит влево-вправо, обходя внутренние перегородки, пока не наткнется на маркер

julia>
=#

function spiral!(condition::Function, robot, side=Nord)
    n=1
    while condition() == false
        movements!(() -> !condition(), robot, side, n)       
        side = left(side)
        movements!(() -> !condition(), robot, side, n)
        side = left(side)
        n += 1
    end
end