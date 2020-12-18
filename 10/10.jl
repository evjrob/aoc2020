io = open("input.txt")
io_txt = read(io, String)
adapters = split(io_txt, "\n")
adapters = parse.(Int, adapters)

function getdiffs()
    global jolts = 0
    diffs = []
    while jolts <= maximum(adapters)
        candidate_jolts = jolts+1:jolts+3
        candidate_adapters = [j for j in candidate_jolts if j in adapters]
        if length(candidate_adapters) > 0
            candidate_diffs = candidate_adapters .- jolts
            #global diffs = cat(diffs, candidate_diffs[1], dims=1)
            push!(diffs, candidate_diffs[1])
            next_adapter = minimum(candidate_adapters)
            global jolts = next_adapter
        else
            push!(diffs, 3)
            break
        end
    end
    return diffs
end

function findallpossibilities()
    joltsmemos = Dict(maximum(adapters) => 1)
    function possibilities(jolts)
        if jolts in keys(joltsmemos)
            return joltsmemos[jolts]
        else
            candidate_jolts = jolts+1:jolts+3
            candidate_adapters = [j for j in candidate_jolts if j in adapters]
            possibilities = sum(map(possibilities, candidate_adapters))
            joltsmemos[jolts] = possibilities
            return possibilities
        end
    end
    return possibilities(0)
end

diffs = getdiffs()
one_jolt_diffs = sum(diffs .== 1)
three_jolt_diffs = sum(diffs .== 3)
jolt_product = one_jolt_diffs * three_jolt_diffs
total_possibilities = findallpossibilities()
println("Part 1. ones: $one_jolt_diffs, threes: $three_jolt_diffs, prod: $jolt_product")
println("Part 2. Total setups possible: $total_possibilities")