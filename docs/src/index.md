

## **Overview**
This page describes how to get started with harmonie-40h1.1.1. Documentation of previous releases is available here: [previous versions](HarmonieSystemDocumentation/40h1.1/PreviousVersions)

A high level overview of HARMONIE, (system content, programs and file formats used), is available in the links below:
 * [Harmonie content](HarmonieSystemDocumentation/40h1.1/Content): Summary of the HARMONIE system and its content - schedulers, scripts and source code and auxiliary software tools
 * [Binaries in HARMONIE](HarmonieSystemDocumentation/40h1.1/Binaries): Summary of HARMONIE programs 
 * [File formats](HarmonieSystemDocumentation/40h1.1/FileFormats): Information on file formats used by HARMONIE, input and outputs, including FA, GRIB, BUFR and ODB

[Training Courses](HarmonieSystemDocumentation/40h1.1/TrainingCourses) also provide a useful overview of the HARMONIE system and its components.
## **Tutorial**
This is a "placeholder" for a beginners tutorial (possibly supplemented with a !YouTube video?)
 * Tutorial to test Harmonie on your PC
 * Tutorial to test Harmonie at ECMWF
## **Quick start**
### ECMWF
Below are links on how the start running HARMONIE at ECMWF. There is also information on how to speed up your compilation on cca and information on how to use the ''Harmonie'' script
 * [Running Harmonie at ECMWF](HarmonieSystemDocumentation/40h1.1/Harmonie-mSMS): A guide to running your first Harmonie experiment at ECMWF
  * [Faster compilation on cca](HarmonieSystemDocumentation/40h1.1/Fast_start_on_cca): Information on how to compile Harmonie code more quickly on ECMWF's HPC platform, cca
 * [The Harmonie script](HarmonieSystemDocumentation/40h1.1/TheHarmonieScript): The ''Harmonie'' script and how to use it
 * [Model domain](HarmonieSystemDocumentation/40h1.1/ModelDomain): How to define a new model domain for your first experiment
Have a look at the [Experiment Configuration](HarmonieSystemDocumentation#ExperimentConfiguration) section below on on how to configure your HARMONIE experiment.
### Local platform
Below are links on how the start running HARMONIE on your local platform. It is assumed that a valid host configuration has been made available to you. If you are really starting from scratch you should first look at the [Installation](HarmonieSystemDocumentation#Installation) and [input data](HarmonieSystemDocumentation#Downloadinputdata) sections.
 * [Running Harmonie](HarmonieSystemDocumentation/40h1.1/QuickStartLocal): A guide to running your first Harmonie experiment on your local platform
 * [The Harmonie script](HarmonieSystemDocumentation/40h1.1/TheHarmonieScript): The ''Harmonie'' script and how to use it
 * [Model domain](HarmonieSystemDocumentation/40h1.1/ModelDomain): How to define a new model domain for your first experiment
Have a look at the [Experiment Configuration](HarmonieSystemDocumentation#ExperimentConfiguration) section below on on how to configure your HARMONIE experiment.

## **Installation**
This section deals with installing HARMONIE on non-ECMWF platforms with some background information on the two build systems available, ''Makeup'' and ''GMKPACK''.
 * [General software requirements](HarmonieSystemDocumentation/40h1.1/General): Prepare your platform by installing software packages required by HARMONIE
  * [Redhat 7](HarmonieSystemDocumentation/40h1.1/Redhat7Install): specific software requirements/installation instructions for CentOS/Redhat 7 platforms
  * ~~[CentOS 6](HarmonieSystemDocumentation/40h1.1/Centos6Install): specific software requirements/installation instructions for CentOS 6 platforms~~. Please note: the version of gcc/gfortran available on CentOS/Redhat 6 platforms ((GCC) 4.4.7 !20120313 (Red Hat 4.4.7-16)) is not recent enough to compile harmonie-40h1.1. gcc/gfortran, netCDF and HDF5 must be installed locally.

 * [Platform configuration](HarmonieSystemDocumentation/40h1.1/PlatformConfiguration): A general description of required configuration files and a summary of those already available in HARMONIE.

 * There are two options available for compiling HARMONIE source code ''Makeup'' and ''GMKPACK''. ''Makeup'' is currently default.
  * [Compilation using Makeup](HarmonieSystemDocumentation/40h1.1/Build_with_makeup): How to compile HARMONIE source code using ''Makeup''
  * [Compilation using GMKPACK](HarmonieSystemDocumentation/40h1.1/Installation): How to compile HARMONIE source code using ''GMKPACK''
 * Source code CPP macros explained [odt](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/cpp_macros.odt), [pdf](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/cpp_macros.pdf): Overview of cpp macros used in the source code of ARPEGE/IFS and ALADIN/AROME/HARMONIE - (CY36T1)

## **Download input data**
Before you can start running HARMONIE experiments some input data (external from the code repository) needs to be available on your platform. The input data contains physiography data, topography information and climatological values determined from a one year ARPEGE assimilation experiment with a resolution of T79.
  * [harmonie_climate/38h1.1.tar.gz](https://hirlam.org/portal/download/harmonie_climate/38h1.1.tar.gz): Climate and physiography data for cy38h1
  * [harmonie_climate/40h1_increment_to_38h1.1.tar.gz](https://hirlam.org/portal/download/harmonie_climate/40h1_increment_to_38h1.1.tar.gz): Climate and physiography data "increment" for cy40h1
  * [sat_const/sat_const_cy38h1.2.tar.gz](https://hirlam.org/portal/download/sat_const/sat_const_cy38h1.2.tar.gz): Satellite constants
  * [Testdata set with boundaries and observations for a small 50x50 domain](https://hirlam.org/portal/download/testbed/38h1/38h1.tar)

## **Experiment Configuration**
This section provides information on how to configure your HARMONIE experiment: definition of input/output locations, how to assimilate observations, define forecast cycles, post-processing options and much more! For the expert user there is information on how model namelists are set up HARMONIE.
 * [Configure your experiment](HarmonieSystemDocumentation/40h1.1/ConfigureYourExperiment) - setting of environment variables in [sms/config_exp.h](tags/harmonie-40h1.1/sms/config_exp.h) explained
 * [Finding the right namelist](HarmonieSystemDocumentation/40h1.1/Namelists): more details on the namelist settings in HARMONIE (if you are prepared to get your hands dirty!)

## **Suite management**
From cy40h1 users have the option to use either mini-SMS or ecFlow to manage the execution of their HARMONIE experiments.

 * [A few words about mSMS](HarmonieSystemDocumentation/40h1.1/scripts/mSMS)
  * [Documentation of the original ECMWF full SMS](https://hirlam.org/UG/HL_Documentation/mSMS/SMS)
  * [mSMS interface: command line and environment](https://hirlam.org/UG/HL_Documentation/mSMS/mSMS_CLI.html)
  * [mini-XCdp: graphical display](https://hirlam.org/UG/HL_Documentation/mSMS/mXCdp) with an [update](HarmonieSystemDocumentation/40h1.1/scripts/mXCdp)
 * [Running Harmonie under ECFLOW](HarmonieSystemDocumentation/40h1.1/ECFLOW)

## **NWP Components**
### Domain definition
 * [Model domain](HarmonieSystemDocumentation/40h1.1/ModelDomain): Horizontal model domain information
 * [Vertical grid](HarmonieSystemDocumentation/40h1.1/VerticalGrid): Vertical model level definitions
### Climate generation
  * [Climate Generation](HarmonieSystemDocumentation/40h1.1/ClimateGeneration)
  * [How to upgrade to high-resolution topography](HarmonieSystemDocumentation/40h1.1/How_to_use_hires_topography)
### Initial/boundary data
   * [Initial and Lateral Boundary Interpolation](HarmonieSystemDocumentation/40h1.1/BoundaryFilePreparation)
   * [Interpolations with gl ](HarmonieSystemDocumentation/40h1.1/PostPP/gl/Interpolation)
### Observations
   * [Use of observations](HarmonieSystemDocumentation/40h1.1/UseofObservation) ([pdf](HarmonieSystemDocumentation/40h1.1/UseofObservation?format=pdfarticle)): selection of observation types and blacklisting using Bator
   * [Preprocessing of observation data](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing) ([pdf](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing?format=pdfarticle)): Introduction 
    * [ObservationData](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing/ObservationData) ([pdf](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing/ObservationData?format=pdfarticle)): Observation data
    * [Oulan](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing/Oulan) ([pdf](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing/Oulan?format=pdfarticle)): Oulan - extraction of conventional data and production of OBSOUL file read by BATOR
    * [Bator](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing/Bator) ([pdf](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing/Bator?format=pdfarticle)): Bator - preparation of ODBs used by data assimilation
    * [Cope](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing/Cope) ([pdf](HarmonieSystemDocumentation/40h1.1/ObservationPreprocessing/Cope?format=pdfarticle)): COPE - preparation of ODBs used by data assimilation - not available yet
   * Observation usage "how-tos":
     * [Atmospheric motion vectors](HarmonieSystemDocumentation/40h1.1/ObservationHowto/Amv) ([pdf](HarmonieSystemDocumentation/40h1.1/ObservationHowto/Amv?format=pdfarticle)): How to process and assimilate AMVs
     * [(OPERA) radar data](HarmonieSystemDocumentation/40h1.1/RadarData) ([pdf](HarmonieSystemDocumentation/40h1.1/RadarData?format=pdfarticle)): Assimilate OPERA (HDF5) radar data
     * [GNSS ZTD data](HarmonieSystemDocumentation/40h1.1/ObservationHowto/GNSS) ([pdf](HarmonieSystemDocumentation/40h1.1/ObservationHowto/GNSSZTD?format=pdfarticle)): How to process and assimilate GNSS ZTD data

   * [CONRAD: radar data pre-processing](HarmonieSystemDocumentation/40h1.1/Conrad) ([pdf](HarmonieSystemDocumentation/40h1.1/Conrad?format=pdfarticle))
   * [ODB: software, data and visualization](HarmonieSystemDocumentation/40h1.1/StandaloneOdb) ([pdf](HarmonieSystemDocumentation/40h1.1/StandaloneOdb?format=pdfarticle))

### Data Assimilation
   * [Surface Data Assimilation](HarmonieSystemDocumentation/40h1.1/Analysis/SurfaceAnalysis) ([pdf](HarmonieSystemDocumentation/40h1.1/Analysis/SurfaceAnalysis?format=pdfarticle))
   * 3D-VAR:
    * [Structure functions](HarmonieSystemDocumentation/40h1.1/Structurefunctions_ensys): How to derive structure functions on cca (at ECMWF) ([pdf](HarmonieSystemDocumentation/40h1.1/Structurefunctions_ensys?format=pdfarticle))
    * [Screening](HarmonieSystemDocumentation/40h1.1/Screening): Quality control of observations task ([pdf](HarmonieSystemDocumentation/40h1.1/Screening?format=pdfarticle))
    * [Single observation test](HarmonieSystemDocumentation/40h1.1/SingleObs_ensys): How to run a single observation test ([pdf](HarmonieSystemDocumentation/40h1.1/SingleObs_ensys?format=pdfarticle))
    * [DA working week 200805](HarmonieDAWorkshop200805): Information out of date now?
    * [Observation operators (HOP_DRIVER)](HarmonieSystemDocumentation/40h1.1/ObservationOperators) ([pdf](HarmonieSystemDocumentation/40h1.1/ObservationOperators?format=pdfarticle))
    * [Data Assimilation Flow Chart](HarmonieSystemDocumentation/40h1.1.1/graphviz)
    * [LETKF](HarmonieSystemDocumentation/40h1.1.1/LETKF)
    * [Hybrid 3DVAR-LETKF](HarmonieSystemDocumentation/40h1.1.1/HYBRID) 
   * Assimilation diagnostics:
    * MTEN ...
    * [DFS](HarmonieSystemDocumentation/40h1.1/DFS)
    * Observation impact diagnostics [https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/DesroziersHarm.tar.gz]

### Digitial Filter Initialization
 * [Digitial Filter Initialization](HarmonieSystemDocumentation/40h1.1/DigitialFilterInitialization): Brief description of how to use DFI in HARMONIE. (Not used by default)
### Forecast Model
 * [Forecast model](HarmonieSystemDocumentation/40h1.1/Forecast): A description of the [Forecast script](tags/harmonie-40h1.1/scr/Forecast) and some of the more important namelist settings
 * [40h1 model output](HarmonieSystemDocumentation/40h1.1/Forecast/Outputlist/40h1): Information on FA and GRIB output available from HARMONIE. (GRIB table information also included). **To be created! Use 38h1 info for now.**
 * [38h1.1 model output](HarmonieSystemDocumentation/Forecast/Outputlist/38h1): Information on FA and GRIB output available from HARMONIE 38h1. (GRIB table information also included).
  * [Previous output lists](HarmonieSystemDocumentation/40h1.1/PreviousModelOutputLists): Links to model output documentation valid for previous HARMONIE versions

### Ensemble prediction (HarmonEPS)
  * [How to run an ensemble experiment](HarmonieSystemDocumentation/EPS/Howto)
  * [Ensemble mode in the script system](HarmonieSystemDocumentation/EPS/System)
  * [Available boundary strategies](HarmonieSystemDocumentation/EPS/BDSTRATEGY)
  * [Available test periods for HarmonEPS](HarmonieSystemDocumentation/EPS/Testperiods)
  * [How to use SLAF](HarmonieSystemDocumentation/EPS/SLAF)
  * [Surface perturbations](HarmonieSystemDocumentation/EPS/SurfacePerturbations)
  * [List of experiments for HarmonEPS paper 2018](HarmonieSystemDocumentation/EPS/Explist_paper)
  * [SPPT (under construction)](HarmonieSystemDocumentation/EPS/SPPT)
  * [SPP (under construction)](HarmonieSystemDocumentation/EPS/SPP)
  * [LETKF](HarmonieSystemDocumentation/40h1.1.1/LETKF)

### Climate simulations (HCLIM)
  * [How to run a climate simulation](HarmonieSystemDocumentation/40h1.1/ClimateSimulation)
  * [HARMONIE Climate](HarmonieClimate): communication of status, development and documentation of HARMONIE Climate (HCLIM)

### Single column model (MUSC)
 * The README files for ecgb ([README_ecgb](branches/harmonie_MUSC_cy40h1/README_ecgb)) and Redhat 7 PCs ([README_redhat7](branches/harmonie_MUSC_cy40h1/README_redhat7)) provide the most up to date documentation on MUSC
 * [MUSC, Harmonie single column model](MUSC): From 2011 Working week. Out of date now?
 
## **Postprocessing**
 * [Postprocessing overview](HarmonieSystemDocumentation/40h1.1/PostPP) 
   * [Convert data to GRIB](HarmonieSystemDocumentation/40h1.1/PostPP/FileConversions)
   * [Postprocessing with FULL-POS](HarmonieSystemDocumentation/40h1.1/PostPP/Fullpos)
   * [Postprocessing with gl](HarmonieSystemDocumentation/40h1.1/PostPP/gl)
   * [Postprocessing with gl_grib_api](HarmonieSystemDocumentation/40h1.1/PostPP/gl_grib_api)
   * [Postprocessing with xtool](HarmonieSystemDocumentation/40h1.1/PostPP/xtool)
   * [Diagnostics](HarmonieSystemDocumentation/40h1.1/PostPP/Diagnostics)
   * [Obsmon](HarmonieSystemDocumentation/40h1.1/PostPP/Obsmon)

## **Verification**

 * [Extract data for verification](HarmonieSystemDocumentation/40h1.1/PostPP/Extract4verification)
 * [Deterministic verification (monitor)](HarmonieSystemDocumentation/40h1.1/PostPP/Verification)
 * [Ensemble verification (HARP)](HARP)
 * [Multi-model Observation Verification Intercomparison](HirlamSystemDocumentation/PostPP/CommonVerification)
 * [Observations monitoring](HarmonieSystemDocumentation/40h1.1/PostPP/Obsmon)


## **System: For the hard core system staff**
  * [Create new namelists](HarmonieSystemDocumentation/40h1.1/UpdateNamelists): How to create new namelists to be used by HARMONIE

  * [Harmonie testbed](HarmonieSystemDocumentation/40h1.1/Evaluation/HarmonieTestbed): The HARMONIE test environment used to test typical configurations on a small domain

  * [Phasing instructions](HarmonieSystemDocumentation/40h1.1/Phasing)
   * [Access to Météo-France servers](HarmonieSystemDocumentation/40h1.1/MFaccess)
   * [Mitraillette](HarmonieSystemDocumentation/40h1.1/Evaluation/Mitraillette)

  * [Profiling with DrHook](HarmonieSystemDocumentation/40h1.1/DrHook): ECMWF's profiling and traceback tool included in the code
  * [HARMONIE RAPS benchmark](HarmonieSystemDocumentation/40h1.1/HarmonieBenchMark)
  * Meteo France/ECMWF 2011: [Coding standards for ARPEGE-IFS](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article213)

  * [Scalability and refactoring](HarmonieSystemDocumentation/40h1.1/Scalability_and_Refactoring): Preliminary documents, presentations and links

  * Coordination documents
    * [OOPS & technical video meeting minutes](http://www.cnrm.meteo.fr/aladin/spip.php?article219&lang=en)
    * [Coordination meeting minutes](http://www.cnrm.meteo.fr/aladin/spip.php?article170&lang=en)
    * [Technical memorandums](http://www.cnrm.meteo.fr/aladin/spip.php?article124&lang=en)

## **Code browsers**

  * [Code browsers (ftagshtml), 36h1.3, 37h1.1, 38h1.beta.1](https://hirlam.org/codebrowser/)
  * [Doxygen code browser (36h1.4)](https://hirlam.org/portal/doxygen_browser/cy36h1.4/)
  * [Trac code browser](tags/harmonie-40h1.1/)

## **HARMONIE Reference materials**

 * **[Excellent ALADIN/Arome documentation](http://www.cnrm.meteo.fr/gmapdoc/spip.php?rubrique1)**
 * [IFS documentation](http://www.ecmwf.int/research/ifsdocs)
 * [SURFEX documentation](http://www.cnrm-game-meteo.fr/surfex/)
 * Meteo France/ECMWF 2011: [Coding standards for ARPEGE-IFS](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article213)
 * Guidard Vincent and C. Fischer, [ALADIN 3D-Var Theory and Practice](https://hirlam.org/trac/attachment/wiki/HarmonieDAWorkshop200805/Guidard_3DVAR_theory.ppt)
 * Kert'esz, S., 2001: [A short overview of ODB](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article64)
 * Kert'esz, S., 2002: Using ODB in ALADIN. Internal note, 21pp, available on "http://www.cnrm.meteo.fr/gmapdoc/" (topics "ODB")
 * [M. Lindskog, 2010: Study with extended extension zone, manuscript for HIRLAM Newsletter 2010](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/report.pdf)
 * R. Roger, [The data flow in HARMONIE data assimilation ](https://hirlam.org/trac/attachment/wiki/HarmonieDAWorkshop200805/R_Roger_data_handeling.ppt)
 * S. Saarinen: [Initial Optimisation of AROME forecasts on FMI's Cray XT5m, Presentation at ECMWF, Nov 20 2009](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/AROME_2_ECMWF_20nov2009v5.pdf)
 * [Yann Seity's unofficial documentation about Surfex surface drag options](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Drag_orog_report.pdf). Note the options described are those featured in CY36 and CY38, and some of the options for CY38 need back porting to CY37.
 * Trojakova Alena, [CANARI optimum interpolation with emphasis on technical aspects ](https://hirlam.org/trac/attachment/wiki/HarmonieDAWorkshop200805/Trojakova_canari_2.ppt)
 * Yessad K.: Aug 2007: [LIBRARY ARCHITECTURE AND HISTORY OF THE TECHNICAL ASPECTS IN ARPEGE/IFS, ALADIN AND AROME IN THE CYCLE 32T2 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article23)
 * Yessad, K., 2007: [Basics about ARPEGE/IFS, ALADIN and AROME in the cycle 32T2 of ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article29)
 * Vignes, O., 2011: [Short presentation of LSMIXBC option](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/lsmixbc.ppt)
 * Bengtsson, L., 2014: [CA scheme description](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/progress_report_CA.pdf)
----


