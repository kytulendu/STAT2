* ทำรายงานแยกโรคตามกลุ่มอายุ
CLOSE DATA
dbfuse = codedir+'icd101'
USE (codedir+'icd101') ORDER 1 IN 0
dbfuse = codedir+'icdcm1'
USE (codedir+'icdcm1') ORDER 1 IN 0
dbfuse = ''
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
IF yearly .AND. FILE(opddir+'report\opdr'+myear+'.dbf')
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
      	DO chec_oprep
      	IF has_err
         	goon='N'
         	yearly = .F.
         	?
         	@ ROW(),2 SAY 'ต้องการทำงานต่อไหม  ' GET goon PICT '!'
         	READ NOLOCK
      	ENDI
	ELSE
    	IF ! FILE(opddir+"came"+startfile+'.dbf') .AND. ! ;
    	FILE(opddir+"report\opdg"+startfile+'.dbf')
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
	   	mfile = IIF(yearly,opddir+'report\opdr'+myear,tempdir+SYS(3))
	   	dbfuse = mfile
		CREA TABLE (mfile) ;
		(diag C(7),SEX C(1),DESC C(30),A1 N(5),A2 N(5),A3 N(5),A4 N(5),;
		A5 N(5),A6 N(5),A7 N(5),A8 N(5),A9 N(5),A10 N(5),A11 N(5),A12 N(5),;
		A13 N(5),A14 N(5),A15 N(5),A16 N(5),A17 N(5),A18 N(5),A19 N(5),A20 N(5),TOTAL N(5),DEAD N(5))
		INDEX ON DIAG+SEX TAG diagsex
		INDEX ON desc+sex TAG desc ADDI
   		USE (mfile) ORDER 1 ALIA opdiag
   		dbfuse = ''
		@ 0,Center('โปรดคอยสักครู่') SAY 'โปรดคอยสักครู่'
		@ 2,Center('กำลังเตรียมข้อมูลทำรายงาน') SAY 'กำลังเตรียมข้อมูลทำรายงาน'
	    SELE 0
	    Calfile = startfile
		DO WHIl calfile <= endfile
			IF FILE(opddir+'came'+calfile+'.dbf') .OR. FILE(opddir+'report\opdg'+calfile+'.dbf')
				IF calfile = startfile
					IF DAY(mstartdate) = 1
						IF calfile # endfile
							DO calopdiag WITH .T.
						ELSE
							DO calopdiag WITH DAY(menddate+1) = 1
						ENDI
					ELSE
						DO calopdiag WITH .F.
					ENDI
				ELSE
					IF calfile = endfile
						DO calopdiag WITH DAY(menddate+1) = 1
					ELSE
						DO calopdiag WITH .T.
					ENDI
				ENDI
			ENDI
			calfile = IIF( RIGHT(calfile,2)='12', ;
			RIGHT(STRZERO(VAL(LEFT(calfile,2))+1,3),2)+'01', ;
			STRZERO(VAL(calfile)+1,4) )
		ENDD
		RELE WIND progress
		KEYB '{HOME}'
		DO ShowOpDi WITH 'รายงานผู้ป่วยนอก'
		SELE opdiag
		USE
		IF ! yearly
			DELE FILE (mfile+'.dbf')
			DELE FILE (mfile+'.cdx')
		ENDI
    ENDI
ELSE
	IF yearly .AND. FILE(opddir+'report\opdr'+myear+'.dbf')
		dbfuse = opddir+'report\opdr'+myear
		USE (opddir+'report\opdr'+myear) ORDER 1 IN 0 ALIA opdiag
		dbfuse = ''
		DO ShowOpDi WITH 'รายงานผู้ป่วยนอก'
		SELE opdiag
		USE
	ENDI
ENDI
RELE WIND rep2
CLOSE DATA
DO OpenCameDBF

PROC CHEC_OPREP
checkfile = startfile
DO WHIL checkfile <= endfile
	yyy = LEFT(checkfile,2)
	mmm = RIGHT(checkfile,2)
	IF ! FILE(opddir+'came'+checkfile+'.dbf') .AND. ;
		! FILE(opddir+'report\opdg'+checkfile+'.dbf')
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

PROC CALOPDIAG
PARA _makefile
PRIVATE _update
_update = .F.
SELE 0
IF _makefile
	openfile = opddir+'report\opdg'+calfile
	m1 = ADIR(arr1,openfile+'.dbf')
	m2 = ADIR(arr2,opddir+'came'+calfile+'.dbf')
	IF USED('source')
		SELE source
	ELSE
		SELE 0
	ENDI
	IF ! EMPTY(m1) .AND. ! EMPTY(m2)
		_update = DTOS(arr2[3])+arr2[4] > DTOS(arr1[3])+arr1[4]
		IF _update
			dbfuse = opddir+'came'+calfile
			USE (opddir+'came'+calfile) ALIA source
		ELSE
			dbfuse = openfile
			USE (openfile) ALIA source
		ENDI
		dbfuse = ''
	ELSE
		IF EMPTY(m1)
			dbfuse = openfile
			CREA TABLE (openfile) ;
		(diag C(7),SEX C(1),DESC C(30),A1 N(5),A2 N(5),A3 N(5),A4 N(5),;
		A5 N(5),A6 N(5),A7 N(5),A8 N(5),A9 N(5),A10 N(5),A11 N(5),A12 N(5),;
		A13 N(5),A14 N(5),A15 N(5),A16 N(5),A17 N(5),A18 N(5),A19 N(5),A20 N(5),TOTAL N(5),DEAD N(5))
		INDEX ON DIAG+SEX TAG diagsex
		INDEX ON desc+sex TAG desc ADDI
			USE (opddir+'came'+calfile) ALIA source
			_update = .T.
		ELSE
			dbfuse = openfile
			USE (openfile) ALIA source
		ENDI
		dbfuse = ''
	ENDI
	IF USED('target')
		SELE target
	ELSE
		SELE 0
	ENDI
	IF _update
		dbfuse = openfile
		USE (openfile) ORDER 1 IN 0 ALIA target
	ENDI
	dbfuse = ''
ELSE
	IF USED('source')
		SELE source
	ELSE
		SELE 0
	ENDI
	dbfuse = opddir+'came'+calfile
	USE (opddir+'came'+calfile) ALIA source
	dbfuse = ''
ENDI
SELE source
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
	m.sex = source.sex
	IF LEFT(m.diag,1) = '*' .OR. ISDIGIT(m.diag)
		fileseek = 'icdcm1'
		m.seek = IIF(LEFT(m.diag,1)='*',SUBS(m.diag,2),LEFT(m.diag,4))
	ELSE
		fileseek = 'icd101'
		m.seek = m.diag
	ENDI
	SELE (fileseek)
	SEEK m.seek
	m.desc = desc
	IF _update
		mage=con_age(source.age_type,source.age)
	ENDI
	SELE opdiag
	SEEK m.diag+m.sex
	seof = IIF(EOF(),.T.,.F.)
	IF _update
		IF BETWEEN(source.date,mstartdate,menddate) .AND. ;
		(source.episode < '3' .OR. ;
		BETWEEN(LEFT(diag,3),'Z23','Z27') .OR. LEFT(diag,1)='*')
			IF seof
				INSERT INTO opdiag FROM MEMV
			ENDI
			mdead = IIF(source.result='52',1,0)
			IF _makefile
				SELE target
				IF ! SEEK(m.diag+m.sex)
					INSERT INTO target FROM MEMV
				ENDI
				IF ! empty(mage)
				REPL a&mage WITH a&mage+1,total WITH total+1,;
				dead WITH dead+mdead
				ENDI
			ENDI
			SELE opdiag
			IF ! EMPTY(mage)
			REPL a&mage WITH a&mage+1,total WITH total+1,;
			dead WITH dead+mdead
			ENDI
		ENDI
	ELSE
		IF seof
			INSERT INTO opdiag FROM MEMV
		ENDI
		IF _makefile
			SELE opdiag
			REPL a1 WITH a1+source.a1,a2 WITH a2+source.a2,a3 WITH a3+source.a3,;
			a4 WITH a4+source.a4,a5 WITH a5+source.a5,a6 WITH a6+source.a6,;
			a7 WITH a7+source.a7,a8 WITH a8+source.a8,a9 WITH a9+source.a9
			REPL a10 WITH a10+source.a10,a11 WITH a11+source.a11,a12 WITH a12+source.a12,;
			a13 WITH a1+source.a13,a14 WITH a14+source.a14,a15 WITH a15+source.a15,a16 WITH a16+source.a16,;
			a17 WITH a17+source.a17,a18 WITH a18+source.a18,a19 WITH a19+source.a19,a20 WITH a20+source.a20,;
			total WITH total+source.total dead WITH dead+source.dead
		ELSE
			SELE opdiag
			IF BETWEEN(source.date,mstartdate,menddate) .AND. ;
			(source.episode < '3' .OR. ;
			BETWEEN(LEFT(diag,3),'Z23','Z27') .OR. LEFT(diag,1)='*')
				mage=con_age(source.age_type,source.age)
				mdead = IIF(source.result='52',1,0)
				IF ! EMPTY(mage)
				REPL a&mage WITH a&mage+1,dead WITH dead+mdead
				ENDI
			ENDI
		ENDI
	ENDI
	SELE source
ENDS
@ 3,4 SAY SPAC(40)
SELE source
USE
IF _update .AND. _makefile
	SELE target
	USE
ENDI

