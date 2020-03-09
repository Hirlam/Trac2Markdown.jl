```@meta
EditURL="https://:@hirlam.org/trac//wiki/Training/HarmonieSystemTraining2008/Lecture/JobControl?action=edit"
```

# HARMONIE Job Control Scripts

## HARMONIE mini-SMS
Like HIRLAM, HARMONIE uses mini-SMS for job control. Mini-SMS is a single perl script emulating
many of the features of SMS (Supervisor Monitor Scheduler) developed at ECMWF.

### SMS
 * [ECMWF documentation](https://hirlam.org/UG/HL_Documentation/mSMS/SMS/)
 * [SMS online course (ECMWF web pages)](http://www.ecmwf.int/publications/manuals/sms/course/)
 * A (newer) pdf version of the manual is attached below.

### mini-SMS in HIRLAM and HARMONIE
[This document](https://hirlam.org/UG/HL_Documentation/mSMS/mSMS_CLI.html) describes the command line
interface to the [mSMS.pl](https://hirlam.org/trac/browser/trunk/harmonie/msms/mSMS.pl) script. However, in Harmonie as well as in Hirlam you will not ordinarily
invoke this script yourself.  Typically, most users will only need to know about the top level script [Harmonie](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/Harmonie). This script will, via the scripts [Main](https://hirlam.org/trac/browser/trunk/harmonie/config-sh/Main) and
[Start](https://hirlam.org/trac/browser/trunk/harmonie/scr/Start) take care of the actual invocation of mini-SMS (mSMS.pl).

### toward SMS?

## [ Prep-IFS](https://hirlam.org/HX/organisation/reports/systemww_200709/prepIFS2007.ppt) or [OLIVE/SWAPP](https://hirlam.org/HX/organisation/reports/systemww_200709/Olive_UG.pdf)

### XCdp
XCdp is the graphical interface to [CDP](https://hirlam.org/UG/HL_Documentation/mSMS/SMS/cdp/), the Control and Display Program which is an integral part of SMS.
 
## mXCdp
mXCdp is a graphical interface to mini-SMS. Unlike XCdp, which is a standalone program communicating with the SMS scheduler via CDP commands (which again use RPC system calls), mXCdp is actually just a set of perl subroutines running inside the mSMS main perl script. This implies some limitations. While many users can connect to SMS with their own instance of XCdp, only one instance of mXCdp can communicate with mSMS. The tight bond between mXCdp and mSMS also implies a vulnerability. If mXCdp chrashes, which happens occasionally, mSMS may go down as well.

 * [More documentation (old)](https://hirlam.org/UG/HL_Documentation/mSMS/mXCdp/)

### future prospects?

## [Hands on practice tasks] (../../../HarmonieSystemTraining2008/Training/JobControl.md)

## Reference
 * [ Prep-IFS ](https://hirlam.org/HX/organisation/reports/systemww_200709/prepIFS2007.ppt)
 * [Eric Sevault on MF Olive/SWAPP project](https://hirlam.org/HX/organisation/reports/systemww_200709/18A_swapp_EricSevault.pdf)
 * [Olive user's guide](https://hirlam.org/HX/organisation/reports/systemww_200709/Olive_UG.pdf)

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)