
"""
    replace_code(s)

"""
function replace_code2(s::String)

    lines = split(s,"\r\n")

    incodeblock = false

    out = String[]
    for line in lines 
        if line == "{{{"
            incodeblock=true
            push!(out,"```bash")
        elseif  line == "}}}"
            incodeblock=false
            push!(out,"```")
        elseif incodeblock
            push!(out,line)
        elseif !incodeblock
            # Single line code blocks
           line = replace(line, r"\{\{\{([^\r\n]+?)\}\}\}" => s"`\1`") 
           # words containing _ or / 
           line = replace(line, r"[\[\*\s\n]`?([^ ]*?[\_/][^ ]*?)`?[\]\*\s\r]" => s" `\1` "))
           push!(out,line)
        end
    end

    return join(lines,"\r\n")  
end
