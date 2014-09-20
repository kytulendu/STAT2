*
* Routine for create billing files for sending to Health Insurance Office
*
***************************************************************************
private LCDATE, LCMONTH, LCYY, LCMM, LCDD, LCOK, LCEDIT, LCCANCEL, LCyyyy

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
@ 2, 4 SAY 'เดือนที่ต้องการตรวจสอบ  ' SIZE 1, 32, 0
@ 2, 40 GET LCMONTH DEFAULT ' ' SIZE 1, 7 PICTURE '99/9999' VALID _vmonth() MESSAGE 'ใส่เดือน ปีเป็นปีพุทธศักราช'
@ 5, 10 GET LCOK DEFAULT 1 SIZE 1, 9, 1 PICTURE '@*VT ถูกต้อง' VALID _vOK()
@ 5, 24 GET LCEDIT DEFAULT 1 SIZE 1, 7, 1 PICTURE '@*VN แก้ไข' VALID _vEdit()
@ 5, 36 GET LCCANCEL DEFAULT 1 SIZE 1, 8, 1 PICTURE '@*HN ยกเลิก' VALID _vCancel() MESSAGE 'ยกเลิกการทำงาน กลับเมนูเดิม'
if  .not. WVISIBLE('wrcreatedb')
   activate WINDOW WRCREATEDB
endif
READ NOLOCK CYCLE
on KEY LABEL Esc
release WINDOW WRCREATEDB

********************
procedure _vmonth
********************
*if VAL(SUBSTR(LCMONTH,1,2))<=MONTH(DATE())
   if TRUEDATE('10/'+LCMONTH)
      @ ROW()+1, 28 SAY SUBSTR(CE2CBE(BE2CE('10/'+LCMONTH)),3,14)
   else
      wait WINDOW TIMEOUT 3 'ใส่วันที่เป็นปีพุทธศักราชไม่ถูกต้อง กรุณาใส่วันที่ใหม่'
      _CUROBJ = _CUROBJ
   endif
*else
*   wait WINDOW TIMEOUT 3 'ใส่เดือนในอนาคตหรือปัจจุบันไม่ได้'+CHR(13)+'กรุณาใส่เดิอนใหม่'
*   _CUROBJ = _CUROBJ
*endif

********************
procedure _vOK
********************
on KEY LABEL Esc
LCyyyy = RIGHT(LCMONTH,4)
LCMM = SUBSTR(LCMONTH,1,2)
LCYY = SUBSTR(LCMONTH,6,2)

********************************************************
*  เปิดแฟ้มที่จะต้องใช้ในการตรวจสอบข้อมูลคนไข้         *
********************************************************
m.hcode = hosp_code
SET EXCL ON
= OpenDBF(ipddir + 'report\ins' + lcyy + lcmm, 'ins')
= OpenDBF(ipddir + 'report\ipd' + lcyy + lcmm, 'ipd')
= OpenDBF(ipddir + 'report\irf' + lcyy + lcmm, 'irf')
= OpenDBF(ipddir + 'report\idx' + lcyy + lcmm, 'idx')
* = OpenDBF(ipddir + 'report\iop' + lcyy + lcmm, 'iop')
= OpenDBF(ipddir + 'report\pat' + lcyy + lcmm, 'pat')
canopen = .T.
SET EXCL OFF
canopen = Opendbf(patientdir + 'patient1', 'patient1','hn')
* canopen = IIF(Opendbf(patientdir + 'insure', 'insure', 1), canopen, .F.)
* canopen = IIF(Opendbf(patientdir + 'patient2', 'patient2', 1), canopen, .F.)
canopen = IIF(Opendbf(patientdir + 'pttyp', 'pttyp','pttyp'), canopen, .F.)
canopen = IIF(Opendbf(patientdir + 'social', '', 1), canopen, .F.)
lcyymm = lcyy + lcmm
IF ! canopen
	?? CHR(7)
	WAIT WIND NOWA 'ไม่มีข้อมูลผู้ป่วยเพียงพอที่จะทำรายงาน'
	RETU
ELSE

************************************************************
*  ตรวจสอบข้อมูลผู้ป่วยในที่จะส่งให้สำนักงานประกันสุขภาพ              *
************************************************************
	DO ShowProgress
	SELE ins
	INDEX ON hn TAG hn
	SELE 0
* udc	CREATE TABLE tempipd (hn C(7), name C(30), inscl C(2), typname C(40), ;
* udc	number N(1) )
* udc
	CREATE TABLE tempipd (hcode C(5), an C(7), hn C(7), typname C(40), dateadm D, ;
	datedsc D, los N(4), CALLOS N(3), DISCHS C(1), DISCHT C(1), namepat C(30), ;
	PERSON_ID C(13), DOB D, AGE C(3), AGEDAY C(3), ADMWT N(7.3), SEX C(1), ;
	CHANGWAT C(2), AMPHUR C(2), MARRIAGE C(1), OCCUPA C(3), NATION C(2), ;
	WARDDSC C(4), DEPT C(2), DRDX C(6), PDX C(7), SDX1 C(7), SDX2 C(7), SDX3 C(7), ;
	SDX4 C(7), SDX5 C(7), SDX6 C(7), SDX7 C(7), SDX8 C(7), SDX9 C(7), SDX10 C(7), ;
	SDX11 C(7), SDX12 C(7), DROP C(6), PROC1 C(7), PROC2 C(7), PROC3 C(7), ;
	PROC4 C(7), PROC5 C(7), PROC6 C(7), PROC7 C(7), PROC8 C(7), PROC9 C(7), ;
	PROC10 C(7), PROC11 C(7), PROC12 C(7), PTTYP C(2), GRP N(2), inscl C(2), ;
	SUBTYPE C(2), CID C(16), REFER C(12), REFERTYPE C(1), HOSPMAIN C(5), ;
	HOSPSUB C(5), OPERATE N(7), X_RAY N(7), LAB N(7), SURGERY N(7), SERVICE N(7), ;
	DRUG N(7), ICU N(7), ROOM N(7), FOOD N(7), OTHERS N(7), TOTAL N(7), PAID N(7), ;
	MDC C(2), DRG C(5), RW N(7.4), ADJRW N(7.4), WTLOS N(6.2), OT N(4), RESULT C(1), ;
	ERR N(2), WARN N(4), number N(1) )
* udc
	INDEX ON inscl TAG inscl
	SELE ipd
	SET RELA TO hn INTO ins
	m.number = 1
	div_num=ROUND((RECCOUNT()/40)+.5,0)
	recno = 0
	SCAN
		recno=recno+1
		@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
		SCAT MEMV
*		SELE ipd.hn, ins.name, ins.inscl, pttyp.typname, 1 AS number FROM ipd, ins, pttyp WHERE ;
*	ipd.hn = ins.hn and ins.inscl = pttyp.pttyp ORDER BY ins.inscl INTO CURSOR tempipd
		IF ! EOF('ins')
* udc			m.name = ins.name
*** udc
	SELE pat
	INDEX ON hn TAG hn
*	SET RELA TO hn INTO ins
*** udc
			= SEEK(m.hn, 'pat') && udc
			m.name = pat.namepat && udc
			m.inscl = ins.inscl
			= SEEK(m.inscl, 'pttyp')
			m.typname = pttyp.typname
			INSERT INTO tempipd FROM MEMV
		ELSE
			= SEEK(LEFT(hn,7), 'patient1')
			m.name = patient1.name
			= SEEK(patient1.class, 'social')
			m.inscl = IIF(EMPTY(social.pttyp), patient1.class, social.pttyp)
			= SEEK(m.inscl, 'pttyp')
			m.typname = pttyp.typname
			INSERT INTO tempipd FROM MEMV
			SELE tempipd
			DELE
			SELE ipd
		ENDI
	ENDS
	RELE WIND progress
	SELE tempipd
	REPL ALL los WITH IIF(datedsc - dateadm = 0, 1, datedsc - dateadm) && udc
	TOTAL ON inscl TO temp1
	USE temp1 IN 0
	CLEA
	detailgo  = .T.
	printmonth = month&lcmm
	printyear = LCyyyy
	DO WHILE detailgo
		CLEA
		@ 1,10 PROMPT '1. ดูจำนวนสิทธิแต่ละประเภท'
		@ 2,10 PROMPT '2. ดูรายละเอียดของทุกคน'
		@ 3,10 PROMPT '3. ส่งออกผลการตรวจสอบ' && udc
*		@ 3,10 PROMPT '9. ดูเฉพาะผู้ไม่ได้ใส่สิทธิการรักษา'
		@ 4,10 PROMPT '0. เลิกงาน'
		MENU TO chdetail
		DO CASE
			CASE chdetail = 0 OR chdetail = 9
				detailgo = .F.
			CASE chdetail = 1
				SELE temp1
				REPO FORM right Preview
				CLEA
				nametext = SPACE(30)
				@ 3,1 SAY 'ต้องการเก็บรายงานไว้ในแฟ้มชื่อ  ' GET nametext
				READ
				IF ! EMPTY(nametext)
					textname = ALLTRIM(nametext)
					REPO FORM right TO FILE &textname NOCONSOLE
				ENDI
			CASE chdetail = 2
				totalpage = 0
				SELE tempipd
				REPO FORM eachrigh NOCONSOLE
				totalpage = _pageno
				REPO FORM eachrigh Preview
				CLEA
				nametext = SPACE(30)
				@ 3,1 SAY 'ต้องการเก็บรายงานไว้ในแฟ้มชื่อ  ' GET nametext
				READ
				IF ! EMPTY(nametext)
					textname = ALLTRIM(nametext)
					REPO FORM eachrigh TO FILE &textname NOCONSOLE
				ENDI
* udc
			CASE chdetail = 3
				SELE tempipd
				namedbf = SPACE(30)
				@ 3,1 SAY 'ต้องการส่งออกรายงานไว้ในแฟ้มชื่อ' GET namedbf
				READ
				IF ! EMPTY(namedbf)
					textdbf = ALLTRIM(namedbf)
					COPY TO &textdbf
				ENDI
* udc
		ENDC
	ENDD
ENDI
SELE ins
DELE TAG ALL
SELE pat && udc
DELE TAG ALL && udc
CLOSE DATA
********************
procedure _vEdit
********************
_CUROBJ = _CUROBJ-2

********************
procedure _vCancel
********************
* release WINDOW WRCREATEDB
* return TO MASTER
CLEAR READ
