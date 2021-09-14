# Двигает робота до границы в переданную сторону
function move_till_border!(r, side)
    while isborder(r, side) == 0
        move!(r, side)
    end
end

# Двигает робота на клетку (x, y). Полезна для задания изначальной позиции робота.
function move_to!(r, x, y)
    move_till_border!(r, West)
    move_till_border!(r, Sud)
    for _ in 1:y-1
        move!(r, Nord)
    end
    for _ in 1:x-1
        move!(r, Ost)
    end
end