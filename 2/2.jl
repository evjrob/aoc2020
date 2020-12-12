using DelimitedFiles
using Formatting

f = readdlm("input.txt", ';', String)
valid_pass_count = 0
valid_pass_count_2 = 0

for i = 1:length(f)
    row = split(f[i], " ")
    counts = parse.(Int, split(row[1], "-"))
    cond = row[2][1]
    password = row[3]
    cond_count = 0
    for c in password
        if c == cond
            cond_count += 1
        end
    end
    if (cond_count >= counts[1]) & (cond_count <= counts[2])
        global valid_pass_count += 1
    end
    if (password[counts[1]] == cond) ⊻ (password[counts[2]] == cond)
        global valid_pass_count_2 += 1
    end
end

println(valid_pass_count)
println(valid_pass_count_2)