```@meta
EditURL="https://hirlam.org/trac//wiki//Forecast/Outputlist?action=edit"
```


# HARMONIE-43h2 parameter list and GRIB definitions



## HARMONIE system output

The HARMONIE system writes its primary output, in FA format, to the upper air history files ICMSHHARM+llll and the SURFEX history files ICMSHHARM+llll.sfx, where HARM is the four-character experiment identifier set in the configuration file config_exp.h, and llll is normally the current timestep in hours. The files are designed to be complete snapshots of respective model state described by the system for a particular time point. In addition more model output including post-processing/diagnostic fields can be written out during the forecast model integration, such as those model diagnostics or pressure level diagnostics, also in FA format, as PFHARMDOMAIN+llll. The FA files can be considered to be internal format files. All of them can be converted to GRIB files during the run for external usage. The name convention is as follows:

* Forecast upper air history files: ICMSHHARM+llll -> fcYYYYMMDDHH+lll_grib (GRIB1) or fcYYYYMMDDHH+lll_grib2 (GRIB2) * Forecast Surfex history files: ICMSHHARM+llll.sfx -> fcYYYYMMDDHH+lll_grib_sfx (GRIB1 only) * Forecast Surfex selected output: ICMSSELE+llll.sfx -> fcYYYYMMDDHH+lll_grib_sfxs (GRIB1 only) * Postprocess files: PFHARMDOMAIN+llll.hfp -> fcYYYYMMDDHH+lllgrib_fp (GRIB1) or fcYYYYMMDDHH+lllgrib2_fp (GRIB2) 
* Analysis upper air history files: ICMSHANAL+0000 -> anYYYYMMDDHH+000grib (GRIB1) or anYYYYMMDDHH+000grib2 (GRIB2) (1)
* Analysis SURFEX history files: ICMSHANAL+0000.sfx -> sa2019041600+000grib_sfx (only GRIB1 for the time being)

## GRIB1 table 2 version in HARMONIE

To avoid conflicts with archived HIRLAM data HARMONIE uses version 253 of table 2. The table is based on the standard WMO version 3 of table 2 and postion 000-127 is kept the same as in the WMO. Note that accumulated and instantaneous versions of the same parameter differ only by the [time range indicator](https://apps.ecmwf.int/codes/grib/format/grib1/ctable/5). It is thus not sufficient to specify parameter, type and level when you refer to an accumulated parameter, but the time range indicator has to be included as well.

**The translation of SURFEX files to GRIB1 is still incomplete and contains several WMO violations. This is not changed in the current release but will revised later.** However, the upper air history file also includes the most common surface parameters and should be sufficient for most users.

The current table 2 version 253 definition files for grib_api can be found here: [GRIB-API local definitions](https://hirlam.org/trac/browser/Harmonie/util/gl_grib_api/definitions/). These local definition files assume centre=233 (Dublin) and should be copied to your own GRIB-API installation. You are strongly recommended to set your own code for generating centre fore operational usage of the data.

## GRIB2 in HARMONIE

The possibility to convert to GRIB2 has been introduced in release-43h2. So far the conversion is restricted to atmospheric history and fullpos files only. To get the output in GRIB2 set ARCHIVE_FORMAT=GRIB2 in ecf/config_exp.h. Please notice that if ARCHIVE_FORMAT=GRIB2 is selected, SURFEX files will be converted to GRIB1 anyway (for the time being). To convert from GRIB1 with GRIB2 using grib_filter we have to tell EcCodes how to translate the parameters. This is done by using the internal HARMONIE tables and setting

```bash
export ECCODES_DEFINITION_PATH=$SOME_PATH_TO_GL/gl/definitions:$SOME_PATH_TO_ECCODES/share/eccodes/definitions
```

Note that there are a few parameters that are not translated to GRIB2 to and those has to be excluded explicitly.


## List of parameters

### 3D model state variables on model levels (1-NLEV), levelType=hybrid


|  FA name         | shortName  | indicatorOfParameter | discipline | parameterCategory | parameterNumber | stepType | unit | Description | 
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SNNNHUMI.SPECIFI | q |  51 | 0 | 1 | 0 | instant | kg kg**-1 | Specific humidity |
| SNNNLIQUID_WATER | cwat_cond |  76 | 0 | 1 | 83 | instant | kg kg**-1 | Specific cloud liquid water content |
| SNNNSOLID_WATER | ciwc_cond |  58 | 0 | 1 | 84 | instant | kg kg**-1 | Specific cloud ice water content |
| SNNNSNOW | snow_cond |  184 | 0 | 1 | 86 | instant | kg kg**-1 | Specific snow water content |
| SNNNRAIN | rain_cond |  181 | 0 | 1 | 85 | instant | kg kg**-1 | Specific rain water content |
| SNNNGRAUPEL | grpl_cond |  201 | 0 | 1 | 32 | instant | kg kg**-1 | Specific graupel |
| SNNNTKE | tke |  200 | 0 | 19 | 11 | instant | J kg**-1 | Turbulent Kinetic Energy |
| SNNNCLOUD_FRACTI | tcc |  71 | 0 | 6 | 192 | instant | 0-1 | Total cloud cover |
| SNNNPRESS.DEPART | pdep |  212 | 0 | 3 | 8 | instant | Pa | Pressure departure |
| SNNNTEMPERATURE | t |  11 | 0 | 0 | 0 | instant | K | Temperature |
| SNNNVERTIC.DIVER | vdiv |  213 | 0 | 2 | 192 | instant | s**-1 | Vertical Divergence |
| SNNNWIND.U.PHYS | u |  33 | 0 | 2 | 2 | instant | m s**-1 | u-component of wind |
| SNNNWIND.V.PHYS | v |  34 | 0 | 2 | 3 | instant | m s**-1 | v-component of wind |

### 2D Surface, prognostic/diagnostic near-surface and soil variables

|  FA name         | Unit  | Parameter | Type | Level | Note |
| --- | --- | --- | --- | --- | --- |
|SURFPRESSION      |Pa     |   1 |105|   0 | Surface pressure    |
|SURFTEMPERATURE   |K      |  11 |105|   0 | Surface temperature |
|CLSTEMPERATURE    |K      |  11 |105|   2 | T2m |
|CLSMAXI.TEMPERAT  |K      |  15 |105|   2 | Max temperature over 3h |
|CLSMINI.TEMPERAT  |K      |  16 |105|   2 | Min temperature over 3h |
|CLSVENT.ZONAL     |ms-1   |  33 |105|  10 | U10m, relative to the model coordinates |
|CLSVENT.MERIDIEN  |ms-1   |  34 |105|  10 | V10m, relative to the model coordinates |
|CLSHUMI.SPECIFIQ  |kg kg-1|  51 |105|   2 | Q2m   |
|CLSHUMI.RELATIVE  |%      |  52 |105|   2 | RH2m  |
|SURFRESERV.NEIGE  |kg m-2 |  65 |105|   0 | Snow depth in water equivalent |
|[[Color(green, CLPMHAUT.MOD.XFU)]]   |m      | 67  |105|   0 | Height (in meters) of the PBL out of the model |
|SURFNEBUL.TOTALE  |%      |  71 |105|   0 | Total cloud cover |
|SURFNEBUL.CONVEC  |%      |  72 |105|   0 | Convective cloud cover |
|SURFNEBUL.BASSE   |%      |  73 |105|   0 | Low cloud cover |
|SURFNEBUL.MOYENN  |%      |  74 |105|   0 | Medium cloud cover |
|SURFNEBUL.HAUTE   |%      |  75 |105|   0 | High cloud cover |
|SURFRAYT.SOLAIRE  |W/m2   | 117 |105|   0 | [[Color(blue, Parameter identifier was 116)]] Instantaneous surface solar radiation (SW down global) |
|SURFRAYT.TERREST  |W/m2   | 115 |105|   0 | Instantaneous surface thermal radiation (LW down) |
|[[Color(green, SURFCAPE.MOD.XFU)]]   | J kg-1 | 160 |105|  0 | Model output CAPE (not calculated by AROME physics) |
| ~~SURFCAPE.MOD.F04~~ | J kg-1 | 160 |105|  0 | Postprocessed CAPE  |
|[[Color(green, SURFCAPE.MOD.F00)]] | J kg-1 | 160 |105|  0 | Postprocessed CAPE  |
|[[Color(green, SURFDIAGHAIL)]]      | %      | 161 |105|  0 | AROME  hail diagnostic. LXXDIAGH = .TRUE. |
|CLSU.RAF.MOD.XFU  |m/s    | 162 |105|  10 | U-momentum of gusts from the model. LXXGST = .TRUE. in NAMXFU. gives gust between current and previous output time step. |
|CLSV.RAF.MOD.XFU  |m/s    | 163 |105|  10 | V-momentum of gusts from the model. LXXGST = .TRUE. in NAMXFU. gives gust between current and previous output time step. |
|SURFINSPLUIE      |kg/m2  | 181 |105|   0 | Instantaneous rain.    |
|SURFINSNEIGE      |kg/m2  | 184 |105|   0 | Instantaneous snow.  |
|SURFINSGRAUPEL    |kg/m2  | 201 |105|   0 | Instantaneous graupel. |
|[[Color(green, CLSMINI.HUMI.REL)]] |%      | 241 |105|   2 | Min relative humidity over 3h |
|[[Color(green, CLSMAXI.HUMI.REL)]]  |%      | 242 |105|   2 | Max relative humidity over 3h |
|[[Color(green, CLSRAFALES.POS)]]    |m/s    | 228 |105|  10 | Gust wind speed |


### 2D Surface, accumulated near-surface and soil variables

**Note that all these are coded with stepType=accum**


|  FA name         | shortName  | indicatorOfParameter | discipline | parameterCategory | parameterNumber | level | unit | Description | 
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| S065RAYT SOL CL | cssw |  130 | 0 | 4 | 11 | 65 |  J m**-2 | SW net clear sky rad |
| S065RAYT THER CL | cslw |  131 | 0 | 5 | 6 | 65 |  J m**-2 | LW net clear sky rad |
| SURFACCGRAUPEL | grpl |  201 | 0 | 1 | 75 | 0 |  kg m**-2 s**-1 | Graupel precipitation rate |
| SURFACCNEIGE | snow |  184 | 0 | 1 | 53 | 0 |  kg m**-2 | Total snowfall rate water equivalent |
| SURFACCPLUIE | rain |  181 | 0 | 1 | 65 | 0 |  kg m**-2 | Rain |
| SURFDIR NORM IRR | dni |  140 | 3 | 6 | 2 | 0 |  J m**-2 | Direct normal irradiance |
| SURFFLU.CHA.SENS | shf |  122 | 0 | 0 | 11 | 0 |  J m**-2 | Sensible heat flux |
| SURFFLU.LAT.MEVA | lhe |  132 | 0 | 1 | 193 | 0 |  J m**-2 | Latent heat flux through evaporation |
| SURFFLU.LAT.MSUB | lhsub |  244 | 0 | 1 | 202 | 0 |  J kg**-1 | Latent Heat Sublimation |
| SURFFLU.MEVAP.EA | wevap |  245 | 0 | 1 | 6 | 0 |  kg m**-2 | Water evaporation |
| SURFFLU.MSUBL.NE | snsub |  246 | 0 | 1 | 62 | 0 |  kg m**-2 | Snow sublimation |
| SURFFLU.RAY.SOLA | nswrs |  111 | 0 | 4 | 9 | 0 |  J m**-2 | Net shortwave radiation flux (surface) |
| SURFFLU.RAY.THER | nlwrs |  112 | 0 | 5 | 5 | 0 |  J m**-2 | Net longwave radiation flux (surface) |
| SURFRAYT DIR SUR | swavr |  116 | 0 | 4 | 7 | 0 |  J m**-2 | Shortwave radiation flux |
| SURFRAYT SOLA DE | grad |  117 | 0 | 4 | 3 | 0 |  J m**-2 | Global radiation flux |
| SURFRAYT THER DE | lwavr |  115 | 0 | 5 | 4 | 0 |  J m**-2 | Longwave radiation flux |
| SURFTENS.TURB.ME | uflx |  124 | 0 | 2 | 198 | 0 |  N m**-2 | Momentum flux, u-component |
| SURFTENS.TURB.ZO | vflx |  125 | 0 | 2 | 199 | 0 |  N m**-2 | Momentum flux, v-component |
| # | tp |  61 | 0 | 1 | 8 | 0 |  kg m**-2 | Total precipitation |

### 2D TOA, diagnostic and accumulated variables

**Note that all these are coded with time range indicator = 4.**


|SOMMFLU.RAY.SOLA  |J m-2   | 113 |   8 |   0 |  TOA SW net radiation (Accumulated Top Solar radiation)    |
| --- | --- | --- | --- | --- | --- |
|SOMMFLU.RAY.THER  |J m-2   | 114 |   8 |   0 |  TOA LW net radiation (Accumulated Top Thermal radiation)  |
|SOMMRAYT.SOLAIRE  |W m-2   | 113 |   8 |   0 |  TOA Instantaneous SW net radiation |
|SOMMRAYT.TERREST  |W m-2   | 114 |   8 |   0 |  TOA Instantaneous LW net radiation |
|TOPRAYT_DIR_SOM   |W m-2   | 116 |   8 |   0 | [[Color(blue, Parameter identifier was 117)]]  TOA Accumulated SW down radiation |
|[[Color(green, SOMMTB_OZ_CLEAR)]]   |K      | 170 |   8 |   0 | Brightness temperature OZ clear |
|[[Color(green, SOMMTB_OZ_CLOUD)]]   |K      | 171 |   8 |   0 | Brightness temperature OZ cloud |
|[[Color(green, SOMMTB_IR_CLEAR)]]   |K      | 172 |   8 |   0 | Brightness temperature IR clear |
|[[Color(green, SOMMTB_IR_CLOUD)]]   |K      | 173 |   8 |   0 | Brightness temperature IR cloud |
|[[Color(green, SOMMTB_WV_CLEAR)]]   |K      | 174 |   8 |   0 | Brightness temperature WV clear |
|[[Color(green, SOMMTB_WV_CLOUD)]]   |K      | 175 |   8 |   0 | Brightness temperature WV cloud |

### 2D Surface, Postprocessed variables

|  FA name         | Unit  | Parameter | Type | Level | Note |
| --- | --- | --- | --- | --- | --- |

### 2D Surface, constant near-surface and soil variables

|  FA name | Unit  | Parameter | Type  | Level | Note |
| --- | --- | --- | --- | --- | --- |
|SPECSURFGEOPOTEN|m-2 s-2    |   6 | 105 |   0 | Geopotential relative to mean sea level. "... contains a GRID POINT orography which is the interpolation of the departure orography" |
|SURFIND.TERREMER|%        |  81 | 105 |   0 | Fr. Land (Land/sea mask) |
|SURFAEROS.SEA   |         | 251 | 105 |   0 | Surface aerosol  sea (Marine aerosols, locally defined GRIB)      |
|SURFAEROS.LAND  |         | 252 | 105 |   0 | Surface aerosol land (Continental aerosols, locally defined GRIB) |
|SURFAEROS.SOOT  |         | 253 | 105 |   0 | Surface aerosol soot (Carbone aerosols, locally defined GRIB)    |
|SURFAEROS.DESERT|         | 254 | 105 |   0 | Surface aerosol desert (Desert aerosols, locally defined GRIB)    |
|SURFAEROS.VOLCAN|         | 197 | 105 |   0 | Surface aerosol volcan (Stratospheric ash, to be locally defined GRIB)    |
|SURFAEROS.SULFAT|         | 198 | 105 |   0 | Surface aerosol desert (Stratospheric sulfate, to be locally defined GRIB)    |
|SURFA.OF.OZONE  |         | 248 | 105 |   0 | SURFA OZONE. First ozone profile (A), locally defined GRIB        |
|SURFB.OF.OZONE  |         | 249 | 105 |   0 | SURFB OZONE. Second ozone profile (B), locally defined GRIB       |
|SURFC.OF.OZONE  |         | 250 | 105 |   0 | SURFC OZONE. Third ozone profile (C), locally defined GRIB        |
|PROFTEMPERATURE |K        |  11 | 112 |   0 | Soil temperature       |
|SURFCAPE.POS.F00|J kg-1   | 160 | 105 |   0 | Convective available potential energy (CAPE) |
|SURFCIEN.POS.F00|J kg-1   | 165 | 105 |   0 | Convective inhibition (CIN) |
|SURFLIFTCONDLEV |m        | 167 | 105 |   0 | Lifting condensation level (LCL) |
|SURFFREECONVLEV |m        | 168 | 105 |   0 | Level of free convection (LFC) |
|SURFEQUILIBRLEV |m        | 169 | 105 |   0 | Level of neutral buoyancy (LNB) | 
|PROFRESERV.EAU  |kg m-2   |  86 | 112 |   0 | Soil Wetness       |
|PROFPROP.RMAX.EA|kg m-2   | 238 | 112 |   0 | Deep soil wetness  |
|PROFRESERV.GLACE|kg m-2   | 193 | 112 |   0 | Soil ice           | 
|PROFRESERV.GLACE|kg m-2   | 193 | 112 |   0 | Soil ice           | 


### 2D variables on special surfaces


|  FA name       | Unit | Parameter | Type | Level | Note |
| --- | --- | --- | --- | --- | --- |
|KT273ISOT_ALTIT  |m     |  8       |   20 | 27315 | Altitude of 0-degree isotherm |
|KT263ISOT_ALTIT  |m     |  8       |   20 | 26315 | Altitude of -0-degree isotherm |
|SURFISOTPW0.MAL  |m     |  8       |   5  | 0     | Altitude of T'w=0 isotherm |
|SURFTOT.WAT.VAPO |kg m-2|  54      |  200 | 0     | Total column water vapour |

## Postprocessed variables on different surface types

Through the postprocessing sofware fullpos HARMONIE offers a number of variables postprocessed on different
surface types. For the current choice of variables, surfaces and levels please see scr/Select_postp.pl.

### State variables and diagnostics on pressure levels,  leveltype


|  FA name         | shortName  | indicatorOfParameter | discipline | parameterCategory | parameterNumber | stepType | unit | Description | 
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PNNNNNWIND.U.PHY | u |  33 | 0 | 2 | 2 |  instant | m s**-1 | u-component of wind |
| PNNNNNWIND.V.PHY | v |  34 | 0 | 2 | 3 |  instant | m s**-1 | v-component of wind |
| PNNNNNTEMPERATUR | t |  11 | 0 | 0 | 0 |  instant | K | Temperature |
| PNNNNNHUMI.SPECI | q |  51 | 0 | 1 | 0 |  instant | kg kg**-1 | Specific humidity |
| PNNNNNLIQUID_WAT | cwat_cond |  76 | 0 | 1 | 83 |  instant | kg kg**-1 | Specific cloud liquid water content |
| PNNNNNSOLID_WATE | ciwc_cond |  58 | 0 | 1 | 84 |  instant | kg kg**-1 | Specific cloud ice water content |
| PNNNNNCLOUD_FRAC | tcc |  71 | 0 | 6 | 192 |  instant | 0-1 | Total cloud cover |
| PNNNNNSNOW | snow_cond |  184 | 0 | 1 | 86 |  instant | kg kg**-1 | Specific snow water content |
| PNNNNNRAIN | rain_cond |  181 | 0 | 1 | 85 |  instant | kg kg**-1 | Specific rain water content |
| PNNNNNGRAUPEL | grpl_cond |  201 | 0 | 1 | 32 |  instant | kg kg**-1 | Specific graupel |
| PNNNNNGEOPOTENTI | z |  6 | 0 | 3 | 4 |  instant | m**2 s**-2 | Geopotential |
| PNNNNNHUMI_RELAT | r |  52 | 0 | 1 | 192 |  instant | 0-1 | Relative humidity |
| PNNNNNTHETA_PRIM | papt |  14 | 0 | 0 | 3 |  instant | K | Pseudo-adiabatic potential temperature |
| PNNNNNVERT.VELOC | w |  40 | 0 | 2 | 9 |  instant | m s**-1 | Geometrical vertical velocity |
| PNNNNNPOT_VORTIC | pv |  4 | 0 | 2 | 14 |  instant | K m**2 kg**-1 s**-1 | Potential vorticity |
| PNNNNNABS_VORTIC | absv |  41 | 0 | 2 | 10 |  instant | s**-1 | Absolute vorticity |

 * NNNNN is in Pascals. 
 * From !FullPos documentation: "Warning: fields on pressure levels bigger or equal to 1000 hPa are written out with truncated names; for example, temperature at 1000 hPa is P00000TEMPERATURE while P00500TEMPERATURE could be as well the temperature at 5 hPa or the temperature at 1005 hPa!"

### State variables and diagnostics on height levels, levelType=heightAboveGround


|  FA name         | shortName  | indicatorOfParameter | discipline | parameterCategory | parameterNumber | stepType | unit | Description | 
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| HNNNNNWIND.U.PHY | u |  33 | 0 | 2 | 2 | instant | m s**-1 | u-component of wind |
| HNNNNNWIND.V.PHY | v |  34 | 0 | 2 | 3 | instant | m s**-1 | v-component of wind |
| HNNNNNTEMPERATUR | t |  11 | 0 | 0 | 0 | instant | K | Temperature |
| HNNNNNLIQUID_WAT | cwat_cond |  76 | 0 | 1 | 83 | instant | kg kg**-1 | Specific cloud liquid water content |
| HNNNNNSOLID_WATE | ciwc_cond |  58 | 0 | 1 | 84 | instant | kg kg**-1 | Specific cloud ice water content |
| HNNNNNCLOUD_FRAC | tcc |  71 | 0 | 6 | 192 | instant | 0-1 | Total cloud cover |
| HNNNNNSNOW | snow_cond |  184 | 0 | 1 | 86 | instant | kg kg**-1 | Specific snow water content |
| HNNNNNRAIN | rain_cond |  181 | 0 | 1 | 85 | instant | kg kg**-1 | Specific rain water content |
| HNNNNNGRAUPEL | grpl_cond |  201 | 0 | 1 | 32 | instant | kg kg**-1 | Specific graupel |
| HNNNNNHUMI_RELAT | r |  52 | 0 | 1 | 192 | instant | 0-1 | Relative humidity |
| HNNNNNPRESSURE | pres |  1 | 0 | 3 | 0 | instant | Pa | Pressure |

 * NNNNN is in meters. 

### State variables and diagnostics on PV levels, GRIB1 level type 117


|FA name            |Unit     | Par | Typ | Lev |gl name              |Note            |
| --- | --- | --- | --- | --- | --- | --- |
| VNNNGEOPOTENTI    | m2 s-2  |   6 | 117 | nnn | Geo.Pot.            |                |
| VNNNTEMPERATUR    | K       |  11 | 117 | nnn | Temp.               |                |
| VNNNWIND.U.PHY    | m s-1   |  33 | 117 | nnn | U-comp.             |                |
| VNNNWIND.V.PHY    | m s-1   |  34 | 117 | nnn | V-comp.             |                |
| VNNNVITESSE_VE    | Pa s-1  |  39 | 117 | nnn | !VertVel.           | DYNAMICS=h     |
| VNNNVERT.VELOC    | m s-1   |  40 | 117 | nnn | !VertVel.           | DYNAMICS=nh    |
| VNNNABS_VORTIC    | s-1     |  41 | 117 | nnn | A.Vort.             |                |
| VNNNDIVERGENCE    | s-1     |  44 | 117 | nnn | Div.                |                |
| VNNNHUMI.SPECI    | kg kg-1 |  51 | 117 | nnn | Sp.Hum.             |                |
| VNNNHUMI_RELAT    | %       |  52 | 117 | nnn | Rel.Hum.            |                |
 * "pv" stream is not available by default
 * NNN is in deci-PVU (1PVU = 1x10-6 K m2 kg-1 s-1) in FA files. PV levels must be in SI units in namelists
 * GRIB1 levels are in milli-PVU. Currently gl does not convert devi-PVU (FA) to milli-PVU (GRIB1)

### State variables and diagnostics on Theta levels, GRIB1 level type 113


|FA name            |Unit     | Par | Typ | Lev |gl name              |Note            |
| --- | --- | --- | --- | --- | --- | --- |
| TNNNPOT_VORTIC    | s-1 |   4 | 113 | nnn | Pot. Vorticity      |                |
| TNNNGEOPOTENTI    | m2 s-2  |   6 | 113 | nnn | Geo.Pot.            |                |
| TNNNTEMPERATUR    | K       |  11 | 113 | nnn | Temp.               |                |
| TNNNWIND.U.PHY    | m s-1   |  33 | 113 | nnn | U-comp.             |                |
| TNNNWIND.V.PHY    | m s-1   |  34 | 113 | nnn | V-comp.             |                |
| TNNNVITESSE_VE    | Pa s-1  |  39 | 113 | nnn | !VertVel.           | DYNAMICS=h     |
| TNNNVERT.VELOC    | m s-1   |  40 | 113 | nnn | !VertVel.           | DYNAMICS=nh    |
| TNNNABS_VORTIC    | s-1     |  41 | 113 | nnn | A.Vort.             |                |
| TNNNDIVERGENCE    | s-1     |  44 | 113 | nnn | Div.                |                |
| TNNNHUMI.SPECI    | kg kg-1 |  51 | 113 | nnn | Sp.Hum.             |                |
| TNNNHUMI_RELAT    | %       |  52 | 113 | nnn | Rel.Hum.            |                |
 * "th" stream is not available by default
 * NNN is in Kelvin.

### FA fields without any default GRIB1 translation
Some very special fields are left without any default translation. Please see in the [gl documentation](./PostPP/gl#GRIBFALFImanipulation.md) on how to add you own translation.


|FA name           |Unit  |Comment | 
| --- | --- | --- |
|CUF1PRESSURE      |      | Coupling error field. |
|THETAPWP_FLUX     |K m-4 s-1 | Instantaneous thetaprimwprim surface flux |
|CLPMOCON.MOD.XFU  |kg kg-1 s-1 | MOCON model output |
|ATMONEBUL.TOTALE  |      | Accumulated Total cloud cover. |
|ATMONEBUL.CONVEC  |      | Accumulated Convective cloud cover. |
|ATMONEBUL.BASSE   |      | Accumulated Low cloud cover. |
|ATMONEBUL.MOYENN  |      | Accumulated Medium cloud cover. |
|ATMONEBUL.HAUTE   |      | Accumulated High cloud cover. |
|SURFCFU.Q.TURBUL  |      | Accumulated contribution of Turbulence to Q. |
|SURFCFU.CT.TURBUL |      | Accumulated contribution of Turbulence to CpT. |
|SUNSHI. DURATION  |      | Sunshine duration.  |
|SURFFL.U  TURBUL  |      | Contribution of Turbulence to U. |
|SURFFL.V  TURBUL  |      | Contribution of Turbulence to V. |
|SURFFL.Q  TURBUL  |      | Contribution of Turbulence to Q. |
|SURFFL.CT TURBUL  |      | Contribution of Turbulence to CpT. |
|SNNNSRC           |      | Second order flux. |


## Variables postprocessed by gl

The following fields are can be generated by gl from a history file and are thus not necessarily available as FA fields.

### Single level fields


| Name | Unit | Par | Typ | Lev |  Note |
| --- | --- | --- | --- | --- | --- |
| MSLPRESSURE      | Pa    |   1 | 103 | 0   | MSLP. gl calculates MSLP independent of AROME/!FullPos |
| # | m | 20        | 105  | 0      | Visibility |
| #                |       |  31 | ttt | lll | Wind direction. gl calculates based on u[33,ttt,lll] and v[34,ttt,lll] wind components    |
| #                | m s-1   |  32 | ttt | lll | Wind speed. gl calculates based on u[33,ttt,lll] and v[34,ttt,lll] wind components  |
| #                | kg m-2 |  61 | 105 | 0   | Total precipitation (TP).  gl calculates TP![61,105,0]=rain![181,105,0]+snow![184,105,0]+graupel![201,105,0]+hail![204,105,0] |
| # | m |  67        | 105  | 0       | Boundary layer height |
| # | - | 71 | 105 | 2 | [[Color(Red, Fog)]] |
| # | ? |  135       | 105  | 0     | Icing index |
| # | K |  136     | 105  | 0  | Pseudo satellite image, cloud top temperature (infrared) |
| # | K |  137   | 105  | 0    | Pseudo satellite image, water vapour brightness temperature  |
| # | K |  138      | 105  | 0      | Pseudo satellite image, water vapour br. temp. + correction for clouds  |
| # | ? |  139       | 105  | 0        | Pseudo satellite image, cloud water reflectivity (visible) |
| # | ? |  144       | 105  | 0     | Precipitation type |
| #                | kg m-2 | 185 | 105 | 0   | Total solid precipitation.  gl calculates ![185,105,0]=snow![184,105,0]+graupel![201,105,0]+hail![204,105,0] |
| # | m/s |  228       | 105  | 10    | Wind gust speed |


### Integrated quantities


| Name | Unit | Par | Typ | Lev |  Note |
| --- | --- | --- | --- | --- | --- |
| # | kg m-2 |  58 | 200  | 0    | Vertical integral of cloud ice |


| # | kg m-2 |  76        | 200  | 0   | Vertical integral of cloud water |
| --- | --- | --- | --- | --- | --- |
| # | ? |  133  | 200  | 0      | Mask of significant cloud amount |
| # | J kg-1 |  160 | 200  | 0    | CAPE, comes in two flavours, cape_version=1|2 where the second is compatible with the ECMWF version |
| # | J kg-1 |  165 | 200  | 0    | CIN, comes in two flavours, cape_version=1|2 where the second is compatible with the ECMWF version |
| # | kg m-2 |  181       | 200  | 0    | Vertical integral of rain |
| # | kg m-2 |  184       | 200  | 0    | Vertical integral of snow |
| # | kg m-2 |  201       | 200  | 0    | Vertical integral of graupel |
| # | m |  186  | 200  | 0     | Cloud base  |
| # | m |  187  | 200  | 0     | Cloud top  |
| # | - |  209 | 200 | 0     | [[Color(Red, Lightning)]] |

## GRIB encoding information

### Time units, WMO code table 4

The following time units are used to encode GRIB edition 1 data


| Code | Unit | 
| --- | --- |
|0 | Minute |
|1 | Hour |
|13 | 15 minutes |
|14 | 30 minutes |

### Time range indicator, WMO code TABLE 5


| Code | Definition |
| --- | --- |
| 0    | Forecast product valid for reference time + P1 (P1 > 0), or Uninitialized analysis product for reference time (P1 = 0) | 
| 2    | 	Product with a valid time ranging between reference time + P1 and reference time + P2. Used for min/max values |
| 4    | Accumulation (reference time + P1 to reference time + P2) product considered valid at reference time + P2 | 

Note that fields available as both instanteous and accumulated values like e.g. rain has the same parameter values and can only be distinguished by the time range indicator.

### Level types, WMO Code table 3


| level type  | WMO/HIRLAM type definition                       | Units                      | notes        |
| --- | --- | --- | --- |
| 001	       | Ground or water surface                          | 0                          | WMO          |
| 002	       | Cloud base level                                 | 0                          | WMO          |
| 004	       | Level of 0°C isotherm                            | 0                          | WMO          |
| 006	       | Maximum wind level                               | 0                          | WMO          |
| 007	       | Tropopause                                       | 0                          | WMO          |
| 008         | Top-of-atmosphere                                |                            | WMO          |
| 020         | Isothermal level	                           | Temperature in 1/100 K     | WMO          |
| 100         | Isobaric level                                   | hPa                        | WMO          |
| 103         | Specified altitude above mean sea level          | Altitude in m              | WMO          |
| 105         | Specified height above ground                    | Altitude in m              | WMO          |
| 107         | Sigma level                                      | Sigma value in 1/10000     | WMO          |
| 109         | Hybrid level                                     |                            | WMO          |
| 113         | Isentropic (theta) level                         | Potential temperature in K | WMO          |
| 117         | Potential vorticity surface                      | 10-9 K m2 kg-1 s-1         | WMO          |
| 200         | Entire atmosphere (considered as a single layer) |                            | WMO, vertically integrated |


### Harmonie GRIB1 code table 2 version 253 - Indicator of parameter
Below the indicator of parameter code table for the Harmonie model. It is based on the WMO code table 2 version 3 with local parameters added. Parameter indicators 128-254 are reserved for originating center use. Parameter indicators 000-127 should not be altered. In HARMONIE, radiation fluxes are assumed positive downwards (against the recommendation by WMO).


| **Par** |**Description**                                 |**SI Units**  |
| --- | --- | --- |
| 000 |Reserved                                                |n/a             |
| 001 |Pressure                                                |Pa              |
| 002 |Pressure reduced to MSL                                 |Pa              |
| 003 |Pressure tendency                                       |Pa s-1          |
| 004 |Potential vorticity                                     |K m2 kg-1 s-1   |
| 005 |ICAO Standard Atmosphere reference height               |m               |
| 006 |Geopotential                                            |m2 s-2          |
| 007 |Geopotential height                                     |gpm             |
| 008 |Geometrical height                                      |m               |
| 009 |Standard deviation of height                            |m               |
| 010 |Total ozone                                             |Dobson          |
| 011 |Temperature                                             |K               |
| 012 |Virtual temperature                                     |K               |
| 013 |Potential temperature                                   |K               |
| 014 |Pseudo-adiabatic potential temperature                  |K               |
| 015 |Maximum temperature                                     |K               |
| 016 |Minimum temperature                                     |K               |
| 017 |Dew-point temperature                                   |K               |
| 018 |Dew-point depression (or deficit)                       |K               |
| 019 |Lapse rate                                              |K m-1           |
| 020 |Visibility                                              |m               |
| 021 |Radar spectra (1)                                       |-               |
| 022 |Radar spectra (2)                                       |-               |
| 023 |Radar spectra (3)                                       |-               |
| 024 |Parcel lifted index (to 500 hPa)                        |K               |
| 025 |Temperature anomaly                                     |K               |
| 026 |Pressure anomaly                                        |Pa              |
| 027 |Geopotential height anomaly                             |gpm             |
| 028 |Wave spectra (1)                                        |-               |
| 029 |Wave spectra (2)                                        |-               |
| 030 |Wave spectra (3)                                        |-               |
| 031 |Wind direction                                          |Degree true     |
| 032 |Wind speed                                              |m s-1           |
| 033 |u-component of wind                                     |m s-1           |
| 034 |v-component of wind                                     |m s-1           |
| 035 |Stream function                                         |m2 s-1          |
| 036 |Velocity potential                                      |m2 s-1          |
| 037 |Montgomery stream function                              |m2 s-1          |
| 038 |Sigma coordinate vertical velocity                      |s-1             |
| 039 |Vertical velocity                                       |Pa s-1          |
| 040 |Vertical velocity                                       |m s-1           |
| 041 |Absolute vorticity                                      |s-1             |
| 042 |Absolute divergence                                     |s-1             |
| 043 |Relative vorticity                                      |s-1             |
| 044 |Relative divergence                                     |s-1             |
| 045 |Vertical u-component shear                              |s-1             |
| 046 |Vertical v-component shear                              |s-1             |
| 047 |Direction of current                                    |Degree true     |
| 048 |Speed of current                                        |m s-1           |
| 049 |u-component of current                                  |m s-1           |
| 050 |v-component of current                                  |m s-1           |
| 051 |Specific humidity                                       |kg kg-1         |
| 052 |Relative humidity                                       |%               |
| 053 |Humidity mixing ratio                                   |kg kg-1         |
| 054 |Precipitable water                                      |kg m-2          |
| 055 |Vapor pressure                                          |Pa              |
| 056 |Saturation deficit                                      |Pa              |
| 057 |Evaporation                                             |kg m-2          |
| 058 |Cloud ice                                               |kg m-2          |
| 059 |Precipitation rate                                      |kg m-2 s-1      |
| 060 |Thunderstorm probability                                |%               |
| 061 |Total precipitation                                     |kg m-2          |
| 062 |Large scale precipitation                               |kg m-2          |
| 063 |Convective precipitation                                |kg m-2          |
| 064 |Snowfall rate water equivalent                          |kg m-2 s-1      |
| 065 |Water equivalent of accumulated snow depth              |kg m-2          |
| 066 |Snow depth                                              |m               |
| 067 |Mixed layer depth                                       |m               |
| 068 |Transient thermocline depth                             |m               |
| 069 |Main thermocline depth                                  |m               |
| 070 |Main thermocline anomaly                                |m               |
| 071 |Total cloud cover                                       |%               |
| 072 |Convective cloud cover                                  |%               |
| 073 |Low cloud cover                                         |%               |
| 074 |Medium cloud cover                                      |%               |
| 075 |High cloud cover                                        |%               |
| 076 |Cloud water                                             |kg m-2          |
| 077 |Best lifted index (to 500 hPa)                          |K               |
| 078 |Convective snow                                         |kg m-2          |
| 079 |Large scale snow                                        |kg m-2          |
| 080 |Water temperature                                       |K               |
| 081 |Land cover (1 = land, 0 = sea)                          |Proportion      |
| 082 |Deviation of sea level from mean                        |m               |
| 083 |Surface roughness                                       |m               |
| 084 |Albedo                                                  |%               |
| 085 |Soil temperature                                        |K               |
| 086 |Soil moisture content                                   |kg m-2          |
| 087 |Vegetation                                              |%               |
| 088 |Salinity                                                |kg kg-1         |
| 089 |Density                                                 |kg m-3          |
| 090 |Water run-off                                           |kg m-2          |
| 091 |Ice cover (1 = ice, 0 = no ice)                         |Proportion      |
| 092 |Ice thickness                                           |m               |
| 093 |Direction of ice drift                                  |Degree true     |
| 094 |Speed of ice drift                                      |m s-1           |
| 095 |u-component of ice drift                                |m s-1           |
| 096 |v-component of ice drift                                |m s-1           |
| 097 |Ice growth rate                                         |m s-1           |
| 098 |Ice divergence                                          |s-1             |
| 099 |Snow melt                                               |kg m-2          |
| 100 |Significant height of combined wind waves and swell     |m               |
| 101 |Direction of wind waves                                 |Degree true     |
| 102 |Significant height of wind waves                        |m               |
| 103 |Mean period of wind waves                               |s               |
| 104 |Direction of swell waves                                |Degree true     |
| 105 |Significant height of swell waves                       |m               |
| 106 |Mean period of swell waves                              |s               |
| 107 |Primary wave direction                                  |Degree true     |
| 108 |Primary wave mean period                                |s               |
| 109 |Secondary wave direction                                |Degree true     |
| 110 |Secondary wave mean period                              |s               |
| 111 |Net short-wave radiation flux (surface)                 |W m-2           |
| 112 |Net long-wave radiation flux (surface)                  |W m-2           |
| 113 |Net short-wave radiation flux (top of atmosphere)       |W m-2           |
| 114 |Net long-wave radiation flux (top of atmosphere)        |W m-2           |
| 115 |Long-wave radiation flux                                |W m-2           |
| 116 |Short-wave radiation flux                               |W m-2           |
| 117 |Global radiation flux                                   |W m-2           |
| 118 |Brightness temperature                                  |K               |
| 119 |Radiance (with respect to wave number)                  |W m-1 sr-1      |
| 120 |Radiance (with respect to wave length)                  |W m-3 sr-1      |
| 121 |Latent heat flux                                        |W m-2           |
| 122 |Sensible heat flux                                      |W m-2           |
| 123 |Boundary layer dissipation                              |W m-2           |
| 124 |Momentum flux, u-component                              |N m-2           |
| 125 |Momentum flux, v-component                              |N m-2           |
| 126 |Wind mixing energy                                      |J               |
| 127 |Image data                                              |-               |
| 128 |Analysed RMS of PHI (CANARI)                            |m2 s-2          |
| 129 |Forecasted RMS of PHI (CANARI)                          |m2 s-2          |
| 130 |SW net clear sky rad                                    |W m-2           |
| 131 |LW net clear sky rad                                    |W m-2           |
| 132 |Latent heat flux through evaporation                    |W m-2           |
| 133 |Mask of significant cloud amount                        |#               |
| 134 |Available                                               |#               |
| 135 |Icing index                                             |Code table      |
| 136 |Pseudo satellite image, cloud top temperature (infrared) |K | 
| 137 |Pseudo satellite image, water vapour brightness temperature  |K | 
| 138 |Pseudo satellite image, water vapour br. temp. + correction for clouds  |K | 
| 139 |Pseudo satellite image, cloud water reflectivity (visible) |? | 
| 140 |Direct normal irradiance                                |J m-2           |
| 141 |Available                                               |#               |
| 142 |Available                                               |#               |
| 143 |Available                                               |#               |
| 144 |Precipition Type                                        |Code table      |
| 145 |Available                                               |#               |
| 146 |Available                                               |#               |
| 147 |Available                                               |#               |
| 148 |Available                                               |#               |
| 149 |Available                                               |#               |
| 150 |Available                                               |#               |
| 151 |Available                                               |#               |
| 152 |Available                                               |#               |
| 153 |Available                                               |#               |
| 154 |Available                                               |#               |
| 155 |Available                                               |#               |
| 156 |Available                                               |#               |
| 157 |Available                                               |#               |
| 158 |Surface downward moon radiation                         |W m-2           |
| 159 |Available                                               |#               |
| 160 |CAPE                                                    |J kg-1          |
| 161 |AROME hail diagnostic                                   |%               |
| 162 |U-momentum of gusts out of the model                    |m s-1           |
| 163 |V-momentum of gusts out of the model                    |m s-1           |
| 164 |Available                                               |#               |
| 165 |Convective inhibition (CIN)                             |J kg-1          |
| 166 |MOCON out of the model                                  |kg/kg s-1       |
| 167 |Lifting condensation level (LCL)                        |m               |
| 168 |Level of free convection (LFC)                          |m               |
| 169 |Level of neutral boyancy (LNB)                          |m               |
| 170 |Brightness temperature OZ clear                         |K               |
| 171 |Brightness temperature OZ cloud                         |K               |
| 172 |Brightness temperature IR clear                         |K               |
| 173 |Brightness temperature IR cloud                         |K               |
| 174 |Brightness temperature WV clear                         |K               |
| 175 |Brightness temperature WV cloud                         |K               |
| 176 |Virtual potential temperature                           |K               |
| 177 |Available                                               |#               |
| 178 |Available                                               |#               |
| 179 |Available                                               |#               |
| 180 |Available                                               |#               |
| 181 |Rain                                                    |kg m-2          |
| 182 |Stratiform Rain                                         |kg m-2          |
| 183 |Convective Rain                                         |kg m-2          |
| 184 |Snow                                                    |kg m-2          |
| 185 |Total solid precipitation                               |kg m-2          |
| 186 |Cloud base                                              |m               | 
| 187 |Cloud top                                               |m               | 
| 188 |Fraction of urban land                                  |Proportion      |
| 189 |Available                                               |#               |
| 190 |Snow Albedo                                             |Proportion      |
| 191 |Snow density                                            |kg/m3           |
| 192 |Water on canopy                                         |kg/m2           |
| 193 |Soil ice                                                |kg/m2           |
| 194 |Available                                               |#               |
| 195 |Gravity wave stress U-comp                              |N/m2            |
| 196 |Gravity wave stress V-comp                              |N/m2            |
| 197 |Available                                               |#               |
| 198 |Available                                               |#               |
| 199 |Vegetation type                                         |-               |
| 200 |TKE                                                     |m2 s-2          |
| 201 |Graupel                                                 |kg m-2          |
| 202 |Stratiform Graupel                                      |kg m-2          |
| 203 |Convective Graupel                                      |kg m-2          |
| 204 |Hail                                                    |kg m-2          |
| 205 |Stratiform Hail                                         |kg m-2          |
| 206 |Convective Hail                                         |kg m-2          |
| 207 |Available                                               |#               |
| 208 |Available                                               |#               |
| 209 |Lightning                                               |-               |
| 210 |Simulated reflectivity                                  |dBz             |
| 211 |Available                                               |#               |
| 212 |Pressure departure                                      |Pa              |
| 213 |Vertical divergence                                     |s-1             |
| 214 |UD_OMEGA                                                |ms-1?           |
| 215 |DD_OMEGA                                                |ms-1?           |
| 216 |UD_MESH_FRAC                                            | -              |
| 217 |DD_MESH_FRAC                                            | -              |
| 218 |PSHI_CONV_CL                                            | -              |
| 219 |Surface albedo for non snow covered areas               |Proportion      |
| 220 |Standard deviation of orography * g                     |J/Kg            |
| 221 |Anisotropy coeff of topography                          | -              |
| 222 |Direction of main axis of topography                    |rad             |
| 223 |Roughness length of bare surface * g                    |m2 s-2          |
| 224 |Roughness length for vegetation * g                     |m2 s-2          |
| 225 |Fraction of clay within soil                            |Proportion      |
| 226 |Fraction of sand within soil                            |Proportion      |
| 227 |Maximum proportion of vegetation                        |Proportion      |
| 228 |Gust wind speed                                         |m s-1           |
| 229 |Albedo of bare ground                                   |Proportion      |
| 230 |Albedo of vegetation                                    |Proportion      |
| 231 |Stomatal minimum resistance                             |s/m             |
| 232 |Leaf area index                                         |m2/m2           |
| 233 |Thetaprimwprim surface flux                             |Km/s            |
| 234 |Dominant vegetation index                               |-               |
| 235 |Surface emissivity                                      |-               |
| 236 |Maximum soil depth                                      |m               |
| 237 |Soil depth                                              |m               |
| 238 |Surface liquid water content                            |kg/m2           |
| 239 |Thermal roughness length * g                            |m2 s-2          |
| 240 |Resistance to evapotransiration                         |s/m             |
| 241 |Minimum relative moisture at 2 meters                   |%               |
| 242 |Maximum relative moisture at 2 meters                   |%               |
| 243 |Duration of total precipitations                        |s               |
| 244 |Latent Heat Sublimation                                 |W/m2            |
| 245 |Water evaporation                                       |kg/m2           |
| 246 |Snow sublimation                                        |kg/m2           |
| 247 |Snow history                                            |???             |
| 248 |A OZONE                                                 |???             |
| 249 |B OZONE                                                 |???             |
| 250 |C OZONE                                                 |???             |
| 251 |Surface aerosol sea                                     |???             |
| 252 |Surface aerosol land                                    |???             |
| 253 |Surface aerosol soot                                    |???             |
| 254 |Surface aerosol desert                                  |???             |
| 255 |Missing value                                           |n/a             |


[wiki:HarmonieSystemDocumentation Back to the main page of the HARMONIE-System Documentation]
----
[[Disclaimer]]