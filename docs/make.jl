using Documenter

pages = [     
    "System" => ["Harmonie-mSMS.md","TheHarmonieScript.md",  "QuickStartLocal.md"],
    "Configuration" => "ConfigureYourExperiment.md",
    "Observations" => "UseofObservation.md",
]


makedocs(
    sitename = "Harmonie wiki",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"), 
    pages = pages       
)

deploydocs(
    repo = "github.com/Hirlam/Trac2Markdown.jl.git",
)
