using DelimitedFiles
using Formatting

f = readdlm("input.txt", ',', String)
slopes = [[1,1],[1,3],[1,5],[1,7],[2,1]]
tree_counts = zeros(length(slopes))

for i = 1:length(slopes)
    col = 1
    down = slopes[i][1]
    right = slopes[i][2]
    for j = 1:down:length(f)
        row = f[Int(j)]
        if col > length(row)
            col = (col % length(row))
        end
        if (row[Int(col)] == '#')
            global tree_counts[i] += 1
        end
        col += right
    end
end

println(tree_counts)
println(format(prod(tree_counts)))