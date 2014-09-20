IF ! FILE('CODEACCI.DBF')
	dbfuse = 'CODEACCP'
	USE codeaccp IN 0 ALIA code
ELSE
	dbfuse = 'CODEACCI'
	USE codeacci IN 0 ALIA code
ENDI
IF ! FILE('NAMEACCI.DBF')
	dbfuse = 'NAMEACCP'
	USE nameaccp IN 0 ALIA name
ELSE
	dbfuse = 'NAMEACCI'
	USE nameacci IN 0 ALIA name
ENDI
dbfuse = ''
SELE name
numrec = RECCOUNT()
DEFINE WIND mostcommon FROM 8,20 TO 13,60 SHAD
STOR SPAC(8) TO startdate,enddate
ACTI WIND mostcommon
CLEA
@ 1,4 SAY 'ต้องการหาตั้งแต่วันที่  ' get startdate PICT '##/##/##' ;
VALID TRUEDATE(startdate)
@ 2,4 SAY '          ถึงวันที่     ' get enddate PICT '##/##/##' ;
VALID TRUEDATE(enddate)
READ NOLOCK
IF LASTKEY() = 27
	SELE code
	USE
	SELE name
	USE
	RELE WIND mostcommon
	RETU
ENDI
mstartdate = BE2CE(startdate)
menddate = BE2CE(enddate)
IF menddate < mstartdate
	= SWAP(mstartdate,menddate)
	= SWAP(startdate,enddate)
ENDI
mm = RIGHT(startdate,2)
yy = SUBS(startdate,4,2)
mm1 = RIGHT(enddate,2)
yy1 = SUBS(enddate,4,2)

RELE WIND mostcommon
startfile=RIGHT(startdate,2)+SUBS(startdate,4,2)
endfile=RIGHT(enddate,2)+SUBS(enddate,4,2)
errmonth=''
*********************	เริ่มวนลูปเพื่อคำนวณข้อมูล
EXTERNAL ARRAY Tmonth
SELE code
numcode=RECCOUNT()
DIME codeacc[numcode,3]
COPY TO ARRAY codeacc
DIME rbnum(numrec*2)
FOR i = 1 TO numrec
	STOR 0 TO rbnum(i),rbnum[i+numrec]
NEXT
DO WHIL startfile <= endfile
	err=TMONTH(VAL(RIGHT(startfile,2)))+' '+FULLYEAR(LEFT(startfile,2))
	IF ! FILE(opddir+'CAME'+startfile+'.dbf')
		?? CHR(7)
		WAIT WIND 'ไม่พบแฟ้มเดือน'+err NOWAIT
		errmonth = errmonth+' '+err+','
	ELSE
		WAIT WIND 'กำลังคำนวณข้อมูลเดือน' + err NOWAIT
		SELE 0
		IF USED('SOURCEFILE')
			SELE sourcefile
		ENDI
		dbfuse = opddir+'CAME'+startfile
		USE (opddir+'came'+startfile) ALIA sourcefile
		dbfuse = ''
		div_num=ROUND((RECCOUNT()/40)+.5,0)
		recno = 0
		DO ShowProgress
		SCAN FOR BETWEEN(date,mstartdate,menddate)
			recno=recno+1
			@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
			IF episode<'3' .AND. LEFT(diag,1)#'*'
				mdiag = LEFT(diag,4)
				FOR nn = 1 TO numcode
					ret_code =IIF(BETWEEN(mdiag,codeacc[nn,2],codeacc[nn,3]),codeacc[nn,1],0)
					IF ret_code>0
						psex = IIF(sex='1',0,1)
						rbnum(ret_code+(psex*numrec)) = rbnum(ret_code+(psex*numrec))+1
					ENDI
				NEXT
			ENDI
		ENDS
	ENDI
	IF RIGHT(startfile,2)='12'	&& เพิ่มเดือนทีละหนึ่งเดือน
		startfile=STRZERO(VAL(LEFT(startfile,2))+1,2)+'01'
	ELSE
		startfile=LEFT(startfile,2)+STRZERO(VAL(RIGHT(startfile,2))+1,2)
	ENDI
ENDD
KEYB ' '
totalnum = 0
reportfile=tempdir+SYS(3)+'.txt'
SET PRINT TO &reportfile
SET PRINT ON
SET CONS OFF
_wrap=.F.
_plength=41
_peject='NONE'
_pageno=1
_plineno=0
_PLOFFSET = 0
ON PAGE AT line _plength-2 DO rbheader WITH .T.
CLEA
shwmsg = 'โปรดคอย กำลังพิมพ์รายงานอยู่'
@ 3,Center(shwmsg) SAY shwmsg
ACTI SCREE
PRINTJOB
	mhosp='จำนวนผู้ป่วยอุบัติเหตุจราจรของ '+TRIM(hosp_name)
	msg2 = 'ตั้งแต่วันที่ '+CE2CBE(mstartdate)+' ถึง '+CE2CBE(menddate)
	SELE name
	GO TOP
	? SPAC(Center(mhosp))+mhosp
	? SPAC(Center(msg2))+msg2
?'..........................................................................'
?' ลำดับที่            สาเหตุการป่วย (กลุ่มโรค)         ชาย    หญิง      รวม'
?'..........................................................................'
	STOR 0 TO totalmale,totalfemal
	FOR i = 1 TO numrec
		? LEFT(desc,50)+TRANSFORM(rbnum[i],'999,999')+;
		TRANSFORM(rbnum[i+numrec],'999,999')+;
		TRANSFORM(rbnum[i]+rbnum[i+numrec],'999,999,999')
		totalmale = rbnum[i]+totalmale
		totalfemale = rbnum[i+numrec]+totalfemale
		SKIP
	NEXT
	? SPACE(40),'รวม  '+SPACE(4)+TRANSFORM(totalmale,'999,999')+;
		TRANSFORM(totalfemale,'999,999')+;
		TRANSFORM(totalmale+totalfemale,'999,999,999')
	?
ENDPRINTJOB
RELE WIND progress
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpbrow
DO Endprint WITH '  รายงานโรคผู้ป่วยอุบัติเหตุจราจร  ',reportfile
ON KEY LABEL F1 &mkeylabel
DELE FILE &reportfile
SELE code
USE
SELE name
USE
IF USED('sourcefile')
	SELE sourcefile
	USE
ENDI
