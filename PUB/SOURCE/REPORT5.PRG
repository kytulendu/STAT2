PARA _typereport
*susp
CLOSE DATA
PRIVATE number,choice,numchoice,cond1,cond2,cond3,cond4,showfile
showfile = 'mju'
numchoice = 5
DIME choice(numchoice)
DO CASE
	CASE UPPE(_typereport) = 'O'
		number = '504'
		codedbf = 'code504'
		namedbf = 'name504'
		_mostfile = 'report\r504'    && รายงานที่จะออก
		_sourcefile = "report\opt"
		line0 = SPACE(65)+'แบบ รง.' + number
		line1 = 'รายงานผู้ป่วยนอกตามกลุ่มสาเหตุ (กลุ่มโรค) ประจำ'
	CASE UPPE(_typereport) = 'I'
		number = '505'
		codedbf = 'code505'
		namedbf = 'name505'
		_mostfile = 'report\r505'  		&& รายงานที่จะออก
		_sourcefile = 'report\ipt'
		line0 = SPACE(65)+'แบบ รง.' + number
		line1 = 'รายงานผู้ป่วยในตามกลุ่มสาเหตุ (กลุ่มโรค) ประจำ'
	CASE UPPE(_typereport) = 'A1'
		number = 'อุบัติเหตุจราจรผู้ป่วยนอก'
		codedbf = 'codeacc'
		namedbf = 'nameacc'
		_mostfile = 'report\acco'    && รายงานที่จะออก
		_sourcefile = "report\opt"
		line0 = SPACE(45)+'แบบรายงาน' + number
		line1 = 'รายงานผู้ป่วยนอกตามกลุ่มอุบัติเหตุจราจร ประจำ'
	CASE UPPE(_typereport) = 'A2'
		number = 'อุบัติเหตุจราจรผู้ป่วยใน'
		codedbf = 'codeacc'
		namedbf = 'nameacc'
		_mostfile = 'report\acci'  		&& รายงานที่จะออก
		_sourcefile = 'report\ipt'
		line0 = SPACE(45)+'แบบรายงาน' + number
		line1 = 'รายงานผู้ป่วยในตามกลุ่มอุบัติเหตุจราจร ประจำ'
ENDC

cond1 = IIF( _typereport $ 'O,A1', "episode1 $ '12'", '.T.')
cond2 = IIF( _typereport $ 'O,A1', "episode2 $ '12'", '.T.')
cond3 = IIF( _typereport $ 'O,A1', "episode3 $ '12'", '.T.')
cond4 = IIF( _typereport $ 'O,A1', "episode4 $ '12'", '.T.')
datecal = IIF( _typereport $ 'O,A1', 'date', 'datedsc' )

choice[1] = '1. รายงานรวม ' + number
choice[2] = '2. รายงานแยกเขต ' + number
choice[3] = '3. รายงานแยกจังหวัด ' + number
choice[4] = '4. รายงานแยกสถานบริการ ' + number
choice[numchoice] = '0. กลับรายการเดิม'

DEFIN WIND show1 FROM 6,10 TO 15,70 TITLE '  เลือกประเภทรายงาน  ' SHAD
ACTI WIND show1
FOR i = 1 TO numchoice
	@ 1 + i,10 PROMPT choice[i]
NEXT
MENU TO choice
RELE WIND show1
IF BETWEEN(choice,1,numchoice-1)
dbfuse = codedbf
dbfuse = IIF( FILE(dbfuse+'.DBF'), dbfuse, dbfuse + 'p')
USE (dbfuse) ALIA code IN 0		&& เปิดแฟ้ม CODE
dbfuse = namedbf
dbfuse = IIF( FILE(dbfuse+'.DBF'), dbfuse, dbfuse + 'p')
USE (dbfuse) ALIA name IN 0 && เปิดแฟ้ม NAME
dbfuse = ''
DEFINE WIND mostcommon FROM 8,10 TO 13,70 SHAD
PRIV startdate,enddate,mstartdate,menddate,mm1,yy1
STOR SPAC(8) TO startdate,enddate
ACTI WIND mostcommon
CLEA
@ 1,4 SAY 'ต้องการหารายงาน ' + number + ' ตั้งแต่วันที่  ' get startdate PICT '##/##/##' ;
VALID TRUEDATE(startdate)
@ 2,4 SAY '                     ถึงวันที่     ' get enddate PICT '##/##/##' ;
VALID TRUEDATE(enddate)
READ
mstartdate = BE2CE(startdate)
menddate = BE2CE(enddate)
IF menddate < mstartdate
	= SWAP(mstartdate,menddate)
	= SWAP(startdate,enddate)
ENDI
yy = RIGHT(startdate,2)
mm = SUBS(startdate,4,2)
yy1 = RIGHT(enddate,2)
mm1 = SUBS(enddate,4,2)
cstartdate = FULLYEAR(yy) + mm + LEFT(startdate,2)
cenddate = FullYear(yy1) + mm1 + LEFT(enddate,2)

RELE WIND mostcommon
startfile=RIGHT(startdate,2)+SUBS(startdate,4,2)
endfile=RIGHT(enddate,2)+SUBS(enddate,4,2)
err_mth=''
many = startfile # endfile
STOR .F. TO monthly,yearly
mthmsg = 'วันที่ ' + CE2CBE(mstartdate) + ' ถึงวันที่ ' + CE2CBE(menddate)
IF startfile = endfile ;
.AND. DAY(mstartdate) = 1 .AND. DAY(menddate+1) = 1
	monthly = .T.
	mthmsg = 'เดือน' + month&mm + ' ' + FULLYEAR(yy)
ELSE
	IF DAY(mstartdate) = 1 .AND. MONTH(mstartdate) = 10 .AND. ;
	DAY(menddate) = 30 .AND. MONTH(menddate) = 9 .AND. YEAR(menddate) ;
	= YEAR(mstartdate) + 1
		yearly = .T.
		mthmsg = 'ปีงบประมาณ ' + FULLYEAR(yy1)
	ENDI
ENDI
DEFINE WIND rep2 FROM 10,10 TO 15,70 SHAD
ACTI WIND rep2
goon1=IIF(LASTKEY() = 27 ,'N', 'Y')
myear = FULLYEAR(menddate)

IF yearly .AND. FILE(_mostfile+myear+'.dbf')
   =TONE(600,10)
   goon1='N'
   CLEA
   @ 1,5 SAY 'แฟ้มรายงาน ' + number + ' ปีงบประมาณ '+myear+'มีอยู่แล้ว'
   @ 3,6 SAY 'ต้องการคำนวณใหม่หรือไม่  ' GET goon1 PICT '!'
   READ
ENDI
IF goon1='Y'
	CLEA
	goon = 'Y'
	IF many
		@ 0,Center('โปรดคอยสักครู่') SAY 'โปรดคอยสักครู่'
      	@ 1,Center('กำลังตรวจสอบแฟ้มข้อมูลอยู่') SAY 'กำลังตรวจสอบแฟ้มข้อมูลอยู่'
      	has_err=.F.                 && ตั้งสมมติฐานว่ามีแฟ้มครบทุกเดือน
      	DO chec_rep
      	IF has_err
         	goon='N'
         	yearly = .F.
         	?
         	@ ROW(),2 SAY 'ต้องการทำงานต่อไหม  ' GET goon PICT '!'
         	READ
      	ENDI
	ELSE
    	IF ! FILE(_sourcefile+startfile+'.dbf') .AND. ! ;
    	FILE(_mostfile+startfile+'.dbf')
        	=TONE(600,10)
        	CLEA
			@ 1,2 SAY "ไม่มีแฟ้มข้อมูลรายงาน " +number +" เดือน"+month&mm+' '+Fullyear(yy)
      		mkey=INKEY(30)
      		goon = 'N'
     	ENDI
   	ENDI
   	IF goon = 'Y'
   		SELE name
   		numname = RECCOUNT()
   		SELE code
   		numrec = RECCOUNT()
		DIME hospcode[numrec],hospmin[numrec],hospmax[numrec]
		n = 1
		GO TOP
		DO WHIL ! EOF()
			hospcode[n] = code
			hospmin[n] = min
			hospmax[n] = max
			SKIP
			n = n+1
		ENDD
	   	mfile = SYS(3)
	   	tempfile = SYS(3)
	   	tempfile1 = SYS(3)
		dbfuse = mfile
		CREA TABLE (mfile) (srv_code C(12),diag C(7),male N(10),female N(10),number N(10))
		INDEX ON srv_code+DIAG TAG diag
		INDEX ON number TAG number ADDI
   		USE (mfile) ORDER 1 ALIA mostrep
   		dbfuse = ''
		@ 0,Center('โปรดคอยสักครู่') SAY 'โปรดคอยสักครู่'
		@ 2,Center('กำลังเตรียมข้อมูลทำรายงาน') SAY 'กำลังเตรียมข้อมูลทำรายงาน'
	    Calfile = startfile
		DO WHIl calfile <= endfile
			IF FILE(_sourcefile+calfile+'.dbf') .OR. FILE(_mostfile+calfile+'.dbf')
				smm = RIGHT(calfile,2)
				syy = LEFT(calfile,2)
				WAIT WIND NOWA 'โปรดคอย ! กำลังทำรายงานแฟ้มข้อมูลเดือน' + month&smm + ' ' + FULLYEAR(syy)
				IF calfile = startfile
					IF DAY(mstartdate) = 1
						IF calfile # endfile
							DO cal5 WITH .T.
						ELSE
							DO cal5 WITH DAY(menddate+1) = 1
						ENDI
					ELSE
						DO cal5 WITH .F.
					ENDI
				ELSE
					IF calfile = endfile
						DO cal5 WITH DAY(menddate+1) = 1
					ELSE
						DO cal5 WITH .T.
					ENDI
				ENDI
			ENDI
			calfile = IIF( RIGHT(calfile,2)='12', ;
			RIGHT(STRZERO(VAL(LEFT(calfile,2))+1,3),2)+'01', ;
			STRZERO(VAL(calfile)+1,4) )
		ENDD
*		RELE WIND progress
		KEYB '{HOME}'
		SELE mostrep
		TOTAL ON srv_code+diag TO (tempfile1) FOR ! EMPTY(diag)
		USE (tempfile1) ALIA mostrep
		DELE FILE (mfile + '.dbf')
		DELE FILE (mfile + '.cdx')
		REPL ALL number WITH male+female
		INDEX ON srv_code+diag TAG srv_diag
		INDEX ON diag TAG diag ADDI
		INDEX ON number TAG number ADDI
		DO FINDR5  		&& ทำรายงานแยกตามต้องการ
		CLOSE DATA
		DELE FILE (tempfile+'.dbf')
		DELE FILE (showfile + '.dbf')
		IF Yearly
			IF FILE(_mostfile+myear+'.dbf')
				DELE FILE (_mostfile+myear+'.dbf')
				DELE FILE (_mostfile+myear+'.cdx')
			ENDI
			RENA (tempfile1+'.dbf) TO (_mostfile+myear+'.dbf')
			RENA (tempfile1+'.cdx) TO (_mostfile+myear+'.cdx')
		ELSE
			DELE FILE (tempfile1+'.dbf')
			DELE FILE (tempfile1+'.cdx')
		ENDI
    ENDI
ELSE
	IF yearly .AND. FILE(_mostfile+myear+'.dbf')
		dbfuse = _mostfile+myear
		yearfile = SYS(3)
		USE (_mostfile+myear) ORDER 1 IN 0 ALIA mostrep
		SELE mostrep
		COPY TO (yearfile) CDX
		USE (yearfile) ORDER 1 ALIA mostrep
		SELE mostrep
		dbfuse = ''
		DO FindR5
		CLOSE DATA
		DELE FILE (showfile + '.dbf')
		DELE FILE (yearfile + '.dbf')
		DELE FILE (yearfile + '.cdx')
	ENDI
ENDI
ENDI
CLOSE DATA
RELE WIND rep2

PROC SHOWREPORT
PRIVATE numcase
_PEJECT = 'AFTER'
SET PRINT ON
SET CONS OFF
SELE name
numrec = RECCOUNT()
GO TOP
PRINTJOB
mpagep='- '+LTRIM(STR(_pageno))+' -'

? line0
? line1 + mthmsg
? line2
?'ชื่อผู้รายงาน ................................ ตำแหน่ง .......................'
?'วันเดือนปีที่รายงาน  ' + CE2CBE(DATE())
DO rbheader WITH .F.

? SPACE(50),'รวมทั้งหมด    ',TRANSFORM(totalnum,'999,999,999')
FOR i = 1 TO numrec
	numcase = 0
	SELE showfile
	IF diag = STR(i,3)
		numcase = number
		SKIP
	ENDI
	SELE name
	? STR(i,3)+'.',LEFT(desc,60),TRANSFORM(numcase,'999,999,999')
	SKIP
NEXT
?
ENDPRINTJOB
SET PRIN OFF
SET CONS ON

PROC PRINTREPORT
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpbrow
DO Endprint WITH '  รายงานโรค 504  ',reportfile
ON KEY LABEL F1 &mkeylabel
DELE FILE &reportfile
IF USED('r504')
	SELE r504
	USE
ENDI
*CLOSE DATA

PROC rbheader
PARA _foreject,_header
PRIVATE mprint,mhosp
IF _foreject
	eject page
	eject
	mpagep='- '+LTRIM(STR(_pageno))+' -'
	?SPACE(37)+mpagep
?
ENDI
?'..............................................................................'
?' ลำดับที่            สาเหตุการป่วย (กลุ่มโรค)                           จำนวน '
?'..............................................................................'

IF _foreject
	?
ENDI


PROC CAL5
PARA _makefile
PRIVATE _update
_update = .F.
SELE 0
sourcefile = _sourcefile+calfile
IF _makefile
	targetfile = _mostfile+calfile
	m1 = ADIR(arr1,targetfile+'.dbf')
	m2 = ADIR(arr2,_sourcefile+calfile+'.dbf')
	IF ! EMPTY(m1) .AND. ! EMPTY(m2)
		_update = DTOS(arr2[3])+arr2[4] > DTOS(arr1[3])+arr1[4]
		IF _update
			DO SQLR5
		ENDI
		dbfuse = ''
	ELSE
		IF EMPTY(m1)
			DO SQLR5
		ENDI
	ENDI
	SELE mostrep
	APPE FROM (targetfile)
ELSE
	targetfile = SYS(3)
	DO SQLR5
	SELE mostrep
	APPE FROM (targetfile)
	DELE FILE (targetfile+'.dbf')
ENDI

PROC SQLR5
DEFINE WIND showsql FROM 4,50 TO 7,79 SHAD
ACTI WIND showsql
SET TALK ON
	SELE srv_code, R5DIAG(dg1) AS diag,SUM(IsOne(sex)) AS male,SUM(IsTwo(sex)) ;
	AS female ;
	FROM (sourcefile) WHERE ! EMPTY(dg1) AND &cond1 GROUP BY srv_code,dg1 ;
UNION ALL ;
	SELE srv_code, R5DIAG(dg2) AS diag,SUM(IsOne(sex)) AS male,SUM(IsTwo(sex)) ;
	AS female ;
	FROM (sourcefile) WHERE ! EMPTY(dg2) AND &cond2 GROUP BY srv_code,dg2 ;
UNION ALL ;
	SELE srv_code, R5DIAG(dg3) AS diag,SUM(IsOne(sex)) AS male,SUM(IsTwo(sex)) ;
	AS female ;
	FROM (sourcefile) WHERE ! EMPTY(dg3) AND &cond3 GROUP BY srv_code,dg3 ;
UNION ALL ;
	SELE srv_code, R5DIAG(dg4) AS diag,SUM(IsOne(sex)) AS male,SUM(IsTwo(sex)) ;
	AS female ;
	FROM (sourcefile) WHERE ! EMPTY(dg4) AND &cond4 GROUP BY srv_code,dg4 ;
HAVING BETWEEN(&datecal,cstartdate,cenddate) INTO TABLE (tempfile)
SET TALK OFF
INDEX ON srv_code+diag TAG diag
TOTAL ON srv_code+diag TO (targetfile) FOR ! EMPTY(diag)

PROC FINDR5
		showfile = SYS(3)
		DO CASE
			CASE choice = 1
				SET ORDER TO TAG diag
				TOTAL ON diag TO (showfile)
				SELE 0
				dbfuse = showfile
				USE (showfile) ALIA showfile
				SUM number TO totalnum
				GO TOP
				line2 = 'ชื่อหน่วยงาน  ' + hosp_name
				reportfile=SYS(3)+'.txt'
				SET PRIN TO &reportfile
				DO ShowReport
				DO PrintReport
			CASE choice = 2
				USE codezone IN 0 AGAIN
				SELE codezone
				numrec = RECCOUNT()
				DIME hospcode[numrec],hospmin[numrec],hospmax[numrec]
				n = 1
				GO TOP
				DO WHIL ! EOF()
					hospcode[n] = code
					hospmin[n] = min
					hospmax[n] = max
					SKIP
					n = n+1
				ENDD
				SELE mostrep
				REPL ALL srv_code WITH HospZone(SUBS(srv_code,5,2))
				SET ORDER TO TAG srv_diag
				TOTAL ON srv_code + diag TO (showfile) FOR ! EMPTY(diag)
				USE (showfile) IN 0 ALIA showfile
				SELE showfile
				DIME place[100],codeplace[100]
				place[1] = 'ทุกสาธารณสุขเขต  '
				codeplace[1] = '  '
				GO TOP
				n =  1
				precode = 'xxx'
				reportfile=SYS(3)+'.txt'
				DO WHIL ! EOF()
					IF srv_code # precode
						n = n + 1
						codeplace[n] = srv_code
						khet = ALLTRIM(srv_code)
						khet = IIF(LEFT(khet,1) = '0', SUBS(khet,2), khet)
						place[n] = 'สาธารณสุขเขต ' + khet
						precode = srv_code
					ENDI
					SKIP
				ENDD
				mchoice = 1
				DEAC WIND ALL
				DEFI WIND showchoice FROM 6,15 TO 9,65

				DO WHIL mchoice > 0
					Clear TYPEAHEAD
					ACTI WIND showchoice
					? '  โปรดเลือกว่าจะทำรายงานสาธารณสุขเขตไหน '
					? '  กด [ESC] เมื่อเลิกทำ'
					ACTI SCREE
					SET CONF ON
					@  10,20 MENU place,n,10
					READ MENU TO mchoice
					SET CONF OFF
					DEAC WIND showchoice
					IF mchoice > 0
						IF mchoice = 1
							SELE showfile
							GO TOP
							precode = srv_code
							DO WHIL ! EOF()
								SUM number TO totalnum FOR srv_code = precode
								LOCA FOR srv_code = precode
								khet = ALLTRIM(precode)
								khet = IIF(LEFT(khet,1) = '0', SUBS(khet,2), khet)
								line2 = 'ชื่อหน่วยงาน  ' + 'สาธารณสุขเขต ' + khet
								SET PRIN TO &reportfile ADDI
								DO ShowReport
								SELE showfile
								DO WHIL srv_code = precode .AND. ! EOF()
									SKIP
								ENDD
								precode = srv_code
							ENDD
							DO PrintReport
						ELSE
							reportfile = SYS(3) + '.txt'
							SELE showfile
							SUM number TO totalnum FOR srv_code = codeplace[mchoice]
							LOCA FOR srv_code = codeplace[mchoice]
							khet = ALLTRIM(srv_code)
							khet = IIF(LEFT(khet,1) = '0', SUBS(khet,2), khet)
							line2 = 'ชื่อหน่วยงาน  ' + 'สาธารณสุขเขต ' + khet
							SET PRIN TO &reportfile ADDI
							DO ShowReport
							DO PrintReport
						ENDI
					ENDI
				ENDD
			CASE choice = 3
				USE address IN 0 ORDER 1 AGAIN
				SELE mostrep
				REPL ALL srv_code WITH SUBS(srv_code,5,2)
				SET ORDER TO TAG srv_diag
				TOTAL ON srv_code + diag TO (showfile) FOR ! EMPTY(diag)
				USE (showfile) IN 0 ALIA showfile
				SELE showfile
				DIME place[100],codeplace[100]
				place[1] = 'ทุกจังหวัด  '
				codeplace[1] = '  '
				GO TOP
				n =  1
				precode = 'xxx'
				reportfile=SYS(3)+'.txt'
				DO WHIL ! EOF()
					IF srv_code # precode
						n = n + 1
						codeplace[n] = srv_code
						SELE address
						SEEK '1' + TRIM(codeplace[n])
						place[n] = TRIM(name) + '  '
						SELE showfile
						precode = srv_code
					ENDI
					SKIP
				ENDD
				mchoice = 1
				DEAC WIND ALL
				DEFI WIND showchoice FROM 6,15 TO 9,65

				DO WHIL mchoice > 0
					Clear TYPEAHEAD
					ACTI WIND showchoice
					? '  โปรดเลือกว่าจะทำรายงานจังหวัดไหน '
					? '  กด [ESC] เมื่อเลิกทำ'
					ACTI SCREE
					SET CONF ON
					@  10,20 MENU place,n,10
					READ MENU TO mchoice
					SET CONF OFF
					DEAC WIND showchoice
					IF mchoice > 0
						IF mchoice = 1
							SELE showfile
							GO TOP
							precode = srv_code
							DO WHIL ! EOF()
								SUM number TO totalnum FOR srv_code = precode
								LOCA FOR srv_code = precode
								line2 = 'ชื่อหน่วยงาน  ' + 'จังหวัด ' + place[ASCAN(codeplace,srv_code)]
								SET PRIN TO &reportfile ADDI
								DO ShowReport
								SELE showfile
								DO WHIL srv_code = precode .AND. ! EOF()
									SKIP
								ENDD
								precode = srv_code
							ENDD
							DO PrintReport
						ELSE
							reportfile = SYS(3) + '.txt'
							SELE showfile
							SUM number TO totalnum FOR srv_code = codeplace[mchoice]
							LOCA FOR srv_code = codeplace[mchoice]
							line2 = 'ชื่อหน่วยงาน  ' + 'จังหวัด ' + place[mchoice]
							SET PRIN TO &reportfile ADDI
							DO ShowReport
							DO PrintReport
						ENDI
					ENDI
				ENDD
			CASE choice = 4
				USE hospcode ORDER 1 IN 0 AGAIN
				SELE mostrep
				SET ORDER TO TAG srv_diag
				TOTAL ON srv_code + diag TO (showfile) FOR ! EMPTY(diag)
				USE (showfile) IN 0 ALIA showfile
				SELE showfile
				DIME place[100],codeplace[100]
				place[1] = 'ทุกสถานบริการ  '
				codeplace[1] = '  '
				GO TOP
				n =  1
				precode = 'xxx'
				reportfile=SYS(3)+'.txt'
				DO WHIL ! EOF()
					IF srv_code # precode
						n = n + 1
						IF n > 100
							DIME place[n],codeplace[n]
						ENDI
						codeplace[n] = srv_code
						SELE hospcode
						SEEK codeplace[n]
						place[n] = TRIM(name) + '  '
						SELE showfile
						precode = srv_code
					ENDI
					SKIP
				ENDD
				mchoice = 1
				DEAC WIND ALL
				DEFI WIND showchoice FROM 6,15 TO 9,65

				DO WHIL mchoice > 0
					Clear TYPEAHEAD
					ACTI WIND showchoice
					? '  โปรดเลือกว่าจะทำรายสถานบริการไหน '
					? '  กด [ESC] เมื่อเลิกทำ'
					ACTI SCREE
					SET CONF ON
					@  10,20 MENU place,n,10
					READ MENU TO mchoice
					SET CONF OFF
					DEAC WIND showchoice
					IF mchoice > 0
						IF mchoice = 1
							SELE showfile
							GO TOP
							precode = srv_code
							DO WHIL ! EOF()
								SUM number TO totalnum FOR srv_code = precode
								LOCA FOR srv_code = precode
								line2 = 'ชื่อหน่วยงาน  ' + DE_NAME(place[ASCAN(codeplace,precode)])
								SET PRIN TO &reportfile ADDI
								DO ShowReport
								SELE showfile
								DO WHIL srv_code = precode .AND. ! EOF()
									SKIP
								ENDD
								precode = srv_code
							ENDD
							DO PrintReport
						ELSE
							reportfile = SYS(3) + '.txt'
							SELE showfile
							SUM number TO totalnum FOR srv_code = codeplace[mchoice]
							LOCA FOR srv_code = codeplace[mchoice]
							line2 = 'ชื่อหน่วยงาน  ' + DE_NAME(place[mchoice])
							SET PRIN TO &reportfile ADDI
							DO ShowReport
							DO PrintReport
						ENDI
					ENDI
				ENDD
		ENDC
