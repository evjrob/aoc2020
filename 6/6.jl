io = open("input.txt")
io_txt = read(io, String)
groups = split(io_txt, "\n\n")

function grouptotal(g, aggfunc=union)
    answers = map(Set, split(g, '\n'))
    group_answers = reduce(aggfunc, answers)
    return length(group_answers)
end

println("At least one answered count:")
println(sum(grouptotal.(groups, union)))
println("All answered count:")
println(sum(grouptotal.(groups, intersect)))