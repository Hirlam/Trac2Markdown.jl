
function trac2md(s::String) 

    subs =  [ 
       "= '''Harmonie System Documentation''' =" => "",
       r"\[(https?://.+?) (.+?)\]"        => s"[\2](\1)",  # hrefs http and https
       r"\[wiki:(.+?) (.+?)\]"           => s"[\2](\1)",  # Wiki links 
       r"\[source:(.+?) (.+?)\]"         => s"[\2](\1)",  # Source links
       r"\[raw-attachment:(.+?) (.+?)\]" => s"[\2](\1)",  # Attachements        
       r"\{\{\{([^\r\n]+?)\}\}\}"        => s"`\1`",      # Single line code blocks
       "{{{"                             => "```bash",   # Multiline code blocks (assumed to be bash)
       "}}}"                             => "```",       # multiline code blocks
       r"==\s*'''\s*(.+?)\s*'''\s*=="    => s"## \1",     # level 2 header (not bold in md)
       r"=\s*'''\s*(.+)\s*'''\s*="       => s"# \1",      # level 1 headers (not bold in md)
       r"===\s*(.+?)\s*==="              => s"### \1",    # level 3 headers
       r"==\s*(.+?)\s*=="                => s"## \1",     # level 2 headers
      
       r"=\s*(.+?)\s*="                  => s"# \1",      # level 1 headers 
       r"'''\s*(.+?)\s*'''"                    => s"**\1**",    # Bold 
       "||"                              => "|",         # For tables 
       r"\[\[.+\]\]\r\n"                 => s"",          # Navigation symbols  (removed) 
       # r"([^ ]*?HM_DATA[^ ]*)"       => s"`\1`",      # if word contains HM_DATA fomat it as code
       # r"([^ ]*?hm_home/[^ ]*)"       => s"`\1`",      # if word contains cca/ fomat it as code
       "[[Center(end)]]"                 => "" ,       # This one doesn't end in \r\n
       "[Back to the main page of the HARMONIE System Documentation](HarmonieSystemDocumentation)" => ""
       
    ]
    
    function convert_tables(s::String)
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
    
     
    s2 = convert_tables(s)

    return foldl(replace, subs, init = s2)
end 
