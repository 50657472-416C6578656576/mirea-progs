# include("basics.jl")
include("basicTypes.jl")


function visit_all_cells!(r, side=Nord, cell=(0, 0), visited=Set(), ans=[0, 0, 0, 0,])

    if (cell in visited) == false && !isborder(r, side)
        move!(r, side)
        push!(visited, cell)

        ans[1] = min(cell[1], ans[1])
        ans[2] = max(cell[1], ans[2])
        ans[3] = min(cell[2], ans[3])
        ans[4] = max(cell[2], ans[4])

        for tempSide in [Nord, Ost, Sud, West]
            tempAns = visit_all_cells!(r, tempSide, side_to_i_j(tempSide, cell), visited, ans)
            if tempAns != false
                move!(r, opposite_side(tempSide))
                ans = tempAns
            end
        end

        return ans

    else
        return false
    end
end

function get_field_size_and_start_cell!(r)
    side = get_no_border_side(r)
    if side == false
        return (1, 1), (1, 1)
    end
    ans = visit_all_cells!(r, side, side_to_i_j(side, (0,0)))
    move!(r, opposite_side(side))
    M = ans[2]-ans[1]+1
    N = ans[4]-ans[3]+1
    return (M, N), (M-ans[2], N-ans[4])
end

struct SuperCheatRobot <: AbstractRobot 
    robot::Robot
    position::Coordinates
    field_size::Coordinates


    SuperCheatRobot(r, (i, j), (M, N)) = new(r, Coordinates(i, j), Coordinates(M, N))
    function SuperCheatRobot(r)
        (M, N), (i, j) = get_field_size_and_start_cell!(r)
        return SuperCheatRobot(r, (i, j), (M, N))
    end
    # spawn::Coordinates
end
