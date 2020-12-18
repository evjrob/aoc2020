using Combinatorics

io = open("input.txt")
io_txt = read(io, String)
data = split(io_txt, "\n")
data = parse.(Int, data)
preamble_length = 25

function validate(num, preamble)
    combs = combinations(preamble, 2)
    for c in combs
        if num == sum(c)
            return true
        end
    end
    return false
end

function findinvalid(data)
    invalid_data = []
    for i = (preamble_length+1):length(data)
        num = data[i]
        if !validate(num, data[(i-preamble_length):(i-1)])
            push!(invalid_data, num)
        end
    end
    return invalid_data
end

function findinvalidsum(data, invalid_num)
    for offset = 1:length(data)
        for i = 1:(length(data)-offset)
            sequence = data[i:(i+offset)]
            if sum(sequence) == invalid_num
                return sequence
            end
        end
    end
end

invalid_data = findinvalid(data)
first_invalid = invalid_data[1]
invalid_sequence = findinvalidsum(data, first_invalid)
println("First invalid num: ", first_invalid)
println("Invalid sequence: ", invalid_sequence)
println("Invalid sequence sum: ", minimum(invalid_sequence) + maximum(invalid_sequence))