```@meta
EditURL="https://hirlam.org/trac//wiki//File_Conv_Postp_Verif?action=edit"
```
# File conversion

ALADIN and AROME works with FA and LFI files. The file formats are described on the GMAP documentation site

http://www.cnrm.meteo.fr/gmapdoc/recherche.php3?recherche=FA+LFI

Since we are used to work with GRIB it's convenient to convert the FA/LFI files to GRIB. This is described in

[README](https://hirlam.org/trac/browser/Harmonie/util/gl/README)

It's worth to mention that the conversion from FA/LFI names to GRIB parameters is at the moment a most subjective choice an by no means any standard. 


# Postprocessing

There is an extensive postprocessing tool in ALADIN, fullpos

http://www.cnrm.meteo.fr/gmapdoc/article.php3?id_article=17&var_recherche=fullpos

There is no working postprocessing yet in this release, but it will be added as soon as possible


# Verification

The verification an extension of the verification used in the developement of HIRVDA. When running an experiment at ECMWF files that can be used for verification will be produced both from the model and the observations.

For further instructions please read [here](https://hirlam.org/trac/browser/Harmonie/util/monitor/doc/)


# DDH

Diagnostics par Domaines Horizontaux (Diagnostics by Horizontal Domains) is a tool to create budgets of different processes in the model. Please read on in the documents attached below.

You may also visit the gmap documentation: http://www.cnrm.meteo.fr/gmapdoc/spip.php?page=recherche&recherche=DDH

https://hirlam.org/contrib/ulf/aladin/ddh.pdf


