module Trac2Markdown

using Logging, HTTP

export trac2md,
       trac2markdown, 
       MARKDOWNDIR

const user = "roel"
const passw = readline("$(ENV["HOME"])/.hirlampassw")


const MARKDOWNDIR   = joinpath(dirname(pathof(Trac2Markdown)),"../docs/src/")
const wikiurl       = "https://$user:$passw@hirlam.org/trac/wiki/HarmonieSystemDocumentation/"
const attachmenturl = "https://$user:$passw@hirlam.org/trac/raw-attachment/wiki/HarmonieSystemDocumentation/"

"""
    trac2markdown(relurl)

Writes markdown file to $MARKDOWNDIR, downloads attachment to $MARKDOWNDIR
and returns names of linked wikipages
"""
function trac2markdown(relurl::String)
    @info "reading $relurl"

    # Retrieve page from wiki
    resp = HTTP.get("$wikiurl$relurl?format=txt")
    s = String(resp.body)

    ## download attachments     
    for attachment in eachmatch(r"\[raw-attachment:(.+?) .+?\]",s)
         capture = attachment.captures[1]
         @info "Downloading $capture"
         mkpath(joinpath(MARKDOWNDIR,relurl))
         download(joinpath(attachmenturl,relurl,capture),joinpath(MARKDOWNDIR,relurl,capture))
    end

    # Get names of linked subwiki's
    subwikis = String[]
    for subwiki in eachmatch(r"\[wiki:(.+?) .+?\]",s)
        capture = subwiki.captures[1]
        push!(subwikis,capture)
    end

    # convert text to markdown
    mdtxt  = trac2md(s)

    # write to file
    mkpath(joinpath(MARKDOWNDIR,relurl))
    write(joinpath(MARKDOWNDIR,relurl,"index.md"), mdtxt)

    return subwikis
end

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

end # module