io = open("input.txt")
io_txt = read(io, String)
seattxt = split(io_txt, "\n")
seattxt = collect.(seattxt)
areadims = (length(seattxt), length(seattxt[1]))
seatingarea = Array{Char}(undef, areadims)
for i = 1:areadims[1]
    for j = 1: areadims[2]
        seatingarea[i,j] = seattxt[i][j]
    end
end

function validseatcheck(seat)
    return ((seat[1] >= 1) && (seat[1] <= areadims[1]) && (seat[2] >= 1) && (seat[2] <= areadims[2]))
end

function adjacentseatscheck(seats, candidateseat, stopvals)
    neighbourcount = 0
    directions = [(i,j) for j = -1:1 for i = -1:1 if ((i != 0) || (j != 0))]
    for d in directions
        adjseat = candidateseat
        neighbour = false
        stop = false
        while !stop
            adjseat = adjseat .+ d
            if !validseatcheck(adjseat)
                stop = true
                break
            end
            if (seats[adjseat[1], adjseat[2]] in stopvals)
                stop = true
            end
            if (seats[adjseat[1], adjseat[2]] == '#')
                neighbour = true
            end
        end
        if neighbour
            neighbourcount += 1
        end
    end
    return neighbourcount
end

function update!(seats, crowdthresh, mode=1)
    oldseats = copy(seats)
    for i = 1:areadims[1]
        for j = 1:areadims[2]
            if oldseats[i,j] == '.'
                continue
            else
                if mode == 1
                    stopvals = ['#','.','L']
                elseif mode == 2
                    stopvals = ['#','L']
                end
                neighbourcount = adjacentseatscheck(oldseats, (i,j), stopvals)
                if oldseats[i,j] == 'L' && neighbourcount == 0
                    seats[i,j] = '#'
                elseif oldseats[i,j] == '#' && neighbourcount >= crowdthresh
                        seats[i,j] = 'L'
                end
            end
        end
    end
    return (seats == oldseats)
end

function markovseats(inputseats; crowdthresh=4, mode=1)
    seats = copy(inputseats)
    converged = false
    while !converged
        converged = update!(seats, crowdthresh, mode)
    end
    occupied = 0
    for i = 1:areadims[1]
        for j = 1:areadims[2]
            if seats[i,j] == '#'
                occupied += 1
            end
        end
    end
    return occupied
end

occupied = markovseats(seatingarea, crowdthresh=4)
println("Part 1: $occupied")
occupied = markovseats(seatingarea, crowdthresh=5, mode=2)
println("Part 2: $occupied")