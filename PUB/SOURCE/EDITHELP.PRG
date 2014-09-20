********************************************************************************
*  โมดูลสำหรับขึ้นเมนูให้เลือกว่าจะแก้ไขหรือเพิ่มเติม                          *
*  แฟ้มข้อมูลความช่วยเหลืออะไรบ้าง และแก้ไขระบบ                                *
********************************************************************************

PRIVATE Colspace,PreScr,Cando,fromdos
#define numutil 12
@ 3,0 CLEA TO 20,80
fromdos = .T.
IF EMPTY(UserRight)
	Userright = GetUser()
ELSE
	fromdos = .F.
ENDI
IF ! UserRight == 'SUP       '
	=Alarm1()
	WAIT WIND NOWA 'คุณไม่มีสิทธิในการทำรายการนี้'
	UserRight = IIF(fromdos,'  ',UserRight)
	RETU
ENDI
UserRight = IIF(fromdos,'  ',UserRight)
DIME chelp(numutil),EHelpMess(numutil)
chelp(1)='1. แก้ไขแฟ้มคลีนิค'
chelp(2)='2. แก้ไขแฟ้มหอผู้ป่วย'
chelp(3)='3. แก้ไขชื่อแพทย์'
chelp(4)='4. ทำลายบัตร'
chelp[5]='5. เลือกจอภาพ'
chelp[6]='6. เลือกแบบ OPD Card'
chelp[7]='7. ชื่อย่อโรค'
chelp[8]='8. รหัสจังหวัด อำเภอ ตำบล'
chelp[9]='9. ซ่อมแฟ้มดัชนี'
chelp[10]='A. รหัสสถานพยาบาล'
chelp[11]='B. ข้อมูล สปร.'
chelp(numutil)='0. กลับรายการเดิม'

EHelpMess(1)='แก้ไขข้อมูลคลีนิคต่าง ๆ'
EHelpMess(2)='แก้ไขข้อมูลหอผู้ป่วยต่าง ๆ'
EHelpMess(3)='แก้ไขข้อมูลรายชื่อแพทย์'
EHelpMess[4]='ทำลายบัตรเมื่อครบกำหนด'
EHelpMess[5]='เลือกชนิดของจอภาพ'
EHelpMess[6]='เลือกว่าจะพิมพ์บัตรผู้ป่วยนอกตามแบบของโรงพยาบาลไหน'
EHelpMess[7]='ใส่รหัสและแก้ไขชื่อย่อโรคและการผ่าตัด'
EhelpMess[8]='เพิ่มเติมและแก้ไขรหัสจังหวัด อำเภอ ตำบล'
EhelpMess[9]='ซ่อมแซมแฟ้มดัชนีที่เสียไปให้คืนดี โปรดระวัง!'
EhelpMess[10]='แก้ไขชื่อและเพิ่มเติมรหัสสถานพยาบาล'
EhelpMess[11]='ดึงข้อมูลจากโปรแกรมบัตร สปร. (HIP)'
EHelpMess[numutil]='กลับไปสู่รายการหลัก'

DEFINE WIND help_menu FROM 4,5 TO 4+ALEN(chelp)+3,40 SHAD COLO gr+/BG TITLE '  แก้ไขค่าต่าง ๆ  '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	CLOSE DATA
	= ENGMODE()
	DO Title WITH 'รายการแก้ไขค่าต่าง ๆ'
	ACTI WIND help_menu
	FOR i=1 TO ALEN(chelp)
		@ i,3 PROMPT chelp(i) MESS EhelpMess[i]
	NEXT
	dbfuse = codedir+'clinic'
	USE (codedir+'clinic') IN 0
	dbfuse = codedir+'ward'
	USE (codedir+'ward') IN 0
	dbfuse = codedir+'doctor'
	USE (codedir+'doctor') IN 0
	dbfuse = ''
	errorhelp = .F.
	IF RECCOUNT('WARD')<14 .OR. RECCOUNT('CLINIC')<16 .OR. ;
	RECCOUNT('DOCTOR') = 0
		Ch_help = IIF( RECCOUNT('DOCTOR') = 0, 3, Ch_help)
		Ch_help = IIF( RECCOUNT('WARD')<14, 2, Ch_help)
		Ch_help = IIF( RECCOUNT('CLINIC')<16, 1, Ch_help)
		errorhelp = .T.
	ENDI
	CLOSE DATA
	toedithelp = errorhelp
	fix_ch = Ch_help
	MENU TO Ch_help
	ACTI SCREE
	IF errorhelp .AND. ch_help # fix_ch
		?? CHR(7)
		DO CASE
			CASE fix_ch = 1
				fixsay = 'ต้องเพิ่มรหัส คลีนิค '
			CASE fix_ch = 2
				fixsay = 'ต้องเพิ่มรหัส หอผู้ป่วย '
			CASE fix_ch = 3
				fixsay = 'ต้องเพิ่มรหัส แพทย์ '
			CASE fix_ch = 6
				fixsay = 'ต้องเลือกแบบ OPD Card ที่จะใช้'
		ENDC
		WAIT WIND NOWA fixsay +'ก่อน'
	ELSE
		DO CASE
			CASE Ch_help = 1
				DO HelpEdit WITH 'clinic'
			CASE Ch_help = 2
				DO HelpEdit WITH 'ward'
			CASE Ch_help = 3
				DO HelpEdit WITH 'doctor'
			CASE Ch_help = 4
				DO Expirec
			CASE Ch_help = 5
				DO SeleMoni
			CASE Ch_help = 6
				DO SeleCard
			CASE Ch_help = 7
				DO ShortICD
			CASE Ch_Help = 8
				DO editaddr
			CASE Ch_help = 9
				DO Reindex
			CASE Ch_help = 10
				?? CHR(7)
				WAIT WIND NOWA 'ยังไม่อนุญาตให้ทำรายการนี้ รอการตกลงอีกหน่อย  '
*				DO Add_Srv
			CASE Ch_help = 11
				DO HipIMPO
			OTHER
				EXIT
		ENDC
	ENDI
ENDD
RELE WIND help_menu
CLOSE DATA

PROC SELECARD
SELE 0
IF ! FILE('prinform.dbf')
	dbfuse = patientdir+'prinform'
	USE (patientdir+'prinform')
ELSE
	dbfuse = 'prinform'
	USE prinform
ENDI
dbfuse = ''
DEFINE POPUP prinform FROM 10,20 TO 15,60 MARGIN SHADOW COLOR ;
SCHEME 4 PROMPT FIELD type MARK CHR(4)
ON SELE POPUP prinform DO makeprintopd
ACTI POPUP prinform

PROC MAKEPRINTOPD
COPY MEMO source TO printopd.prg
COPY MEMO compiled TO printopd.fxp
DEAC POPUP prinform
USE
CLEA PROG

PROC SHORTICD
IF ! USED('shorticd')
	IF ! FILE(patientdir+'shorticd.dbf')
		=TONE(1200,5)
		=TONE(700,5)
		WAIT WIND NOWA 'ยังไม่มีการใส่ชื่อโรคย่อ/ผ่าตัด'
		RETU
	ELSE
		dbfuse = patientdir+'shorticd'
		USE (patientdir+'shorticd') ORDER 1 IN 0
	ENDI
	dbfuse = ''
ENDI
DEFINE WIND shorticd FROM 13,30 TO 20,70 SHAD 
ACTI WIND shorticd
numshort = 3
DIME shortmenu[numshort],shortmess[numshort]
shortmenu[1] = '1. ใส่รหัส'
shortmenu[2] = '2. แก้ไขชื่อและรหัส'
shortmenu[numshort] = '0. กลับรายการก่อนหน้านี้'
shortmess[1] = 'ใส่รหัสของชื่อโรคย่อ/ชื่อผ่าตัดย่อ'
shortmess[2] = 'แก้ไขรหัสและชื่อโรคย่อที่เคยใส่ไปแล้ว'
shortmess[numshort] = ''
FOR i = 1 TO numshort 
	@ i,2 PROMPT shortmenu[i] MESS shortmess[i]
NEXT
MENU TO shortchoice
RELE WIND shorticd
DO CASE
	CASE shortchoice = 1
		DO InputShort
	CASE shortchoice = 2
		SELE shorticd
		ON KEY LABEL CTRL+N APPE BLAN
		ON KEY LABEL CTRL+F DO findabnormal
		DEFINE WIND browicd FROM 3,2 TO 20,77 SHAD PANEL ;
		TITLE '  ดูและแก้ไขรหัส/ชื่อย่อ  ' FOOT 'กด [Esc] เมื่อเสร็จ'
		ACTI SCREE
		@ 23,0 SAY ;
' CTRL+N = เพิ่มรหัส    CTRL+F = ค้นหาคลีนิคที่ตั้งรหัสนี้  CTRL+W = เสร็จงาน'
		BROW FIELD code :h='รหัส ICD',desc :h='ชื่อโรค/การผ่าตัด' WIND browicd 
		RELE WIND browicd
		ACTI SCREE
		@ 23,0
ENDC
ON KEY LABEL CTRL+N
ON KEY LABEL CTRL+F

PROC FINDABNORMAL
DEFINE WIND findab FROM 21,2 TO 24,77 SHAD
openfile = opddir+'came'+date
ACTI WIND findab
IF FILE(openfile+'.dbf')
	SELE 0
	dbfuse = openfile
	USE (openfile) ALIA open1
	WAIT WIND NOWA 'โปรดคอย ! กำลังค้นหารหัส '+shorticd.code+' ในแฟ้ม '+openfile
	LOCA FOR diag = shorticd.code
	dbfuse = ''
	=ALARM1()
	IF ! EOF()
		IF ! USED('clinic')
			dbfuse = codedir+'clinic'
			USE (codedir+'clinic') ORDER 1 IN 0
			useaddr = .F.
		ELSE
			useaddr = .T.
		ENDI
		SELE clinic
		dbfuse = ''
		SEEK open1.clinic
		@ 0,3 SAY 'พบรหัส '+shorticd.code+' ในคลีนิค'+name
		= INKEY(0)
		IF ! useaddr
			SELE clinic
			USE
		ENDI
		SELE open1
		USE
	ELSE
		DO Deleteab
		SELE open1
		USE
	ENDI
ELSE
	DO Deleteab
ENDI
RELE WIND findab


PROC DELETEAB
@ 0,2 SAY 'ไม่พบว่ามีการใส่รหัส '+shorticd.code
@ 1,2 SAY 'ต้องการลบรหัสนี้หรือไม่  ' GET confirmdel DEFA 'Y' PICT '!'
READ NOLOCK
IF confirmdel $ 'Yัํ'
	SELE shorticd
	SCAT MEMV BLAN
	GATHER MEMV
	FLUSH
ENDI

PROC INPUTSHORT
SELE shorticd
SET ORDER TO TAG code
GO TOP
goon = SEEK('#')
IF goon
	DEFINE WIND browicd FROM 3,2 TO 20,77 SHAD PANEL ;
	TITLE '  ใส่รหัส ICD ให้กับชื่อย่อ  ' FOOT 'กด [Esc] เมื่อเสร็จ'
	ACTI WIND browicd
	DIME newcode[100], oldcode[100], foropd[100], foripd[100], ;
	finddate[12], findtype[12]
	numchange = 0
	datestart = '9999'
	numfind = 0
	IF SEEK('#')
		DO WHIL goon .AND. LEFT(code,1) = '#' .AND. numchange <100
			m.correct = 'Y'
			SKIP
			nextrec = IIF(EOF(), 1, RECNO())
			SKIP -1
			CLEA
			SCAT MEMV
			@ 2,5 SAY 'ชื่อโรคย่อ ' +m.desc
			@ 3,5 SAY 'รหัส ICD ' GET m.code PICT '@!'
			@ 5,10 SAY 'ยืนยันว่าถูกต้อง ' GET m.correct PICT '!'
			READ NOLOCK
			IF LASTKEY() = 27
				goon = .F.
			ELSE
				IF m.correct $ 'Yัํ'
					numchange = numchange + 1
					oldcode[numchange] = code
					newcode[numchange] = m.code
					m.pos = ASCAN(finddate,m.date)
					IF m.pos = 0 
						numfind = numfind+1
						finddate[numfind] = m.date
						findtype[numfind] = m.type
					ELSE
						findtype[m.pos] = IIF( findtype[m.pos]='2', '2', ;
						IIF( findtype[m.pos]=m.type, m.type, '2') )
					ENDI
**					datestart = MIN(datestart,m.date)
**					foropd = type > '1'
**					foripd = type < '3'
					GATH MEMV
					FLUSH
				ENDI
			ENDI
			GO nextrec
		ENDD
	ENDI
	SELE shorticd
	USE
	IF numfind > 0
		CLEA
		msg = 'โปรดคอย ! กำลังเปลี่ยนรหัสให้ถูกต้อง'
		@ 5,Center(msg) SAY msg
		FOR i = 1 TO numfind
			datestart = finddate[i]
			IF findtype[i] < '3'
				usefile = opddir+'came'+datestart
				USE	(usefile)
				msg = 'กำลังแก้ไขแฟ้ม '+usefile
				@ 7,0
				@ 7,Center(msg) SAY msg
				SCAN
					IF LEFT(diag,1) = '#'
						mpos = ASCAN(oldcode,diag)
						IF mpos > 0
							REPL diag WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
				ENDS
			ENDI
			IF findtype[i] > '1'
				usefile = ipddir+'data\diag'+datestart
				USE	(usefile)
				msg = 'กำลังแก้ไขแฟ้ม '+usefile
				@ 7,0
				@ 7,Center(msg) SAY msg
				SCAN
					IF LEFT(diag,1) = '#'
						mpos = ASCAN(oldcode,diag)
						IF mpos > 0
							REPL diag WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
				ENDS
				usefile = ipddir+'data\oper'+datestart
				USE	(usefile)
				msg = 'กำลังแก้ไขแฟ้ม '+usefile
				@ 7,0
				@ 7,Center(msg) SAY msg
				SCAN
					IF LEFT(op,1) = '#'
						mpos = ASCAN(oldcode,op)
						IF mpos > 0
							REPL op WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
				ENDS
				usefile = ipddir+'data\death'+LEFT(datestart,2)
				USE	(usefile)
				msg = 'กำลังแก้ไขแฟ้ม '+usefile
				@ 7,0
				@ 7,Center(msg) SAY msg
				SCAN
					IF LEFT(icd10,1) = '#'
						mpos = ASCAN(oldcode,icd10)
						IF mpos > 0
							REPL icd10 WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
					IF LEFT(cause1,1) = '#'
						mpos = ASCAN(oldcode,cause1)
						IF mpos > 0
							REPL cause1 WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
					IF LEFT(cause2,1) = '#'
						mpos = ASCAN(oldcode,cause2)
						IF mpos > 0
							REPL cause2 WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
				ENDS
			ENDI
**		
**		datestart = IIF( RIGHT(datestart,2)='12', ;
**		STRZERO(VAL(LEFT(datestart,2))+1,2)+'01', ;
**		LEFT(datestart,2)+STRZERO(VAL(RIGHT(datestart,2))+1,2) )
	NEXT
	USE
	ENDI
	RELE WIND browicd
ENDI
