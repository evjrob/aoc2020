using DataStructures

io = open("input.txt")
io_txt = read(io, String)
program = split(io_txt, '\n')

function parseinstructions(program; version=1)
    instructions = []
    instruction = nothing
    for row in program
        if row[1:4] == "mask"
            if instruction != nothing
                push!(instructions, instruction)
            end
            instruction = Dict("mask" => collect(row[8:length(row)]), "operations" => [])
        elseif row[1:3] == "mem"
            opregex = r"mem\[(\d+)\]\s=\s(\d+)"
            m = match(opregex, row)
            address = parse(Int, String(m[1]))
            value = parse(Int, String(m[2]))
            if version == 1
                value = lpad(string(value, base=2), 36, "0")
                value = collect(value)
            end
            push!(instruction["operations"], (address => value))
        end
    end
    # Push the last instruction
    push!(instructions, instruction)
    return instructions
end

function execute(instructions)
    memory = DefaultDict(repeat(['0'], 36))

    # Execute the instructions
    for instruction in instructions
        mask = instruction["mask"]
        operations = instruction["operations"]
        for op in operations
            address = op[1]
            value = op[2]
            memory[address] = value
            for i = 1:length(memory[address])
                if mask[i] != 'X'
                    memory[address][i] = mask[i]
                end
            end
        end
    end
    memsum = 0
    for (key, value) in memory
        memsum += parse(Int, join(value), base=2)
        # println(key, " ", join(value), " ", parse(Int, join(value), base=2))
    end
    return memsum
end

instructions = parseinstructions(program, version=1)
memsum = execute(instructions)
println("Part 1: ", memsum)

function execute2(instructions)
    memory = DefaultDict(repeat(['0'], 36))
    memsum = 0
    # Execute the instructions
    for instruction in instructions
        mask = instruction["mask"]
        operations = instruction["operations"]
        for op in operations
            address = op[1]
            value = op[2]
            xcount = sum(mask .== 'X')
            xmap = [i for i = 1:length(mask) if mask[i] == 'X']
            possiblevalues = (2^length(xmap)) - 1
            addressbits = lpad(string(address, base=2), length(mask), "0")
            addressbits = collect(addressbits)
            for i = 1:length(mask)
                if mask[i] == '1'
                    addressbits[i] = '1'
                end
            end
            for i = 0:possiblevalues
                changeaddress = deepcopy(addressbits)
                floatingbits = lpad(string(i, base=2), length(xmap), "0")
                floatingbits = collect(floatingbits)
                for j = 1:length(xmap)
                    changeaddress[xmap[j]] = floatingbits[j]
                end
                changeaddress = parse(Int, join(changeaddress), base=2)
                memory[changeaddress] = value
            end
        end
    end
    memsum = 0
    for (key, value) in memory
        memsum += value
        # println(key, " ", value)
    end
    return memsum
end

instructions = parseinstructions(program, version=2)
memsum2 = execute2(instructions)
println("Part 2: ", memsum2)