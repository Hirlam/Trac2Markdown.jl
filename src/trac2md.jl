
function trac2md(s::String) 

    s = replace_tables(s)
    s = replace_code(s)
    return s
end 
