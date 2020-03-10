```@meta
EditURL="https://hirlam.org/trac//wiki/Training/HarmonieSystemTraining2008/Lecture/DomainAndCoupling?action=edit"
```

# HARMONIE climate generation, domain selection and model coupling

## Construction of model domain
 * [selection from config_exp.h](../../../HirlamSystemDocumentation/Mesoscale/HarmonieScripts.md#Modeldomainsettings)
 * construction of new model domain: what to consider
## Climate Generation

 * [Climate Generation](../../../HirlamSystemDocumentation/Mesoscale/HarmonieScripts.md#Climategeneration)
 * [e923 documentation on gmapdoc](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=e923)
 * [Projections](http://www.cnrm.meteo.fr/gmapdoc/spip.php?rubrique24)
 * [Presentation from J.D. Grill](http://www.cnrm.meteo.fr/gmapdoc/spip.php?article108)
 
## Model nesting

  * [Boundaryfile Preparation](../../../HirlamSystemDocumentation/Mesoscale/HarmonieScripts.md#Boundaryfilepreparation)

### Interpolation with gl

 gl has two different LBC scenarios, data from HIRLAM or ECMWF.

   *  setup_ecmwf.f90/ec2ald.f90
   *  setup_aladin.f90/hl2ald.f90

In the setup a list of fields to be read and interpolated are defined. The second routine does the job.

       * Setup list of fields
       * Define geometry by reading the climate fields
       * Make averages over tiles.
       * Interpolate horizontally (bilinear)
       * Vertical interpolation, same as in HIRLAM
       * Recalculate surface variables ( new by Alex Deckmyn, currently removed from trunk )
       * transform to spectral space (where needed)
       * output to FA


For the atmosphere the required fields are: Q,T,U,V,PS,ORO. Optional fields like TKE,Ql,Qr,Qs,Qh,... defined by ATMKEY in the 
[namelist](https://hirlam.org/trac/browser//trunk/harmonie/scr/hir2ald#L34). If you need these or not depends on the choice in the forecast model 
[namelist](https://hirlam.org/trac/browser//trunk/harmonie/nam/namelist_fcstald_h_default#L238)

 * Deficiencies
       * No LSM check applied yet
       * No calculation of vertical divergence for NH case, set to zero

### Interpolation with fullpos

 Fullpos is used for interpolation when we go from ALADIN to ALADIN/AROME
 source:/trunk/harmonie/nam/namelist_ald2arome_N_default#L114
 
 * [gmpadoc](http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=ee927)

## [Hands on practice task](../../../HarmonieSystemTraining2008/Training/DomainAndCoupling.md)
## Reference Links

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)