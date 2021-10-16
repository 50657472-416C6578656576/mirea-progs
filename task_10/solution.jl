using HorizonSideRobots
include("../basics.jl")


md"""
            ДАНО: Робот - в юго-западном углу поля, на котором расставлено некоторое количество маркеров

            РЕЗУЛЬТАТ: Функция вернула значение средней температуры всех замаркированных клеток
"""


"""Поиск в глубину, робот проходится по всем клеткам и возвращает пару значений: (сумма температур на маркированных клетках, их кол-во)"""
function count_some_temperature_with_dfs!(r, visited, cell, side, COUNT=0, SUM=0)
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

        if ismarker(r)
            SUM += temperature(r)
            COUNT += 1
        end

        for tempSide in [Nord, Ost, Sud, West]
            ans = count_some_temperature_with_dfs!(r, visited, side_to_i_j(tempSide, cell), tempSide, COUNT, SUM)
            if ans != false
                move!(r, opposite_side(tempSide))
                SUM += ans[1]
                COUNT += ans[2]
            end
        end

        return (SUM, COUNT)

    else
        return false
    end
end


 """Решение задачи 10"""
 function solve_10!(r)
    (M, N), (I, J) = get_field_size_and_position!(r)
    answer = count_some_temperature_with_dfs!(r, Set(), (I, J), false)
    
    return Float64(answer[1] / answer[2])
end