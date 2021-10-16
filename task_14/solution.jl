using HorizonSideRobots
include("../basics.jl")

"""
        task_1, но с перегородками
"""


function solve_problem_14!(r)
    visited = Set()
    (M, N), (I, J) = get_field_size_and_position!(r)
    cells = Set()

    for i in 1:M
        push!(cells, (i, J))
    end
    for j in 1:N
        push!(cells, (I, j))
    end

    mark_some_cells_with_dfs!(r, visited, (I, J), false, cells)
    
    show(r)
end