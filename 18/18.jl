# The trick: recursively replace parenthesized expressions with their 
# numeric equivalent until we have just numbers and operations, then
# evaluate them left to right, or by order of operations
function evaluate(expression; firstop=nothing)
    # Nested function to apply operations in string without parentheses
    operatormap = Dict("+" => +, "*" => *)
    function applyoperations(expression)
        tokens = split(expression, " ")
        result = parse(Int, popfirst!(tokens))
        while !isempty(tokens)
            operator = popfirst!(tokens)
            number = parse(Int, popfirst!(tokens))
            result = operatormap[operator](result, number)
        end
        return result
    end
    # If there are no parentheses, just evaluate left to right    
    parenthesesregex = r"(\([^()]+\))"
    containsparentheses = occursin(parenthesesregex, expression)
    if !containsparentheses
        # If we have order of operations then evaluate those first
        if firstop != nothing
            if firstop == "*"
                opregex = r"(\d+\s\*\s\d+)"
            elseif firstop == "+"
                opregex = r"(\d+\s\+\s\d+)"
            else
                error("Invalid operation $firstop provided to firstop")
            end
            while occursin(opregex, expression)
                m = match(opregex, expression)
                result = evaluate(m[1])
                expression = replace(expression, opregex => "$result", count=1)
            end
        end
        return string(applyoperations(expression))
    # Otherwise we need to take care of parentheses first
    else
        m = match(parenthesesregex, expression)
        insideresult = evaluate(strip(m[1], ('(', ')')), firstop=firstop)
        revisedexpression = replace(expression, parenthesesregex => insideresult, count=1)
        return string(evaluate(revisedexpression, firstop=firstop))
    end
end

io = open("input.txt")
io_txt = read(io, String)
problems = split(io_txt, '\n')
solutions = evaluate.(problems)
part1 = sum(parse.(Int, solutions))
println("Part 1: $part1")
solutions2 = [evaluate(p, firstop="+") for p in problems]
part2 = sum(parse.(Int, solutions2))
println("Part 2: $part2")