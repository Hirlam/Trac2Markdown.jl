```@meta
EditURL="https://hirlam.org/trac//wiki//Source?action=edit"
```


# Harmonie Source Code
## Introduction
This wiki page summaries the ARPEGE/IFS source code made available in the HARMONIE system. It is based on documents made available by YESSAD K. (METEO-FRANCE/CNRM/GMAP/ALGO). The relevant document for cycle 40 is available here: [http://www.cnrm.meteo.fr/gmapdoc//spip.php?article171](http://www.cnrm.meteo.fr/gmapdoc//spip.php?article171) (or directly here: [http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykarchi40t1.pdf](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykarchi40t1.pdf)). Documents for other versions are available in the ["References and documentation" section](./Source#Referencesanddocumentation.md). This page used the 40T1 document.

## HARMONIE Source Library Structure
The main source of HARMONIE system originates from IFS/ARPEGE and it consists of a number of "project" sources. These are:
   * aeolus: Aeolous source code, a package for pre-processing satellite lidar wind data. **Inactive for us**.
   * aladin: specific routines only relevant to LAM, (limited area models, in particular ALADIN and AROME).
   * algor: application routines, e.g. to read LFI or Arpege files,interface routines for distributed memory environment, some linear algebra routines, such as lanczos algorithm, minimizers.
   * arpifs: global model routines (ARPEGE, IFS), and routines common to global and LAM models. This is the core of the ARPEGE/IFS software. The core of ARPEGE/IFS software.
   * biper: Biperiodization routines for the LAM
   * blacklist: package for blacklisting
   * coupling: lateral coupling and spectral nudging for LAM models
   * etrans: spectral transforms for plane geometry, used for LAM
   * ifsaux: some application routines, for example reading or writing on “LFI” or ARPEGE files, interface routines for distributed memory environment
   * mpa: upper air meso-NH/AROME physics (also used in ARPEGE/ALADIN)
   * mse: surface processes in meso-NH/AROME (interface for SURFEX)
   * odb: ODB (Observational Data Base software), needed by ARPEGE/ALADIN for their analysis or their assimilation cycle
   * satrad: satellite data handling package, needed to run the model analysis/assimilation
   * surf: ECMWF surface scheme
   * surfex: surface processes in meso-NH/AROME - the externalized surface scheme SURFEX
   * trans: spectral transforms for spherical geometry, used for ARPEGE/IFS
   * utilities: utility packages, for operational FA to GRIB (PROGRID), OULAN, BATOR, or programs to operate on ODB and radiances bias correction

## Dependencies and hierarchy between each project
Note: these project names are no longer valid -- need to update
 * ARP+TFL+XRD+XLA+MPA+MSE+SURFEX: for ARPEGE forecasts with METEO-FRANCE physics.
 * ARP+ALD+TFL+TAL+XRD+XLA+BIP+MPA+MSE+SURFEX: for ALADIN or AROME forecasts.
 * ARP+TFL+XRD+XLA+SUR: for IFS forecasts with ECMWF physics.
 * ARP+TFL+XRD+XLA+MPA+MSE+SURFEX+BLA+ODB+SAT+AEO: for ARPEGE assimilations with METEO-FRANCE physics.
 * ARP+ALD+TFL+TAL+XRD+XLA+BIP+MPA+MSE+SURFEX+BLA+ODB+SAT+AEO: for ALADIN or AROME assimilations.
 * ARP+TFL+XRD+XLA+SUR+BLA+ODB+SAT+OBT+SCR+AEO: for IFS assimilations with ECMWF physics.

## Libraries under each project
Note: this information made need to be updated for CY40
### ARPIFS
 * adiab
  * Adiabatic dynamics
  * Adiabatic diagnostics and intermediate quantities calculation, for example the geopotential height (routines GP... or GNH...).
  * Eulerian advections
  * Semi-Lagrangian advection and interpolators (routines LA...)
  * Semi-implicit scheme and linear terms calculation (routines SI..., SP..SI..)
  * Horizontal diffusion (routines SP..HOR..)
 * ald inc
  * function: functions used only in ALADIN
  * namelist: namelists read by ALADIN.
 * c9xx: specific configurations 901 to 999 routines (mainly configuration 923). Routines INCLI.. are used in configuration 923. Routines INTER... are interpolators used in configurations 923, 931, 932.
 * canari: routines used in the CANARI optimal interpolation. Their names generally starts by CA.
 * canari common: empty directory to be deleted.
 * climate: some specific ARPEGE-CLIMAT routines.
 * common: often contains includes
 * control: control routines. Contains in particular STEPO and CNT... routines.
 * dfi: routines used in the DFI (digital filter initialisation) algorithm
 * dia: diagnostics other than FULL-POS. One finds some setup SU... routines specific to some diagnostics and some WR... routines doing file writing.
 * function: functions (in includes). The qa....h functions are used in CANARI, the fc....h functions are used in a large panel of topics.
 * interface: not automatic interfaces (currently empty).
 * kalman: Kalman filter.
 * module: all the types of module (variables declarations, type definition, active code).
 * mwave: micro-wave observations (SSM/I) treatment.* namelist: all namelists.
 * nmi: routines used in the NMI (normal mode initialisation) algorithm.
 * obs error: treatment of the observation errors in the assimilation.
 * obs preproc: observation pre-processing (some of them are called in the screening).
 * ocean: oceanic coupling, for climatic applications.
 * onedvar: 1D-VAR assimilation scheme used at ECMWF.
 * parallel: parallel environment, communications between processors.
 * parameter: empty directory to be deleted.
 * phys dmn: physics parameterizations used at METEO-FRANCE, and HIRLAM physics, ALARO physics.
 * phys ec: ECMWF physics. Some of these routines (FMR radiation scheme, Lopez convection scheme) are now also used in the METEO-FRANCE physics.
 * pointer: empty directory to be deleted.
 * pp obs: several applications
  * observation horizontal and vertical interpolator. 
  * FULL-POS. 
  * vertical interpolator common to FULL-POS and the observation interpolator; some of these routines may be used elsewhere.
 * setup: setup routines not linked with a very specific domain. More specific setup routines are spread among some other subdirectories.
 * sinvect: singular vectors calculation (configuration 601).
 * support: empty directory to be deleted.
 * transform: hat routines for spectral transforms.
 * utility: miscellaneous utilitaries, linear algebra routines, array deallocation routines.
 * var: routines involved in the 3DVAR and 4DVAR assimilation, some minimizers (N1CG1, CONGRAD), some specific 3DVAR and 4DVAR setup routines.
 * wave: empty directory to be deleted.
### ALADIN
 * adiab: adiabatic dynamics.
 * blending: blending scheme (currently only contains the procedure blend.ksh).
 * c9xx: specific configurations E901 to E999 routines (mainly configuration E923). Routines EINCLI.. are used in configuration E923. Routines EINTER... are interpolators used in configurations E923, E931, E932.
 * control: control routines.
 * coupling: lateral coupling by external lateral boundary conditions.
 * dia: diagnostics other than FULL-POS.
 * inidata: setup routines specific to file reading (initial conditions, LBC).
 * module: active code modules only used in ALADIN.
 * obs preproc: observation pre-processing (some of them are called in the screening).
 * parallel: parallel environment, communications between processors.
 * pp obs: several applications:
  * observation horizontal and vertical interpolator. 
  * FULL-POS.
  * vertical interpolator common to FULL-POS and the observation interpolator; some of these routines may be used elsewhere.
 * programs: probably designed to contain procedures, but currently contains among others some blending routines, the place of which would be probably better in subdirectory "blending".
 * setup: setup routines not linked with a very specific domain. More specific setup routines are spread among some other subdirectories.
 * sinvect: singular vectors calculation (configuration E601).
 * transform: hat routines for spectral transforms.
 * utility: miscellaneous utilitaries, array deallocation routines.
 * var: routines involved in the 3DVAR and 4DVAR assimilation, some specific 3DVAR and 4DVAR setup routines.
### TFL
 * build: contains procedures.
 * external: routines which can be called from another project.
 * interface: not automatically generated interfaces which match with the "external" directory routines.
 * module: all the types of module (variables declarations, type definition, active code).
  * tpm ...F90: variable declaration + type definition modules. 
  * lt.... mod.F90: active code modules for Legendre transforms. 
  * ft.... mod.F90: active code modules for Fourier transforms. 
  * tr.... mod.F90: active code modules for transpositions. 
  * su.... mod.F90: active code modules for setup.
 * programs: specific entries which can be used for TFL code validation. These routines are not called elsewhere.   
### TAL 
 * external: routines which can be called from another project.
 * interface: not automatically generated interfaces which match with the "external" directory routines.
 * module: all the types of module (variables declarations, type definition, active code). 
  * tpmald ...F90: variable declaration + type definition modules. 
  * elt.... mod.F90: active code modules for N-S Fourier transforms. 
  * eft.... mod.F90: active code modules for E-W Fourier transforms. 
  * sue.... mod.F90: active code modules for setup. 
 * programs: specific entries which can be used for TAL code validation. These routines are not called elsewhere.                                                             
### XRD 
 * arpege: empty directory to be deleted.
 * bufr io: BUFR format files reading and writing.
 * cma: CMA format files reading and writing.
 * ddh: DDH diagnostics.
 * fa: ARPEGE (FA) files reading and writing.
 * grib io: ECMWF GRIB format files reading and writing.
 * grib mf: METEO-FRANCE GRIB format files reading and writing.
 * ioassign: empty directory to be deleted.
 * lanczos: linear algebra routines for Lanczos algorithm.
 * lfi: LFI format files reading and writing.
 * minim: linear algebra routines for minimizations. Contains the M1QN3 (quasi-Newton) minimizer.
 * misc: miscellaneous decks.* module: all the types of module (variables declarations, type definition, active code). There are a lot of mpl...F90 modules for parallel environment (interface to MPI parallel environment).
 * mrfstools: empty directory to be deleted.
 * newbufrio: empty directory to be deleted.
 * newcmaio: empty directory to be deleted.
 * not used: miscellaneous decks (unused decks to be deleted?).
 * pcma: empty directory to be deleted.
 * support: miscellaneous routines. Some of them do Fourier transforms, some others do linear algebra.
 * svipc: contains only svipc.c .
 * utilities: miscellaneous utilitaries.
### SUR
 * build: contains procedures.
 * external: routines which can be called from another project.* function: specific functions.
 * interface: not automatically generated interfaces which match with the "external" directory routines.
 * module: all the types of module (variables declarations, type definition, active code).
  * yos ...F90: variable declaration + type definition modules. 
  * su.... mod.F90 but not surf.... mod.F90: active code modules for setup. 
  * surf.... mod.F90, v.... mod.F90: other active code modules.
 * offline: specific entries which can be used for SUR code validation. These routines are not called elsewhere.
### BLA
 * compiler.
 * include: not automatically generated interfaces, functions, and some other includes.
 * library: the only containing .F90 decks.
 * old2new.
 * scripts.
### SAT
 * bias.
 * emiss.
 * interface.
 * module.
 * mwave.
 * onedvar.
 * pre screen.
 * rtlimb.
 * rttov.
 * satim.
 * test. (Not described in detail; more information has to be provided by someone who knows the content of this project, but there is currently no specific documentation about this topic)
### UTI
 * add cloud fields: program to add 4 cloud variables (liquid water, ice, rainfall, snow) in ARPEGE files.
 * bator: BATOR software (reads observations data in a ASCII format file named OBSOUL and the blacklist, writes them on a ODB format file with some additional information).
 * combi: combination of perturbations in an ensemble forecast (PEARP).
 * controdb: control of the number of observations.
 * extrtovs: unbias TOVS.
 * fcq: does quality control and writes this quality control in ODB files.
 * gobptout: PROGRIB? (convert ARPEGE files contained post-processed data into GRIB files).
 * include: all .h decks (functions, COMMON blocks, parameters).
 * mandalay: software MANDALAY.
 * module: all types of modules.
 * namelist: namelists specific to the applications stored in UTI (for example OULAN, BATOR).
 * oulan: OULAN software (the step just before BATOR: observation extractions in the BDM, samples data in space and time, and writes the sampled data in an ASCII file called "OBSOUL").
 * pregpssol: Surface GPS processing.
 * prescat: Scatterometer data processing.
 * progrid: PROGRID? (convert ARPEGE files contained post-processed data into GRIB files).
 * progrid cadre: cf. progrid?
 * sst nesdis: program to read the SST on the BDAP. This project has its own entries.
### MPA
It contains first layer of directory
 * chem: chemistry.
 * conv: convection.
 * micro: microphysics.
 * turb: turbulence.
Each directory contains the following subdirectories
  * externals: routines which can be called from another project.
  * include: all the "include" decks (functions, COMMON blocks, parameters).
  * interface: not automatically generated interfaces which match with the "external" directory routines.
  * internals: other non-module routines; they cannot be called from another project.
  * module: all types of modules.

### SURFEX

 * ASSIM: Surface assimilation routines (please note that programs soda.F90, oi_main.F90 and varassim.F90 are located under mse/programs).
 * OFFLIN: Surface offline routines (please note that programs pgd.F90, prep.F90 and offline.F90 are located under mse/programs).
 * SURFEX: Surface routines for physiography (PGD), initialisation (PREP) and physical processes including e.g. land (ISBA), sea, town (TEB) and lakes.
 * TOPD: TOPMODEL (TOPography based MODEL) for soil hydrology.
 * TRIP: River routing model TRIP

### MSE
 * dummy: empty versions of some routines.
 * externals: routines which can be called from another project.
 * interface: not automatically generated interfaces which match with the "external" directory routines.
 * internals: other non-module routines; they cannot be called from another project.
 * module: all types of modules.
 * new: file conversion routines, e.g. fa2lfi, lfi2fa
 * programs: SURFEX programs

## References and documentation
 * Yessad K.: Jul 2015: [LIBRARY ARCHITECTURE AND HISTORY OF THE TECHNICAL ASPECTS IN ARPEGE/IFS, ALADIN AND AROME IN THE CYCLE 42 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykarchi42.pdf)
 * Yessad K.: Mar 2014: [LIBRARY ARCHITECTURE AND HISTORY OF THE TECHNICAL ASPECTS IN ARPEGE/IFS, ALADIN AND AROME IN THE CYCLE 40T1 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykarchi40t1.pdf)
 * Yessad K.: Jul 2013: [LIBRARY ARCHITECTURE AND HISTORY OF THE TECHNICAL ASPECTS IN ARPEGE/IFS, ALADIN AND AROME IN THE CYCLE 40 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc//IMG/pdf/ykarchi40.pdf)
 * Yessad K.: Nov 2011: [BASICS ABOUT ARPEGE/IFS, ALADIN AND AROME IN THE CYCLE 38 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc/IMG/pdf/ykarpbasics38.pdf)
 * Yessad K.: Nov 2011: [LIBRARY ARCHITECTURE AND HISTORY OF THE TECHNICAL ASPECTS IN ARPEGE/IFS, ALADIN AND AROME IN THE CYCLE 38 OF ARPEGE/IFS](http://www.cnrm.meteo.fr/gmapdoc/IMG/pdf/ykarchi38.pdf)


----


