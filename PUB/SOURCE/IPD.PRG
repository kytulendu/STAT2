**** 					ระบบงานเวชระเบียน
*** 	ระบบงานย่อยที่ 4 งานผู้ป่วยใน ประกอบด้วยงาน
***			- บันทึกข้อมูลด้านคลีนิกผู้ป่วยใน
***			- บันทึกข้อมูลการเงินผู้ป่วยประกันสังคม
***			- บันทึกข้อมูลการส่งต่อผู้ป่วยใน
***			- บันทึกข้อมูลสาเหตุการตาย
***			- จัดทำแฟ้มรายงานส่งส่วนกลาง
***		    - พิมพ์ รง.505
***
***		แฟ้มข้อมูลหลัก ที่ใช้ มี 5 แฟ้มใน subdirectory data\ ดังนี้
***			1. แฟ้ม INyymm สำหรับเก็บข้อมูลการรับ,จำหน่ายผู้ป่วยในรายเดือน
***			2. แฟ้ม DIAGyymm สำหรับเก็บข้อมูลคลีนิก
***			3. แฟ้ม OPERyymm สำหรับเก็บข้อมูลการผ่าตัดและหัตถการ
***		    4. แฟ้ม DEATHyy สำหรับเก็บสาเหตุการตาย
***         5. แฟ้ม REFERyy สำหรับเก็บข้อมูลการส่งต่อผู้ป่วยใน
***
***		หรินทร์ เพิ่มเติม
***			6. แฟ้ม CHAyymm สำหรับเก็บข้อมูลรายละเอียดค่ารักษา
***			7. แฟ้ม CHTyymm สำหรับเก็บข้อมูลค่ารักษา
***
***		แฟ้มข้อมูลที่ใช้ร่วม มี 6 แฟ้ม ดังนี้
***	แฟ้ม \pub\patient1.dbf, data\iptrana.dbf, data\iptrans.dbf
***		\opd\appoin.dbf, \pub\doctor, \pub\clinic
***	procedure ที่ใช้ร่วม คือ procedure utility
***	MEMO ที่ใช้ร่วม คือ \PUB\OPDLAN กำลังคิดว่าจะรวมกันให้ได้
***
***           	ALPHA VERSION  ก.ค. 2536
***************************************************************
**						*  โปรแกรม  IPD  *                   **
***************************************************************
PARA _pass
*ON ERROR
PRIV Userright
NotUsePass = PARAMETER() = 1 .AND.  _pass
IF ! NotUsePass
	Userright = GetUser()
	cando = ('SUP' $ userright .OR. 'I' $ userright)
	IF ! cando
		=ALARM1()
		WAIT WIND NOWA 'เสียใจ ! คุณไม่มีสิทธิทำงานผู้ป่วยใน'
		RETU
	ENDI
ENDI
*STATINPUT = UPPE(geten('workstation')) = 'STAT'
mhosp_name=LTRIM(TRIM(hosp_name))
@ 2,0 SAY REPL('-',80)
@ 21,0 SAY REPL('-',80)
col=Center(mhosp_name)
@ 0,col SAY mhosp_name color gr+/
DISP_DATE=CE2CBE(DATE())
@ 1,0
@ 1,2 SAY DISP_DATE

PRIVAT mm,yy,annum,anyy,hn,ward,name,age,datea,dated,timed,dr,pt,app,dcstatus,dctype
PRIVAT diag1,diag2,diag3,diag4,oper1,oper2,oper3,oper4,surg1,surg2,surg3,surg4
PRIVAT dateop1,dateop2,dateop3,datep4,dead1,dead2,dead3
PRIVAT mdiag1,mdiag2,mdiag3,mdiag4,moper1,moper2,moper3,moper4,mdead1,mdead2,mdead3
PRIVAT mdr,msurg1,msurg2,msurg3,msurg4
PRIVAT array death(6)
PRIVAT an1,man,pttyp
PRIVAT First,Last,ColSpace,NumLevel,ChMain
DIME IpLevel(6),IpMenuMess(6)

mdate=CE2BE(DATE())
yy=RIGHT(mdate,2)
mm=SUBS(mdate,4,2)
CLOSE DATA
do mainscr
@2,0 SAY REPL('-',80)
do openfile
DO OpenFile1

IpMenuMess(1)='บันทึกข้อมูลการรักษาผู้ป่วยใน'
IpMenuMess(2)='แก้ไขข้อมูลการรักษาผู้ป่วยใน'
IpMenuMess(3)='ทำรายงานต่าง ๆ'
IpMenuMess(4)='กลับไปสู่รายการหลัก มีปัญหาติดต่อศูนย์คอมพิวเตอร์ FAX.5918630'
IpLevel(1)= padc('บันทึก',14,' ')
IpLevel(2)= padc('แก้ไข',14,' ')
IpLevel(3)= padc('ส่งรายงาน',14,' ')
IpLevel(4)= padc('เมนูหลัก',14,' ')
NumLEVEL=4             && จำนวนรายการหลัก
CoLSpace=17

do whil .t.
	UNLOCK ALL
   xx=1
   @2,0 SAY REPL('-',80)
   @21,0 SAY REPL('-',80)
	@ 1,0
	@ 1,4 SAY CE2CBE(DATE())
   DO Title WITH 'บันทึกข้อมูลการรักษาผู้ป่วยใน'
   DO WHIL xx<=NumLEVEL
      @ 22,1+ColSpace*(xx-1) PROMPT IpLevel(xx) MESSAGE IpMenuMess(xx)
      xx=xx+1
   ENDD
   MENU TO ChMain
   DO CASE
   	  CASE ChMain=0
   	  	  ChMain=numlevel
      CASE ChMain=1
          do AddIP
      CASE ChMain=2
          do EditIP
      CASE ChMain=3
      		DO Closefile1
      	  do Irp_menu  && C_Rep
			mdate=CE2BE(DATE())
			yy=RIGHT(mdate,2)
			mm=SUBS(mdate,4,2)
			DO Openfile1
      CASE ChMain=4
		IF NotUsePass
			CLOSE DATA
			CANC
		ENDI
          exit
   ENDC
   @ 1,0 to 1,80 clear
   @ 3,0 to 20,80 clear
   @ 22,0 to 24,80 clear
   do mainscr
endd
close database
ON KEY
RETURN

********************************
Procedure OpenFile

dbfuse = patientdir+'patient1'
USE (patientdir+'patient1') ORDER 1 IN 0
dbfuse = ipddir+'data\iptrana'
USE (ipddir+'data\iptrana') ORDER TAG AN IN 0
dbfuse = patientdir+'medrec'
use (patientdir+'medrec') alias medrec IN 0
dbfuse = codedir+'doctor'
use (codedir+'doctor') order 1 IN 0
dbfuse = codedir+'social'
USE (codedir+'social') ORDER 1 IN 0
dbfuse = codedir+'ward'
USE (codedir+'ward') ORDER 1 IN 0
dbfuse = codedir+'icd101'
USE (codedir+'icd101') ORDER 1 IN 0
dbfuse = codedir+'icd102'
USE (codedir+'icd102') ORDER 1 IN 0
dbfuse = codedir+'icd103'
USE (codedir+'icd103') ORDER 1 IN 0
dbfuse = codedir+'icdcm1'
USE (codedir+'icdcm1') ORDER 1 IN 0
dbfuse = codedir+'icdcm2'
USE (codedir+'icdcm2') ORDER 1 IN 0
dbfuse = codedir+'icdcm3'
USE (codedir+'icdcm3') ORDER 1 IN 0
dbfuse = ipddir+'lib\codefile'
USE (ipddir+'lib\codefile') IN 0
dbfuse = codedir+'hospcode'
USE (codedir+'hospcode') ORDER 1 IN 0
dbfuse = ''

PROC OPENFILE1
IF USED('INP')
	SELE inp
	use
ENDI
	sele 0
	target=ipddir+'data\IN'+yy+mm+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (HN c(7), AN C(7), WARD_DSC C(3), DATEADM D, ;
		TIMEADM C(4), DATEDSC D,TIMEDSC C(4), ;
		DISC C(2),PTTYP C(2), DR C(6), PLACE C(5), ADM_W N(7,3))
			index on AN tag AN
	endif
	use (target) alias INP
	set order to tag AN
	dbfuse = ''
IF USED('DIAGNOSIS')
	SELE diagnosis
	use
ENDI
	sele 0
	target=ipddir+'data\DIAG'+yy+mm+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (AN C(7), DIAG C(7), DXTYPE C(1))
			index on AN tag AN
	endif
	use (target) alias DIAGNOSIS
	dbfuse = ''
	set order to tag AN
IF USED('OPERATION')
	SELE operation
	USE
ENDI
	sele 0
	target=ipddir+'data\OPER'+yy+mm+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (AN C(7), OP C(7), OPTYPE C(1), DATEOP D, ;
		TIMEIN C(4), DATEOUT D, TIMEOUT C(4), SURGEON C(6))
			index on AN tag AN
	endif
	use (target) alias OPERATION
	set order to tag AN
IF USED('REFER')
	SELE refer
	USE
ENDI
	sele 0
	target=ipddir+'data\REFER'+yy+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (AN C(7), DAY C(4), TIME C(4), PLACE C(5), DIAG C(7),;
		CAUSE C(2), WARD C(3), TYPE C(1))
			index on AN tag AN
	endif
	use (target) alias REFER
    set order to tag AN
IF USED('DEATH_YR')
	SELE death_yr
	use
ENDI
	sele 0
	target=ipddir+'data\DEATH'+yy+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (HOSPCARE C(5), HN C(7), AN C(7), ICD10 C(7), CAUSE1 C(7),;
		CAUSE2 C(7))
			index on AN tag AN
	endif
	use (target) alias DEATH_YR
	set order to tag AN
IF USED('SS')
	SELE ss
	USE
ENDI
	sele 0
	target=ipddir+'data\SS'+yy+mm+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (AN C(9), LABC N(7), BLDBC N(7), PATHC N(7), XRAYC N(7),;
		INVTC N(7), OPRNC N(7), PROSC N(7), ANESC N(7), DRUGC N(7), REHBC N(7),;
		THERC N(7), ICUC N(7), ACCOC N(7), VHCLC N(7), PARTY N(7), PAID N(7))
			index on AN tag AN
	endif
	use (target) alias SS
	set order to tag AN

********เพิ่มตรงนี้********
IF USED('RCPD')
	SELE RCPD
	use
ENDI
	sele 0
	target=billdir+'all\rcpd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (RC_NO C(10), HN C(9), DATE D, TOTAL N(7);
		,PAID N(7) , AN C(9) )
			index on AN tag AN
	endif
	use (target) alias RCPD
	dbfuse = ''
	set order to tag AN
IF USED('DTPD')
	SELE DTPD
	use
ENDI
	sele 0
	target=billdir+'all\dtpd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (RC_NO C(10), SV_ID C(2), AMT N(7), AN C(9) )
			index on AN tag AN
	endif
	use (target) alias DTPD
	dbfuse = ''
	set order to tag AN
IF USED('CREDITPD')
	SELE CREDITPD
	use
ENDI
	sele 0
	target=billdir+'all\creditpd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (CR_ID C(2), RC_NO C(10), AN C(9) )
			index on An tag An ADDI
			index on Rc_no tag Rc_no ADDI
	endif
	use (target) alias CREDITPD
	dbfuse = ''
	set order to tag Rc_no

***************************

IF USED('ADMYEAR')
	SELE admyear
	USE
ENDI
	SELE 0
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
USE (infile) ORDER 1 ALIA ADMyear
dbfuse = ''

*****************************
PROC CLOSEFILE1
*****************************
IF USED('INP')
	SELE inp
	USE
ENDI
IF USED('DIAGNOSIS')
	SELE DIAGNOSIS
	USE
ENDI
IF USED('OPERATION')
	SELE operation
	USE
ENDI
IF USED('REFER')
	SELE refer
	USE
ENDI
IF USED('DEATH_YR')
	SELE death_yr
	USE
ENDI
IF USED('SS')
	SELE ss
	USE
ENDI

*****************************
FUNC CHECKICD5
PARA _cicd
IF LEFT(_cicd,1)='!'
	_cicd= SUBS(_cicd,2)+' '
	=CheckICD1(_cicd)
ELSE
	=CheckICD2(_cicd)
ENDI
SHOW GETS

FUNC CHECKICD1
PARA _icd
_mx='m'+VARREAD()
_x=RIGHT(_mx,1)
IF ! USED('shorticd')
	dbfuse = patientdir+'shorticd'
	IF ! FILE(patientdir+'shorticd.dbf')
		SELE 0
		CREA TABLE (patientdir+'shorticd') ;
		(code C(7), desc C(60), type C(1), date C(4))
		INDEX ON UPPE(desc) TAG desc
		INDEX ON code TAG code ADDI
		USE
	ENDI
		** แฟ้ม shorticd เก็บชื่อย่อของโรคหรือการผ่าตัด
		** TYPE  1 = จากโปรแกรม OPD
		**       2 = จากโปรแกรม IPD
		**       3 = จากโปรแกรมทั้ง OPD	และ IPD
		** DATE  คือวันที่เริ่มมีการใส่รหัสย่อนี้
	USE (patientdir+'shorticd') ORDER 1 IN 0
	dbfuse = ''
ENDI
IF ! EMPTY(_icd)
	IF ISDIGIT(_icd) .OR. LEFT(_icd,1)='*'
		SELE icdcm1
		_icd = IIF(LEFT(_icd,1)='*',SUBS(_icd,2)+' ',_icd)
	ELSE
		SELE icd101
	ENDI
	SET ORDER TO 1
	IF ! SEEK(TRIM(_icd))	&& ไม่ได้ใส่เป็นรหัส
		SELE shorticd
		mtag = IIF(LEFT(_icd,1)='#','code','desc')	&& ดูว่าเป็นรหัสย่อ หรือ ชื่อ
		SET ORDER TO TAG (mtag)
		mseek = IIF( LEFT(_icd,1)='#',TRIM(_icd),_icd)
		IF ! SEEK(mseek)
			SET ORDER TO TAG desc	&& ให้หาดูจากชื่อ
			IF SEEK(TRIM(_icd))		&& หาพบว่าใส่เป็นชื่อโรค
				_trimicd = TRIM(_icd)
				icdlen = LEN(_trimicd)
				DIME ProvArr(100)
				xx=1
				DO WHIL UPPE(LEFT(desc,icdlen)) = _trimicd .AND. ! EOF()
					IF xx >100
						DIME ProvArr(xx)
					ENDI
					ProvArr(xx)=desc
					xx=xx+1
					SKIP
				ENDD
				IF xx > 2 	&& มีชื่อคล้ายกันมากกว่า 1 ชื่อ
					mchoice=0
					SET CONF ON
					@  10,20 MENU ProvArr,xx-1,10
					READ MENU TO mchoice
					SET CONF OFF
					IF mchoice = 0  && User กดปุ่ม [Esc]
						= TONE(1200,5)
						=TONE(700,5)
						DEFINE WIND addname FROM 10,20 TO 16,60 SHAD
						ACTI WIND addname
						@ 1,2 SAY 'ต้องการเพิ่มชื่อ '+TRIM(_icd)+' เข้าไปในแฟ้มชื่อย่อ'
						@ 3,10 SAY 'ใช่หรือไม่ ' GET yesno DEFA 'N' PICT '!'
						READ NOLOCK
						RELE WIND addname
						IF yesno $ 'Yัํ'
							SET ORDER TO TAG code
							SEEK '#'
							m.code = IIF( LEFT(code,1)='#', '#'+STR(VAL(SUBS(code,2))-1,4),;
							'#'+'9999')
							GO TOP
							IF ! EMPTY(code) .OR. BOF()
								APPE BLAN
							ENDI
							REPL code WITH m.code, desc WITH _icd, type WITH '3',;
							date WITH yy+mm
							FLUSH
							&_mx = _icd
							_icd = m.code
						ELSE
							_CUROBJ = _CUROBJ
							RETU
						ENDI
					ENDI
					SKIP mchoice-xx
				ELSE
					SKIP -1
				ENDI
				_icd = ShowICD(code)
				&_mx = LEFT(desc,60)
				REPL type WITH IIF( type<'3', '2', '3')
				FLUSH
*				IF LEFT(_icd,1)$'*123456789'
*					_CUROBJ=_CUROBJ+2
*				ENDI
			ELSE		&& ยังไม่มีชื่ออยู่ในรายชื่อย่อ
				= TONE(1200,5)
				=TONE(700,5)
				DEFINE WIND addname FROM 10,20 TO 16,60 SHAD
				ACTI WIND addname
				@ 1,2 SAY 'ต้องการเพิ่มชื่อ '+TRIM(_icd)+' เข้าไปในแฟ้มชื่อย่อ'
				@ 3,10 SAY 'ใช่หรือไม่ ' GET yesno DEFA 'N' PICT '!'
				READ NOLOCK
				RELE WIND addname
				IF yesno $ 'Yัํ'
					SET ORDER TO TAG code
					SEEK '#'
					m.code = IIF( LEFT(code,1)='#', '#'+STR(VAL(SUBS(code,2))-1,4),;
					'#'+'9999')
					GO TOP
					IF ! EMPTY(code) .OR. BOF()
						APPE BLAN
					ENDI
					REPL code WITH m.code, desc WITH _icd, type WITH '3',;
					date WITH yy+mm
					FLUSH
					&_mx = _icd
					_icd = m.code
				ELSE
					_CUROBJ = _CUROBJ
				ENDI
			ENDI
		ELSE
			_icd = ShowICD(code)
			&_mx = LEFT(desc,60)
			REPL type WITH IIF( type<'3', '2', '3')
			FLUSH
*			IF LEFT(_icd,1)='*'
*				_CUROBJ=_CUROBJ+2
*			ENDI
		ENDI
	ELSE
		_icd=ShowICD(code)
		&_mx=LEFT(desc,60)
*		IF LEFT(_icd,1)='*'
*			_CUROBJ=_CUROBJ+2
*		ENDI
	ENDI
ELSE
	_icd = SPACE(5)
	&_mx = SPACE(60)
ENDI
SHOW GETS
*RETU _icd

FUNC CHECKICD2            		&& ตรวจสอบว่ามี ICD นี้หรือไม่
PARA _icd
ON KEY LABEL Home
ON KEY LABEL PGUP
ON KEY LABEL PGDN
_mx='M'+VARREAD()
_x=RIGHT(_mx,1)
mf1='icd101'
mf2='icd102'
mf3='icd103'
IF LASTKEY() # 5
IF ! EMPTY(_icd)
	_icd = IIF(LEFT(_mx,5)='MOPER' .AND. LEFT(_icd,1)#'*','*'+_icd,_icd)
	IF ISDIGIT(SUBS(_icd,2,1)) .OR. LEN(TRIM(_icd))=1
		IF LEFT(_icd,1)='*' .OR. ISDIGIT(_icd)
			_icd=IIF(ISDIGIT(_icd),LEFT(_icd,4),SUBS(_icd,2,4))
			mf1='icdcm1'
			mf2='icdcm2'
			mf3='icdcm3'
		ELSE
			mf1='icd101'
			mf2='icd102'
			mf3='icd103'
		ENDI
		_seek=ALLTRIM(_icd)
		_seek=IIF(LEN(_seek)>5,LEFT(_seek,5),_seek)
		_seek=IIF(LEN(_seek)<3,_seek+SPAC(3-LEN(_seek)),_seek)
		slen=LEN(_seek)-1
		SELE (mf1)
		SET ORDER TO 1
		IF ! SEEK(_seek)
			success=.F.				&& หารหัสที่ใส่ไม่พบ
			FOR i = slen TO 1 STEP -1	&& Loop หาโดยการตัดที่ตัวจนเหลือ 1 ตัว
				_seek=LEFT(_icd,i)
				IF SEEK(_seek)
					success=.T.		&& หารหัสที่ใส่พบแล้ว
					_prompt=sicd1(code+SPACE(3)+desc)
					FOR n = i+1 TO 3	&& ถ้าหากว่าความยาวของรหัส น้อยกว่า 4 ให้หารหัสย่อยอีก
						_seek=LEFT(_prompt,n)
						IF SEEK(_seek)
							_prompt=sicd1(code+SPACE(3)+desc)
						ELSE
							EXIT
						ENDI
					NEXT
					EXIT
				ENDI
			NEXT
			IF success
				_icd=LEFT(_prompt,LEN(code))
				_icd=ShowICD(_icd)
				&_mx=SUBS(_prompt,LEN(code)+4,60)
				IF LEFT(_icd,1)='*'
					_CUROBJ=_CUROBJ+2
				ENDI
			ELSE
	            ?? CHR(7)
				WAIT 'ไม่มีรหัสโรคนี้  '+_icd  WIND NOWAIT
				_CUROBJ=_CUROBJ
			ENDI
		ELSE
			_icd=ShowICD(code)
			&_mx=LEFT(desc,60)
			IF LEFT(_icd,1)='*'
				_CUROBJ=_CUROBJ+2
			ENDI
		ENDI
	ELSE
		IF LEFT(_icd,1)='*'
			_icd=SUBS(_icd,2)
*		DO openicdcm
			mf1='icdcm1'
			mf2='icdcm2'
			mf3='icdcm3'
		ENDI
		SELE (mf1)
		mprompt=Keyword(_icd)
		SELE (mf1)
		IF LASTKEY()#27
			_icd=LEFT(mprompt,LEN(code))
			_icd=Showicd(_icd)
			&_mx=SUBS(mprompt,LEN(code)+4,60)
			IF LEFT(_icd,1)='*'
				_CUROBJ=_CUROBJ+2
			ENDI
		ENDI
	ENDI
	IF mf1='icdcm'
*	DO openicd10
		mf1='icd101'
		mf2='icd102'
		mf3='icd103'
	ENDI
ELSE
	IF LASTKEY()#5
		_icd=SPACE(LEN(_icd))
		&_mx=SPAC(LEN(&_mx))
	ENDI
ENDI
ELSE
	_icd = showicd(_icd)
ENDI
SHOW GETS

PROC Keyword
PARA word
_wret=SPAC(LEN(word))
mkwd=rtrim(word)
dimension tmpdg(1)
select (mf3)
set order to tag desc
IF seek(mkwd)
	num=1
	do while UPPE(desc)=mkwd
		dimension tmpdg(num)
		tmpdg(num)=desc
		num=num+1
		SKIP
	enddo
	choice=''
	DEFINE WIND sicd FROM 1,1 TO 23,78 SHAD
	ACTI WIND sicd
	lastkey=27
	@ 5,5 get choice from tmpdg &&color n/w,w+/n,w+/bg
	KEYB "{HOME}"
	READ NOLOCK
	IF LASTKEY()=27
		_CUROBJ=_CUROBJ
		RELE WIND sicd
		RETU
	ENDI
	CLEA
	set order to tag desc
	seek UPPE(choice)
	mcode=kwcode

*** ADD HERE ****


	select (mf2)
	set order to tag kwcode
	seek mcode
	num=0
	do while mcode=kwcode
		num=num+1
		dimension tmp(num)
		tmp(num)=code
		SKIP
	enddo
	select (mf1)
	set order to tag code

	for i=1 to alen(tmp)
		seek(LEFT(alltrim(tmp(i)),3))
		if !empty(text)
			tmp(i)=code+' * '+rtrim(desc)
		else
			tmp(i)=code+'   '+rtrim(desc)
		endif
	endfor
	num=alen(tmp)
*	set color to w+/b
	ftr='  กดปุ่ม [F2] เพื่อดูข้อมูลเพิ่มเติม  '
	DEFINE POPUP sicd COLO r+/bg+,w+/r+ SHAD FOOT ftr FROM 0,1 TO 10,75
	for ii=1 to num
		DEFINE BAR ii OF sicd PROMPT padr(tmp(ii),70,' ')
	endfor
	mcode1=spac(3)
	_seek=space(4)
	keyf2=ON('KEY','F2')
	ON KEY LABEL F2 DO ShwMemo4 WITH PROMPT()
	ON SELE POPUP sicd DO  Sele_sicd WITH PROMPT(),_seek
	mkey=27
	DO WHIL mkey=27
		ACTI POPUP sicd
		mkey=lastkey()
	ENDD
	ON KEY LABEL F2 &keyf2
	_seek=LEFT(_seek,3)
	select (mf1)
	IF !seek(_seek)			&& expecting X99
		?? chr(7)
		wait 'WARNING : This code is currently NOT in the ICD files!' window timeout 1
	else
		_wret=Sicd1(code+SPACE(3)+desc)
	ENDI
	RELE WIND sicd
ENDI
select (mf3)
SET ORDER TO 1
select (mf2)
SET ORDER TO 1
select (mf1)
SET ORDER TO 1
RETU _wret

*************************************
FUNC SHOWICD
PARA _showicd
IF ISDIGIT(_showicd) .OR. LEFT(_showicd,1)='*'
	RETU IIF(ISDIGIT(_showicd),'*'+_showicd,_showicd)
ELSE
	_showicd= LEFT(_showicd,3)+IIF(ISDIGIT(SUBS(_showicd,4,1)),'.','')+SUBS(_showicd,4)
	RETU _showicd
ENDI

FUNC FINDICD
PARA _find
DIME tempicd(100),tempname(100)
PRIVATE xx,mchoice
xx=1
WAIT 'กำลังค้นหาข้อมูลอยู่ กรุณาคอยสักครู่' WIND NOWA
SET ORDER TO 0
SCAN FOR TRIM(_find)$name
	TempName(xx)=name
	TempICD(xx)=RECNO()
	xx=xx+1
	IF xx>100
		EXIT
	ENDI
ENDS
SET ORDER TO 1
IF xx=1 .OR. xx>100
	GO BOTT
	SKIP
	?? CHR(7)
	IF xx=1
		WAIT 'ไม่มีรหัสโรคที่สะกดคล้าย '+_find WIND NOWAIT
	ELSE
		WAIT 'ควรพิมพ์ชื่อยาวกว่านี้ มีชื่อทำนองนี้มากเกินไป' wind nowait
	ENDI
	_CUROBJ=_CUROBJ
ELSE
	?? CHR(7)
	WAIT WIND 'ค้นได้แล้ว เชิญเลือกเอาได้เลย' NOWA
	mchoice=0
	SET CONF ON
	DO WHIL mchoice=0
		@  10,20 MENU TempName,xx-1,10
		READ MENU TO mchoice
	ENDD
	SET CONF OFF
	GO TempICD(mchoice)
ENDI

***********************************
FUNC ENTRYICD
PARA _oldicd,_newicd
mx = 'm'+VARREAD()
IF EMPTY(_oldicd)
	_newicd=SPAC(60)
	&mx = SPACE(LEN(&mx))
ELSE
	_newicd=con_icd(_newicd)
	_newicd=LEFT(_newicd+SPAC(60),60)
ENDI
SHOW GETS
RETU IIF(_oldicd='     ',.F.,.T.)

***********************************
FUNC con_icd
PARA _conicd
RETU IIF(SUBS(_conicd,4,1)='.',LEFT(_conicd,3)+SUBS(_conicd,5),_conicd)

***********************************
PROC OPENICD10
IF USED('ICDCM1')
	sele icdcm1
	dbfuse = codedir+'icd101'
	use (codedir+'icd101') order 1
ELSE
	if used('ICD101')
		select icd101
	else
		SELE 0
		dbfuse = codedir+'icd101'
		use (codedir+'icd101') order 1
	endif
ENDI

IF USED('ICDCM2')
	sele icdcm2
	dbfuse = codedir+'icd102'
	use (codedir+'icd102') order 1
ELSE
	if used('ICD102')
		select icd102
	else
		SELE 0
		dbfuse = codedir+'icd102'
		use (codedir+'icd102') order 1
	endif
ENDI

IF USED('ICDCM3')
	sele icdcm3
	dbfuse = codedir+'icd103'
	use (codedir+'icd103') order 1
ELSE
	if used('ICD103')
		select icd103
	else
		SELE 0
		dbfuse = codedir+'icd103'
		use (codedir+'icd103') order 1
	endif
ENDI
dbfuse = ''

***********************************
PROC OPENICDCM
IF USED('ICD101')
	sele icd101
	dbfuse = codedir+'icdcm1'
	use (codedir+'icdcm1') order 1
ELSE
	if used('ICDCM1')
		select icdcm1
	else
		SELE 0
		dbfuse = codedir+'icdcm1'
		use (codedir+'icdcm1') order 1
	endif
ENDI

IF USED('ICD102')
	sele icd102
	dbfuse = codedir+'icdcm2'
	use (codedir+'icdcm2') order 1
ELSE
	if used('ICDCM2')
		select icdcm2
	else
		SELE 0
		dbfuse = codedir+'icdcm2'
		use (codedir+'icdcm2') order 1
	endif
ENDI

IF USED('ICD103')
	sele icd103
	dbfuse = codedir+'icdcm3'
	use (codedir+'icdcm3') order 1
ELSE
	if used('ICDCM3')
		select icdcm3
	else
		SELE 0
		dbfuse = codedir+'icdcm3'
		use (codedir+'icdcm3') order 1
	endif
ENDI
dbfuse = ''

**********************************
PROC Sele_sicd
PARA _pmt,_sst
_sst=_pmt
DEAC POPUP sicd

***********************************
PROC Sicd1
PARA _sicd1c
_sret=_sicd1c
select (mf1)
DEFINE WIND sicd FROM 1,1 TO 23,78 SHAD
ACTI WIND sicd
ftr='  กดปุ่ม [F2] เพื่อดูข้อมูลเพิ่มเติม  '
DEFINE POPUP sicd COLO r+/bg+,w+/r+ SHAD FOOT ftr FROM 0,1 TO 10,75
num=0
FOR ii=0 to 9
	IF SEEK(_seek+str(ii,1))
		num=num+1
		if !empty(text)
			DEFINE BAR num OF sicd PROMPT code+' * '+rtrim(desc)
		else
			DEFINE BAR num OF sicd PROMPT code+'   '+rtrim(desc)
		endif
	ENDI
NEXT
keyf2=ON('KEY','F2')
ON KEY LABEL F2 DO shwmemo4 WITH PROMPT()
ON SELE POPUP sicd DO  Sele_sicd WITH PROMPT(), _sret
mkey=27
DO WHIL mkey=27 .AND. num>0
	ACTI POPUP sicd
	mkey=lastkey()
ENDD
RELE WIND sicd
ON KEY LABEL F2 &keyf2
RETU _sret

*****************
Procedure shwmemo4
*****************
parameter scode
on key label F2
scode=LEFT(scode,4)
define window mem from 15,5 to 23,75 shadow COLO w+/bg+
select (mf1)
seek scode
if !empty(text)
	modify memo text noedit window mem
endif
on key label F2 do shwmemo4 WITH PROMPT()
return

*******************************
PROC MAINSCR
@ 3,0 CLEA TO 20,80
@ 2,0
TEXT
                              โปรแกรมสำหรับงานผู้ป่วยใน
                                IPD  Version <<statversion>>
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
FUNC InputDoctor
PARA _doctor,_mdoctor
_doctor=RemoveBlank(_doctor)

***************
Func ChkDeath
***************
Para _stat

if ! _stat$'123456789' .AND. LASTKEY() # 5
	?? chr(7)
	wait 'รหัสไม่ถูกต้อง' window timeout 1
	return 0
endif

if _stat$'89'
	if _stat = '8'
		if m.datea <> m.dated
			wait 'รหัสนี้สำหรับ ผู้ป่วยเด็กตายแรกคลอดเท่านั้น ' wind time 2
			return 0
		endif
	endi

	define window dead from 12,2 to 19,76 shadow title '  สาเหตุการตาย  '
	sele death_yr
	IF EMPTY(death[4])
		IF SEEK( m.an)
			SCAT TO death
			dead1 = death[4]
			dead2 = death[5]
			dead3 = death[6]
			SELE icd101
			SEEK TRIM(dead1)
			mdead1 = LEFT(desc,40)
			SEEK TRIM(dead2)
			mdead2 = LEFT(desc,40)
			SEEK TRIM(dead3)
			mdead3 = LEFT(desc,40)
		ELSE
			scatter to death blank
			death(1)=Hosp_code
			death(2)=m.HN
			death(3)=m.AN
			store space(6) to dead1,dead2,dead3
			store space(40) to mdead1, mdead2, mdead3
		ENDI
	ELSE
		dead1 = death[4]
		dead2 = death[5]
		dead3 = death[6]
		SELE icd101
		SEEK (dead1)
		mdead1 = LEFT(desc,40)
		SEEK (dead2)
		mdead2 = LEFT(desc,40)
		SEEK (dead3)
		mdead3 = LEFT(desc,40)
	ENDI

	activate window dead
	dead0 = 'abcd'
	do while .t.
		@ 1,2 say 'Immediate Cause  : '
		@ 2,2 say 'Antecedent Cause : '
		@ 3,2 say 'Other Cause      : '
		@ 5,20 say 'ข้อมูลถูกต้อง ....... '
		@ 1,22 get dead1 picture '@!' WHEN EntryICD(dead0,dead1) VALID CheckICD(dead1)
		@ 1,28 get mdead1 disable color ,,,,,,,,,gr+/
		@ 2,22 get dead2 picture '@!' VALID CheckICD(dead2)
		@ 2,28 get mdead2 disable color ,,,,,,,,,gr+/
		@ 3,22 get dead3 picture '@!' VALID CheckICD(dead3)
		@ 3,28 get mdead3 disable color ,,,,,,,,,gr+/
		@ 5,40 get ans DEFA 'Y' picture 'Y'
	READ NOLOCK
	if readkey()=12 or readkey()=268
		wait 'Terminate by user' window timeout 1
		release window dead
		SELE death_yr
		store space(6) to dead1,dead2,dead3
		store space(40) to mdead1, mdead2, mdead3
		return
	endif
	if Upper(ans)='N'
		loop
	else
		exit
	endif
	enddo

	death(4)=Con_ICD(dead1)
	death(5)=Con_ICD(dead2)
	death(6)=Con_ICD(dead3)
	release window dead

endif

***********************
PROC V_REFER
***********************
do case
 case m.dctype$'1234567'
 	if m.dcstatus$'89'
 		?? chr(7)
 		wait 'ผู้ป่วยเสียชีวิตแล้ว รหัสการจำหน่ายต้องเป็น 8 หรือ 9 ' wind time 1
 		return 0
 	endif
 case m.dctype$'89'
 	if ! m.dcstatus$'89'
 		?? chr(7)
 		wait 'สถานภาพการจำหน่ายผู้ป่วยไม่ได้เสียชีวิต รหัสการจำหน่ายต้องไม่ใช่ 8,9 ' wind time 1
 		return 0
 	endif
 othe
	?? chr(7)
	wait 'รหัสไม่ถูกต้อง กด F1 ดูข้อความช่วยเหลือ' wind time 1
	return 0
endc
IF m.dctype = '4'
	DO Forreferout
ENDI
***********************
Func V_mon
Para _mm

if !between(val(_mm),1,12)
	??chr(7)
	wait 'Invalid input' window timeout 0.5
	_curobj=_curobj
else
	@ 1,13 say tmonth(val(_mm))+' '
endif

*************************
Func V_year
Para _mm,_yy

DO CASE
 CASE _mm = str(MONTH(date()),2) and _yy = str(YEAR(date())+543-2500,2)
	??chr(7)
	wait 'เดือนปัจจุบันข้อมูลยังไม่ครบ ไม่สามารถประมวลผลได้' window timeout 1
	_curobj=_curobj-1
 CASE val(_yy) < 35
	??chr(7)
	wait 'Invalid input' window timeout 0.5
	_curobj=_curobj
ENDC

*************
PROC MON_FILE
*************
@ 3,0 clear to 20,79
@ 22,0 clear to 23,79
@ 3,0

define window askmonth from 8,20 to 14,60 shadow title'    บันทึกข้อมูลของเดือน  '
activate window askmonth
ans='Y'
do while .t.
	@ 1,3 say 'เดือน'
	@ 1,20 say 'พ.ศ.25'
	@ 2,10 say 'ใส่เดือนที่จำหน่ายผู้ป่วย'
	@ 3,8 say 'ถูกต้องแล้ว....  '
	@ 1,10 get mm picture '99' valid v_mon(mm)
	@ 1,27 get yy picture '99' valid val(yy)>35
	@ 3,25 get ans picture 'Y'
	READ NOLOCK
	if readkey()=12 or readkey()=268
		wait 'Terminate by user' window timeout 1
		release window askmonth
		return to ipd
	endif
	if Upper(ans)='N'
		loop
	else
		release window askmonth
		exit
	endif
enddo

return

FUNC CLEAROPER
IF EMPTY(m.oper1)
	store '  /  /    ' to m.dateop1
	store space(6) to m.surg1
	STOR SPACE(25) TO m.msurg1
	STOR SPACE(50) TO m.moper1
ENDI
IF EMPTY(m.oper2)
	store '  /  /    ' to m.dateop2
	store space(6) to m.surg2
	STOR SPACE(25) TO m.msurg2
	STOR SPACE(50) TO m.moper2
ENDI
IF EMPTY(m.oper3)
	store '  /  /    ' to m.dateop3
	store space(6) to m.surg3
	STOR SPACE(25) TO m.msurg3
	STOR SPACE(50) TO m.moper3
ENDI
IF EMPTY(m.oper4)
	store '  /  /    ' to m.dateop4
	store space(6) to m.surg4
	STOR SPACE(25) TO m.msurg4
	STOR SPACE(50) TO m.moper4
ENDI
SHOW GETS

PROC FORREFEROUT
DEFINE WIND win1 FROM 6,2 TO 19,78 SHAD
ACTI WIND win1
* udc outtime=IIF(empty(outtime),LEFT(TIME(),2)+SUBS(TIME(),4,2),outtime)
outtime = m.timed
@ 1,3 say 'เวลาที่ส่ง refer   ' get outtime PICT '@R ##:##';
valid TimeRefer(outtime) mess 'ใส่เวลาเป็นชั่วโมง นาที'
@ 3,3 SAY 'ชื่อสถานบริการที่ refer ' get outplace pict '@!' ;
VALID Hospital(outplace,referoutplace)
@ 4,3 GET referoutplace DISA
@ 6,3 say 'เหตุผลที่ส่ง refer ' get outcause VALID CheckCause(outcause)
@ 10,20 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET m.correct DEFA 'Y';
PICT '!' VALID CheckCorrect1(outtime,outplace,outcause,m.correct)
READ NOLOCK
outtype='2'
RELE WIND win1

FUNC ENTRYDATEOP
PARA _check
SHOW GETS
RETU ! EMPTY(_check)

FUNC CHECKDATEOP
PARA _checkdate, _date2
PRIV numpara
numpara = PARAMETERS()
_checkdate = LEFT(_checkdate,8)
IF  LEFT(_checkdate,2)='  ' .OR. (truedate(_checkdate) and ;
BETWEEN(be2ce(_checkdate),be2ce(m.datea),be2ce(m.dated)))
	IF numpara > 1
		IF DTOS(BE2CE(_checkdate)) < DTOS(BE2CE(_date2))
			?? CHR(7)
			WAIT WIND NOWA 'ใส่วันที่ผ่าตัดเสร็จไม่ถูกต้อง'
			RETU 0
		ENDI
	ENDI
ELSE
	= TONE(1200,5)
	=TONE(700,5)
	WAIT WIND 'ใส่วันที่ผ่าตัดไม่ถูกต้อง กรุณาใส่ใหม่' NOWA
	_CUROBJ = _CUROBJ-1
ENDI

FUNC SHOWHN
PARA _hn
SELE patient1
SET ORDER TO TAG hn
_hn = PADZERO(_hn)
SEEK _hn
scatter memvar
m.name=De_Name(NAME)
m.age=NOWAGE(BIRTHDAY,derive)
SHOW GETS

PROC Closefile1
IF USED('INP')
	SELE inp
	use
ENDI
IF USED('DIAGNOSIS')
	SELE diagnosis
	use
ENDI
IF USED('OPERATION')
	SELE operation
	USE
ENDI
IF USED('REFER')
	SELE refer
	USE
ENDI
IF USED('DEATH_YR')
	SELE death_yr
	use
ENDI
IF USED('SS')
	SELE ss
	USE
ENDI
IF USED('ADMYEAR')
	SELE admyear
	USE
ENDI

FUNC CheckTimeOut
PARA _date1, _time1, _date2, _time2
PRIV date1, date2
date1 = DTOS(BE2CE(_date1))
date2 = DTOS(BE2CE(_date2))
IF ! BETWEEN(_time2,'0000','2400') .OR. ! BETWEEN(RIGHT(_time2,2),'00','59') ;
.OR. (date2 + _time2 <= date1 + _time1)
	?? CHR(7)
	WAIT WIND NOWA 'ใส่เวลาผ่าตัดเสร็จไม่ถูกต้อง'
	RETU 0
ENDI

FUNC CheckTime
PARA _time
IF ! BETWEEN(_time,'0000','2400') .OR. ! BETWEEN(RIGHT(_time,2),'00','59')
	?? CHR(7)
	WAIT WIND NOWA 'ใส่เวลาไม่ถูกต้อง'
	RETU 0
ENDI

FUNC CHECKCORRECT1
PARA _outtime, _outplace, _outcause, _mcorrect
DO CASE
	CASE EMPTY(_outtime)
		_CUROBJ=ObjNum(_outtime)
	CASE EMPTY(_outplace)
		_CUROBJ=ObjNum(_outplace)
	CASE EMPTY(_outcause)
		_CUROBJ=ObjNum(_outcause)
	OTHERWISE
		IF _mcorrect#'Y'
			_CUROBJ=1
		ENDI
ENDC