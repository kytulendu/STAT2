* popup all data from file to select one record
* By Chusak Yathongchai Information RAMATHIBODEE
* Modified by Virat Luevisadpaibul SAPPASITTHIPRASONG UBON

PARAMETER PopRow, PopCol, PopNum, PopDBF, PopFields
* PopRow, PopCol = first row, column to start on window
* PopNum = number of record to popup
* PopDBF = strings of database name in use
* PopFields = strings of description to show in one row
PRIVATE Count, Frec, ERec, CurRec, PopKey, PopLen, PopCh, ScrollD, ;
ScrollU, UpperKey, NowAlias, PropKey
*ACTI SCREE
maxcol = WCOLS() - 1
maxrow = WROWS() - 1
SAVE SCREEN TO PopUp
PopLen = Len(&PopFields) + 2
PopNum = IIF( ! BETWEEN(PopNum,2,maxrow - 2), maxrow - 2, IIF(PopNum >= RECCOUNT(PopDBF), RECCOUNT(PopDBF) - 1, PopNum))
PopRow = IIF( ! BETWEEN(PopRow,2,maxrow - 2), 2, PopRow)
PopRow = IIF( PopRow + PopNum > maxrow - 2, maxrow - 2 - PopNum, PopRow)
PopRow = IIF( PopRow < 3, 3, PopRow)
PopCol = IIF( ! BETWEEN(PopCol,3,maxcol - 2), 3, PopCol)
PopCol = IIF( PopCol + PopLen > maxcol - 2, maxcol - 2 - PopLen - 2, PopCol)
@ PopRow - 3, PopCol - 3 CLEAR TO PopRow + PopNum + 2, PopCol + PopLen + 2
@ PopRow - 3, PopCol - 1, PopRow + PopNum + 1, PopCol + PopLen+2 BOX ba
 @ PopRow - 1, PopCol - 1, PopRow + PopNum + 1, PopCol + PopLen+2  BOX bb
PopLoop = .T.
NowAlias = ALIAS()
SELE (PopDBF)
UpperKey = LEFT(KEY(),6) = 'UPPER('
PropKey = LEFT(KEY(),7) = 'PROPER('
PopCh = ''
GO TOP
DO WHILE PopLoop
	@ PopRow , PopCol  CLEAR TO PopRow + PopNum , PopCol + PopLen - 1
  FRec = RECNO(PopDBF)
  FOR Count = 0 TO PopNum
    @ PopRow + Count, PopCol SAY IIF(! EOF(PopDBF), &PopFields,'')
    SKIP IIF(! EOF(PopDBF), 1, 0) IN (PopDBF)
  ENDFOR
  SKIP -1 IN (PopDBF)
  ERec = RECNO(PopDBF)
  GO Frec IN (PopDBF)
  Count = 0
  DO WHILE .T.
    @ PopRow + Count, PopCol SAY &PopFields COLOR w/gr
    @ PopRow - 2, PopCol SAY SPACE(LEN(PopCh)+1)
    @ PopRow - 2, PopCol SAY PopCh  COLOR W/GR+
    CurRec = RECNO(PopDBF)
    PopKey = INKEY(0)
    @ PopRow + Count, PopCol SAY &PopFields
    DO CASE
    CASE PopKey = 5    && up
		count = count - 1
      SKIP IIF(! BOF(PopDBF), -1, 0) IN (PopDBF)
      IF Count < 0 AND RECNO(PopDBF) != FRec .AND. ! BOF(PopDBF)
        SCROLL PopRow, PopCol, PopRow + PopNum, PopCol + PopLen - 1,-1
        FRec = RECNO(PopDBF)
        numrec = 0
        DO WHIL numrec <= popnum .AND. ! EOF(PopDBF)
        	numrec = numrec + 1
        	SKIP 1 IN (PopDBF)
        ENDD
        SKIP -1 IN (PopDBF)
        ERec = RECNO(PopDBF)
        GO FRec IN (PopDBF)
        count = 0
      ENDIF
      count = IIF(count < 0, 0, count)
      IF BOF(PopDBF)
        GO TOP IN (PopDBF)
        Count = 0
      ENDIF
    CASE PopKey = 24   && down
		count = count + 1
      SKIP IIF(! EOF(PopDBF), 1, 0) IN (PopDBF)
      IF Count > PopNum AND RECNO(PopDBF) != ERec AND ! EOF(PopDBF)
        SCROLL PopRow, PopCol, PopRow + PopNum, PopCol + PopLen - 1, 1
        ERec = RECNO(PopDBF)
        GO FRec IN (PopDBF)
        SKIP IN (PopDBF)
        FRec = RECNO(PopDBF)
        GO ERec IN (PopDBF)
      ENDIF
      count = IIF(count > popnum, popnum, count)
      IF EOF(PopDBF)
        GO BOTTOM IN (PopDBF)
        Count = IIF(frec = erec, 0, Count )
      ENDIF
    CASE PopKey = 18   && PgUp
      GO FRec IN (PopDBF)
      Count = PopNum
      DO WHILE ! BOF(PopDBF) AND Count > 0
        SKIP - 1 IN (PopDBF)
        Count = Count - 1
      ENDDO
      EXIT
    CASE PopKey = 3    && PgDn
      GO ERec IN (PopDBF)
      @ PopRow, PopCol CLEAR TO PopRow + PopNum, PopCol + PopLen - 1
      EXIT
    CASE PopKey = 1    && home
      GO TOP IN (PopDBF)
      EXIT
    CASE PopKey = 6    && end
      GO BOTTOM IN (PopDBF)
      Count = PopNum
      DO WHILE ! BOF(PopDBF) AND Count > 0
        SKIP - 1 IN (PopDBF)
        Count = Count - 1
      ENDDO
      EXIT
    CASE PopKey = 13   && enter
      PopLoop = .F.
      EXIT
    CASE PopKey = 27   && escape
      GO BOTTOM IN (PopDBF)
      SKIP IN (PopDBF)
      PopLoop = .F.
      EXIT
    OTHERWISE
      PopCh = IIF( PopKey = 127, LEFT(PopCh, LEN(PopCh) - 1), ;
      IIF( UpperKey, UPPER(PopCh + CHR(PopKey)), IIF(PropKey, PROP(PopCh + CHR(PopKey)), PopCh + CHR(PopKey))))
      IF SEEK(PopCh, PopDBF)
        EXIT
      ELSE
        ?? CHR(7)
        GO CurRec IN (PopDBF)
		PopCh = LEFT(PopCh,LEN(PopCh) -1 )
      ENDIF
    ENDCASE
  ENDDO
ENDDO
RESTORE SCREEN FROM PopUp
IF ! EMPTY(NowAlias)
	SELE (NowAlias)
ENDI
RETURN
