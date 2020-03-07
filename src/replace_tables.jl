
function replace_tables(s::String)
    lines = split(s,"\r\n")
    out=String[]
    intable=false
    for line in lines
           
        if startswith(line, r"\s*\|\|") && !intable  # first row of table 
            println("found table")
            push!(out,"")   # empty line needed
            push!(out,replace(line, "||" => "|" ))
            push!(out, rstrip(replace(line, r"\s*(\|\|[^\|]*)" => "| --- ") , ['-', ' ']))
            intable=true
        elseif startswith(line, r"\s*\|\|") && intable # non first row of table
            push!(out,replace(line, "||" => "|"))
        else # normal text 
            push!(out,line)
            intable=false
        end
    end
    return join(out,"\r\n")
end
    