```@meta
EditURL="https://hirlam.org/trac//wiki//PostPP/EPyGrAM?action=edit"
```

# EPyGrAM
## General
 * [https://opensource.cnrm-game-meteo.fr/projects/epygram](https://opensource.cnrm-game-meteo.fr/projects/epygram): EPyGram wiki
 * [https://opensource.cnrm-game-meteo.fr/projects/epygram/wiki/Vortex_packages](https://opensource.cnrm-game-meteo.fr/projects/epygram/wiki/Vortex_packages): Vortex information

## Using EPyGrAM (version 1.3.6) at ecgate
  * Set up EPyGrAM configuration (might be outdated, info is for version 1.2.1):
```bash
cd $HOME
mkdir .epygram
cp ~hlam/.epygram/* .epygram
```

  * Set up Vortex and EPyGrAM environment information by adding the following lines to the end of $HOME/.user_bashrc (or similar):
```bash
# Vortex & Footprints
VORTEX_INSTALL_DIR=/home/ms/spsehlam/hlam/local/EPyGrAM/vortex-1.0.0
export PYTHONPATH=$PYTHONPATH:$VORTEX_INSTALL_DIR:$VORTEX_INSTALL_DIR/src:$VORTEX_INSTALL_DIR/site

# EPyGrAM
EPYGRAM_INSTALL_DIR=/home/ms/spsehlam/hlam/local/EPyGrAM/EPyGrAM-1.3.6
export PYTHONPATH=$PYTHONPATH:$EPYGRAM_INSTALL_DIR:$EPYGRAM_INSTALL_DIR/site
export PATH=$PATH:$EPYGRAM_INSTALL_DIR/apptools
export LD_LIBRARY_PATH=$EPYGRAM_INSTALL_DIR/site/arpifs4py:/usr/local/apps/openmpi/2.1.3/GNU/6.3.0/lib:$LD_LIBRARY_PATH

```

  * Open a new shell or source $HOME/.user_bashrc 
  * Test:
```bash
epy_plot.py -f shortName:t,level:802 ~hlam/EPyGRAM/examples/fc2020052500+000grib_sfx
epy_section.py -f shortName:t,typeOfLevel:heightAboveGround -s'-8,53' -e'-7,53' 
 ~hlam/EPyGRAM/examples/fc2020052500+000grib_sfx
domain_maker.py
```

Enjoy!
