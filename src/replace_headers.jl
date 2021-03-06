function replace_headers(s::AbstractString)

    subs =  [     
        r"\[(https?://.+?) (.+?)\]"        => s"[\2](\1)",  # hrefs http and https
   
        r"\[source:(.+?) (.+?)\]"         => s"[\2](https://hirlam.org/trac/browser/\1)",  # Source links
        r"\[raw-attachment:(.+?) (.+?)\]" => s"[\2](\1)",  # Attachements        
        r"^==\s*'''\s*(.+?)\s*'''\s*=="    => s"## \1",     # level 2 header (not bold in md)
        r"^=\s*'''\s*(.+)\s*'''\s*="       => s"# \1",      # level 1 headers (not bold in md)
        r"^===\s*(.+?)\s*==="              => s"### \1",    # level 3 headers
        r"^==\s*(.+?)\s*=="                => s"## \1",     # level 2 headers
    
        r"^=\s*(.+?)\s*="                  => s"# \1",      # level 1 headers 
        r"'''\s*(.+?)\s*'''"              => s"**\1**",    # Bold 
        r"''\s*(.+?)\s*''"                => s"*\1*",      # Italic  
    ]

    return foldl(replace, subs, init = s)
end 