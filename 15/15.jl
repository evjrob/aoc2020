using DataStructures

function game(startingnumbers, idxend=2020)
    numbertracker = DefaultDict(Array{Any,1})
    idxstart = length(startingnumbers) + 1
    # Initialize the game
    for i = 1:length(startingnumbers)
        push!(numbertracker[startingnumbers[i]], i)
        num = startingnumbers[i]
    end
    lastnumber = startingnumbers[end]
    # Continue the game 
    for i = idxstart:idxend
        l = numbertracker[lastnumber]
        if length(numbertracker[lastnumber]) <= 1
            lastnumber = 0
            push!(numbertracker[lastnumber], i)
        else
            lastidx = numbertracker[lastnumber][end]
            secondlastidx = numbertracker[lastnumber][end-1]
            lastnumber = lastidx - secondlastidx
            push!(numbertracker[lastnumber], i)
        end
    end
    return lastnumber
end
    
#startingnumbers = [0,3,6]  
startingnumbers = [12,1,16,3,11,0]

# Part 1
@time lastnumber = game(startingnumbers, 2020)
println("Part 1: ", lastnumber)

# Part 2
@time astnumber = game(startingnumbers, 30000000)
println("Part 2: ", lastnumber)