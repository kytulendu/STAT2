*******************   7 0  P R O C  HELP_CAME  ************************
IF fromhelp
	?? CHR(7)
	WAIT 'คุณอยู่ในรายการช่วยเหลืออยู่แล้ว ไม่สามารถกดปุ่ม [F1] ได้อีก' WIND NOWA
	RETU
ELSE
	fromhelp = .T.
ENDI
varread=VARREAD()
DIME tempicd(100),tempname(100)
DO CASE
	CASE VARREAD='TEXT_VA3' .OR. varread='CLINIC' ;
	.OR. varread = 'CON_CLINIC'
		SELE clinic
		SET FILT TO RIGHT(clinic,1) # ' ' .AND. ! EMPTY(name)
		SET ORDER TO TAG name
		DO SearchHelp
		&varread=clinic
		SET FILT TO
		SET ORDER TO TAG clinic
		KEYB CHR(13)
	CASE VARREAD='WARD_ADM' .OR. varread = 'DEP'
		SELE WARD
		SET ORDER TO TAG name
		IF varread = 'DEP'
			SET FILTER TO RIGHT(clinic,1) = ' ' .AND. ! EMPTY(name)
		ELSE
			set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		ENDI
		DO SearchHelp
		&varread=LEFT(clinic,LEN(&varread))
		SET FILT TO
		SET ORDER TO TAG clinic
		KEYB CHR(13)
	CASE VARREAD $ 'HOSP_CODE,PLACE,OUTPLACE'
   		nowwindow = WONTOP()
   		IF ! EMPTY(nowwindow)
   			SAVE SCREE TO prewin
   			DEAC WIND (nowwindow)
   		ENDI
		SELE hospcode
		SET ORDER TO TAG name
		DO POPUP WITH 10,40,12,'hospcode','name'
		IF ! EOF()
			&varread = off_id
		ENDI
		IF ! EMPTY(nowwindow)
			ACTI WIND (nowwindow)
			REST SCREE FROM prewin
		ENDI
		SHOW GETS
   		KEYB CHR(13)
	CASE VARREAD='DOCTOR'
		SELE doctor
		SET FILT TO ! EMPTY(name)
		SET ORDER TO TAG name
		DO SearchHelp
		m.doctor=doctor
		SET FILT TO
		SET ORDER TO TAG doctor
		KEYB CHR(13)
	CASE LEFT(VARREAD,4)='MNEW'
		=EPISODE(&VARREAD)	
	CASE VARREAD='RESULT'
		=CheckResult(&VARREAD)	
	CASE VARREAD='REM_C'
		=CheckRem(&VARREAD)	
	CASE VARREAD='SEX'
		?? CHR(7)
		WAIT 'ให้ใส่รหัส  1 = ชาย      2 = หญิง  ' WIND NOWAIT
	CASE VARREAD='PROVINCE'
		?? CHR(7)
		WAIT 'ให้ใส่รหัส  1 = ในเขตจังหวัด     0 = นอกเขตจังหวัด  ' WIND NOWAIT
	CASE VARREAD='PTAGE'
		?? CHR(7)
		WAIT 'ให้ใส่รหัส  1XX = ปี      2XX = เดือน  3xx = วัน ' WIND NOWAIT
	CASE VARREAD='CAUSE' .OR. VARREAD='OUTCAUSE' 
		?? CHR(7)
		msg2='อาจใส่เหตุผลได้ 2 ข้อ เช่น 45  กดปุ่มอะไรก็ได้เพื่อทำงานต่อ'
		define window instr from 1,0 to 11,78 shadow title ;
		'   รหัสสาเหตุการส่งต่อผู้ป่วย  ' COLO bg+/gr+
		activate window instr
		@ 0,1 say '1 = วินิจฉัย ชันสูตรและส่งกลับ'
		@ 1,1 say '2 = เพื่อการรักษาเนื่องจากขีดความสามารถไม่พอด้านบุคคลากร'
		@ 2,1 say '3 = เพื่อการรักษาเนื่องจากขีดความสามารถไม่พอในด้านเครื่องมือ สถานที่'
		@ 3,1 say '4 = เพื่อการรักษาเนื่องจากขีดความสามารถไม่พอทั้งข้อ 2 และ 3'
		@ 4,1 say '5 = เพื่อการรักษาเนื่องจากขีดความสามารถไม่พอในด้านวิชาการ' 
		@ 5,1 say '6 = เพื่อการรักษาเนื่องจากขีดความสามารถพอแต่ไม่จำเป็น'
		@ 6,1 SAY '7 = เพื่อการรักษาเนื่องจากขีดความสามารถพอแต่ผู้ป่วย/ญาติต้องการ'
		@ 7,1 SAY '8 = เพื่อการรักษาเนื่องจากขีดความสามารถพอแต่เพื่อต้องการใช้สิทธิ'
		@ 8,Center(msg2) say msg2 color g+/gr+
		wait '' window TIMEOUT 30
		release window instr
     CASE varread = 'SOCIAL'
			DO SearchHelp
			_m=field(1)
			SET ORDER TO 1
			ACTI SCREE
			KEYB &_m
     CASE LEFT(varread,6)='DXTYPE'
     		DEFINE WIND selehelp FROM 8,20 TO 15,50 SHAD
     		ACTI WIND selehelp
            @ 1,3 SAY '1 = Principal Diagnosis'
            @ 2,3 PROMPT '2 = Comorbidity'
            @ 3,3 PROMPT '3 = Complication'
            @ 4,3 PROMPT '4 = Other'
            MENU TO mchoice
            RELE WIND selehelp
            KEYB STR(mchoice+1,1)
	OTHER
		??CHR(7)
		WAIT 'กรุณาดูคำอธิบายบรรทัดสุดท้าย ขอขอบคุณ' WIND NOWA
ENDC
fromhelp = .F.
return 
