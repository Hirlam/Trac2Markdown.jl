using Documenter

#pages = [     
#    "System" => ["Harmonie-mSMS.md","TheHarmonieScript.md",  "QuickStartLocal.md"],
#    "Configuration" => "ConfigureYourExperiment.md",
#    "Observations" => "UseofObservation.md",
#]

# include("../src/pages2.jl")

pages = [
    "Input Data" => [
        "Climate" => [
            "ClimateGeneration.md"
        ]
        "Boundaries" => [
            "BoundaryFilePreparation.md"
        ],
        "Observations" => [
            "StandaloneOdb.md",
            "UseofObservation.md",
            "ObservationOperators.md",
            "ObservationHowto/GNSS.md",
            "ObservationHowto/Amv.md",
            "RadarData.md",
            "Preprocessing" => [
                "ObservationPreprocessing.md" ,
                "ObservationPreprocessing/ObservationData.md", 
                "ObservationPreprocessing/Bator.md", 
                "ObservationPreprocessing/Oulan.md", 
                "ObservationPreprocessing/Cope.md"
            ]
        ]
    ],
    "Post Processing" => [
       "PostPP/Obsmon.md", 
       "PostPP/Diagnostics.md", 
       "PostPP/xtool.md", 
       "PostPP/gl/Interpolation.md",
       "PostPP/Verification.md",
       "PostPP/Extract4verification.md",
       "PostPP/Fullpos.md",
       "PostPP/FileConversions.md",
       "PostPP/gl_grib_api.md",
    ],  
    
    "ModelDomain.md",
    "TrainingCourses.md",
    "DigitialFilterInitialization.md",
    "System" => [
        "TheHarmonieScript.md",
        "ConfigureYourExperiment.md",
        "Job Scheduling" => [
           "Harmonie-mSMS.md",
  
           "ECFLOW.md", 
           "scripts/mXCdp.md", 
           "scripts/mSMS.md"
       ],
       "PlatformConfiguration.md",
       "Binaries.md",
       "Fast_start_on_cca.md",
     
       "Build_with_makeup.md",
       "PreviousVersions.md",
       "DrHook.md",
       "Scalability_and_Refactoring.md",
       "HarmonieBenchMark.md",
       "Redhat7Install.md",
       "Centos6Install.md",
       "Namelists.md",
       "MFaccess.md",
       "Phasing.md",
    
       "How_to_use_hires_topography.md",
       "FileFormats.md",
       "UpdateNamelists.md",
       "ClimateSimulation.md",
       "PreviousModelOutputLists.md",
       "Installation.md",
       "General.md",
       "QuickStartLocal.md" 
    ],
    "Data Assimilation" => [
        "DFS.md",
         "Screening.md",
        "Structurefunctions_ensys.md",
        "SingleObs_ensys.md",
        "Conrad.md",
        "Analysis.md",
        "Analysis/SurfaceAnalysis.md" 
    ],
    "Model" => [
        "VerticalGrid.md",
        "Forecast.md",
    ],
    "Content.md",
    
    "Evaluation" => [
        "Evaluation/HarmonieTestbed.md",
        "Evaluation/Mitraillette.md"
    ]
  
]


makedocs(
    sitename = "Harmonie wiki",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"), 
    pages = pages,
)

deploydocs(
    repo = "github.com/Hirlam/Trac2Markdown.jl.git",
)
