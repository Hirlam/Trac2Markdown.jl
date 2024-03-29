```@meta
EditURL="https://hirlam.org/trac//wiki//Calibration?action=edit"
```

# ENSEMBLE CALIBRATION


# Introduction
In probabilistic forecasting the unavoidable forecast uncertainties are quantified and the aim is to estimate the probability forecast distribution based on information available at the time the forecast is to be issued. There are errors in the raw NWP ensemble distribution (both in the mean and the variance), and the systematic errors can be corrected by statistical post-processing, also called calibration. Attention is paid here to use predictors from HarmonEPS as a source of predictive information. 

# Statistical methods
The book of Vannitsem et al. (2018) gives a good overview of the ensemble calibration techniques that have been developed and used since the early 2000's. Here we describe a number of distributional regression and non-parametric methods only briefly together with the R packages that can be used. For most distributional regression methods the R package *gamlss* can be used, unless mentioned otherwise.
 
### Distributional regression
* **Normal**. The well-known normal or Gaussian distribution can be used to calibrate ensemble temperature forecasts. It has 2 parameters: the mean and the standard deviation. 

* **Truncated normal**. The truncated normal distribution is truncated at a specific value, e.g. at zero for wind speed as values < 0 are not physically possible. It also has 2 parameters: the mean and the standard deviation. 

* Log-normal

* Gamma

* Zero-adjusted Gamma distribution

* **Box-Cox t-distribution**. The Box-Cox t-distribution has four parameters which are related to the location, scale, skewness and kurtosis, but in a composite way. Roughly, mu is the mean or median, sigma is the mean/sd, and nu is (mean-median)/sd. 

* mixture Gamma

* mixture normal

### Non-parametric methods
* **quantile regression**. In quantile regression quantiles are modeled separately as functions of the covariates. Note that unless special care is taken quantiles may cross, but in any case they can be sorted afterwards. The R package *quantreg* can be used to fit quantiles.

* **quantile random/regression forests**. The R package *ranger* is an efficient package to fit quantile random/regression forests.

* **generalized random forests**. The R package *grf* can be used to fit generalized random forests. 

* **gradient boosting**. The R package *gbm* can be used to fit gradient boosting trees.

# Experiments

## Construction of spatial features
Spatial features are variables describing the topography. In statistical calibration their main usage is to explain possible spatial variations in the relation between the NWP model and observations. A good basis for defining features are land type and elevation data. For the European domain the Corine Land Cover data and the EU DEM 3035 data are suitable. The former classify the land type into more than 40 categories with a spatial resolution of about 140 meter. The land type classes can either be used directly as covariates in statistical models or clustered before further use. The elevation data have a spatial resolution of about 25 meter and are useful as they are. In addition, further processing can create variables describing peaks, ridges, plateaus etc. *gdalwarp* and *gdaldem* are useful tools to work on these data. Here are some examples:


Change of projection and domain to the MEPS (old):
```bash
gdalwarp -te -922442.2 -1129322 922557.8 1240678 -t_srs "+proj=lcc +lat_0=63 +lon_0=15 +lat_1=63 +lat_2=63 +no_defs +R=6.371e+06" $PATH_DATA/eudem_dem_3035_europe.tif $PATH_DATA/eudem_dem_3035_meps.tif
```

Change of resolution to 250 m:
```bash
gdalwarp -r near -tr 250 250 $PATH_DATA/eudem_dem_3035_meps.tif $PATH_DATA/eudem_dem_3035_meps_250m_nearest.tif
```

Computation of the topographical position index:
```bash
gdaldem TPI $PATH_DATA/eudem_dem_3035_meps_250m_nearest.tif $PATH_DATA/eudem_dem_3035_meps_250m_nearest_TPI.tif
```


## Calibration of wind speed

The skill of a number of (empirical) distributions to calibrate MEPS wind speed over Denmark has been investigated by Ioannidis et al. (2018). Global models have been fitted and the truncated normal distribution turned out to be the most skillful parametric distribution and it was compared to quantile regression forests. The latter was less skillful for the larger thresholds, probably because of the relatively small training data set (only 2 months per season). For the mean of the truncated normal distribution the MEPS mean and land type from the 140-m resolution Corine land cover data set were selected most often, and for the standard deviation the MEPS standard deviation and the land type. In terms of the Brier skill score the truncated normal distribution shows skill until thresholds of at least 20 m/s in winter. More details can be found in Ioannidis et al. (2018). 

# References

Ioannidis, E., K. Whan and M. Schmeits, 2018: Probabilistic Wind Speed Forecasting using Parametric and non-parametric Statistical Post-Processing Methods. KNMI internal report, to appear.

Vannitsem, S., D. Wilks and J. Messner (editors), 2018: Statistical Postprocessing of Ensemble Forecasts. Elsevier, 362 pp.   