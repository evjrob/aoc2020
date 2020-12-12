using DelimitedFiles
using Formatting

io = open("input.txt")
io_txt = read(io, String)
passports = split(io_txt, "\n\n")

# cid is optional
required_fields = [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid"
]

function heightcheck(x)
    units = x[(length(x)-1):length(x)]
    if units == "cm"
        value = parse(Int, x[1:length(x)-2])
        return (value >= 150) & (value <= 193)
    end
    if units == "in"
        value = parse(Int, x[1:length(x)-2])
        return (value >= 59) & (value <= 76)
    end
    return false
end

field_rules = Dict(
    "byr" => v -> (parse(Int, v) >= 1920) & (parse(Int, v) <= 2002),
    "iyr" => v -> (parse(Int, v) >= 2010) & (parse(Int, v) <= 2020),
    "eyr" => v -> (parse(Int, v) >= 2020) & (parse(Int, v) <= 2030),
    "hgt" => v -> heightcheck(v),
    "hcl" => v -> occursin(r"^#[(0-9)|(a-f)]{6}$", v),
    "ecl" => v -> occursin(r"^(amb|blu|brn|gry|grn|hzl|oth)$", v),
    "pid" => v -> occursin(r"^[0-9]{9}$", v),
    "cid" => v -> true
)

function validpassport(p)
    fields = split(p, (' ', '\n'))
    fields = [split(f, ':') for f in fields]
    #println(fields)
    fnames = [f[1] for f in fields]
    validname = [f in fnames for f in required_fields]
    validnames = reduce(&, validname)
    #println(validname)
    validvalue = Dict(f[1] => field_rules[f[1]](f[2]) for f in fields)
    validvalues = reduce(&, values(validvalue))
    #println(validvalue)
    return (validnames & validvalues)
end

println(format(sum(validpassport.(passports))))