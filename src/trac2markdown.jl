"""
    trac2markdown(relurl; getattachments)

Writes markdown file to $MARKDOWNDIR, and downloads attachment to $MARKDOWNDIR if getattachments=true.
Returns names of linked wikipages
"""
function trac2markdown(relurl::String; getattachments=false)

    @info "Converting $(Trac2Markdown.WIKIDIR)$relurl.wiki"
    
    s = read("$(Trac2Markdown.WIKIDIR)$relurl.wiki",String)
          

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

    


    # To create relative url in Markdown we need the nestling level
    # So we can point to the docs/src directory
    nestinglevel = length(splitpath(relurl))-1
    wikisub = repeat("../",nestinglevel)    
    sstr = SubstitutionString("[\\2] ($wikisub\\1.md)")    
    s = replace(s,r"\[wiki:([^ ]+?) (.+?)\]" => sstr)

    # convert text to markdown
    mdtxt  = trac2md(s)

    # write to file
    mkpath(dirname(joinpath(MARKDOWNDIR, relurl)))

    # Add meta block to change the EditURL to point to hirlam.org
    wikiurl = "$(Trac2Markdown.wikiurl)/$relurl"
    meta="```@meta\r\nEditURL=\"$wikiurl?action=edit\"\r\n```\r\n"

    meta_mdtxt = meta .* mdtxt 

    write(joinpath(MARKDOWNDIR, "$relurl.md"), meta_mdtxt)

    return subwikis
end

function getfromwikidir(relurl)
    
end 

# The .wiki extension is added to avoid conflict with 
# having a file with the same name as a directory
