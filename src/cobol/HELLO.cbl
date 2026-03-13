      *****************************************************************
      * Program:    HELLO
      * Purpose:    Hello World COBOL demonstration program
      * Author:     Stormer Mainframes
      * Date:       2026
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       AUTHOR. STORMER-MAINFRAMES.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-ZOS.
       OBJECT-COMPUTER. IBM-ZOS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-MESSAGE           PIC X(40) VALUE SPACES.

       PROCEDURE DIVISION.
       0000-MAIN.
           MOVE 'HELLO FROM STORMER MAINFRAMES!'
               TO WS-MESSAGE
           DISPLAY WS-MESSAGE
           STOP RUN.
