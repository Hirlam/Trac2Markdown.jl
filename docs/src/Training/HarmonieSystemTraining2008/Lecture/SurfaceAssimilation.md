```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2008/Lecture/SurfaceAssimilation?action=edit"
```

# HARMONIE Surface Data Assimilation
## Overview: main characteristics
## CANARI vs HIRLAM
### Source code structure
 * leve0 preparation
 * level1 preparation
 * Canari analysis steps
 * Canari analysis - the predictors
### Background Error
### Observation Handling
In HARMONIE DA CANARI is used for surface analysis. Therefore, theoretically, we only need [surface measurements](https://hirlam.org/trac/attachment/wiki/HarmonieSystemTraining2008/Lecture/ObsHandling/harmonie_obs_surface.png) in the ODB database. But, in practice, since CANARI can handle observations outside the central and inner zones (C+I), we rerun bator, fed with conventional observations, with special setting for lamflag part. CANARI needs also information about Sea Surface temperature (SST). In local implementations (Czech or Norway tests) SST field is taken from global surface analysis (ARPEGE for Czech and ECMWF for Norway). 
## CANARI Data flow
### CANARI analysis steps [here](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008/Lecture/DAdataflow#SurfaceanalysisCANARI)
### input/output data
## CANARI Implementation and Development
### status, problems, todos
So far CANARI runs with single processor. CANARI assumes that the first-guess is a 6-hour forecast (there is check on forecast length in the code) that causes problem when one try to use analysis file as first-guess. This case is mainly the start of any experiment. In HARMONIE system this problem is solved. Although positive impact was found in the Norway 11km domain, problem related to temperature increments near coastal lines were reported. The same problem was also reported from [Swedish test](https://hirlam.org/trac/wiki/HarmonieDAworkingweek200806#a1.HARMONIE3DVARadaptation). SST field was inserted into the first-guess field using blending technique. Ulf Andrae reported that possible reason of the problem is a deficiency in the interpolation technique used in GL for SST. Mariken succeeded to solve this problem avoiding the use of blending technique to insert the SST analysis into the guess filed. Instead, she read directly the SST-related fields in the model before the CANARI analysis with careful check of data using land/sea mask information. In her solution, she does not use the relaxation technique for 2m temperature analysis. See the improvement in the pictures below:
Fration of land
Temperature increments from surface analysis performed 4 June 2008 at 06 UTC, WITH missing values in some spots.
Temperature increments from surface analysis performed 4 June 2008 at 06 UTC.
Increments from surface analysis performed 5 June 2008 at 00 UTC (new ECMWF SST).
Result of surface analysis performed 5 June 2008 at 00 UTC (new ECMWF SST).
### How to run
[Here](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008/Lecture/DAdataflow#SurfaceanalysisCANARI) one can see how to run CANARI.
### Questions

### References
[Météo France documentation about CANARI](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article3)

[Cornel Soci, 2002; Code description - algorithms and data flow: CANARI](http://www.met.hu/pages/seminars/ALADIN2002/doc_canari.ps)

## [Hands on practice task](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008/Lecture/DAdataflow#Handsonpracticetask)

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)