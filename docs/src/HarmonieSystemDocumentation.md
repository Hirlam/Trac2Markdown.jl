# Harmonie System Documentation
# Documentation by version
 * [HarmonieSystemDocumentation/40h1.1.1](HarmonieSystemDocumentation/40h1.1.1)
 * [HarmonieSystemDocumentation/40h1.1](HarmonieSystemDocumentation/40h1.1)
 * [HarmonieSystemDocumentation/38h1.2](HarmonieSystemDocumentation/38h1.2)
 * [HarmonieSystemDocumentation/37h1.2](HarmonieSystemDocumentation/37h1.2)

## Overview
This page describes how to get started with harmonie-43h2, documentation of previous releases is available here: [previous versions](HarmonieSystemDocumentation/PreviousVersions)

A high level overview of HARMONIE, (system content, programs and file formats used), is available in the links below:
 * [Harmonie content](HarmonieSystemDocumentation/Content): Summary of the HARMONIE system and its content - schedulers, scripts and source code and auxiliary software tools
 * [Binaries in HARMONIE](HarmonieSystemDocumentation/Binaries): Summary of HARMONIE programs 
 * [File formats](HarmonieSystemDocumentation/FileFormats): Information on file formats used by HARMONIE, input and outputs, including FA, GRIB, BUFR and ODB

[Training Courses](HarmonieSystemDocumentation/TrainingCourses) also provide a useful overview of the HARMONIE system and its components.
## Tutorial
This is a "placeholder" for a beginners tutorial (possibly supplemented with a !YouTube video?)
 * Tutorial to test Harmonie on your PC
 * Tutorial to test Harmonie at ECMWF
## Quick start
## ECMWF
Below are links on how to start running HARMONIE at ECMWF. There is also information on how to speed up your compilation on cca and information on how to use the ''Harmonie'' script
 * [Running Harmonie at ECMWF](HarmonieSystemDocumentation/Harmonie-mSMS): A guide to running your first Harmonie experiment at ECMWF
  * [Faster compilation on cca](HarmonieSystemDocumentation/Fast_start_on_cca): Information on how to compile Harmonie code more quickly on ECMWF's HPC platform, cca
 * [The Harmonie script](HarmonieSystemDocumentation/TheHarmonieScript): The ''Harmonie'' script and how to use it
 * [Model domain](HarmonieSystemDocumentation/ModelDomain): How to define a new model domain for your first experiment
Have a look at the [Experiment Configuration](HarmonieSystemDocumentation#ExperimentConfiguration) section below on how to configure your HARMONIE experiment.
## Local platform
Below are links on how the start running HARMONIE on your local platform. It is assumed that a valid host configuration has been made available to you. If you are really starting from scratch you should first look at the [Installation](HarmonieSystemDocumentation#Installation) and [input data](HarmonieSystemDocumentation#Downloadinputdata) sections.
 * [Running Harmonie](HarmonieSystemDocumentation/QuickStartLocal): A guide to running your first Harmonie experiment on your local platform
 * [The Harmonie script](HarmonieSystemDocumentation/TheHarmonieScript): The ''Harmonie'' script and how to use it
 * [Model domain](HarmonieSystemDocumentation/ModelDomain): How to define a new model domain for your first experiment
Have a look at the [Experiment Configuration](HarmonieSystemDocumentation#ExperimentConfiguration) section below on how to configure your HARMONIE experiment.

## Installation
This section deals with installing HARMONIE on non-ECMWF platforms with some background information build system.
 * [General software requirements](HarmonieSystemDocumentation/General): Prepare your platform by installing software packages required by HARMONIE
  * [Redhat 7](HarmonieSystemDocumentation/Redhat7Install): specific software requirements/installation instructions for CentOS/Redhat 7 platforms
  * ~~[CentOS 6](HarmonieSystemDocumentation/Centos6Install): specific software requirements/installation instructions for CentOS 6 platforms~~. Please note: the version of gcc/gfortran available on CentOS/Redhat 6 platforms ((GCC) 4.4.7 !20120313 (Red Hat 4.4.7-16)) is not recent enough to compile harmonie-40h1.1. gcc/gfortran, netCDF and HDF5 must be installed locally.

 * [Platform configuration](HarmonieSystemDocumentation/PlatformConfiguration): A general description of required configuration files and a summary of those already available in HARMONIE.

 * The compiling package for HARMONIE source code is called ''Makeup''. ''GMKPACK'' used within ALADIN is no longer supported in Harmonie and has been removed asn an option in CY43h2.
  * [Compilation using Makeup](HarmonieSystemDocumentation/Build_with_makeup): How to compile HARMONIE source code using ''Makeup''
 * Source code CPP macros explained [odt](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/cpp_macros.odt), [pdf](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/cpp_macros.pdf): Overview of cpp macros used in the source code of ARPEGE/IFS and ALADIN/AROME/HARMONIE - (CY36T1)

## Download input data
Before you can start running HARMONIE experiments some input data (external from the code repository) needs to be available on your platform. The input data contains physiography data, topography information and climatological values determined from a one year ARPEGE assimilation experiment with a resolution of T79.
  * [E923_DATA-release-43h2.beta.3.tar.gz](https://hirlam.org/portal/download/release-43h2.beta.3/E923_DATA-release-43h2.beta.3.tar.gz): Climate and physiography data for atmospheric climate generation (E923)
  * [PGD-release-43h2.beta.3.tar.gz](https://hirlam.org/portal/download/release-43h2.beta.3/PGD-release-43h2.beta.3.tar.gz): Physiography data for SURFEX (PGD)
  * [GMTED2010-release-43h2.beta.3.tar.gz](https://hirlam.org/portal/download/release-43h2.beta.3/GMTED2010-release-43h2.beta.3.tar.gz): Digital elevation model from [USGS](https://www.usgs.gov/)
  * [SOILGRID-release-43h.beta.3.tar.gz](https://hirlam.org/portal/download/release-43h2.beta.3/SOILGRID-release-43h.beta.3.tar.gz): Soil type data from [SOILGRIDS](https://soilgrids.org/)
  * [sat_const-release-43h2.beta.3.tar.gz](https://hirlam.org/portal/download/release-43h2.beta.3/sat_const-release-43h2.beta.3.tar.gz) : Constants for satellite information
  * [rttov7L54-release-43h2.beta.3.tar.gz](https://hirlam.org/portal/download/release-43h2.beta.3/rttov7L54-release-43h2.beta.3.tar.gz) : RTTOV constants
  * ECOCLIMAP second generation is available from [here](https://opensource.umr-cnrm.fr/projects/ecoclimap-sg/wiki). It's also available on {{{cca:/project/hirlam/harmonie/climate_in_order/ECOCLIMAP2G}}}
  * [Test data set with boundaries and observations for a small 50x50 domain](https://hirlam.org/portal/download/testbed/testbed-release-43h2.beta.3.tar.gz)

## Experiment Configuration
This section provides information on how to configure your HARMONIE experiment: definition of input/output locations, how to assimilate observations, define forecast cycles, post-processing options and much more! For the expert user there is information on how model namelists are set up HARMONIE.
 * [Configure your experiment](HarmonieSystemDocumentation/ConfigureYourExperiment) - setting of environment variables in [source:Harmonie/ecf/config_exp.h?rev=release-43h2.beta.3 ecf/config_exp.h] explained
 * [Finding the right namelist](HarmonieSystemDocumentation/Namelists): more details on the namelist settings in HARMONIE (if you are prepared to get your hands dirty!)

## Suite management
From cy43h2 ecflow is the only supported scheduler. Read more about the changes below.

 * [Pruning of mSMS](HarmonieSystemDocumentation/PruningOfmSMS)
 * [Running Harmonie under ECFLOW](HarmonieSystemDocumentation/ECFLOW)

## NWP Components
## Domain definition
 * [Model domain](HarmonieSystemDocumentation/ModelDomain): Horizontal model domain information
 * [Vertical grid](HarmonieSystemDocumentation/VerticalGrid): Vertical model level definitions
## Climate generation
  * [Climate Generation](HarmonieSystemDocumentation/ClimateGeneration)
  * [How to upgrade to high-resolution topography](HarmonieSystemDocumentation/How_to_use_hires_topography)
## Initial/boundary data
   * [Initial and Lateral Boundary Interpolation](HarmonieSystemDocumentation/BoundaryFilePreparation)
   * [Interpolations with gl](HarmonieSystemDocumentation/PostPP/gl/Interpolation)
## Observations
   * [Use of observations](HarmonieSystemDocumentation/UseofObservation) ([pdf](HarmonieSystemDocumentation/UseofObservation?format=pdfarticle)): selection of observation types and blacklisting using Bator
   * [Preprocessing of observation data](HarmonieSystemDocumentation/ObservationPreprocessing) ([pdf](HarmonieSystemDocumentation/ObservationPreprocessing?format=pdfarticle)): Introduction 
    * [ObservationData](HarmonieSystemDocumentation/ObservationPreprocessing/ObservationData) ([pdf](HarmonieSystemDocumentation/ObservationPreprocessing/ObservationData?format=pdfarticle)): Observation data
    * [Oulan](HarmonieSystemDocumentation/ObservationPreprocessing/Oulan) ([pdf](HarmonieSystemDocumentation/ObservationPreprocessing/Oulan?format=pdfarticle)): Oulan - extraction of conventional data and production of OBSOUL file read by BATOR
    * [Bator](HarmonieSystemDocumentation/ObservationPreprocessing/Bator) ([pdf](HarmonieSystemDocumentation/ObservationPreprocessing/Bator?format=pdfarticle)): Bator - preparation of ODBs used by data assimilation
    * [Cope](HarmonieSystemDocumentation/ObservationPreprocessing/Cope) ([pdf](HarmonieSystemDocumentation/ObservationPreprocessing/Cope?format=pdfarticle)): COPE - preparation of ODBs used by data assimilation - not available yet
   * Observation usage "how-tos":
     * [Atmospheric motion vectors](HarmonieSystemDocumentation/ObservationHowto/Amv) ([pdf](HarmonieSystemDocumentation/ObservationHowto/Amv?format=pdfarticle)): How to process and assimilate AMVs
     * [ATOVS radiances](HarmonieSystemDocumentation/ObservationHowto/Atovs) ([pdf](HarmonieSystemDocumentation/ObservationHowto/Atovs?format=pdfarticle)): How to process and assimilate ATOVS (AMSU-A and AMSU-B/MHS) radiances
     * [Scatterometer data](HarmonieSystemDocumentation/ObservationHowto/Scatt) ([pdf](HarmonieSystemDocumentation/ObservationHowto/Scatt?format=pdfarticle)): How to process and assimilate scatterometer observations
     * [(OPERA) radar data](HarmonieSystemDocumentation/RadarData) ([pdf](HarmonieSystemDocumentation/RadarData?format=pdfarticle)): Assimilate OPERA (HDF5) radar data
     * [GNSS ZTD data](HarmonieSystemDocumentation/ObservationHowto/GNSS) ([pdf](HarmonieSystemDocumentation/ObservationHowto/GNSS?format=pdfarticle)): How to process and assimilate GNSS ZTD data
     * [Mode-S EHS data](HarmonieSystemDocumentation/ObservationHowto/Modes) ([pdf](HarmonieSystemDocumentation/ObservationHowto/Modes?format=pdfarticle)): How to process and assimilate Mode-S EHS data

   * [ODB: software, data and visualization](HarmonieSystemDocumentation/StandaloneOdb) ([pdf](HarmonieSystemDocumentation/StandaloneOdb?format=pdfarticle))

## Data Assimilation
   * [Surface Data Assimilation](HarmonieSystemDocumentation/Analysis/SurfaceAnalysis) ([pdf](HarmonieSystemDocumentation/Analysis/SurfaceAnalysis?format=pdfarticle))
   * 3D-VAR:
    * [Structure functions](HarmonieSystemDocumentation/Structurefunctions_ensys): How to derive structure functions on cca (at ECMWF) ([pdf](HarmonieSystemDocumentation/Structurefunctions_ensys?format=pdfarticle))
    * [Screening](HarmonieSystemDocumentation/Screening): Quality control of observations task ([pdf](HarmonieSystemDocumentation/Screening?format=pdfarticle))
    * [Single observation test](HarmonieSystemDocumentation/SingleObs_ensys): How to run a single observation test ([pdf](HarmonieSystemDocumentation/SingleObs_ensys?format=pdfarticle))
    * [DA working week 200805](HarmonieDAWorkshop200805): Information out of date now?
    * [Observation operators (HOP_DRIVER)](HarmonieSystemDocumentation/ObservationOperators) ([pdf](HarmonieSystemDocumentation/ObservationOperators?format=pdfarticle))
   * Assimilation diagnostics:
    * [MTEN](HarmonieSystemDocumentation/MTEN)
    * [DFS](HarmonieSystemDocumentation/DFS)
    * Observation impact diagnostics [https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/DesroziersHarm.tar.gz]
    * [CHKEVO](HarmonieSystemDocumentation/CHKEVO): Diagnose forecast model spin-up of pressure

  * Impact of observation in data assimilation:
    * [Report on observation impact study in HARMONIE-AROME data assimilation](ObsImpact)
  
  * Short and long term plan for data assimilation:
    * [Selected tasks for data assimilation development](data_assimilation_plan)

## Digitial Filter Initialization
 * [Digitial Filter Initialization](HarmonieSystemDocumentation/DigitialFilterInitialization): Brief description of how to use DFI in HARMONIE. (Not used by default)
## Forecast Model
 * [Forecast model](HarmonieSystemDocumentation/Forecast): A description of the [source:Harmonie/scr/Forecast?rev=release-43h2.beta.3 Forecast script] and some of the more important namelist settings
 * [Model output](HarmonieSystemDocumentation/Forecast/Outputlist): Information on FA and GRIB output available from HARMONIE. (GRIB table information also included).
 * Forecast diagnostics:
  * [CHKEVO](HarmonieSystemDocumentation/CHKEVO): Diagnose forecast model spin-up of pressure

## Ensemble prediction (HarmonEPS)
  * [How to run an ensemble experiment](HarmonieSystemDocumentation/EPS/Howto)
  * [Ensemble mode in the script system](HarmonieSystemDocumentation/EPS/System)
  * [Available boundary strategies](HarmonieSystemDocumentation/EPS/BDSTRATEGY)
  * [Available test periods for HarmonEPS](HarmonieSystemDocumentation/EPS/Testperiods)
  * [How to use SLAF](HarmonieSystemDocumentation/EPS/SLAF)
  * [Surface perturbations](HarmonieSystemDocumentation/EPS/SurfacePerturbations)
  * [List of experiments for HarmonEPS paper 2018](HarmonieSystemDocumentation/EPS/Explist_paper)
  * [SPPT (under construction)](HarmonieSystemDocumentation/EPS/SPPT)
  * [SPP (under construction)](HarmonieSystemDocumentation/EPS/SPP)

## Climate simulations (HCLIM)
  * [How to run a climate simulation](HarmonieSystemDocumentation/ClimateSimulation)
  * [HARMONIE Climate](HarmonieClimate): communication of status, development and documentation of HARMONIE Climate (HCLIM)

## Single column model (MUSC)
 * [MUSC](HarmonieSystemDocumentation/MUSC): Compile & run MUSC

## Postprocessing
 * [Postprocessing overview](HarmonieSystemDocumentation/PostPP) 
   * [Convert data to GRIB](HarmonieSystemDocumentation/PostPP/FileConversions)
   * [Postprocessing with FULL-POS](HarmonieSystemDocumentation/PostPP/Fullpos)
   * [Postprocessing with gl_grib_api](HarmonieSystemDocumentation/PostPP/gl_grib_api)
   * [Postprocessing with xtool_grib_api](HarmonieSystemDocumentation/PostPP/xtool)
   * [Postprocessing with EPyGrAM](HarmonieSystemDocumentation/PostPP/EPyGrAM)
   * [Diagnostics](HarmonieSystemDocumentation/PostPP/Diagnostics)
   * [Obsmon](HarmonieSystemDocumentation/PostPP/Obsmon)
 * [Calibration](HarmonieSystemDocumentation/Calibration)

## Verification

 * [Extract data for verification](HarmonieSystemDocumentation/PostPP/Extract4verification)
 * [Deterministic verification (monitor)](HarmonieSystemDocumentation/PostPP/Verification)
 * [Ensemble verification (HARP)](HARP)
 * [Multi-model Observation Verification Intercomparison](HirlamSystemDocumentation/PostPP/CommonVerification)
 * [Observations monitoring](HarmonieSystemDocumentation/PostPP/Obsmon)

## Visualization
 * [EPyGrAM at ecgate](HarmonieSystemDocumentation/PostPP/EPyGrAM)

## System: For the hard core system staff
  * [Create new namelists](HarmonieSystemDocumentation/UpdateNamelists): How to create new namelists to be used by HARMONIE

  * [Harmonie testbed](HarmonieSystemDocumentation/Evaluation/HarmonieTestbed): The HARMONIE test environment used to test typical configurations on a small domain
  * [Trunk contribution form](HarmonieSystemDocumentation/Development/ContributionForm): Form to provide information to system people about new developments
  * [Phasing instructions](HarmonieSystemDocumentation/Phasing)
   * [Access to Météo-France servers](HarmonieSystemDocumentation/MFaccess)
   * [Mitraillette](HarmonieSystemDocumentation/Evaluation/Mitraillette)
   * [Preparing HIRLAM contributions for Phasing](HarmonieSystemDocumentation/ForwardPhasing)
  * [Phasing instructions with our git repository](HarmonieSystemDocumentation/PhasingWithGit)

   * svn -> git
    * current svn working practice related to CY40 and CY43 [https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/svn_working_practice.pdf]
    * about the (new) [Harmonie source code repository](HarmonieSystemDocumentation/SourceCodeRepository)

  * [Profiling with DrHook](HarmonieSystemDocumentation/DrHook): ECMWF's profiling and traceback tool included in the code
  * [HARMONIE RAPS benchmark](HarmonieSystemDocumentation/HarmonieBenchMark)
  * Meteo France/ECMWF 2011: [http://www.cnrm.meteo.fr/gmapdoc/spip.php?article213 Coding standards for ARPEGE-IFS]

  * [Scalability and refactoring](HarmonieSystemDocumentation/Scalability_and_Refactoring): Preliminary documents, presentations and links

  * Coordination documents
    * [http://www.cnrm.meteo.fr/aladin/spip.php?article219&lang=en OOPS & technical video meeting minutes]
    * [http://www.cnrm.meteo.fr/aladin/spip.php?article170&lang=en Coordination meeting minutes]
    * [http://www.cnrm.meteo.fr/aladin/spip.php?article124&lang=en Technical memorandums]

## Code browsers

  * [Code browsers (ftagshtml), 36h1.3, 37h1.1, 38h1.beta.1](https://hirlam.org/codebrowser/)
  * [Doxygen code browser (36h1.4)](https://hirlam.org/portal/doxygen_browser/cy36h1.4/)
  * [source:Harmonie Trac code browser]

## HARMONIE Reference materials

 * [http://www.cnrm.meteo.fr/gmapdoc/spip.php?rubrique1 ALADIN/Arome documentation]
 * [IFS documentation](https://www.ecmwf.int/en/forecasts/documentation-and-support/changes-ecmwf-model/ifs-documentation)
 * [http://www.cnrm-game-meteo.fr/surfex/ SURFEX documentation]

----


[[Center(end)]]