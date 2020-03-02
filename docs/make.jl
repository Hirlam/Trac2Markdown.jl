using Documenter, HTTP

include("trac2md.jl")

wikiurl       = "https://hirlam.org/trac/wiki/HarmonieSystemDocumentation/"
attachmenturl = "https://hirlam.org/trac/raw-attachment/wiki/HarmonieSystemDocumentation/"

pages= [
    "ConfigureYourExperiment",
    "Harmonie-mSMS", 
    "TheHarmonieScript",
    "QuickStartLocal",
    "UseofObservation",
    "General"
]

for page in pages 
    println("reading $page")

    # Retrieve page from wiki
    resp = HTTP.get("$wikiurl$page?format=txt")
    s = String(resp.body)

    ## download attachments     
    for attachment in eachmatch(r"\[raw-attachment:(.+?) .+?\]",s) 
         capture = attachment.captures[1]
         mkpath(joinpath("src",page))
        download(joinpath(attachmenturl,page,capture),joinpath("src",page,capture))
    end
    

    # convert text to markdown
    mdtxt  = trac2md(s)

    # write to file
    write("src/$page.md", mdtxt)
end

makedocs(
    sitename = "Harmonie wiki",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),    
    pages = pages .* ".md"
)

deploydocs(
    repo = "github.com/Hirlam/Trac2Markdown.git",
)
