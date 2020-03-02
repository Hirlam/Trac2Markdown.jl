using Documenter, HTTP

include("trac2md.jl")

wikiurl = "https://hirlam.org/trac/wiki/HarmonieSystemDocumentation/"

doc  = "Harmonie-mSMS"

resp = HTTP.get("$wikiurl$doc?format=txt")

s = String(resp.body)


mdtxt  = trac2md(s)
write("src/$doc.md", mdtxt)


makedocs(
    sitename = "Trac2Markdown",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),    
)

deploydocs(
    repo = "github.com/Hirlam/Trac2Markdown.git",
)
