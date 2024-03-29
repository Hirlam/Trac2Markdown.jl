```@meta
EditURL="https://hirlam.org/trac//wiki//HHoutputlist?action=edit"
```


# HARMONIE and HIRLAM-7.3 GRIB Output Lists

## Grib Records Contained in HIRLAM/HARMONIE Model Level/History data

Both HIRLAM and HARMONIE forecast models write comprehensive model states at main integration intervals onto GRIB files. For HIRLAM, the standard
output model states contains full model states that enable a re-start of model integraton. Such data are refered to as both model level and history data. For HARMONIE, since the system is formulated on spectral space, the original model state is written on FA files containing spectral records, supplemented by surface model states on grid space in lfi format. Using HARMONIE GL tool, these data are then converted to 'normal' GRIB format on grid-point space. This enables downstream applications, such as comparison to that of HIRLAM. Such obtained grib-data normally keeps original projection, often in Lambert projection as contrast to HIRLAM's rotated lat-lon.

Following tables compare contents and definition of the data stored in the normal GRIB files as described above, from HIRLAM and HARMONIE models. The file names usually follow following convention: fcyyyymmdd_hh+lll in HIRLAM and fcyyyymmdd_hh+lllgrib and fcyyyymmdd_hh+lllgrib_sfx in HARMONIE, the latter provided MAKEGRIB=yes is set. In the above, yyyymmdd refers to year, month and day, hh the base hour from which forecast integration is initiated, lll the forecast length.

### 3D state variables on model level

| SOURCE  | SOURCE |  Variable names | Unit  | IPAR | LTYP | LEV | Note |
| --- | --- | --- | --- | --- | --- | --- | --- |
| HIRLAM | |  U | ms-1 |033 | 109 | 1...NLEV | wind: x-component, relative to the rotated coordinates, given at u-points |
|   | HARMONIE | SNNNWIND.U.PHYS | ms-1 |033 | 109 | 1...NLEV | on mass grid (unstaggered) |
|HIRLAM | |V | ms-1 |034 | 109 | 1...NLEV | wind: y-component, relative to the rotated coordinates, given at v-points |
|   | HARMONIE | SNNNWIND.V.PHYS | ms-1 |034 | 109 | 1...NLEV | on mass grid (unstaggered) |
|HIRLAM | | temperature | K |011 | 109 | 1...NLEV | |
|  | HARMONIE |SNNNTEMPERATURE | K |011 | 109 | 1...NLEV | |
|HIRLAM | | specific humidity |kg kg-1|051|109|1...NLEV||
|  | HARMONIE |SNNNHUMI.SPECIFI|kg kg-1|051|109|1...NLEV||
|HIRLAM |  | specific cloud liquid water |kg kg-1|076|109|1...NLEV |  |
|  | HARMONIE |SNNNHUMILIQU.TOT/SNNNCLOUD_WATER/SNNNLIQUID_WATER |kg kg-1|076|109| 1...NLEV |  |
|HIRLAM |  | specific cloud ice |kg kg-1|058|109|1...NLEV||
|  | HARMONIE | PNNNNNICE_CRYSTA |kg kg-1|058|109|1...NLEV||
|HIRLAM |  | total cloud cover |fraction|071|109|1...NLEV| |
|  | HARMONIE |SNNNCLOUD_FRACTI (cloud fraction) |fraction|071|109|1...NLEV| |
|HIRLAM |  | kinetic energy of turbulence |m2 s-2|200|109|1...NLEV| defined at model half-levels |
|  | HARMONIE | SNNNTKE (tke) |m2 s-2|200|109|1...NLEV||
|  | HARMONIE | PNNNNNSNOW (snow) | |79|109|1...NLEV| 3D-snow unique |
|  | HARMONIE | SNNNRAIN (rain) | |62|109|1...NLEV| 3D-rain |
|  | HARMONIE | SNNNGRAUPEL (graupel) | |201|109|1...NLEV| 3D-graupel |
|  | HARMONIE | HNNNNNPRESS.DEPA (pressure departure) | |212|109|1...NLEV||
|  | HARMONIE | vertical divergence | |213|109|1...NLEV||

### 2D Surface, near-surface and soil variables

|HIRLAM | | surface pressure |Pa|1|105| 0| not the mean sea level pressure |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  | HARMONIE | SURFPRESSION |Pa| 1|105| 0| not the mean sea level pressure |
|  | HARMONIE | MSLPRESSURE ||1|103| 0| MSLP |
|HIRLAM | | surface geopotential |m2/s2|006|105| 0| geopotential relative to mean sea level |
|  | HARMONIE |INTSURFGEOPOTENT/SPECSURFGEOPOTEN|m2/s2|006|105| 0| geopotential relative to mean sea level |
|HIRLAM | | surface temperature |K|011|105| 0| tile averaged |
|  | HARMONIE |SURFTEMPERATURE|K|11|105| 0| Surface Temp |
|HIRLAM | | screen level temperature |K|011 |105 |2 | 2m above ground |
|  | HARMONIE |CLSTEMPERATURE||11|105| 2| T2m |
|HIRLAM | | screen level temperature over land |K|140 |105 |2 |2m above ground, averaged over land tiles, [[Color(red, excluding forest)]] |
|HIRLAM | | screen level specific humidity over land |kg/kg|141 |105 |2 |2m above ground, [[Color(red, excluding forest)]]|
|  | HARMONIE |CLSMAXI.TEMPERAT||15|105| 2| Max Temp |
|  | HARMONIE |CLSMINI.TEMPERAT||16|105| 2| Min Temp |
|HIRLAM |  | x-component of wind at 10 m height |m/s|033 |105 |10 | relative to the rotated coordinates, given at mass-points |
|  | HARMONIE |CLSVENT.ZONAL||33|105| 10|U10m|
|HIRLAM | | y-component of wind at 10 m height |m/s|034 |105 |10 | relative to the rotated coordinates, given at mass-points |
|  | HARMONIE |CLSVENT.MERIDIEN||34|105| 10| V10m |
|HIRLAM | | screen level specific humidity |kg/kg|051 |105 |2 | 2m above ground |
|  | HARMONIE |CLSHUMI.SPECIFIQ||51|105| 2|Q2m|
|  | HARMONIE |CLSHUMI.RELATIVE||52|105| 2|RH2m|
|HIRLAM | | grid-scale precipitation |kg/m2|062 |105 |0 | different definition from HARMONIE |
|HIRLAM | | subgrid-scale precipitation |kg/m2|063 |105 |0 | different definition from HARMONIE |
|  | HARMONIE |SURFINSPLUIE |kg/m2||061 |105 |456 | Inst. rain |
|  | HARMONIE |SURFACCPLUIE |kg/m2||061 |105 |457 | Accumulated rain |
|  | HARMONIE |SURFINSNEIGE |kg/m2||062 |105 |456 | Inst. snow |
|  | HARMONIE |SURFACCNEIGE |kg/m2||062 |105 |457 | Accumulated snow |
|  | HARMONIE |SURFINSGRAUPEL |kg/m2||063 |105 |456 | Inst. graupel |
|  | HARMONIE |SURFACCGRAUPEL |kg/m2||063 |105 |457 | Accumulated graupel |
|  | HARMONIE |SURFRESERV.NEIGE| |066 |105 |0 | !SnowCov. |
|HIRLAM |  | total cloud cover |fraction|71 |105 | 0 | |
|  | HARMONIE |SURFNEBUL.TOTALE||71|105| 0| !TotCloud cover |
|  | HARMONIE |SURFNEBUL.CONVEC||72|105| 0| !ConCloud cover |
|  | HARMONIE |SURFNEBUL.BASSE||73|105| 0| !LowCloud cover |
|  | HARMONIE |SURFNEBUL.MOYENN||74|105| 0| !MidCloud cover |
|  | HARMONIE |SURFNEBUL.HAUTE||75|105| 0| !HigCloud cover |
|HIRLAM |  | fraction of land |fraction |081|105| 0| fraction of grid-square covered by land |
|  | HRAMONIE |SURFIND.TERREMER|fraction|081|105| 0| Fr. Land |
|HIRLAM |  | orographic roughness |m|083 |105 |0 | alternative to variables 204-209 |
|HIRLAM | | roughness length over sea |m|083 |102 |0 | analysis files contain a background-value |
|HIRLAM | | albedo |fraction |084 |105 |0 | basic value + snow |
|HIRLAM | | deep soil wetness |m|086|105| 998| climatological value |
|  | HARMONIE |SURFFLU.RAY.SOLA||111|105| 0| Surface SW net radiation |
|  | HARMONIE |SURFFLU.RAY.THER||112|105| 0| Surface LW net radiation |
|  | HARMONIE |SOMMFLU.RAY.SOLA||113|8| 0| TOA SW net radiation |
|  | HARMONIE |SOMMFLU.RAY.THER||114|8| 0| TOA LW net radiation |
|  | HARMONIE |SURFFLU.LAT.MEVA||121|105| 0| Latent heat flux |
|  | HARMONIE |SURFFLU.CHA.SENS||122|105| 0| Sensible heat flux |
|  | HARMONIE |SURFRAYT THER DE||115|105| 0| Surface LW down radiation |
|  | HARMONIE |SURFRAYT SOLA DE||117|105| 0| Surface SW down radiation |
|  | HARMONIE |SURFRAYT DIR SUR||117|105| 667| Surf direct solar flux |
|  | HARMONIE | ||117|8| 154|?? |
|  | HARMONIE |||117|8| 155|? |
|  | HARMONIE |SURFRAYT.SOLAIRE||117|105| 666| Surf inst. solar radiation |
|  | HARMONIE |SURFRAYT.TERREST||118|105| 666| Surf inst. thermal radiation |
|  | HARMONIE |||118|8| 155|? |
|  | HARMONIE |FMU||124|105| 0| Momentum flux  U-comp |
|  | HARMONIE |FMU||125|105| 0| Momentum flux  V-comp |
|  | HARMONIE |||162|105| 10|?|
|  | HARMONIE |||163|105| 10|?|
|  | HARMONIE |SURFFLU.LAT.MSUB||244|1| 0| Latent Heat Sublimation |
|  | HARMONIE |SURFFLU.MEVAP.EA||245|1| 0| Water evaporation |
|  | HARMONIE |SURFFLU.MSUBL.NE||246|1| 0| Snow Sublimation |
|HIRLAM |  | temperature of snow covering tiles 3 and 4 |K|011 |105 |706 | |
|HIRLAM |  | water in open land snow | m3/m3 |086 |105 |706 |  |
|HIRLAM |  | temperature of snow in the forest |K|011 |105 |707 | |
|HIRLAM |  | water in forest snow | m3/m3 |086 |105 |707 |  |
|HIRLAM | | canopy temperature |K|011 |105 |605 | |
|HIRLAM | | canopy snow water equivalence | m |066 |105 |605 |[[Color(red, nonsense values in 7.3)]] |
|HIRLAM |  | fraction of snow on ice | fraction | 194 | 105 | 702 | as compared to whole grid |
|HIRLAM | | fraction of snow on open land | fraction | 194 | 105 | 706 | as compared to whole grid |
|HIRLAM | | fraction of snow in the forest | fraction | 194 | 105 | 707 | as compared to whole grid |
|HIRLAM | | fraction of lake | fraction | 196 | 105 | 0 | |
|HIRLAM | | lake depth |m|068 |105 |0 |[[Color(red, always zero in 7.3, to be activated with FLake)]]|
|HIRLAM |  | std dev of mesoscale orography | gpm | 204 | 105 | 0 | |
|HIRLAM |  | anisotrophy mesoscale orography | | 205 | 105 | 0 | |
|HIRLAM | | x-angle of mesoscale orography | rad | 206 | 105 | 0 | |
|HIRLAM | | maximum slope of smallest scale orography | rad | 208 | 105 | 0 | |
|HIRLAM | | std dev of smallest scale orography | gpm | 209 | 105 | 0 | |
|HIRLAM | | x-component of wind at 10 m height | m/s|033 |105 |801-807 |relative to the rotated coordinates, given at mass-points |
|HIRLAM | | y-component of wind at 10 m height | m/s|034 |105 |801-807| relative to the rotated coordinates, given at mass-points]]
|HIRLAM | | surface temperature | K |011 |105 |901-907 | 901 = 011-102-0 = water surface temperature |
|HIRLAM | | 2nd layer soil temperature | K |011 |105 |931-937 |(7 cm), 931=nonsense |
|HIRLAM | | 3rd layer soil temperature | K |011 |105 |951-957 | (43 cm) |
|HIRLAM | | mean surface temperature | K |011 |105 |951-955 |  |
|HIRLAM | | surface specific humidity | kg / kg |051 |105 |901-907 | |
|HIRLAM | | surface soil water content | m3/m3 |086 |105 |901-907 |  |
|HIRLAM | | total soil water content | m3/m3 |086 |105 |951-957 | |
|HIRLAM | | water equivalent of snowpack/snow cover | m |066 |105 |901-907 | always zero for tiles 6 and 7 |
|HIRLAM | | latent heat flux | W/m2 |121 |105 |901-907 | instantaneous value  |
|HIRLAM | | sensible heat flux | W/m2 |122 |105 |901-907 | instantaneous value |
|HIRLAM | | scalar momentum flux | Pa |128 |105 |901-907 | given at mass-point, instantaneous value |
|HIRLAM | | snow albedo | fraction |190 |105 |901-907 ||
|HIRLAM | | snow density | |191 |105 |902-907 ||
|HIRLAM | | canopy water | kg/m2 |192 |105 |901-907 | 903 always 99 |
|HIRLAM | | 1st layer frozen soil water content | m3/ m3 |193 |105 |901-907 | always zero in 7.3 |
|HIRLAM | | 2nd layer frozen soil water content | m3/ m3 |193 |105 |931-937 | always zero in 7.3 |
|HIRLAM | | 3rd layer frozen soil water content | m3/ m3 |193 |105 |951-957 | always zero in 7.3 |
|HIRLAM | | fraction of surface type | fraction | 194 | 105 | 901-907 | 906,907 always zero in 7.3 |
|HIRLAM | | soil type | |195 |105 |901-907 | |
|HIRLAM | | vegetation type | |199 |105 |901-907 ||
|HIRLAM | | screen level temperature |K|011 |105 |801-807 | 2m above ground |
|HIRLAM | | screen level specific humidity |kg /kg|051 |105 | 801-807 | 2m above ground |
|  | HRAMONIE | SURFA.OF.OZONE | |248|105| 0| SURFA OZONE |
|  | HRAMONIE | SURFB.OF.OZONE | |249|105| 0| SURFB OZONE |
|  | HRAMONIE | SURFC.OF.OZONE | |250|105| 0| SURFC OZONE |
|  | HRAMONIE | SURFAEROS.SEA | |251|105| 0| Surface aerosol  sea |
|  | HRAMONIE |SURFAEROS.LAND| |252|105| 0| Surface aerosol land |
|  | HRAMONIE |SURFAEROS.SOOT| |253|105| 0| Surface aerosol soot? |
|HIRLAM | | deep soil temperature |K|011|105| 998| climatological value |

[wiki:HarmonieSystemDocumentation Back to the main page of the HARMONIE-System Documentation]
