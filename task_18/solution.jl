using HorizonSideRobots
include("../basics.jl")


"""
            task_5 c перегородками
"""

function solve_18!(r)
    visited = Set()
    M, N = field_size(r)
    mark_some_cells_with_dfs!(r, visited, coordinates(r), false, [(M, N), (1, N), (M, 1), (1, 1)])
    
    show(r)
end