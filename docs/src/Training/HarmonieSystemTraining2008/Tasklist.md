```@meta
EditURL="https://:@hirlam.org/trac//wiki/Training/HarmonieSystemTraining2008/Tasklist?action=edit"
```

# Task list

# Hands On Session
The following hands-on task list is to be compiled and finalized prior to the training week to enable participants to go through practices of various system components connected to the HARMONIE system. The list will include, but not limited to, the training of following system skills/abilities. At the start of the week, participants of the training week will be assigned a task-list containing hands-on practice for following aspects to get familiar with the basic HARMONIE system features.
 1. basic functionality of Subversion tool
   * use basic svn functions co, export, status, info, merge, add, delete, copy, revert
   * some information about svn commit; merge tracking; build a personal/institute branch
   * find and assemble a specific HARMONIE code: tagged versions, trunk, branches and vendor versions.
 1. configure and launch reference HARMONIE on ECMWF platform with different (tagged, trunk) versions of HARMONIE releases.
   * learn using Harmonie Setup/Start/Prod/Co/CleanUp/mXCdp
   * configure/edit experiment settings with Env_system, Env_submit, config.h
 1. learn basic steps to install Harmonie system on non-ECMWF platform
   * check of auxiliary tools, compilers, local modification
 1. test Harmonie/Surfex climate generation
   * learn to create a new model domain
 1. test boundary couping between ECMWF/HIRLAM/ALADIN/AROME
 1. test forecast runs with ALADIN/HIRALD/ALARO/AROME physics
   * learn basic name-list and tuning
     * time step; diffusion coefficient; physical parameterisation switches
 1. test running CANARI
   * examine analysis increment, data use, log files
 1. test running 3DVAR
   * basic configuration adjustment, examine analysis increment, ODB data, analysis monitoring, log files. Test simulated observation experiment
 1. [learn to use GL/xtool for file conversion/manipulation](https://hirlam.org/trac/browser/trunk/harmonie/util/gl/README)
   * use basic GL functionalities
     * Convert from FA/LFI to GRIB
     * Convert a subset of fields
     * Interpolate to a new domain
     * Extract gridpoints
     * Postprocess to pressure levels
   * use fldextr to extract model data for obs verification
   * use obsextr to extract observation data for obs verification
   * use xtool to manipulate fields
     * Print difference between to fields on the screen
     * Create accumulated differences 
     * Create a monthly average
     * Use SAL to compare different fields from different resolutions
 1. [learn to use verobs](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/doc/README_verobs)
   * use verobs to inter-compare different experiments to obs.
     * Download the trunk on ecgate and run the standard setup
     * Play with different forecast lengths, areas parameters
     * Add a new area, change the map view, define a polygon
     * Remove the quality control, fix the quality control
     * Plot some single stations
     * Create new contingency tables
     * Create monthly averages for several months
     * Change the time window for time series
 1. [learn to use WebgraF](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/doc/README_WebgraF)
   * Present data through WebgraF
     * Extract the definition file from a page
     * Create a new project/entry
     * Add info links
   * [Learn about the page definition file](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/WebgraF/src/input.html)
     * Change colors titles and texts
     * Turn on all do_* flags
     * Create a dynamic date axis
     * Create a page with links to external plots 
 1. learn to work with mSMS
   * write simple SMS TDF's to perform simple job
 1. learn to work with mXCdp
   * submit, interrupt, resume mSMS jobs with graphic user interface
 1. learn to design and perform a series of ALADIN forecast to derive background error statistics for 3DVAR
 1. [basic editing of Hirlam system wiki] (../../HarmonieSystemTraining2008/Training/WikiAuthoring.md)
   * use Hirlam system wiki to add/edit pages, using basic wiki editing features

