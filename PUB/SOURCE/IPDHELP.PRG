*************** Procedure IPDHELP *******************
Para _var

on key label F1
on key label PgUp
on key label PgDn
on key label Home
on key label End
on key label F3

_varname=Upper(rtrim(_var))

do case
	case substr(_varname,1,4)='SURG' or _varname='DR'
		SELE doctor
		SET ORDER TO NAME
		SET FILT TO ! EMPTY(name)
		DO SearchHelp
		SET FILT TO
		m.&_varname=DOCTOR
		KEYB CHR(13)
		on key label F1 do ipdhelp with varread()
		RETURN
	case _varname='PTTYP'
		SELE social
		DO SearchHelp
		m.&_varname = class
		KEYB CHR(13)
	case _varname='DCSTATUS'
		do hlpdcs
	case _varname='DCTYPE'
		do hlpdct
	case substr(_varname,1,4)='WARD'
		SELE WARD
		SET ORDER TO TAG name
		set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		DO SearchHelp
		m.&_varname=LEFT(clinic,LEN(m.&_varname))
		SET FILT TO
		SET ORDER TO 1
		KEYB CHR(13)
     CASE LEFT(_var,6)='DXTYPE'
     		DEFINE WIND selehelp FROM 8,20 TO 15,50 SHAD
     		ACTI WIND selehelp
            @ l1,3 SAY '1 = Principal Diagnosis'
            @ 2,3 PROMPT '2 = Comorbidity'
            @ 3,3 PROMPT '3 = Complication'
            @ 4,3 PROMPT '4 = Other'
            MENU TO mchoice
            RELE WIND selehelp
            KEYB STR(mchoice+1,1)
	CASE _VAR='CAUSE' .OR. _VAR='OUTCAUSE'
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
	CASE _VAR='PLACE' .OR. _VAR='OUTPLACE'
   		nowwindow = WONTOP()
   		IF ! EMPTY(nowwindow)
   			SAVE SCREE TO prewin
   			DEAC WIND (nowwindow)
   		ENDI
		SELE hospcode
		SET ORDER TO TAG name
		DO POPUP WITH 10,40,12,'hospcode','name'
		IF ! EOF()
			m.&_varname = off_id
		ENDI
		IF ! EMPTY(nowwindow)
			ACTI WIND (nowwindow)
			REST SCREE FROM prewin
		ENDI
		SHOW GETS
   		KEYB CHR(13)
	otherwise
		wait 'โปรดอ่านคำแนะนำที่บรรทัดล่างสุด' window timeout 2
endcase

on key label F1 do ipdhelp with varread()
on key label F3 do disprec
*on key label PgUp ?? chr(7)
*on key label PgDn ?? chr(7)
*on key label Home ?? chr(7)
*on key label End ?? chr(7)

***********************************

FUNC HLPDCS
select codefile
set order to 0
LOCA FOR varname='DCST'
DIME dcsname[10]
numdcs = 0
DO WHIL varname = 'DCST'
	numdcs=numdcs+1
	dcsname(numdcs)=LEFT(code,1)+' ' + TRIM(name)+'  '
	skip
ENDD
DIME dcsname(numdcs)
mchoice=0
SET CONF ON
define window showDCt from 5,20 to 15,60 none shadow

activate window showdct
DO WHIL mchoice=0
   @ 0,0 MENU dcsname,numdcs,10
   READ MENU TO mchoice
ENDD
SET CONF OFF
release window showdct
m.&_var=LEFT(dcsname(mchoice),1)
KEYB CHR(13)

************************************
Func HlpDct
************************************
select codefile
SET ORDER TO TAG 0
LOCA FOR varname='DCTY'
DIME dcsname[10]
numdcs = 0
DO WHIL varname = 'DCTY'
	numdcs=numdcs+1
	dcsname(numdcs)=LEFT(code,1)+' ' + TRIM(name)+'  '
	skip
ENDD
DIME dcsname(numdcs)
mchoice=0
SET CONF ON
define window showDCt from 5,20 to 15,60 none shadow

activate window showdct
DO WHIL mchoice=0
   @ 0,0 MENU dcsname,numdcs,10
   READ MENU TO mchoice
ENDD
SET CONF OFF
release window showdct
m.&_var=LEFT(dcsname(mchoice),1)
KEYB CHR(13)

********************************
