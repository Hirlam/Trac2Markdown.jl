```@meta
EditURL="https://hirlam.org/trac//wiki//ObservationHowto/Scatt?action=edit"
```

# Scatterometers

## Background
The EUMETSAT [OSI SAF](http://projects.knmi.nl/scatterometer/osisaf/) produces different scatterometer wind products at KNMI and more will become available in 2019:

        - C-band ASCAT-A/B/C overpassing at 9:30/21:30 Local Solar Time (LST), since 2007/2011/2019;
         - Ku-band !ScatSat overpassing at 8:45/20:45 LST, since 2017;
         - Ku-band HY2A/B overpassing at 6:00/18:00 LST, since 2013 (n.a. in NRT)/2019;
         - Ku-band CFOSAT overpassing at 7:00/19:00 LST, expected 2019;
         - Ku-band OSCAT3 overpassing at 12:00/24:00, expected 2019;
         - C/Ku-band !WindRad overpassing at 6:00/18:00, expected 2020.

Note that the products have different ambiguity and noise properties, that are handled in the generic KNMI processing. We distinguish two types of scatterometers with (1) static beams (ASCAT) and with (2) rotating beams (the rest).

In the ECMWF model (on ~200 km scales) the availability of three hourly observations is motivated from the experience of assimilating ASCAT and OSCAT (2.5 hours overpass time difference), which showed double the impact of assimilating ASCAT only. So, they appear as independent data sources for the model.

Since ASCAT overpasses only twice per day we cannot fulfil the temporal requirement and can therefore not expect to analyze open ocean surface winds deterministically at 25 km scales with ASCAT only. Based on this analysis we should therefore focus on larger than 25 km scales (as ECMWF does), also for Harmonie, so typically focus on 100 km scales. This means that scales between ~25-100 km in Harmonie over open sea is mostly noise, which can be removed through supermodding (ref: Mate Mile's project). Note that more scatterometers will be available next year at more times a day (see above).

ECMWF is testing ASCAT with different aggregation, thinning and weights in order to optimize scatterometer data assimilation, which results may be useful for HARMONIE data assimilation strategy as well.

## ASCAT
 1. ASCAT-12.5km (or ASCAT-coastal) data are available on a 12.5 km grid.
 1. The resolution of ASCAT-12.5km is about 25 km (through the application of a Hanning with tails extending beyond 12.5 km)
 1. As a result, the errors of neighbouring observations are correlated. For the 6.25 km product:
   * along-track wind component **l** : neighbor 0.60; next-neighbor 0.19; next-next neighbor 0.02; total noise variance 0.385
   * cross-track wind component **t** : neighbor 0.51; next-neighbor 0.11; next-next neighbor 0.00; total noise variance 0.214
  This agrees well with the footprint overlap (see point 2). We expect similar values for ASCAT-12.5km, but this could be easily assessed more dedicated.
 1. Triple collocation tests show obervation error standard deviation for ASCAT-12.5km (or ASCAT-coastal) of ~ 0.7 m/s for u and v.
 1. The effective model resolution of Harmonie (with 2.5 km grid) is about 20-25 km.

Based on this one may conclude that the resolution of ASCAT-12.5km and Harmonie is about the same, so the representativeness error is negligible, and the total error equal to the observation error, i.e., 0.7 m/s and use this value for giving weight to ASCAT in Harmonie.

However, we think this will not give the best impact. This is because if you want to analyse model states on 25 km scales (Harmonie effective resolution) deterministically, you need a forcing term which accounts for this resolution. Forcing can be either from orography (over land only) or observations. So,  over sea we have to rely on the density of the observation network.
To analyse scales up to 25 km deterministically over sea requires high density observations both in space and time, i.e., for the latter at least every hour. This is corroborated by studies with ASCAT A and B, separated in time by 50 minutes, showing high correlation of ASCAT divergence and convergence with moist convection rain, but negligible  correlation between convergence or divergence of the two passes.

Since ASCAT overpasses only twice per day we can not fulfil the temporal requirement and can therefore not expect to analyse ocean surface winds deterministically at 25 km scales with ASCAT only. Based on this analysis we should therefore focus on larger than 25 km scales (as ECMWF does), also for Harmonie, so typically focus on 100 km scales. This means that scales between ~25-100 km in Harmonie over sea is mostly noise, which can be removed through supermodding, i.e., the project where Mate Mile is working on.

KNMI are waiting for a data feed from EUMETSAT. Level 1 ASCAT data available 14 March 2019 [https://www.eumetsat.int/website/home/TechnicalBulletins/Metop/DAT_4128787.html](https://www.eumetsat.int/website/home/TechnicalBulletins/Metop/DAT_4128787.html)

## Other scatterometers
 1. 25km data are generally available on a the satellite swath grid of WVCs
 1. The resolution of this 25 km data is around 100 km (through the application of a spatial filter that successfully suppresses both wind direction ambiguities and noise)
 1. As a result, the errors of neighboring observations are correlated over a distance of 100  km or more
 1. Triple collocation tests show observation error standard deviation ~ 0.7 m/s for u and v
 1. Biases exist at warm and cold SST of up to 0.5 m/s, which are being corrected; also winds around nadir and, to a lesser extent, in the outer swath are sometimes biased; the IFS takes account of this, but may need retuning for CFOSAT

## Further reading
More information is available on the OSI SAF wind site in the form of training material, product manuals, scientific publications, verification reports and monitoring information. Support and services messages for all products can be obtained through scat _at_ knmi.nl .

The EUMETSAT NWP SAF provides the following reports:
 * [High resolution data assimilation guide, v1.2 (NWPSAF-KN-UD-008)](http://projects.knmi.nl/scatterometer/publications/pdf/high_resolution_data_assimilation_guide_1.2_def.pdf)
 * [Wind Bias Correction Guide, v1.3 (NWPSAF-KN-UD-007)](http://projects.knmi.nl/scatterometer/publications/pdf/wind_bias_correction_guide_v1.3_def.pdf)

## Model
### Enable assimilation
 * Set SCATT_OBS=1 in scr/include.ass
 * Ensure ascat${DTG} files are available in $OBDIR (defined in ecf/config_exp.h )

### Technical information
 * Referred to as NSCAT3 in arpifs (see src/arpifs/module/yomcoctp.F90)
 * From [https://apps.ecmwf.int/odbgov](https://apps.ecmwf.int/odbgov)
   * obstype=9
   * codetype=139
   * sensor=190
   * varno=125/124 for ambiguos u/v wind component

## Issues (CY40/CY43)

### Thinning: NASCAWVC
 * Number of ASCAT wave vector cells
 * Defined in src/arpifs/module/yomthlim.F90
 * Default, set in src/arpifs/obs_preproc/sufglim.F90, is 42 (for 25-km product)
 * Set to 82 for 12.5-km scatterometer product in nam/harmonie_namelists.pm (possibly also in sufglim.F90. To be checked)

### Observation error
 * Set by Bator (src/odb/pandor/module/bator_init_mod.F90) u_err=1.39, v_err=1.54
 * Suggested values from KNMI: u_err=1.4, v_err=1.4
 * ZWE=2.0 set in src/arpifs/obs_preproc/nscatin.F90 but not used (I think)
 * *!ObsErr* in Jo-table is RMS of all ASCAT obs_error values (SQRT(0.5*(u,,err,,^2^ + v,,err,,^2^))
 * sigma,,o,, can be set by Bator in NADIRS using NADIRS:
```bash
ECTERO(9,139,125,1) = 1.39_JPRB
ECTERO(9,139,124,1) = 1.54_JPRB
```