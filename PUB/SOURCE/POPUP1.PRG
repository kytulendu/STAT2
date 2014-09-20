* popup all data from file to select one record

PARAMETER PopRow, PopCol, PopNum, PopDBF, PopFields, PopFirst, PopLast,PopTitle, PopOpe
* PopRow, PopCol = first row, column to start on window
* PopNum = number of record to popup
* PopDBF = strings of database name in use
* PopFields = strings of description to show in one row
* PopFirst = first record to popup
* PopLast = last record to popup
* PopTitle = ?

PRIVATE Count, Frec, ERec, CurRec, PopKey, PopLen, PopCh, ScrollD, ScrollU

SAVE SCREEN TO PopUp
PopLen = Len(&PopFields)
@ PopRow - 3, PopCol - 1 CLEAR TO PopRow + PopNum + 1, PopCol + PopLen
@ PopRow - 3, PopCol - 1, PopRow + PopNum + 1, PopCol + PopLen BOX 'ÄÖÅÑÉÖÇÑ'
DO hline with PopRow - 1, PopCol - 1, PopCol + PopLen
@ PopRow - 2, PopCol SAY PopTitle COLOR SCHEME 8
PopLoop = .T.
=SEEK(PopFirst, PopDBF)

DO WHILE PopLoop
  FRec = RECNO(PopDBF)
  FOR Count = 0 TO PopNum
    @ PopRow + Count, PopCol SAY IIF(! EOF(PopDBF) AND &PopOpe <= PopLast, &PopFields,'')
    SKIP IIF(! EOF(PopDBF) AND &PopOpe <= PopLast, 1, 0) IN (PopDBF)
  ENDFOR
  SKIP -1 IN (PopDBF)
  ERec = RECNO(PopDBF)
  GO Frec IN (PopDBF)
  Count = 0
  DO WHILE .T.
    @ PopRow + Count, PopCol SAY &PopFields COLOR SCHEME 10
    CurRec = RECNO(PopDBF)
    PopKey = INKEY(0)
    @ PopRow + Count, PopCol SAY &PopFields
    DO CASE
    CASE PopKey = 5    && up
      Count = IIF(Count > 0, Count - 1, 0)
      SKIP IIF(! BOF(PopDBF) AND &PopOpe >= PopFirst, -1, 0) IN (PopDBF)
      IF Count = 0 AND RECNO(PopDBF) != FRec AND &PopOpe >= PopFirst
        SCROLL PopRow, PopCol, PopRow + PopNum, PopCol + PopLen - 1,-1
        FRec = RECNO(PopDBF)
        GO ERec IN (PopDBF)
        SKIP -1 IN (PopDBF)
        ERec = RECNO(PopDBF)
        GO FRec IN (PopDBF)
      ENDIF
      IF &PopOpe < PopFirst
        =SEEK(PopFirst, PopDBF)
      ENDIF
    CASE PopKey = 24   && down
      Count = IIF(Count < PopNum, Count + 1, PopNum)
      SKIP IIF(! EOF(PopDBF) AND &PopOpe <= PopLast, 1, 0) IN (PopDBF)
      IF Count = PopNum AND RECNO(PopDBF) != ERec AND ! EOF(PopDBF) AND &PopOpe <= PopLast
        SCROLL PopRow, PopCol, PopRow + PopNum, PopCol + PopLen - 1, 1
        ERec = RECNO(PopDBF)
        GO FRec IN (PopDBF)
        SKIP IN (PopDBF)
        FRec = RECNO(PopDBF)
        GO ERec IN (PopDBF)
      ENDIF
      IF EOF(PopDBF) OR &PopOpe > PopLast
        IF SEEK(PopLast, PopDBF)
          DO WHILE &PopOpe = PopLast
            SKIP IN (PopDBF)
          ENDDO
          SKIP -1 IN (PopDBF)
        ELSE
          GO BOTTOM IN (PopDBF)
        ENDIF
        Count = IIF(Count = PopNum, PopNum, Count - 1)
      ENDIF
    CASE PopKey = 18   && PgUp
      GO FRec IN (PopDBF)
      Count = PopNum
      DO WHILE ! BOF(PopDBF) AND Count > 0 AND &PopOpe >= PopFirst
        SKIP - 1 IN (PopDBF)
        Count = Count - 1
      ENDDO
      IF &PopOpe < PopFirst
        SKIP IN (PopDBF)
      ENDIF
      EXIT
    CASE PopKey = 3    && PgDn
      GO ERec IN (PopDBF)
      @ PopRow, PopCol CLEAR TO PopRow + PopNum, PopCol + PopLen - 1
      EXIT
    CASE PopKey = 1    && home
      =SEEK(PopFirst,PopDBF)
      EXIT
    CASE PopKey = 6    && end
      IF SEEK(PopLast, PopDBF)
        DO WHILE &PopOpe = PopLast
          SKIP IN (PopDBF)
        ENDDO
        SKIP -1 IN (PopDBF)
      ELSE
        GO BOTTOM IN (PopDBF)
      ENDIF
      Count = PopNum
      DO WHILE ! BOF(PopDBF) AND Count > 0 AND &PopOpe >= PopFirst
        SKIP - 1 IN (PopDBF)
        Count = Count - 1
      ENDDO
      IF &PopOpe < PopFirst
        =SEEK(PopFirst, PopDBF)
      ENDIF
      EXIT
    CASE PopKey = 13   && enter
      PopLoop = .F.
      EXIT
    CASE PopKey = 27   && escape
      GO BOTTOM IN (PopDBF)
      SKIP IN (PopDBF)
      PopLoop = .F.
      EXIT
    ENDCASE
  ENDDO
ENDDO
RESTORE SCREEN FROM PopUp
RETURN