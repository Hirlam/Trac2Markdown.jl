using Documenter

pages = [
    "ConfigureYourExperiment.md",
    "Harmonie-mSMS.md", 
    "TheHarmonieScript.md",
    "QuickStartLocal.md",
    "UseofObservation.md",
    "General.md"
]


makedocs(
    sitename = "Harmonie wiki",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"), 
    pages = pages       
)

deploydocs(
    repo = "github.com/Hirlam/Trac2Markdown.jl.git",
)
