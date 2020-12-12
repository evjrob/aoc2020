io = open("input.txt")
io_txt = read(io, String)
seatcodes = split(io_txt, "\n")
results = []

for sc in seatcodes
    rc = sc[1:7]
    cc = sc[8:10]
    rsubs = Dict("F" => 0, "B" => 1)
    csubs = Dict("L" => 0, "R" => 1)
    r = replace(rc, r"F|B" => s -> rsubs[s])
    r = parse(Int, r, base=2)
    c = replace(cc, r"L|R" => s -> csubs[s])
    c = parse(Int, c, base=2)
    seatid = r * 8 + c
    push!(results, (r,c,seatid))
end

seatids = [f[3] for f in results]
minseat = minimum(seatids)
maxseat = maximum(seatids)
myseat = [s for s = minseat:maxseat if !(s in seatids)]
println(myseat)