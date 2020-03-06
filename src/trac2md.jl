
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
    
    tables = [ 
        # For tables we detect the first line and repeat it
        r"(\r\n[^\|]*?\r\n)(\s*\|\|.*?)\r\n" => s"\1\2\r\n\2",

        # We detect start off table again and on the second line 
        # substitute the cell contents with --- 
        r"(\r\n[^\|]*?\r\n\s*\|\|.*?\r\n\s*)(\|\|.*?\|\|)*?\r\n" => 
          m -> startswith(m,'|') ? " --- " : "**",
         
    ]  
    ] 


    return foldl(replace, subs, init = s)
end 
