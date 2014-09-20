************************** proc ADDCAME ******************
***				งานเวชระเบียน (ระบบงาน OPD)
***				โปรแกรม ส่วนที่ 2 สำหรับให้ โปรแกรม came1 เรียกใช้
***				การใช้งาน ให้เรียกจากโปรแกรม came1
****************************              ******************
PRIV goon
#define numdiag  9
iscode = 'NZ'
islow = 'S00'
ishigh = 'T79'
isis = ! EMPTY(isdir)
IF isis
	IF ! FILE(isdir + 'is.dbf')
		isis = .F.
	ELSE
*		SET PATH TO (isdir)
		USE (isdir + 'is') INDEX (isdir +'hn'), (isdir + 'name'), (isdir +'fname'), (isdir +'adate') IN 0
		SELE 0
		USE (isdir + 'hospital')
		m.hosp = code
		m.prov = changwat
		USE
	ENDI
ENDI
ON KEY LABEL ALT+S DO reprints
IF USED('address')
	SELE address
	USE
ENDI
IF USED('occupat')
	SELE occupat
	USE
ENDI
STOR SPACE(2) TO m.clinic,mclinic,nowclinic
ON KEY LABEL F2 DO search_clinic WITH m.clinic,mclinic
_printappoint=.T.
*******      รายการ ที่ 1   บันทึกข้อมูลการตรวจผู้ป่วยนอก  *******
EXTERNAL ARRAY OpdMess,Tmonth
call_text=space(5)
@ 1,1 to 1,80 clear
@ 1,29 say OpdMess(ChMain)
@ 22,0 clea
@ 5,0 to 18,80 clea
   va3=space(3)
   dummyclinic = '   '
   m.clinic='010'
DO search_clinic WITH m.clinic,mclinic        && search    1 0 0
my=SUBS(DTOC(DATE()),4,2)+STR(YEAR(DATE())+543,2)
dummyclinic = m.clinic
do search_month with my           && search    2 0 0
mm = LEFT(my,2)
yy = RIGHT(my,2)
DO CheckCameFile
mdate=CE2BE(DATE())
SELE refer
SCAT MEMV BLANK
SELE camefile
SCAT MEMV BLANK
SELE iptrana
SCAT MEMV BLANK
STOR SPACE(30) TO mdoctor,ptname,referinplace,referoutplace,mappdoctor,mappclinic
STOR SPACE(60) TO mreferdiag,moutdiag
STOR SPACE(25) TO mcon_clinic,mdep,mward
STOR SPACE(60) TO referdiag, outdiag
STOR SPACE(4) TO mt_in,mt_out,outtime
STOR SPAC(5) TO outplace
STOR SPAC(2) TO outcause
m.AdmWt = 0.000 && udc
STORE SPACE(1) TO outtype, m.forensic
FOR i = 1 TO numdiag
	x = LTRIM(STR(i))
	STOR SPAC(1) TO mnew&x, m.dxtype&x
	STORE SPACE(60) TO mmdiag&x, m.mdiag&x
NEXT
m.dxtype1 = '1'
* STOR .T. TO m.emergency
STOR 0 TO ill_d
STOR SPACE(3) TO m.con_clinic
SELE patient1
SET RELA TO hn INTO newcase ADDI
*m.rem_c='2' && udc
m.rem_c=' '
m.result='51'
m.dep = LEFT(m.clinic,2)
end_add=.t.
m.found=.F.						&& Flag เพื่อบอกว่าหาเลขที่ผู้ป่วยพบไหม
mdiag0='adfe'					&& ทำ dummy ไว้สำหรับตรวจสอบ
goobj=1
m.clinic = dummyclinic
		DEFINE WIND win1 FROM 10,2 TO 15,78 SHAD
DO WHIL end_add                 && จุดเริ่มต้นของงานบันทึกข้อมูลผู้ป่วยนอก'
	FLUSH
	m.clinic = dummyclinic
	@4,0 to 20,80 clea
	came_hn=space(7)
	do entry_screen             && เรียกหน้าจอ
	@5,30 get m.hn pict "#######" WHEN Checkobj() VALID CheckHn(m.hn);
		MESS 'ใส่หมายเลขผู้ป่วยนอก ไม่ต้องมี 0 นำหน้า'
	@ 5,40 GET ptname DEFA SPAC(30) DISA COLO ,,,,,,,,,/w
	@6,24 GET m.rem_c PICT '#' VALID CheckRem(m.rem_c) ;
		MESS 'ใส่ 1=มาตามนัด  2=มาเอง   3=รับ Consult  4=รับ REFER'
	@6,60 get mdate PICT '99/99/9999' VALID CameDATE(mdate,mm,yy) ;
		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
	@7,24 get mt_in pict '@R ##:##'  WHEN CheckFirst('addcame') ;
	VALID (CheckTimeIn(mt_in) AND Checkrepeat()) ;
		MESS 'ใส่เวลาที่มาทำบัตรเป็นชั่วโมง นาที'
	@7,60 get mt_out pict '@R ##:##' WHEN CheckFirst() VALID CheckTimeOut(mt_out) ;
		MESS 'ใส่เวลาที่ตรวจเสร็จเป็นชั่วโมง นาที'
	@9,28 get mdiag1 WHEN EntryICD(mdiag0,mdiag1) VALID CheckICD(mdiag1) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 1 ถ้าผ่าตัดให้ใส่เครื่องหมาย * นำหน้า' FUNC 'S20'
	@9,61 get mnew1 pict '9' WHEN CheckFirst() VALID EPISODE(mnew1);
		MESS 'ใส่รหัสว่าเป็น 1 = ผู้ป่วยใหม่ 2 = เก่า หรือ 3 = ติดตามโรค'
	@9,73 get m.dxtype1 DISA COLO ,,,,,,,,,/w
	@10,5 GET mmdiag1 DISA COLO ,,,,,,,,,/w
	@11,28 get mdiag2 WHEN EntryICD(mdiag1,mdiag2) VALID CheckICD(mdiag2) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 2 ถ้าผ่าตัดให้ใส่เครื่องหมาย * นำหน้า ถ้าไม่มีให้ใส่เป็นช่องว่าง' ;
		SIZE 1,20
	@11,61 get mnew2 pict '9' WHEN CheckFirst() VALID EPISODE(mnew2);
		MESS 'ใส่รหัสว่าเป็น 1 = ผู้ป่วยใหม่ 2 = เก่า หรือ 3 = ติดตามโรค'
	@11,73 get m.dxtype2 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype2,mdiag2);
		MESS 'ใส่รหัสว่าเป็น 2 = Comorbidity 3 = Complication หรือ 4 = Other'
	@12,5 GET mmdiag2 DISA COLO ,,,,,,,,,/w
	@13,28 get mdiag3 WHEN EntryICD(mdiag2,mdiag3) VALID CheckICD(mdiag3) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 3 ถ้าผ่าตัดให้ใส่เครื่องหมาย * นำหน้า ถ้าไม่มีให้ใส่เป็นช่องว่าง' ;
		SIZE 1,20
	@13,61 get mnew3 pict '9' WHEN CheckFirst() VALID EPISODE(mnew3);
		MESS 'ใส่รหัสว่าเป็น 1 = ผู้ป่วยใหม่ 2 = เก่า หรือ 3 = ติดตามโรค'
	@13,73 get m.dxtype3 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype3,mdiag3);
		MESS 'ใส่รหัสว่าเป็น 2 = Comorbidity 3 = Complication หรือ 4 = Other'
	@14,5  GET mmdiag3 DISA COLO ,,,,,,,,,/w
	@15,28 get mdiag4 WHEN EntryICD(mdiag3,mdiag4) VALID CheckICD(mdiag4) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 4 ถ้าผ่าตัดให้ใส่เครื่องหมาย * นำหน้า ถ้าไม่มีให้ใส่เป็นช่องว่าง' ;
		SIZE 1,20
	@15,61 get mnew4 pict '9' WHEN CheckFirst() VALID EPISODE(mnew4);
		MESS 'ใส่รหัสว่าเป็น 1 = ผู้ป่วยใหม่ 2 = เก่า หรือ 3 = ติดตามโรค'
	@15,73 get m.dxtype4 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype4,mdiag4);
		MESS 'ใส่รหัสว่าเป็น 2 = Comorbidity 3 = Complication หรือ 4 = Other'
	@16,5 GET mmdiag4 DISA COLO ,,,,,,,,,/w
	@18,21 get ill_d pict '##' ;
		MESS 'ใส่จำนวนวันที่ผู้ป่วยไม่สบาย'
	@18,42 get m.AdmWt pict '999.999' VALID ChkAdmWt() mess 'ใส่น้ำหนักเป็นกิโลกรัม'
	@18,71 get m.doctor WHEN InputDoctor(m.doctor) VALID CheckDoctor(m.doctor,mdoctor) ;
		MESS 'ใส่รหัสแพทย์ที่ทำการรักษาผู้ป่วย'
	@19,21 get m.result PICT '99' VALID CheckResult(m.result) ;
		MESS 'ใส่ผลการรักษาผู้ป่วย'
	@19,47 GET mdoctor DISA COLO ,,,,,,,,,/w
	READ NOLOCK
	pdoctor = m.doctor
	pmdoctor = mdoctor
	IF ! EMPTY(m.hn) && .AND. ! EMPTY(mdiag1)
		IF ! m.found			&& ไม่พบ HN ใน file patient1
			DEFINE WIND win1 FROM 10,2 TO 15,78 SHAD
			ACTI WIND win1
			CLEA
			@ 1,3 SAY 'ผู้ป่วยเพศชายหรือหญิง           ' GET m.sex ;
			DEFA '1' PICT '9' VALID Sex(m.sex)
			@ 2,3 SAY 'ผู้ป่วยอยู่ในหรือนอกเขตจังหวัด  ' GET ;
			m.province DEFA '1' PICT '9' VALID InProvince(m.province)
			@ 3,3 SAY 'อายุผู้ป่วย                     ' GET m.ptage ;
			DEFA '   ' PICT '999' VALID AGE(m.ptage)
			READ NOLOCK
		ENDI
		IF LEFT(m.clinic,2) $ '13,14'
			DO AskEmer
		ELSE
			m.dep = LEFT(m.clinic,2)
		ENDI
		ACTI SCREE
		ask='Y'
		goobj=1
		ON KEY LABEL Alt+E DO AskEmer
		do confirm with ask,20,25
		ON KEY LABEL Alt+E
		DEAC WIND win1
		IF LASTKEY()#27
			IF ask $'yYัํ'
				DO CASE
					CASE EMPTY(m.rem_c)
						goobj=3
					CASE EMPTY(mt_in)
						goobj=5
					CASE EMPTY(mt_out)
						goobj=6
					CASE EMPTY(m.result)
						goobj=21
					OTHER
						m.fromclinic = m.clinic
						do append_data          && เก็บข้อมูลเข้าแฟ้ม search 3 0 0

						IF StatInput
							SELE medrec
							IF SEEK(m.hn)
								DO WHIL hn = m.hn
									SCAT MEMV
									phn = m.hn
									m.status = .T.
									INSERT INTO filecame FROM MEMV
									FLUSH
									SCAT MEMV BLANK
									prec = RECNO()
									SKIP
									prec = IIF( ! EOF(), RECNO(), prec )
									SKIP -1
									GATH MEMV
									FLUSH
									GO prec
									m.hn = phn
								ENDD
								REPL patient1.clinic WITH 'ZZZ'
								FLUSH
							ENDI
						ENDI
						IF BETWEEN(m.result,'01','12') .AND. ;
						(LEFT(m.clinic,2) = '13' .OR. canadmit)
							IF USED('shorticd')
								SELE shorticd
								USE
							ENDI
							IF ! USED('address')
								dbfuse = codedir + 'ADDRESS'
								USE (codedir+'address') ORDER 1 IN 0
							ENDI
							dbfuse = codedir + 'OCCUPAT'
							USE (codedir+'occupat') ORDER 1 IN 0
							dbfuse = ''
							DO askadmit
							SELE address
							USE
							SELE occupat
							USE
						ENDI
						DO AskAppoint  			&& สอบถามว่ามีการนัดหมายหรือไม่
						DEFINE WIND OPDChrg1 FROM 10,10 TO 14,70 SHAD
						ACTI WIND OPDChrg1
						goon1='N'
						CLEA
						@ 1,3 SAY 'ต้องการป้อนข้อมูลค่าใช้จ่ายหรือไม่  ' GET goon1 PICT '!'
						READ
						RELE WIND
						IF goon1='Y'
							DO OPDCHRG
						ENDI
						DO InitVariable		&& กำหนดค่าตัวแปรเริ่มต้นใหม่
				ENDC
			ENDI
		ELSE
			DO InitVariable		&& กำหนดค่าตัวแปรเริ่มต้นใหม่
		ENDI
	ELSE
		end_add=.F.
	ENDI
ENDD                             && เสร็จ งานบันทึกการตรวจผู้ป่วยนอก
ON KEY LABEL F2
SELE camefile
USE
SELE nowappoint
USE
SELE refer
USE
SELE newcase
USE
SELE filecame
USE
*USE (codedir+'address') ORDER 1 IN 0
dbfuse = codedir + 'OCCUPAT'
USE (codedir+'occupat') ORDER 1 IN 0
dbfuse = ''
SET DELI TO DEFA
ON KEY LABEL ALT+S

PROC INITVARIABLE
SELE refer
SCAT MEMV BLANK
SELE camefile
SCAT MEMV BLANK
m.doctor = pdoctor
mdoctor = pmdoctor
STOR SPACE(30) TO ptname,referinplace,referoutplace
STOR SPACE(60) TO mmdiag1,mmdiag2,mmdiag3,mmdiag4,mreferdiag,moutdiag
STOR SPACE(25) TO mcon_clinic
STOR SPACE(60) TO mdiag1,mdiag2,mdiag3,mdiag4,referdiag,outdiag
STOR SPACE(4) TO mt_in,mt_out,outtime
STOR SPAC(5) TO outplace
STOR SPAC(2) TO outcause
STOR SPACE(1) TO outtype, m.forensic
m.AdmWt = 0.000 && udc
FOR i = 1 TO numdiag
	x = LTRIM(STR(i))
	STOR SPAC(1) TO mnew&x, m.dxtype&x
	STORE SPACE(60) TO mmdiag&x, m.mdiag&x
NEXT
m.dxtype1 = '1'
STOR 0 TO ill_d
STOR SPACE(3) TO m.con_clinic
*m.rem_c='2' & udc
m.rem_c=' '
m.result='51'

********************** 3 0 0  proc append-data  (came file)  **********
PROC APPEND_DATA
IF isis
	SELE is
	m.isname = TRIM(patient1.name)
	m.comma = AT(',',isname)
	m.prename = IIF(comma > 0, SUBS(isname,comma + 1), '')
	m.isname = IIF(m.comma > 0, LEFT(isname, m.comma-1), m.isname)
	m.name = LEFT(isname, IIF(AT(' ',isname) > 1, AT(' ',isname) -1,1))
	m.fname = IIF(AT(' ',isname) > 0, SUBS(isname, AT(' ',isname)+1), '')
	m.home = IIF(contact.changwat = m.hosp_province, '1', '2')
	m.birth = patient1.birthday
	m.dayage = DATE() - m.birth
	m.age = INT(m.dayage/365)
	m.month = INT(MOD(m.dayage,365)/30)
	m.refer = IIF(m.rem_c = '4', '1', '0')
*	m.home = IIF(contact.changwat = m.hosp_province, '1', '2')
	m.hdate = BE2CE(mdate)
	m.htime = LEFT(mt_in,2)+'.'+RIGHT(mt_in,2)
ENDI
m.t_in=MINUTEIN(mt_in)
m.t_out=MINUTEOUT(mt_out)
m.date=BE2CE(mdate)
m.clinic = nowclinic
referplace=m.clinic
IF m.found
	m.age_type=' '
	m.age=0
	=FindAge(m.age_type,m.age,patient1->birthday)
	m.sex=patient1->sex
	m.province=IIF(contact->changwat=hosp_province,'1','0')
ELSE
	m.age_type=LEFT(m.ptage,1)
	m.age=VAL(RIGHT(m.ptage,2))
ENDI
IF EMPTY(newcase->hn)
	m.visited = .T.
	INSERT INTO newcase FROM MEMVAR
	FLUSH
	m.new=.T.
ELSE
	m.new=IIF(newcase.visited,.F.,.T.)
	REPL newcase.visited WITH .T.
ENDI
SELE camefile
m.ill_date=BE2CE(mdate)-ill_d
m.fc=patient1.class
isnum = 0
FOR nm=1 TO numdiag
	SELE camefile
	_nm=LTRIM(STR(nm))
	IF mdiag&_nm='    ' .AND. nm>1
		EXIT
	ENDI
	m.diag=Con_ICD(mdiag&_nm)
	m.diag=IIF(ISDIGIT(m.diag),'*'+LEFT(m.diag,4),m.diag)
	m.sequence=nm
	m.episode=mnew&_nm
	m.dxtype = m.dxtype&_nm
	GO TOP
	IF ! EMPTY(hn) .OR. BOF()
		APPE BLANK
	ENDI
	GATHER MEMV
	IF isis .AND. (m.diag $ iscode .OR. BETWEEN(m.diag,islow,ishigh))
		isnum = isnum + 1
		isx = STR(isnum,1)
		m.diag&isx = m.diag
		SELE is
		IF isnum = 1
			APPE BLANK
			GATH MEMV
			REPL hn WITH '0' + LEFT(m.hn,7) + '-' + RIGHT(m.hn,2)
		ELSE
			IF isnum <=6
				REPL diag&isx WITH m.diag
			ENDI
		ENDI
	ENDI
	FLUSH

NEXT               && end loop append diag or operation record
sele appoint
IF SEEK(m.hn+m.clinic)
	SCAT MEMV MEMO
	INSERT INTO nowappoint FROM MEMV
	FLUSH
	REPL hn WITH SPACE(7),appoint with .t.,lab WITH '',date WITH CTOD('  /  /  ')
	FLUSH
ENDI
mday=DTOC(m.date)
m.day=SUBS(mday,4,2)+LEFT(mday,2)
IF m.rem_c='4'
	SELE refer
	m.diag=Con_ICD(mdiag1)
	m.diag=IIF(ISDIGIT(m.diag),' '+LEFT(m.diag,4),m.diag)
	m.type= '1'       &&IIF(m.rem_c='3','1','3')
	APPE BLANK
	GATHE MEMV
	FLUSH
ENDI
IF m.result = '54'
	SELE refer
	m.diag=Con_ICD(mdiag1)
	m.diag=IIF(ISDIGIT(m.diag),' '+LEFT(m.diag,4),m.diag)
	m.type='2'  && IIF(m.result='03','2','4')
	m.place=outplace
	m.cause=outcause
	m.time = outtime
	LOCA FOR EMPTY(hn)
	IF EOF()
		APPE BLANK
	ENDI
	GATHE MEMV
	FLUSH
ENDI
IF m.result = '53'
	SELE medrec
	SEEK m.hn
	DO WHIL hn = m.hn .AND. status
		SKIP
	ENDD
	IF hn = m.hn
		REPL who WITH m.con_clinic
		FLUSH
	ENDI
ENDI

PROC AskAppoint
***------   สอบถาม การนัดหมาย --------------
IF m.result='51'
	SELE appoint
 	_mdoctor=m.doctor
	scat memv blank MEMO
	mmtime=space(4)
	mdateappo=SPACE(10)
	m.doctor=_mdoctor
	m.clinic=nowclinic
	m.fromclinic = nowclinic
   DO APPOINTMENT WITH .T.
ENDI

*: EOF: FORM.PRG

PROC CheckCameFile
yymm=RIGHT(my,2)+LEFT(my,2)
CHECK_FILE=(opddir+'came'+yymm+'.dbf')
dbfuse =opddir+'came'+yymm+'.dbf'
SELE 0
IF USED('camefile')
	SELE camefile
ENDI
IF ! FILE(check_file)
	CREATE TABLE (opddir+ 'came'+yymm) ;
	(HN C(7),DATE D,CLINIC C(3),T_IN N(4),T_OUT N(4),DOCTOR C(6),DIAG C(7),;
	REM_C C(1),EPISODE C(1),RESULT C(2),AGE_TYPE C(1),AGE N(2),FC C(2),;
	SEQUENCE N(1),ILL_DATE D,PROVINCE C(1),SEX C(1),NEW L,DEP C(2),;
	EMERGENCY L,FORENSIC C(1), DXTYPE C(1),ADMWT N(7,3))
	index on hn+STR(DAY(date),2)+clinic+STR(t_in,4)+STR(sequence,1) tag hdate
ENDI
use (opddir+'came'+yymm) ORDER 1 ALIA camefile
newcamefile = .F.
FOR i = 1 TO FCOUNT()
	IF UPPE(FIELD(i)) = 'DXTYPE'
		newcamefile = .T.
	ENDI
NEXT
IF ! newcamefile
	_asksure = 'แฟ้มผู้ป่วยนอกเป็นแบบเก่า ต้องแก้ไข ให้หยุดเครื่องอื่นก่อน'
	nAsksure = 1
	DO asksure.spr
	IF nAsksure = 1
		COPY TO temp STRU EXTE
		USE temp
		APPE BLANK
		REPL FIELD_NAME WITH 'DXTYPE', field_type WITH 'C', ;
		field_len WITH 1
		USE
		CREAT (opddir + 'temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = opddir + 'temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO Reindex WITH .F.
	ELSE
		RETU TO opd
	ENDI
ENDI
SELE 0
dbfuse = opddir+'appoin'+yy+'.dbf'
IF ! FILE(opddir+'appoin'+yy+'.dbf')
	dbfuse = opddir+'appoin'+yy
	CREATE TABLE (opddir+'appoin'+yy) ;
      (HN C(7),CLINIC C(3),DATE D,TIME C(4),DOCTOR C(6))
	INDEX ON hn+clinic TAG hnclinic
ENDI
USE (opddir+'appoin'+yy) ORDER 1 ALIA nowappoint
SELE 0
dbfuse = opddir+'refer'+yy
IF ! FILE(opddir+'refer'+yy+'.dbf')
	CREATE TABLE (opddir+'refer'+yy) ;
	(HN C(7),DAY C(4),TIME C(4),PLACE C(5),DIAG C(7),CAUSE C(2),;
	CLINIC C(4),TYPE C(1))
ENDI
use (opddir+'refer'+yy) ALIA refer
SELE 0
mfile=patientdir+'new'+yy
dbfuse = mfile
IF ! FILE(mfile+'.dbf')
	CREATE TABLE (mfile) (HN C(7))
	INDEX ON hn TAG hn
ENDI
USE (mfile) ORDER TAG hn ALIA newcase
dbfuse = ''
IF FCOUNT() = 1
	DO WarnNew WITH mfile
ENDI
SELE 0
target=patientdir+'FILE'+yy+'.DBF'
dbfuse = target
	if !file(target)
		create table (target) (HN C(7), DATE D, TIME C(4), WHO C(6), STATUS L)
	endif
 USE (target) alias  FILECAME
dbfuse = ipddir+'data\iptrana'
IF ! USED('iptrana')
	USE (ipddir+'data\iptrana') ORDER 1 IN 0
ENDI
dbfuse = ''

PROC REPRINTS
PRIV useaddress,useoccupat
STOR .F. TO useaddress,useoccupat
IF USED('shorticd')
	SELE shorticd
	USE
ENDI
IF ! USED('address')
	dbfuse = codedir+'address'
	USE (codedir+'address') ORDER 1 IN 0
	useaddress = .T.
ENDI
IF ! USED('occupat')
	dbfuse = codedir+'occupat'
	USE (codedir+'occupat') ORDER 1 IN 0
	useoccupat = .T.
ENDI
dbfuse = ''
DO prsumary
IF useaddress
	SELE address
	USE
ENDI
IF useoccupat
	SELE occupat
	USE
ENDI

FUNC CheckRepeat
mseek = m.hn + STR(DAY(BE2CE(mdate)),2) + m.clinic + STR(MINUTEIN(mt_in),4)
IF SEEK(mseek,'camefile')
	?? CHR(7)
	WAIT WIND NOWA '  ผู้ป่วยคนนี้ได้ลงข้อมูลแล้ว  '
	_CUROBJ = _CUROBJ
ENDI

***------------------------  ค่ารักษาผู้ป่วยนอก --------------------
PROC OPDCHRG
PARA _new
define window opdchrg from 3,0 to 22,79 shadow
activate window opdchrg
@3,0 TO 22,80 clea
do opdchrg_screen           && search parag 7000
do entry_opdchrg            && search parag 8000
rele window opdchrg
***---------------------   7000   ----------------
proc opdchrg_screen
text
    				ค่ารักษาพยาบาลผู้ป่วยนอก
  HN :            ค่ารักษาของ                                        สิทธิ์
  รายละเอียด                          จ่าย        ฟรี
      ค่ายา
      ค่าบริการทางการแพทย์
      ค่าบริการทันตกรรม
      ค่าบริการทางห้องปฏิบัติการ
      ค่า X-Ray
      ค่าวัสดุการแพทย์
      ค่าห้อง
      ค่าบำรุง
      ใบรับรองแพทย์
      บริจาค
      อื่น ๆ
      รวม
      จ่ายจริง                             สปร.

endtext
***------------------------   8000  บันทึกค่ารักษา ---------------
PROC ENTRY_opdchrg
fromin = PROGRAM(3) = 'IN_opdchrg'
firstenter = _new 	&& ให้รู้ว่าเป็นการเพิ่งเข้ามาลงข้อมูล
stor 0 to m01,m02,m03,m04,m05,m06,m07,m08,m09,m010,m011,m.sum,m.paid
stor 0 to s01,s02,s03,s04,s05,s06,s07,s08,s09,s010,s011,m.ssum,m.spaid
cItem1 = "01"
cItem2 = "02"
cItem3 = "03"
cItem4 = "04"
cItem5 = "05"
cItem6 = "06"
cItem7 = "07"
cItem8 = "08"
cItem9 = "09"
cItem10 = "10"
cItem11 = "11"
m.hn = hn
sele patient1
seek(hn)
mclass = class
@ 2,8 say m.hn colo /w
@ 2,31 SAY ptname colo /w
@ 2,75 say mclass colo /w
@ 4,3 say cItem1 colo /w
@ 4,36 GET m01 PICT '@R #######' COLO ,,,,,,,,,/w
@ 4,50 GET s01 PICT '@R #######' COLO ,,,,,,,,,/w
@ 5,3 say cItem2 colo /w
@ 5,36 GET m02 PICT '@R #######' COLO ,,,,,,,,,/w
@ 5,50 GET s02 PICT '@R #######' COLO ,,,,,,,,,/w
@ 6,3 say cItem3 colo /w
@ 6,36 GET m03 PICT '@R #######' COLO ,,,,,,,,,/w
@ 6,50 GET s03 PICT '@R #######' COLO ,,,,,,,,,/w
@ 7,3 say cItem4 colo /w
@ 7,36 GET m04 PICT '@R #######' COLO ,,,,,,,,,/w
@ 7,50 GET s04 PICT '@R #######' COLO ,,,,,,,,,/w
@ 8,3 say cItem5 colo /w
@ 8,36 GET m05 PICT '@R #######' COLO ,,,,,,,,,/w
@ 8,50 GET s05 PICT '@R #######' COLO ,,,,,,,,,/w
@ 9,3 say cItem6 colo /w
@ 9,36 GET m06 PICT '@R #######' COLO ,,,,,,,,,/w
@ 9,50 GET s06 PICT '@R #######' COLO ,,,,,,,,,/w
@ 10,3 say cItem7 colo /w
@ 10,36 GET m07 PICT '@R #######' COLO ,,,,,,,,,/w
@ 10,50 GET s07 PICT '@R #######' COLO ,,,,,,,,,/w
@ 11,3 say cItem8 colo /w
@ 11,36 GET m08 PICT '@R #######' COLO ,,,,,,,,,/w
@ 11,50 GET s08 PICT '@R #######' COLO ,,,,,,,,,/w
@ 12,3 say cItem9 colo /w
@ 12,36 GET m09 PICT '@R #######' COLO ,,,,,,,,,/w
@ 12,50 GET s09 PICT '@R #######' COLO ,,,,,,,,,/w
@ 13,3 say cItem10 colo /w
@ 13,36 GET m010 PICT '@R #######' COLO ,,,,,,,,,/w
@ 13,50 GET s010 PICT '@R #######' COLO ,,,,,,,,,/w
@ 14,3 say cItem11 colo /w
@ 14,36 GET m011 PICT '@R #######' COLO ,,,,,,,,,/w
@ 14,50 GET s011 PICT '@R #######' COLO ,,,,,,,,,/w
read nolock

m.sum = m01+m02+m03+m04+m05+m06+m07+m08+m09+m010+m011
m.ssum = s01+s02+s03+s04+s05+s06+s07+s08+s09+s010+s011
@ 15,36 SAY m.sum COLO /w
@ 15,50 SAY m.ssum COLO /w
@ 16,25 GET m.paid COLO /w
read nolock
m.free = m.sum-m.paid
@ 16,50 say m.free COLO /w
@ 17,20 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET m.correct WHEN Clearkey() DEFA 'Y' ;
PICT '!' VALID CheckCorrect(m.correct)
READ NOLOCK
=ClearKey()
********************************** ถ้ามีข้อมูลค่ารักษาบันทึกใน rcpd,dtpd,creditpd
********** เปิดแฟ้ม
IF USED('RCOPD')
	SELE RCOPD
	use
ENDI
	sele 0
	target=billdir+'opd\rcopd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (RC_NO C(10), HN C(9), DATE D, TOTAL N(7);
		,PAID N(7) )
			index on hn tag hn addi
			index on RC_NO tag RC_NO addi
	endif
	use (target) alias RCOPD
	dbfuse = ''
	set order to tag rc_no
IF USED('DTOPD')
	SELE DTOPD
	use
ENDI
	sele 0
	target=billdir+'opd\dtopd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (RC_NO C(10), SV_ID C(2), AMT N(7),FREE N(7), HN C(9) )
			index on HN tag HN
			index on rc_no tag rc_no addi
	endif
	use (target) alias DTOPD
	dbfuse = ''
	set order to tag rc_no
IF USED('CREDOPD')
	SELE CREDOPD
	use
ENDI
	sele 0
	target=billdir+'opd\credopd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (CR_ID C(2), RC_NO C(10), HN C(9) )
			index on HN tag HN addi
			index on rc_no tag rc_no addi
	endif
	use (target) alias CREDOPD
	dbfuse = ''
	set order to tag rc_no
*************
m.cr_id =mclass
sele RcoPd
go bott
mRc_no = Rc_no
m.Rc_no = str(val(mRc_no)+1)
m.date = BE2CE(mdate)
m.total = m.sum
m.paid = m.paid
	DO WHIL !empty(hn) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
	GATH MEMV
	FLUSH
	UNLOCK ALL

sele credopd
	DO WHIL !empty(hn) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
	GATH MEMV
	FLUSH
	UNLOCK ALL


sele dtopd
goon = .T.
n=1
DO WHIL n <= 11
	msv_id = 'cItem'+alltrim(str(n))
	mget = 'm0'+alltrim(str(n))
	sget = 's0'+alltrim(str(n))
	m.sv_id = &msv_id
	m.amt = &mget
	m.free = &sget
		go top
		if m.amt = 0
			*skip
			n = n+1
		else
		DO WHIL !empty(hn) .or.  BOF() .OR. ! RLOCK()
			appe blank
		endD
		gather memvar
		FLUSH
		UNLOCK ALL
	n = n+1
endif
ENDD

***********************************
	Function ChkAdmWt
***********************************
	dAdmit = BE2CE(mdate)
	dBirth = Lookup(Patient1.BirthDay,alltrim(m.HN),Patient1.HN,"HN")
	IF ! Empty(dBirth) and ! Empty(dAdmit) and ;
		dBirth > gomonth(dAdmit,-12) and Empty(m.AdmWt)
		?? Chr(7)
		WAIT WIND " ผู้ป่วยอายุต่ำกว่า 1 ปี ต้องบันทึกน้ำหนักด้วย " NOWAIT
		_Curobj = ObjNum(m.AdmWt)
		Return
	ELSE
		IF m.AdmWt > 500
			?? Chr(7)
			WAIT WIND " ใครจะน้ำหนักมากขนาดนั้น !!!  ลองตรวจสอบอีกครั้ง " NOWAIT
			_Curobj = ObjNum(m.AdmWt)
			Return
		ENDI
	ENDI