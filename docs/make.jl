using Documenter

makedocs(
    sitename = "Harmonie wiki",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),        
)

deploydocs(
    repo = "github.com/Hirlam/Trac2Markdown.jl.git",
)
