
DEFINE WIND mostcommon FROM 8,20 TO 13,60 SHAD
STOR SPAC(8) TO startdate,enddate
ACTI WIND mostcommon
CLEA
@ 1,4 SAY 'ต้องการหาตั้งแต่วันที่  ' get startdate PICT '##/##/##' ;
VALID TRUEDATE(startdate)
@ 2,4 SAY '          ถึงวันที่     ' get enddate PICT '##/##/##' ;
VALID TRUEDATE(enddate)
READ NOLOCK
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
err_mth=''
many = startfile # endfile
STOR .F. TO monthly,yearly
IF startfile = endfile ;
.AND. DAY(mstartdate) = 1 .AND. DAY(menddate+1) = 1
	monthly = .T.
ELSE
	IF DAY(mstartdate) = 1 .AND. MONTH(mstartdate) = 10 .AND. ;
	DAY(menddate) = 30 .AND. MONTH(menddate) = 9 .AND. YEAR(menddate) ;
	= YEAR(mstartdate) + 1
		yearly = .T.
	ENDI
ENDI
DEFINE WIND rep2 FROM 10,10 TO 15,70 SHAD
ACTI WIND rep2
goon1=IIF(LASTKEY() = 27 ,'N', 'Y')
myear = FULLYEAR(menddate)
IF yearly .AND. FILE(opddir+'report\most'+myear+'.dbf')
   =TONE(600,10)
   goon1='N'
   CLEA
   @ 1,5 SAY 'แฟ้มปีงบประมาณ '+myear+'มีอยู่แล้ว'
   @ 3,6 SAY 'ต้องการคำนวณใหม่หรือไม่  ' GET goon1 PICT '!'
   READ NOLOCK
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
         	READ NOLOCK
      	ENDI
	ELSE
    	IF ! FILE(opddir+"came"+startfile+'.dbf') .AND. ! ;
    	FILE(opddir+"report\most"+startfile+'.dbf')
        	=TONE(600,10)
        	CLEA
			@ 1,2 SAY "ไม่มีแฟ้มข้อมูลรายงาน"+_type+" "+month&mm+' '+Fullyear(yy)
      		mkey=INKEY(30)
      		goon = 'N'
     	ENDI
   	ENDI
   	IF goon = 'Y'
	   	CLEA
	   	SELE 0
	   	mfile = tempdir+SYS(3)
		dbfuse = mfile
		CREA TABLE (mfile) (diag C(7),male N(10),female N(10),number N(10))
		INDEX ON DIAG TAG diag
		INDEX ON number TAG number ADDI
   		USE (mfile) ORDER 1 ALIA mostrep
   		dbfuse = ''
		@ 0,Center('โปรดคอยสักครู่') SAY 'โปรดคอยสักครู่'
		@ 2,Center('กำลังเตรียมข้อมูลทำรายงาน') SAY 'กำลังเตรียมข้อมูลทำรายงาน'
    	IF yearly
	    	SELE 0
	    	IF ! FILE(opddir+'report\most'+myear+'.dbf')
				dbfuse = opddir+'report\most'+myear
				CREA TABLE (opddir+'report\most'+myear) (diag C(7),male N(10),female N(10),number N(10))
				INDEX ON DIAG TAG diag
				INDEX ON number TAG number ADDI
	    		USE (opddir+'report\most'+myear) ORDER 1 ALIA yearrep
	    	ELSE
		    	dbfuse = opddir+'report\most'+myear
	    		USE (opddir+'report\most'+myear) ORDER 1 ALIA yearrep
				REPL ALL number WITH 0,male WITH 0,female WITH 0
				FLUSH
	    	ENDI
	    	dbfuse = ''
	    ENDI
	    SELE 0
	    Calfile = startfile
		DO WHIl calfile <= endfile
			IF FILE(opddir+'came'+calfile+'.dbf') .OR. FILE(opddir+'report\most'+calfile+'.dbf')
				IF calfile = startfile
					IF DAY(mstartdate) = 1
						IF calfile # endfile
							DO calmost WITH .T.
						ELSE
							DO calmost WITH DAY(menddate+1) = 1
						ENDI
					ELSE
						DO calmost WITH .F.
					ENDI
				ELSE
					IF calfile = endfile
						DO calmost WITH DAY(menddate+1) = 1
					ELSE
						DO calmost WITH .T.
					ENDI
				ENDI
			ENDI
			calfile = IIF( RIGHT(calfile,2)='12', ;
			RIGHT(STRZERO(VAL(LEFT(calfile,2))+1,3),2)+'01', ;
			STRZERO(VAL(calfile)+1,4) )
		ENDD
		RELE WIND progress
		KEYB '{HOME}'
		DO ShowReport
		SELE mostrep
		USE
		DELE FILE (mfile+'.dbf')
		DELE FILE (mfile+'.cdx')
		IF yearly
   			SELE yearrep
			USE
   		ENDI
    ENDI
ELSE
	IF yearly .AND. FILE(opddir+'report\most'+myear+'.dbf')
		dbfuse = opddir+'report\most'+myear
		USE (opddir+'report\most'+myear) ORDER 1 IN 0 ALIA mostrep
		dbfuse = ''
		DO ShowReport
		SELE mostrep
		USE
	ENDI
ENDI
RELE WIND rep2

PROC SHOWREPORT
		SELE mostrep
		SET ORDER TO TAG number DESC
		mostchoice = 1
		DO WHIL mostchoice > 0
			ACTI WIND rep2
			CLEA
			@ 1,3 PROMPT '1. รายงานโรค'
			@ 2,3 PROMPT '2. รายงานหัตถการ'
			@ 3,3 PROMPT '0. กลับรายการเดิม'
			MENU TO mostchoice
			mostchoice = IIF(mostchoice = 3, 0 ,mostchoice)
			IF mostchoice > 0
				CLEA
				@ 1,2 SAY 'ต้องการรายงานกี่ลำดับ ' GET numrep DEFA 10
				READ NOLOCK
				IF mostchoice = 1
					header = 'รายงานโรคที่พบบ่อย'
					fileseek = 'icd101'
					SET FILT TO LEFT(diag,1) # '*'
				ELSE
					header = 'รายงานหัตถการที่พบบ่อย'
					fileseek = 'icdcm1'
					SET FILT TO LEFT(diag,1) = '*'
				ENDI
				DEAC WIND rep2
				ACTI SCREE
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
				ON PAGE AT line _plength-2 DO mostheader WITH .T.,header
				PRINTJOB
					DO mostheader WITH .F.,header
					GO TOP
					numdisp = 1
					DO WHIL ! EOF() .AND. numdisp <= numrep
						SELE (fileseek)
						SEEK IIF(fileseek = 'icd101', mostrep.diag, SUBS(mostrep.diag,2))
						? STR(numdisp,4)+'. '+LEFT(ShowICD(mostrep.diag)+SPACE(7),7)+LEFT(desc,45)+;
						TRANSFORM(mostrep.number,'99,999,999,999')+TRANSFORM(mostrep.male,'9,999,999,999')+;
						TRANSFORM(mostrep.female,'9,999,999,999')
						SELE mostrep
						SKIP
						numdisp = numdisp+1
					ENDD
					?
					? 'หมายเหตุ'
					? SPAC(10)+'ข้อมูลตั้งแต่วันที่ '+CE2CBE(mstartdate)+' ถึงวันที่ '+CE2CBE(menddate)
					IF ! EMPTY(err_mth)
						? SPAC(10)+'ไม่พบข้อมูลเดือน '+err_mth
					ENDI
					?
				ENDPRINTJOB
				mkeylabel=ON('KEY','F1')
				ON KEY LABEL F1 DO helpbrow
				DO Endprint WITH '  รายงานโรคที่พบบ่อย  ',reportfile
				ON KEY LABEL F1 &mkeylabel
				DELE FILE &reportfile
	    	ENDI
	    ENDD

PROC CHEC_REP
checkfile = startfile
DO WHIL checkfile <= endfile
	yyy = LEFT(checkfile,2)
	mmm = RIGHT(checkfile,2)
	IF ! FILE(opddir+'came'+checkfile+'.dbf') .AND. ;
		! FILE(opddir+'report\most'+checkfile+'.dbf')
		=TONE(400,4)
		? 'ไม่พบแฟ้มเดือน'+month&mmm+' '+FULLYEAR(yyy)
		has_err=.T.               && ตรวจพบว่ามีแฟ้มบางเดือนขาดหายไป
		err_mth = err_mth + month&mmm+' '+FullYear(yyy) + ','
		=INKEY(.5)
	ENDI
   checkfile = IIF(mmm = '12', STRZERO(VAL(yyy)+1,2)+'01',yyy+STRZERO(VAL(mmm)+1,2))
ENDD
IF  has_err
	err_mth = LEFT(err_mth,LEN(err_mth)-1)
ENDI
*RELE WIND err_check

PROC CALMOST
PARA _makefile
PRIVATE _update
_update = .F.
SELE 0
IF _makefile
	openfile = opddir+'report\most'+calfile
	m1 = ADIR(arr1,openfile+'.dbf')
	m2 = ADIR(arr2,'came'+calfile+'.dbf')
	IF ! EMPTY(m1) .AND. ! EMPTY(m2)
		_update = DTOS(arr2[3])+arr2[4] > DTOS(arr1[3])+arr1[4]
		IF _update
			dbfuse = opddir+'came'+calfile
			USE (opddir+'came'+calfile) ORDER 1 ALIA source
		ELSE
			dbfuse = openfile
			USE (openfile) ORDER 1 ALIA source
		ENDI
		dbfuse = ''
	ELSE
		IF EMPTY(m1)
			dbfuse = openfile
			CREA TABLE (openfile) (diag C(7),male N(10),female N(10),number N(10))
			INDEX ON DIAG TAG diag
			INDEX ON number TAG number ADDI
			dbfuse = opddir+'came'+calfile
			USE (opddir+'came'+calfile) ORDER 1 ALIA source
			_update = .T.
		ELSE
			dbfuse = openfile
			USE (openfile) ORDER 1 ALIA source
		ENDI
		dbfuse = ''
	ENDI
	IF _update
		dbfuse = openfile
		USE (openfile) ORDER 1 IN 0 ALIA target
	ENDI
	dbfuse = ''
ELSE
	dbfuse = opddir+'came'+calfile
	USE (opddir+'came'+calfile) ORDER 1 ALIA source
ENDI
dbfuse = ''
SELE source
SET RELA TO diag INTO mostrep
IF _update
	SET RELA TO diag INTO target ADDI
ENDI
IF yearly
	SET RELA TO diag INTO yearrep ADDI
ENDI
div_num=ROUND((RECCOUNT()/40)+.5,0)
recno = 0
DO ShowProgress
calmm = RIGHT(calfile,2)
calyy = LEFT(calfile,2)
WAIT WIND NOWA 'กำลังคำนวณข้อมูลเดือน '+month&calmm+' พ.ศ. '+FULLYEAR(calyy)
SCAN
	recno=recno+1
	@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
	m.diag = source.diag
	IF EMPTY(mostrep.diag)
		INSERT INTO mostrep FROM MEMV
		FLUSH
	ENDI
	IF _update
		IF EMPTY(target.diag)
			INSERT INTO target FROM MEMV
			FLUSH
		ENDI
		IF BETWEEN(date,mstartdate,menddate) .AND. (episode < '3' .OR. ;
		BETWEEN(LEFT(diag,3),'Z23','Z27') .OR. LEFT(diag,1)='*')
			IF sex = '1'
				REPL mostrep.male WITH mostrep.male+1, ;
				target.male WITH target.male+1
				FLUSH
			ELSE
				REPL mostrep.female WITH mostrep.female+1, ;
				target.female WITH target.female+1
				FLUSH
			ENDI
			REPL mostrep.number WITH mostrep.number+1, ;
			target.number WITH target.number+1
			FLUSH
		ENDI
	ELSE
		IF _makefile
			REPL mostrep.male WITH mostrep.male+source.male, ;
			mostrep.female WITH mostrep.female+source.female, ;
			mostrep.number WITH mostrep.number+source.number
			FLUSH
		ELSE
			IF BETWEEN(date,mstartdate,menddate) .AND. (episode < '3' .OR. ;
			BETWEEN(LEFT(diag,3),'Z23','Z27') .OR. LEFT(diag,1)='*')
				IF sex = '1'
					REPL mostrep.male WITH mostrep.male+1, ;
					mostrep.number WITH mostrep.number+1
					FLUSH
				ELSE
					REPL mostrep.female WITH mostrep.female+1, ;
					mostrep.number WITH mostrep.number+1
					FLUSH
				ENDI
			ENDI
		ENDI
	ENDI
	IF yearly
		IF EMPTY(yearrep.diag)
			INSERT INTO yearrep FROM MEMV
			FLUSH
		ENDI
		IF _update
			IF episode < '3' .OR.  BETWEEN(LEFT(diag,3),'Z23','Z27') .OR. LEFT(diag,1)='*'
				IF sex = '1'
					REPL yearrep.male WITH yearrep.male+1, ;
					yearrep.number WITH yearrep.number+1
					FLUSH
				ELSE
					REPL yearrep.female WITH yearrep.female+1, ;
					yearrep.number WITH yearrep.number+1
					FLUSH
				ENDI
			ENDI
		ELSE
			REPL yearrep.male WITH yearrep.male+male, yearrep.female ;
			WITH yearrep.female+female, yearrep.number WITH ;
			yearrep.number+number
			FLUSH
		ENDI
	ENDI
ENDS
@ 3,4 SAY SPAC(40)
SELE source
USE
IF _update
	SELE target
	USE
ENDI

PROC MOSTHEADER
PARA _foreject,_header
PRIVATE mprint,mhosp
mhosp=TRIM(hosp_name)
*mtime1='ตั้งแต่วันที่ '+CE2CBE(startdate)+' ถึง วันที่ '+CE2CBE(enddate)
IF _foreject
	eject page
	eject
ENDI
mpagep='หน้าที่ '+LTRIM(STR(_pageno))
?mpagep+SPACE(CENTER(_header)-LEN(mpagep))+_header
?SPAC(CENTER(mhosp))+mhosp
?
? 'ลำดับที่ รหัสโรค          ชื่อโรค                                    รวม          ชาย          หญิง'
?
IF _foreject
	?
ENDI

