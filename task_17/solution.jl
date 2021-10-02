using HorizonSideRobots
include("../basics.jl")


"""
            task_4 c перегородками
"""


function solve_16!(r)
    visited = Set()
    M, N = field_size(r)
    I, J = coordinates(r)
    cells = Set()

    for i in 1:M
        for j in N:-1:i
            push!(cells, (M-i+1, j))
        end
    end

    mark_some_cells_with_dfs!(r, visited, (I, J), false, cells)
    
    show(r) 
end