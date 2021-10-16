using HorizonSideRobots
include("../basics.jl")


md"""
            task_5 c перегородками
"""

function solve_18!(r)
    visited = Set()
    (M, N), (I, J) = get_field_size_and_position!(r)
    mark_some_cells_with_dfs!(r, visited, (I, J), false, [(M, N), (1, N), (M, 1), (1, 1)])
    
    show(r)
end