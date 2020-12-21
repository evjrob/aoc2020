using Statistics

function parsetickets()
    io = open("input.txt")
    io_txt = read(io, String)
    lines = split(io_txt, '\n')

    readconstraints = true
    readticket = false
    readnearby = false

    constraints = Dict()
    myticket = nothing 
    nearbytickets = []
    
    for l in lines
        if l == ""
            continue
        elseif l == "your ticket:"
            readconstraints = false
            readticket = true
            readnearby = false
            continue
        elseif l == "nearby tickets:"
            readconstraints = false
            readticket = false
            readnearby = true
            continue
        else
            if readconstraints
                m = match(r"^([a-z\s]+):\s(\d+)-(\d+)\sor\s(\d+)-(\d+)$", l)
                field = m[1]
                lower1 = parse(Int, m[2])
                upper1 = parse(Int, m[3])
                lower2 = parse(Int, m[4])
                upper2 = parse(Int, m[5])
                constraints[field] = [(lower1, upper1), (lower2, upper2)]
            elseif readticket
                myticket = parse.(Int, split(l, ','))
            elseif readnearby
                ticket = parse.(Int, split(l, ','))
                push!(nearbytickets, ticket)
            end
        end
    end
    return constraints, myticket, nearbytickets
end

function validate(ticket, constraints)
    ticketerrors = []
    for value in ticket
        validvalue = false
        for (field, bounds) in constraints
            for bound in bounds
                if value ∈ bound[1]:bound[2]
                    validvalue = true
                    break
                end
            end
            if validvalue
                break
            end
        end
        if !validvalue
            push!(ticketerrors, value)
        end
    end
    return ticketerrors
end

function errorrate(nearbytickets, constraints)
    errors = [validate(t, constraints) for t in nearbytickets]
    errorsum = sum([sum(vcat(e, [0])) for e in errors])
    return errorsum
end

function matchfields(nearbytickets, constraints)
    errors = [validate(t, constraints) for t in nearbytickets]
    errorsum = [sum(vcat(e, [0])) for e in errors]
    validtickets = nearbytickets[errorsum .== 0]
    fields = keys(constraints)
    candidatecolumns = Dict(f => Set() for f in fields)
    candidatefields = Dict(i => Set() for i = 1:length(fields))
    # Find the candidate columns for each field
    for field in fields
        bounds = constraints[field]
        for candidatecolumn = 1:length(fields)
            validcol = true
            for ticket in validtickets
                value = ticket[candidatecolumn]
                validvalue = false
                for bound in bounds
                    if value ∈ bound[1]:bound[2]
                        validvalue = true
                        break
                    end
                end
                if !validvalue
                    validcol = false
                    break
                end
            end
            if validcol
                push!(candidatecolumns[field], candidatecolumn)
                push!(candidatefields[candidatecolumn], field)
            end
        end
    end
    # Find the unique possibility
    function cover(field, column)
        otherfields = setdiff(candidatefields[column], Set([field]))
        for otherfield in otherfields
            setdiff!(candidatecolumns[otherfield], Set([column]))
            setdiff!(candidatefields[column], Set([otherfield]))
            if length(candidatecolumns[otherfield]) == 1
                uniquecolumn = first(candidatecolumns[otherfield])
                cover(otherfield, uniquecolumn)
            end
        end
        return
    end
    for field in fields
        if length(candidatecolumns[field]) == 1
            uniquecolumn = first(candidatecolumns[field])
            cover(field, uniquecolumn)
        end         
    end
    
    # Generate and return the product
    prodfields = [f for f in fields if startswith(f, "departure")]
    prodcolumns = [first(candidatecolumns[f]) for f in prodfields]
    resultproduct = prod([myticket[i] for i in prodcolumns])

    return resultproduct
end

constraints, myticket, nearbytickets = parsetickets()
println("Part 1: ", errorrate(nearbytickets, constraints))
println("Part 2: ", matchfields(nearbytickets, constraints))


