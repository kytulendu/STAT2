*** 					ระบบงานเวชระเบียน
*** 	ระบบงานย่อยที่ 3 งานผู้ป่วยใน ประกอบด้วยงาน
***			- บันทึกขัอมูลการรับไว้เป็นผู้ป่วยใน แต่ละหอผู้ป่วย
***			- บันทึกขัอมูลการย้ายหอผู้ป่วย
***			- บันทึกขัอมูลการจำหน่ายผู้ป่วย
***		    - พิมพ์ รง.501, 502, 503 และ รายงานสรุปผู้ป่วยรับ,จำหน่ายแต่ละ
***           วันแยกตามหอผู้ป่วย
***			- สอบถามผู้ป่วยในว่าอยู่ตึกใด
***		แฟ้มข้อมูลหลัก ที่ใช้ มี 5 แฟ้ม ดังนี้
***			1. แฟ้ม iptrana สำหรับเก็บข้อมูลการรับ,จำหน่ายผู้ป่วยใน
***			2. แฟ้ม transfer สำหรับเก็บข้อมูลการย้ายหอผู้ป่วยแต่ละครั้ง
***			3. แฟ้ม iptrans สำหรับเก็บ convertion table ของ HN กับ SSN
***		    4. แฟ้ม refer แยกจากแฟ้ม refer ของ OPD
***         5. แฟ้ม appoint ใช้ร่วมกับ OPD
***		แฟ้มข้อมูลที่ใช้ร่วม มี 5 แฟ้ม ดังนี้
***	แฟ้ม patient1,contact,doctor,clinic,codefile
***	procedure ที่ใช้ร่วม คือ procedure utility
***	MEMO ที่ใช้ร่วม คือ OPDLAN, IPDTIME
***	การเรียกใช้งาน ให้เรียกจาก โปรแกรม adm_cen
***
***           	BETA VERSION 2.0 (December 1993)
***
*** v 1.6 แก้ไข ให้แสดงที่อยู่ต่อเนื่องกันใน admit
***            ปัญหาบันทึก hn ใน iptrana หลังจาก ทำdischarge
***			   เพิ่มการบันทึกข้อมูลลงใน \pub\medrec
*** v 1.7 แก้ไข การบันทึกข้อมูล iptrana โดยตรวจหา blank record ก่อน
*** 	  	   ลบ iptrana โดย insert blank
***			   บันทึก วันกลับ แพทย์เจ้าของไข้ และ dx_stat ใน iptrana
***			เมื่อบันทึกผ่าน addip
***			   ปัญหาบันทึก hn ใน ip-yy-mm หลังจาก ลง diag ใน addip
***			   ปรับปรุงสอบถามผ่านชื่อผู้ป่วย admit ให้เร็วขึ้น
*** v 1.8 แก้ไข flock หลังถามว่าถูกต้องหรือไม่ ใน admit
***			   transfer เปลียนเป็นค้นด้วย HN
***			   พิมพ์ซ่อมใบ discharge summary ใช้ HN แทน AN
***			   เพิ่ม field REM_C ใน iptrana สำหรับระบุว่าเป็น ผป refer
*** V 2.0 แก้ไข การแสดงหน้าจอ, รายงานต่างๆให้เป็นรูปแบบเดียวกันโดยใช้ utility
***			ของ นพ.วิรัตน์  debug set filter to
***			   ยกเลิกการตั้งค่า AN เอง และเก็บ AN ที่ยกเลิกไว้ใช้ใหม่
***************************************************************
**							*  โปรแกรม  ADM_CEN  *             **
***************************************************************
PARA _pass
PRIV ColSpace,NumLevel,ChMain,Userright
NotUsePass = PARAMETER() = 1 .AND.  _pass
IF ! NotUsePass
	Userright = GetUser()
	cando = ('SUP' $ userright .OR. 'A' $ userright)
	IF ! cando
		=ALARM1()
		WAIT WIND NOWA 'เสียใจ ! คุณไม่มีสิทธิทำงานห้องรับผู้ป่วย'
		RETU
	ENDI
ENDI
set function 12 to 'cancel;'
mdate=CE2BE(DATE())
yy=RIGHT(mdate,2)

IF ! FILE(ipddir+"ipdtime.mem")
	DO ipdtime  && ไม่ต้องถามไดเร็กทอรี่
ENDI
REST FROM (ipddir+'ipdtime') ADDI

CLOSE DATA
*StatInput = IIF(UPPE(GETENV('WORKSTATION'))='STAT',.T.,.F.)
col=Center(mhosp_name)
DISP_DATE=CE2CBE(DATE())
@ 0,col SAY mhosp_name COLO r+/b
@ 1,0
@1,2 SAY DISP_DATE COLO gr+/b

DIME LEVEL(6),LEVEL_A(4),LEVEL_I(4),LEVEL_E(4),MenuMess(6),Menu_A(4),Menu_I(4),Menu_E(7),chelp(3),EHelpMess(3)

@ 2,0 SAY REPL('-',80)
@ 21,0 SAY REPL('-',80)

MenuMess(1)='บันทึกรับ/ย้าย/จำหน่ายผู้ป่วยใน'
MenuMess(2)='แก้ไขบันทึกรับ/ย้าย/จำหน่ายผู้ป่วยใน'
MenuMess(3)='พิมพ์สรุป ยอดรับ และ จำหน่ายผู้ป่วยใน'
MenuMess(4)='สอบถามตึกที่ผู้ป่วยพัก'
MenuMess(5)='บำรุงรักษาระบบงาน '
MenuMess(6)='กลับรายการหลัก  มีปัญหาติดต่อศูนย์คอมพิวเตอร์ FAX.5918630'

LEVEL(1)= padc('บันทึก',12,' ')
LEVEL(2)= padc('แก้/ยกเลิก',12,' ')
LEVEL(3)= padc('พิมพ์/รายงาน',12,' ')
LEVEL(4)= padc('สอบถาม',12,' ')
LEVEL(5)= padc('บำรุงรักษา',12,' ')
LEVEL(6)= padc('เมนูหลัก',12,' ')

Menu_I(1)='บันทึกข้อมูลรับผู้ป่วยใน'
Menu_I(2)='บันทึกการย้ายผู้ป่วยภายในโรงพยาบาล'
Menu_I(3)='จำหน่ายและนัดหมายผู้ป่วยใน'
Menu_I(4)=''

LEVEL_I(1)=  padr('รับ ',15,' ')
LEVEL_I(2)=  padr('ย้ายตึก ',15,' ')
LEVEL_I(3)=  padr('จำหน่าย ',15,' ')
LEVEL_I(4)=  padr('เมนูหลัก ',15,' ')

Menu_E(1)='แก้ไขบันทึกข้อมูลรับผู้ป่วยใน'
Menu_E(2)='แก้ไขบันทึกการย้ายผู้ป่วยภายในโรงพยาบาล'
Menu_E(3)='แก้ไขบันทึกจำหน่ายและนัดหมายผู้ป่วยใน'
Menu_E(4)=''
LEVEL_E(1)=  padr('รับ ',15,' ')
LEVEL_E(2)=  padr('ย้ายตึก',15,' ')
LEVEL_E(3)=  padr('จำหน่าย',15,' ')
LEVEL_E(4)=  padr('เมนูหลัก',15,' ')

Menu_A(1)='สอบถามหอผู้ป่วยที่อยู่ของผู้ป่วยใน โดยค้นตามชื่อผู้ป่วย'
Menu_A(2)='สอบถามหอผู้ป่วยที่อยู่ของผู้ป่วยใน โดยค้นตามรายชื่อหอผู้ป่วย'
Menu_A(3)='สอบถามหอผู้ป่วยที่อยู่ของผู้ป่วยใน โดยค้นตามวันรับไว้ในโรงพยาบาล'
Menu_A(4)=''
LEVEL_A(1)=  padr('ชื่อ ',15,' ')
LEVEL_A(2)=  padr('หอผู้ป่วย ',15,' ')
LEVEL_A(3)=  padr('วันรับ ',15,' ')
LEVEL_A(4)=  padr('เมนูเดิม',15,' ')

chelp(1)='  เลือกชนิดจอภาพ     '
chelp(2)='  ลบรายการเก่า       '
chelp(3)='  เมนูหลัก           '
EHelpMess(1)='เลือกชนิดของจอภาพว่าเป็นจอสีหรืจอ MONOCHROME'
EHelpMess(2)='ลบรายการชั่วคราวของผู้ป่วยในที่กลับบ้าน และลงการวินิจฉัยแล้ว'
EHelpMess(3)=''


NumLEVEL=6             && จำนวนรายการหลัก
CoLSpace=13
DO OpenIpdDBF
DO mainscr
do whil .t.
	on key label F1 do mhelp with varread()
   @ 0,1 to 1,80 clea
   @ 0,col SAY mhosp_name COLO r+/b
	@ 1,0
   @1,2 SAY DISP_DATE COLO gr+/b
   DO Title WITH 'ลงทะเบียนผู้ป่วยใน/ประชาสัมพันธ์'
   xx=1
   @2,0 SAY REPL('-',80)
   @21,0 SAY REPL('-',80)
   @ 22,0 CLEA
   DO WHIL xx<=NumLEVEL
      @ 22,1+ColSpace*(xx-1) PROMPT LEVEL(xx) MESSAGE MenuMess(xx)
      xx=xx+1
   ENDD
   MENU TO ChMain
   IF ChMain=0
   		Chmain = numlevel
   ELSE
	   DO CLEARSCR
	DO CASE
   	CASE ChMain=1
   		DO in_ipd
   	CASE ChMain=2
   		DO edit_ipd
    CASE ChMain=3
        DO Rp_Ipd
    CASE ChMain=4
    	DO Ask
    CASE ChMain=5
		DO Adm_Util
	CASE ChMain=6
		IF NotUsePass
			CLOSE DATA
			CANC
		ENDI
		EXIT
	ENDC
	ENDI
	DO CLEARSCREEN
	DO Mainscr
ENDD

RELE WIND ALL
CLEA

***************************
PROC OpenIpdDBF
***************************

SELE 2
	dbfuse = patientdir+'contact'
	USE (patientdir+'contact') ORDER 1 ALIA contact

SELE 1
	dbfuse = patientdir+'patient1'
	USE (patientdir+'patient1') ORDER 1 ALIA patient1

SELE 4
	dbfuse = codedir+'occupat'
	USE (codedir+'occupat') ORDER 1 alia occupat

SELE 5
	dbfuse = codedir+'nation'
	USE (codedir+'nation') ORDER 1 ALIA nation

SELE 6
	dbfuse = codedir+'social'
 	USE (codedir+'social') ORDER 1 ALIA social

SELE 7
	dbfuse = codedir+'DOCTOR'
	USE (codedir+'DOCTOR') ORDER 1 ALIA doctor

SELE 9
	dbfuse = codedir+'address'
	USE (codedir+'address') ORDER 1 ALIA address

SELE 10
	dbfuse = codedir+'ward'
	USE (codedir+'ward') ORDER 2 ALIA ward

SELE 11
	dbfuse = patientdir+'patient2'
	USE (patientdir+'patient2') ORDER 1 ALIA patient2

SELE 12
	afile=ipddir+'data\iptrana'
	dbfuse = afile
	IF ! FILE(afile+'.dbf')
		CREATE TABLE (afile) ;
		(HN C(7),AN C(7),PTTYP C(2),DEP C(2),WARD_ADM C(3),DATEADM D,;
		TIMEADM C(4),WARD_NOW C(3),DATE_NOW D,TIME_NOW C(4),BED_NO C(2),;
		BED_TYPE C(1),TRANSFER L,DATEDSC D,TIMEDSC C(4),DISC C(4),;
		DR C(6),SENT L,DX_STAT L,PLACE C(5))
		INDEX ON hn TAG hn
		INDEX ON an TAG an
		INDEX ON WARD_ADM TAG WARD_ADM
		INDEX ON DATEADM TAG DATEADM
		INDEX ON WARD_NOW TAG WARD_NOW
		INDEX ON DATEDSC TAG DATEDSC
	ENDI
	USE (afile) ORDER 1 ALIA iptrana

sele 13

	infile=ipddir+'data\ADM'+yy
	dbfuse = infile
	IF ! FILE(infile+'.dbf')
		CREATE TABLE (infile) ;
		(HN C(7),AN C(7),PTTYP C(2),DEP C(2),WARD_ADM C(3),DATEADM D,;
		TIMEADM C(4),WARD_NOW C(3),DATE_NOW D,TIME_NOW C(4),BED_NO C(2),;
		BED_TYPE C(1),TRANSFER L,DATEDSC D,TIMEDSC C(4),DISC C(4),;
		DR C(6),SENT L,DX_STAT L,PLACE C(5), CAUSE C(2), ONSET N(2), ADM_W N(7,3))
		INDEX ON an TAG an
		INDEX ON hn TAG hn ADDI
	ENDI
	USE (infile) ALIA ADMyear ORDER TAG an

SELE 14
	anfile=ipddir+'ancount'
	dbfuse = anfile
	IF ! FILE(anfile+'.dbf')
		CREATE TABLE (anfile) (LASTAN N(5,0),YEAR C(2))
	ENDI
	use (anfile)

SELE 15
	dbfuse = ipddir+'CANCELAN'
	IF ! FILE(ipddir+'CancelAN.dbf')
		CREA TABLE (ipddir+'CANCELAN') (AN C(7))
		INDEX ON an TAG an
	ENDI
	USE (ipddir+'CancelAN') ORDER 1

SELE 16
	rfile=ipddir+'data\refer'+yy
	dbfuse = rfile
	IF ! FILE(rfile+'.dbf')
		CREATE TABLE (rfile) ;
		(HN C(7),AN C(7),DAY C(4),TIME C(4),PLACE C(5),DIAG C(7),CAUSE C(2),;
		CLINIC C(3),TYPE C(1))
			INDEX ON an TAG an
	ENDI
	USE (rfile) ORDER 1 ALIA refer

SELE 17
	dbfuse = ipddir+'data\transfer'
	IF ! FILE(ipddir+'data\transfer.dbf')
		CREATE TABLE (ipddir+'data\transfer') ;
		(AN C(7),DATE_IN D,TIME_IN C(4),WARDFROM C(3),DATE_OUT D,;
		TIME_OUT C(4),WARD_TO C(3))
			INDEX ON an TAG an
	ENDI
	USE (ipddir+'data\transfer') ORDER 1 ALIA transfer

SELE 0
dbfuse = codedir+'hospcode'
USE (codedir+'hospcode') ORDER  1 IN 0
dbfuse = opddir+'appoint'
USE (opddir+'appoint') ORDER 1 IN 0
dbfuse = codedir+'clinic'
USE (codedir+'clinic') ORDER 2 IN 0
dbfuse = patientdir+'medrec'
USE (patientdir+'medrec') ORDER 1 IN 0
dbfuse = ipddir+'lib\codefile'
USE (ipddir+'lib\codefile') ORDER tag code IN 0
dbfuse = patientdir+'countapp'
USE (patientdir+'countapp') ORDER 1 IN 0
dbfuse = patientdir+'holiday'
USE (patientdir+'holiday') ORDER 1 IN 0
dbfuse = ''
SELE patient1
	  set order to tag hn
	SET RELA TO hn INTO patient2
	SET RELA TO hn INTO contact ADDI
return

***************************
PROC ASK
***************************
DEFINE WIND help_ask FROM 4,5 TO 4+ALEN(LEVEL_A)+3,30 SHAD COLO gr+/w TITLE '  สอบถาม  '
DO WHIL .T.
	ACTI SCREE
	@ 22,0 CLEA
	ACTI WIND help_ask
	FOR i=1 TO ALEN(LEVEL_A)
		@ i,3 PROMPT LEVEL_A(i)
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
	   		DO ask_pt
			DO CLEARSCREEN
		CASE Ch_help = 2
	   		DO ask_ward
			DO CLEARSCREEN
		CASE Ch_help = 3
	        DO ask_date
			DO CLEARSCREEN
		CASE Ch_help = 4
			RELE WIND help_ask
			DO CLEARSCREEN
			return to adm_cen
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_ask
*SET COLO TO bg+/b

***************************
PROC IN_IPD
***************************
DEFINE WIND help_adm FROM 4,5 TO 4+ALEN(LEVEL_I)+3,30 SHAD TITLE '    ลงทะเบียนรับ  ' &&COLO gr+/w
DO WHIL .T.
	ACTI SCREE
	@ 22,0 CLEA
	ACTI WIND help_adm
	FOR i=1 TO ALEN(LEVEL_I)
		@ i,3 PROMPT LEVEL_I(i)
	NEXT
	MENU TO Ch_adm
	ACTI SCREE
	DO CASE
		CASE Ch_adm = 1
	   		DO admit
			DO CLEARSCREEN
		CASE Ch_adm = 2
	   		DO transfer
			DO CLEARSCREEN
		CASE Ch_adm = 3
	        DO disch
			DO CLEARSCREEN
		CASE Ch_adm = 4
			RELE WIND help_adm
			DO CLEARSCREEN
			return to adm_cen
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_adm
*SET COLO TO bg+/b

***************************
PROC EDIT_IPD
***************************
DEFINE WIND help_edit FROM 4,5 TO 4+ALEN(LEVEL_E)+3,30 SHAD COLO gr+/w TITLE '    แก้ไข/ยกเลิก  '
DO WHIL .T.
	ACTI SCREE
	@ 22,0 CLEA
	ACTI WIND help_edit
	FOR i=1 TO ALEN(LEVEL_E)
		@ i,3 PROMPT LEVEL_E(i)
	NEXT
	MENU TO Ch_edit
	ACTI SCREE
	DO CASE
		CASE Ch_edit = 1
	   		DO edit_adm
			DO CLEARSCREEN
		CASE Ch_edit = 2
	   		DO edit_trf
			DO CLEARSCREEN
		CASE Ch_edit = 3
	        DO edit_dsc
			DO CLEARSCREEN
		CASE Ch_edit = 4
			RELE WIND help_edit
			DO CLEARSCREEN
			return to adm_cen
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_edit
*SET COLO TO bg+/b

***************************
PROC Rp_Menu
***************************
PARA ntype
PRIVATE mstart,mend,anstart,anend
DO CLEARSCREEN
STORE SPACE(7) TO mstart,mend
STORE SPACE(7) TO anstart,anend
myy=subst(mdate,9,2)
@ 10,25 SAY 'HN เลขที่  '
@ 10,50 GET  mstart PICT '9999999'
	READ NOLOCK

hnstart=PADZERO(mstart,7)

exist=.F.
DO WHIL ! PRINTSTATUS() .AND. ! exist
    ?? CHR(7)
    WAIT 'เครื่องพิมพ์ยังไม่พร้อม  โปรดตรวจสอบให้เรียบร้อย' WINDOW TIMEOUT 10
	DO CLEARSCREEN
      exist=.T.
ENDD
IF exist
	RETU
ENDI

	SELE iptrana
	set order to tag hn
		go top
	dummyan=' '
	nowrec=recno()
	IF seek(hnstart)
    	 DO WHILE hn=hnstart
			nowrec  = IIF(an>dummyan,recno(),nowrec)
			dummyan = IIF(an>dummyan,an,dummyan)
				skip
		 ENDDO
	ELSE
			wait 'ไม่มี HN นี้ในแฟ้มข้อมูลคนไข้ใน ' window timeout 2
			return to adm_cen
	ENDIF

	go nowrec
	scat memvar
	m.result=m.dep
*	  SELE iptrans
*	  SET ORDER TO TAG HN
*	  SEEK m.hn
*		IF found()
*			scatter memvar
*		ENDIF
	      DO CASE
			CASE ntype='RP501'
				IF FILE('rp501.fxp')
					DO ('rp501')
				ELSE
					DO rp501p
				ENDI
			CASE ntype='RP502'
				IF FILE('rp501.fxp')
					DO ('rp501')
				ELSE
					DO rp501p
				ENDI
			CASE ntype='RP503'
				IF FILE('rp501.fxp')
					DO ('rp501')
				ELSE
					DO rp501p
				ENDI
	      ENDCASE
DO CLEARSCREEN
return

***********************************************
PROC nurseipd
***********************************************
DEAC WIND help_rep
@ 0,0 clear to 1,78
DO CLEARSCR

MDATE1=CE2BE(DATE()-1)

@ 11,2 say 'วันที่ต้องการออกรายงานผู้ป่วยใน'
@ 11,35 get mdate1  PICT '99/99/9999' ;
 		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
	READ NOLOCK
DO Clearscr

MDATEADM=BE2CE(MDATE1)

SELE 0
dbfuse = tempdir+'nurseipd'
IF ! FILE(tempdir+'nurseipd.dbf')
	CREAT TABLE (tempdir+'nurseipd') ;
      (HN C(9),AN C(8),NAME C(36),DATEADM D,TIMEADM C(4),WARD_ADM C(3),WARD_NOW C(3),DATEDSC D,TIMEDSC C(4),DATE_IN D, TIME_IN C(4), WARDFROM C(3), DATE_OUT D, TIME_OUT C(4), WARD_TO C(3), DISC C(4))
ELSE
	USE (tempdir+'nurseipd')
ENDIF
dbfuse = ''
SELE IPTRANA
COPY TO (tempdir+'IPD') for dateadm=MDATEADM or datedsc=MDATEADM
SELE 0
dbfuse = tempdir+'IPD'
	use (tempdir+'IPD') alia IPD
     index on hn tag hn
	 set order to tag hn
	 SET RELA TO hn INTO patient1
dbfuse = ''
go top
  DO WHILE  .NOT. EOF()
	scat memvar
   SELE patient1
	scat fields NAME memvar
	insert into nurseipd from memvar
	FLUSH
   SELE	ipd
	skip
  ENDDO
  scat memvar blank

SELE TRANSFER
COPY TO (tempdir+'TRF') for date_in=MDATEADM or date_out=MDATEADM
SELE 0
dbfuse = tempdir+'TRF'
	use (tempdir+'TRF') alia TRF
     index on an tag an
	 set order to tag an
	 SET RELA TO an INTO iptrana
dbfuse = ''
	SELE iptrana
	  set order to tag hn
      SET RELA TO hn INTO patient1
SELE trf
go top
  DO WHILE  .NOT. EOF()
	scat memvar
   SELE IPTRANA
	scat fields hn memvar
   SELE patient1
	scat fields NAME memvar
	insert into nurseipd from memvar
	FLUSH
   SELE TRF
	skip
  ENDDO
  scat memv blank

SELE ward
SET ORDER TO TAG CLINIC
go top
set filter to subs(clinic,3,1) <> ' '

  DO WHILE	.NOT. EOF()

   mclinic=ward->clinic

	SELECT *;
	 FROM WARD;
	 HAVING SUBSTR(ward.clinic,3,1) BETWEEN "1" AND "9";
		AND WARD.CLINIC = MCLINIC;
	 ORDER BY WARD.CLINIC;
	 INTO CURSOR QUERY
	CREATE REPORT TITLE.FRX FROM QUERY WIDTH 80 COLUMN NOOVERWRITE
	REPORT FORM TITLE.FRX TO PRINTER NOCONSOLE PDSETUP NOEJECT

	SELECT WARD.NAME, NURSEIPD.HN, NURSEIPD.AN, NURSEIPD.NAME,;
	  NURSEIPD.DATEADM, NURSEIPD.TIMEADM, NURSEIPD.WARD_ADM;
	 FROM NURSEIPD, WARD;
	 WHERE WARD.CLINIC = NURSEIPD.WARD_ADM;
	  HAVING VAL(DTOC(nurseipd.datedsc)) = 0.00;
		AND NURSEIPD.WARD_ADM = MCLINIC;
	 ORDER BY WARD.NAME, NURSEIPD.TIMEADM;
	 INTO CURSOR ADM_RP
	CREATE REPORT ADM_RP.FRX FROM ADM_RP WIDTH 80 COLUMN NOOVERWRITE
	REPORT FORM ADM_RP.FRX TO PRINTER NOCONSOLE PDSETUP NOEJECT

	SELECT DISTINCT WARD.NAME, NURSEIPD.HN, NURSEIPD.AN, NURSEIPD.NAME,;
	  NURSEIPD.WARD_NOW, NURSEIPD.DATEDSC, NURSEIPD.TIMEDSC, NURSEIPD.DISC;
	 FROM NURSEIPD, WARD;
	 WHERE WARD.CLINIC = NURSEIPD.WARD_NOW;
	 HAVING VAL(DTOC(nurseipd.datedsc)) <> 0.00;
		AND NURSEIPD.WARD_NOW = MCLINIC;
	 ORDER BY WARD.NAME, NURSEIPD.TIMEDSC;
	 INTO CURSOR DSC_RP
	CREATE REPORT DSC_RP.FRX FROM DSC_RP WIDTH 80 COLUMN NOOVERWRITE
	REPORT FORM DSC_RP.FRX TO PRINTER NOCONSOLE PDSETUP NOEJECT

	SELECT DISTINCT WARD.NAME, NURSEIPD.HN, NURSEIPD.AN, NURSEIPD.NAME,;
	  NURSEIPD.DATE_OUT, NURSEIPD.TIME_OUT, NURSEIPD.WARD_TO;
	 FROM NURSEIPD, WARD;
	 WHERE WARD.CLINIC = NURSEIPD.WARD_TO;
	 HAVING VAL(DTOC(nurseipd.date_out)) <> 0.00;
		AND NURSEIPD.WARD_TO = MCLINIC;
	 ORDER BY NURSEIPD.WARD_TO, NURSEIPD.TIME_OUT;
	 INTO CURSOR QUERY_A
	CREATE REPORT TRF_RP.FRX FROM QUERY_A WIDTH 80 COLUMN NOOVERWRITE
	REPORT FORM TRF_RP.FRX TO PRINTER NOCONSOLE PDSETUP NOEJECT

   SELE ward
   skip
   EJECT
  ENDDO


SELE IPD
USE
dele file (tempdir+'ipd.dbf')
dele file (tempdir+'ipd.cdx')
SELE TRF
USE
dele file (tempdir+'trf.dbf')
dele file (tempdir+'trf.cdx')
SELE NURSEIPD
USE
dele file (tempdir+'nurseipd.dbf')

return

***********************************************
PROC Adm_Util
***********************************************
DO CLEARSCR

DEFINE WIND help_menu FROM 4,5 TO 4+ALEN(chelp)+3,40 SHAD COLO gr+/w TITLE ' บำรุงรักษาระบบ '
DO WHIL .T.
	ACTI SCREE
	@ 22,0 CLEA
	ACTI WIND help_menu
	FOR i=1 TO ALEN(chelp)
		@ i,3 PROMPT chelp(i)
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
				do SELEMONI
		CASE Ch_help = 2
				do deltrana
		CASE Ch_help = 2
				RELE WIND help_menu
				return to adm_cen
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_menu
*SET COLO TO bg+/b

*************************************
PROC DELTRANA
*************************************
SET REPROCESS TO 3 SECONDS
SELE iptrana
 SET FILTER TO (DATE()-DATEDSC >7) AND (VAL(DTOC(DATE())) <> 0)
 GO TOP
 IF FLOCK()
  DO WHILE .NOT. EOF()
  		if dx_stat = .T.
  		  scat memv blank
  		  gather memvar
  		  FLUSH
  		endif
  		skip
  ENDDO
 ELSE
       	WAIT 'ไม่สามารถล็อค File IPTRANA ได้ เลิกทำงาน';
         	WINDOW TIME 3
           	RETU TO MASTER
 ENDIF

UNLOCK ALL
WAIT 'ดำเนินการเสร็จสิ้นแล้ว' WINDOW TIME 3
SET FILTER TO
SELE iptrana
set order to tag HN

***********************************
PROC ASK_PT
***********************************
* 1. ตรวจสอบว่าใส่เป็นนามสกุลหรือไม่โดยดูว่าอักขระแรกเป็นช่องว่างหรือไม่ ถ้า   *
*    เป็นนามสกุลจะดูว่าสี่ตัวแรกมีไหม ถ้าไม่มีเป็นรายใหม่                      *
* 2. ถ้าเป็นชื่อจะค้นหาว่าชื่อนี้มีหรือไม่ ถ้าไม่มีจะหาโดยเทียบชื่อ 3 ตัวแรก   *
*    รวมกับนามสกุล 3 ตัวแรกว่ามีหรือไม่ ถ้าไม่มีแสดงว่าเป็นรายใหม่             *
* 3. ถ้าเป็นรายเก่าจาก 2 ข้อแรกจะแสดงชื่อ นามสกุล ชื่อมารดา                    *
*    และวันเดือนปีเกิด โดยอาศัย Procedure LISTNAME                             *
********************************************************************************
PRIVATE mseek,useother,yearopen
STORE .F. TO useother
EXTERNAL ARRAY patient1
SELE patient1
new_one=.F.
STORE SPACE(30) to mname

DEAC WIND help_ask

DO bottmess WITH 'พิมพ์ชื่อที่ต้องการค้นหา ถ้าพิมพ์เฉพาะนามสกุลให้เคาะ space bar ก่อน 1 ครั้ง'

@ 0,0 clear to 1,78
DO CLEARSCR

@ 1,2 say 'HN.'
@ 1,23 say 'AN.'
@ 1,34 say '/'
@ 1,45 say 'ชื่อ'
@ 1,50 get mname
	READ NOLOCK
newcase = .T.
IF ISDIGIT(mname)
	SELE patient1
	SET ORDER TO TAG hn
*	IF SEEK(PADZERO(TRIM(mhn),7))
*		newcase = .F.
*	ENDI
	newcase = ! SEEK(PADZERO(TRIM(mname),7))
ELSE
	DO Chec_New WITH mname,newcase
ENDI
IF newcase
	?? CHR(7)
	heading = IIF(Lastkey()=27,'ยกเลิกการค้นตามต้องการ','ไม่มีคนไข้ชื่อ ' + ALLTRIM(mname) + ' ในทะเบียนของโรงพยาบาล')
	WAIT WIND heading NOWA
ELSE
	ON ERROR
	m.hn = hn
	m.name = LEFT(De_Name(name),25)
	SELE iptrana
	SET ORDER TO TAG hn
	IF ! SEEK(m.hn)
		yearopen = RIGHT(CE2BE(DATE()),2)
		SELE 0
		IF ! FILE(ipddir+'data\adm'+yearopen+'.dbf')
			yearopen = STRZERO(VAL(yearopen)-1,2)
		ENDI
		DO WHIL FILE(ipddir+'data\adm'+yearopen+'.dbf')
			SELE admyear
			_fileopen = DBF()
			useother = .T.
			USE (ipddir+'data\adm'+yearopen) ORDER TAG hn ALIA admyear
			IF SEEK(m.hn)
				EXIT
			ENDI
			yearopen = STRZERO(VAL(yearopen)-1,2)
		ENDD
	ENDI
	IF EMPTY(DBF()) .OR.  EOF()
		?? CHR(7)
		WAIT WIND 'ไม่มีคนไข้ชื่อ '+TRIM(m.name) +' รักษาตัวอยู่ในโรงพยาบาล' Nowai
	ELSE
		reportfile=tempdir+SYS(3)+'.txt'
		SET PRINT TO &reportfile
		SET PRINT ON
		SET CONS OFF
		_wrap=.F.
		_plength=41
		_peject='AFTER'
		_pageno=1
		_plineno=0
		_PLOFFSET = 0
		ON PAGE AT line _plength-2 DO admitheader WITH .T.
		KEYB ' '
		STORE .F. TO usedhosp,usestatrqbe
		IF ! USED('hospcode')
			dbfuse = codedir+'hospcode'
			USE (codedir+'hospcode') ORDER 1 IN 0
			usedhosp = .T.
		ENDI
		dbfuse = 'statrqbe.dbf'
		IF ! USED('statrqbe')
			IF FILE('statrqbe.dbf')
				USE statrqbe IN 0
			ELSE
				dbfuse = patientdir+'statrqbe'
				USE (patientdir+'statrqbe') IN 0
			ENDI
			usedstatrqbe = .T.
		ENDI
		dbfuse = ''
		SELE statrqbe
		LOCA FOR TRIM(name)='ผลการรักษา' .AND. 'I' $ callprg
		numline=memlines(code)
		DIME xcode(numline),xcoded(numline)
		FOR i=1 to numline
			STOR mline(desc,i) TO xcoded(i)
			STOR mline(code,i) TO xcode(i)
		NEXT
		IF usedstatrqbe
			USE
		ENDI
		SELE ward
		SET ORDER TO 1
		IF useother
			SELE admyear
		ELSE
			SELE iptrana
		ENDI
		PRINTJOB
			DO admitheader WITH .F.
			DO WHIL hn = m.hn
				SCAT MEMV
				SELE ward
				SEEK m.ward_now
				? m.name,' '+IIF(day(m.dateadm)<10,' ',''),Ce2CBE(m.dateadm),;
				' '+IIF(day(m.datedsc)<10,' ',''),CE2CBE(m.datedsc),;
				TRIM(ward.name) AT 60
				m.disc = LEFT(m.disc,2)
				IF ! EMPTY(m.datedsc)
					nameresult =xcoded[ASCAN(xcode,m.disc)]
					IF RIGHT(m.disc,1)='4'
						SELE hospcode
						SEEK m.place
						nameresult = TRIM(nameresult)+;
						IIF(EMPTY(name),'ไม่ได้ระบุรพ.ที่ส่งต่อ',TRIM(De_name(name)))
					ENDI
					? SPACE(8)+nameresult
				ENDI
				IF useother
					SELE admyear
				ELSE
					SELE iptrana
				ENDI
				SKIP
			ENDD
			?
		ENDPRIN
		IF usedhosp
			SELE hospcode
			USE
		ENDI
		IF useother
			SELE admyear
			USE (_fileopen) ORDER TAG an ALIA admyear
		ENDI
		mkeylabel=ON('KEY','F1')
		ON KEY LABEL F1 DO helpbrow
		ON KEY LABEL PGUP
		DO Endprint WITH '  รายงานผู้ป่วยในโรงพยาบาล  ',reportfile
		ON KEY LABEL F1 &mkeylabel
		DELE FILE (reportfile)
	ENDI
ENDI
@ 0,0 clear to 1,78
sele patient1
SET ORDER TO TAG hn
DO CLEARSCR

***********************************
PROC ASK_WARD
***********************************
WARD='   '

DEAC WIND help_ask

SELE IPTRANA
SET ORDER TO TAG WARD_NOW
go top

@ 0,0 clear to 1,78
DO CLEARSCR

@ 11,20 say 'หอผู้ป่วยที่รับ'
@ 11,35 get ward picture '999' valid !empty(ward) message 'F1 = List'
	READ NOLOCK
SELE ward
SET ORDER TO TAG clinic
SEEK ward
wardname = name
SELE PATIENT1
SET ORDER TO TAG hn
SELE IPTRANA
SET ORDER TO TAG ward_now
SET RELA TO hn INTO patient1
IF ! SEEK(WARD)
	?? CHR(7)
	WAIT WIND 'ไม่มีคนไข้ในตึก ' + TRIM(wardname) NOWA
ELSE
	reportfile=tempdir+SYS(3)+'.txt'
	SET PRINT TO &reportfile
	SET PRINT ON
	SET CONS OFF
	_wrap=.F.
	_plength=41
	_peject='AFTER'
	_pageno=1
	_plineno=0
	_PLOFFSET = 0
	ON PAGE AT line _plength-2 DO admitheader WITH .T.
	KEYB ' '
	SELE iptrana
	PRINTJOB
		DO admitheader WITH .F.
		DO WHIL ward_now = ward
			IF EMPTY(datedsc) .OR. DATE() - datedsc <= 7
				? LEFT(DE_NAME(patient1.name),25),' '+IIF(day(dateadm)<10,' ',''),Ce2CBE(dateadm),;
				' '+IIF(day(datedsc)<10,' ',''),CE2CBE(datedsc),;
				TRIM(ward.name) AT 60
			ENDI
			SKIP
		ENDD
		?
	ENDPRIN
	mkeylabel=ON('KEY','F1')
	ON KEY LABEL F1 DO helpbrow
	ON KEY LABEL PGUP
	DO Endprint WITH '  รายงานผู้ป่วยในโรงพยาบาล  ',reportfile
	ON KEY LABEL F1 &mkeylabel
	DELE FILE (reportfile)
ENDI

***********************************
PROC ASK_DATE
***********************************
DEAC WIND help_ask

SELE ward
SET ORDER TO TAG clinic
SELE patient1
SET ORDER TO TAG hn
SELE IPTRANA
SET ORDER TO TAG dateadm
SET RELA TO hn INTO patient1

@ 0,0 clear to 1,78
DO CLEARSCR

@ 11,2 say 'วันที่รับไว้ในโรงพยาบาล'
@ 11,28 get mdate  PICT '99/99/9999' VALID TRUEDATE(mdate) ;
 		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
	READ NOLOCK

MDATEADM=BE2CE(MDATE)
IF ! SEEK(MDATEADM)
	?? CHR(7)
	showdate = CE2CBE(mdateadm)
	WAIT WIND 'ไม่มีคนไข้รับไว้ในวันที่ ' + showdate NOWA
ELSE
	reportfile=tempdir+SYS(3)+'.txt'
	SET PRINT TO &reportfile
	SET PRINT ON
	SET CONS OFF
	_wrap=.F.
	_plength=41
	_peject='AFTER'
	_pageno=1
	_plineno=0
	_PLOFFSET = 0
	ON PAGE AT line _plength-2 DO admitheader WITH .T.
	KEYB ' '
	PRINTJOB
		DO admitheader WITH .F.
		SELE ward
		DO WHILE iptrana.dateadm = mdateadm
			SEEK iptrana.ward_now
			? LEFT(DE_NAME(patient1.name),25),' '+IIF(day(iptrana.dateadm)<10,' ',''),Ce2CBE(iptrana.dateadm),;
			' '+IIF(day(iptrana.datedsc)<10,' ',''),CE2CBE(iptrana.datedsc),;
			TRIM(ward.name) AT 60
			SKIP IN iptrana
		ENDD
		?
	ENDPRIN
	mkeylabel=ON('KEY','F1')
	ON KEY LABEL F1 DO helpbrow
	ON KEY LABEL PGUP
	DO Endprint WITH '  รายงานผู้ป่วยในโรงพยาบาล  ',reportfile
	ON KEY LABEL F1 &mkeylabel
	DELE FILE (reportfile)
ENDI

*******************
PROC MAINSCR
*******************
DO CLEARSCREEN
@ 2,0
TEXT
                        โปรแกรมสำหรับงานรับและจำหน่ายผู้ป่วยใน
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

***************************
Procedure v_refer
***************************
do case
 case m.dctype$'123567'
 	if m.dcstatus$'89'
 		?? chr(7)
 		wait 'ผู้ป่วยเสียชีวิตแล้ว รหัสการจำหน่ายต้องเป็น 8 หรือ 9 ' wind time 1
 		return 0
 	endif
 case m.dctype ='4'
 	if m.dcstatus$'89'
	 	?? chr(7)
 		wait 'ผู้ป่วยเสียชีวิตแล้ว รหัสการจำหน่ายต้องเป็น 8 หรือ 9 ' wind time 1
 		return 0
 	endif
	do forreferout
 case m.dctype$'89'
 	if ! m.dcstatus$'89'
 		?? chr(7)
 		wait 'สถานภาพการจำหน่ายผู้ป่วยไม่ได้เสียชีวิต รหัสการจำหน่ายต้องไม่ใช่ 8 หรือ 9 ' wind time 1
 		return 0
 	endif
 othe
	?? chr(7)
	wait 'รหัสไม่ถูกต้อง กด F1 ดูข้อความช่วยเหลือ' wind time 1
	return 0
endc

************************************************************
PROC FORREFEROUT
************************************************************
DEFINE WIND win1 FROM 6,2 TO 19,78 SHAD
ACTI WIND win1
outtime=IIF(empty(outtime),LEFT(TIME(),2)+SUBS(TIME(),4,2),outtime)
@ 1,3 say 'เวลาที่ส่ง refer   ' get outtime PICT '@R ##:##';
valid TimeRefer(outtime) mess 'ใส่เวลาเป็นชั่วโมง นาที'
@ 3,3 SAY 'ชื่อสถานบริการที่ refer ' get outplace pict '@!' ;
VALID Hospital(outplace,referoutplace)
@ 4,3 GET referoutplace DISA
@ 6,3 say 'เหตุผลที่ส่ง refer ' get outcause VALID CheckCause(outcause)
@ 10,20 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET m.correct DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
READ NOLOCK
outtype='2'
RELE WIND win1

FUNC TimeRefer
para _mtime
if ! BETWEEN(LEFT(_mtime,2),'  ','23') .OR. ! BETWEEN(RIGHT(_mtime,2),'  ','59')
	?? CHR(7)
	WAIT 'ใส่เวลาไม่ถูกต้อง' WIND NOWA
	_CUROBJ=_CUROBJ
ENDI

FUNC CHECKCORRECT
PARA _check
IF _check#'Y'
	_CUROBJ=1
ENDI

FUNC CheckCause
PARA _cause
IF LASTKEY()>27
	IF ! LEFT(_cause,1) $ '12345678' .OR. ! RIGHT(_cause,1) $ ' 12345678'
		_CUROBJ=_CUROBJ
		KEYB "{F1}"
	ENDI
ENDI

***********************************
PROC AskAppoint
*   สอบถาม การนัดหมาย
***********************************
IF m.dctype = '1'
	SELE appoint
	_hn = m.hn
	_mdoctor=m.dr
	scat memv blank MEMO
	m.hn = _hn
	mmtime=space(4)
	mdateappo=SPACE(10)
	m.doctor=_mdoctor
   DO APPOINTMENT WITH .T.
ENDI

***********************************
Procedure v_dc
***********************************
do case
	case !m.dcstatus$'123456789'
		?? chr(7)
		wait 'รหัสไม่ถูกต้อง' window timeout 1
		return 0
	case m.dcstatus = '8'
		if m.dateadm <> m.datedsc
			wait 'รหัสนี้สำหรับ ผู้ป่วยเด็กตายแรกคลอดเท่านั้น ' wind time 2
			return 0
		endif
	othe
		return
endc

********************************
PROC SEEK_PT
*********************************
PRIVATE Pre_page,mkey,valid_key,bott_mess
bott_mess='[PgUp]=ชื่อก่อนหน้านี้  [PgDn]=ชื่อถัดไป  [Esc]=ไม่เลือก  [A]-['
SAVE SCREEN TO Pre_page
DO CLEARSCR
@ 3,0
?'      HN      AN                  ชื่อ นามสกุล    '
nn=0
DO WHIL nn=0
   @ 5,0
   mkey=0
	 	IF readkey()=12 or readkey()=268
			SELE  disctemp
				use
				dele file disctemp.dbf
			@ 0,0 CLEA TO 1,79
			@ 3,0 CLEA TO 20,79
			on key label PGUP
			return to edit_ipd
		ENDI
		IF EOF()
			wait 'ไม่มีข้อมูลผู้ป่วยในหอผู้ป่วยนี้' window timeout 2
			@ 3,0 CLEA TO 20,79
			SELE  disctemp
				use
				dele file disctemp.dbf
			return
		ENDIF
		SELE disctemp
		SET RELA TO hn INTO patient1
   DO WHIL nn<14 .AND. ! EOF()
	  ? CHR(nn+65)+' '+hn+'  '+subs(an,3,5)+'-'+subs(an,1,2)
      ?? SPAC(20)+De_name(patient1->name)
      nn=nn+1
      SKIP
   ENDD
   valid_key=.F.
   DO Bottmess WITH bott_mess+CHR(nn+64)+']=เลือก'
   DO WHIL ! valid_key
      mkey=inkey(10)
      DO Bottmess WITH bott_mess+CHR(nn+64)+']=เลือก'
      DO CASE
      CASE mkey=27 .OR. mkey=13     && [Esc] or [Enter]
         valid_key=.T.
      CASE mkey=5  .OR. mkey=18              &&  Up arrow
         SKIP -nn-1
         IF BOF()
            ?? CHR(7)
            DO Bottmess WITH 'นี่เป็นชื่อแรกอยู่แล้ว'
            SKIP nn
         ELSE
            SKIP -(27-nn)
            valid_key=.T.
            nn=0
            IF BOF()
               GO TOP
            ENDI
         ENDI
      CASE mkey=24  .OR. mkey=3             &&  Down arrow
         IF ! EOF()
            valid_key=.T.
            nn=0
         ELSE
            ?? CHR(7)
            DO bottmess WITH 'หมดรายชื่อที่จะแสดงแล้ว'
         ENDI
      OTHER
         mm= ROUND(AT(UPPE(CHR(mkey)),'AฟBิCแDกEำFดGเH้IรJ่KาLสMทNื')/2,0)
         IF mm>0 .AND. mm<=nn
            valid_key=.T.
         ENDI
      ENDC
   ENDD
   @ 5,0 CLEA TO 20,79
ENDD
IF mkey=27
   new_one=.T.
   mm=0
ELSE
   mm=IIF(mkey=13,1,mm)
   SKIP -(nn+1-mm)
	scat memvar
	mmhn=m.hn
   new_one=.F.
ENDI

SELE  disctemp
	use
	dele file (disctemp+'.dbf')

REST SCREE FROM Pre_page

****************-------  นัดคนไข้  --------------------

FUNC CHECKCORRECT
PARA _check
IF _check#'Y'
	_CUROBJ=1
ENDI

********************************************************************
PROC admitheader
********************************************************************
PARA _foreject
PRIVATE mprint,mhosp
mhosp='รายชื่อผู้ป่วยใน '+TRIM(hosp_name)
IF _foreject
	eject page
	eject
ENDI
mpagep='หน้าที่ '+LTRIM(STR(_pageno))
? REPL('-',80)
?'วันที่ '+CE2CBE(DATE())+SPACE(44) + mpagep
?SPAC(CENTER(mhosp))+mhosp
? REPL('-',80)
?
?'   ชื่อ นามสกุล                วันรับ         วันจำหน่าย         หอผู้ป่วย'
?
IF _foreject
	?
ENDI

*************
PROC CLEARSCR
*************
@ 3,0 TO 20,79 CLEA
@ 22,0 TO 24,79 CLEA

************
FUNC HIDEWIN
************
PARA _hidewin
IF WVISIBLE(_hidewin)
	HIDE WIND &_hidewin
ENDI
RETU .T.

*********************************************************
PROC IPDTIME
*********************************************************
PRIVATE time_morn,time_aft,time_nigh,morn_min,aft_min,nigh_min,m_min,a_min,n_min

STOR SPACE(4) TO time_morn,time_aft,time_nigh

@ 3,0 CLEA TO 20,80
@5,15 say 'เวลาเริ่มต้นเวรเช้า  ' get time_morn pict '@R ##:##'  VALID CheckTimeIn(time_morn) ;
		MESS 'ใส่เวลาที่เริ่มต้นเวรเช้า เป็นชั่วโมง นาที'
@7,15 say 'เวลาเริ่มต้นเวรบ่าย  ' get time_aft pict '@R ##:##'  VALID CheckTimeIn(time_aft) ;
		MESS 'ใส่เวลาที่เริ่มต้นเวรบ่าย เป็นชั่วโมง นาที'
@9,15 say 'เวลาเริ่มต้นเวรดึก   ' get time_nigh pict '@R ##:##' VALID CheckTimeIn(time_nigh) ;
		MESS 'ใส่เวลาที่เริ่มต้นเวรดึก เป็นชั่วโมง นาที'
READ NOLOCK
=English()

morn_min=VAL(SUBS(time_aft,3,2))
aft_min	=VAL(SUBS(time_nigh,3,2))
nigh_min=VAL(SUBS(time_morn,3,2))

m_min=IIF(morn_min=0,59,morn_min-1)
a_min=IIF(aft_min=0,59,aft_min-1)
n_min=IIF(nigh_min=0,59,nigh_min-1)

mtime1	=	time_morn
mtime2	=	PADZERO(STR(VAL(SUBST(time_aft,1,2))-1,2),2)+PADZERO(STR(m_min,2),2)
mtime3 	=	time_aft
mtime4	=	STR(VAL(SUBST(time_nigh,1,2))-1,2)+PADZERO(STR(a_min,2),2)
mtime4  =   IIF(time_nigh='0000','2359',mtime4)
mtime5	=	IIF(time_nigh='0000','2400',time_nigh)
mtime6	=	'2400'
mtime7	=	'0000'
mtime8	=	PADZERO(STR(VAL(SUBST(time_morn,1,2))-1,2),2)+PADZERO(STR(n_min,2),2)

SAVE ALL LIKE mtime* TO (ipddir+'IPDTIME')
DO CLEARSCR

****************
FUNC CHECKTIMEIN
****************
PARA _time
IF RIGHT(_time,2)>'59' .OR. LEFT(_time,2)>'24'
	?? CHR(7)
	_CUROBJ=_CUROBJ
ENDI

FUNC SAMEWARD
PARA _ward,_oldward
IF _ward = _oldward
	?? CHR(7)
	WAIT WIND NOWA 'ทำไมถึงจะย้ายไปยังหอผู้ป่วยเก่าอีกละ ! '
	_CUROBJ = _CUROBJ
ENDI