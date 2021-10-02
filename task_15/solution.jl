using HorizonSideRobots
include("../basics.jl")


"""
            task_2 c перегородками
"""


function solve_15!(r)
    visited = Set()
    M, N = field_size(r)
    I, J = coordinates(r)
    cells = Set()

    for i in 1:M
        push!(cells, (i, N))
        push!(cells, (i, 1))
    end
    for j in 1:N
        push!(cells, (M, j))
        push!(cells, (1, j))
    end

    mark_some_cells_with_dfs!(r, visited, (I, J), false, cells)
    
    show(r)    
end