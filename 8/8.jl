io = open("input.txt")
io_txt = read(io, String)
cmds = split(io_txt, "\n")
cmdlength = length(cmds)

function runops(changecmd=-1)
    i = 1
    acc = 0
    excmds = Set()
    function nopfn()
        i += 1
    end
    function jmpfn(x)
        i += parse(Int, x)
    end
    function accfn(x)
        acc += parse(Int, x)
        i += 1
    end
    while !(i in excmds) & (i != cmdlength+1)
        cmd = cmds[i]
        push!(excmds, i)
        cmdparts = split(cmd, " ")
        if (changecmd == i) & (cmdparts[1] == "nop")
            jmpfn(cmdparts[2])
        elseif (changecmd == i) & (cmdparts[1] == "jmp")
            nopfn()
        elseif cmdparts[1] == "nop"
            nopfn()
        elseif cmdparts[1] == "acc"
            accfn(cmdparts[2])
        elseif cmdparts[1] == "jmp"
            jmpfn(cmdparts[2])
        else 
            println("Bad Op!")
        end
    end
    if (i == (cmdlength + 1)) | (changecmd == -1)
        return acc
    end
end

part1 = runops()
part2 = [runops(i) for i = 1:cmdlength]
part2 = [i for i in part2 if (i != nothing)][1]
println("part 1 acc: ", part1)
println("part 2 acc: ", part2)