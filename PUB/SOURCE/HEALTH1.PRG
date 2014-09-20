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
	SELE a.hn, a.inscl, a.subtype, a.cid, a.name, a.datein, a.dateexp, a.hospmain,;
	a.hospsub, b.sex, b.birthday, b.derive, b.mother, b.father, b.person_id, ;
	c.marriage, c.occupa, c.nation, c.race, c.phone, d.address, d.village, ;
	d.tambon, d.ampur, d.changwat, '1' AS owner ;
	FROM insure a, patient1 b, patient2 c, contact d ;
	WHERE LEFT(a.hn,7) = b.hn .AND. b.hn = c.hn .AND. b.hn = d.hn ;
	GROUP BY a.hn, a.inscl, a.subtype ;
	HAVING BETWEEN(a.notedate,date1,date2) ;
	INTO TABLE temphip
	IF RECCOUNT('temphip') # 0
		USE
		m.todrive = 1
		DO Todrive.spr
		IF todrive > 0
			todrive = IIF(todrive = 1, 'A:', 'B:')
			WAIT WIND '  กรุณาใส่แผ่นเปล่าไว้ใน Drive ' + todrive + ' แล้วกดปุ่มอะไรก็ได้  '
			zipfile = todrive + 'hipdata'
			SET CONS OFF
			! PKZIP -a &zipfile temphip.dbf
			SET CONS ON
			WAIT WIND NOWA IIF(FILE(todrive + 'hipdata.zip'), ;
			'  นำข้อมูลไว้ที่ Drive ' + todrive + ' เรียบร้อยแล้ว  ', ;
			'  ไม่สามารถเก็บข้อมูลไว้ที่ Drive ' + todrive + ' ได้  ') ;
			TIME 20
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
DELE FILE temphip.dbf

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

