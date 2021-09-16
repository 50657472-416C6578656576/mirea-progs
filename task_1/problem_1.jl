using HorizonSideRobots
include("../basics.jl")


"""
    ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок и маркеров.

    РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.
    
    Рассмотреть отдельно еще случай, когда изначально в некоторых клетках поля могут находиться маркеры.
"""


# Аналогично move!, но маркирует (немаркированные) клетки по дороге.
function go_and_mark!(r, side)
    move!(r, side)
    if ismarker(r) == false
        putmarker!(r)
    end
 end
 
 # Двигает робота до границы поля в сторону side, маркируя клетки по пути, после чего возвращает его в точку старта.
 function mark_till_border!(r, side)
     while isborder(r, side) == 0
         go_and_mark!(r, side)
     end
     while ismarker(r)
         move!(r, opposite_side(side))
     end
 end
 
 function solve_problem_1!(r)
    for side in [Nord, Ost, Sud, West]
        mark_till_border!(r, side)
     end
     putmarker!(r)
     show(r)
 end
