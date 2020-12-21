io = open("input.txt")
io_txt = read(io, String)
schedule = split(io_txt, "\n")
earliestdeparture = parse(Int, schedule[1])
buses = split(schedule[2], ',')
offsets = [i for i in 0:length(buses)-1]
offsets = offsets[(buses .!= "x")]
buses = [b for b in buses if b != "x"]
buses = parse.(Int, buses)
departures = [ceil(earliestdeparture/b)*b for b in buses]
waits = departures .- earliestdeparture
firstbus = argmin(waits)
slowestbus = argmax(buses)

# Extended Euclidean algorithm
function eea(a, b)
    t = 0
    newt = 1
    r = b
    newr = a
    while newr != 0
        quotient = r ÷ newr
        (t, newt) = (newt, t - quotient * newt)
        (r, newr) = (newr, r - quotient * newr)
    end
    if t < 0
        t += b
    end
    return t
end

# Chinese reamainder theorem
function crt()
    N = prod(buses)
    a = buses .- offsets
    y = [N ÷ n for n in buses]
    z = [eea(y[i], buses[i]) for i = 1:length(buses)]
    x = sum(a .* y .* z) 
    return (x % N)
end

println("Part 1: ", Int(waits[firstbus]*buses[firstbus]))
println("Part 2: ", crt())