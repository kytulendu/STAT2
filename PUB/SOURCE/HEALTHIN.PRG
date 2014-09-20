PARA _startprog
STORE  .F. TO audit, er
STORE .T. TO healthin
notremovethai = .T.
IF PARAMETERS() > 0
	notremovethai = UPPE(_startprog) = 'T'
ENDI
statversion = 'HIP 1.0a'
*RELE ALL
SET PROC TO Utility
SET LIBR TO foxfix ADDI
_toprog = IIF(PARAMETER()=0,'  ',_startprog)
DO StartSet
ON KEY LABEL F7 STORE .F. TO healthin
thaipro = FILE('thaipro.exe') .AND. FILE('thai.cfg') .AND. FILE('reset.com') ;
.AND.  FILE('thikey.bin') .AND. FILE('engkey.bin') .AND. FILE('plv1.bin') ;
.AND. FILE('plv2.bin') .AND. FILE('plv3.bin')
*IF thaipro
*	! thaipro
*	LOAD thikey
*	LOAD engkey
*	LOAD plv1
*	LOAD plv2
*	LOAD plv3
*	CLEA
*ENDI
IF ! notremovethai
	! thaist
ENDI
ba = CHR(201) + CHR(205) + CHR(187) + CHR(186) + CHR(188) + CHR(205) + CHR(200) + CHR(186)
bb = CHR(204) + CHR(205) + CHR(185) + CHR(186) + CHR(188) + CHR(205) + CHR(200) + CHR(186)
PRIV goon
SET RESOURCE OFF
#DEFINE UpArrow 5
#DEFINE LeftArrow 19
PUBLIC Atrscreen,Atrbackgr,Atrdata,Atrmenu,Atrmenu2
STORE '\pub\' TO patientdir,codedir
STOR '' TO tempdir,workstation,backup,admit,thaicard,person_id,;
prescription,notprintrx,wellbaby,notkeyword,backupdrive,dbfuse,notstatadmit
STORE '\ipd\' TO ipddir
STORE '\opd\' TO opddir
STORE '\pharm\' TO pharmdir
youngright	=	'71,81'
poorright	=	'72,82'
studentright =	'73,83'
disableright = 	'74,84'
warright	=	'75,85'
monkright	=	'76,86'
oldright	=	'77,87'
tempright	=	'78,88'
ON error DO err WITH ERROR(),MESSAGE(),LINENO(),PROGRAM(),PROGRAM(2),PROGRAM(3),;
PROGRAM(4),PROGRAM(5),PROGRAM(6),PROGRAM(7),PROGRAM(8),PROGRAM(9)
DIME ProvArr(60)
goon = .T.
DIME test(4)
=ADIR(test,SYS(16))
programdate=CE2CBE(test[3])
fromhelp = .F.
DO GetConfig
defadrive = LEFT(patientdir,AT('\',patientdir))
IF ADIR(directory,defadrive+'credit','D') = 0
	makedir = defadrive+'credit'
	! md &makedir
	makedir = defadrive+'credit\data'
	! md &makedir
	makedir = defadrive+'credit\report'
	! md &makedir
ENDI
IF ! FILE(patientdir + "opdlan.mem")
	DO makedbf WITH patientdir+'patient1'  && ตรวจสอบว่ามีแฟ้มที่จำเป็นครบหรือไม่ ถ้าขาดให้สร้างเพิ่ม
	PUSH KEY CLEA
	ON KEY LABEL F1 KEYB '{ENTER}'
	DO OpdLan  			&& สอบถามข้อมูลพื้นฐานของโรงพยาบาล
	POP KEY
	DO CLearScreen
	dbfuse = ''
	CLOSE DATA
ENDI
REST FROM (patientdir+'opdlan') ADDI
IF ! FILE(patientdir+'patient1.dbf')
	DO makedbf WITH patientdir+'patient1'  && ตรวจสอบว่ามีแฟ้มที่จำเป็นครบหรือไม่ ถ้าขาดให้สร้างเพิ่ม
ENDI	
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
ENDI
SET MESSAGE TO 24
SET TEXT ON
mhosp_name=LTRIM(TRIM(hosp_name))
dbfuse = patientdir + 'patient1'
USE (dbfuse) IN 0
SELE patient1
IF FCOUNT() < 12
	= ALARM1()
	WAIT WIND 'จำนวน Field ในแฟ้ม Patient1 ไม่ถูกต้อง' + CHR(13) + ;
	'จะต้องมีทั้งหมด 12 Field และ Field ที่ 12 จะต้องเป็น' + CHR(13) + ;
	'Person_id เป็น Character 13 หลัก' + CHR(13) + ;
	'ไม่สามารถทำงานต่อได้' TIME 60
	RETU
ENDI
USE
col=Center(mhosp_name)
@ 0,col SAY mhosp_name COLO g+/b
DO mainscr
PRIV goon,NumMain,Chmain,ColSpace,Userright,m.username
UserRight = ' '
m.username = ''
#DEFINE UpArrow 5
#DEFINE LeftArrow 19
dbfuse = ''
fromhelp = .F.
SET FUNC 2 TO ',นาย;'
SET FUNC 3 TO ',นาง;'
SET FUNC 4 TO ',นส.;'
SET FUNC 5 TO ',ดช.;'
SET FUNC 6 TO ',ดญ.;'
ON KEY LABEL F1 DO HELP WITH SYS(18),SYS(16)
ON KEY LABEL SHIFT+F2
Shift_f2=.F.
CLEA
@ 2,0 SAY REPL('-',80)
@ 21,0 SAY REPL('-',80)
hosp_dir=''
mhosp_name=LTRIM(TRIM(hosp_name))
col=Center(mhosp_name)
@ 0,col SAY mhosp_name COLO g+/b

******************************************************************************
*                    กำหนดค่าเริ่มต้นที่จำเป็นต่าง ๆ ไว้                     *
******************************************************************************

SET MESSAGE TO 24
NumMain=6            && จำนวนรายการหลัก
DIME StatMain(nummain),StatMainMess(nummain)
StatMain(1)='ลงทะเบียน'
StatMain(2)='พิมพ์บัตร'
StatMain(3)='บำรุงรักษา'
StatMain(4)='รายงาน'
StatMain(5)='ส่งข้อมูล'
StatMain(nummain)='เลิกงาน'
StatMainMess(1)='ลงทะเบียนสิทธิบัตรต่าง ๆ'
StatMainMess(2)='พิมพ์ใบสิทธิบัตร'
StatMainMess(3)='แก้ไขและเพิ่มเติมแฟ้มช่วยเหลือต่างๆ และระบบ'
StatMainMess(4)='ทำรายงานต่าง ๆ'
StatMainMess(5)='ส่งข้อมูลให้สถานบริการ'
StatMainMess(nummain)='เลิกงาน '
ColSpace=78/NumMain    && ระยะห่างระหว่างแต่ละรายการ
ChMain=1               && รายการที่เลือก
DO mainscr
dbfuse = codedir+'clinic'
USE (codedir+'clinic') IN 0
dbfuse = codedir+'ward'
USE (codedir+'ward') IN 0
dbfuse = codedir+'doctor'
USE (codedir+'doctor') IN 0
dbfuse = ''
toedithelp = reccount('CLINIC')<16 .OR. reccount('WARD')<14 .OR. ;
RECCOUNT('DOCTOR') = 0
goon = .T.
****************************************************************
****************************************************************
DO WHIL goon
	ON KEY LABEL F1 DO HELP WITH SYS(18),SYS(16)
	CLOSE DATA
	sysdate=DATE()
	thaiday=Ce2Cbe(sysdate)
	@ 1,4 SAY thaiday COLO gr+/b
	@ 22,0 CLEA
	DO title WITH 'งานลงทะเบียนสิทธิบัตร'
	xx=1
	@ 2,0 SAY REPL('-',80)
	@ 21,0 SAY REPL('-',80)
	@ 22,0
	DO WHIL xx<=NumMain
		@ 22,Col()+2 PROMPT StatMain(xx) MESSAGE StatMainMess(xx)
		xx=xx+1
	ENDD
	= THAIMODE()
	MENU TO ChMain
	@ 22,0 CLEA
		DO CASE
		CASE ChMain=1
			DO Newhn WITH .T.
		CASE Chmain=2
			DO PrHealth
		CASE Chmain=3
			DO HipUtil
		CASE ChMain=4
			DO HipRepo.spr
		CASE ChMain=5
			DO HIPExport
		CASE ChMain=nummain
			CLOSE DATA
			ON ERROR
			goon = .F.
		OTHER
			Chmain = nummain
		ENDC
	DO mainScr
ENDD
= ENGMODE()
DO ClearScreen
DO EndSet
CLEA
*IF ! notremovethai .AND. thaipro
*	! reset
*ENDI
IF ! notremovethai
	! thaist /U
ENDI

PROC MAINSCR
@ 3,0 CLEA TO 20,80
@ 2,0
TEXT
                        โปรแกรมสำหรับงานลงข้อมูลสิทธิบัตร
                       Health Insurance Program (HIP)
                                 <<statversion>>
                             สำนักงานประกันสุขภาพ
                             
                            คณะทำงานพัฒนาโปรแกรม

    นายแพทย์วิรัตน์   ลือวิเศษไพบูลย์          โรงพยาบาลสรรพสิทธิประสงค์ อุบลฯ
    นายแพทย์ยุทธพงศ์  พตด้วง                   โรงพยาบาลเสนา อยุธยา
    นายแพทย์ถาวร      สกุลพาณิชย์              โรงพยาบาลพระพุทธบาท สระบุรี
    นางสาวสุวรรณา     เสมอเนตร                 สำนักเทคโนโลยีสารสนเทศ
ENDTEXT

PROC HipUtil
********************************************************************************
*  โมดูลสำหรับขึ้นเมนูบำรุงรักษาระบบของโปรแกรมประกันสุขภาพ                          *
********************************************************************************

PRIVATE Colspace,PreScr,Ch_help
#define numutil 5
@ 3,0 CLEA TO 20,80
DIME chelp(numutil),EHelpMess(numutil)
chelp(1)='1. ซ่อมแฟ้มดัชนี'
chelp(2)='2. แก้ไขรหัสจังหวัด อำเภอ'
chelp(3)='3. แก้ไขรหัสสถาพยาบาล'
chelp(4)='4. เรียกข้อมูล'

chelp(numutil)='0. กลับรายการเดิม'

EhelpMess[1]='ซ่อมแซมแฟ้มดัชนีที่เสียไปให้คืนดี โปรดระวัง!'
EhelpMess[2]='เพิ่มเติมและแก้ไขรหัสอำเภอและจังหวัด'
EhelpMess[3]='เพิ่มเติมและแก้ไขรหัสสถานพยาบาล'
EhelpMess[4]='เรียกข้อมูลที่หน่วยงานอื่นส่งเข้ามา '
EHelpMess[numutil]='กลับไปสู่รายการหลัก'

DEFINE WIND help_menu FROM 4,5 TO 4+ALEN(chelp)+3,40 SHAD COLO gr+/BG TITLE '  กำหนดค่าต่าง ๆ  '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	= ENGMODE()
	DO Title WITH 'รายการบำรุงรักษา'
	ACTI WIND help_menu
	FOR i=1 TO ALEN(chelp)
		@ i,3 PROMPT chelp(i) MESS EhelpMess[i]
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
			DO Reindex
		CASE Ch_help = 2
			DO EditAddr
		CASE Ch_help = 3
			DO Add_SRV
		CASE Ch_help = 4
			DO HipImpo
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_menu
CLOSE DATA

PROC HIPExport
STOR SPACE(10) TO m.date1, m.date2
STORE 'Y' TO m.correct
DO HIPEXSCR.SPR
m.date1 = BE2CE(m.date1)
m.date2 = BE2CE(m.date2)
IF LASTKEY() # 27 .AND. m.correct $ 'Yํั'
	dbfuse = patientdir + 'patient1'
	=OPENDBF(dbfuse,'')
	dbfuse = patientdir + 'patient2'
	=OPENDBF(dbfuse,'')
	dbfuse = patientdir + 'contact'
	=OPENDBF(dbfuse,'')
	dbfuse = patientdir + 'insure'
	=OPENDBF(dbfuse,'')
	SELE m.hosp_code AS hospcode, a.hn, a.inscl, a.subtype, a.cid, a.name, a.datein, a.dateexp, a.hospmain,;
	a.hospsub, b.sex, b.birthday, b.derive, b.mother, b.father, b.person_id, ;
	c.marriage, c.occupa, c.nation, c.race, c.phone, d.address, d.village, ;
	d.tambon, d.ampur, d.changwat, '3' AS owner ;
	FROM insure a, patient1 b, patient2 c, contact d ;
	WHERE LEFT(a.hn,7) = b.hn .AND. b.hn = c.hn .AND. b.hn = d.hn ;
	GROUP BY a.hn, a.inscl, a.subtype ;
	HAVING BETWEEN(a.notedate,date1,date2) ;
	INTO TABLE hipdata
	IF RECCOUNT('hipdata') # 0
		USE
		m.todrive = 1
		m.exim = 'ส่งข้อมูลไป'
		DO Todrive.spr
		IF LASTKEY() # 27
			todrive = IIF(todrive = 1, 'A:', 'B:')
			WAIT WIND '  กรุณาใส่แผ่นเปล่าไว้ใน Drive ' + todrive + ' แล้วกดปุ่มอะไรก็ได้  '
			zipfile = todrive + 'hipdata'
			SET CONS OFF
			! PKZIP -a &zipfile hipdata.dbf
			SET CONS ON
			WAIT WIND NOWA IIF(FILE(todrive + 'hipdata.zip'), ;
			'  นำข้อมูลไว้ที่ Drive ' + todrive + ' เรียบร้อยแล้ว  ', ;
			'  ไม่สามารถเก็บข้อมูลไว้ที่ Drive ' + todrive + ' ได้  ') ;
			TIME 20
		ELSE
			=ALARM1()
			WAIT WIND NOWA '  ยกเลิกการส่งข้อมูลตามต้องการ  '
		ENDI
	ELSE
		= ALARM1()
		WAIT WIND NOWA '  ไม่มีข้อมูลระหว่างวันที่ ' + CE2CBE(m.date1) + ;
		' ถึงวันที่ ' + CE2CBE(m.date2) + '  '
	ENDI
ELSE
	= ALARM1()
	WAIT WIND NOWA 'ยกเลิการส่งข้อมูลตามต้องการ'
ENDI
CLOSE DATA
DELE FILE hipdata.dbf

PROC OpenLanMaster
SELE 2
dbfuse = patientdir+'contact'
USE (patientdir+'contact') ORDER 1
SELE 4
dbfuse = codedir+'occupat'
USE (codedir+'occupat') ORDER 1
SELE 5
dbfuse = codedir+'nation'
USE (codedir+'nation') ORDER 1
SELE 6
dbfuse = patientdir+'patient2'
USE (patientdir+'patient2') ORDER 1
SELE 7
dbfuse = codedir+'social'
USE (codedir+'social') ORDER 1
SELE 9
dbfuse = codedir+'address'
USE (codedir+'address') ORDER 1
SELE 10
dbfuse = patientdir+'hncount'
USE (patientdir+'hncount')
SELE 0
dbfuse = patientdir+'patient1'
USE (patientdir+'patient1') ORDER 1
SET RELA TO hn INTO patient2,hn INTO contact,class INTO social
dbfuse = ''


PROC SCATVAR
SELE patient1
SCATTER TO patient1
mbirthday=IIF(EMPTY(birthday),'  /  /    ',STR(DAY(birthday),2)+'/'+STR(MONTH(birthday),2)+'/'+STR(YEAR(birthday)+543,4))
SELE patient2
SCATTER TO patient2
SELE contact
SCATTER TO contact1
IF owner='1'
	SKIP
	IF hn # contact1[1]
		SKIP -1
	ENDI
ENDI
SCATTER TO contact2

