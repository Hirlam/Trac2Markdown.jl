using Documenter



include("../src/pages.jl")

# pages="Phasing.md"  # for testing

makedocs(
    sitename = "Harmonie wiki",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"), 
    pages = ["Home" => "index.md"; pages],
#   repo="https://hirlam.org/trac/wiki/HarmonieSystemDocumentation"
)

deploydocs(
    repo = "github.com/Hirlam/Trac2Markdown.jl.git",
)
