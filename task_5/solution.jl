using HorizonSideRobots
include("../basics.jl")


md"""
    ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, на котором могут находиться также внутренние прямоугольные перегородки
            (все перегородки изолированы друг от друга, прямоугольники могут вырождаться в отрезки)

    РЕЗУЛЬТАТ: Робот - в исходном положении и в углах поля стоят маркеры
"""


function solve_problem_5!(r)
    visited = Set()
    (M, N), (I, J) = get_field_size_and_position!(r)
    mark_some_cells_with_dfs!(r, visited, (I, J), false, [(M, N), (1, N), (M, 1), (1, 1)])
    
    show(r)
end
