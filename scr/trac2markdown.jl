#!/usr/bin/env julia
using Trac2Markdown

pages= [
    "ConfigureYourExperiment",
    "Harmonie-mSMS", 
    "TheHarmonieScript",
    "QuickStartLocal",
    "UseofObservation",
    "General"
]

include("$(dirname(pathof(Trac2Markdown)))/pages2.jl")
# recursively get all subwikis
# getall(page) = getall.(trac2markdown.(page))


#topath(s::String) = s
#function topath(s::Pair)
#  root = first(s)

#function topath(s::Pair)= "$(s.first)/$(topath.(s.second))" 
   
trac2markdown.(pages, getattachments=false)

