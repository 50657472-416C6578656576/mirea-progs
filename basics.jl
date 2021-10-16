# using HorizonSideRobots
"""
Делает попытку шагнуть в сторону {side} и возвращает {false} при неудачной попытке, иначе {true}
"""
function carefull_move!(r::Robot, side::HorizonSide)
    if !isborder(r, side)
        move(r, side)
        return true
    else
        return false
    end
end


# Двигает робота до границы в переданную сторону
function move_till_border!(r::Robot, side::HorizonSide)
    steps = 0
    while isborder(r, side) == 0
        move!(r, side)
        steps += 1
    end
    return steps
end


# Двигает робота на {x} клеток в сторону {side}
function move_for!(r::Robot, side::HorizonSide, x::Int)
    for _ in 1:x
        if !isborder(r, side)
            move!(r, side)
        else
            return false
        end
    end
    return true
end


# Двигает робота на клетку (x, y)
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


opposite_side(side::HorizonSide) = HorizonSide((Int(side) + 2) % 4)     # Возвращает противоположную передаваемой сторону.

next_side(side::HorizonSide) = opposite_side(HorizonSide((Int(side) + 1) % 4))       # Возвращает следующую сторону от {side} по часовой стрелке


# Возвращает координаты клетки сверху/снизу/слева/справа от переданной
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

coordinates(r::Robot) = r.situation.robot_position      # Координаты робота. ( {position(r)} конфликтует с встроенными ф-циями julia )

field_size(r::Robot) = map(u_int -> Int(u_int), r.situation.frame_size)        # Размер поля, на котором находится робот


# "Поиск в глубину", робот проходится по всем клеткам и маркирует переданные в {cells}
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



"""
            Обход перегородок
"""


# проверяет {x}-овую клетку в сторону {side} от места старта робота
function find_or_move!(r, side, x, border_side)
    move_for!(r, side, x)
    if isborder(r, border_side) == false
        return true
    end
    move_for!(r, opposite_side(side), x)
    return false
end

# Перемещает робота к "выходу"
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


function super_move!(r, side)
    if isborder(r, side)
        cnt, escape_side = escape_find(r, side)
        move!(r, side)
        for _ in 1:cnt
            super_move!(r, opposite_side(escape_side))
        end
    else
        move!(r, side)
    end
    
end


# # Двигается вдоль перегородки со стороны {check_side} в сторону {side}
# function move_while_border_at!(r, side, check_side)
#     cnt = 0
#     # isblocked = false
#     while isborder(r, check_side) == 1
#         if isborder(r, side) == 0
#             return (cnt, true)
#         end
#         move!(r, side)
#         cnt += 1
#     end
#     return (cnt, false)
# end

# # Двигается вдоль перегородки со стороны {border_side} в сторону {side} и проверяет есть ли там выход
# function check_if_escape_or_border(r, side, border_side)
#     cnt_1, isBlocked_1 = move_while_border_at!(r, side, border_side)
#     move_for!(r, opposite_side(side), cnt_1)
    
#     return (!isBlocked_1, cnt_1)            # {!isblocked_1} == true - есть выход
# end

# # Проверяет границу на доступность обхода
# function is_local_border(r, side)
#     for t_side in (next_side(side), opposite_side(next_side(side)))
#         isEscape, cnt = check_if_escape_or_border(r, t_side, side)
#         if isEscape
#             return (true, cnt, t_side)
#         end
#     end

#     return (false, 0, side)
# end
