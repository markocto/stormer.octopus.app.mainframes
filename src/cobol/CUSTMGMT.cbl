      *****************************************************************
      * Program:    CUSTMGMT
      * Purpose:    Customer Management - Read and display customer
      *             records from a sequential file
      * Author:     Stormer Mainframes
      * Date:       2026
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CUSTMGMT.
       AUTHOR. STORMER-MAINFRAMES.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-ZOS.
       OBJECT-COMPUTER. IBM-ZOS.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE
               ASSIGN TO CUSTFILE
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  CUSTOMER-FILE
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS
           RECORD CONTAINS 80 CHARACTERS.
       01  CUSTOMER-RECORD.
           05 CUST-ID           PIC 9(06).
           05 CUST-LAST-NAME    PIC X(20).
           05 CUST-FIRST-NAME   PIC X(15).
           05 CUST-BALANCE      PIC S9(9)V99 COMP-3.
           05 FILLER            PIC X(29).

       WORKING-STORAGE SECTION.
       01 WS-FILE-STATUS        PIC XX VALUE SPACES.
       01 WS-EOF-FLAG           PIC X  VALUE 'N'.
           88 WS-EOF                   VALUE 'Y'.
       01 WS-RECORD-COUNT       PIC 9(06) VALUE ZEROS.
       01 WS-DISPLAY-BALANCE    PIC ZZZ,ZZZ,ZZ9.99-.

       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM 1000-OPEN-FILES
           PERFORM 2000-PROCESS-RECORDS
               UNTIL WS-EOF
           PERFORM 3000-CLOSE-FILES
           STOP RUN.

       1000-OPEN-FILES.
           OPEN INPUT CUSTOMER-FILE
           IF WS-FILE-STATUS NOT = '00'
               DISPLAY 'ERROR OPENING CUSTOMER FILE: ' WS-FILE-STATUS
               MOVE 16 TO RETURN-CODE
               STOP RUN
           END-IF.

       2000-PROCESS-RECORDS.
           READ CUSTOMER-FILE
               AT END MOVE 'Y' TO WS-EOF-FLAG
               NOT AT END
                   ADD 1 TO WS-RECORD-COUNT
                   PERFORM 2100-DISPLAY-RECORD
           END-READ.

       2100-DISPLAY-RECORD.
           MOVE CUST-BALANCE TO WS-DISPLAY-BALANCE
           DISPLAY 'CUST-ID: ' CUST-ID
               '  NAME: ' CUST-LAST-NAME ', ' CUST-FIRST-NAME
               '  BALANCE: ' WS-DISPLAY-BALANCE.

       3000-CLOSE-FILES.
           CLOSE CUSTOMER-FILE
           DISPLAY 'TOTAL RECORDS PROCESSED: ' WS-RECORD-COUNT.
