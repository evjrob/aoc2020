function parseinput()
    io = open("input.txt")
    iotxt = split(read(io, String), "\n\n")
    rulestxt = split(iotxt[1], '\n')
    rules = Dict()
    for r in rulestxt
        ruleparts = split(r, ": ")
        rulenum = ruleparts[1]
        rulematches = strip(replace(ruleparts[2], "\"" => ""))
        if occursin("|", rulematches)
            rulematches = "(" * rulematches * ")"
        end
        rules[rulenum] = rulematches
    end
    messages = split(iotxt[2], '\n')
    return rules, messages
end

function regexify(rules, startrule)
    function regexrecurser(ruleregex)
        while occursin(r"(\d+)", ruleregex)
            m = match(r"(\d+)", ruleregex)
            subrule = rules[m[1]]
            # Recurse and replace the dict match to get the advantages of memoization
            subrulematch = regexrecurser(subrule)
            rules[subrule] = subrulematch
            ruleregex = replace(ruleregex, m[1] => "$subrulematch", count=1)
        end
        return ruleregex
    end
    finalregex = regexrecurser(rules[startrule])
    return Regex("^" * replace(finalregex, " " => "") * "\$")
end

rules, messages = parseinput()
# Part 1
@time begin
    ruleregex = regexify(rules, "0")
    rulematchcount = sum(Int.(occursin.(ruleregex, messages)))
    println("Part 1: $rulematchcount")
end

# Part 2
@time begin
    # Swap the designated rules, with regex notation equivalents, you need to
    # do this with your own rule changes, as they will be different.
    # 8: 42 | 42 8
    rules["8"] = "((42)+)"
    # 11: 42 31 | 42 11 31
    # This next one is a bit more tricky, since we can't just use the regex + 
    # after 42 and 31 separately, as this could match n occurrences of rule 42, 
    # followed by m occurrences of 31, where n ≠ m. Luckily the diabolical minds 
    # behind Perl Compatible Regular Expressions (PCRE) have me covered with 
    # recursive pattern matching for named groups:
    # https://www.debuggex.com/cheatsheet/regex/pcre
    # The following matches one or more occurance of rule 42 followed by the 
    # same number of occurrences rule 31.
    rules["11"] =  "(?P<eleven>(42 (?&eleven)? 31))"
    ruleregex = regexify(rules, "0")
    rulematchcount = sum(Int.(occursin.(ruleregex, messages)))
    println("Part 2: $rulematchcount")
end


