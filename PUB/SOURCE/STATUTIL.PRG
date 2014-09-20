********************************************************************************
*  โมดูลสำหรับขึ้นเมนูบำรุงรักษาระบบของโปรแกรม STAT2                           *
********************************************************************************

PRIVATE Colspace,PreScr,Ch_help
#define numutil 10
@ 3,0 CLEA TO 20,80
DIME chelp(numutil),EHelpMess(numutil)
chelp(1)='1. กำหนดผู้ใช้'
chelp(2)='2. กำหนดรหัสสิทธิ'
chelp(3)='3. แก้ไขรหัสผ่าน'
chelp(4)='4. สำรองข้อมูล'
chelp(5)='5. กำหนดค่าของระบบ'
chelp(6)='6. ซ่อมแฟ้มดัชนี'
chelp(7)='7. ตรวจสอบแฟ้มดัชนี'
chelp(8)='8. แก้ไขโครงสร้างแฟ้มเป็น Version 2.8'
chelp(9)='9. แก้ไขโครงสร้างแฟ้มเป็น Version 2.95'
chelp(numutil)='0. กลับรายการเดิม'

EHelpMess(1)='กำหนดชื่อผู้ใช้งานในระบบ และสิทธิในการใช้งาน'
EHelpMess(2)='กำหนดรหัสสิทธิการรักษาให้สอดคล้องกับรหัสกลาง'
EHelpMess(3)='แก้ไขรหัสผ่านของตัวเอง'
EHelpMess(4)='สำรองข้อมูลไว้เพื่อความปลอดภัย'
EHelpMess(5)='กำหนด Configuration ของระบบว่าจะให้ทำอะไรได้บ้าง'
EhelpMess(6)='ซ่อมแซมแฟ้มดัชนีที่เสียไปให้คืนดี โปรดระวัง!'
EhelpMess(7)='ตรวจสอบหาแฟ้มดัชนีที่เสีย'
EhelpMess(8)='ตรวจสอบและแก้ไขโครงสร้างแฟ้มของ STAT Ver2.6 ให้เป็นแบบ STAT Ver2.8'
EhelpMess(9)='ตรวจสอบและแก้ไขโครงสร้างแฟ้มของ STAT Ver2.8 ให้เป็นแบบ STAT Ver2.95'
EHelpMess(numutil)='กลับไปสู่รายการหลัก'

DEFINE WIND help_menu FROM 4,5 TO 4+ALEN(chelp)+3,45 SHAD COLO gr+/BG TITLE '    กำหนดค่าต่าง ๆ    '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	= ENGMODE()
	DO Title WITH 'รายการกำหนดค่าต่าง ๆ'
	ACTI WIND help_menu
	CLEA
	FOR i=1 TO ALEN(chelp)
		@ i,3 PROMPT chelp(i) MESS EhelpMess(i)
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
			DO InputUser
		CASE Ch_help = 2
			DO SocialRight
		CASE Ch_help = 3
			DO ChangeUsrPass
		CASE Ch_help = 4
			DO Audit
		CASE Ch_help = 5
			DO SetCon
		CASE Ch_help = 6
			DO Reindex
		CASE Ch_help = 7
			DO Checkind
		CASE Ch_help = 8
			DO CheckStructure
		CASE Ch_help = 9
			DO CheckStru295
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_menu
CLOSE DATA

PROC CheckStructure
********************************************************************************
*  โมดูลสำหรับขึ้นเมนูแก้ไขโครงสร้างแฟ้มข้อมูล                         *
********************************************************************************

PRIVATE Colspace,PreScr,Ch_help
#define numstru 10
@ 3,0 CLEA TO 20,80
DIME shelp(numstru),shelpmess(numstru)
shelp(1)='1. แฟ้มฐานข้อมูลหลัก'
shelp(2)='2. แฟ้มรหัสสถานบริการ'
shelp(3)='3. แฟ้มสิทธิการรักษา'
shelp(4)='4. แฟ้มผู้ป่วยนอก'
shelp(5)='5. แฟ้ม refer ผู้ป่วยนอก'
shelp(6)='6. แฟ้มรับผู้ป่วย'
shelp(7)='7. แฟ้มวินิจฉัยโรคผู้ป่วยใน'
shelp(8)='8. แฟ้ม refer ผู้ป่วยใน'
shelp(9)='9. แฟ้มรับผู้ป่วยในประจำปี'
shelp(numstru)='0. กลับรายการเดิม'

shelpmess(1) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้ม PATIENT1'
shelpmess(2) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มรหัสสถานบริการ'
shelpmess(3) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มสิทธิการรักษา'
shelpmess(4) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มผู้ป่วยนอก'
shelpmess(5) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้ม refer ผู้ป่วยนอก'
shelpmess(6) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มรับผู้ป่วยใน (IPTRANA) ต้องใช้เวลานานมาก'
shelpmess(7) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มผู้ป่วยใน และการผ่าตัด'
shelpmess(8) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้ม refer ผู้ป่วยใน'
shelpmess(9) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มรับผู้ป่วยในประจำปี (ADMyy) และการตาย'
shelpmess(numstru)='กลับไปสู่รายการหลัก'

DEFINE WIND ChkStru_menu FROM 4,5 TO 4+ALEN(shelp)+3,45 SHAD COLO gr+/BG TITLE ' เลือกแฟ้มที่ต้องการ '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	= ENGMODE()
	DO Title WITH 'แก้ไขโครงสร้างแฟ้มเป็น Version 2.8'
	ACTI WIND ChkStru_menu
	CLEAR
	FOR i=1 TO ALEN(shelp)
		@ i,3 PROMPT shelp(i) MESS shelpmess(i)
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
			DO CheckPatient1
		CASE Ch_help = 2
			DO CheckHospCode
		CASE Ch_help = 3
			DO CheckSocial
		CASE Ch_help = 4
			DO CheckCame
		CASE Ch_help = 5
			DO CheckRFO
		CASE Ch_help = 6
			DO CheckIPTRANA
		CASE Ch_help = 7
			DO CheckIPDFile
		CASE Ch_help = 8
			DO CheckRFI
		CASE Ch_help = 9
			DO CheckADM
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND ChkStru_menu
CLOSE DATA


PROC InputUser
PRIV UserName,UserRight,_ret,pp,_mkey,goon,goon1
userright = GetUser()
SELE 0
dbfuse = patientdir+'user'
USE (patientdir+'user') ORDER TAG name
dbfuse = ''
goon1 = .T.
IF 'SUP       ' == userright
	DEFI WIND inputuser FROM 5,10 TO 19,70 SHAD
	ACTI WIND inputuser
	DO WHIL goon1
		CLEA
		goon = .T.
		yn = 'N'
		UserName = SPACE(12)
		@ 1,3 SAY 'ชื่อผู้ใช้  : ' GET UserName PICT '@!'
		READ NOLOCK
		IF ! EMPTY(UserName) .AND. LASTKEY() # 27
			IF SEEK(UserName)
				=ALARM1()
				@ 3,5 SAY 'ชื่อ '+ UserName + ' เคยตั้งแล้ว ต้องการแก้ไขหรือไม่'
				@ 4,10 SAY 'Yes/No ' GET yn PICT '!'
				READ NOLOCK
				IF yn # 'Y'
					goon = .F.
				ENDI
				@ 3,0 CLEA
			ENDI
			IF goon
				msg = 'ไม่ต้องใส่รหัสผ่านถ้าต้องการลบผู้ใช้'

				@ WROW() - 1,Center(msg) SAY msg
				@ 3,3 SAY 'รหัสผ่าน    : '
				_ret = ''
				FOR pp = 1 TO 10
					_mkey = INKEY(0)
					IF _mkey = 13
						EXIT
					ENDI
					_ret = _ret+CHR(_mkey)
					@ 3,COL() SAY '*'
				NEXT
				IF EMPTY(_ret)
					IF ! EOF()
						SCAT MEMV BLANK
						GATH MEMV
					ENDI
				ELSE
					_ret = UPPE(LEFT(_ret+SPAC(10),10))
					IF 'SUP       ' == right
						STORE 1 TO sright,aright,oright,iright,suright
					ELSE
						sright = IIF( 'S' $ right,1,0)
						aright = IIF('A' $ right,1,0)
						oright = IIF('O' $ right,1,0)
						iright = IIF('I' $ right,1,0)
						suright = 0
					ENDI
					@ WROW() - 1,0
					@ WROW() -1,Center('กดปุ่ม [Esc] เมื่อเสร็จ') SAY 'กดปุ่ม [Esc] เมื่อเสร็จ'
					@ 5,8 GET suright FUNC '*C สิทธิของ Supervisor'
					@ 6,8 GET sright FUNC '*C สิทธิใช้โปรแกรมห้องบัตร' WHEN suright = 0
					@ 7,8 GET oright FUNC '*C สิทธิใช้โปรแกรมผู้ป่วยนอก' WHEN suright = 0
					@ 8,8 GET aright FUNC '*C สิทธิใช้โปรแกรมรับผู้ป่วย' WHEN suright = 0
					@ 9,8 GET iright FUNC '*C สิทธิใช้โปรแกรมผู้ป่วยใน' WHEN suright = 0
					READ NOLOCK CYCLE
					IF suright = 1
						userright = 'SUP'
					ELSE
						userright = IIF(sright=1,'S,','')
						userright = IIF(oright=1,userright+'O,',userright)
						userright = IIF(aright=1,userright+'A,',userright)
						userright = IIF(iright=1,userright+'I,',userright)
					ENDI
					IF EOF()
						GO TOP
						IF ! EMPTY(name) .OR. BOF()
							APPE BLAN
						ENDI
					ENDI
					REPL name WITH UserName,psw WITH Encrypt(_ret),right WITH userright
				ENDI
			ENDI
		ELSE
			goon1 = .F.
		ENDI
	ENDD
	RELE WIND inputuser
ENDI
SELE user
USE

PROC ChangeUsrPass
PRIV UsrName,NewPass
STORE ' ' TO UsrName,NewPass
IF ! EMPTY(GetUser(UsrName))
	IF ChangePass(NewPass)
		SELE 0
		dbfuse = patientdir+'user'
		USE (patientdir+'user') ORDER TAG name
		dbfuse = ''
		SEEK UsrName
		REPL psw WITH Encrypt(LEFT(NewPass+SPACE(10),10))
		USE
		=ALARM1()
		WAIT WIND NOWA 'โปรดระวัง ! ได้เปลี่ยนรหัสผ่านใหม่ตามต้องการแล้ว โปรดจำให้แม่น'
	ENDI
ENDI

PROC SocialRight
PRIV UserName,UserRight,_ret,pp,_mkey,goon,goon1
userright = GetUser()
SELE 0
dbfuse = patientdir+'social'
= OpenDBF(dbfuse,'',1)
dbfuse = patientdir+'pttyp'
= OpenDBF(dbfuse,'',1)
dbfuse = ''
goon1 = .T.
IF 'SUP       ' == userright
	msg = '[CTRL]+[N] = เพิ่มรหัส     [CTRL]+[V] = ขอดูรหัสจากส่วนกลาง  [Esc] = เสร็จ'
	ACTI SCREE
	@ 23, Center(msg) SAY msg
	ON KEY LABEL CTRL+N DO APPE_BLANK
	ON KEY LABEL CTRL+V DO viewpttype
	SELE social
	DEFINE WIND social FROM 3,10 TO 17,70 SHAD
	BROW FIELD class :h='รหัส', name :h='    สิทธิการรักษา', pttyp :h='รหัสมาตรฐาน' WIND social
	RELE WIND pttype, social
	ON KEY LABEL CTRL+N
	ON KEY LABEL CTRL+V
	ACTI SCREE
	@ 23,0
ENDI

PROC ViewPTTYPE
ON KEY LABEL CTRL+V
SELE pttyp
DEFINE WIND pttype FROM 13,10 TO 22,70 SHAD
BROW FIELD pttyp :h='รหัสมาตรฐาน', typname :h='   สิทธิการรักษา' WIND pttype
SELE social
ON KEY LABEL CTRL+V DO viewpttype


PROC APPE_BLANK
APPE BLANK

PROC CHECKPATIENT1
*******************************************************************
*  ตรวจสอบว่ามีการเก็บเลขที่บัตรประชาชนแล้วหรือยัง                *
*******************************************************************

SET EXCL ON
SELE 0
DEFINE WIND showready FROM 19,20 TO 23,78 SHAD COLO SCHEM 6

dbfuse = patientdir + 'patient1.dbf'
beupdate= .T.
IF FILE(dbfuse)
	USE (dbfuse)
	FOR I = 1 TO FCOUNT()
		IF FIELD(i) = 'PERSON_ID'
			i = 100
			beupdate = .F.
		ENDI
	NEXT
	IF beupdate						&& ยังไม่มีการใช้เลขที่บัตรประชาชน
		DO Patient1Correct			&& แก้ไขแฟ้มให้ใช้เลขที่บัตรประชาชน
	ENDI
ENDI
SET EXCL OFF
KEYB '!'
CLOSE DATA

PROC CHECKHOSPCODE
*******************************************************************
*  ตรวจสอบว่าใช้รหัสสถานบริการใหม่แล้วหรือยัง                     *
*******************************************************************
dbfuse = codedir + 'hospcode'
USE (dbfuse) ORDER 1
IF FCOUNT() < 5 					&& ยังไม่ได้ใช้รหัสสถานบริการใหม่
	USE
	SET DEFA TO (patientdir)
	IF ! FILE(patientdir + 'helpdbf.zip')
		?? CHR(7)
		CLEA
		WAIT WIND 'โปรดทราบ ! การติดตั้งโปรแกรม STAT2 Ver ' + statversion + ;
		' ไม่สมบูรณ์' + CHR(13) + 'กรุณา Install ใหม่ให้ถูกต้อง' TIME 10
		SET DEFA TO (currentdirectory)
		RETU
	ENDI
	! PKUNZIP -o helpdbf  hospcode.*
	CLEAR
ENDI
dbfuse = patientdir + 'hospcode.dbf'
USE (dbfuse) ORDER 1 EXCL
IF TAG(3) # 'CODE'
	INDEX ON code TAG code ADDI
ENDI
SET ORDER TO TAG code
IF TYPE('hosp_code') = 'C' .AND. LEN(hosp_code) > 5
	= SEEK(hosp_code)
	hosp_code = off_id
	SAVE ALL LIKE hosp_* TO (patientdir+'opdlan')
ENDI
CLOSE DATA
SET DEFA TO (currentdirectory)
KEYB '!'

PROC CHECKSOCIAL
***************************************************************
*  แก้ไขแฟ้ม Social                                           *
***************************************************************

dbfuse = patientdir + 'social.dbf'
SELE 0
IF FILE(dbfuse)
	WAIT WIND NOWA 'โปรดคอย กำลังแก้ไขแฟ้ม SOCIAL'
	USE (dbfuse) EXCL
	IF FCOUNT() < 3
		DO SocialCorrect
	ENDI
ENDI

***************************************************************
*  แก้ไขรหัสสถานพยาบาลของแฟ้ม INSURE                          *
***************************************************************

dbfuse = patientdir + 'insure.dbf'
IF ! USED('hospcode')
	SELE 0
	USE codedir + 'hospcode'
ENDI
SELE hospcode
IF FCOUNT('hospcode') < 5 .OR. TAG(3) # 'CODE'
	?? CHR(7)
	WAIT WIND NOWA 'ต้องแก้ไขโครงสร้างแฟ้มรหัสสถานพยาบาลก่อน'
	ch_help = 2
	RETU
ENDI
SELE hospcode
SET ORDER TO TAG code
SELE 0
IF FILE(dbfuse)
	WAIT WIND NOWA 'โปรดคอย กำลังแก้ไขแฟ้ม INSURE'
	USE (dbfuse) EXCL
	IF LEN(hospmain) > 5
		n = 1
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SCAN
			@ 2,10 SAY n
			= SEEK(hospmain,'hospcode')
			REPL insure.hospmain WITH hospcode.off_id
			= SEEK(hospsub, 'hospcode')
			REPL insure.hospsub WITH hospcode.off_id
			n = n + 1
		ENDS
		DO InsureCorrect
	ENDI
ENDI

***************************************************************
*  แก้ไขรหัสสถานพยาบาลของแฟ้ม INSURLOG                        *
***************************************************************

dbfuse = LEFT(patientdir,AT('\',patientdir)) + 'credit\data\insurlog.dbf'
SELE 0
IF FILE(dbfuse)
	WAIT WIND NOWA 'โปรดคอย กำลังแก้ไขแฟ้ม INSURLOG'
	USE (dbfuse) EXCL
	n = 1
	DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
	ACTI WIND trycorrect
	SCAN
		@ 2,10 SAY n
		= SEEK(hospmain, 'hospcode')
		REPL insurlog.hospmain WITH hospcode.off_id
		= SEEK(hospsub, 'hospcode')
		REPL insurlog.hospsub WITH hospcode.off_id
		n = n + 1
	ENDS
	DO InsureCorrect
ENDI
RELE WIND trycorrect
CLOSE DATA
KEYB '!'

PROC CHECKIPTRANA
*****************************************************************
*  แก้ไขรหัสสถานพยาบาลในแฟ้ม IPTRANA                            *
*****************************************************************
dbfuse = ipddir + 'data\iptrana.dbf'
IF FILE(dbfuse)
	USE (dbfuse) EXCL
	IF (LEN(place)) > 5
		IF ! USED('hospcode')
			SELE 0
			USE codedir + 'hospcode'
		ENDI
		IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
			?? CHR(7)
			WAIT WIND NOWA 'ต้องแก้ไขโครงสร้างแฟ้มรหัสสถานพยาบาลก่อน'
			ch_help = 2
			RETU
		ENDI
		SELE hospcode
		SET ORDER TO TAG code
		SELE iptrana
		WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
		n = 1
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SCAN FOR ! EMPTY(place)
			@ 2,10 SAY n
			= SEEK(place, 'hospcode')
			REPL iptrana.place WITH hospcode.off_id
			n = n + 1
		ENDS
		DO IptranaCorrect
	ENDI
ENDI
RELE WIND trycorrect
CLOSE DATA
KEYB '!'

PROC CHECKRFO
**************************************************************
*  แก้ไขรหัสสถานพยาบาลในแฟ้ม REFER ผู้ป่วยนอก                *
**************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY 'แก้ไขตั้งแต่ปี  ' GET startmonth DEFA SPACE(2)
@ 2,2 SAY '      ถึงปี     ' GET endmonth DEFA SPACE(2)
@ 3,7 SAY 'ถูกต้องหรือไม่  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Yํั' .AND. LASTKEY() # 27
	IF ! USED('hospcode')
		SELE 0
		USE codedir + 'hospcode'
	ENDI
	IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
		?? CHR(7)
		WAIT WIND NOWA 'ต้องแก้ไขโครงสร้างแฟ้มรหัสสถานพยาบาลก่อน'
		ch_help = 2
		RETU
	ENDI
	SELE hospcode
	SET ORDER TO TAG code
	SELE 0
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = opddir + 'refer' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) ALIA source
			IF (LEN(place)) > 5
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN
					@ 2,10 SAY n
					= SEEK(place, 'hospcode')
					REPL source.place WITH hospcode.off_id
					SELE source
					n = n + 1
				ENDS
				DO ReferCorrect
			ENDI
		ENDI
		startmonth = STRZERO(VAL(startmonth)+1, 2 )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ยกเลิกการทำงานตามต้องการ  '
ENDI
CLOSE DATA
RELE WIND trycorrect
KEYB '!'

PROC CHECKCAME
******************************************************************
*  ตรวจสอบแฟ้ม came ว่าเป็นแบบเก่าหรือใหม่                       *
******************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY 'แก้ไขตั้งแต่เดือน/ปี  ' GET startmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(startmonth)
@ 2,2 SAY '      ถึงเดือน/ปี     ' GET endmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(endmonth)
@ 3,7 SAY 'ถูกต้องหรือไม่  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Yํั' .AND. LASTKEY() # 27
	startmonth = RIGHT(startmonth,2) + LEFT(startmonth,2)
	endmonth = RIGHT(endmonth,2) + LEFT(endmonth,2)
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = opddir + 'came' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse)
			newcamefile = .F.
			FOR i = 1 TO FCOUNT()
				IF UPPE(FIELD(i)) = 'DXTYPE'
					newcamefile = .T.
				ENDI
			NEXT
			IF ! newcamefile
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
				USE (dbfuse) ORDER 1
				div_num=ROUND((RECCOUNT()/40)+.5,0)
				recno = 0
				DO ShowProgress
				prehn = 'zzzzzzz'
				firstop = .T.
				SCAN
					firstop = IIF(hn + DTOS(date) + clinic # prehn, .T., firstop)
					recno=recno+1
					@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
					IF LEFT(diag,1) = '*' OR ISDIGIT(diag)
						IF firstop
							REPL dxtype WITH '1'
							firstop = .F.
						ELSE
							REPL dxtype WITH '2'
						ENDI
					ELSE
						REPL dxtype WITH IIF(sequence = 1, '1', '2')
					ENDI
					prehn = hn + DTOS(date) + clinic
				ENDS
				RELE WIND progress
			ENDI
		ENDI
		startmonth = IIF(RIGHT(startmonth, 2 ) = '12', ;
		STRZERO(VAL(LEFT(startmonth, 2))+1, 2 ) + '01', ;
		LEFT(startmonth, 2) + STRZERO(VAL(RIGHT(startmonth, 2)) + 1, 2) )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ยกเลิกการทำงานตามต้องการ  '
ENDI
CLOSE DATA
RELE WIND trycorrect
KEYB '!'

PROC CHECKRFI
***************************************************************
*  แก้ไขรหัสสถานพยาบาลในแฟ้ม REFER ผู้ป่วยใน                  *
***************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY 'แก้ไขตั้งแต่ปี  ' GET startmonth DEFA SPACE(2)
@ 2,2 SAY '      ถึงปี     ' GET endmonth DEFA SPACE(2)
@ 3,7 SAY 'ถูกต้องหรือไม่  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Yํั' .AND. LASTKEY() # 27
	IF ! USED('hospcode')
		SELE 0
		USE codedir + 'hospcode'
	ENDI
	IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
		?? CHR(7)
		WAIT WIND NOWA 'ต้องแก้ไขโครงสร้างแฟ้มรหัสสถานพยาบาลก่อน'
		ch_help = 2
		RETU
	ENDI
	SELE hospcode
	SET ORDER TO TAG code
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	SELE 0
	DO WHIL startmonth <= endmonth
		dbfuse = ipddir + 'data\refer' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) ALIA source EXCL
			IF (LEN(place)) > 5
				WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN
					@ 2,10 SAY n
					= SEEK(place, 'hospcode')
					REPL source.place WITH hospcode.off_id
					n = n + 1
				ENDS
				DO ReferipdCorrect
			ENDI
		ENDI
		startmonth = STRZERO(VAL(startmonth)+1, 2 )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ยกเลิกการทำงานตามต้องการ  '
ENDI
CLOSE DATA
RELE WIND trycorrect
KEYB '!'

PROC CHECKADM
***************************************************************
*  ตรวจสอบแฟ้ม ipd adm ว่าเป็นแบบเก่าหรือไม่                 *
***************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY 'แก้ไขตั้งแต่ปี  ' GET startmonth DEFA SPACE(2)
@ 2,2 SAY '      ถึงปี     ' GET endmonth DEFA SPACE(2)
@ 3,7 SAY 'ถูกต้องหรือไม่  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Yํั' .AND. LASTKEY() # 27
	IF ! USED('hospcode')
		SELE 0
		USE codedir + 'hospcode'
	ENDI
	IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
		?? CHR(7)
		WAIT WIND NOWA 'ต้องแก้ไขโครงสร้างแฟ้มรหัสสถานพยาบาลก่อน'
		ch_help = 2
		RETU
	ENDI
	SELE hospcode
	SET ORDER TO TAG code
	SELE 0
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = ipddir + 'data\adm' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			IF LEN(place) > 5
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN FOR ! EMPTY(place)
					@ 2,10 SAY n
					= SEEK(place, 'hospcode')
					REPL in.place WITH hospcode.off_id
					n = n + 1
				ENDS
				COPY TO temp STRU EXTE
				USE temp
				LOCA FOR field_name = 'PLACE'
				REPL field_len WITH 5
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
			ENDI
		ENDI

		dbfuse = ipddir + 'data\death' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) EXCL
			newcamefile = .F.
			IF LEN(hospcare) > 5
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN
					@ 2,10 SAY n
					= SEEK(hospcare, 'hospcode')
					REPL hospcare WITH hospcode.off_id
					n = n + 1
				ENDS
				COPY TO temp STRU EXTE
				USE temp
				LOCA FOR field_name = 'HOSPCARE'
				REPL field_len WITH 5
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
			ENDI
		ENDI
		startmonth = STRZERO(VAL(startmonth)+1, 2 )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ยกเลิกการทำงานตามต้องการ  '
ENDI
RELE WIND trycorrect
CLOSE DATA
RELE WIND trycorrect
KEYB '!'

PROC CHECKIPDFILE
***************************************************************
*  ตรวจสอบแฟ้ม ipd in ว่าเป็นแบบเก่าหรือไม่                 *
***************************************************************

DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
IF ! USED('hospcode')
	SELE 0
	USE codedir + 'hospcode'
ENDI
IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
	?? CHR(7)
	WAIT WIND NOWA 'ต้องแก้ไขโครงสร้างแฟ้มรหัสสถานพยาบาลก่อน'
	ch_help = 2
	RETU
ENDI
SELE hospcode
SET ORDER TO TAG code
ACTI WIND ask
@ 1,2 SAY 'แก้ไขตั้งแต่เดือน/ปี  ' GET startmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(startmonth)
@ 2,2 SAY '      ถึงเดือน/ปี     ' GET endmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(endmonth)
@ 3,7 SAY 'ถูกต้องหรือไม่  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Yํั' .AND. LASTKEY() # 27
	startmonth = RIGHT(startmonth,2) + LEFT(startmonth,2)
	endmonth = RIGHT(endmonth,2) + LEFT(endmonth,2)
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	SELE 0
	DO WHIL startmonth <= endmonth
		IF ! USED('hospcode')
			USE (codedir + 'hospcode') ORDER 1 IN 0
		ENDI
		SELE 0
		dbfuse = ipddir + 'data\in' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			IF LEN(place) > 5
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN FOR ! EMPTY(place)
					@ 2,10 SAY n
					= SEEK(place, 'hospcode')
					REPL place WITH hospcode.off_id
					n = n + 1
				ENDS
				COPY TO temp STRU EXTE
				USE temp
				LOCA FOR field_name = 'PLACE'
				REPL field_len WITH 5
				LOCA FOR field_name = 'TIMEADM'
				IF EOF()
					APPE BLANK
					REPL field_name WITH 'TIMEADM', field_type WITH 'C', field_len WITH 4
				ENDI
				LOCA FOR field_name = 'TIMEDSC'
				IF EOF()
					APPE BLANK
					REPL field_name WITH 'TIMEDSC', field_type WITH 'C', field_len WITH 4
				ENDI
				LOCA FOR field_name = 'DEP'
				IF EOF()
					APPE BLANK
					REPL field_name WITH 'DEP', field_type WITH 'C', field_len WITH 4
				ENDI
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				predbf = dbfuse
				DO Reindex WITH .F.
				dbfuse = predbf

				USE (dbfuse) ALIA nowadm
				= OPENDBF(ipddir + '\data\adm' + LEFT(startmonth,2),'adm', 'an')
				SELE nowadm
				SET RELA TO
				SET RELA TO an INTO adm
				SCAN
					? SPACE(5), an
					REPL timeadm WITH adm.timeadm, timedsc WITH adm.timedsc, ;
					dep WITH adm.dep
				ENDS
				SELE adm
				USE
				SELE nowadm
				USE
			ENDI
		ENDI
***************************************************************
*  ตรวจสอบแฟ้ม ipd diag ว่าเป็นแบบเก่าหรือไม่                 *
***************************************************************
		dbfuse = ipddir + 'data\diag' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) EXCL
			newcamefile = .F.
			FOR i = 1 TO FCOUNT()
				IF UPPE(FIELD(i)) = 'DXTYPE'
					newcamefile = .T.
				ENDI
			NEXT
			IF ! newcamefile
				COPY TO temp STRU EXTE
				USE temp
				APPE BLANK
				REPL FIELD_NAME WITH 'DXTYPE', field_type WITH 'C', ;
				field_len WITH 1
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
				GO TOP
				prean = 'zzzzz'
				DO WHIL ! EOF()
					? SPACE(5), an
					REPL dxtype WITH IIF(an = prean, '2', '1')
					prean = an
				SKIP
				ENDD
				USE
			ENDI
		ENDI

***************************************************************
*  ตรวจสอบแฟ้ม ipd oper ว่าเป็นแบบเก่าหรือไม่                 *
***************************************************************

		dbfuse = ipddir + 'data\oper' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) EXCL
			IF FCOUNT() < 6
				COPY TO temp STRU EXTE
				USE temp
				APPE BLANK
				REPL FIELD_NAME WITH 'TIMEIN', field_type WITH 'C', ;
				field_len WITH 4
				APPE BLANK
				REPL FIELD_NAME WITH 'DATEOUT', field_type WITH 'D'
				APPE BLANK
				REPL FIELD_NAME WITH 'TIMEOUT', field_type WITH 'C', ;
				field_len WITH 4
				APPE BLANK
				REPL FIELD_NAME WITH 'OPTYPE', field_type WITH 'C', ;
				field_len WITH 1
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
				GO TOP
				prean = 'zzzzz'
				DO WHIL ! EOF()
					? SPACE(5), an
					REPL optype WITH IIF(an = prean, '2', '1')
					prean = an
					SKIP
				ENDD
				USE
			ENDI
		ENDI
		startmonth = IIF(RIGHT(startmonth, 2 ) = '12', ;
		STRZERO(VAL(LEFT(startmonth, 2))+1, 2 ) + '01', ;
		LEFT(startmonth, 2) + STRZERO(VAL(RIGHT(startmonth, 2)) + 1, 2) )
		CLOSE DATA
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ยกเลิกการทำงานตามต้องการ  '
ENDI
CLOSE DATA
RELE WIND Trycorrect
KEYB '!'

PROC Patient1Correct
*****************************************************************
*  โปรแกรมแก้ไขแฟ้ม patient1 ให้เก็บเลขที่บัตรประชาชน           *
*****************************************************************

		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		APPE BLAN
		REPL field_name WITH 'PERSON_ID', field_type WITH 'C', field_len WITH 13
		USE
		CREAT (patientdir + 'temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = patientdir + 'temp1.dbf'
		targetfile = patientdir + 'patient1.dbf'
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		INDEX ON hn TAG hn
		INDEX ON name TAG name ADDI
		INDEX ON SUBS(name,AT(' ',name)+1,4) TAG last ADDI
		INDEX ON LEFT(name,4)+SUBS(name,AT(' ',name)+1,4) TAG namelast ADDI
		INDEX ON clinic TAG clinic ADDI
		INDEX ON lastdate TAG lastdate ADDI
		INDEX ON person_id TAG person_id ADDI
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC InsureCorrect
****************************************************************
*  โปรแกรมแก้ไขแฟ้ม insure ให้ใช้รหัสสถานบริการแบบใหม่         *
*  และแก้ไขข้อมูลให้ถูกต้อง                                    *
****************************************************************

		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'HOSPMAIN'
		REPL field_len WITH 5
		LOCA FOR field_name = 'HOSPSUB'
		REPL field_len WITH 5
		USE
		CREAT (patientdir + 'temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = patientdir + 'temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC IptranaCorrect
****************************************************************
*  โปรแกรมแก้ไขแฟ้ม iptrana ให้ใช้รหัสสถานบริการแบบใหม่        *
*  และแก้ไขข้อมูลให้ถูกต้อง                                    *
****************************************************************

		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'PLACE'
		REPL field_len WITH 5
		USE
		CREAT (ipddir + 'data\temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = ipddir + 'data\temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC ReferCorrect
****************************************************************
*  โปรแกรมแก้ไขแฟ้ม refer ให้ใช้รหัสสถานบริการแบบใหม่          *
*  และแก้ไขข้อมูลให้ถูกต้อง                                    *
****************************************************************
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'PLACE'
		REPL field_len WITH 5
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
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC ReferIpdCorrect
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'PLACE'
		REPL field_len WITH 5
		USE
		CREAT (ipddir + 'data\temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = ipddir + 'data\temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC SocialCorrect
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		APPE BLAN
		REPL field_name WITH 'pttyp', field_type WITH 'C', field_len WITH 2
		USE
		CREAT (patientdir + 'temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = patientdir + 'temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

FUNC TrueMonth
PARA _month
IF ! BETWEEN(_month, '0100', '1299')
	?? CHR(7)
	WAIT WIND NOWA IIF( ! BETWEEN(LEFT(_month,2),'01', '12'), ;
	'  ใส่เดือนไม่ถูกต้อง  ', '  ใส่ปีไม่ถูกต้อง  ')
	RETU 0
ENDI

********************************************************************************
*  โมดูลสำหรับขึ้นเมนูแก้ไขโครงสร้างแฟ้มข้อมูลเป็น Version 2.95                *
********************************************************************************
PROC CheckStru295

PRIVATE Colspace,PreScr,Ch_help
#define numstru2 5
@ 3,0 CLEA TO 20,80
DIME s2help(numstru2),s2helpmess(numstru2)
s2help(1)='1. แฟ้มรายชื่อแพทย์'
s2help(2)='2. แฟ้มผู้ป่วยใน'
s2help(3)='3. แฟ้มผู้ป่วยนอก'
s2help(4)='4. แฟ้มรับผู้ป่วยในประจำปี'
s2help(numstru2)='0. กลับรายการเดิม'

s2helpmess(1) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มรายชื่อแพทย์ (Doctor)'
s2helpmess(2) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มผู้ป่วยใน (INyymm)'
s2helpmess(3) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มผู้ป่วยนอก (CAMEyymm)'
s2helpmess(4) = 'ตรวจสอบและแก้ไขโครงสร้างแฟ้มรับผู้ป่วยในประจำปี (ADMyy)'
s2helpmess(numstru2)='กลับไปสู่รายการหลัก'

DEFINE WIND ChkStru295_menu FROM 4,25 TO 4+ALEN(s2help)+3,52 SHAD COLO gr+/BG TITLE ' เลือกแฟ้มที่ต้องการ '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	= ENGMODE()
	DO Title WITH 'แก้ไขโครงสร้างแฟ้มเป็น Version 2.95'
	ACTI WIND ChkStru295_menu
	CLEAR
	FOR i=1 TO ALEN(s2help)
		@ i,3 PROMPT s2help(i) MESS s2helpmess(i)
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
			DO CheckDOCTOR
		CASE Ch_help = 2
			DO CheckINyymm
		CASE Ch_help = 3
			DO CheckCAMEyymm
		CASE Ch_help = 4
			DO CheckADMyy
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND ChkStru295_menu
CLOSE DATA

***************************************************************
*  แก้ไขแฟ้ม Doctor                                           *
***************************************************************
PROC CheckDOCTOR
	dbfuse = patientdir+'doctor.dbf'
	IF ! FILE(dbfuse)
		?? CHR(7)
		WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
	ELSE
		WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
		USE (dbfuse) ALIA in EXCL
		newcamefile = .F.
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'STATUS'
		IF ! EOF()
			WAIT WIND NOWA ' โครงสร้างแฟ้ม Doctor ถูกต้องแล้ว '
		ELSE
			APPE BLANK
			REPL field_name WITH 'STATUS', field_type WITH 'L'
			USE
			CREAT (patientdir + 'temp1') FROM temp
			DELE FILE temp.dbf
			APPE FROM (dbfuse)
			DELE FILE (dbfuse)
			USE
			sourcefile = patientdir + 'temp1.dbf'
			targetfile = dbfuse
			RENAME &sourcefile TO &targetfile
			USE (dbfuse) EXCL
			REPL ALL status WITH .T.
			DO Reindex WITH .F.
			WAIT WIND NOWA ' แก้ไขโครงสร้างแฟ้มรายชื่อแพทย์ (Doctor) เสร็จเรียบร้อยแล้ว '
			USE
		ENDI
	ENDI

PROC CHECKINyymm
***************************************************************
*  แก้ไขแฟ้ม INyymm ให้เป็นแบบ Version 2.95                   *
***************************************************************

DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY 'แก้ไขตั้งแต่เดือน/ปี  ' GET startmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(startmonth)
@ 2,2 SAY '      ถึงเดือน/ปี     ' GET endmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(endmonth)
@ 3,7 SAY 'ถูกต้องหรือไม่  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Yํั' .AND. LASTKEY() # 27
	startmonth = RIGHT(startmonth,2) + LEFT(startmonth,2)
	endmonth = RIGHT(endmonth,2) + LEFT(endmonth,2)
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = ipddir + 'data\in' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			COPY TO temp STRU EXTE
			USE temp
			LOCA FOR field_name = 'ADM_W'
			IF ! EOF()
				IF field_type ='C'
					REPL field_type WITH 'N', field_len WITH 7, field_dec WITH 3 FOR field_name = 'ADM_W'
					USE
					CREAT (ipddir + 'data\temp1') FROM temp
					DELE FILE temp.dbf
					APPE FROM (dbfuse)
					DELE FILE (dbfuse)
					USE
					sourcefile = ipddir + 'data\temp1.dbf'
					targetfile = dbfuse
					RENAME &sourcefile TO &targetfile
					USE (dbfuse) EXCL
					predbf = dbfuse
					DO Reindex WITH .F.
					WAIT WIND NOWA ' แก้ไขโครงสร้างแฟ้มผู้ป่วยใน INyymm เสร็จเรียบร้อยแล้ว :) '
					USE
				ELSE
					WAIT WIND NOWA ' โครงสร้างแฟ้ม ' + dbfuse + ' ถูกต้องแล้ว '
				ENDI
			ELSE
				APPE BLANK
				REPL field_name WITH 'ADM_W', field_type WITH 'N', field_len WITH 7, field_dec WITH 3
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				predbf = dbfuse
				DO Reindex WITH .F.
				WAIT WIND NOWA ' แก้ไขโครงสร้างแฟ้มผู้ป่วยใน INyymm เสร็จเรียบร้อยแล้ว '
				USE
			ENDI
		ENDI
		startmonth = IIF(RIGHT(startmonth, 2 ) = '12', ;
		STRZERO(VAL(LEFT(startmonth, 2))+1, 2 ) + '01', ;
		LEFT(startmonth, 2) + STRZERO(VAL(RIGHT(startmonth, 2)) + 1, 2) )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ยกเลิกการทำงานตามต้องการ  '
ENDI
CLOSE DATA

PROC CheckADMyy
***************************************************************
*  แก้ไขแฟ้ม ADMyy ให้เป็นแบบ Version 2.95                    *
***************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY 'แก้ไขตั้งแต่ปี  ' GET startmonth DEFA SPACE(2)
@ 2,2 SAY '      ถึงปี     ' GET endmonth DEFA SPACE(2)
@ 3,7 SAY 'ถูกต้องหรือไม่  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Yํั' .AND. LASTKEY() # 27
	SELE 0
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = ipddir + 'data\adm' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			COPY TO temp STRU EXTE
			USE temp
			LOCA FOR field_name = 'ADM_W'
			IF ! EOF()
				IF field_type ='C'
					REPL field_type WITH 'N', field_len WITH 7, field_dec WITH 3 FOR field_name = 'ADM_W'
					USE
					CREAT (ipddir + 'data\temp1') FROM temp
					DELE FILE temp.dbf
					APPE FROM (dbfuse)
					DELE FILE (dbfuse)
					USE
					sourcefile = ipddir + 'data\temp1.dbf'
					targetfile = dbfuse
					RENAME &sourcefile TO &targetfile
					USE (dbfuse) EXCL
					DO Reindex WITH .F.
					WAIT WIND NOWA ' แก้ไขโครงสร้างแฟ้มรับผู้ป่วยในประจำปี ADMyy เสร็จเรียบร้อยแล้ว :) '
					USE
				ELSE
					WAIT WIND NOWA ' โครงสร้างแฟ้ม ' + dbfuse + ' ถูกต้องแล้ว '
				ENDI
			ELSE
				APPE BLANK
				REPL field_name WITH 'ADM_W', field_type WITH 'N', field_len WITH 7, field_dec WITH 3
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
				WAIT WIND NOWA ' แก้ไขโครงสร้างแฟ้มรับผู้ป่วยในประจำปี ADMyy เสร็จเรียบร้อยแล้ว =:)'
				USE
			ENDI
		ENDI
	startmonth = STRZERO(VAL(startmonth)+1, 2 )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ยกเลิกการทำงานตามต้องการ  '
ENDI

PROC CheckCAMEyymm
***************************************************************
*  แก้ไขแฟ้ม CAMEyymm ให้เป็นแบบ Version 2.95                 *
***************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY 'แก้ไขตั้งแต่เดือน/ปี  ' GET startmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(startmonth)
@ 2,2 SAY '      ถึงเดือน/ปี     ' GET endmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(endmonth)
@ 3,7 SAY 'ถูกต้องหรือไม่  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Yํั' .AND. LASTKEY() # 27
	startmonth = RIGHT(startmonth,2) + LEFT(startmonth,2)
	endmonth = RIGHT(endmonth,2) + LEFT(endmonth,2)
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = opddir + 'CAME' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ไม่พบแฟ้ม ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! โปรดคอย กำลังแก้ไขแฟ้ม ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			COPY TO temp STRU EXTE
			USE temp
			LOCA FOR field_name = 'ADMWT'
			IF ! EOF()
				WAIT WIND NOWA ' โครงสร้างแฟ้ม ' + dbfuse + ' ถูกต้องแล้ว '
			ELSE
				APPE BLANK
				REPL field_name WITH 'ADMWT', field_type WITH 'N', field_len WITH 7, field_dec WITH 3
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
				predbf = dbfuse
				DO Reindex WITH .F.
				WAIT WIND NOWA ' แก้ไขโครงสร้างแฟ้มผู้ป่วยใน CAMEyymm เสร็จเรียบร้อยแล้ว '
				USE
			ENDI
		ENDI
		startmonth = IIF(RIGHT(startmonth, 2 ) = '12', ;
		STRZERO(VAL(LEFT(startmonth, 2))+1, 2 ) + '01', ;
		LEFT(startmonth, 2) + STRZERO(VAL(RIGHT(startmonth, 2)) + 1, 2) )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ยกเลิกการทำงานตามต้องการ  '
ENDI
CLOSE DATA
