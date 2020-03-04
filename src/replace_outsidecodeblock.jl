
"""
replace(s::AbstractString, pat=>r; [count::Integer])

Search for the given pattern `pat` in `s` outside trac wiki code blocks, 
and replace each occurrence with `r`.
If `count` is provided, replace at most `count` occurrences.
"""
function replace_outsidecodeblock(s::AbstractString, pat_f::Pair; count=typemax(Int))

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