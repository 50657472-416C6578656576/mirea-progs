using Markdown
# using HorizonSideRobots
#########################################################
md"""
    #Базовые функции, связанные с передвижением робота
"""
#########################################################
"""
Делает попытку шагнуть в сторону {side} и возвращает {false} при неудачной попытке, иначе {true}
"""
function carefull_move!(r::Robot, side::HorizonSide)
    if !isborder(r, side)
        move!(r, side)
        return true
    else
        return false
    end
end


"""
Двигает робота до перегородки в сторону {side} и возвращает кол-во шагов {steps}
"""
function move_till_border!(r, side::HorizonSide)
    steps = 0
    while isborder(r, side) == 0
        move!(r, side)
        steps += 1
    end
    return steps
end


"""
Двигает робота на {x} клеток в сторону {side}
"""
function move_for!(r, side::HorizonSide, x::Int)
    for _ in 1:x
        if !isborder(r, side)
            move!(r, side)
        else
            return false
        end
    end
    return true
end


"""
Перемещает робота в угол ({side_1}, {side_2}) и возвращает проделанный при этом путь {path}
"""
function move_to_corner!(r, side_1::HorizonSide, side_2::HorizonSide,)
    path = []
    while !isborder(r, side_1) || !isborder(r, side_2)
        push!(path, move_till_border!(r, side_1))
        push!(path, move_till_border!(r, side_2))
    end
    return path
end

"""
Перемещает робота из угла в стартовую позицию по {back_path}
"""
function move_back_from_corner!(r, side_1, side_2, back_path)
    side_1 = opposite_side(side_1)
    side_2 = opposite_side(side_2)
    for i in 1:2:size(back_path)[1]
        move_for!(r, side_2, back_path[i])
        move_for!(r, side_1, back_path[i+1])
    end
end


"""
Двигает робота на клетку (x, y)
"""
function move_to!(r::Robot, x, y)
    move_till_border!(r, West)
    move_till_border!(r, Sud)
    for _ in 1:y-1
        move!(r, Nord)
    end
    for _ in 1:x-1
        move!(r, Ost)
    end
end


"""Возвращает противоположную {side} сторону."""
opposite_side(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)

"""Возвращает следующую сторону от {side} по часовой стрелке"""
next_side(side::HorizonSide) = opposite_side(HorizonSide((Int(side) + 1) % 4))

"""Возвращает следующую сторону от {side} против часовой стрелке"""
previous_side(side::HorizonSide) = HorizonSide((Int(side) + 1) % 4)


"""Возвращает сторону, в которой нет перегородки"""
function get_no_border_side(r)
    for side in [Nord, Ost, Sud, West]
        if !isborder(r, side)
            return side
        end
    end
    return false
end

"""Возвращает координаты клетки сверху/снизу/слева/справа от переданной"""
function side_to_i_j(side::HorizonSide, cell)
    i, j = cell
    if side == Nord
        return (i - 1, j)
    elseif side == Sud
        return (i + 1, j)
    elseif side == West
        return (i, j - 1)
    elseif side == Ost
        return (i, j + 1)
    end
end


"""Поиск в глубину, робот проходится по всем клеткам и маркирует переданные в {cells}"""
function mark_some_cells_with_dfs!(r, visited, cell, side, cells)
    is_not_at_start = side != false

    if is_not_at_start
        cheker = isborder(r, side) == false
    else
        cheker = true
    end
    
    if (cell in visited) == false && cheker && length(cells) > 0
        if is_not_at_start
            move!(r, side)
        end
        push!(visited, cell)

        if cell in cells
            putmarker!(r)
            println("!Marker at ", cell)
            filter!(el -> el ≠ cell, cells)
        end

        for tempSide in [Nord, Ost, Sud, West]
            if mark_some_cells_with_dfs!(r, visited, side_to_i_j(tempSide, cell), tempSide, cells)
                move!(r, opposite_side(tempSide))
            end
        end

        return true

    else
        return false
    end
end


"""Проверяет {x}-овую клетку в сторону {side} от места старта робота на наличие выхода в стороне {border_side}"""
function find_or_move!(r, side, x, border_side)
    move_for!(r, side, x)
    if isborder(r, border_side) == false
        return true
    end
    move_for!(r, opposite_side(side), x)
    return false
end


"""Перемещает робота к выходу со стороны {border_side}"""
function escape_find(r, border_side)
    count = 1
    sides = (next_side(border_side), opposite_side(next_side(border_side)))
    while true                                  # Робот двигается поочередно влево-вправо (с каждой итерацией проверяя на одну клетку с каждой стороны больше), пока не наткнется на выход
        for side in sides
            if find_or_move!(r, side, count, border_side)
                return (count, side)
            end
        end
        count += 1
    end
    return false
end


"""Обходит любую одинарную прямоугольную перегородку в стороне {side}"""
function try_move!(r::Robot, side::HorizonSide)
    if isborder(r, side)
        n = 0;
        ort_side = next_side(side)
        while isborder(r, side)
            if !isborder(r, ort_side)
                move!(r, ort_side)
                n+=1
            else
                move_for!(r, opposite_side(ort_side), n)
                return false
            end
        end

        move!(r, side)
        while isborder(r, opposite_side(ort_side))
            move!(r, side)
        end
        move_for!(r, opposite_side(ort_side), n)
        return true
    else
        move!(r, side)
        return true
    end
end


"""Посещает все доступные клетки и возвращет {ans}, имеющий значение соответствующее {[i_min, i_max, j_min, j_max]}"""
function visit_all_cells!(r, side=Nord, cell=(0, 0), visited=Set(), ans=[0, 0, 0, 0,])

    if (cell in visited) == false && !isborder(r, side)
        move!(r, side)
        push!(visited, cell)

        ans[1] = min(cell[1], ans[1])
        ans[2] = max(cell[1], ans[2])
        ans[3] = min(cell[2], ans[3])
        ans[4] = max(cell[2], ans[4])

        for tempSide in [Nord, Ost, Sud, West]
            tempAns = visit_all_cells!(r, tempSide, side_to_i_j(tempSide, cell), visited, ans)
            if tempAns != false
                move!(r, opposite_side(tempSide))
                ans = tempAns
            end
        end
        return ans
    else
        return false
    end
end

"""Возвращает размер поля {(M, N)} и текущую позицию робота {r} {(i, j)}"""
function get_field_size_and_position!(r)
    side = get_no_border_side(r)
    if side == false
        return (1, 1), (1, 1)
    end
    ans = visit_all_cells!(r, side, side_to_i_j(side, (0,0)))
    move!(r, opposite_side(side))
    M = ans[2]-ans[1]+1
    N = ans[4]-ans[3]+1
    return (M, N), (M-ans[2], N-ans[4])
end


#########################################################
md"""
    #Базовые функции, связанные с базовыми типами данных, и сами типы и связанные структуры
"""
#########################################################

import HorizonSideRobots
"""Переопределение стандартных функций робота для стандартного робота {::Robot}"""
move!(robot::Robot, side::HorizonSide) = HorizonSideRobots.move!(robot, side)
isborder(robot::Robot,  side::HorizonSide) = HorizonSideRobots.isborder(robot, side)
putmarker!(robot::Robot) = HorizonSideRobots.putmarker!(robot)
ismarker(robot::Robot) = HorizonSideRobots.ismarker(robot)
temperature(robot::Robot) = HorizonSideRobots.temperature(robot)
show(robot::Robot) = HorizonSideRobots.show(robot)
show!(robot::Robot) = HorizonSideRobots.show!(robot)

#---------------------------------#

"""Структура координат {i, j}, где i - номер строки поля, а {j} - номер столбца поля (для робота)"""
mutable struct Coordinates
    i::Integer
    j::Integer

    Coordinates() = new(0,0)
    Coordinates(i::Integer,j::Integer) = new(i,j)
    Coordinates((i, j)::Tuple{Int64, Int64}) = new(i, j)
end

"""Изменяет координаты соответственно перемещению робота"""
function move!(coordinates::Coordinates, side::HorizonSide)
    if side==Nord
        coordinates.i -= 1
    elseif side==Sud
        coordinates.i += 1
    elseif side==Ost
        coordinates.j += 1
    else
        coordinates.j -= 1
    end
end

"""Обновляет значения координат соответственно на {i} и {j}"""
function update!(coordinates::Coordinates, (i, j)::Tuple{Int64, Int64})
    coordinates.i = i
    coordinates.j = j
end

#---------------------------------#

"""Базовый абстрактный робот"""
abstract type AbstractRobot end
"""Определение стандартных функций робота для робота {::AbstractRobot}"""
move!(robot::AbstractRobot, side::HorizonSide) = HorizonSideRobots.move!(get(robot), side)
isborder(robot::AbstractRobot,  side::HorizonSide) = HorizonSideRobots.isborder(get(robot), side)
putmarker!(robot::AbstractRobot) = HorizonSideRobots.putmarker!(get(robot))
ismarker(robot::AbstractRobot) = HorizonSideRobots.ismarker(get(robot))
temperature(robot::AbstractRobot) = HorizonSideRobots.temperature(get(robot))
show(robot::AbstractRobot) = HorizonSideRobots.show(get(robot))
show!(robot::AbstractRobot) = HorizonSideRobots.show!(get(robot))
"""Возвращает {nothing} для робота типа {AbstractRobot}"""
get(robot::AbstractRobot) = nothing


"""Двигает робота змейкой по всему полю"""
function move_as_snake!(r::AbstractRobot, side=Ost)
    do_movements!(r, side) #этаче, должно быть {do_movements} (которая еще и переопределяется для разных типов в зависимости от задач получается(?))
    while isborder(r, Nord)
        move!(r, Nord)
        side = opposite_side(side)
        do_movements!(r, side)
    end
end

#---------------------------------#

"""Абстрактный тип робота, обходящего перегородки"""
abstract type AbstractBorderRobot <: AbstractRobot end


"""Переопределенная {move_till_border!} для {AbstractBorderRobot}:
                        + Использует {try_move!}, что позволяет обходить одиночные перегородки по пути
"""
function move_till_border!(r::AbstractBorderRobot, side::HorizonSide)
    counter = 0
    
    while try_move!(get(r), side)
        counter += 1
    end
    
    return n
end

#---------------------------------#

"""Маркирующий робот от {AbstractBorderRobot}"""
struct PutMarkersBorderRobot <: AbstractBorderRobot
    robot::Robot
end

"""Возвращает ссылку на робота {::Robot} для робота типа {PutMarkersBorderRobot}"""
get(r::PutMarkersBorderRobot) = r.robot

"""
Переопределенная {try_move!}:
                        + Ставит маркеры
"""
function try_move!(r::PutMarkersBorderRobot, side::HorizonSide)
    try_move!(get(r), side)
    putmarker!(r)
end

"""Конструктор {PutMarkersBorderRobot}"""
function PutMarkersBorderRobot(r::Robot)
    putmarker!(r)
    new(r)
end

"""Маркирует все поле используя {move_as_snake!}"""
function mark_field(r::Robot)
    # утв: робот в ЮЗ углу
    r = PutMarkersBorderRobot(r)
    move_as_snake!(r)
end

#---------------------------------#

"""Тип робота, использующего глобальные координаты"""
struct SuperCheatRobot <: AbstractRobot 
    robot::Robot
    position::Coordinates
    field_size::Tuple{Int64, Int64}


    SuperCheatRobot(r, (i, j), (M, N)) = new(r, Coordinates(i, j), (M, N))
    function SuperCheatRobot(r)
        (M, N), (i, j) = get_field_size_and_position!(r)
        return SuperCheatRobot(r, (i, j), (M, N))
    end
end

"""Возвращает ссылку на робота {::Robot} для робота типа {SuperCheatRobot}"""
get(robot::SuperCheatRobot) = robot.robot

"""Обновляет данные о текущей позиции {r.position} робота {r} (происходит вызов {get_field_size_and_position}!)"""
function update!(r::SuperCheatRobot)
    update!(r.position, get_field_size_and_position!(r.robot)[2])
end

"""Устанавливает данные о текущей позиции {r.position} робота {r} равными {(i, j)}"""
function setPositionTo!(r::SuperCheatRobot, (i, j))
    update!(r.position, (i,j))
end

"""
Переопределенная {move!(::Robot)}:
                        + Изменяет текущие координаты робота {r} согласно перемещению
"""
function move!(robot::SuperCheatRobot, side::HorizonSide)
    move!(robot.robot, side)
    move!(robot.position, side)
end

"""Возвращает текущую позицию робота {r.position} в виде {(i, j)}"""
position(r) = (r.position.i, r.position.j)