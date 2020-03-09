
function trac2md(s::String) 

    subs =  [     

       r"\[(https?://.+?) (.+?)\]"        => s"[\2](\1)",  # hrefs http and https
      #  r"\[wiki:([^ ]*) (.+?)\]"           => s"[\2](./\1.md)",  # Wiki links 
       r"\[source:(.+?) (.+?)\]"         => s"[\2](https://hirlam.org/trac/browser/\1)",  # Source links
       r"\[raw-attachment:(.+?) (.+?)\]" => s"[\2](\1)",  # Attachements        
       r"==\s*'''\s*(.+?)\s*'''\s*=="    => s"## \1",     # level 2 header (not bold in md)
       r"=\s*'''\s*(.+)\s*'''\s*="       => s"# \1",      # level 1 headers (not bold in md)
       r"===\s*(.+?)\s*==="              => s"### \1",    # level 3 headers
       r"==\s*(.+?)\s*=="                => s"## \1",     # level 2 headers
      
       r"=\s*(.+?)\s*="                  => s"# \1",      # level 1 headers 
       r"'''\s*(.+?)\s*'''"                    => s"**\1**",    # Bold 
       r"''\s*(.+?)\s*''"                    => s"*\1*",    # Italic  
       
       
       
    ]
    
     

    s2=  foldl(replace, subs, init = s)

    s2 = replace_tables(s2)
    s2 = replace_code(s2)
    return s2
end 
