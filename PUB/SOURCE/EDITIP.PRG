************************** proc EDITIP*****************
***							ผู้ป่วยใน
***				โปรแกรม ส่วนที่ 2 สำหรับแก้ไขข้อมูลผู้ป่วยใน
***				   การใช้งาน เรียกจากโปรแกรม IPD
***						ALFA VERSION 1.5
***							ตุลาคม 2536
****************************              ******************
***
ON KEY LABEL CTRL+S SUSP
SET ESCA OFF
SET DELETED ON
SET UDFPARMS to REFERENCE
EXTERNAL ARRAY Tmonth
#define numdiag 12
#define numoper 12
entrydateadm = .T.
on key label F1 do ipdhelp with varread()
*on key label F3 do disprec
my = CE2BE(DATE())
my=SUBS(my,4,2)+RIGHT(my,2)
mm=left(my,2)
yy=RIGHT(my,2)
col=Center(mhosp_name)
diag0='adfe'
oper0='adfe'
@ 0,col SAY mhosp_name color gr+/
col=center('แก้ไขข้อมูลการรักษาผู้ป่วยใน ')
@ 1,col say 'แก้ไขข้อมูลการรักษาผู้ป่วยใน '
@ 3,0 clear to 20,79
@ 22,0 clear to 24,79
@ 3,0
DO OpenFile1

@ 3,2 say 'AN'
@ 3,11 say '/'
@ 3,15 say 'HN'
@ 3,26 say 'ชื่อ'
@ 3,68 say 'อายุ'
@ 4,0 say replicate('-',80)
@ 5,1 say 'สิทธิการรักษา'
@ 5,18 say 'Ward : '
@ 5,29 say 'วัน admit'
@ 5,47 say 'วัน D/C'
@ 5,63 say 'เวลา D/C'
@ 6,1 say 'โรค 1'
@ 6,70 SAY 'ประเภท'
@ 7,1 say '    2'
@ 7,70 SAY 'ประเภท'
@ 8,1 say '    3'
@ 8,70 SAY 'ประเภท'
@ 9,1 say '    4'
@ 9,70 SAY 'ประเภท'
@ 10,1 say 'ผ่า 1'
@ 11,1 say 'เริ่ม           เวลา        เสร็จ           เวลา         ผ่าโดย'
@ 12,1 say '   2'
@ 13,1 say 'เริ่ม           เวลา        เสร็จ           เวลา         ผ่าโดย'
@ 14,1 say '   3'
@ 15,1 say 'เริ่ม           เวลา        เสร็จ           เวลา         ผ่าโดย'
@ 16,1 say '   4'
@ 17,1 say 'เริ่ม           เวลา        เสร็จ           เวลา         ผ่าโดย'
@ 18,0 say replicate('-',80)
@ 19,2 say 'นน. Admit'
@ 19,27 say 'กก. (ทารกแรกเกิด ให้ใส่น้ำหนักเมื่อคลอด)'
@ 20,2 say 'D/C Status'
@ 20,17 say 'D/C Type'
@ 20,30 say 'แพทย์'
*@ 20,65 say 'การนัด'
@ 22,12 say '              [ESC] = เสร็จสิ้นการลงข้อมูล'

dimension smenu(3)
smenu(1)=padc('บันทึกการแก้ไข',18,' ')
smenu(2)=padc('แก้ไข',18,' ')
smenu(3)=padc('ลบรายการนี้',18,' ')
sitem=3
STOR SPACE(2) TO outcause
STOR SPACE(4) TO outtime
STOR SPACE(5) TO outplace
STOR SPACE(25) TO referoutplace
SELE death_yr
SCAT TO death BLANK
select INP
go top
First=Recno()
go bott
Last=Recno()
scatter memvar
man=m.AN

m.annum=space(5)
m.anyy=space(2)
m.an1=space(7)
m.hn=space(9)
m.ward=space(3)
m.name=space(36)
m.age=space(5)
m.DATEA='  /  /  '
m.DATED='  /  /  '
m.TIMED=space(4)
m.doc=space(6)
m.pt=space(2)
m.app='N'
M.ADM_W=0.000

store space(60) to mdiag0,moper0
store ' ' to dcstatus, dctype, dxtype2, dxtype3, dxtype4
store space(25) to mdr
STOR SPACE(2) TO outcause
STOR SPACE(4) TO outtime
STOR SPACE(5) TO outplace
STOR SPACE(25) TO referoutplace
FOR i = 1 TO numdiag
	x = LTRIM(STR(i))
	STOR SPACE(60) TO diag&x, dxtype&x, mdiag&x
NEXT
FOR i = 1 TO numoper
	x = LTRIM(STR(i))
	STORE SPACE(60) TO moper&x, oper&x
	STORE SPACE(6) TO surg&x
	STORE SPACE(25) TO msurg&x
	STORE '  /  /  ' to dateop&x, dateout&x
	STORE SPACE(4) TO timein&x, timeout&x
NEXT
STOR '1' TO m.dxtype1
do getvar with m.man

******** Entry loop *********
do while .t.
	@ 22,4 say 'PgUp,PgDn = เลื่อน Record    ESC = กลับรายการหลัก (No Save)      '
	firstfield = .T.
	do dispvar
		READ NOLOCK
	m.man = m.an

	define window asksave from 5,2 to 9,78 shadow

	do case

	case readkey()=12 or readkey()=268 		&& Esc
		IF firstfield
			wait 'ยกเลิกการแก้ไขข้อมูลตามต้องการ' window timeout 1
			release window asksave
			exit
		ENDI
	case readkey()=6				&& PgUp -no change
		do SkipUp
*		keyboard '{Enter}+{Enter}'
		loop
	case readkey()=262				&& PgUp with change
		?? chr(7)
		sav='Y'
		activate window asksave
		@ 1,3 say 'มีการแก้ไขข้อมูล  Save ก่อนหรือไม่  (Y/N)'
		@ 1,50 get sav picture 'Y'
		READ NOLOCK
		DEAC WIND asksave
		if upper(sav)='Y'
			do saveedit
		endif
		deactivate window asksave
		do skipup
		loop
	case readkey()=7				&& PgDn -no change
		do SkipDown
		loop
	case readkey()=263				&& PgDn with change
		?? chr(7)
		sav='Y'
		activate window asksave
		@ 1,3 say 'มีการแก้ไขข้อมูล  Save ก่อนหรือไม่  (Y/N)'
		@ 1,50 get sav picture 'Y'
		READ NOLOCK
		if upper(sav)='Y'
			do saveedit
		endif
		deactivate window asksave
		do skipdown
		loop
	case readkey()=2				&& Home -no change
		do GoFirst
		loop
	case readkey()=258				&& Home with change
		?? chr(7)
		sav='Y'
		activate window asksave
		@ 1,3 say 'มีการแก้ไขข้อมูล  Save ก่อนหรือไม่  (Y/N)'
		@ 1,50 get sav picture 'Y'
		READ NOLOCK
		if upper(sav)='Y'
			do saveedit
		endif
		deactivate window asksave
		do GoFirst
		loop
	case readkey()=3				&& End -no change
		do GoLast
		loop
	case readkey()=259				&& End with change
		?? chr(7)
		sav='Y'
		activate window asksave
		@ 1,3 say 'มีการแก้ไขข้อมูล  Save ก่อนหรือไม่  (Y/N)'
		@ 1,50 get sav picture 'Y'
		READ NOLOCK
		if upper(sav)='Y'
			do saveedit
		endif
		deactivate window asksave
		do GoLast
		loop
	case readkey()=270				&& Ctrl-W, Ctrl-End
		do saveedit
		DO initvar
		release window asksave
		exit
	endcase

	define window ask from 21,0 to 23,79 shadow
	activate window ask
	for i=1 to sitem
		@ 0,(i-1)*18+2 prompt smenu(i)
	endfor
	menu to SChoice
	do case
		case SChoice=1
			do saveedit
			DEFINE WIND IPDChrg FROM 10,10 TO 14,70 SHAD
			ACTI WIND IPDChrg
			goon1='N'
			CLEA
			@ 1,3 SAY 'ต้องการป้อนข้อมูลค่าใช้จ่ายหรือไม่  ' GET goon1 PICT '!'
			READ
			RELE WIND
			IF goon1='Y'
				DO EditCHRG WITH .T.
			ENDI
			do initvar
			release window ask
		case SChoice=2 .OR. Schoice = 0
			release window ask
		case SChoice=3
			?? CHR(7)
			CLEA
			firmdel = 'N'
			@ 0,1 SAY 'ต้องการลบแน่จริงหรือ ลบข้อมูลค่ารักษาด้วยนะ' GET firmdel PICT '!'
			READ NOLOCK
			IF firmdel = 'Y'
				DO dele_ip
			ENDI
			release window ask
	endcase

enddo
*wait '' window
on key label F1
*on key label F3
return

*********************
PROC EDITCHRG
*********************
PARA _new
*DEAC WIND ALL
define window editchrg from 03,0 to 20,79 shadow
activate window editchrg
@3,0 TO 20,80 clea
do editchrg_screen           && search parag 5000
do entry_editchrg            && search parag 6000
rele window editchrg
***---------------------   5000   ----------------
proc editchrg_screen
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
PROC ENTRY_editchrg
Para _AN
fromin = PROGRAM(3) = 'IN_inchrg'
* ON KEY LABEL CTRL+P DO PrintStatus
* ON KEY LABEL ALT+C DO Showcalendar WITH mdateappo
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
sele dtpd
SET ORDER TO TAG an
IF seek(m.an)
	DO WHIL an = m.an
		mcitem = sv_id
		do case
			case mcitem = "0A"
				m01 = AMT
				skip+1
			case mcitem = "0B"
				m02 = AMT
				skip+1
			case mcitem = "0C"
				m03 = AMT
				skip+1
			case mcitem = "0D"
				m04 = AMT
				skip+1
			case mcitem = "0E"
				m05 = AMT
				skip+1
			case mcitem = "0F"
				m06 = AMT
				skip+1
			case mcitem = "0G"
				m07 = AMT
				skip+1
			case mcitem = "0H"
				m08 = AMT
				skip+1
			case mcitem = "0I"
				m09 = AMT
				skip+1
			case mcitem = "0J"
				m010 = AMT
				skip+1
		endc
		enddo
	endif
@ 3,34 say m01 COLO ,,,,,,,,,/w
@ 4,34 say m02 COLO ,,,,,,,,,/w
@ 5,34 say m03 COLO ,,,,,,,,,/w
@ 6,34 say m04 COLO ,,,,,,,,,/w
@ 7,34 say m05 COLO ,,,,,,,,,/w
@ 8,34 say m06 COLO ,,,,,,,,,/w
@ 9,34 say m07 COLO ,,,,,,,,,/w
@ 10,34 say m08 COLO ,,,,,,,,,/w
@ 11,34 say m09 COLO ,,,,,,,,,/w
@ 12,34 say m010 COLO ,,,,,,,,,/w
read nolock
m.sum =m01+m02+m03+m04+m05+m06+m07+m08+m09+m010
@ 13,34 SAY m.sum COLO /w
@ 14,34 GET m.paid COLO /w
@ 15,20 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET m.correct WHEN Clearkey()DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
READ NOLOCK
=ClearKey()
********************************** ถ้ามีข้อมูลค่ารักษาบันทึกใน rcpd,dtpd,creditpd
anedit = m.an
sele creditpd
if seek(anedit)
scatter memvar
m.Rc_no = Rc_no
	GATH MEMV
	FLUSH
endif

sele RcPd
if seek(anedit)
scatter memvar
m.date = datedsc
m.total = m.sum
m.paid = m.paid
	GATH MEMV
	FLUSH
endif
sele dtpd
if !seek(anedit)
n = 1
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
		DO WHIL !empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD

		gather memvar
		FLUSH
		UNLOCK ALL
	n = n+1
endif
ENDD
else
DO WHIL SEEK(anedit)
	replace RC_NO with space(10),SV_ID with space(2), AMT with 0,AN with space(9)
ENDD
FLUSH
n = 1
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
		DO WHIL !empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD

		gather memvar
		FLUSH
		UNLOCK ALL
	n = n+1
endif
ENDD
endif

********************************
PROC INITVAR
********************************
select INP
scatter memvar blank
select patient1
scatter memvar blank

m.annum=space(5)
m.anyy=space(2)
m.hn=space(9)
m.ward=space(3)
m.name=space(36)
m.age=space(5)
m.DATEA='  /  /  '
m.DATED='  /  /  '
m.TIMED=space(4)
*m.doc=space(6)
m.pt=space(2)
m.app='N'

store space(60) to mdiag0,moper0
store ' ' to dcstatus, dctype, dxtype2, dxtype3, dxtype4
store space(25) to mdr
STOR SPACE(2) TO outcause
STOR SPACE(4) TO outtime
STOR SPACE(5) TO outplace
STOR SPACE(25) TO referoutplace
FOR i = 1 TO numdiag
	x = LTRIM(STR(i))
	STOR SPACE(60) TO diag&x, dxtype&x, mdiag&x
NEXT
FOR i = 1 TO numoper
	x = LTRIM(STR(i))
	STORE SPACE(60) TO moper&x, oper&x
	STORE SPACE(6) TO surg&x
	STORE SPACE(25) TO msurg&x
	STORE '  /  /  ' to dateop&x, dateout&x
	STORE SPACE(4) TO timein&x, timeout&x
NEXT

store space(25) to mDr
STOR SPAC(1) TO m.dcstatus,m.dctype
SELE death_yr
SCAT TO death BLAN
********************************
Function ChkAN
********************************
Para _an
IF EMPTY(_an) .OR. _an = '00000'
	RETU TO IPD
ENDI
firstfield = .F.
_an=padl(alltrim(_an),5,'0')
m.an1=_an
@ 3,6 say m.an1
@ 22,4 say 'PgUp,PgDn = เลื่อน Record    ESC = เมื่อแก้ไขส่วนที่ผิดเสร็จแล้ว'
return

***********************************
	Function ChkAdm_W
***********************************
	dAdmit = BE2CE(m.datea)
	dBirth = Lookup(Patient1.BirthDay,alltrim(m.HN),Patient1.HN,"HN")
	IF ! Empty(dBirth) and ! Empty(dAdmit) and ;
		dBirth > gomonth(dAdmit,-12) and Empty(m.Adm_W)
		?? Chr(7)
		WAIT WIND " ผู้ป่วยอายุต่ำกว่า 1 ปี ต้องบันทึกน้ำหนักแรกรับด้วย " NOWAIT
		_Curobj = ObjNum(m.Adm_W)
		Return
	ELSE
		IF m.Adm_W > 500
			?? Chr(7)
			WAIT WIND " ใครจะน้ำหนักมากขนาดนั้น ลองตรวจสอบอีกครั้ง " NOWAIT
			_Curobj = ObjNum(m.Adm_W)
			Return
		ENDI
	ENDI

***********************************
Function CheckAN
***********************************
Para _an, _anyy
*susp
IF EMPTY(_anyy)
	=ALARM1()
	_CUROBJ = _CUROBJ
	RETU
ENDI
*susp
private XAN
	XAN=_anyy+padl(alltrim(_an),5,'0')
	m.man=XAN
SELE admyear
*IF _anyy # yy	&& ตรวจสอบการเปิดแฟ้มให้ถูกต้อง
	infile=ipddir+'\data\ADM'+_anyy
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
	USE (infile) ORDER 1 ALIA ADMyear
*ENDI
dbfuse = ''
SET ORDER TO TAG an
*** udc
IF !seek(XAN)
	anyy = Val(_anyy)+1
	infile=ipddir+'data\ADM'+Alltrim(Str(anyy))
	USE
	dbfuse = infile
	IF ! FILE(infile+'.dbf')
		CREATE TABLE (infile) ;
		(HN C(7),AN C(7),PTTYP C(2),DEP C(2),WARD_ADM C(3),DATEADM D,;
		TIMEADM C(4),WARD_NOW C(3),DATE_NOW D,TIME_NOW C(4),BED_NO C(2),;
		BED_TYPE C(1),TRANSFER L,DATEDSC D,TIMEDSC C(4),DISC C(4),;
		DR C(6),SENT L,DX_STAT L,PLACE C(5),CAUSE C(2),ONSET N(2),ADM_W N(7,3))
		INDEX ON an TAG an
		INDEX ON hn TAG hn ADDI
	ENDI
	USE (infile) ORDER 1 ALIA ADMyear
	dbfuse = ''
ENDI
*** udc
IF ! SEEK(xan)
	=TONE(1200,5)
	=TONE(700,5)
	WAIT WIND 'ยังไม่เคยลงข้อมูล AN นี้เลย' NOWA
	_CUROBJ = 1
	firstfield = .T.
ELSE
	_datedsc = CE2BE(datedsc,2)
	mm1 = SUBS(_datedsc,4,2)
	yy1 = RIGHT(_datedsc,2)
*	IF mm#mm1 .OR. yy#yy1
		mm = mm1
		yy = yy1
		DO OpenFile1
*	ENDI
	select inp
	if !seek(XAN)
		=TONE(1200,5)
		=TONE(700,5)
		wait 'ไม่พบ AN นี้ในแฟ้ม Admit' window timeout 1
		firstfield = .T.
		_curobj=1
	ELSE
		scatter memvar
		do getvar with m.man
		SHOW GETS
	ENDI
ENDI

*******************************
Procedure getvar
*******************************
Para _AN

store space(60) to oper1,oper2,oper3,oper4
store '  /  /  ' to dateop1, dateop2, dateop3, dateop4, dateout1, dateout2, ;
dateout3, dateout4
store space(6) to surg1, surg2, surg3, surg4
store space(60) to diag1, diag2, diag3, diag4
store space(60) to mdiag1, mdiag2, mdiag3, mdiag4, moper1, moper2, moper3, moper4,mdiag0,moper0
store ' ' to dcstatus, dctype, dxtype2, dxtype3, dxtype4
store space(25) to mdr, msurg1,msurg2,msurg3,msurg4
STOR SPACE(2) TO outcause
STOR SPACE(4) TO outtime, timein1, timein2, timein3, timein4, timeout1, ;
timeout2, timeout3, timeout4, timedsc
STOR SPACE(5) TO outplace
STOR SPACE(25) TO referoutplace
STOR '1' TO m.dxtype1

m.annum=substr(_AN,3)
m.anyy=substr(_AN,1,2)
select inp
seek(_AN)
scatter memvar
m.mHN=m.HN
m.mTimedsc=m.TIMEDSC
m.dcstatus=substr(DISC,1,1)
m.dctype=substr(DISC,2,1)

select patient1
SET ORDER TO TAG hn
seek(m.mHN)
scatter memvar
m.name = DE_NAME(name)
m.hn = m.mhn
SELE doctor
SET ORDER TO TAG doctor
SEEK m.dr
m.mdr = LEFT(name,30)
select DIAGNOSIS
IF seek(_AN)
	scatter memvar
	numd = 0
	DO WHIL an = m.an
		numd = numd+1
		x = LTRIM(STR(numd))
		m.diag&x = diag
		m.dxtype&x = dxtype
		SELE icd101
		SEEK m.diag&x
		m.mdiag&x = LEFT(desc,60)
		m.diag&x = SHOWICD(m.diag&x)
		sele diagnosis
		SKIP
	ENDD
ENDI
select OPERATION
IF seek(_AN)
	scatter memvar
	m.dateop1=ce2be(m.dateop,2)
	m.surg1=m.surgeon
	numop = 0
	DO WHIL an = m.an
		numop = numop + 1
		x = LTRIM(STR(numop))
		m.oper&x = op
		m.surg&x = surgeon
		m.dateop&x = CE2BE(dateop,2)
		m.dateout&x = CE2BE(dateout,2)
		m.timein&x = timein
		m.timeout&x = timeout
		SELE icdcm1
		SET ORDER TO 1
		SEEK TRIM(m.oper&x)
		m.moper&x = LEFT(desc,50)
		SELE doctor
		SEEK m.surg&x
		m.msurg&x = LEFT(name,30)
		SELE operation
		skip +1
	ENDD
ENDI
SELE death_yr
SCAT TO death BLAN
IF m.dcstatus $ '89'
	IF SEEK(_an)
		SCAT TO death
	ENDI
ENDI
m.ward=m.ward_dsc
m.age=NOWAGE(m.Birthday,m.derive)
m.DATEA=ce2be(m.DATEADM,2)
m.DATED=ce2be(m.DATEDSC,2)
m.TIMED=m.TIMEDSC
m.pt=m.PTTYP
m.app='N'
SELE refer
SET ORDER TO TAG an
IF SEEK(_an)
	outtime = time
	outplace = place
	outcause = cause
	SELE hospcode
	SEEK outplace
	referoutplace = DE_NAME(name)
ENDI

*****************************
Func V_mon
*****************************
Para _mm

if !between(val(_mm),1,12)
	??chr(7)
	wait 'Invalid input' window timeout 0.5
	_curobj=_curobj
else
	@ 1,13 say tmonth(val(_mm))+' '
endif

*****************************
Procedure SaveEdit
*****************************
m.datedsc=be2ce(m.dated)
m.timedsc=m.timed
m.dateadm=be2ce(m.datea)
old_disc=m.disc
m.disc=m.dcstatus+m.dctype
m.adm_w=m.adm_w
SELE refer
IF m.dctype = '4'
	IF ! SEEK(m.an)
		GO TOP
		IF ISDIGIT(an) .OR. BOF()
			APPE BLAN
		ENDI
	ENDI
	m.day = SUBS(m.dated,4,2) + LEFT(m.dated,2)
	m.time = m.outtime
	m.place = m.outplace
	m.cause = m.outcause
	m.diag = m.diag1
	m.ward = m.ward_dsc
	GATH MEMV
	FLUSH
ELSE
	IF SEEK(m.an)
		SCAT TO refer BLANK
		GATH FROM refer
		FLUSH
	ENDI
ENDI
select INP
	gather memvar
	FLUSH

sele admyear
IF	seek( m.an)
	GATHER MEMVAR FIELD disc, datedsc, timedsc, pttyp, dr, adm_w
	FLUSH
ENDI
select DIAGNOSIS
n=0
if empty(diag1)
	?? chr(7)
	wait 'ต้องมีอย่างน้อย 1 Diagnosis' window timeout 1
	_curobj=objnum(diag1)
	return
endif
DO WHIL SEEK(m.an)
	replace AN with space(7), DIAG with space(5)
ENDD
FLUSH
for i=1 to numdiag
	xx = LTRIM(STR(i))
	IF ! EMPTY(diag&xx)
		m.diag = CON_ICD(m.diag&xx)
		m.dxtype = m.dxtype&xx
		if seek(space(7))
			GATHER MEMVAR
			FLUSH
		else
			insert into DIAGNOSIS from memvar
			FLUSH
		endif
	ELSE
		i = numdiag + 1
	ENDI
endfor

select OPERATION
n=0
DO WHIL SEEK(m.an)
	replace AN with space(7), OP with space(5), DATEOP with ctod('  /  /  '), SURGEON with space(5)
ENDD
	FLUSH
	for i=1 to numoper
		xx = LTRIM(STR(i))
		IF ! EMPTY(oper&xx)
			m.dateout = BE2CE(m.dateout&xx)
			m.timein = m.timein&xx
			m.timeout = m.timeout&xx
			m.op = IIF(LEFT(oper&xx,1) = '*', SUBS(oper&xx,2), oper&xx)
			m.dateop = BE2CE(m.dateop&xx)
			m.surgeon = m.surg&xx
			m.optype = IIF( i =1, '1', '2')
			if seek(space(7))
				GATHER MEMV
				FLUSH
			else
				insert into OPERATION from memvar
				FLUSH
			endif
		ELSE
			i = numoper + 1
		ENDI
	endfor
SELE death_yr
SEEK m.an
IF m.dcstatus $ '89'
	IF EOF()
		APPE BLANK
	ENDI
	GATH FROM death
	FLUSH
ELSE
	IF ! EOF()
		SCAT TO death BLAN
		GATH FROM death
		FLUSH
	ENDI
ENDI
release opr
release dop
release sur

*****************************************
Procedure disprec

on key label F1
*on key label F3
set escape off

private all

select INP
go top
top=recno()
go bottom
bott=recno()
go top
do while empty(INP.AN)
	skip +1
enddo
scatter memvar
select patient1
seek(m.HN)
scatter memvar
age=NOWAGE(BIRTHDAY)
man=substr(m.AN,3)+'/'+substr(m.AN,1,2)

define window test from 5,1 to 13,78 shadow title ' แอบดู '
activate window test
@ 1,2 say 'AN'
@ 1,15 say 'HN'
@ 2,15 say 'ชื่อ'
@ 2,55 say 'อายุ'
@ 3,15 say 'วัน ADMIT'
@ 3,45 say 'วัน D/C'
@ 4,0 say replicate('-',76)
@ 5,2 say 'F' color w+
@ 5,3 say '=First'
@ 5,18 say 'L' color gr+
@ 5,19 say '=Last'
@ 5,33 say ' PgUp PgDn' color gr+
@ 5,45 say '=Skip'
@ 5,60 say 'X' color gr+
@ 5,61 say '=Exit'

clear typeahead

do while .t.
	@ 1,5 say m.man color gr+
	@ 1,21 say m.hn color gr+
	@ 2,21 say rtrim(m.name) color gr+
	@ 2,63 say m.age color gr+
	@ 3,26 say ce2be(m.DATEADM,2) color gr+
	@ 3,54 say ce2be(m.DATEDSC,2) color gr+
	mkey=inkey(0.5,'H')
	do case
		case mkey=120
			exit
		case mkey=108		&& L
			select INP
			if recno()=bott
				?? chr(7)
				wait 'Already at LAST Record' window timeout 1
				loop
			else
				go bottom
				scatter memvar
				select patient1
				seek(m.HN)
				scatter memvar
				age=NOWAGE(BIRTHDAY)
				man=substr(m.AN,3)+'/'+substr(m.AN,1,2)
				@ 1,5 say space(7)
				@ 1,21 say space(7)
				@ 2,21 say space(34)
				@ 2,65 say space(10)
				loop
			endif
		case mkey=102		&& F
			select INP
			if recno()=top
				?? chr(7)
				wait 'Already at FIRST Record' window timeout 1
				loop
			else
				go top
				scatter memvar
				select patient1
				seek(m.HN)
				scatter memvar
				age=NOWAGE(BIRTHDAY)
				man=substr(m.AN,3)+'/'+substr(m.AN,1,2)
				@ 1,5 say space(7)
				@ 1,21 say space(7)
				@ 2,21 say space(34)
				@ 2,65 say space(10)
				loop
			endif
		case mkey=5 or mkey=18		&& Up,PgUp
			select INP
			if recno()=top
				?? chr(7)
				wait 'Already at FIRST Record' window timeout 1
				loop
			else
				skip -1
				scatter memvar
				select patient1
				seek(m.HN)
				scatter memvar
				age=NOWAGE(BIRTHDAY)
				man=substr(m.AN,3)+'/'+substr(m.AN,1,2)
				@ 1,5 say space(7)
				@ 1,21 say space(7)
				@ 2,21 say space(34)
				@ 2,65 say space(10)
				loop
			endif

		case mkey=24 or mkey=3		&& Dn,PgDn
			select INP
			if recno()=bott
				?? chr(7)
				wait 'Already at LAST Record' window timeout 1
				loop
			else
				skip +1
				scatter memvar
				select patient1
				seek(m.HN)
				scatter memvar
				age=NOWAGE(BIRTHDAY)
				man=substr(m.AN,3)+'/'+substr(m.AN,1,2)
				@ 1,5 say space(7)
				@ 1,21 say space(7)
				@ 2,21 say space(34)
				@ 2,65 say space(10)
				loop
			endif

	endcase
enddo

select INP
set order to tag AN
release window test
on key label F1 do ipdhelp with varread()
*on key label F3 do disprec

**************************************
Procedure SkipUp

select INP
if recno()=First
	?? chr(7)
	wait 'ขณะนี้ อยู่ที่ record แรกนะครับ' window timeout 1
	return
else
	skip -1
	scatter memvar
	do getvar with m.AN
*	@ 3,6 say m.annum
*	@ 3,12 say m.anyy
*	@ 3,21 say m.hn
*	@ 4,21 say m.name
*	@ 4,65 say m.age

endif

**************************************
Procedure SkipDown
select INP
if recno()=Last
	?? chr(7)
	wait 'ขณะนี้ อยู่ที่ record สุดท้ายนะครับ' window timeout 1
	return
else
	skip +1
	scatter memvar
	do getvar with m.AN
*	@ 3,6 say m.annum
*	@ 3,12 say m.anyy
*	@ 3,21 say m.hn
*	@ 4,21 say m.name
*	@ 4,65 say m.age

endif

**************************************
Procedure goFirst
	select INP
	go top
	scatter memvar
	do getvar with m.AN
*	@ 3,6 say m.annum
*	@ 3,12 say m.anyy
*	@ 3,21 say m.hn
*	@ 4,21 say m.name
*	@ 4,65 say m.age

**************************************
Procedure GoLast
	select INP
	go bottom
	scatter memvar
	do getvar with m.AN
*	@ 3,6 say m.annum
*	@ 3,12 say m.anyy
*	@ 3,21 say m.hn
*	@ 4,21 say m.name
*	@ 4,65 say m.age

**************************************
PROC DispVar
	@ 3,6 get m.annum picture '99999' valid ChkAN(m.annum)
	@ 3,12 get m.anyy picture '99' valid CheckAN(m.annum,m.anyy) message 'ปีพุทธศักราช'
	@ 3,18 get m.hn picture '9999999' WHEN entrydateadm VALID ShowHn(m.hn) &&disable COLO ,,,,,,,,,gr+
	@ 3,31 get m.name disable  COLO ,,,,,,,,,gr+
	@ 3,73 get m.age disable COLO ,,,,,,,,,gr+
	@ 5,14 get m.pttyp picture '99' message 'สิทธิการรักษา    F1 = List'
	@ 5,25 get m.ward_dsc picture '999' message 'Ward สุดท้ายก่อนออกจากโรงพยาบาล  F1=List'
	@ 5,38 get m.datea WHEN entrydateadm PICT '99/99/99' VALID TrueDATE(m.datea) && disable COLO ,,,,,,,,,gr+
	@ 5,54 get m.dated pict '99/99/99' valid truedate(m.dated) and BETWEEN(be2ce(m.dated),be2ce(m.datea),date())
	@ 5,72 get m.timed pict '@R ##:##' VALID CheckTime(m.timed) message 'ใส่เวลาที่จำหน่าย'
	@ 6,7 get m.diag1 WHEN EntryICD(m.diag0,m.diag1) VALID CheckICD(m.diag1) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 1' SIZE 1,20
	@ 6,7 get m.mdiag1	disable color ,,,,,,,,,gr+
	@ 6,77 GET m.dxtype1 DISA color ,,,,,,,,,gr+
	@ 7,7 get m.diag2 WHEN EntryICD(m.diag1,m.diag2) VALID CheckICD(m.diag2) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 2' SIZE 1,20
	@ 7,7 get m.mdiag2	disable color ,,,,,,,,,gr+
	@ 7,77 get m.dxtype2 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype2, diag2);
		MESS 'ใส่รหัสว่าเป็น 2 = Comorbidity 3 = Complication หรือ 4 = Other'
	@ 8,7 get m.diag3 WHEN EntryICD(m.diag2,m.diag3) VALID CheckICD(m.diag3) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 3' SIZE 1,20
	@ 8,7 get m.mdiag3	disable color ,,,,,,,,,gr+
	@ 8,77 get m.dxtype3 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype3, diag3);
		MESS 'ใส่รหัสว่าเป็น 2 = Comorbidity 3 = Complication หรือ 4 = Other'
	@ 9,7 get m.diag4 WHEN EntryICD(m.diag3,m.diag4) VALID CheckICD(m.diag4) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 4' SIZE 1,20
	@ 9,7 get m.mdiag4 disable color ,,,,,,,,,gr+ message ' '
	@ 9,77 get m.dxtype4 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype4, diag4);
		MESS 'ใส่รหัสว่าเป็น 2 = Comorbidity 3 = Complication หรือ 4 = Other'
	@ 10,7 get m.oper1 WHEN EntryICD(m.oper0,m.oper1) VALID CheckICD(m.oper1) ;
		MESS 'ใส่รหัสผ่าตัดหรือชื่อการผ่าตัดที่ 1' SIZE 1,20
	@ 10,7 get m.moper1 disable color ,,,,,,,,,gr+ message ' '
	@ 11,8 get m.dateop1 when Entrydateop(m.oper1) picture '##/##/##' ;
	valid Checkdateop(m.dateop1)
	@ 11,23 GET m.timein1 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop1,2)) VALID CheckTime(m.timein1)
	@ 11,36 GET m.dateout1 WHEN ! EMPTY(LEFT(m.dateop1,2)) PICT '##/##/##' ;
	valid Checkdateop(m.dateout1,m.dateop1)
	@ 11,50 GET m.timeout1 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop1,2)) VALID Checktimeout(m.dateop1,m.timein1,m.dateout1,m.timeout1)
	@ 11,68 get m.surg1 when EntryDateOP(m.oper1) picture '######' valid CheckDoctor(m.surg1,m.msurg1) message 'รหัสแพทย์ผู้ผ่าตัด  F1=List'
	@ 11,68 get msurg1 defa space(25) disable color ,,,,,,,,,gr+
	@ 12,7 get m.oper2 WHEN EntryICD(m.oper1,m.oper2) VALID CheckICD(m.oper2) ;
		MESS 'ใส่รหัสผ่าตัดหรือชื่อการผ่าตัดที่ 2' SIZE 1,20
	@ 12,7 get m.moper2 disable color ,,,,,,,,,gr+ message ' '
	@ 13,8 get m.dateop2 when Entrydateop(m.oper2) picture '##/##/##' ;
	valid Checkdateop(m.dateop2)
	@ 13,23 GET m.timein2 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop2,2)) VALID CheckTime(m.timein2)
	@ 13,36 GET m.dateout2 WHEN ! EMPTY(LEFT(m.dateop2,2)) PICT '##/##/##' ;
	valid Checkdateop(m.dateout2,m.dateop2)
	@ 13,50 GET m.timeout2 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop2,2)) VALID Checktimeout(m.dateop2,m.timein2,m.dateout2,m.timeout2)
	@ 13,68 get m.surg2 when EntryDateOP(m.oper2) picture '######' valid CheckDoctor(m.surg2,m.msurg2) message 'รหัสแพทย์ผู้ผ่าตัด  F1=List'
	@ 13,68 get msurg2 defa space(25) disable color ,,,,,,,,,gr+
	@ 14,7 get m.oper3 WHEN EntryICD(m.oper2,m.oper3) VALID CheckICD(m.oper3) ;
		MESS 'ใส่รหัสผ่าตัดหรือชื่อการผ่าตัดที่ 3' SIZE 1,20
	@ 14,7 get m.moper3 disable color ,,,,,,,,,gr+ message ' '
	@ 15,8 get m.dateop3 when Entrydateop(m.oper3) picture '##/##/##' ;
	valid Checkdateop(m.dateop3)
	@ 15,23 GET m.timein3 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop3,2)) VALID CheckTime(m.timein3)
	@ 15,36 GET m.dateout3 WHEN ! EMPTY(LEFT(m.dateop3,2)) PICT '##/##/##' ;
	valid Checkdateop(m.dateout3,m.dateop3)
	@ 15,50 GET m.timeout3 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop3,2)) VALID Checktimeout(m.dateop3,m.timein3,m.dateout3,m.timeout3)
	@ 15,68 get m.surg3 when EntryDateOP(m.oper3) picture '######' valid CheckDoctor(m.surg3,m.msurg3) message 'รหัสแพทย์ผู้ผ่าตัด  F1=List'
	@ 15,68 get msurg3 defa space(25) disable color ,,,,,,,,,gr+
	@ 16,7 get m.oper4 WHEN EntryICD(m.oper3,m.oper4) VALID CheckICD(m.oper4) ;
		MESS 'ใส่รหัสผ่าตัดหรือชื่อการผ่าตัดที่ 4' SIZE 1,20
	@ 16,7 get m.moper4 disable color ,,,,,,,,,gr+ message ' '
	@ 17,8 get m.dateop4 when Entrydateop(m.oper4) picture '##/##/##' ;
	valid Checkdateop(m.dateop4)
	@ 17,23 GET m.timein4 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop4,2)) VALID CheckTime(m.timein4)
	@ 17,36 GET m.dateout4 WHEN ! EMPTY(LEFT(m.dateop4,2)) PICT '##/##/##' ;
	valid Checkdateop(m.dateout4,m.dateop4)
	@ 17,50 GET m.timeout4 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop4,2)) VALID Checktimeout(m.dateop4,m.timein4,m.dateout4,m.timeout4)
	@ 17,68 get m.surg4 when EntryDateOP(m.oper4) picture '######' valid CheckDoctor(m.surg4,m.msurg4) message 'รหัสแพทย์ผู้ผ่าตัด  F1=List'
	@ 17,68 get msurg4 defa space(25) disable color ,,,,,,,,,gr+
	@ 19,12 GET m.adm_w Valid ChkAdm_W() mess 'ใส่น้ำหนักเป็นกิโลกรัม'
	@ 20,13 get m.dcstatus picture '9' WHEN ClearOper() valid ChkDeath(m.dcstatus) message 'สถานะ จำหน่าย       F1 = List'
	@ 20,26 get m.dctype picture '9' valid v_refer() message 'ลักษณะการจำหน่าย      F1 = List'
	@ 20,37 get m.dr WHEN InputDoctor(m.dr) VALID CheckDoctor(m.dr,m.mdr) ;
	MESS 'ใส่รหัสแพทย์ที่ทำการรักษาผู้ป่วย    F1 = List'
	@ 20,45 GET m.mdr defa space(20) DISA COLO ,,,,,,,,,gr+

Procedure dispVar1

	@ 3,6 say m.annum
	@ 3,12 say m.anyy
	@ 3,18 say m.hn
	@ 3,31 say m.name
	@ 3,37 say m.age
	@ 5,14 say m.pttyp
	@ 5,25 say m.ward_dsc
	@ 5,38 say m.datea
	@ 5,54 say m.dated
	@ 5,72 say m.timed
	@ 7,14 say m.diag1
	@ 7,20 say m.mdiag1
	@ 8,14 say m.diag2
	@ 8,20 say m.mdiag2
	@ 9,14 say m.diag3
	@ 9,20 say m.mdiag3
	@ 10,14 say m.diag4
	@ 10,20 say m.mdiag4
	@ 11,14 say m.oper1
	@ 11,20 say m.moper1
	@ 12,23 say m.dateop1
	@ 12,48 say m.surg1
	@ 13,14 say m.oper2
	@ 13,20 say m.moper2
	@ 14,23 say m.dateop2
	@ 14,48 say m.surg2
	@ 15,14 say m.oper3
	@ 15,20 say m.moper3
	@ 16,23 say m.dateop3
	@ 16,48 say m.surg3
	@ 17,14 say m.oper4
	@ 17,20 say m.moper4
	@ 18,23 say m.dateop4
	@ 18,48 say m.surg4
	@ 19,12 say m.adm_w
	@ 20,13 say m.dcstatus
	@ 20,26 say m.dctype
	@ 20,36 say m.DR
*	@ 20,73 say m.app

*********************
PROC DELE_IP
*********************
andel = m.an
SELE inp
	if seek(andel)
		scat memv blank
		gath memv
		FLUSH
	endif
SELE diagnosis
	DO WHIL seek(andel)
		scat memv blank
		gath memv
		FLUSH
	enddo
SELE operation
	DO WHIL seek(andel)
		scat memv blank
		gath memv
		FLUSH
	enddo
SELE death_yr
	if seek(andel)
		scat memv blank
		gath memv
		FLUSH
	endif
SELE RCPD
	if seek(andel)
		scat memv blank
		gath memv
		FLUSH
	endif
SELE DTPD
	if seek(andel)
		scat memv blank
		gath memv
		FLUSH
	endif
SELE CREDITPD
	if seek(andel)
		scat memv blank
		gath memv
		FLUSH
	endif
DO initvar