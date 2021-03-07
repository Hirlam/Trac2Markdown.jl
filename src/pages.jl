

# include("TrainingPages.jl")

HSD = "HarmonieSystemDocumentation"

Configuration = [
    "Experiment" => "$HSD/ConfigureYourExperiment.md",
    "Platform" => "$HSD/PlatformConfiguration.md",       
    "Namelist" => "$HSD/Namelists.md",
    "Update Namelist" => "$HSD/UpdateNamelists.md",
    "Model Domain" => "$HSD/ModelDomain.md",        
    "Vertical Grid" => "$HSD/VerticalGrid.md",
    "Climate Simulation" => "$HSD/ClimateSimulation.md",
    "Hires topography" => "$HSD/How_to_use_hires_topography.md"
]

ECFLOW_TASKS = [
    "Climate" => "$HSD/ClimateGeneration.md",
    "Observations" => [
        "$HSD/UseofObservation.md",
        "$HSD/ObservationOperators.md",
        "$HSD/ObservationHowto/GNSS.md",
        "$HSD/ObservationHowto/Amv.md",
        "$HSD/RadarData.md",
        "Preprocessing" => [
         # "ObservationPreprocessing.md" ,
            "$HSD/ObservationPreprocessing/ObservationData.md", 
            "Bator" => "$HSD/ObservationPreprocessing/Bator.md", 
            "Oulan" => "$HSD/ObservationPreprocessing/Oulan.md", 
            "Cope" => "$HSD/ObservationPreprocessing/Cope.md"
         ]
    ],            
    "Bator" => "$HSD/ObservationPreprocessing/Bator.md", 
    "Oulan" => "$HSD/ObservationPreprocessing/Oulan.md",
    "Boundaries" => "$HSD/BoundaryFilePreparation.md",
    "Screening" => "$HSD/Screening.md",
    "Surface Analysis" => "$HSD/Analysis/SurfaceAnalysis.md", 
    "DFI" => "$HSD/DigitialFilterInitialization.md",
    "Forecast" => "$HSD/Forecast.md",
    "Post Processing" => [
        "Obsmon" => "$HSD/PostPP/Obsmon.md", 
        "Diagnostics" => "$HSD/PostPP/Diagnostics.md", 
        "xtool" => "$HSD/PostPP/xtool.md", 
        "GL interpolation" => "$HSD/PostPP/gl/Interpolation.md",
        "Verification" => [
            "$HSD/PostPP/Verification.md", 
            "$HSD/PostPP/Extract4verification.md"
        ],
        "Fullpos" => "$HSD/PostPP/Fullpos.md",
        "FileConversion" => "$HSD/PostPP/FileConversions.md",
        "gl_grib_api" => "$HSD/PostPP/gl_grib_api.md",
    ] 
]   

pages = [
    # "Overview" => ["index" => ["index.md"]],
    
    
        "Running at ECMWF and local" => [
            "Running at ECMWF" => "$HSD/Harmonie-mSMS.md",
            "Fast start on cca" => "$HSD/Fast_start_on_cca.md",
            "Quick start local" => "$HSD/QuickStartLocal.md",
        ],  
        "Installation" => [
            "Installation" => "$HSD/Installation.md",
            "General Software Requirements" => "$HSD/General.md",
            "Makeup" => "$HSD/Build_with_makeup.md",
            "Stand Alone ODB" => "$HSD/StandaloneOdb.md",
            "Redhat7" => "$HSD/Redhat7Install.md",
            "Centos6" => "$HSD/Centos6Install.md"    
        ],  
        "The Harmonie Script" => "$HSD/TheHarmonieScript.md",
        "Profiling and Traceback" => "$HSD/DrHook.md",
        "File Formats" => "$HSD/FileFormats.md",     
        "Job Scheduling" => [           
            "ECFlow" => "$HSD/ECFLOW.md",
            "mXCdp" => "$HSD/scripts/mXCdp.md", 
            "mSMS" => "$HSD/scripts/mSMS.md"
        ],
        "Testbed and Mitraillette" => [
            "Testbed" => "$HSD/Evaluation/HarmonieTestbed.md",
            "Mitraillette" => "$HSD/Evaluation/Mitraillette.md"
        ],
        "Directories  and Binaries" => [
            "Directories" => "$HSD/Content.md", 
            "Binaries" => "$HSD/Binaries.md"
        ],
        "Configuration" => Configuration,                
        "ECFlow tasks" => ECFLOW_TASKS, 
        "Other" => [        
       
               
            "$HSD/Scalability_and_Refactoring.md",
            "$HSD/HarmonieBenchMark.md",
            "$HSD/MFaccess.md",
            "$HSD/Phasing.md" 
                          
            
        ]
    
 
    
]
