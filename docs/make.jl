using Documenter

#pages = [     
#    "System" => ["Harmonie-mSMS.md","TheHarmonieScript.md",  "QuickStartLocal.md"],
#    "Configuration" => "ConfigureYourExperiment.md",
#    "Observations" => "UseofObservation.md",
#]

# include("../src/pages2.jl")

pages = [
    # "Overview" => ["index" => ["index.md"]],
    "System" => [
        "Job Scheduling" => [           
           "ECFlow" => "ECFLOW.md",
           "mXCdp" => "scripts/mXCdp.md", 
           "mSMS" => "scripts/mSMS.md"
       ],
       "Configuration" => [
          "Experiment" => "ConfigureYourExperiment.md",
          "Platform" => "PlatformConfiguration.md",       
          "Namelist" => "Namelists.md",
          "Update Namelist" => "UpdateNamelists.md"       
        ],
        "Installation" => [
            "Installation" => "Installation.md",
            "Makeup" => "Build_with_makeup.md",
            "Redhat7" => "Redhat7Install.md",
            "Centos6" => "Centos6Install.md"    
        ],
        "Running at ECMWF" => "Harmonie-mSMS.md",  
        "The Harmonie Script" => "TheHarmonieScript.md",
        "Profiling and Traceback" => "DrHook.md",
        "File Formats" => "FileFormats.md",            
        "Testbed and Mitraillette" => [
           "Testbed" => "Evaluation/HarmonieTestbed.md",
           "Mitraillette" => "Evaluation/Mitraillette.md"
        ],  
        "Climate Simulation" => "ClimateSimulation.md",
        "Other" => [     
            "Binaries.md",
            "Fast_start_on_cca.md",
            # "PreviousVersions.md",            
            "Scalability_and_Refactoring.md",
            "HarmonieBenchMark.md",
            "MFaccess.md",
            "Phasing.md",   
            "How_to_use_hires_topography.md",            
            # "PreviousModelOutputLists.md",           
            "General Software Requirements" => "General.md",
            "Quick start local" => "QuickStartLocal.md"
        ]
    ],
    "Input Data" => [
        "Climate" => [
            "ClimateGeneration.md"
        ],
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
                # "ObservationPreprocessing.md" ,
                "ObservationPreprocessing/ObservationData.md", 
                "Bator" => "ObservationPreprocessing/Bator.md", 
                "Oulan" => "ObservationPreprocessing/Oulan.md", 
                "Cope" => "ObservationPreprocessing/Cope.md"
            ]
        ]
    ],
    "Data Assimilation" => [
        "Screening" => "Screening.md",
        "Structure functions" => "Structurefunctions_ensys.md",
        "DFS" => "DFS.md",         
        "Surface" => "Analysis/SurfaceAnalysis.md", 
        "Analysis" => "Analysis.md", 
        "Single Obs" => "SingleObs_ensys.md",
        "Conrad" => "Conrad.md",       
    ],
    "Model" => [
        "Model Domain" => "ModelDomain.md",        
        "Vertical Grid" => "VerticalGrid.md",
        "Forecast" => "Forecast.md",
    ],
    "Post Processing" => [
       "Obsmon" => "PostPP/Obsmon.md", 
       "Diagnostics" => "PostPP/Diagnostics.md", 
       "xtool" => "PostPP/xtool.md", 
       "GL interpolation" => "PostPP/gl/Interpolation.md",
       "Verification" => [ "PostPP/Verification.md", "PostPP/Extract4verification.md"],
       "Fullpos" => "PostPP/Fullpos.md",
       "FileConversion" => "PostPP/FileConversions.md",
       "gl_grib_api" => "PostPP/gl_grib_api.md",
    ],      
    
    "Other" => [
        # "TrainingCourses.md",
        "DigitialFilterInitialization.md",
        "Content.md"
    ]
    
    
]

getpages(s::String) = s
getpages(p::Pair) = getpages(p.second)
getpages(a::Array) = getpages.(a)


makedocs(
    sitename = "Harmonie wiki",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"), 
    pages = pages,
)

deploydocs(
    repo = "github.com/Hirlam/Trac2Markdown.jl.git",
)
