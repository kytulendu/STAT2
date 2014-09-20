*
* Routine for create billing files for sending to Health Insurance Office
*
***************************************************************************
*SET EXCL OFF
*SET PROC TO J:\PUB\UTILITY
*DO STARTSET
*STORE 'j:\pub\' TO Patientdir
*STORE 'N:\CRH39\' TO BILLdir
*STORE 'C:\TEMP\' TO TEMPdir
*STORE 'J:\ipd\' TO ipddir

private LCDATE, LCMONTH, LCYY, LCMM, LCDD, LCOK, LCEDIT, LCCANCEL

if  .not. WEXIST('wrcreatedb') .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.PJX' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.SCX' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.MNX' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.PRG' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.FRX' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.QPR'
   define WINDOW WRCREATEDB FROM INT((SROWS()-9)/2), INT((SCOLS()-60)/2) TO INT((SROWS()-9)/2)+8, INT((SCOLS()-60)/2)+59 NOFLOAT NOCLOSE SHADOW NOMINIMIZE COLOR SCHEME 1
endif
LCMONTH = SPACE(7)
on KEY LABEL Esc KEYB CHR(7)
if WVISIBLE('wrcreatedb')
   activate WINDOW SAME WRCREATEDB
else
   activate WINDOW NOSHOW WRCREATEDB
endif
@ 2, 4 SAY 'เดือนที่ต้องการประมวลผลสิทธิการรักษา ' SIZE 1, 32, 0
@ 2, 40 GET LCMONTH DEFAULT ' ' SIZE 1, 7 PICTURE '99/9999' VALID _vmonth() MESSAGE 'ใส่เดือน ปีเป็นปีพุทธศักราช'
@ 5, 10 GET LCOK DEFAULT 1 SIZE 1, 9, 1 PICTURE '@*VT ถูกต้อง' VALID _vOK()
@ 5, 24 GET LCEDIT DEFAULT 1 SIZE 1, 7, 1 PICTURE '@*VN แก้ไข' VALID _vEdit()
@ 5, 36 GET LCCANCEL DEFAULT 1 SIZE 1, 8, 1 PICTURE '@*HN ยกเลิก' VALID _vCancel() MESSAGE 'ยกเลิกการทำงาน กลับเมนูเดิม'
if  .not. WVISIBLE('wrcreatedb')
   activate WINDOW WRCREATEDB
endif
read CYCLE
on KEY LABEL Esc
DO ENDSET
release WINDOW WRCREATEDB

********************
procedure _vmonth
********************
*if VAL(SUBSTR(LCMONTH,1,2))<=MONTH(DATE())
   if TRUEDATE('10/'+LCMONTH)
      @ ROW()+1, 28 SAY SUBSTR(CE2CBE(BE2CE('10/'+LCMONTH)),3,10)
   else
      wait WINDOW TIMEOUT 3 'ใส่วันที่เป็นปีพุทธศักราชไม่ถูกต้อง กรุณาใส่วันที่ใหม่'
      _CUROBJ = _CUROBJ
   endif
*else
*   wait WINDOW TIMEOUT 3 'ใส่เดือนในอนาคตหรือปัจจุบันไม่ได้'+CHR(13)+'กรุณาใส่เดือนใหม่'
*   _CUROBJ = _CUROBJ
*endif

********************
procedure _vOK
********************
on KEY LABEL Esc
LCMM = SUBSTR(LCMONTH,1,2)
LCYY = SUBSTR(LCMONTH,6,2)

*-- Check for existing of Billing file
if  FILE(BILLDIR+'all\RcPd.DBF')

	= OPENDBF(BILLDIR+'all\DtPd','DtPd')
	= OPENDBF(BILLDIR+'all\RcPd','RcPd')
	= OPENDBF(BILLDIR+'all\CreditPd','CreditPd')

	*-- Create Heading file
	select RCPD.RC_NO, RCPD.HN, RCPD.DATE, RCPD.TOTAL, RCPD.PAID;
	   FROM RCPD;
	   HAVING substr(dtos(CTOD('1/1/89')+RCPD.DATE),1,6) =;
    	substr(dtos(BE2CE('10/'+LCMONTH)),1,6);
       INTO DBF (TEMPDIR+'RCTEMP.DBF')
	= OPENDBF(TEMPDIR+'RCTEMP','RCTEMP')
	index ON RC_NO TAG RC_NO

	*-- Create Credit file
	select RCPD.RC_NO, CREDITPD.CR_ID ;
	   FROM RCPD, CREDITPD;
    	WHERE CREDITPD.RC_NO=RCPD.RC_NO;
	   HAVING substr(dtos(CTOD('1/1/89')+RCPD.DATE),1,6) =;
   		 substr(dtos(BE2CE('10/'+LCMONTH)),1,6);
	   ORDER BY RCPD.RC_NO;
     INTO DBF (TEMPDIR+'CREDTEMP.DBF')
	= OPENDBF(TEMPDIR+'CREDTEMP','CREDTEMP')
	index ON RC_NO TAG RC_NO

	*-- Create Detail file
	select DTPD.* FROM DTPD, RCPD;
	 WHERE RCPD.RC_NO==DTPD.RC_NO;
	  HAVING substr(dtos(CTOD('1/1/89')+RCPD.DATE),1,6) =;
   	 	 substr(dtos(BE2CE('10/'+LCMONTH)),1,6);
	  ORDER BY DTPD.RC_NO INTO DBF (TEMPDIR+'DTTEMP.DBF')
	= OPENDBF(TEMPDIR+'DTTEMP','DTTEMP')
	index ON RC_NO TAG RC_NO

	if  .not. FILE(TEMPDIR+'HeadRcNO.dbf')
	   create DBF TEMPDIR+'HeadRcNO';
    	( HN C ( 9 ), AN C ( 9 ), DATE D ,;
	     TOTAL N ( 7,0 ), PAID N ( 7,0 ), PTTYP C ( 2 ) )
	endif
	= OPENDBF(patientdir+'report\cht'+lcYY+lcMM,'HEADRCNO')

	if  .not. FILE(TEMPDIR+'DtRcNO.dbf')
	   create DBF TEMPDIR+'DtRcNO';
    	( HN C ( 9 ), AN C ( 9 ), DATE D ,;
	     CHRGITEM C ( 2 ), AMOUNT N ( 7,0 ) )
	endif
	= OPENDBF(patientdir+'report\cha'+lcYY+lcMM,'DTRCNO')

	*-- Create Sending file
	= OPENDBF(TEMPDIR+'CREDTEMP','CREDTEMP','RC_NO')
	= OPENDBF(TEMPDIR+'DTTEMP','DTTEMP','RC_NO')
	= OPENDBF(TEMPDIR+'RCTEMP','RCTEMP','RC_NO')
	SET RELATION OFF INTO DTTEMP
	SET RELATION OFF INTO RCTEMP
	SET RELATION TO RC_NO INTO DTTEMP
	SET RELATION TO RC_NO INTO CREDTEMP ADDITIVE

	GO TOP
	SCAN
		SCATTER MEMVAR
		IF ISDIGIT(SUBSTR(M.RC_NO,1,1))#.T.
			SELECT CREDTEMP
				M.PAID 	= 0
				M.PTTYPE = CREDTEMP.CR_ID
		ELSE
				M.PTTYE  = '10'
		ENDIF
		M.RCNODATE	= (CTOD('1/1/89')+M.DATE)
		M.DATE = M.RCNODATE
		SELECT DTTEMP
			DO WHILE DTTEMP.RC_NO = M.RC_NO
				IF EOF()
					EXIT
				ENDIF
				M.AMOUNT	=	DTTEMP.AMT
				DO CASE
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0A'
						M.CHRGITEM	=	'00'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0B'
						M.CHRGITEM	=	'01'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0C'
						M.CHRGITEM	=	'02'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0D'
						M.CHRGITEM	=	'03'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0E'
						M.CHRGITEM	=	'04'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0F'
						M.CHRGITEM	=	'05'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0G'
						M.CHRGITEM	=	'06'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0H'
						M.CHRGITEM	=	'07'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0I'
						M.CHRGITEM	=	'08'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0J'
						M.CHRGITEM	=	'09'
				ENDCASE
				INSERT INTO DTRCNO	 FROM MEMVAR	&& CREATE DTRCNO
				SKIP
			ENDDO
			INSERT INTO HEADRCNO FROM MEMVAR	&& CREATE HEADRCNO

		SELECT RCTEMP
	ENDSCAN

	SELECT CREDTEMP
	USE
	SELECT DTTEMP
	USE
	SELECT RCTEMP
	USE

	DELETE FILE TEMPDIR+'CREDTEMP.DBF'
	DELETE FILE TEMPDIR+'CREDTEMP.CDX'
	DELETE FILE TEMPDIR+'DTTEMP.DBF'
	DELETE FILE TEMPDIR+'DTTEMP.CDX'
	DELETE FILE TEMPDIR+'RCTEMP.DBF'
	DELETE FILE TEMPDIR+'RCTEMP.CDX'

ENDIF


********************
procedure _vEdit
********************
_CUROBJ = _CUROBJ-2

********************
procedure _vCancel
********************
release WINDOW WRCREATEDB
return TO MASTER

