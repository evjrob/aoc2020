# Add empty  
function expand(array)
    dims = size(array)
    expandeddims = dims .+ 2
    expandedarray = zeros(expandeddims)
    if length(expandeddims) == 3
        expandedarray[2:end-1, 2:end-1, 2:end-1] = array
    elseif length(dims) == 4
        expandedarray[2:end-1, 2:end-1, 2:end-1, 2:end-1] = array
    end
    array = expandedarray
    return array
end

function countneighbours(array, i,j,k,l=nothing)
    dims = size(array)
    irange = max(i-1,1):min(i+1,dims[1])
    jrange = max(j-1,1):min(j+1,dims[2])
    krange = max(k-1,1):min(k+1,dims[3])
    if length(dims) == 3
        neighbours = array[irange, jrange, krange]
        return sum(neighbours) - array[i,j,k]
    elseif  length(dims) == 4
        lrange = max(l-1,1):min(l+1,dims[4])
        neighbours = array[irange, jrange, krange, lrange]
        return sum(neighbours) - array[i,j,k,l]
    end
end

function conwaycycle!(array)
    oldarray = copy(array)
    dims = size(array)
    for i = 1:dims[1]
        for j = 1:dims[2]
            for k = 1:dims[3]
                nc = countneighbours(oldarray, i,j,k)
                #println(i, " ", j, " ", k, " : ", nc)
                if (oldarray[i,j,k] == 1.0) && !(nc == 2 || nc == 3)
                    array[i,j,k] = 0.0
                elseif (oldarray[i,j,k] == 0) && (nc == 3)
                    array[i,j,k] = 1.0
                end
            end
        end
    end
end

function conwaycycle4D!(array)
    oldarray = copy(array)
    dims = size(array)
    for i = 1:dims[1]
        for j = 1:dims[2]
            for k = 1:dims[3]
                for l = 1:dims[4]
                    nc = countneighbours(oldarray, i,j,k,l)
                    #println(i, " ", j, " ", k, " : ", nc)
                    if (oldarray[i,j,k,l] == 1.0) && !(nc == 2 || nc == 3)
                        array[i,j,k,l] = 0.0
                    elseif (oldarray[i,j,k,l] == 0) && (nc == 3)
                        array[i,j,k,l] = 1.0
                    end
                end
            end
        end
    end
end

function conway()
    io = open("input.txt")
    iotxt = read(io, String)
    input = collect(iotxt)
    inputmap = Dict('.' => 0, '#' => 1)
    input = [inputmap[i] for i in input if i != '\n']
    dim = Int(sqrt(length(input)))
    initdims = (dim, dim)
    initarray = reshape(input, initdims)
    # Part 1: 3D
    @time begin
        # Initial non-standard expansion
        array = zeros((initdims[1], initdims[2], initdims[1]))
        array[1:initdims[1], 1:initdims[2],2] = initarray
        for c = 1:6
            array = expand(array)
            conwaycycle!(array)
        end
        println("Part 2: ", sum(array))
    end

    # Part 2: 4D
    @time begin
        # Initial non-standard expansion
        array = zeros((initdims[1], initdims[2], initdims[1], initdims[1]))
        array[1:initdims[1], 1:initdims[2], 2, 2] = initarray
        for c = 1:6
            array = expand(array)
            conwaycycle4D!(array)
        end
        println("Part 2: ", sum(array))
    end
end

conway()