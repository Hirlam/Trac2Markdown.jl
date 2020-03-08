
"""
    replace_code(s)

"""
function replace_code(s::String)

    lines = split(s,r"}}}|{{{")

    # check that number of lines is odd
    isodd(length(lines)) || error("Something is wrong")
   # s = join(lines,"```")

   # replace(s,r"(.*?) )
   # lines = split(s,"_")
   # out = String[] 
   # push!(out,replace(lines[1], r"(.*)\s`?([^ ]*)?" => s"\1 `\2"))
   # for line in lines[2:end-1]
   #     l = replace(line, r"[^ ]*`?\s(.*)?" => s"\1` \2")
   #     l = replace(l, r"(.*)\s`?([^ ]*)?" => s"\1 `\2") 
   #     push!(out,l)
   # end
   # push!(out, replace(lines[end], r"(.*)\s`?([^ ]*)?" => s"\1 `\2"))

   # return join(out,"_")

        # replace(line, r"(.*)\s([^ ]*)?" = > s"\1 `\2")

    out = String[]
    for (i,line) in enumerate(lines)
        if isodd(i)  # normal text: quote all special keywords/file paths
            # A word containing _ or \ is treated as code 
            # note this doesn't handle overlap properly "g/h h/j" will only quote g/h 
           push!(out,replace(line,r"[\[\*\s\n]`?([^ ]*?[\_/][^ ]*?)`?[\]\*\s\r]" => s" `\1` "))
           #  line = replace(line,r"(.*?)\s`?([^ ]*?\_[^ ]*?)`?\s(.*?)" => s"\1 `\2` \3")
           # line = replace(line,r"\s([^ `]*?/[^ `]*?)\s" => s"  `\1` ")
  #          push!(out,line)
        else #code block
            push!(out,line)
  #          push!(out,line)
        end
    end
    return join(out,"```")
    # println(out)
    
end
