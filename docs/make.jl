using Documenter



include("../src/pages.jl")

makedocs(
    sitename = "Harmonie wiki",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"), 
    pages = ["Home" => "index.md"; pages]
)

deploydocs(
    repo = "github.com/Hirlam/Trac2Markdown.jl.git",
)
