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

# recursively get all subwikis
# getall(page) = getall.(trac2markdown.(page))
   
trac2markdown.(pages, getattachments=true)

