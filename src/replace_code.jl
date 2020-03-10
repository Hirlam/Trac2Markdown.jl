
"""
    replace_code(s)

"""
function replace_code(s::String)

    lines = split(s,"\r\n")

    incodeblock = false

    out = String[]
    for line in lines 
        if strip(line) == "{{{" 
            incodeblock=true
            push!(out,"```bash")
        elseif strip(line) == "}}}"
            incodeblock=false
            push!(out,"```")
        elseif incodeblock
            push!(out,line)
        elseif !incodeblock
            
           line = replace_headers(line)
           
           # Single line code blocks
           line = replace(line, r"\{\{\{(.*?)\}\}\}" => s"`\1`") 
                      
           push!(out,line)
        end
    end

    return join(out,"\r\n")  
end
