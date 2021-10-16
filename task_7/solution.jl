using HorizonSideRobots
include("../basics.jl")


md"""
        ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля (без внутренних перегородок)

        РЕЗУЛЬТАТ: Робот - в исходном положении, в клетке с роботом стоит маркер, и все остальные клетки поля промаркированы в шахматном порядке
"""


 """Решение задачи 7"""
 function solve_7!(r)
    (M, N), (I, J) = get_field_size_and_position!(r)
    visited = Set()
    cells = Set()
    
    for i in 1:M
        for j in 1:N
            if (I % 2 != i % 2 && J % 2 != j % 2) || (I % 2 == i % 2 && J % 2 == j % 2)
                push!(cells, (i, j))
            end
        end
    end

    mark_some_cells_with_dfs!(r, visited, (I, J), false, cells)
    
    show(r)
end