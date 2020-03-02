module Trac2Markdown

export trac2md,
       getattachments, 
       MARKDOWNDIR

const MARKDOWNDIR = joinpath(dirname(pathof(Trac2Markdown)),"../docs/src/")

function trac2md(s::String) 

    subs =  [ 
       r"\[(https://.+?) (.+?)\]"        => s"[\2](\1)",  # hrefs
       r"\[wiki:(.+?) (.+?)\]"           => s"[\2](\1)",  # Wiki links 
       r"\[source:(.+?) (.+?)\]"         => s"[\2](\1)",  # Source links
       r"\[raw-attachment:(.+?) (.+?)\]" => s"[\2](\1)",  # Attachements        
       r"\{\{\{([^\r\n]+?)\}\}\}"        => s"`\1`",      # Single line code blocks
       r"\{\{\{"                         => s"```bash",   # Multiline code blocks (assumed to be bash)
       r"\}\}\}"                         => s"```",       # multiline code blocks
       r"=== (.+?) ==="                  => s"## \1",     # level 2 headers
       r"== '''(.+?)''' =="              => s"## \1",     # level 2 header (not bold in md)
       r"= '''(.+)''' ="                 => s"# \1",      # level 1 headers (not bold in md)
       r"== (.+?) =="                    => s"# \1",      # level 1 headers
       r"'''(.+?)'''"                    => s"**\1**",    # Bold 
       r"\[\[.+\]\]\r\n"                 => s"",          # Navigation symbols  (removed) 
       #r"([^ ]*?HM_DATA[^ ]*)"       => s"`\1`",      # if word contains HM_DATA fomat it as code
       #r"([^ ]*?hm_home/[^ ]*)"       => s"`\1`",      # if word contains cca/ fomat it as code
       r"\[Back to the main page of the HARMONIE System Documentation\]\(HarmonieSystemDocumentation\)" => s"",
       r"\[\[Center\(end\)\]\]"         => s"",        # This one doesn't end in \r\n
    ]

    return foldl(replace, subs, init = s)
end 

function getattachments(s::String) 
    m = match(r"\[raw-attachment:(.+?) .+?\]",s)      
    m === nothing ? nothing : m.captures 
end 

end # module
