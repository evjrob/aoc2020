using DataStructures

io = open("input.txt")
io_txt = read(io, String)
rules = split(io_txt, "\n")

rgraph = DefaultDict(Set)
fgraph = DefaultDict(Set)

function bagcolor(b)
    subs = Dict(" bags" => "", " bags." => "", " bag" => "", " bag." => "")
    b = replace(b, r" bags.| bags| bag.| bag" => s -> subs[s])
    return b
end

function ruleparser(r)
    outer, inner = split(r, " bags contain ")
    inner = split(inner, ", ")
    inner = [split(i, " ", limit=2) for i in inner]
    inner = [[i[1], bagcolor(i[2])] for i in inner]
    fgraph[outer] = inner
    for i in inner
        bcount, bcolor = i
        push!(rgraph[bcolor], outer)
    end
end

ruleparser.(rules)

function parentbagcount(childbag)
    bags = Set()
    function bagtraverse(bcolor)
        outerbags = rgraph[bcolor]
        for b in outerbags
            push!(bags, b)
            bagtraverse(b)
        end
    end
    bagtraverse(childbag)
    return length(bags)
end

function childbagcount(parentbag)
    bagcount = 0
    function bagtraverse(bcolor, c)
        innerbags = fgraph[bcolor]
        for b in innerbags
            innerbcount, innerbcolor = b
            if innerbcount == "no"
                return
            end
            innerc = c * parse(Int, innerbcount)
            bagcount +=  innerc
            bagtraverse(innerbcolor, innerc)
        end
    end
    bagtraverse(parentbag, 1)
    return bagcount
end

println(parentbagcount("shiny gold"))
println(childbagcount("shiny gold"))