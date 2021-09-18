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
        move!(r, side)
    end
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
    
    if (cell in visited) == false && cheker
        if is_not_at_start
            move!(r, side)
        end
        push!(visited, cell)

        if cell in cells
            putmarker!(r)
            println("!Marker at ", cell)
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