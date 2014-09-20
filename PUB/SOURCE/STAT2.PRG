PARA _startprog
currentdirectory = SYS(5) + SYS(2003)
notremovethai = .F.
havepara = .F.
STORE .F. TO healthin    && Not a program of HEALTH INSURANCE
IF PARAMETERS() > 0
	notremovethai = UPPE(_startprog) = 'T'
	havepara = .T.
ENDI
statversion = '2.95 TM'
*RELE ALL
SET PROC TO Utility
SET LIBR TO foxfix ADDI
_toprog = IIF(PARAMETER()=0,'  ',_startprog)
DO StartSet
ba = CHR(201) + CHR(205) + CHR(187) + CHR(186) + CHR(188) + CHR(205) + CHR(200) + CHR(186)
bb = CHR(204) + CHR(205) + CHR(185) + CHR(186) + CHR(188) + CHR(205) + CHR(200) + CHR(186)
PRIV goon
SET RESOURCE OFF
#DEFINE UpArrow 5
#DEFINE LeftArrow 19
PUBLIC Atrscreen,Atrbackgr,Atrdata,Atrmenu,Atrmenu2
STORE '\pub\' TO patientdir,codedir
STORE '' TO tempdir,workstation,backup,admit,thaicard,person_id,;
prescription,notprintrx,wellbaby,notque,backupdrive,dbfuse,;
notstatadmit, isdir
STORE '\ipd\' TO ipddir
STORE '\opd\' TO opddir
STORE '\pharm\' TO pharmdir
STORE '\billing\' TO billdir
STORE .F. TO printpx, nottoque
*youngright	=	'71,81'
*poorright	=	'72,82'
*studentright =	'73,83'
*disableright =  '74,84'
*warright	=	'75,85'
*monkright	=	'76,86'
*oldright	=	'77,87'
*tempright	=	'78,88'
*ucright 	=	'89'
*fwfright	=	''
*leaderright =	''
*hcvright	=	''
** udc ***
youngright	=	'62,63,64'
poorright	=	'51'
studentright =	'34,35,36,37,38'
disableright = 	'66'
warright	=	'41,42,43,44,45'
monkright	=	'65'
oldright	=	'61'
tempright	=	''
ssoright	=	'71,72,73'
ucright 	=	'30,3C'
fwfright	=	'99'
leaderright =	'32'
hcvright	=	'33'
*** udc ***

*ON error DO err WITH ERROR(),MESSAGE(),LINENO(),PROGRAM(),PROGRAM(2),PROGRAM(3),;
*PROGRAM(4),PROGRAM(5),PROGRAM(6),PROGRAM(7),PROGRAM(8),PROGRAM(9)
DIME ProvArr(60)
goon = .T.
DIME test(4)
=ADIR(test,SYS(16))
programdate=CE2CBE(test[3])
fromhelp = .F.
backup = UPPE(GETENV('BACKUP'))
workstation = UPPE(GETENV('workstation'))
er = workstation = 'ER'
statinput = workstation = 'STAT'
notkeyword = 'NO'
DO GetConfig
audit = backup = 'AUDIT'
printpx = prescription = 'YES'
nottoque = UPPE(notque) = 'YES'
F_STATION=workstation='FILE'
*ER=workstation='ER'
drive = LEFT(patientdir,AT('\',patientdir))
IF ADIR(directory,drive+'credit','D') = 0
	makedir = drive+billdir
	! md &makedir
	makedir = drive+billdir +'data'
	! md &makedir
	makedir = drive+billdir + 'report'
	! md &makedir
ENDI
IF ADIR(directory,patientdir,'D') = 0
	makedir = LEFT(patientdir,LEN(patientdir)-1)
	! md &makedir
	makedir = LEFT(opddir,LEN(opddir)-1)
	! md &makedir
	makedir = makedir + '\report'
	! md &makedir
	makedir = LEFT(ipddir,LEN(ipddir)-1)
	! md &makedir
	makedir = makedir + '\report'
	! md &makedir
	makedir = makedir + '\data'
	! md &makedir
	makedir = makedir + '\lib'
	! md &makedir
ENDI

**billing
IF ADIR(directory,billdir,'D') = 0
	makedir = LEFT(billdir,LEN(billdir)-1)
	! md &makedir
ENDI
IF ADIR(directory,billdir+'All','D') = 0
	makedir = billdir +'ALL'
	! md &makedir
ENDI
IF ADIR(directory,billdir+'OPD','D') = 0
	makedir = billdir + 'OPD'
	! md &makedir
ENDI
IF ! FILE(billdir+'opd\chrgitem.dbf')
	SELE 0
	dbfuse = billdir+'opd\chrgitem'
	CREA TABLE (billdir+'opd\chrgitem') ;
	(CHRGITEM C(2),CHR_NAME C(25))
	APPE BLANK
	REPL CHRGITEM WITH '00',CHR_name WITH 'ค่ายา'
	APPE BLANK
	REPL CHRGITEM WITH '01',CHR_name WITH 'ค่าบริการทางการแพทย์'
	APPE BLANK
	REPL CHRGITEM WITH '02',CHR_name WITH 'ค่าบริการทางทันตกรรม'
	APPE BLANK
	REPL CHRGITEM WITH '03',CHR_name WITH 'ค่าตรวจทางห้องปฏิบัติการ'
	APPE BLANK
	REPL CHRGITEM WITH '04',CHR_name WITH 'ค่า X-Ray'
	APPE BLANK
	REPL CHRGITEM WITH '05',CHR_name WITH 'ค่าวัสดุการแพทย์'
	APPE BLANK
	REPL CHRGITEM WITH '06',CHR_name WITH 'ค่าห้อง'
	APPE BLANK
	REPL CHRGITEM WITH '07',CHR_name WITH 'ค่าบำรุง'
	APPE BLANK
	REPL CHRGITEM WITH '08',CHR_name WITH 'ใบรับรองแพทย์'
	APPE BLANK
	REPL CHRGITEM WITH '09',CHR_name WITH 'บริจาค'
	APPE BLANK
	REPL CHRGITEM WITH '10',CHR_name WITH 'อื่น ๆ'
	dbfuse = ''
	USE
ENDI
IF ! FILE(billdir+'all\chrgitem.dbf')
	SELE 0
	dbfuse = billdir+'all\chrgitem'
	CREA TABLE (billdir+'all\chrgitem') ;
	(CHRGITEM C(2),CHR_NAME C(25))
	APPE BLANK
	REPL CHRGITEM WITH '00',CHR_name WITH 'ชันสูตรห้องปฏิบัติการ'
	APPE BLANK
	REPL CHRGITEM WITH '01',CHR_name WITH 'X-Ray'
	APPE BLANK
	REPL CHRGITEM WITH '02',CHR_name WITH 'ตรวจชันสูตรอื่น ๆ'
	APPE BLANK
	REPL CHRGITEM WITH '03',CHR_name WITH 'ผ่าตัด'
	APPE BLANK
	REPL CHRGITEM WITH '04',CHR_name WITH 'การรักษาอื่น ๆ'
	APPE BLANK
	REPL CHRGITEM WITH '05',CHR_name WITH 'ยาและเวชภัณฑ์'
	APPE BLANK
	REPL CHRGITEM WITH '06',CHR_name WITH 'ICU'
	APPE BLANK
	REPL CHRGITEM WITH '07',CHR_name WITH 'ค่าห้อง'
	APPE BLANK
	REPL CHRGITEM WITH '08',CHR_name WITH 'ค่าอาหาร'
	APPE BLANK
	REPL CHRGITEM WITH '09',CHR_name WITH 'อื่น ๆ'
	dbfuse = ''
USE
ENDI
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
			index on hn tag hn
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
			index on HN tag HN
			index on rc_no tag rc_no addi
	endif
	use (target) alias CREDOPD
	dbfuse = ''
	set order to tag rc_no
IF USED('RCPD')
	SELE RCPD
	use
ENDI
	sele 0
	target=billdir+'all\rcpd'+'.dbf'
	dbfuse = target
	IF !FILE(target)
		create dbf (target) (RC_NO C(10), HN C(9), DATE D, TOTAL N(7);
		,PAID N(7) , AN C(9) )
			index on AN tag AN
			INDEX ON RC_NO TAG RC_NO ADDI
	ENDI
	use (target) alias RCPD
	dbfuse = ''
	set order to tag AN
IF USED('DTPD')
	SELE DTPD
	use
ENDI
	sele 0
	target=billdir+'all\dtpd'+'.dbf'
	dbfuse = target
	IF !file(target)
		create dbf (target) (RC_NO C(10), SV_ID C(2), AMT N(7), AN C(9) )
			index on AN tag AN
			INDEX ON RC_NO TAG RC_NO ADDI
	ENDI
	use (target) alias DTPD
	dbfuse = ''
	set order to tag AN
IF USED('CREDITPD')
	SELE CREDITPD
	use
ENDI
	sele 0
	target=billdir+'all\creditpd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (CR_ID C(2), RC_NO C(10), AN C(9) )
			index on An tag An
			index on Rc_no tag Rc_no ADDI
	endif
	use (target) alias CREDITPD
	dbfuse = ''
	set order to tag Rc_no

***

IF ! FILE(patientdir+'user.dbf')
	SELE 0
	dbfuse = patientdir+'user'
	CREA TABLE (patientdir+'user') ;
	(NAME C(12),PSW C(10),RIGHT C(10))
	INDEX ON name TAG name
	dbfuse = ''
	USE
ENDI

IF ! FILE(patientdir + "opdlan.mem")
	DO makedbf WITH patientdir+'patient1'  && ตรวจสอบว่ามีแฟ้มที่จำเป็นครบหรือไม่ ถ้าขาดให้สร้างเพิ่ม
	PUSH KEY CLEA
	ON KEY LABEL F1 DO HELP WITH SYS(18),SYS(16)
	USE (codedir+'hospcode') ORDER 1 IN 0
	DO OpdLan  			&& สอบถามข้อมูลพื้นฐานของโรงพยาบาล
	POP KEY
	DO CLearScreen
*	DO OpenLanMaster
	SELE 0
	dbfuse = patientdir+'hncount'
	USE (patientdir+'hncount')
	m.lasthn = lasthn +1
	SELE 0
	dbfuse = ipddir+'ancount'
	USE (ipddir+'ancount')
	dbfuse = ''
	SCAT MEMV
	m.year = IIF( EMPTY(m.year), RIGHT(CE2BE(DATE()),2), m.year)
	m.lastan = m.lastan+1
	@ 10,20 SAY 'ต้องการเริ่มต้นที่หมายเลข HN ' GET m.lasthn PICT '9999999'
	@ 12,20 SAY 'ต้องการเริ่มต้นที่หมายเลข AN '
	_col = COL() + 1
	@ 12,_col GET m.lastan PICT '99999'
	@ 12,_col+5 SAY '-'
	@ 12,_col+6 GET m.year PICT '99'
	READ NOLOCK
	m.lasthn =IIF(m.lasthn>0, m.lasthn-1,m.lasthn)
	m.lastan = IIF(m.lastan>0, m.lastan-1, m.lastan)
	GATH MEMV
	FLUSH
	SELE hncount
	GATH MEMV
	FLUSH
	CLOSE DATA
ENDI
REST FROM (patientdir+'opdlan') ADDI
getperson_id = .T.
dbfuse = codedir + 'social'
USE (dbfuse) IN 0 ORDER 1
SELE social
IF ! SEEK('71')
	m.class = '71'
	m.name = 'เด็กอายุต่ำกว่า 12 ปี ในเขต'
	INSERT INTO social FROM MEMV
	m.class = '81'
	m.name = 'เด็กอายุต่ำกว่า 12 ปี นอกเขต'
	INSERT INTO social FROM MEMV
	m.class = '72'
	m.name = 'ผู้มีรายได้น้อย ในเขต       '
	INSERT INTO social FROM MEMV
	m.class = '82'
	m.name = 'ผู้มีรายได้น้อย นอกเขต      '
	INSERT INTO social FROM MEMV
	m.class = '73'
	m.name = 'นักเรียน ในเขต              '
	INSERT INTO social FROM MEMV
	m.class = '83'
	m.name = 'นักเรียน นอกเขต             '
	INSERT INTO social FROM MEMV
	m.class = '74'
	m.name = 'ผู้พิการ ในเขต              '
	INSERT INTO social FROM MEMV
	m.class = '84'
	m.name = 'ผู้พิการ นอกเขต             '
	INSERT INTO social FROM MEMV
	m.class = '75'
	m.name = 'ทหารผ่านศึก ในเขต           '
	INSERT INTO social FROM MEMV
	m.class = '85'
	m.name = 'ทหารผ่านศึก นอกเขต          '
	INSERT INTO social FROM MEMV
	m.class = '76'
	m.name = 'ภิกษุ/ผู้นำศาสนา ในเขต      '
	INSERT INTO social FROM MEMV
	m.class = '86'
	m.name = 'ภิกษุ/ผู้นำศาสนา นอกเขต     '
	INSERT INTO social FROM MEMV
	m.class = '77'
	m.name = 'ผู้สูงอายุ ในเขต            '
	INSERT INTO social FROM MEMV
	m.class = '87'
	m.name = 'ผู้สูงอายุ นอกเขต           '
	INSERT INTO social FROM MEMV
	m.class = '78'
	m.name = 'บัตรชั่วคราว ในเขต          '
	INSERT INTO social FROM MEMV
	m.class = '88'
	m.name = 'บัตรชั่วคราว นอกเขต         '
	INSERT INTO social FROM MEMV
	m.class = '89'
	m.name = 'บัตรสุขภาพดีถ้วนหน้า(30บาท)  '
	INSERT INTO social FROM MEMV
ENDI
SET MESSAGE TO 24
SET TEXT ON
mhosp_name=LTRIM(TRIM(hosp_name))
dbfuse = patientdir + 'referin.dbf'
SELE 0
IF ! FILE(dbfuse)
	CREATE TABLE (dbfuse) ;
	(HN C(7), ref_no C(7), place C(5), referdate D, refertime C(4), ;
	toclinic C(3), cause C(2) )
	INDEX ON hn TAG hn
	INDEX ON DTOS(referdate) TAG referdate ADDI
ENDI
dbfuse = patientdir + 'referno.dbf'
IF ! FILE(dbfuse)
	CREATE TABLE (dbfuse) ;
	( lastrefer N(5), year C(2) )
	APPE BLANK
ENDI
USE
dbfuse = patientdir + 'patient1'
USE (dbfuse) IN 0
SELE patient1
IF FCOUNT() < 12
	= ALARM1()
	WAIT WIND 'จำนวน Field ในแฟ้ม Patient1 ไม่ถูกต้อง' + CHR(13) + ;
	'จะต้องมีทั้งหมด 12 Field และ Field ที่ 12 จะต้องเป็น' + CHR(13) + ;
	'Person_id เป็น Character 13 หลัก' + CHR(13) + ;
	'ถ้าต้องการให้แก้ไขให้กรุณากดปุ่ม [Y]' TO correct
	IF correct $ 'yัYํ'
		DO Patient1Correct
	ELSE
		WAIT WIND 'แฟ้ม Patient1 ไม่ถูกต้อง ไม่สามารถทำงานต่อได้ ' TIME 100
		RETU
	ENDI
ENDI
USE

*** UDC
PRIVATE yy,mm
mdate=CE2BE(DATE())
yy=RIGHT(mdate,2)
mm=SUBS(mdate,4,2)
dbfuse = patientdir + 'doctor.dbf'
USE (dbfuse) IN 0
SELE doctor
IF FCOUNT() < 3
	= ALARM1()
	WAIT WIND 'โครงสร้างแฟ้มข้อมูล Doctor ไม่ถูกต้อง' + CHR(13) + ;
	'กรุณาแก้ไขโครงสร้างแฟ้มก่อน โดยใช้เมนู บำรุงรักษาระบบ' + CHR(13) + ;
	'มิฉะนั้นอาจเกิดความผิดพลาดในการทำงาน' + CHR(13) + ;
	'...กดปุ่มใด ๆ เพื่อทำงานต่อ...' TIME 100
ENDI
USE
*** UDC
*i=0
*dbfuse = ipddir+'data\IN'+yy +mm +'.dbf'
*DO WHIL !FILE(dbfuse)
*	IF VAL(mm) = 1
*		mm ='12'
*		yy = ALLTRIM(STR(VAL(yy) - 1))
*	ELSE
*		mm = RIGHT('0'+ALLTRIM(STR(VAL(mm)-1)),2)
*	ENDI
*	dbfuse = ipddir+'data\IN'+yy +mm +'.dbf'
*	i=i+1
*	WAIT WIND 'i =' +STR(i)
*	IF i = 5
*		!FILE(dbfuse) = .T.
*		WAIT WIND 'STOP'
*		EXIT
*	ENDIF
*ENDD
*USE (dbfuse) IN 0
*COPY TO temp STRU EXTE
*USE temp
*LOCA FOR field_name = 'ADM_W'
*IF EOF()
*	WAIT WIND 'โครงสร้างแฟ้มข้อมูล ' +dbfuse + ' ไม่ถูกต้อง' + CHR(13) + ;
*	'กรุณาแก้ไขโครงสร้างแฟ้มก่อน โดยใช้เมนู บำรุงรักษาระบบ' + CHR(13) + ;
*	'มิฉะนั้นอาจเกิดความผิดพลาดในการทำงาน' + CHR(13) + ;
*	'...กดปุ่มใด ๆ เพื่อทำงานต่อ...' TIME 100
*ENDI
*USE
*DELE FILE temp.dbf

*dbfuse = ipddir+'data\ADM'+yy
*USE (dbfuse) IN 0
*COPY TO temp STRU EXTE
*USE temp
*LOCA FOR field_name = 'ADM_W'
*IF EOF()
*	WAIT WIND 'โครงสร้างแฟ้มข้อมูล ADM' +yy +' ไม่ถูกต้อง' + CHR(13) + ;
*	'กรุณาแก้ไขโครงสร้างแฟ้มก่อน โดยใช้เมนู บำรุงรักษาระบบ' + CHR(13) + ;
*	'มิฉะนั้นอาจเกิดความผิดพลาดในการทำงาน' + CHR(13) + ;
*	'...กดปุ่มใด ๆ เพื่อทำงานต่อ...' TIME 100
*ENDI
*USE
*DELE FILE temp.dbf
*** UDC

col=Center(mhosp_name)
@ 0,col SAY mhosp_name COLO g+/b
DO mainscr
DO workscr
			NumMain=6           && จำนวนรายการหลัก
			DIME MAIN(NumMain),MainMess(NumMain)
			Main(1)='ห้องบัตร'
			Main(2)='ผู้ป่วยนอก'
			Main(3)='รับผู้ป่วยใน'
			Main(5)='บำรุงรักษาระบบ'
			Main(4)='ผู้ป่วยใน'
			Main(NumMain)='เลิกงาน'
			MainMess(1)='งานห้องบัตรและห้องทะเบียน'
			MainMess(2)='งานลงข้อมูลการมาตรวจผู้ป่วยนอก'
			MainMess(3)='งานลงทะเบียนผู้ป่วยรับไว้ในโรงพยาบาล และประชาสัมพันธ์'
			MainMess(4)='งานลงผลการรักษาผู้ป่วยใน'
			MainMess(5)='งานกำหนดค่าระบบ และอรรถประโยชน์'
			MainMess(NumMain)='เลิกการทำงาน'
			ColSpace=78/NumMain    && ระยะห่างระหว่างแต่ละรายการ
			ChMain=1               && รายการที่เลือก
DO WHIL goon
	DO CASE
		CASE UPPE(_toprog) == 'S'
			DO lan WITH .T.
		CASE UPPE(_toprog) == 'P'
			DO lan WITH .T.
		CASE UPPE(_toprog) == 'O'
			DO came1 WITH .T.
		CASE UPPE(_toprog) == 'A'
			DO Adm_cen WITH .T.
		CASE UPPE(_toprog) == 'I'
			DO ipd WITH .T.
		OTHER
			CLOSE DATA
			sysdate=DATE()
			thaiday=Ce2Cbe(sysdate)
			@ 1,0
			@ 1,4 SAY thaiday COLO gr+/b
			@ 22,0 CLEA
			DO title WITH 'รายการหลัก'
			xx=1
			@ 2,0 SAY REPL('-',80)
			@ 21,0 SAY REPL('-',80)
			@ 22,0
			SELE 0
			dbfuse = patientdir+'user'
			USE (patientdir+'user')
			dbfuse = ''
			ChMain =IIF(RECCOUNT('user') = 0,5,ChMain)
			USE
			DO WHIL xx<=NumMain
				@ 22,Col()+2 PROMPT Main(xx) MESSAGE MainMess(xx)
				xx=xx+1
			ENDD
			= EngMODE()
			MENU TO ChMain
			@ 22,0 CLEA
			DO CASE
				CASE ChMain=1
					DO Lan
				CASE Chmain=2
					DO Came1
				CASE Chmain=3
					DO Adm_cen
				CASE ChMain=4
					DO Ipd
				CASE ChMain=5
					DO StatUtil
				CASE ChMain=nummain
					CLOSE DATA
					ON ERROR
					goon = .F.
				OTHER
					Chmain = nummain
			ENDC
		DO mainScr
	ENDC
ENDD
= ENGMODE()
? CHR(155)+'KE'
DO EndSet
CLEA

PROC MAINSCR
@ 3,0 CLEA TO 20,80
@ 2,0
TEXT
                          โปรแกรมสำหรับงานเวชระเบียนและสถิติ
                                STAT Version <<statversion>>
                                 กระทรวงสาธารณสุข
ENDTEXT
? SPAC(Center(programdate))+programdate

PROC WORKSCR
TEXT
                               คณะทำงานพัฒนาโปรแกรม
    นายแพทย์ประดิษฐ์  วงษ์คณารัตนกูล        โรงพยาบาลเมืองสมุทร
    นายแพทย์ฐิติ      พัฒนกำจร              โรงพยาบาลเกษมราษฎร์
    นายแพทย์อนุวัฒน์  ศุภชุติกุล            สถาบันวิจัยระบบสาธารณสุข
    นายแพทย์วิรัตน์   ลือวิเศษไพบูลย์       โรงพยาบาลสรรพสิทธิประสงค์ อุบลฯ
    นายแพทย์ยุทธพงศ์  พตด้วง                โรงพยาบาลเสนา อยุธยา
    นายแพทย์ถาวร      สกุลพาณิชย์           โรงพยาบาลพระพุทธบาท สระบุรี
    นางสาวนิตณา       วิเศษชัยนุสรณ์        สถาบันราชภัฏ สวนสุนันทา
    นางสาวลี่ลี       อิงศรีสว่าง           คณะสาธารณสุขศาสตร์ มหิดล
    นางสาวสุวรรณา     เสมอเนตร              สำนักเทคโนโลยีสารสนเทศ
    นางอุษณีย์        เกียรติเสริมขจร       กองโรงพยาบาลภูมิภาค
ที่ปรึกษา... นายแพทย์สุชาติ สรณสถาพร        โรงพยาบาลรามาธิบดี
ปรับปรุงโดย... นายหรินทร์ ศิขรินวรานนท์     โรงพยาบาลภูเรือ เลย
             ภก.อุดมโชค สมหวัง  โรงพยาบาลสมเด็จพระสังฆราช องค์ที่ 17 สุพรรณบุรี
ENDTEXT

***------------------------  นัดคนไข้  --------------------
proc appointment
PARA _new
DEAC WIND ALL
@3,0 TO 20,80 clea
SELE holiday
COPY TO ARRA HLDDATE FOR DATE > DATE()
IF TYPE('hlddate') # 'D'
	DIME hlddate(1,2)
	hlddate[1,1] = {01/01/1700}
	hlddate[1,2] = '             '
ENDI
DO AddRoutHld WITH DATE(),hlddate

do appo_screen           && search parag 3000
do entry_appo            && search parag 4000

***---------------------   3000   ----------------
proc appo_screen
text

    				กำหนดการนัดตรวจคนไข้


           วันที่นัด                           เวลานัด


           นัดตรวจคนไข้ที่คลีนิค


           แพทย์ผู้นัด



           ส่งชันสูตร

endtext
***------------------------   4000  บันทึกการนัด  ---------------
PROC ENTRY_APPO
fromin = PROGRAM(3) = 'IN_APPO'
ON KEY LABEL CTRL+P DO PrintStatus
ON KEY LABEL ALT+C DO Showcalendar WITH mdateappo
m.date = {  /  /  }
firstenter = _new 	&& ให้รู้ว่าเป็นการเพิ่งเข้ามาลงข้อมูล
@ 4,60 SAY IIF(_printappoint,'พิมพ์ใบนัด    ','ไม่พิมพ์ใบนัด ') COLO /w
@ 8,28 get mdateappo WHEN HideWin('win1') .AND. ActiCalendar() PICT '@!' ;
VALID CHECKAPPOINT(mdateappo) .AND. DeacCalendar() ;
mess 'ใส่ วันเดือนปี(ddmmyyyy) หรือ W ต่อท้ายแทนสัปดาห์ หรือ M ต่อท้ายแทนเดือน (ALT+C)'
@ 9,28 GET showdate DEFA SPACE(20) DISA COLO ,,,,,,,,,/w
@ 8,56 get mmtime pict '@r ##:##' VALID TimeAPPO(mmtime) ;
  mess 'ใส่เวลาที่นัดเป็น ชั่วโมงนาที'
@ 11,34 GET m.clinic VALID CheckClinic(m.clinic,mclinic)
@ 11,38 GET mclinic DISA COLO ,,,,,,,,,/w
@ 14,28 get m.doctor WHEN InputDoctor(m.doctor) VALID ;
CheckDoctor(m.doctor,mdoctor) MESS 'ใส่รหัสแพทย์ที่นัดผู้ป่วยไปพบ'
@ 14,35 GET mdoctor WHEN CLEARKEY() DISA COLO ,,,,,,,,,/w
@ 18,28 EDIT m.lab SIZE 3,40  WHEN EditLab() COLO ,/w;
  mess ' LAB ที่ต้องใช้ประกอบ สามารถกดปุ่มหมายเลขหน้าชื่อได้'
@ 22,20 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET m.correct WHEN Clearkey()DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
READ NOLOCK
=ClearKey()
**********

@ 4,60
if LEFT(mdateappo,2) # '  '
	m.doctor = PADBLANK(m.doctor)
	IF ! fromin .AND. USED('camefile')
		sele camefile
		m.hn    =hn
	ENDI
   m.time=mmtime
   sele appoint
	IF  _new
	   	GO TOP
   		IF ! EMPTY(hn) .OR. BOF()
   			appe blank
   		ENDI
   ENDI
   gather memv MEMO
   FLUSH
	IF _printappoint
		IF FILE('printapp.fxp')
			DO ('printapp')
		ELSE
			DO Prappop
		ENDI
	ENDI
ELSE
	SELE appoint
	IF ! _new .AND. ! EOF()
		REPL hn WITH '  ',DATE WITH CTOD('  /  /  '),lab WITH ''
		FLUSH
	ENDI
endi
IF ! fromin
	IF PROGRAM(2) = 'ADM_CEN'
		SELE iptrana
	ELSE
		IF USED('camefile')
			SELE camefile
		ENDI
	ENDI
ENDI
ON KEY LABEL CTRL+P
RETURN

FUNC CHECKAPPOINT
para _check
private _date
IF LEFT(_check,2)='  '
	CLEA READ
	RETU
ENDI

_date=ALLTRIM(_check)
_type=RIGHT(_date,1)
   if _type $ 'WM'
      newdate=VAL(SUBS(_check,1,LEN(_date)-1))
      IF PROGRAM(3) = 'IN_APPO' .OR. ! used('camefile')
      	m.date=IIF(_type = 'W',DATE()+(newdate*7),DATE()+(newdate*28))
      ELSE
      	m.date=IIF(_type = 'W',camefile->date+(newdate*7),camefile->date+(newdate*28))
      ENDI
   ELSE
   	  _check=IIF(LEN(_date)<10,LEFT(_check,2)+'/'+SUBS(_check,3,2)+'/'+SUBS(_check,5,4),_check)
   	  IF TRUEDATE(_check)
   	  	m.date=BE2CE(_check)
   	  	IF USED('camefile')
	   	  	_cdate = IIF(PROGRAM(3)='IN_APPO',DATE(),camefile.date)
		ELSE
			_cdate = DATE()
		ENDI
   	  	IF m.date<=_cdate
    	    ?? CHR(7)
    	    WAIT 'ใส่วันที่นัดก่อนวันนี้ ไม่ถูกต้อง' WIND NOWA
    	    _CUROBJ=_CUROBJ
    	ENDI
   	  ELSE
   	    ?? CHR(7)
   	    WAIT 'ใส่วันที่นัดไม่ถูกต้อง' WIND NOWA
   	    _CUROBJ=_CUROBJ
   	  ENDI
   endi
dayofweek = DOW(m.date)
IF dayofweek = 1 .OR. dayofweek = 7
	?? CHR(7)
	showdayofweek = IIF(dayofweek = 1,'วันอาทิตย์','วันเสาร์')
	WAIT WIND NOWA 'โปรดระวัง ! นัดตรงกับวัน'+showdayofweek
ELSE
	ms = ASCAN(hlddate,m.date)
	IF ms > 0
		= ALARM1()
		WAIT WIND NOWA 'นัดตรงกับวัน '+ hlddate(ms+1)
	ENDI
ENDI
showdate=CE2CBE(m.date)
SHOW GETS

FUNC TIMEAPPO
PARA _mmtime
IF ! BETWEEN(VAL(LEFT(_mmtime,2)),8,15)
	=ALARM1()
	WAIT 'โปรดระวัง ! ไม่ใช่เวลาราชการ ไม่ควรนัดคนไข้' WIND NOWA
ENDI

FUNC EditLab
IF firstenter
	SELE countapp
	IF SEEK(DTOS(m.date)+m.clinic)
		numcount = number+1
		repl number WITH numcount
		FLUSH
	ELSE
		go top
		IF date < m.date
			APPE BLAN
		ENDI
		REPL date WITH m.date,clinic WITH m.clinic,number WITH 1
		FLUSH
		numcount = 1
	ENDI
	firstenter = .F.
	WAIT WIND NOWA 'ผู้ป่วยนัดเป็นคนที่ ' + LTRIM(STR(numcount))
ENDI

DEFINE WIND lab FROM 1,1 TO 18,26  && เดิม 15,23
ACTI WIND lab
@ 0,1 SAY 'ALT+1 = CBC'
@ 1,1 SAY 'ALT+2 = UA'
@ 2,1 SAY 'ALT+3 = CXR'
@ 3,1 SAY 'ALT+4 = EKG'
@ 4,1 SAY 'ALT+5 = BUN Cr'
@ 5,1 SAY 'ALT+6 = Electrolyte'
@ 6,1 SAY 'ALT+7 = LFT'
@ 7,1 SAY 'ALT+8 = FBS'
@ 8,1 SAY 'ALT+9 = VDRL'
@ 9,1 SAY 'ALT+0 = Anti HIV'
@10,1 SAY '^A = Ultrasound'
@11,1 SAY '^B = HBsAg'
@12,1 SAY '^X = X-ray อื่น ๆ'
@13,1 SAY '^C = CHO TG HDL'
@14,1 SAY '^N = NPO หลังเที่ยงคืน'
@15,1 SAY '^M = NPO หลัง 2 ทุ่ม'

SHOW WIND lab
ACTI SCREE
ON KEY LABEL ALT+1 KEYB 'CBC '
ON KEY LABEL ALT+2 KEYB 'UA '
ON KEY LABEL ALT+3 KEYB 'CXR '
ON KEY LABEL ALT+4 KEYB 'EKG '
ON KEY LABEL ALT+5 KEYB 'BUN Cr '
ON KEY LABEL ALT+6 KEYB 'Electrolyte '
ON KEY LABEL ALT+7 KEYB 'LFT '
ON KEY LABEL ALT+8 KEYB 'FBS '
ON KEY LABEL ALT+9 KEYB 'VDRL '
ON KEY LABEL ALT+0 KEYB 'Anti HIV '
ON KEY LABEL CTRL+A KEYB 'Ultrasound '
ON KEY LABEL CTRL+B KEYB 'HBsAg '
ON KEY LABEL CTRL+X KEYB 'X-ray อื่น ๆ '
ON KEY LABEL CTRL+C KEYB 'CHO TG HDL '
ON KEY LABEL CTRL+N KEYB 'งดน้ำและอาหารหลังเที่ยงคืน '
ON KEY LABEL CTRL+M KEYB 'งดน้ำและอาหารหลัง 2 ทุ่ม '
ON KEY LABEL ENTER KEYB "{TAB}"
*DO ClearKey

FUNC ClearKey
ON KEY LABEL ALT+1
ON KEY LABEL ALT+2
ON KEY LABEL ALT+3
ON KEY LABEL ALT+4
ON KEY LABEL ALT+5
ON KEY LABEL ALT+6
ON KEY LABEL ALT+7
ON KEY LABEL ALT+8
ON KEY LABEL ALT+9
ON KEY LABEL ALT+0
ON KEY LABEL CTRL+A
ON KEY LABEL CTRL+B
ON KEY LABEL CTRL+X
ON KEY LABEL CTRL+C
ON KEY LABEL CTRL+N
ON KEY LABEL CTRL+M
ON KEY LABEL ENTER
DEAC WIND lab

PROC PrintStatus
STOR IIF(_printappoint,.F.,.T.) TO _printappoint
@ 4,60 SAY IIF(_printappoint,'พิมพ์ใบนัด    ','ไม่พิมพ์ใบนัด ') COLO /w

FUNC CHECKFIRST
PARA _add
numpara = PARAMETERS()
varread=VARREAD()
DO CASE
	CASE varread='MT_IN'
		IF mt_in='  '
			mt_in=patient1->time
			SHOW GETS
			IF numpara > 0 .AND. UPPER(_add) = 'ADDCAME'
				mseek = m.hn + STR(DAY(BE2CE(mdate)),2) + m.clinic + STR(MINUTEIN(mt_in),4)
				IF SEEK(mseek,'camefile')
					?? CHR(7)
					WAIT WIND NOWA 'ผู้ป่วยคนนี้ได้ลงข้อมูลแล้ว'
					RETU .T.
				ELSE
					RETU IIF(mt_in='  ',.T.,.F.)
				ENDI
			ELSE
				RETU IIF(mt_in='  ',.T.,.F.)
			ENDI
		ENDI
	CASE varread='MT_OUT'
		IF mt_out='  '
			_mtime=TIME()
			mt_out=LEFT(_mtime,2)+SUBS(_mtime,4,2)
		ENDI
	CASE LEFT(varread,4) $ 'MNEW,DXTY'
		_x=RIGHT(varread,2)
		_x = IIF( ISDIGIT(_x), _x, RIGHT(_x,1) )
		IF EMPTY(mdiag&_x)
			mnew&_x=' '
			RETU .F.
		ELSE
			IF LEFT(varread,4) = 'MNEW'
				IF USED('newcase')
					SELE newcase
					IF ! SEEK(m.hn)
						mnew&_x = '1'
					ENDI
				ENDI
			ENDI
		ENDI

ENDC
SHOW GETS


***------------------------  ค่ารักษาผู้ป่วยใน --------------------
proc inchrg
PARA _new
*DEAC WIND ALL
define window inchrg from 03,0 to 20,79 shadow
activate window inchrg
@3,0 TO 20,80 clea
do inchrg_screen           && search parag 5000
do entry_inchrg            && search parag 6000
rele window inchrg
***---------------------   5000   ----------------
proc inchrg_screen
text
    				ค่ารักษาพยาบาลผู้ป่วยใน
  AN :            ค่ารักษาของ
  รายละเอียด
           ค่าชันสูตรห้องปฏิบัติการ
           ค่า X-Ray
           ค่าตรวจชันสูตรอื่น ๆ
           ค่าผ่าตัด
           ค่าการรักษาอื่น ๆ
           ค่ายาและเวชภัณฑ์
           ค่า ICU
           ค่าห้อง
           ค่าอาหาร
           อื่น ๆ
        รวม
        จ่ายจริง

endtext
***------------------------   6000  บันทึกค่ารักษา ---------------
PROC ENTRY_inchrg
fromin = PROGRAM(3) = 'IN_inchrg'
m.date = {  /  /  }
firstenter = _new 	&& ให้รู้ว่าเป็นการเพิ่งเข้ามาลงข้อมูล
stor 0 to m01,m02,m03,m04,m05,m06,m07,m08,m09,m010,m.sum,m.paid
cItem1 = "0A"
cItem2 = "0B"
cItem3 = "0C"
cItem4 = "0D"
cItem5 = "0E"
cItem6 = "0F"
cItem7 = "0G"
cItem8 = "0H"
cItem9 = "0I"
cItem10 = "0J"
@ 1,8 SAY m.an COLO /w
@ 1,31 SAY m.name colo /w
@ 3,8 say cItem1 colo /w
@ 3,37 GET m01 PICT '@R #######' COLO ,,,,,,,,,/w
@ 4,8 say cItem2 colo /w
@ 4,37 GET m02 PICT '@R #######' COLO ,,,,,,,,,/w
@ 5,8 say cItem3 colo /w
@ 5,37 GET m03 PICT '@R #######' COLO ,,,,,,,,,/w
@ 6,8 say cItem4 colo /w
@ 6,37 GET m04 PICT '@R #######' COLO ,,,,,,,,,/w
@ 7,8 say cItem5 colo /w
@ 7,37 GET m05 PICT '@R #######' COLO ,,,,,,,,,/w
@ 8,8 say cItem6 colo /w
@ 8,37 GET m06 PICT '@R #######' COLO ,,,,,,,,,/w
@ 9,8 say cItem7 colo /w
@ 9,37 GET m07 PICT '@R #######' COLO ,,,,,,,,,/w
@ 10,8 say cItem8 colo /w
@ 10,37 GET m08 PICT '@R #######' COLO ,,,,,,,,,/w
@ 11,8 say cItem9 colo /w
@ 11,37 GET m09 PICT '@R #######' COLO ,,,,,,,,,/w
@ 12,8 say cItem10 colo /w
@ 12,37 GET m010 PICT '@R #######' COLO ,,,,,,,,,/w
read nolock
m.sum = m01+m02+m03+m04+m05+m06+m07+m08+m09+m010
@ 13,37 SAY m.sum COLO /w
@ 14,37 GET m.paid COLO /w
@ 15,20 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET m.correct WHEN Clearkey()DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
READ NOLOCK
=ClearKey()

********************************** ถ้ามีข้อมูลค่ารักษาบันทึกใน rcpd,dtpd,creditpd
*	= OPENDBF(BILLDIR+'all\DtPd','DtPd')
*	= OPENDBF(BILLDIR+'all\RcPd','RcPd')
*	= OPENDBF(BILLDIR+'all\CreditPd','CreditPd')
do openfile1
sele creditpd
*SET ORDER TO TAG Rc_no
go bott
mRc_no = Rc_no
m.Rc_no = str(val(mRc_no)+1)
	DO WHIL ! empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
	GATH MEMV
	FLUSH
	UNLOCK ALL

sele RcPd
m.date = datedsc
m.total = m.sum
m.paid = m.paid
	DO WHIL ! empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
	GATH MEMV
	FLUSH
	UNLOCK ALL

sele dtpd
goon = .T.
n=1
DO WHIL n <= 10
	msv_id = 'cItem'+alltrim(str(n))
	mget = 'm0'+alltrim(str(n))
	m.sv_id = &msv_id
	m.amt = &mget
		go top
		if m.amt = 0
			*skip
			n = n+1
		else
		DO WHIL ! empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
		gather memvar
		FLUSH
		UNLOCK ALL
	n = n+1
ENDI
ENDD

********************
FUNC CheckClinic
********************
PARA _clinic,_mclinic
SELE clinic
IF ! EMPTY(_clinic)
   	SET ORDER TO TAG clinic
	IF ! SEEK(_clinic)
		?? CHR(7)+CHR(7)
		WAIT 'ไม่มีคลีนิครหัส '+_clinic WIND NOWAIT
		_CUROBJ=_CUROBJ
	ENDI
	_mclinic=name
ELSE
	?? CHR(7)
	WAIT WIND NOWA 'ต้องใส่รหัสคลีนิกด้วย'
	_CUROBJ=_CUROBJ
ENDI
SHOW GETS

PROC WARNNEW
PARA _newfile
PRIV correct,tempfile
=ALARM1()
DEFI WIND warnnew FROM 4,5 TO 14,70 SHAD
ACTI WIND warnnew
@ 1,3 SAY 'โครงสร้างของแฟ้ม ' + _newfile +' ไม่ถูกต้อง'
@ 3,3 SAY 'ท่านต้องการแก้ไขให้ถูกต้องหรือไม่' GET correct PICT '!' DEFA 'Y'
READ NOLOCK
IF correct # 'Y'
	RELE WIND warnnew
	RETU TO MASTER
ELSE
	CLEA
	@ 2,3 SAY 'ท่านต้องการแก้ไข้แฟ้ม ' + _newfile + ' ให้ถูกต้อง'
	@ 4,3 SAY 'ท่านต้องให้คอมพิวเตอร์เครื่องอื่นหยุดการเรียกใช้แฟ้มนี้'
	@ 7,3 SAY 'ท่านพร้อมแล้วใช่หรือไม่ ' GET correct PICT '!'
	READ NOLOCK
	IF correct # 'Y'
		RELE WIND warnnew
		RETU TO MASTER
	ELSE
		USE
		tempfile = PATIENTDIR + SYS(3)
		RENA (_newfile+'.dbf') TO (tempfile+'.dbf')
		dbfuse = _newfile
		CREATE TABLE (_newfile) (HN C(7),VISITED L)
		INDEX ON hn TAG hn
		dbfuse = _newfile
		USE (_newfile) ORDER TAG hn ALIA newcase
		dbfuse = patientdir+tempfile
		USE (tempfile) IN 0 ALIA temp
		dbfuse = ''
		SELE temp
		div_num=ROUND((RECCOUNT()/40)+.5,0)
		recno = 0
		DO ShowProgress
		SCAN
			recno=recno+1
			@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
			m.hn = hn
			m.visited = .T.
			INSERT INTO newcase FROM MEMV
		ENDS
		DEAC WIND progress
		USE
		DELE FILE (tempfile+'.dbf')
	ENDI
ENDI
RELE WIND warnnew
CLEA TYPEAHEAD

FUNC ActiCalendar
ON KEY LABEL Alt+C DO Showcalendar WITH mdateappo

FUNC DeacCalendar
ON KEY LABEL Alt+C

PROC ShowCalendar
PARA _date
PRIV dateappo
dateappo = IIF(! EMPTY(_date) .AND. Truedate(_date),BE2CE(_date),DATE() + 1)
nextdate = GOMONTH(DATE(),6)
nextdate = nextdate - DAY(nextdate)
dateappo = IIF(dateappo > nextdate, nextdate, dateappo)
DO hifu WITH DATE(),dateappo
_date = CE2BE(dateappo)
SHOW GETS
KEYB CHR(13)

PROC AddRoutHld
PARA _date,_arr
PRIV year
numadd = 22
DIME routhld[numadd,2]
year = STR(YEAR(_date),4)
year1 = STR(YEAR(_date)+1,4)
routhld[1,1] = CTOD('01/01/'+year)
routhld[1,2] = 'วันขึ้นปีใหม่   '
routhld[2,1] = CTOD('06/04/'+year)
routhld[2,2] = 'วันจักรี   '
routhld[3,1] = CTOD('13/04/'+year)
routhld[3,2] = 'วันสงกรานต์      '
routhld[4,1] = CTOD('14/04/'+year)
routhld[4,2] = 'วันสงกรานต์      '
routhld[5,1] = CTOD('15/04/'+year)
routhld[5,2] = 'วันสงกรานต์      '
routhld[6,1] = CTOD('05/05/'+year)
routhld[6,2] = 'วันฉัตรมงคล      '
routhld[7,1] = CTOD('12/08/'+year)
routhld[7,2] = 'วันเฉลิมพระชนม์ ราชินี'
routhld[8,1] = CTOD('23/10/'+year)
routhld[8,2] = 'วันปิยะมหาราช '
routhld[9,1] = CTOD('05/12/'+year)
routhld[9,2] = 'วันเฉลิมพระชนม์พรรษา ในหลวง'
routhld[10,1] = CTOD('10/12/'+year)
routhld[10,2] = 'วันรัฐธรรมนูญ    '
routhld[11,1] = CTOD('31/12/'+year)
routhld[11,2] = 'วันสิ้นปี        '
routhld[12,1] = CTOD('01/01/'+year1)
routhld[12,2] = 'วันขึ้นปีใหม่   '
routhld[13,1] = CTOD('06/04/'+year1)
routhld[13,2] = 'วันจักรี   '
routhld[14,1] = CTOD('13/04/'+year1)
routhld[14,2] = 'วันสงกรานต์      '
routhld[15,1] = CTOD('14/04/'+year1)
routhld[15,2] = 'วันสงกรานต์      '
routhld[16,1] = CTOD('15/04/'+year1)
routhld[16,2] = 'วันสงกรานต์      '
routhld[17,1] = CTOD('05/05/'+year1)
routhld[17,2] = 'วันฉัตรมงคล      '
routhld[18,1] = CTOD('12/08/'+year1)
routhld[18,2] = 'วันเฉลิมพระชนม์ ราชินี'
routhld[19,1] = CTOD('23/10/'+year1)
routhld[19,2] = 'วันปิยะมหาราช '
routhld[20,1] = CTOD('05/12/'+year1)
routhld[20,2] = 'วันเฉลิมพระชนม์พรรษา ในหลวง'
routhld[21,1] = CTOD('10/12/'+year1)
routhld[21,2] = 'วันรัฐธรรมนูญ    '
routhld[22,1] = CTOD('31/12/'+year1)
routhld[22,2] = 'วันสิ้นปี        '

oldarrlen = ALEN(_arr,1)
DIME _arr[oldarrlen+numadd,2]
FOR i = 1 TO numadd
	_arr[oldarrlen+i,1] = routhld[i,1]
	_arr[oldarrlen+i,2] = routhld[i,2]
NEXT

FUNC CHECKDXTYPE
PARA _dxtype, _mdiag
preprogram = PROGRAM(2)
varread = VARREAD()
numpara = PARAMETERS()
IF numpara = 1 .OR. ! (ISDIGIT(_mdiag) .OR. LEFT(_mdiag,1) = '*')
* udc
	IF LEFT(_mdiag,1) $ 'VWXYvwxy' .and. _dxtype <> '4'
		= CHR(7)
		WAIT WIND NOWA 'ใส่ประเภทไม่ถูกต้อง' + CHR(13) + ;
		'สาเหตุของการบาดเจ็บ (ขึ้นต้นด้วย V, W, X, Y) ต้องใส่ประเภทเป็น 4'
		RETU 0
	ELSE
		IF LEFT(_mdiag,3) = 'Z37' .and. _dxtype <> '4'
			= CHR(7)
			WAIT WIND NOWA 'ใส่ประเภทไม่ถูกต้อง' + CHR(13) + ;
			'Delivery Outcome (ขึ้นต้นด้วย Z37) ต้องใส่ประเภทเป็น 4'
			RETU 0
		ELSE
* udc
			IF ! BETWEEN(_dxtype,'2','4')
				= CHR(7)
				WAIT WIND NOWA 'ใส่ประเภทไม่ถูกต้อง กดปุ่ม [F1] ถ้าต้องการความช่วยเหลือ'
				RETU 0
			ENDI
		ENDI && udc
	ENDI && udc
ENDI
IF RIGHT(varread,1) = '4' AND LASTKEY() # 5
	IF preprogram = 'CAME1'
		DO diaginpu.spr
	ELSE
		DO diagip.spr
	ENDI
ENDI

****************
FUNC CheckDoctor
****************
PARA _doctor,_mdoctor
SELE doctor
validinput = .T.
varread = VARREAD()
IF ! EMPTY(_doctor)
	_doctor=PadBlank(_doctor,6)
   	SET ORDER TO TAG doctor
	IF ! SEEK(_doctor)
		?? CHR(7)+CHR(7)
		WAIT 'ไม่มีแพทย์รหัส '+_doctor WIND NOWAIT
		_doctor=RemoveBlank(_doctor)
		_CUROBJ = _CUROBJ - 1
		validinput = .F.
	ELSE
		IF ! STATUS
			?? CHR(7)+CHR(7)
			WAIT '!!! โปรดระวัง... แพทย์ท่านนี้ไม่ได้ทำงานที่นี่แล้ว !!!' WIND NOWAIT
		ENDIF
	ENDI
	_mdoctor=name
ENDI
SHOW GETS
IF validinput .AND. UPPE(varread) = 'SURG4'
	DO OperIP.spr
ENDI