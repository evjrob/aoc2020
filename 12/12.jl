io = open("input.txt")
io_txt = read(io, String)
directions = split(io_txt, "\n")

function navigate()
    lat = 0
    long = 0
    header = 'E'

    function changeheader(dir, angle)
        change = (dir, angle/90)
        headermap = Dict(
            'N' => Dict('L' => 'W', 'R' => 'E'),
            'E' => Dict('L' => 'N', 'R' => 'S'),
            'S' => Dict('L' => 'E', 'R' => 'W'),
            'W' => Dict('L' => 'S', 'R' => 'N')
        )
        for i = 1:change[2]
            header = headermap[header][dir]
        end
    end

    function move(instruction)
        dir = instruction[1]
        dist = parse(Int, instruction[2:length(instruction)])
        if dir in ['R', 'L']
            changeheader(dir, dist)
        else
            if dir == 'F'
                dir = header
            end
            if dir == 'N'
                lat += dist
            elseif dir == 'E'
                long += dist
            elseif dir == 'S'
                lat -= dist
            elseif dir == 'W'
                long -= dist
            else
                println("Something went wrong!")
                
            end
        end
    end

    for instruction in directions
        move(instruction)
    end

    manhattan_distance = abs(lat) + abs(long)
    return manhattan_distance
end

function navigate2()
    shiplocation = [0, 0]
    waypoint = [10, 1]

    function rotatewaypoint(dir, angle)
        change = angle/90
        rotationmap = Dict(
            'L' => [0 -1; 1 0],
            'R' => [0 1; -1 0]
        )
        rotationmatrix = rotationmap[dir]
        waypoint = rotationmatrix^change * waypoint
    end

    function move(instruction)
        dir = instruction[1]
        dist = parse(Int, instruction[2:length(instruction)])
        if dir in ['R', 'L']
            rotatewaypoint(dir, dist)
        else
            if dir == 'F'
                shiplocation .+= dist * waypoint
            elseif dir == 'N'
                waypoint[2] += dist
            elseif dir == 'E'
                waypoint[1] += dist
            elseif dir == 'S'
                waypoint[2] -= dist
            elseif dir == 'W'
                waypoint[1] -= dist
            else
                println("Something went wrong!")
            end
        end
    end

    for instruction in directions
        move(instruction)
    end

    manhattan_distance = abs(shiplocation[1]) + abs(shiplocation[2])
    return manhattan_distance
end

println("Part 1: ", navigate())
println("Part 2: ", navigate2())