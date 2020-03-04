
"""
replace(s::AbstractString, pat=>r)

Search for the given pattern `pat` in `s` outside trac wiki code blocks, 
and replace each occurrence with `r`.
"""
function replace_outsidecodeblock(s::AbstractString, pat_f::Pair)

    # Magic string
    const MS = "THISSTRINGWILLNOTAPPEARINTHEWIKI"
    
     subs =  [
        # Inside code blocks replace search pattern with magic string 
        r"\{\{\{([.*?\r\n.*?])\}\}\}" =>  m -> replace(m, first(pat_f) => MS),
        # apply pat_f
        pat_f,  
        # Replace magic string with search pattern  
        MS => first(pat_f),
    ]

    return foldl(replace, subs, init = s)

end