parameter vname
DIME tempicd(100),tempname(100)
on key label F1 ??chr(7)
set talk off
lastwin=wlast()
oldarea=select()
finish = .F.
do case
case  substr(vname,1,2)='DR' OR substr(vname,1,6)='DOCTOR' OR substr(vname,1,7)='MDOCTOR'
		SELE doctor
		SET FILT TO ! EMPTY(name)
		DO SearchHelp
		m.&vname=DOCTOR
		SET FILT TO
		KEYB CHR(13)
		finish = .T.
case  substr(vname,1,5)='PTTYP'
		SELE social
		SET ORDER TO 1
		DO SearchHelp
		m.&vname=class
		KEYB CHR(13)
		finish = .T.
case substr(vname,1,4)='WARD'
		SELE WARD
		set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		DO SearchHelp
		m.&vname=clinic
		SET FILT TO
		KEYB CHR(13)
		finish = .T.
case substr(vname,1,6)='CLINIC' OR substr(vname,1,7)='MCLINIC'
		SELE clinic
		set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		DO SearchHelp
		m.&vname=clinic
		KEYB CHR(13)
		finish = .T.
case substr(vname,1,3)='DEP'
		SELE WARD
		set filter to subst(clinic,3,1) = ' '  .AND. ! EMPTY(name)
		DO SearchHelp
		m.&vname=clinic
		KEYB CHR(13)
		finish = .T.
case substr(vname,1,6)='HOSPTY'
	vsearch='XXXX'
case substr(vname,1,5)='CAUSE' .OR. substr(vname,1,8)='OUTCAUSE'
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
		RETU
case substr(vname,1,5)='PLACE' .OR. substr(vname,1,8)='OUTPLACE'
		SELE hospcode
		_seek=ProvPop(0,30)
		_seek1=HospType()
		_seek=_seek+STR(_seek1,1)
		=FindHosp(_seek)
		m.&vname=code
		KEYB "{ENTER}"
		on key label F1 do mhelp with varread()
		finish = .T.
otherwise
	vsearch=vname
endcase
SET FILT TO
IF finish
	on key label F1 do mhelp with varread()
	RETU
ENDI
if used('codefile')
	select codefile
else
	sele 25
	dbfuse = ipddir+'lib\codefile'
	use (ipddir+'lib\codefile') order tag code
	dbfuse = ''
endif
if wexist('helpwin')
	activate window helpwin
	clear
else
	define window helpwin from 5,10 to 15,63 shadow none
	define popup helppop from 0,0 to 10,52 margin prompt field rtrim(code)+' '+name color n/w
endif
set order to tag varname

if !seek(substr(vsearch,1,4))
	? chr(7)+chr(7)
	wait 'ไม่มีตัวเลือกอยู่ในระบบ' window timeout 1
	deactivate window helpwin
	on key label F1 do mhelp with varread()
	select (oldarea)
	return 0
endif
set filter to varname=substr(vsearch,1,4)
set order to tag code
activate window helpwin
choice2=''
@ 0,0 get choice2 popup helppop
keyboard "{HOME}"
READ NOLOCK

x=at(' ',choice2,1)

if substr(vname,1,8)='OPERATE('
	&vname=substr(choice2,1,x-1)
else
	m.&vname=substr(choice2,1,x-1)
endif
clear
release window helpwin

if substr(vname,1,8)='OPERATE('
	show get &vname
else
	show get m.&vname
endif

set filter to
keyboard '{Enter}'
on key label F1 do mhelp with varread()
select (oldarea)
return 1