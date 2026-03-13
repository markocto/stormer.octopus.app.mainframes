//*********************************************************************
//* Job:       RUN
//* Purpose:   Execute a compiled COBOL load module
//* Usage:     Update PROGRAM as appropriate, then submit.
//*********************************************************************
//RUN      JOB (ACCT),'COBOL RUN',
//         CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*
//STEP1    EXEC PGM=&PROGRAM
//*
//STEPLIB  DD DSN=STORMER.LOADLIB,DISP=SHR
//CUSTFILE DD DSN=STORMER.DATA.CUSTOMERS,DISP=SHR
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//*
