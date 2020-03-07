"""
    trac2markdown(relurl; getattachments)

Writes markdown file to $MARKDOWNDIR, and downloads attachment to $MARKDOWNDIR if getattachments=true.
Returns names of linked wikipages
"""
function trac2markdown(relurl::String; getattachments=false)

    s = isfile("$(Trac2Markdown.WIKIDIR)$relurl") ? getfromwikidir(relurl) : getfromhirlam(relurl)
          

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

function getfromwikidir(relurl)
    @info "using $(Trac2Markdown.WIKIDIR)$relurl"
    return read("$(Trac2Markdown.WIKIDIR)$relurl",String)
end 

function getfromhirlam(relurl)
    @info "Retrieving $relurl"
    resp = HTTP.get("$wikiurl$relurl?format=txt")
    s = String(resp.body)

    mkpath(dirname(joinpath(Trac2Markdown.WIKIDIR,relurl)))
    write(joinpath(Trac2Markdown.WIKIDIR,relurl),s)
    return s
end 