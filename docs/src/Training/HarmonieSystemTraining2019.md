```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2019?action=edit"
```
# ALADIN/HIRLAM common data assimilation training week
**The Hungarian Meteorological Service Headquarter (OMSZ)**

**H-1024 Budapest, Kitaibel Pál u. 1 Hungary**

**10-15 February 2019**




## Invitation


In cooperation with Aladin and LACE, we are organising data assimilation (DA) training week.  DA is a very important part of our numerical weather prediction (NWP) system.  The aim of the training is to introduce the principles of DA and the way the DA system is built up in our consortia. 
We would like to welcome newcomers (having or not experience in DA) and all the colleagues, who are willing to work with DA to the training days. During these days we will introduce the different parts of our DA system to experienced newcomers and teach the full system from observation pre-processing, trough objective analysis for both upper-air and surface, up to observation monitoring and DA diagnostic to starters. We plan to have morning lecture and afternoon practical sessions.


To ease the registration and choice of the best week for the training, we elaborated a doodle poll, where each participant is requested to express his/her availability during the four proposed weeks together with his/her preference/possibility regarding the computing platform during the training days. One can choose more options if convenient. 

All participants are requested to register to the [doodle poll](https://doodle.com/poll/t92qxied35qnh2pv) below by 16th of November.

As explained above, we expect to welcome (more) colleagues with different background in DA from different centres. We prepare ourselves to "handle" at least two groups of participants.

## Course website

[https://www.met.hu/en/omsz/rendezvenyek/index.php?id=2400](https://www.met.hu/en/omsz/rendezvenyek/index.php?id=2400)

[Accommodation](https://www.met.hu/doc/rendezvenyek/assimilation_training-2019/Accommodation.pdf)

## Requirements
 * Laptop: bring your own!
 * ECMWF user account
   * Confirm you can log in to ecgate from your laptop
   * Options include PuTTy (Windows), ssh (Linux), NX (Windows / Linux)
     * Use [this version for nomachine](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/nomachine-enterprise-client_5.1.54_1_x86_64.tar) and add [this config file under your .ssh directory](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/config). Also, follow the advice given through the link below regarding the changed needed in ".nx/config/player.cfg".
     * [ecaccess.nxs](ecaccess.nxs): Windows Desktop icon for NX log in to ecaccess.ecmwf.int
     * For ssh:
```bash
cd $HOME
vi .ssh/config
```
     * Add the following lines:
```bash
Host ecaccess.ecmwf.int
    KexAlgorithms +diffie-hellman-group1-sha1
Host ecaccess.ecmwf.int
    HostKeyAlgorithms +ssh-dss
Host *
  ServerAliveInterval 240
```
      * And then log in:
```bash
ssh -X user@ecaccess.ecmwf.int
```
   * Further information here: [https://confluence.ecmwf.int/display/UDOC/ecgate](https://confluence.ecmwf.int/display/UDOC/ecgate)
   * How to log in: [https://www.ecmwf.int/en/computing/access-computing-facilities/how-log](https://www.ecmwf.int/en/computing/access-computing-facilities/how-log)
 * hirald user group
   * Confirm that your user is a member of the hirald user group:
```bash
dui@ecgb11:~$ whoami 
dui
dui@ecgb11:~$ groups dui
dui : ie glameps iemera hirlam hirald
```
 * Background reading
   * [ Data assimilation concept and methods, Bouttier and Courtier, 1999](https://www.ecmwf.int/en/elibrary/16928-data-assimilation-concepts-and-methods)
   * [Introduction to data assimilation, ECMWF material](https://www.ecmwf.int/assets/elearning/da/da1/story_html5.html)
   * [Overview of satellite observations and their role in NWP, ECMWF material](https://www.ecmwf.int/assets/elearning/satellite/satellite-obs/story_html5.html)

## Programme

[Final Programme](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/Darft_agenda.pdf)

## List of participants
[Participants](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/List_of_Participants.pdf)

{{{#!th align=left style="background: #BBBBBB" width=50
Time
```
{{{#!th align=left style="background: #BBBBBB" width=250
**Monday**
```
{{{#!th align=left style="background: #BBBBBB" width=250
**Tuesday**
```
{{{#!th align=left style="background: #BBBBBB" width=250
**Wednesday**
```
{{{#!th align=left style="background: #BBBBBB" width=250
**Thursday**
```
{{{#!th align=left style="background: #BBBBBB" width=250
**Friday**
```
|----------------------------------
{{{#!td style="background: #EEEEEE"
0900-0945
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture: [Observations for NWP](eoinWhelan_Obs.pdf)**
 - Eoin Whelan
A summary of observations used in NWP. Conventional (GTS), satellite (EUMETSAT), radar (OPERA) and other observations will discussed in the context of the ALADIN/HIRLAM System.

```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture: [Observation screening](Observation_Screening.pdf)**
 - Roger Randriamampianina
How the good observations are selected for data assimilation through quality control, blacklisting and data thinning. What do we do with known biased observations?
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture: [Variational data assimilation](budapest2019stappers.pdf)**
 - Roel Stappers
Theoretical background for variational data assimiliation (Minimization algorithms, preconditioning, Large scale constraint) 
 
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture:** [Surface DA](Hamdi_SURFACE_DA.pdf)
 - Rafiq Hamdi
Theoretical and scientific background for surface assimilation in NWP. 
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture: [Initialisation](AT_initialization.pdf)**
 - Alena Trojakova
A short introduction to initialization (DFI, IDFI, space consistent coupling).
```
|----------------------------------
{{{#!td style="background: #EEEEEE"
0945-1030
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture:  [Bator](bator.pdf)**
 - Alena Trojakova 
 - **Lecture:  [ODB](odb.pdf)**
 - Alena Trojakova

An overview of BATOR program to convert various observation data into ODB-1 format, to perform a blacklisting, to assign observation errors for conventional data and to make a preselection (geographic,timewindow, channel and sensors) of data. A short review of ODB and ODB applications (odbsq, MANDALAY, ODBTOOLS).
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture: [Bias correction of observations](VARBC_for_observations.pdf)**
 - Roger Randriamampianina
 - **Lecture: monitoring of observation usage:** [Obsmon](https://docs.google.com/presentation/d/1_3EpUtEIb3Tf4AK2JDDDpz073uV_aYEgvsbdqHHKlRM/edit#slide=id.p) [Budapest February 2019.pdf" (pdf)]("OBSMON)
 - Trygve Aspelien & Roger Randriamampianina
Obsmon is a tool used to monitor the use of observations from the ODBs used in 3/4D-Var and CANARI. It consists of two parts, the first extract information from ODB and the second part is the visualization done in a browser.
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture: [Minimization & B matrix computation from practical point of view](Bucanek_minim_bmatrix.pdf)**
 - Antonin Bucanek
An overview of minimization configuration (inputs, environment, namelist parameters) and checking of its execution. Various methods of B matrix computation: spinup, EDA (femars a festat programs).
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture:** [ Surface DA II](https://docs.google.com/presentation/d/1cRsFDl1XRi7zPnJyxJLaCo_kWTGDAX1q_pCizMuUD4I/edit#slide=id.p) [DA II.pdf" (pdf)]("Surface)
 - Trygve Aspelien
This second part will focus more on practical aspects on how to do surface assimilation with the external surface model SURFEX and how this links to the NWP model and HARMONIE script system 
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Lecture: [Diagnostics in DA](diagnostics_in_DA.pdf)**
 - Benedikt Strajnar
Introduction of various diagnostic techniques for DA: Analysis of residuals, Degrees of Freedom for Signal, Moist Total Energy norm, covariances of residuals and tuning of background/observation errors and thinning based on a-posterior diagnostics.
```
|----------------------------------
{{{#!td style="background: #BBBBBB"
1030-1100
```
{{{#!td style="background: #BBBBBB"
Coffee
```
{{{#!td style="background: #BBBBBB"
Coffee
```
{{{#!td style="background: #BBBBBB"
Coffee
```
{{{#!td style="background: #BBBBBB"
Coffee
```
{{{#!td style="background: #BBBBBB"
Coffee
```
|----------------------------------
{{{#!td valign=top style="background: #EEEEEE"
1100-1130
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the working environment: [ECMWF working environment](ECMWF_facilities.pdf)**
 - Daniel Santos
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the working environment: [System.pdf" Harmonie system part I]("Harmonie-Arome)**
 - Daniel Santos
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the working environment: [System.pdf" Harmonie system part II]("Harmonie-Arome)**
 - Daniel Santos
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the working environment: [Cycling - Input/Output/Archiving in Harmonie](eoinWhelan_HarmonieCycling.pdf)**
 - Eoin Whelan
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the working environment: "Gap filling"**
 - All
```
|----------------------------------
{{{#!td style="background: #BBBBBB"
1130-1300
```
{{{#!td style="background: #BBBBBB"
Lunch
```
{{{#!td style="background: #BBBBBB"
Lunch
```
{{{#!td style="background: #BBBBBB"
Lunch
```
{{{#!td style="background: #BBBBBB"
Lunch
```
{{{#!td style="background: #BBBBBB"
Lunch
```
|----------------------------------
{{{#!td style="background: #EEEEEE"
1300-1330
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the practicals**
 - Eoin Whelan (Obs) & Alena Trojakova (Bator)
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the practicals: [Screening & monitoring](Screening_Monitoring_exercises.pdf)**
 - Roger Randriamampianina (Screening), Alena Trojakova (Mandalay), Trygve Aspelien & Paulo Madeiros (Obsmon)
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the practicals: Upper-air DA**
   
 - Roel Stappers  & Antonin Bucanek
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the practicals:** [Introduction to practical session on surface analysis](https://docs.google.com/presentation/d/15iajONqe424lw2pMqhKsW36CQQANI-N6J-H0uH7Oez0/edit#slide=id.g4f93348872_0_0)
 - Trygve Aspelien & Rafiq Hamdi
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Introduction to the practicals: Diagnostic tools**
 - Benedikt Strajnar  & Roger Randriamampianina
```
|----------------------------------
{{{#!td style="background: #EEEEEE"
1330-1530
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Practical: [BUFR observations](eoinWhelan_Obs_Practical_NoSolutions.pdf) ([Solutions](eoinWhelan_Obs_Practical.pdf))**
 - Eoin Whelan
Introduction to BUFR related software including ecCodes, Metview and "bespoke" software related to the system. I will try not to mention BUFRDC!
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Practical: [Screening & monitoring](Screening_Monitoring_exercises.pdf)**
 - Alena Trojakova & Roger Randriamampianina & Trygve Aspelien & Paulo Madeiros
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Practical: [Minimization and Single Obs](Bucanek_minim_practicals.pdf)**
  Antonin Bucanek 
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Practicals:** [Surface Analysis](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/Practicals)
 - Trygve Aspelien & Rafiq Hamdi
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Practical: [Diagnostic tools](diagnostics_in_DA_exercises.pdf)**
Alena Trojakova & Benedikt Strajnar & Roger Randriamampianina
```
|----------------------------------
{{{#!td style="background: #BBBBBB"
1530-1600
```
{{{#!td valign=top style="background: #BBBBBB"
Coffee
```
{{{#!td valign=top style="background: #BBBBBB"
Coffee
```
{{{#!td valign=top style="background: #BBBBBB"
Coffee
```
{{{#!td valign=top style="background: #BBBBBB"
Coffee
```
{{{#!td valign=top style="background: #BBBBBB"
Coffee
```
|----------------------------------
{{{#!td style="background: #EEEEEE"
1600-1730
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Practical: [Bator](bator_practical.pdf) ([Solutions](bator_practical_solutions.pdf)) and preparing observations for NWP**
 - Alena Trojakova / Eoin Whelan
A hands-on session to learn about ODB and how Bator treats observations ...
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Practical: [Screening (ALARO) practicals](Bucanek_screening_practicals.pdf)**
 - Antonin Bucanek & Roger Randriamampianina
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Practical: [Minimization and Single Obs](HarmonieDAexercise.pdf)**
 - Using the scripts prepared by Eoin. (See practicals [Day 3](./Training/HarmonieSystemTraining2019/Practicals#Day3.md))
```
{{{#!td valign=top style="background: #EEEEEE"
- **Practicals:** [Surface Analysis](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/Practicals)
 - Trygve Aspelien & Rafiq Hamdi
```
{{{#!td valign=top style="background: #EEEEEE"
 - **Practical: [Diagnostic tools](diagnostics_in_DA_exercises.pdf)**
Alena Trojakova & Benedikt Strajnar & Roger Randriamampianina
```
|----------------------------------

## Practicals
[Practicals](./Training/HarmonieSystemTraining2019/Practicals.md): Practical instructions and links to reference material

## Evaluation
[Evaluation ](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/Common_DA_training_course_evaluation-Google_Forms.pdf)

## List of hotels

Please find [attached a document](https://hirlam.org/trac/attachment/wiki/HarmonieSystemDocumentation/Training/HarmonieSystemTraining2019/Accommodation_Budapest_2019.pdf) about two hotels which are located near to OMSZ and where group reservation is available.
In case of Hotel Novotel the deadline is 31 of January in case of group reservation.
In case of Hotel Regnum it is just advised to complete booking as soon as possible.



------------------------------------
## Social event

 

---------
