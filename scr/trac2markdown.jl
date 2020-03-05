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

SRCDIR = dirname(pathof(Trac2Markdown))

include("$SRCDIR/pages2.jl")
# recursively get all subwikis
# getall(page) = getall.(trac2markdown.(page))

   
trac2markdown.(pages, getattachments=false)


