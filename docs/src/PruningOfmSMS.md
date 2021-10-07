```@meta
EditURL="https://hirlam.org/trac//wiki//PruningOfmSMS?action=edit"
```


## Pruning of mSMS

## Introduction

To ease the maintenance burden mSMS has been removed as a scheduler option from Harmonie. The change is introduced in the realease NN. The change has the following consequences

 * The msms directory has been renamed to suites and several outdated suite definition files have been removed. The remaining have been cleaned slightly in syntax
 * The sms directory has been renamed to ecf and all .sms files have been renamved to .ecf with adjustments to fit with the ecflow syntax. As a consequence the main configuration files of Harmonie, config_exp.h is now located under ecf/config_exp.h. The syntax in config_exp.h has not changed.
 * A large number of variables related to the usage of mSMS have been removed from the scripts and the various platform configuration files. 

User impact

 * Any experiment containing the sms or msms directory will not start until these directories are removed or renamed. If you have a CY43 experiment prior to the change that you'd like to continue you have to match your local files in sms/msms to the corresponding new ones in ecf/suites.
 * Be aware that the change has only been tested on a few platforms and there might be small errors introduced in the config/submit files for your particular platform.
 


----


