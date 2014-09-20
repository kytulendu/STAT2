************************************************************************
PRIV UserName,UserRight,_ret,pp,_mkey,goon,goon1
userright = GetUser()
*SELE 0
*USE (patientdir+'user') ORDER TAG name
goon1 = .T.
IF 'SUP       ' # userright
	RETU
ENDI
DEFI WIND setconfig FROM 3,1 TO 20,78 SHAD
ACTI WIND setconfig
STORE LEFT(patientdir+SPACE(30),30) TO patientdir
STORE LEFT(codedir+SPACE(30),30) TO codedir
STORE LEFT(tempdir+SPACE(30),30) TO tempdir
STORE LEFT(ipddir+SPACE(30),30) TO ipddir
STORE LEFT(opddir+SPACE(30),30) TO opddir
STORE LEFT(pharmdir+SPACE(30),30) TO pharmdir
STORE LEFT(notprintrx+SPACE(30),30) TO notprintrx
STORE LEFT(Wellbaby+SPACE(30),30) TO Wellbaby
STORE LEFT(billdir+SPACE(30),30) TO billdir
STORE LEFT(isdir+SPACE(30),30) TO isdir
STORE SPACE(30) TO configfile
backupdrive = IIF( EMPTY(backupdrive), ' ', LEFT(backupdrive,1) )

IsER = IIF(er,1,0)
IsStat = IIF(statinput,1,0)
IsBackup = IIF(UPPE(backup) == 'AUDIT',1,0)
IsAdmit = IIF(UPPE(TRIM(Admit))=='DISTRIBUTE',1,0)
isMicrowiz = IIF(UPPE(TRIM(Thaicard))=='MICROWIZ',1,0)
IsPerson = IIF(UPPE(TRIM(Person_id))=='YES',1,0)
IsPres = IIF(UPPE(TRIM(Prescription))=='YES',1,0)
Isnotque = IIF(UPPE(TRIM(notque))=='YES',1,0)

DEFINE WIND setconfig FROM 3,1 TO 20,78 SHAD
ACTI WIND setconfig
@ WROW()-1,Center('กดปุ่ม [Esc] เมื่อเสร็จแล้ว') SAY 'กดปุ่ม [Esc] เมื่อเสร็จแล้ว'
@ 1,3 SAY 'Directory ข้อมูลหลัก        ' GET patientdir MESS ;
'ใส่ชื่อ Drive และ Directory ที่แฟ้ม Patient1 อยู่'
@ 2,3 SAY 'Directory ข้อมูลผู้ป่วยนอก  ' GET opddir MESS ;
'ใส่ชื่อ Drive และ Directory ที่เก็บข้อมูลการวินิจฉัยผู้ป่วยนอก'
@ 3,3 SAY 'Directory ข้อมูลผู้ป่วยใน   ' GET ipddir MESS ;
'ใส่ชื่อ Drive และ Directory ที่เก็บข้อมูลการวินิจฉัยผู้ป่วยใน'
@ 4,3 SAY 'Directory ข้อมูลใบสั่งยา    ' GET pharmdir MESS ;
'ใส่ชื่อ Drive และ Directory ที่เก็บข้อมูลใบสั่งยาผู้ป่วยนอก'
@ 5,3 SAY 'Directory แฟ้มช่วยเหลือ     ' GET codedir MESS ;
'ใส่ชื่อ Drive และ Directory ที่ช่วยเหลือเช่น Doctor,Address อยู่'
@ 6,3 SAY 'Directory โปรแกรม BILLING   ' GET billdir MESS ;
'ใส่ชื่อ Drive และ Directory ของโปรแกรม Billing'
@ 7,3 SAY 'Directory โปรแกรม IS        ' GET isdir MESS ;
'ใส่ชื่อ Drive และ Directory ของโปรแกรม IS'
@ 8,3 SAY 'Directory ข้อมูลชั่วคราว    ' GET tempdir MESS ;
'ใส่ชื่อ Drive และ Directory ที่สำหรับเขียนข้อมูลชั่วคราวเมื่อมีการประมวลผล'
@ 9,3 SAY 'คลีนิคที่ไม่พิมพ์ใบสั่งยา   ' GET notprintrx MESS ;
'ใส่รหัสคลีนิคที่ไม่ต้องการพิมพ์ใบสั่งยาตามด้วยเครื่องหมาย , เช่น 011,024'
@ 10,3 SAY 'คลีนิคสุขภาพเด็กดี          ' GET Wellbaby MESS ;
'ใส่รหัส Well baby คลีนิคตามด้วยเครื่องหมาย , เช่น 011,024'
@ 11,3 GET Iser FUNC '*C ห้องบัตรนอกเวลา' MESS ;
'เป็นห้องบัตรนอกเวลาที่มีการเบิกแฟ้มมาไว้ก่อน'
@ 11,32 GET IsStat FUNC '*C คืนแฟ้มเมื่อลงการวินิจฉัย' MESS ;
'เมื่อมีการลงการวินิจฉัยผู้ป่วยนอก จะทำการคืนแฟ้มให้อัตโนมัติ' && WHEN Checkiser()
@ 12,3 GET Isbackup FUNC '*C มีการสำรองข้อมูล' MESS ;
'มีการบันทึกข้อมูลที่มีการแก้ไข เพื่อจะทำการสำรองข้อมูลอัตโนมัติ'
@ 12,32 GET isadmit FUNC '*C รับผู้ป่วยใน' MESS ;
'ให้ห้องตรวจผู้ป่วยนอกสามารถลงทะเบียนรับผู้ป่วยในได้'
*@ 11,3 GET Isperson FUNC '*C เลขที่บัตรประชาชน' MESS ;
*'มีการบันทึกเลขที่บัตรประชาชน 13 หลักด้วย'
@ 13,3 GET Ispres FUNC '*C พิมพ์ใบสั่งยาผู้ป่วย' MESS ;
'ให้ห้องบัตรสามารถพิมพ์ใบสั่งยาเมื่อทำการบันทึกผู้ป่วยเก่ามายื่นบัตรได้ด้วย'
@ 13,32 GET Isnotque FUNC '*C ไม่ต้องการเข้าคิวใบสั่งยาเก่า' MESS ;
'ไม่ต้องการให้ใบสั่งยาเก่า (เฉพาะใบสั่งยาผู้ป่วยเก่า) เข้าไปอยู่ในคิว'
@ 14,3 SAY 'สำรองข้อมูลทั้งหมดไว้ที่ Drive  ' GET backupdrive MESS ;
'ใส่ชื่อ Drive ที่จะใช้สำรองข้อมูลอัตโนมัติ ' PICT '!'
@ 15,3 SAY 'เก็บตัวติดตั้งไว้ในแฟ้ม     ' GET configfile MESS ;
'ใส่ชื่อ Drive\Directory\ชื่อแฟ้ม ที่จะเก็บตัวระบบ ตามแบบของ DOS'
READ NOLOCK CYCLE
patientdir = ALLTRIM(patientdir)
patientdir = IIF(EMPTY(patientdir), '\pub\', patientdir)
patientdir = IIF(RIGHT(patientdir,1)#'\', patientdir+'\', patientdir)
opddir = ALLTRIM(opddir)
opddir = IIF(EMPTY(opddir), '\opd\', opddir)
opddir = IIF(RIGHT(opddir,1)#'\', opddir+'\', opddir)
ipddir = ALLTRIM(ipddir)
ipddir = IIF(EMPTY(ipddir), '\ipd\', ipddir)
ipddir = IIF(RIGHT(ipddir,1)#'\', ipddir+'\', ipddir)
codedir = ALLTRIM(codedir)
codedir = IIF(EMPTY(codedir), '\pub\', codedir)
codedir = IIF(RIGHT(codedir,1)#'\', codedir+'\', codedir)
tempdir = ALLTRIM(tempdir)
tempdir = IIF(! EMPTY(tempdir) .AND. RIGHT(tempdir,1)#'\', tempdir+'\', tempdir)
pharmdir = ALLTRIM(pharmdir)
pharmdir = IIF(EMPTY(pharmdir), '\pharm\', pharmdir)
pharmdir = IIF(RIGHT(pharmdir,1)#'\', pharmdir+'\', pharmdir)
billdir = ALLTRIM(billdir)
billdir = IIF(! EMPTY(billdir) .AND. RIGHT(billdir,1)#'\', billdir+'\', billdir)
isdir = ALLTRIM(isdir)
isdir = IIF(! EMPTY(isdir) .AND. RIGHT(isdir,1)#'\', isdir+'\', isdir)
notprintrx = ALLTRIM(notprintrx)
wellbaby = ALLTRIM(wellbaby)
work1 = IIF( isstat = 0, '', 'STAT')
work2 = IIF( iser = 0, '', 'ER')
statinput = isstat = 1
er = iser = 1
backup = IIF(isbackup=0, ' ', 'AUDIT')
admit = IIF(isadmit=0, ' ', 'DISTRIBUTE')
prescription = IIF(ispres=0, 'NO', 'YES')
printpx = prescription = 'YES'
*person_id = IIF(isperson=0, 'NO', 'YES')
thaicard = IIF(ismicrowiz=0, ' ', 'MICROWIZ')
notque = IIF(isnotque=0, 'NO', 'YES')
backupdrive = IIF( EMPTY(backupdrive), '',backupdrive+':')
configfile = IIF( EMPTY(configfile),'stat2.cfg',configfile)
mat = AT('.',configfile)
configfile = IIF( mat=0, TRIM(configfile)+'.cfg', TRIM(configfile) )
towrite = 'Y'
IF FILE(configfile)
	=ALARM1()
	CLEA
	@ WROW()/2,10 SAY 'แฟ้ม ' +configfile+ ' มีอยู่แล้ว'
	@ ROW()+2,10 SAY 'ต้องการเขียนทับหรือไม่  ' GET towrite PICT '!'
	READ NOLOCK
ENDI
IF towrite = 'Y'
	fhandle = FCREA(configfile)
	IF fhandle > -1
		=FPUTS(fhandle,'patientdir = '+patientdir)
		=FPUTS(fhandle,'opddir = '+opddir)
		=FPUTS(fhandle,'ipddir = '+ipddir)
		=FPUTS(fhandle,'codedir = '+codedir)
		=FPUTS(fhandle,'tempdir = '+tempdir)
		=FPUTS(fhandle,'pharmdir = '+pharmdir)
		=FPUTS(fhandle,'billdir = '+billdir)
		=FPUTS(fhandle,'isdir = '+isdir)
		=FPUTS(fhandle,'notprintrx = '+notprintrx)
		=FPUTS(fhandle,'wellbaby = '+wellbaby)
		=FPUTS(fhandle,'workstation = '+work1)
		=FPUTS(fhandle,'backup = '+backup)
		=FPUTS(fhandle,'workstation = '+work2)
		=FPUTS(fhandle,'admit = '+admit)
		=FPUTS(fhandle,'prescription = '+prescription)
*		=FPUTS(fhandle,'person_id = '+person_id)
		=FPUTS(fhandle,'notque = '+notque)
		=FPUTS(fhandle,'thaicard = '+thaicard)
		=FPUTS(fhandle,'backupdrive = '+backupdrive)
		=FCLOSE(fhandle)
	ELSE
		=ALARM1()
		WAIT WIND NOWA 'ไม่สามารถสร้างแฟ้ม '+configfile
	ENDI
ENDI
CLEA
=ALARM1()
@ 1,Center('คำเตือน') SAY 'คำเตือน'
?
?
? '   ','ระบบของเครื่องนี้ได้เปลี่ยนไปตามที่ท่านกำหนดแล้ว'
?
IF towrite # 'Y'
	? '   ','ระบบได้เปลี่ยนเฉพาะในการทำงานต่อไป'
	? '   ','เมื่อออกจากโปรแกรมและกลับมาทำใหม่จะใช้ข้อมูลเดิม'
ELSE
	IF fhandle > -1
		? '   ','ข้อมูลของระบบได้เขียนไว้ในแฟ้มชื่อ ' + configfile +' เรียบร้อยแล้ว'
		exefile = SYS(16,1)
		IF UPPE(configfile) == 'STAT2.CFG' .OR. UPPE(configfile) == ;
		LEFT(exefile, AT('.',exefile))+'CFG'
			? '   ','เมื่อท่านเข้าสู่โปรแกรมอีกครั้ง ระบบก็จะเป็นไปตามที่ท่านตั้งใหม่'
		ELSE
			? '   ','โปรดระวัง ! เมื่อท่านออกจากโปรแกรม STAT2 '
			? '   ','ก่อนใช้โปรแกรม STAT2 ครั้งต่อไป ท่านจะต้องใช้คำสั่ง'
			?'   ','        SET configfile=' + configfile
			?'   ','ใน DOS prompt หรือ ใส่ไว้ใน AUTOEXEC.BAT'
			?'   ','มิฉะนั้นท่านจะไม่ได้ระบบตามที่ท่านต้องการ'
		ENDI
	ENDI
ENDI
@ WROW() -1,Center('กดปุ่มอะไรก็ได้เพื่อทำงานต่อ') SAY 'กดปุ่มอะไรก็ได้เพื่อทำงานต่อ'
=INKEY(0)
RELE WIND setconfig
audit = backup = 'AUDIT'
F_STATION=workstation='FILE'
nottoque = UPPE(notque) = 'YES'

FUNC Checkiser
IF iser =1
	Isstat = 0
	SHOW GETS
	RETU .F.
ENDI