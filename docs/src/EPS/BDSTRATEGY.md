```@meta
EditURL="https://hirlam.org/trac//wiki//EPS/BDSTRATEGY?action=edit"
```
'''
## Boundary strategies for HarmonEPS: SLAF and EC ENS
'''

Presently there are two available options for choosing boundaries when running HarmonEPS: EC ENS or [SLAF] [[BR]](./EPS/SLAF.md)
In the branch harmonEPS-40h1.1 **SLAF is set as default** 


| |Settings for SLAF (default in branch harmonEPS-40h1.1 ) | Settings for EC ENS |
| --- | --- | --- |
|ecf/config_exp.h | BDSTRATEGY=simulate_operational | BDSTRATEGY=eps_ec |
| | BDINT=1 (can be set to larger value) | BDINT=3 (or larger, hourly input is not possible) |
| msms/harmonie.pm | | Comment out SLAF settings: #SLAFLAG, #SLAFDIFF, #SLAFK |
| | 'ENSBDMBR' => [ 0] | 'ENSBDMBR' => [ 0, 1..10] (or any other members from EC ENS you would like to use)|

More information about how to treat the settings in harmonie.pm, see: [[[BR]](./EPS/Howto#Advancedconfigurationmemberspecificsettings].md)
Note that BDSTRATEGY=eps_ec uses EC ENS data as stored in the GLAMEPS archive (as ECMWF does not store model levels in MARS). Only EC ENS at 00UTC and 12UTC are in this archive, and with 3h output, hence you need to use BDINT=3 for this option.