module Trac2Markdown

using Logging, HTTP

export trac2md,
       trac2markdown, 
       MARKDOWNDIR

# Note `export HLUSER=<hluser>` and `export HLPASSW=<passwd> before using Trac2Markdown 
const hluser = get(ENV,"HLUSER","")
const hlpassw = get(ENV,"HLPASSW","")


const MARKDOWNDIR   = joinpath(dirname(pathof(Trac2Markdown)), "../docs/src/")
const tracurl       = "https://$hluser:$hlpassw@hirlam.org/trac/"
const wikiurl       = "$tracurl/wiki/HarmonieSystemDocumentation/"
const attachmenturl = "$tracurl/raw-attachment/wiki/HarmonieSystemDocumentation/"

"""
    trac2markdown(relurl; getattachments)

Writes markdown file to $MARKDOWNDIR, and downloads attachment to $MARKDOWNDIR if getattachments=true.
Returns names of linked wikipages
"""
function trac2markdown(relurl::String; getattachments=false)
    @info "reading $relurl"

    # Retrieve page from wiki
    resp = HTTP.get("$wikiurl$relurl?format=txt")
    s = String(resp.body)

    ## download attachments
    if getattachments     
        for attachment in eachmatch(r"\[raw-attachment:(.+?) .+?\]", s)
            capture = attachment.captures[1]
            @info "Downloading $capture"
            mkpath(joinpath(MARKDOWNDIR, relurl))
            download(joinpath(attachmenturl, relurl, capture), joinpath(MARKDOWNDIR, relurl, capture))
        end
    end 

    # Get names of linked subwiki's
    subwikis = String[]
    for subwiki in eachmatch(r"\[wiki:(.+?) .+?\]", s)
        capture = subwiki.captures[1]
        push!(subwikis, capture)
    end

    # convert text to markdown
    mdtxt  = trac2md(s)

    # write to file
    mkpath(dirname(joinpath(MARKDOWNDIR, relurl)))

    write(joinpath(MARKDOWNDIR, "$relurl.md"), mdtxt)

    return subwikis
end

function trac2md(s::String) 

    subs =  [ 
       r"= '''Harmonie System Documentation''' =" => s"",
       r"\[(https?://.+?) (.+?)\]"        => s"[\2](\1)",  # hrefs http and https
       r"\[wiki:(.+?) (.+?)\]"           => s"[\2](\1)",  # Wiki links 
       r"\[source:(.+?) (.+?)\]"         => s"[\2](\1)",  # Source links
       r"\[raw-attachment:(.+?) (.+?)\]" => s"[\2](\1)",  # Attachements        
       r"\{\{\{([^\r\n]+?)\}\}\}"        => s"`\1`",      # Single line code blocks
       r"\{\{\{"                         => s"```bash",   # Multiline code blocks (assumed to be bash)
       r"\}\}\}"                         => s"```",       # multiline code blocks
       r"===\s*(.+?)\s*==="              => s"### \1",    # level 3 headers
       r"==\s*(.+?)\s*=="                    => s"## \1",     # level 2 headers
       r"==\s*'''(.+?)'''\s*=="              => s"## \1",     # level 2 header (not bold in md)
       r"=\s*'''(.+)'''\s*="                 => s"# \1",      # level 1 headers (not bold in md)
       r"=\s*(.+?)\s*="                  => s"# \1",      # level 1 headers 
       r"'''(.+?)'''"                    => s"**\1**",    # Bold 
       r"\[\[.+\]\]\r\n"                 => s"",          # Navigation symbols  (removed) 
       # r"([^ ]*?HM_DATA[^ ]*)"       => s"`\1`",      # if word contains HM_DATA fomat it as code
       # r"([^ ]*?hm_home/[^ ]*)"       => s"`\1`",      # if word contains cca/ fomat it as code
       r"\[Back to the main page of the HARMONIE System Documentation\]\(HarmonieSystemDocumentation\)" => s"", 
       r"\[\[Center\(end\)\]\]"         => s""        # This one doesn't end in \r\n
    ]

    return foldl(replace, subs, init = s)
end 

end # module