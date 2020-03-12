```@meta
EditURL="https://hirlam.org/trac//wiki//Training/HarmonieSystemTraining2008/Training/JobControl?action=edit"
```

# Hands On Practice: Use of mini-SMS script

## Instructions or links to instructions
## Practice tasks
 * Introduce [CollectLogs.pl](https://hirlam.org/trac/browser/trunk/hirlam/scripts/CollectLogs.pl) (from the Hirlam repository) into the Harmonie system.
 * Start mini-SMS with e.g. DEBUG=6 and watch the file harmonie.db
 * Write a climate.tdf to get all 12 climate files
 * Introduce a "Listener" to process files fairly soon after creation rather than wait for the forecast to finish
 * To play with mini-SMS (suite, families, tasks, triggers, counters, loops, etc., or the mini-SMS interface), start from the attached file (trial.tar.gz). Unpack it in a working directory, and put . in your path. Run "perl mSMS.pl --prepare --play --halted suite". At ECMWF, use /usr/local/bin/perl56. Note that mini-SMS will start in the state defined by the checkpoint file suite.check. If you want to start mini-SMS from fresh, remove the file suite.check before you start mini-SMS.


## Relevant lecture notes
 * [mini-SMS, SMS and mXCdp](../../../HarmonieSystemTraining2008/Lecture/JobControl.md)

[ Back to the main page of the HARMONIE system training 2008 page](https://hirlam.org/trac/wiki/HarmonieSystemTraining2008)

[Back to the main page of the HARMONIE-System Documentation](https://hirlam.org/trac/wiki/HarmonieSystemDocumentation)