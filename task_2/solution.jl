using HorizonSideRobots
include("../basics.jl")


md"""
    ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок и маркеров)

    РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру внешней рамки промакированы
"""

# Двигает робота на север до границы, возвращая кол-во шагов, потребовавшихся ему для этого
function move_to_border!(r)
    cnt = 0
    while isborder(r, Nord) == 0
        move!(r, Nord)
        cnt += 1
    end
    return cnt
end

# Двигает робота вдоль границы.
# Если оказывается в углу: true. Если встретил промаркированную клетку (вернулся в начало, пройдя по периметру): false.
function go_and_mark_border!(r, side)
    while isborder(r, side) == 0
        if ismarker(r)
            return false
        end
        putmarker!(r)
        move!(r, side)
    end
    return true
end

function solve_problem_2!(r)
    cnt = move_to_border!(r)
    i = 0
    while go_and_mark_border!(r, HorizonSide(i % 4))
        i+=1
    end
    for i in 1:cnt
        move!(r, Sud)
    end
    show(r)
end
