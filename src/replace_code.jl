
"""
    replace_code(s)

"""
function replace_code(s::String)

    lines = split(s,r"}}}|{{{")

    # check that number of lines is odd
    println(length(lines))
    isodd(length(lines)) || error("Something is wrong")

    out = String[]
    for (i,line) in enumerate(lines)
        if isodd(i)  # normal text: quote all special keywords/file paths
            line = replace(line,r"\s([^ `]*?\_[^ `]*?)\s" => s" ```\1``` ")
            line = replace(line,r"\s([^ `]*?/[^ `]*?)\s" => s" ```\1``` ")
            push!(out,line)
        else #code block
            push!(out,"``` $line ```")
        end
    end
    # println(out)
    return join(out)
end
