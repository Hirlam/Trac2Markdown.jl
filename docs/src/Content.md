```@meta
EditURL="https://hirlam.org/trac//wiki//Content?action=edit"
```


# Harmonie Content

## Overview

Harmonie is HIRLAM's adaptation of the LAM version of the IFS/ARPEGE project. The common code shared with the ALADIN program, Meteo France and ECMWF only contains the source code. Harmonie adds the build environment, scripts, support for a scheduler, and a number of diagnostics tools for file conversion and postprocessing. In summary a download of harmonie from the repository, [https://git.hirlam.org/Harmonie] contains the following main directories

 * config-sh : Configuration and job submission files for different platforms.
 * const : A selected number of constant files for bias correction, assimilation and different internal schemes. A large number of data for climate generation and the RTTOV software is kept outside of the repository. See [wiki:HarmonieSystemDocumentation#Downloaddata].
 * ecf : Directory for the main configuration file [config_exp.h](https://hirlam.org/trac/browser/Harmonie/ecf/config_exp.h) and the containers for the scheduler ECFLOW.
 * suites Scripts and suit definition files for mSMS, the scheduler for HARMONIE. 
 * nam : Namelists for different configurations.
 * scr : Scripts to run the different tasks.
 * src : The IFS/ARPEGE [source code](./Source.md).
 * [#util util] : A number of utilities and support libraries.

### util

 The util directory contains the following main directories

 * auxlibs : Contains gribex, bufr, rgb and some dummy routines
 * binutils : https://www.gnu.org/software/binutils/
 * checknorms : Script for code norm checking
 * gl_grib_api : Boundary file generator and file converter
 * makeup : HIRLAM style compilation tool
 * musc : MUSC scripts
 * obsmon : Code to produce obsmon sqlite files
 * offline : SURFEX offline code
 * oulan : Converts conventional BUFR data to OBSOUL format read by bator.
 * RadarDAbyFA : Field alignment code


----


