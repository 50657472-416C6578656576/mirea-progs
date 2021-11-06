using HorizonSideRobots

function try_move!(r::Robot,side::HorizonSide)::Bool
    ort_side = left(side)
    n=0
    while isborder(r,side)
        if !isborder(r,ort_side)
            move!(r,ort_side)
            n += 1
        else
            break
        end
    end
    if isborder(r,side)
        movements!(r,inverse(ort_side),n)
        return false
    end
    move!(r,side)
    while isborder(r,inverse(ort_side))
        move!(r,side)
    end
    movements!(r, inverse(ort_side), n)
    return true
end


function movements!(r::Robot, side)
    n=0
    while !isborder(r,side)
        move!(r,side)
        n += 1
    end
end

function movements!(r::Robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(r,side)
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))

#-------------------------------------------------------------------------

abstract type AbstractRobot end

import HorizonSideRobots: move!, isborder, putmarker!, ismarker, temperature

move!(r::AbstractRobot, side) = move!(get(r), side) 
isborder(r::AbstractRobot, side) = isborder(get(r), side)
putmarker!(r::AbstractRobot) = putmarker!(get(r))
ismarker(r::AbstractRobot) = ismarker(get(r))
temperature(r::AbstractRobot) = temperature(get(r))

# предполагается, что функция get() будет определена для каждого производного конкретного типа

# movements!(r::AbstractRobot, side) = movements!(get(r), side)
# movements!(r::AbstractRobot, side, num_steps::Integer) = movements!(get(r), side, num_steps)

function movements!(r::AbstractRobot, side)
    n=0
    while !isborder(r,side)
        move!(r,side)
        n += 1
    end
end

function movements!(r::AbstractRobot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(r,side)
    end
end
#-----------------------------------------------------

abstract type AbstractBorderRobot <: AbstractRobot end

function movements!(r::AbstractBorderRobot, side::HorizonSide)
    n=0
    while try_move!(r, side) # предполагается, что try_move! будет переопределяться для всех производных типов
        n+=1
    end
    return n
end

function movements!(r::AbstractBorderRobot, side::HorizonSide, n::Integer)
    for _ in 1:n
        try_move!(r, side) # как вариант - предполагается, что try_move! будет переопределяться для всех производных типов
    end
    return n
end

function try_move!(r::AbstractBorderRobot, side::HorizonSide)
    result = try_move!(get(r), side)
    if result == true
        action(r) # предполагается, что в каждом производном конткретном типе функция action определена
    end
    return result 
end




#-------------------------------------------------------
struct PutmarkerRobot <: AbstractRobot
    robot::Robot
end

get(r::PutmarkerRobot) = r.robot

function move!(r::PutmarkerRobot, side) 
    move!(r.robot, side)
    putmarker!(r)
end

#------------------------------------------------------

mutable struct CountmarkersRobot <: AbstractRobot
    robot::Robot
    count::Int
end

get(r::CountmarkersRobot) = r.robot

function move!(r::CountmarkersRobot, side)
    move!(r.robot, side) # если бы тут было так: move!(r, side), то это был бы рекурсивный вызов, котрорый здесь не уместен !!!
    # можно было бы ещё и так: move!(get(r), side), разницы в этом никакой нет
    if ismarker(r)
        r.count += 1
    end
end 
#----------------------------------

mutable struct CountmarkersBorderRobot <: AbstractBorderRobot
    robot::Robot
    count::Int
end

get(r::CountmarkersBorderRobot) = r.robot

function action(r::CountmarkersBorderRobot)
    if ismarker(r)
        r.count += 1
    end
end

#----------------

struct PutmarkersBorderRobot <: AbstractBorderRobot
    robot::Robot
end

get(r::PutmarkersBorderRobot) = r.robot

action(r::PutmarkersBorderRobot) = putmarker!(r)


# ===================== 3 часть занятия =============================

mutable struct Coord
    x::Int
    y::Int
end
Coord()=Coord(0,0)

function move!(coord::Coord, side::HorizonSide)
    if side==Nord
        coord.y += 1
    elseif side==Sud
        coord.y -= 1
    elseif side==Ost
        coord.x += 1
    else #if side==West
        coord.x -= 1
    end
end

get_coord(coord::Coord) = (coord.x, coord.y)

#----------------------------------------------

mutable struct CoordRobot <: AbstractRobot
    robot::Robot
    coord::Coord
end

CoordRobot(r)=CoordRobot(r, Coord())

get(robot::CoordRobot) = robot.robot

function move!(robot::CoordRobot, side::HorizonSide)
    move!(get(robot), side)
    move!(robot.coord, side)
end

get_coord(r::CoordRobot)=get_coord(r.coord)
#--------------------------------------------------

# Проектирование праметрического абстрактного типа

abstract type AbstractBorderRobot2{TypeRobot} <: AbstractRobot end
# тип AbstractBorderRobot - уже есть, он не параметрический

function movements!(r::AbstractBorderRobot2, side::HorizonSide)
    n=0
    while try_move!(r, side) # предполагается, что try_move! будет переопределяться для всех производных типов
        n+=1
    end
    return n
end

function movements!(r::AbstractBorderRobot2, side::HorizonSide, n::Integer)
    for _ in 1:n
        try_move!(r, side) # как вариант - предполагается, что try_move! будет переопределяться для всех производных типов
    end
    return n
end

function try_move!(r::AbstractBorderRobot2, side::HorizonSide)
    result = try_move!(get(r), side)
    if result == true
        action(r) # предполагается, что в каждом производном конткретном типе функция action определена
    end
    return result 
end

# Проектирование конкретного типа на базе абстрактного параметрического
struct CoordmarkersBorderRobot <: AbstractBorderRobot2{CoordRobot} # CoordRobot - ранее определенный тип
    robot::CoordRobot
    markers_coord::Vector{NTuple{2,Int}}
end

get(robot::CoordmarkersBorderRobot) = get(robot.robot)

function action(robot::CoordmarkersBorderRobot)
    if ismarker(robot)
        push!(robot.markers_coord, get_coord(robot))
    end
end

get_coord(r::CoordmarkersBorderRobot) = get_coord(r.robot)

#-------------------------------Дополнительно требуется определить:
get(r::Robot)=r