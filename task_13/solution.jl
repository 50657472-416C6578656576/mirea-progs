using HorizonSideRobots
include("../basics.jl")


"""
            ДАНО: Робот - в произвольной клетке ограниченного прямоугольной рамкой поля без внутренних перегородок и маркеров.

            РЕЗУЛЬТАТ: Робот - в исходном положении в центре косого креста (в форме X) из маркеров.
"""


function solve_13!(r)
    I, J = coordinates(r)
    M, N = field_size(r)
    cells = Set()
    visited = Set()

    # Отбирает клетки поля подходящие для раскраски и пушит в {cells}
    for i in 1:I
        push!(cells, (I-i, J+i))
        push!(cells, (I-i, J-i))

    end
    for i in 1:(M-I)
        push!(cells, (I+i, J+i))
        push!(cells, (I+i, J-i))
    end

    mark_some_cells_with_dfs!(r, visited, (I, J), false, cells)
    putmarker!(r)
    show(r)
end
