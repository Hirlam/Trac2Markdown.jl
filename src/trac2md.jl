
function trac2md(s::String) 

    # Remove some navigation symbols
    subs =  [ 
        "== '''Harmonie System Documentation''' ==" => "",
        "= '''Harmonie System Documentation''' =" => "",
        "=== '''Harmonie System Training''' ===" => "",
        "[wiki:HarmonieSystemDocumentation Back to the main page of the HARMONIE System Documentation]" => "",
        r"\[\[.+\]\]\r\n"                       => s"",          # Navigation symbols  (removed) 
        "[[Center(end)]]"                       => "" ,       # This one doesn't end in \r\n     
    ]

    s =  foldl(replace, subs, init = s)

    s = replace_tables(s)
    s = replace_code(s)
    return s
end 
