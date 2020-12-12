using DelimitedFiles
using Formatting

f = readdlm("input.txt", ',', Float64)

for i = 1:length(f)
    for j = i:length(f)
        if (f[i] + f[j]) == 2020
            println("Two ints product: ", format(f[i] * f[j]))
        end
        for k = j:length(f)
            if (f[i] + f[j] + f[k]) == 2020
                println("Three ints product: ", format(f[i] * f[j] * f[k]))
            end
        end
    end
end
