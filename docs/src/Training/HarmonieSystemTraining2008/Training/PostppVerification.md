```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2008/Training/PostppVerification?action=edit"
```

# Hands On Practice: Post-Processing and Verification

## Practice tasks and Instructions


### Xtool

[learn to use GL/xtool for file conversion/manipulation](https://hirlam.org/trac/browser/trunk/harmonie/util/gl/README)
  * Run a difference between to files and print the result on the screen
  * Compare the orography between to files with SAL. Change the thresholds
  * Make a analysis increment file for a month of RCR data

### gl

[learn to use GL/xtool for file conversion/manipulation](https://hirlam.org/trac/browser/trunk/harmonie/util/gl/README)

   * use basic GL functionalities
     * Convert from FA/LFI to GRIB
     * Convert a subset of fields
     * Interpolate to a new domain
     * Extract gridpoints
     * Postprocess to pressure levels
     * Add missing FA/LFI to GRIB translations
   * use fldextr to extract model data for obs verification
     * Find what is wrong with the TD calculation for ALADIN
   * use obsextr to extract observation data for obs verification
     * Run with and without station list
   * use xtool to manipulate fields
     * Print difference between to fields on the screen
     * Create accumulated differences 
     * Create a monthly average
     * Use SAL to compare different fields from different resolutions

### verobs

[learn to use verobs](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/doc/README_verobs)

     * Download the trunk on ecgate and run the standard setup

```bash
        cd $SCRATCH
        svn co https://svn.hirlam.org/trunk/harmonie/util/monitor
        or 
        cp -r ~nhz/harmonie_release/trunk/util/monitor .
        cd monitor
        gmake
        cd scr
        ./Run_verobs_all
        Your verification results are stored in /scratch/ms/se/snh/monitor/scr/RCR C22_export.tar
        Copy to your local machine, untar and open RCR C22_export/index.html in your browser
```

     * use verobs to inter-compare different experiments to obs.
     * Play with different forecast lengths, areas parameters
     * Add a new area, change the map view, define a polygon
     * Remove the quality control, fix the quality control
     * Plot some single stations
     * Blacklist stations
     * Create new contingency tables
     * Create monthly averages for several months
     * Change the time window for time series
     * Play with the quality control

### WebgraF

[learn to use WebgraF](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/doc/README_WebgraF)

   * Download the WebgraF code

```bash
        svn co https://svn.hirlam.org/trunk/harmonie/util/monitor/WebgraF
        cd WebgraF
        export WEBGRAF_BASE=$PWD/WebgraF
        WebgraF/bin/WebgraF
```
     
     Open WebgraF/index.html in your browser

   * Present data through WebgraF
     * Extract the definition file from a page
     * Create a new project/entry
     * Add info links

[Learn about the page definition file](https://hirlam.org/trac/browser/trunk/harmonie/util/monitor/WebgraF/src/input.html)

     * Change colors titles and texts
     * Turn on all do_* flags
     * Create a dynamic date axis
     * Create a page with links to external plots 
     * Export a page
     * Transport a page



### Feeback

Please note found problems or suggestions below:

 * Everything works just fine!


## Reference Links to Post-PP and verification related lectures
 * [Post-Processing and Verification] (../../../HarmonieSystemTraining2008/Lecture/PostppVerification.md)
 * [Common Monitoring] (../../../HarmonieSystemTraining2008/Lecture/CommonMonitoring.md)

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)