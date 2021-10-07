```@meta
EditURL="https://hirlam.org/trac//wiki//PhasingWithGit/Cycle46t1_bf.02/unqique_harmonie?action=edit"
```
Any file not connected to a header has an unknown purpose

```bash
# REMOVED THESE
arpifs/function/fcttrmd.func.h
utilities/pearome/programs/clust.F90
arpifs/adiab/specrtges.F90
arpifs/raingg/raingg_put.F90
arpifs/raingg/raingg_put_tl.F90
arpifs/utility/dealfpos.F90
arpifs/utility/prtjo.F90
arpifs/var/gp_ssmi.F90
arpifs/var/gp_ssmi_inv.F90
arpifs/var/grbspa_mf.F90
odb/pandor/module/aeolusconstants.F90
odb/pandor/module/height_conv.F90
odb/pandor/module/numerics.F90

# BALTRAD reader
odb/pandor/module/bator_decodhdf5_balt.F90




# LSMIX
aladin/programs/lsmix.F90

# EPS utilities
aladin/programs/addpert.F90
aladin/programs/pertsfc.F90

# Fullpos config cache
arpifs/module/yomfphold.F90

Our SPP implement
arpifs/phys_dmn/evolve_spp.F90
arpifs/phys_dmn/ini_spp.F90
mpa/micro/module/modd_spp_type.F90

# MSGINT
arpifs/phys_dmn/msginit.F90
arpifs/module/yom_msg.F90

# HybridEnVar
aladin/module/yemenshyb.F90
arpifs/module/yomalpha.F90
arpifs/module/yomja.F90
arpifs/transform/alpsp2gp.F90
arpifs/transform/alpsp2gpad.F90
arpifs/transform/spjbgp2sp.F90
arpifs/transform/spjbsp2gp.F90
arpifs/utility/acvspa.F90
arpifs/utility/acvspaad.F90
arpifs/utility/augalp.F90
arpifs/utility/augalp_ad.F90
arpifs/var/ens_contrib_ad.F90
arpifs/var/ens_contrib_tl.F90
arpifs/var/sp_trunc.F90
arpifs/var/sqrtain.F90
arpifs/var/sqrtainad.F90
arpifs/var/sualpfld.F90
arpifs/var/suja.F90
arpifs/var/sujacos.F90

# Our blacklisting
blacklist/Gen_hirlam_blacklist
blacklist/hirlam_blacklist.B
blacklist/hirlam_blacklist.b.data_selection_after_20140601
blacklist/hirlam_blacklist.b.data_selection_before20081209
blacklist/hirlam_blacklist.b.data_selection_from20081209_to_20140601
blacklist/hirlam_blacklist.b.monthly_after_20140601
blacklist/hirlam_blacklist.b.monthly_before20081209
blacklist/hirlam_blacklist.b.monthly_from20081209_to_20140601
blacklist/hirlam_blacklist.b.monthly_recent
blacklist/hirlam_blacklist.b.monthly_recent_carra
blacklist/hirlam_external
blacklist/mon_black2018080700.b
blacklist/mon_black2018090400.b
blacklist/mon_black2018100100.b
blacklist/mon_black2018100200.b
blacklist/mon_black2018110100.b
blacklist/mon_black2018120400.b
blacklist/mon_black2018121200.b
blacklist/mon_black2019010200.b
blacklist/mon_black2019011600.b
blacklist/mon_black2019020100.b
blacklist/mon_black2019030100.b
blacklist/mon_black2019050100.b
blacklist/mon_black2019060300.b
blacklist/mon_black2019070100.b
blacklist/mon_black2019080100.b

# LETKF or HybridEnsVar ?
etrans/external/edist_grid_32.F90
etrans/external/egath_grid_32.F90
etrans/interface/edist_grid_32.h
etrans/interface/egath_grid_32.h

# Relocation of misplaced (?) routines found in ifsaux/program in CY46T1_bf.02
ifsaux/fa/faconvcpl.F90
ifsaux/fa/faconvgrib.F90
ifsaux/fa/facplspec.F90
ifsaux/fa/fahis2cpl.F90
ifsaux/fa/faprogrid.F90
ifsaux/lfi/lfistress.F90
ifsaux/lfi/lfitestread.F90
ifsaux/lfi/lfitestwrite.F90

# Karl-Ivar Ivarsson microphysics
mpa/micro/internals/ini_snow.F90
mpa/micro/internals/ini_tiwmx.F90
mpa/micro/module/modd_tiwmx_fun.F90
mpa/micro/module/modi_ini_snow.F90

# Called from SURFEX 8.1
mse/externals/aro_dist_field.F90
mse/externals/aro_gather_field.F90
mse/externals/aro_get_global_size.F90 file name doesn't match subroutine name
mse/externals/aro_propagate_ice.F90

# Climate model SST/SIC updated routines
mse/externals/aro_put_SIC.F90
mse/interface/aro_put_sic.h

# SURFEX programs
mse/programs/convert_ecoclimap_param.f90   Renamed to .F90
mse/programs/soda.F90

# LETKF kept
odb/ddl.CCMA/global_enkf_11.sql
odb/ddl.CCMA/global_enkf_12.sql
odb/ddl.CCMA/global_enkf_13.sql
odb/ddl.CCMA/global_enkf_14.sql
odb/ddl.CCMA/global_enkf_16.sql
odb/ddl.CCMA/global_enkf_17.sql
odb/ddl.CCMA/global_enkf_18.sql
odb/ddl.CCMA/global_enkf_19.sql
odb/ddl.CCMA/global_enkf_21.sql
odb/ddl.CCMA/global_enkf_22.sql
odb/ddl.CCMA/global_enkf_23.sql
odb/ddl.CCMA/global_enkf_24.sql
odb/ddl.CCMA/global_enkf_26.sql
odb/ddl.CCMA/global_enkf_27.sql
odb/ddl.CCMA/global_enkf_28.sql
odb/ddl.CCMA/global_enkf_29.sql
odb/ddl.CCMA/global_enkf_31.sql
odb/ddl.CCMA/global_enkf_32.sql
odb/ddl.CCMA/global_enkf_33.sql
odb/ddl.CCMA/global_enkf_34.sql
odb/ddl.CCMA/global_enkf_36.sql
odb/ddl.CCMA/global_enkf_37.sql
odb/ddl.CCMA/global_enkf_38.sql
odb/ddl.CCMA/global_enkf_39.sql
odb/ddl.CCMA/global_enkf_41.sql
odb/ddl.CCMA/global_enkf_42.sql
odb/ddl.CCMA/global_enkf_43.sql
odb/ddl.CCMA/global_enkf_44.sql
odb/ddl.CCMA/global_enkf_46.sql
odb/ddl.CCMA/global_enkf_47.sql
odb/ddl.CCMA/global_enkf_48.sql
odb/ddl.CCMA/global_enkf_49.sql
odb/ddl.CCMA/global_enkf_51.sql
odb/ddl.CCMA/global_enkf_52.sql
odb/ddl.CCMA/global_enkf_53.sql
odb/ddl.CCMA/global_enkf_54.sql
odb/ddl.CCMA/global_enkf_56.sql
odb/ddl.CCMA/global_enkf_57.sql
odb/ddl.CCMA/global_enkf_58.sql
odb/ddl.CCMA/global_enkf_59.sql
odb/ddl.CCMA/global_enkf_6.sql
odb/ddl.CCMA/global_enkf_61.sql
odb/ddl.CCMA/global_enkf_62.sql
odb/ddl.CCMA/global_enkf_63.sql
odb/ddl.CCMA/global_enkf_64.sql
odb/ddl.CCMA/global_enkf_66.sql
odb/ddl.CCMA/global_enkf_67.sql
odb/ddl.CCMA/global_enkf_68.sql
odb/ddl.CCMA/global_enkf_69.sql
odb/ddl.CCMA/global_enkf_7.sql
odb/ddl.CCMA/global_enkf_71.sql
odb/ddl.CCMA/global_enkf_72.sql
odb/ddl.CCMA/global_enkf_73.sql
odb/ddl.CCMA/global_enkf_74.sql
odb/ddl.CCMA/global_enkf_76.sql
odb/ddl.CCMA/global_enkf_77.sql
odb/ddl.CCMA/global_enkf_78.sql
odb/ddl.CCMA/global_enkf_79.sql
odb/ddl.CCMA/global_enkf_8.sql
odb/ddl.CCMA/global_enkf_81.sql
odb/ddl.CCMA/global_enkf_82.sql
odb/ddl.CCMA/global_enkf_83.sql
odb/ddl.CCMA/global_enkf_84.sql
odb/ddl.CCMA/global_enkf_86.sql
odb/ddl.CCMA/global_enkf_87.sql
odb/ddl.CCMA/global_enkf_88.sql
odb/ddl.CCMA/global_enkf_89.sql
odb/ddl.CCMA/global_enkf_9.sql
odb/ddl.CCMA/global_enkf_91.sql
odb/ddl.CCMA/global_enkf_92.sql
odb/ddl.CCMA/global_enkf_93.sql
odb/ddl.CCMA/global_enkf_94.sql
odb/ddl.CCMA/global_enkf_96.sql
odb/ddl.CCMA/global_enkf_97.sql
odb/ddl.CCMA/global_enkf_98.sql
odb/ddl.CCMA/global_enkf_99.sql
odb/ddl/global_enkf_11.sql
odb/ddl/global_enkf_12.sql
odb/ddl/global_enkf_13.sql
odb/ddl/global_enkf_14.sql
odb/ddl/global_enkf_16.sql
odb/ddl/global_enkf_17.sql
odb/ddl/global_enkf_18.sql
odb/ddl/global_enkf_19.sql
odb/ddl/global_enkf_21.sql
odb/ddl/global_enkf_22.sql
odb/ddl/global_enkf_23.sql
odb/ddl/global_enkf_24.sql
odb/ddl/global_enkf_26.sql
odb/ddl/global_enkf_27.sql
odb/ddl/global_enkf_28.sql
odb/ddl/global_enkf_29.sql
odb/ddl/global_enkf_31.sql
odb/ddl/global_enkf_32.sql
odb/ddl/global_enkf_33.sql
odb/ddl/global_enkf_34.sql
odb/ddl/global_enkf_36.sql
odb/ddl/global_enkf_37.sql
odb/ddl/global_enkf_38.sql
odb/ddl/global_enkf_39.sql
odb/ddl/global_enkf_41.sql
odb/ddl/global_enkf_42.sql
odb/ddl/global_enkf_43.sql
odb/ddl/global_enkf_44.sql
odb/ddl/global_enkf_46.sql
odb/ddl/global_enkf_47.sql
odb/ddl/global_enkf_48.sql
odb/ddl/global_enkf_49.sql
odb/ddl/global_enkf_51.sql
odb/ddl/global_enkf_52.sql
odb/ddl/global_enkf_53.sql
odb/ddl/global_enkf_54.sql
odb/ddl/global_enkf_56.sql
odb/ddl/global_enkf_57.sql
odb/ddl/global_enkf_58.sql
odb/ddl/global_enkf_59.sql
odb/ddl/global_enkf_6.sql
odb/ddl/global_enkf_61.sql
odb/ddl/global_enkf_62.sql
odb/ddl/global_enkf_63.sql
odb/ddl/global_enkf_64.sql
odb/ddl/global_enkf_66.sql
odb/ddl/global_enkf_67.sql
odb/ddl/global_enkf_68.sql
odb/ddl/global_enkf_69.sql
odb/ddl/global_enkf_7.sql
odb/ddl/global_enkf_71.sql
odb/ddl/global_enkf_72.sql
odb/ddl/global_enkf_73.sql
odb/ddl/global_enkf_74.sql
odb/ddl/global_enkf_76.sql
odb/ddl/global_enkf_77.sql
odb/ddl/global_enkf_78.sql
odb/ddl/global_enkf_79.sql
odb/ddl/global_enkf_8.sql
odb/ddl/global_enkf_81.sql
odb/ddl/global_enkf_82.sql
odb/ddl/global_enkf_83.sql
odb/ddl/global_enkf_84.sql
odb/ddl/global_enkf_86.sql
odb/ddl/global_enkf_87.sql
odb/ddl/global_enkf_88.sql
odb/ddl/global_enkf_89.sql
odb/ddl/global_enkf_9.sql
odb/ddl/global_enkf_91.sql
odb/ddl/global_enkf_92.sql
odb/ddl/global_enkf_93.sql
odb/ddl/global_enkf_94.sql
odb/ddl/global_enkf_96.sql
odb/ddl/global_enkf_97.sql
odb/ddl/global_enkf_98.sql
odb/ddl/global_enkf_99.sql
odb/scripts/create_global_enkf_links.ksh

```