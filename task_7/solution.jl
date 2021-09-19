using HorizonSideRobots
include("../basics.jl")


"""
        ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля (без внутренних перегородок)

        РЕЗУЛЬТАТ: Робот - в исходном положении, в клетке с роботом стоит маркер, и все остальные клетки поля промаркированы в шахматном порядке
"""


function solve_7!(r)
    I, J = coordinates(r)
    M, N = field_size(r)
    visited = Set()
    cells = Set()
    
    for i in 1:M
        for j in 1:N
            if (I % 2 != i % 2 && J % 2 != j % 2) || (I % 2 == i % 2 && J % 2 == j % 2)
                push!(cells, (i, j))
            end
        end
    end

    mark_some_cells_with_dfs!(r, visited, coordinates(r), false, cells)
    
    show(r)
end