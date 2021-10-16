include("./basics.jl")

move!(robot::Robot, side::HorizonSide) = HorizonSideRobots.move!(robot, side)
isborder(robot::Robot,  side::HorizonSide) = HorizonSideRobots.isborder(robot, side)
putmarker!(robot::Robot) = HorizonSideRobots.putmarker!(robot)
ismarker(robot::Robot) = HorizonSideRobots.ismarker(robot)
temperature(robot::Robot) = HorizonSideRobots.temperature(robot)



mutable struct Coordinates
    i::Integer
    j::Integer
    Coordinates() = new(0,0) # - такой конструктор определен для удобства использования
    Coordinates(i::Integer,j::Integer) = new(i,j)
end


#########################################################
# Базовый абстрактный робот
#########################################################

abstract type AbstractRobot end

import HorizonSideRobots

move!(robot::AbstractRobot, side::HorizonSide) = HorizonSideRobots.move!(get(robot), side)
isborder(robot::AbstractRobot,  side::HorizonSide) = HorizonSideRobots.isborder(get(robot), side)
putmarker!(robot::AbstractRobot) = HorizonSideRobots.putmarker!(get(robot))
ismarker(robot::AbstractRobot) = HorizonSideRobots.ismarker(get(robot))
temperature(robot::AbstractRobot) = HorizonSideRobots.temperature(get(robot))
get(robot::AbstractRobot) = nothing


"""
двигает робота змейкой
"""
function move_as_snake!(r::AbstractRobot, side=Ost)
    do_movements!(r, side) #этаче, должно быть {do_movements} (которая еще и переопределяется для разных типов в зависимости от задач получается(?))
    while isborder(r, Nord)
        move!(r, Nord)
        side = opposite_side(side)
        do_movements!(r, side)
    end
end

#--------------------------------------------------------

abstract type AbstractBorderRobot <: AbstractRobot end


"""
"""
function try_move!(r::Robot, side::HorizonSide)
    n = 0;
    ort_side = next_side(side)
    while isborder(r, side)
        if !isborder(r, ort_side)
            move!(r, ort_side)
            n+=1
        else
            return false
        end
    end

    move!(r, side)
    while isborder(r, opposite_side(next_side))
        move!(r, side)
    end
    move_for!(r, opposite_side(next_side), n)
    return true
end


"""
"""
function move_till_border!(r::AbstractBorderRobot, side::HorizonSide)
    counter = 0
    
    while try_move!(get(r), side)
        counter += 1
    end
    
    return n
end


"""
Маркирующий робот
"""
struct PutMarkersBorderRobot <: AbstractBorderRobot
    robot::Robot
end
get(r::PutMarkersBorderRobot) = r.robot

"""
Переопределенная {try_move!}:
                    + Ставит маркеры
"""
function try_move!(r::PutMarkersBorderRobot, side::HorizonSide)
    try_move!(get(r), side)
    putmarker!(r)
end


"""
Конструктор
"""
function PutMarkersBorderRobot(r::Robot)
    putmarker!(r)
    new(r)
end


function mark_field(r::Robot)
    # утв: робот в ЮЗ углу
    r = PutMarkersBorderRobot(r)
    move_as_snake!(r)
end