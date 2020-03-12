```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2008/Lecture/General?action=edit"
```


# Harmonie System: Introduction

## What is HARMONIE
 * Harmonie is an abbreviation for "Hirlam-ALADIN Research on Mesoscale Operational NWP In Europe".
 * Harmonie system as appeared in the hirlam system repository consists of [source code, scripts and utilities](https://hirlam.org/trac/browser/trunk/harmonie) organised under various [system versions](https://hirlam.org/trac/browser), such as that of [trunk](https://hirlam.org/trac/browser/trunk/harmonie), [tagged releases](https://hirlam.org/trac/browser/tags) and [branches](https://hirlam.org/trac/browser/branches)
  * The source code is largely based on the released versions from Meteo France, such as cycle 33, cycle 33t1, which are featured in the hirlam repository as [vendor branches](https://hirlam.org/trac/browser/vendor/aladin)
  * [The scripts] (../../../HirlamSystemDocumentation/Mesoscale/HarmonieScripts.md), which are developed by HIRLAM. These originate partly from wrappers around name-lists examples for climate generation, forecast and data assimilation; partly from HIRLAM's own development on model (initial, lateral and surface) coupling, data conversion. The past one year has seen two major developments in scripting area: mini-SMS job control/script system, and scripts for data assimilation at cycling mode.
  * [Utilities](https://hirlam.org/trac/browser/trunk/harmonie/util), partly through own development, such as [GL](https://hirlam.org/trac/browser/trunk/harmonie/util/gl), [MONITOR/WebgraF](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor), partly through import of external tools, such as [gmkpack](https://hirlam.org/trac/browser/trunk/harmonie/util/gmkpack), [DDH](https://hirlam.org/trac/browser/trunk/harmonie/util/ddh), [OULAN](https://hirlam.org/trac/browser/trunk/harmonie/util/oulan), [SCUM](https://hirlam.org/trac/browser/trunk/harmonie/util/scum) etc.
 * HARMONIE system is aimed to be a complete NWP model system suitable for both research and operational use. Given observation and lateral boundary data, it shall be able to run as an independent system that covers full NWP production chain: from build, run to post-processing, diagnosis and verification.
 * HARMONIE system is version controlled using [Subversion] (../../../HirlamHowto/Svn/Subversion.md).

----
 
## Harmonie in comparison to HIRLAM system 
(a perspective for HIRLAM veterans...) 
## HARMONIE features: data structure

 === NWP aspects ===

 * ALADIN is a H/NH spectral model.
 * lambert, polar stereographic, (rotated) mercator projection
 * Large variety of physical parameterizations ALADIN/HIRALD/ALARO/AROME
 * 3(4)Dvar upper air analysis
 * OI based surface analysis, CANARI

 === FA files ===

 Internal format for ARPEGE/ALADIN for gridpoint or spectral data. GRIB is used as a way to pack data, but the grib record cannot be used as such.

 * The header contains information about model domain, projection, spectral truncation, extension zone, boundary zone, vertical levels. 
 * Only one date/time per file.
 * FA routines are found under xrd/fa
 * List with gl or frodo.
 * [gmapdoc](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=FA+)

 === LFI files ===

 File format for SURFEX/MESO-NH
 
 * LFI routines for handling direct-access files under xrd/lfi
 * No packing ?
 * List with gl
 * [gmapdoc](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=LFI)
 
### GRIB

 * Harmonie is not using ASIMOF GRIB. 
 * Table one is used and generously extended

 === BUFR and ODB ===

 BUFR is the archiving /exchange format for observations. Observation Database is used for efficient handling of observations on IFS. ODB used for both input data and feedback information.

 === DDH (LFA files ) ===

 Diagnostics by Horizontal Domains allows you to accumulate fluxes from different packages over different areas/points. 
 
 * LFA files ( Autodocumented File Software )
 * [gmapdoc](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article44&var_recherche=LFA&var_lang=en)
 * under util/ddh

 === Misc ===
 
 * vfld/vobs files in a simple ASCII format.


----

## Harmonie system components and features
 * [Climate generation] (../../../HirlamSystemDocumentation/Mesoscale/HarmonieScripts#Climategeneration.md): (SURFEX still unresolved issue with source code absent from the system)
 * [Initial and lateral/surface boundary data preparation] (../../../HirlamSystemDocumentation/Mesoscale/HarmonieScripts#Boundaryfilepreparation.md), post-processing using GL
 * [Forecast model] (../../../HarmonieSystemTraining2008/Lecture/Forecast.md), in principle the ALADIN model within the IFS framework, with following physics packages
  * ALADIN: closest to ALADIN-MF physics, normally run for models with 10km scale, hydrostatic or nonhydrostatic
  * HIRALD: same as above but with HIRLAM 7.1 parameterisation on turbulence, cloud and condensation, radiation schemes. This is a pure HIRLAM development, but maybe ad hoc.
  * ALARO:  an ALADIN development designed to be suitable also for grey zone (~5 km). Currently operational at CHMI (7.5 km?) and runs daily at SMHI at 5 km
  * AROME:  ALADIN dynamics + meso-NH physics targeted for km-scale resolution, currently near-operational at Meteo France (2.5 km) and runs daily at main HIRLAM services
  * SURFEX: an externalized surface scheme suitable to be used for all the above model/resolutions. It as first introduced for AROME, and recently it has been made possible to run with ALADIN/ALARO physics also.
 * [Data assimilation: observation data handling, CANARI and 3DVAR] (../../../HarmonieSystemTraining2008/Lecture/DAdataflow.md)
  * The work initiated at met.no, with active participation by system group this year

----

## HARMONIE mini-SMS script
 * In ALADIN cooperation, job scripts including that of name-lists for system components (data preparation, assimilation, forecast, posp-processing) are not considered an integrated part of the system source, and thus no scripts or name-list examples are packed in the standard system release ('export' version). HIRLAM considers script as part of the source and is determined to establish a complete system with harmonised system scripts as an integrated part. 
 * Hirlam script development started in 2005/2006 when HIRLAM pioneers started implementing ALADIN forecast system locally. Independently, met.no staffs introduced scripts in order to perform cycled experiment including surface and upper air data assimilation.
 * In Sept 2007, the [system working meeting] (../../../SystemWorkingmeeting200709.md) of the HIRLAM system group decided to develop HIRLAM-like mini-SMS script for HARMONIE system. In December 2007, the first mini-SMS script system, [32h3] (../../../Harmonie_32h3.md), was released, including the installation and build using gmkpack. In April 2008, the mini-SMS script was extended to the data assimilation and cycling components in [33h0] (../../../Harmonie_33h0.md). The system has been further enhanced in [33h1] (../../../Harmonie_33h1.md) as released in June 2008.
 * [HARMONIE mini-SMS script system] (../../../HirlamSystemDocumentation/Mesoscale/HarmonieScripts.md) has full coverage of the NWP system procedure, from installation, configuration, build, data preparation, cycled runs to post-processing and verification. It has so far been tested on various HIRLAM computation platforms. The script including name-list settings are version controlled in similar way as for the source code.

----

## Development of HARMONIE utilities
HARMONIE system contains several utility programmes which are developed by HIRLAM staffs (mainly Ulf Andrae), which are included as integrated part of the HARMONIE system.
 * HARMONIE GRIB data conversion tool GL, with numerous additional post-processing and diagnosis functionalities
 * MONITOR, a collection of statistics and data manipulation tools for monitoring of model runs
 * WEBGRAF: Web-based graphic display interface using java-script
 * XTOOL: GRIB manipulation tool for calculation of difference fields etc. 
These tools are not limited to handle HARMONIE data. e.g, GL and MONITOR have recently been adopted as software basis for conducting common model inter-comparison and observation verification

## Harmonie Documentation

The main documentation source for HARMONIE system is [documentation portal] (../../../HarmonieSystemDocumentation.md) at the HIRLAM system wiki. Most of the presentation materials prepared for this training workshop will be used/linked directly there.

The main documentation format will be in wiki, with the purpose to encourage all developers and users to contribute easily.

It is important that documentation and instructions are maintained and updated timely. Version-dependent documentation materials need to be version controlled and go together with released system versions. Currently there exists numerous gaps in system documentation, and we hope to fill in the gaps soon. After that we shall consider to compile and release version-tagged documentation. User-manual shall become an integrated part of the HARMONIE system that accompanies with each release/version. For stand-alone documentation/instruction materials, it is important to specify clearly the model versions that the documentation are prepared for.

----

## Real time HARMONIE forecast systems
 * DMI, SMHI and FMI started real-time, forecast-only runs since 2005/2006. Currently [real time HARMONIE system (at uncycled mode)] (../../../HirlamInventory/HarmonieSystem.md) is run daily at most HIRLAM services.  
  * 
```bash
#!html
<a href="https://hirlam.org/portal/dmi/dmiald/forecasts/"  target="_blank">
DMI's real time ALADIN suite</a>
```
  * 
```bash
#!html 
<a href="http://fminwp.fmi.fi/ALADIN/" target="_blank">
FMI's real time ALADIN suite</a>
```
  * 
```bash
#!html 
<a href="http://fminwp.fmi.fi/AROME/" target="_blank">
FMI's real time AROME suite</a>
```
  * 
```bash
#!html 
<a href="http://hirlam.org/portal/smhi/WebgraF/" target="_blank">SMHI's real time ALADIN/AROME suite</a> 
```
 * met.no and SMHI likely to start cycled HARMONIE runs with DA by the end of this year
### **Web interface for real-time operational HIRLAM model monitoring and inter-comparison**
 * HIRLAM operational services recently started [joint monitoring and verification] (../../../oprint/general.md) at hirlam.org. It is an interesting topic about if a joint data portal is also relevant for HARMONIE real time system.

----

## Hirlam/HARMONIE System Management
 * Hirlam system group
  * Hirlam and HARMONIE systems are managed by Hirlam system group, consisting of a group of HIRLAM developers with system and scientific expertises. The work is lead by HIRLAM project leader on applications
  * The main mission of the system project is to provide to HIRLAM community a good technical platform for convenient, reliable and efficient system development
  * The core system group with privileges to commit directly source code and script changes into the hirlam source code repository, is expanding during past years. The long term vision is to bring the hirlam system management in style of open source software system management, in which developers are encouraged to make more use of revision control tool for an improved efficiency. 
 * Source code management with Subversion tools
  * Main new features are subject to code revision procedure in which HIRLAM MG and project leaders are involved
  * Communication aspects. HIRLAM system repository is quite visible to the entire community
   * system wiki (code browser, release notes, instructions, system documentations, references, workshop materials etc.)
   * mailing list (harmonie@hirlam.org; system@hirlam.org, dev@hirlam.org, operational@hirlam.org, etc.)

----

## Harmonie System Releases and strategy on phasing
 * The tagged HARMONIE system version is named in form of HARMONIE 3*h*, such as 33h1, where "h" stands for hirlam.
  * Common cycle. ECMWF and Meteo France jointly release, at a certain interval, IFS(Integrated Forecast System)/Arpege common code, referred to as Cycle "XX" where XX is 35 for the latest release.
  * Interim cycle. After a common cycle is declared, ECMWF and MF normally work out a few interim cycles to introduce new features. e.g., Cycle 33r2 is the second interim cycle released by ECMWF ("r" refers to Reading) after common cycle 33. Cycle 33t1 is the first MF interim cycle released by Meteo France ("t" refers to Toulouse) after Cycle 33. The release of interim cycles are mostly independent between MF and ECMWF, and there exists normally no correspondence between interim cycles released from ECMWF and from MF. e.g, new features introduced in 33r2 is not likely to appear in 33t2, and vice versa. Instead, new features introduced in the interim cycles are likely to be seen in the next common cycle.
  * Phasing. Up till now the Reading cycles are exclusively about global model. MF interim cycles normally contain not only the one for global model (Arpege) but also the updates about LAM system --- ALADIN. The code adaptation and merging of ALADIN system code are largely dominated by Meteo France, although ALADIN, and lately also HIRLAM communities are invited to contribute to the process. This occurs most often in form of 'phasing', during which selected ALADIN and HIRLAM staffs are invited to visit MF to participate in code merge, test and evaluation work at the spot, for a stay of one to 6 weeks. The phasing work normally results in release of new interim cycles. 
  * Hirlam strategy in participation of phasing.  Although phasing as practiced in MF/ALADIN community is not the norm in HIRLAM system development, HIRLAM is committed to contribute to the MF/ALADIN phasing activities. Apart from fulfilling the typical phasing tasks (code mergting, testing and debugging, validation), HIRLAM wishes to push for increased use of ECMWF platform for testing and evaluation tasks, and combine the phasing tasks with that of the adaptation work of new code cycles into HARMIONIE system, with an aim to eventually realise simultaneous release of HARMONIE model with that at MF
 * At current stage we aim to pack and release tagged HARMONIE systems that follow closely the release cycles at Meteo France, (2-4 times a year)
 * In addition to released systems, the Hirlam system repository also contains collection of development codes which undergoes daily update
  * trunk version, targeted code for next tagged release
  * development branches
  * vendor branches
  * national/operational branches?

----

## HARMONIE system plan
 * HARMONIE system release plan
  * Oct 2008: HARMONIE 35h0
  * Dec 2008: HARMONIE 35h1?
 * Development of HARMONIE system test and evaluation facility
  * It is a heavy task to keep up with the pace of the tagged cycles at ECMWF/MF. Lack of experience and suitable tools for mesoscale system, and the frequent version update from upstream source, make it difficult for systematic evaluation. There is hence a urgent need to develop suitable test and evaluation tools which are designed for HARMONIE system (for HARMONIE scripts and HIRLAM scenarios). This will be pursued in 2009 as a major development task.
 * Discussion about HARMONIE reference system
  * Reference HIRLAM system and its operational realisation, RCR, has proven to be a success. Some time along the road a 'reference' HARMONIE system shall be defined. How shall such a reference system take shape? There are many questions need to be answered.

 * Work on computation efficiency aspects
  * HARMONIE system is very expensive to run. We need to start thinking about profiling information, locate bottle necks; find weak links where we can improve.

 * Extension of HARMONIE system scripts
  * Discussions about extension/upgrade to SMS. Kai already started working on HIRLAM-system side...
  * Prep-HARMONIE is an attractive feature. What kind of priority shall it be given?
## Consortia cooperation aspects
 * ALADIN is our partner in research area
  * More joint planning in research project
 * LACE is also an interesting partner in terms of system and operational aspects.
  * Some proposals already on scientific research area. Joint work on model coupling issue: large scale, surface coupling, initialisation
  * Tools for verification and routine monitoring etc. are obvious area for sharing and joint development
  * Documentation, instruction and discussion forum benefit all
  * Exchange of monitoring data?
  * Exchange on ideas about operational cooperation?
  * Training: we are already doing that...
  * Joint development of HARMONIE system? HIRLAM welcome!

## *Questions & issues related to the current topics* 
 * **Trunk vs tagged releases: which one to use? What's the recommendation**?
  * Users that are interested to use HARMONIE/HIRLAM system to study on certain issues, are always advised to use tagged releases instead of trunk. The latter is an evolving program branch that is not much tested even technically
  * There are however needs for developers to learn using trunk versions
     * If they work with phasing mission or with merging of new development
     * If they want to submit/commit new code to the coming system
 * **What is pgd? I can't do climate generation locally**?
  * Yes climate generation is doable IF one does not run SURFEX and if one has download locally the climate data set (available on "ec:/rmt/clim_database".
  * It is currently not possible to do full climate generation if your model configuration include SURFEX, because currently HIRLAM has not yet got the source code for doing climate generation related to SURFEX. At ECMWF, the needed executible PGD is acquired from the MF directory. Since SURFEX is used per default in AROME runs, in order to install AROME model locally, we need at the moment a work-around to solve the issue: run first AROME runs at ECMWF platform to produce all the necessary climate files including that of SURFEX, and download them. Then, in local implementation, put Make_climate to 'no'.

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)