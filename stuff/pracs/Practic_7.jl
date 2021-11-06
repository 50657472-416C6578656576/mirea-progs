# Задача.
# ДАНО: робот - в югозападном углу поля, на которм имеются 
#       прямолинейные перегородки, не соприкасющиеся друг с другом и с внешней рамкой
# РЕЗУЛЬТАТ: функция должна вернуть число имеющихся на поле перегородок 
# (в упрощенном варианте - число горизонтальных перегородок)


mutable struct  CountbordersRobot <: AbstractBorderRobot
    robot::Robot
    state::Bool
    count::Int
    border_side::HorizonSide
    CountbordersRobot(r, border_side=Nord) = new(r,0,0, border_side)
end

get(robot::CountbordersRobot) = robot.robot

function try_move!(robot::CountbordersRobot,side)
    try_move!(get(robot), side) 
    if isborder(robot, robot.border_side)
        if robot.state == 0
            robot.state = 1
            robot.count += 1
        end
    else
        robot.state = 0
    end
end

get_num_borders(robot::CountbordersRobot) = robot.count
#--------------------------------------------

function count_borders!(robot::Robot)
    # робот - в юго-западном углу

    robot = CountbordersRobot(robot)
    snake(robot)
    return get_num_borders(robot) # - число горизонтальных перегородок
end

#------------------------

#ЗАМЕЧАНИЕ.
#Если определить функцию snake! так, чтобы она возвращала ссылку на робота нового типа:
function snake!(robot::AbstractRobot, (next_row_side::HorizonSide, move_side::HorizonSide)=(Nord, Ost)) # - это обобщенная функция
    # Робот - в (inverse(next_row_side), inverse(move_side)) - углу поля
    movements!(robot, move_side)
    while !isborder(robot, next_row_side)
        move!(robot,next_row_side)
        move_side = inverse(move_side)
        movements!(robot,move_side)
    end
    return robot
end

#то можно было бы определить функцию count_borders! совсем кратко:
count_borders!(robot::Robot) = get_num_borders(snake!(CountbordersRobot(robot)))