using HorizonSideRobots
include("../basics.jl")


"""
    ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля

    РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы
"""

# "Поиск в глубину", робот проходится по всем клеткам и маркирует их
function dfs!(r, visited, node, side)
    is_not_at_start = side != false
    if is_not_at_start
        cheker = isborder(r, side) == false
    else
        cheker = true
    end
    if (node in visited) == false && cheker
        if is_not_at_start
            move!(r, side)
        end
        putmarker!(r)
        push!(visited, node)

        for tempSide in [Nord, Ost, Sud, West]
            if dfs!(r, visited, side_to_x_y(tempSide, node), tempSide)
                move!(r, opposite_side(tempSide))
            end
        end
        return true
    else
        return false
    end
end


function solve_problem_3!(r)
    visited = Set()
    dfs!(r, visited, (0, 0), false)
    show(r)
end