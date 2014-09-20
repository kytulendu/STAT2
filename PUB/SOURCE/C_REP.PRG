***********************************************************************
*								C_REP.PRG
*							ver 1.0 	12 ต.ค. 2536
***********************************************************************
ACTI SCREE
mm0 = mm
yy0 = yy
my=SUBS(DTOC(DATE()),4,2)+STR(YEAR(DATE())+543-2500,2)
mmonth=left(my,2)
yyear=RIGHT(my,2)

if val(mmonth) = 1
	mm='12'
	yy=str(val(yyear)-1,2)
else
	mtemp=val(mmonth)-1
	mm = STRZERO(mtemp,2)
	yy=yyear
endif

col=Center(mhosp_name)
diag0='adfe'
oper0='adfe'
@ 0,col SAY mhosp_name color gr+/
*col=center(MenuMess(ChMain))
*@ 1,col say MenuMess(ChMain)

@ 3,0 clear to 20,79
@ 22,0 clear to 23,79
@ 3,0

define window askmonth from 8,20 to 14,60 shadow title'    ส่งรายงานของเดือน  '
activate window askmonth
ans='Y'
do while .t.
	@ 1,3 say 'เดือน'
	@ 1,20 say 'พ.ศ.'
	@ 3,8 say 'ถูกต้องแล้ว....  '
	@ 1,10 get mm picture '99' && valid v_mon(mm)
	@ 1,27 get yy picture '99' && valid v_year(mm,yy)
	@ 3,25 get ans picture 'Y'
	READ NOLOCK
	if LASTKEY() = 27
		wait 'Terminate by user' window timeout 2
		release window askmonth
		return
	endif
	if Upper(ans)='N'
		loop
	endif

	target=ipddir+'\data\IN'+yy+mm+'.dbf'
	IF !file(target)
		wait 'ไม่พบแฟ้มข้อมูล' wind time 2
		loop
	ELSE
	DO OpenFile1
	target=patientdir+'patient2.dbf'
	IF ! USED('PATIENT2')
		SELE 0
			dbfuse = target
			use (target) alias PATIENT2
			set order to tag hn
			dbfuse = ''
	ELSE
		SELE PATIENT2
	ENDI

	target=patientdir+'contact.dbf'
	IF ! USED('CONTACT')
		SELE 0
			dbfuse = target
			use (target) alias CONTACT
			set order to tag hn
	ELSE
		SELE CONTACT
	ENDI
	dbfuse = ''
*INDEX ON an TAG an
*Set order to tag AN
	ENDI

	exit
enddo
release window askmonth
yymm = yy+mm
recal = 'Y'
IF file(ipddir+'report\IP'+yy+mm+'.dbf')
	DEFINE WIND askgo FROM 10,20 TO 15,60 SHAD
	ACTI WIND askgo
	@ 1,3 SAY 'ข้อมูลเดือน'+month&mm+' '+FullYear(yy)+' เคยคำนวณแล้ว'
	@ 2,3 SAY 'ต้องการคำนวณใหม่หรือไม่ ' GET recal DEFA 'N' PICT '!'
	READ NOLOCK
	RELE WIND askgo
ENDI
IF recal = 'Y'
	dele file (ipddir+'report\IP'+yy+mm+'.dbf')
	rfile=ipddir+'report\IP'+yy+mm+'.dbf'
	dbfuse = rfile
	create table (rfile) (AN C(7), HN C(9), CHANGWAT C(2), AMPUR C(2),;
	SEX C(1), AGE_TYPE C(1),  AGE N(2,0), MARRIAGE C(1), OCCUPA C(3),;
	NATION C(2), WARD C(3), DATEADM C(8), DATEDSC C(8), DG1 C(7),;
	DG2 C(7), DG3 C(7), DG4 C(7),;
	OP1 C(7), OP2 C(7), OP3 C(7), OP4 C(7), ONSET N(2,0),;
	DISCHS C(1), DISCHT C(1), REFERIN C(5), REFEROUT C(5), CAUSEIN C(2),;
	CAUSEOUT C(2), PTTYP C(2))
	use (rfile) alia REPORTM
	dbfuse = ''
	SELE patient1
	set order to tag hn
	SET RELA TO hn INTO patient2
	SET RELA TO hn INTO contact ADDI

	SELE inp
	SET ORDER TO 0
	GO TOP
	IF RECCOUNT() = 0
		wait 'ยังไม่ได้ใส่ข้อมูล' wind time 2
		sele reportm
		USE
		SELE PATIENT2
		use
		SELE CONTACT
		use
		RETU
	ENDI
	div_num=ROUND((RECCOUNT()/40)+.5,0)
	recno = 0
	DO ShowProgress
	SCAN
		@ 3,3 SAY SPACE((ROUND(recno('inp')/div_num+.5,0))) COLO gr/r
		SELE reportm
		SCAT TO rep BLANK
		SELE inp
		IF ! EMPTY(hn)
			rep(1)=AN
			rep(2)=HN
			rep(11)=WARD_DSC
			mdadmit = DTOS(dateadm)
			mddisch = DTOS(datedsc)
			rep(12)=STRZERO(VAL(LEFT(mdadmit,4))+543,4)+RIGHT(mdadmit,4)
			rep(13)=STRZERO(VAL(LEFT(mddisch,4))+543,4)+RIGHT(mddisch,4)
			rep(23)=subs(DISC,1,1)
			rep(24)=subs(DISC,2,1)
			SELE PATIENT1
			seek rep[2]
			rep(5)=SEX
			_mage=inp.DATEDSC-birthday
			DO CASE
				CASE _mage<=30
					rep(6)='3'
					rep(7)=INT(_mage)
				CASE _mage<=365
					rep(6)='2'
					rep(7)=INT(_mage/31)
				OTHER
					rep(6)='1'
					rep(7)=INT(_mage/365)
			ENDC
			rep[7] = IIF( rep[7]<0, -1, rep[7])
			rep[7] = IIF( rep[7]>99, 0, rep[7])
			rep(29)=CLASS
			SELE PATIENT2
			rep(8)=iif(MARRIAGE>'0',MARRIAGE,'')
			rep(9)=iif(OCCUPA>'0',OCCUPA,'')
			rep(10)=iif(NATION>'0',NATION,'')
			SELE CONTACT
			rep(3)=iif(CHANGWAT>'0',CHANGWAT,'')
			rep(4)=iif(AMPUR>'0',AMPUR,'')

			SELE REFER
			if seek(rep[1])
				rep(26)=place
				rep[28]=cause
			endif
			SELE Admyear
			IF SEEK(rep[1])
				rep[25] = place
				rep[27] = cause
				rep[22] = onset
			ENDI
			SELE diagnosis
			seek(rep[1])
			increment = 0
			DO WHIL an = rep[1] .AND. increment < 4
				rep(14+increment)=DIAG
				skip +1
				increment = increment+1
			ENDD
			SELE operation
			seek(rep[1])
			increment = 0
			DO WHIL an = rep[1] .AND. increment < 4
				rep(18+increment)= op
				skip +1
				increment = increment+1
			ENDD
			insert into REPORTM from array rep
			FLUSH
		ENDI
		rep=''
		SELE inp
	ENDS
	SELE reportm
	USE
	RELE WIND progress
ENDI
tofile = ipddir+'report\ip'+yymm
ACTI SCREE
SAVE SCREE TO scr1
filezip = ipddir+'report\ip'+yymm+'.dbf'
exefile = patientdir+'pkzip'
RUN &exefile -m &tofile &filezip
CLEA
REST SCREE FROM scr1
DEFINE WIND rp_govn FROM 8,35 TO 15,79 SHAD TITLE 'รายงานผู้ป่วยในส่งกระทรวง' COLO gr+/b
ACTI WIND rp_govn
notsend = .F.
DO WHIL ! notsend
	@ 1,4 SAY 'ต้องการใส่รายงานไว้ในไดร์ฟไหน  '
	@ 2,10 PROMPT 'A:'
	@ 3,10 PROMPT 'B:'
	MENU TO mdrive
	?? CHR(7)
	IF mdrive=0
		@ 4,10 SAY 'ต้องการยกเลิกจริงหรือ ' GET notsend PICT 'Y'
		READ NOLOCK
		@ 4,0
	ELSE
		notsend = .T.
	ENDI
ENDD
IF mdrive=0
	WAIT WIND 'ยกเลิกการส่งรายงานไปกระทรวงตามต้องการ' TIME 2
ELSE
	drive=IIF(mdrive=1,'A:','B:')
	mfile=drive+'readme.ipd'
	WAIT WIND 'กรุณาใส่แผ่นดิสก์ไว้ในไดร์ฟ '+drive+' แล้วกดปุ่มอะไรก็ได้'
	fhandle=FCREATE(mfile)
	errmsg=''
	IF NoError(fhandle,errmsg)
		=FCLOSE(fhandle)
		DEFINE WIND comment FROM 7,10 TO 12,70 SHAD ;
		TITLE 'ข้อความฝากถึงส่วนกลาง' COLO r+/w
		ACTI WIND comment
		ON KEY LABEL ENTER KEYB "{TAB}"
		@ 1,4 EDIT m.comment DEFA '' SIZE 3,50
		READ NOLOCK
		ON KEY LABEL ENTER
		?? CHR(7)
		WAIT WIND 'โปรดคอย กำลังเก็บข้อมูลใส่ไว้ในแผ่นดิสต์ในช่อง ';
		+drive NOWA
		DIME tfile[5]
		=ADIR(tfile,ipddir+'report\ip'+yymm+'.zip')
		olddrive = SYS(5)
		SET DEFA TO &drive
		samefile = 0
		IF FILE(drive+'ip'+yymm+'.zip')
			DIME pfile[5]
			=ADIR(pfile,drive+'ip'+yymm+'.zip')
			samefile = pfile[2]
		ENDI
		freespace = DISKSPACE()
		DO WHIL freespace<=tfile[2]+4000 - samefile .AND. LASTKEY() # 27
			?? CHR(7)
			WAIT WIND 'เนื้อที่ว่างในไดร์ฟ '+drive+' มีไม่พอ'
			freespace = DISKSPACE()
		ENDD
		SET DEFA TO &olddrive
		IF LASTKEY() # 27
			DIME rp_file(5)
			=ADIR(rp_file,ipddir+'report\ip'+yymm+'.zip')
			filelen=LTRIM(STR(rp_file(2)))
			filedate=CE2CBE(rp_file(3))
			fhandle=FCREATE(mfile)
			=FWRITE(fhandle,'HP: ')
			=FPUTS(fhandle,hosp_name)
			=FWRITE(fhandle,'HC: ')
			=FPUTS(fhandle,hosp_code)
			=FPUTS(fhandle,'VL: IPD')
			=FWRITE(fhandle,'RD: ')
			=FPUTS(fhandle,DTOC(date()))
			=FPUTS(fhandle,'CT: 01,'+'IP'+yymm+'.ZIP'+','+filedate+','+filelen)
			=FWRITE(fhandle,'CM: ')
			=FPUTS(fhandle,m.comment)
			SELE doctor
			COPY TO (drive+'doctor')
			tofile = drive+'ip'+yymm+'.zip'
			fromfile = ipddir+'report\ip'+yymm+'.zip'
			COPY FILE (fromfile) TO (tofile)
		ELSE
			?? CHR(7)
			WAIT WIND NOWA 'ไม่ได้เก็บข้อมูลไว้ในไดร์ฟ '+drive TIME 2
		ENDI
		RELE WIND PR_GOVN
		RELE WIND comment
	ELSE
		?? CHR(7)
		WAIT WIND 'ไม่สามารถสร้างแฟ้มได้เนื่องจาก'+errmsg TIME 2
	ENDI
	=FCLOSE(fhandle)
ENDI
DEAC WIND ALL
RELE WIND ALL
KEYB '!'
SELE PATIENT2
use
SELE CONTACT
use

FUNC NoError
PARA _handle,reason
_ret=.T.
IF _handle < 0                &&Error generated creating file
   	DO CASE 						     && Determine which error
			CASE FERROR() = 4
				reason = 'เปิดแฟ้มมากเกินไป ไม่สามารถทำได้'
			CASE FERROR() = 5
 				reason = 'ไม่สามารถอ่าน-เขียนได้'
 			CASE FERROR() = 8
 				reason = 'ความจำไม่เพียงพอ'
			CASE FERROR() = 29
				reason = 'ไม่มีที่ว่าง'
	    CASE FERROR() = 31
	    		reason = 'มีข้อผิดพลาดทั่ว ๆ ไป'
	 	ENDCASE
	_ret=.F.
ENDI
RETURN _ret
