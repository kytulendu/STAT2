********************************************************************************
*  โมดูลพิมพ์ใบสั่งยาผู้ป่วยนอก
********************************************************************************
ON KEY LABEL Alt+R
PRIVATE Colspace,PreScr,Chprint,numpr
SET ESCA ON
set refresh to 1
ON ESCAPE STORE .T. TO exist

EXTERNAL ARRAY tmonth

DIME PrintMenu(5),PrintMess(5)
PrintMenu(1)='N=ใหม่ทุกคน'
PrintMenu(2)='E=ใหม่หนึ่งคน'
PrintMenu(3)='R=พิมพ์ซ่อม'
PrintMenu(4)='O=เก่าทุกคน'
PrintMenu(5)='C=ยกเลิกคิว'
PrintMess(1)='พิมพ์ใบสั่งยาผู้ป่วยนอกใหม่ทุกคน'
PrintMess(2)='พิมพ์ใบสั่งยาผู้ป่วยนอกใหม่ทีละคน'
PrintMess(3)='พิมพ์ซ่อมใบสั่งยาผู้ป่วยนอกที่เสีย'
PrintMess(4)='พิมพ์ใบสั่งยาผู้ป่วยนอกเก่าทุกคน'
PrintMess(5)='ยกเลิกคิวใบสั่งยาใหม่ที่ยังไม่ได้พิมพ์'
NumPr=5              && จำนวนรายการหลัก
ColSpace=78/NumPr    && ระยะห่างระหว่างแต่ละรายการ
ChPrint=1               && รายการที่เลือก
SAVE SCREEN TO PreScr
DO ClearScreen
@ 22,0 CLEA
DO WHIL ChPrint>0
   DO title WITH 'รายการพิมพ์ใบสั่งยา'
   xx=1
   DO WHIL xx<=NumPr
      @ 22,1+ColSpace*(xx-1) PROMPT PrintMenu(xx) MESSAGE PrintMess(xx)
      xx=xx+1
   ENDD
   MENU TO ChPrint
   @ 22,0
   DO CASE
      CASE ChPrint=0
         Chprint = 0
      CASE ChPrint=1
         DO Presc WITH .T.
      CASE ChPrint=2
         DO Presc WITH .F.
      CASE ChPrint=3
         DO Prescold
      CASE ChPrint=4
         DO OldPresc
      CASE ChPrint=5
         DO CancelPx
   ENDC
    DO ClearScreen
*   DO MainScr
ENDD
SET ESCA OFF
*close database
*set refresh to 15
ON ESCAPE STORE .T. TO exist
ON KEY LABEL Alt+R DO prs_menu
REST SCREEN FROM PreScr

*********************
PROC PRESC
*********************
PARA PrintAll
PRIVATE printkey,retrykey,mkey, prescr
SAVE SCREEN TO prescr
mrow=0

*DO CLearSCreen
printkey=1
exist=.F.
DO WHIL ! PRINTSTATUS() .AND. ! exist
   ?? CHR(7)
   WAIT 'เครื่องพิมพ์ยังไม่พร้อม  โปรดตรวจสอบให้เรียบร้อย' WINDOW NOWA
   exist = INKEY(0) = 27
ENDD
IF ! exist
	@ 22,0 CLEA
	DO ClearScreen
	SELE pque
	go top
	IF ! ISDIGIT(pn)
		?? CHR(7)
		@ 12,25 SAY 'ใบสั่งยาใหม่ได้พิมพ์ไปหมดเรียบร้อยแล้ว'
		mkey=INKEY(5)
	ELSE
			select presc
			SET ORDER TO tag pn
			select patient1
			set order to tag hn
			SELE pque
		DO WHIL ISDIGIT(pn) .AND. ! exist
			mpn=pn
			mnew=IIF(pque->new,'ใหม่','เก่า')
			select presc
			IF SEEK(mpn)
				@ 12,25 SAY 'กำลังพิมพ์ใบสั่งยาเลขที่ '+pn
				mhn=presc.hn
				mdate=str(day(presc.date),2)+' '+tmonth(month(presc.date))+str(year(presc.date)+543,4)
				mtime=substr(presc.time,1,2)+':'+substr(presc.time,3,2)+' น.'
				select patient1
				seek(mhn)
				mname = De_name(name)
				mage=nowage(birthday)
				mclinic=clinic
				mclass=class
				select social
				seek(mclass)
				mrights=rtrim(name)
				IF FILE('printpx.fxp')
					DO ('printpx')
				ELSE
					DO Printpxp
				ENDI
			ENDI
			SELE pque
			REPL  pn WITH 'AAAAAAA'
			GO TOP
			IF ! PrintAll
				exist=.T.
			ENDI
		ENDD
*		eject
	ENDI
ENDI
REST SCREE FROM prescr
********************
PROC PRESCOLD
********************
PRIVATE mstart,mend
*public mrow
mrow=0
on key label f10 do helppn
on key label f9 do helphn
DO ClearScreen
STORE 0 TO mstart,mend
@ 10,25 SAY 'เริ่มพิมพ์ตั้งแต่เลขที่  ' GET mstart PICT '9999999' valid mstart>0
@ 12,25 SAY ' พิมพ์ไปจนถึงเลขที่      ' GET mend PICT '9999999' VALID mend>=mstart
@ 15,0 say padc('F9,F10 ค้นหาเลขที่ใบสั่งยา   ESC exit',wcols(),' ')
READ NOLOCK
if readkey()=12 or readkey()=268
	exist=.T.
else
	exist=.F.
endif
DO WHIL ! PRINTSTATUS() .AND. ! exist
   ?? CHR(7)
   WAIT 'เครื่องพิมพ์ยังไม่พร้อม  โปรดตรวจสอบให้เรียบร้อย' WINDOW
ENDD
IF exist
	on key label F10
	on key label f9
	RETU
ENDI
DO ClearScreen
DO WHIL mstart<=mend .AND. ! exist
	select presc
	SET ORDER TO tag pn
	mseek=PADL(alltrim(str(mstart)),7,'0')
	IF ! SEEK(mseek)
	  	?? CHR(7)
		WAIT 'ไม่มีใบสั่งยาเลขที่ '+mseek WINDOW TIMEOUT 1
	ELSE
      mpn=pn
      IF SEEK(mpn)
         @ 12,25 SAY 'กำลังพิมพ์ใบสั่งยาเลขที่ '+pn
		 mhn=presc.hn
		 pdate=presc.date
		 mdate=str(day(presc.date),2)+' '+tmonth(month(presc.date))+str(year(presc.date)+543,4)
		 mtime=substr(presc.time,1,2)+':'+substr(presc.time,3,2)+' น.'
		 select patient1
		 set order to tag hn
		 seek(mhn)
		 mname=patient1.name
		 pos=at(',',mname)
		 mname=rtrim(substr(mname,pos+1))+substr(mname,1,pos-1)
		 mage=nowage(patient1.birthday)
		 mclinic=patient1.clinic
		 mclass=patient1.class
		 select social
		 seek(mclass)
		 mrights=rtrim(name)
		pnew=.T.
		select medrec
		set order to tag hn
		if seek(mhn)
			if year(medrec.date)<>year(pdate)
				do while medrec.hn=mhn
					skip +1
					if year(medrec.date)=year(pdate)
						pnew=.F.
						exit
					endif
				enddo
			else
				if medrec.date=pdate
					pnew=.T.
				else
					pnew=.F.
				endif
			endif
		endif
		mnew=iif(pnew,'ใหม่','เก่า')
		IF FILE('printpx.fxp')
			DO ('printpx')
		ELSE
			DO printpxp
		ENDI
	ENDI
	mstart=mstart+1
	endif
ENDD
*eject
on key label F10
on key label f9

**************************
Procedure HelpPN
**************************
on key label F10
on key label F9
define window pnbrow from 3,1 to 18,33 shadow color w+/b
activate window pnbrow
dd=padl(alltrim(str(day(date()),2)),2,'0')
mm=padl(alltrim(str(month(date()),2)),2,'0')
yy=str(year(date())+543-2500,2)
mfile='\PUB\PO'+yy+mm+dd+'.DBF'

select prtoday
set order to
go bott
set order to tag hn
brow field HN,PN,date,time in window pnbrow nomodify

release window pnbrow
on key label F10 do helppn
on key label f9 do helphn
return

**************************
Procedure HelpHN
**************************
on key label F10
on key label F9
define window pnbrow from 3,1 to 18,33 shadow color w+/b
activate window pnbrow
do while .t.
whichhn=space(7)
DO CLEARSCREEN
@ 1,2 say 'HN. ->'
@ 1,8 get whichhn picture '9999999'
READ NOLOCK
if readkey()=12 or readkey()=268 or empty(whichhn)
	exit
endif
whichhn=padl(alltrim(whichhn),7,'0')

dd=padl(alltrim(str(day(date()),2)),2,'0')
mm=padl(alltrim(str(month(date()),2)),2,'0')
yy=str(year(date())+543-2500,2)
mfile='\PUB\PO'+yy+mm+dd+'.DBF'

	select prtoday
set order to tag hn
seek(whichhn)
if !found()
	wait 'ไม่พบ HN '+whichhn window timeout 1
else
	brow field HN,PN,date,time in window pnbrow nomodify
	exit
endif

enddo
release window pnbrow
on key label F10 do helppn
on key label f9 do helphn
return

PROC CancelPX
DO ClearScreen
@ 10,25 PROMPT '1. ยกเลิกคิวใบสั่งยาคนไข้ใหม่'
@ 12,25 PROMPT '2. ยกเลิกคิวใบสั่ยาคนไข้เก่า'
MENU TO que
IF que > 0
	IF que = 1
		SELE pque
	ELSE
		SELE pqueo
	ENDI
	SET ORDER TO TAG pn
	GO TOP
	DO WHIL ISDIGIT(pn)
		WAIT WIND NOWA 'กำลังยกเลิกเลขที่ใบสั่งยา ' + pn
		REPL  pn WITH 'AAAAAAA'
		GO TOP
	ENDD
	WAIT WIND NOWA 'ยกเลิกคิวใบสั่งยา' + IIF(que = 1,'ใหม่','เก่า')+'หมดแล้ว'
ELSE
	WAIT WIND NOWA 'ไม่ได้ยกเลิกคิวใบสั่งยา'
ENDI

*********************
PROC OLDPRESC
*********************
PRIVATE printkey,retrykey,mkey, prescr
SAVE SCREEN TO prescr
mrow=0

*DO CLearSCreen
printkey=1
exist=.F.
DO WHIL ! PRINTSTATUS() .AND. ! exist
   ?? CHR(7)
   WAIT 'เครื่องพิมพ์ยังไม่พร้อม  โปรดตรวจสอบให้เรียบร้อย' WINDOW NOWA
   exist = INKEY(0) = 27
ENDD
DO WHIL ! exist
	@ 22,0 CLEA
	DO ClearScreen
	SELE pqueo
	go top
	IF ! ISDIGIT(pn)
		?? CHR(7)
		@ 12,25 SAY 'ใบสั่งยาเก่าได้พิมพ์ไปหมดเรียบร้อยแล้ว'
		mkey=INKEY(5)
		@ 12,0
	ELSE
			select presc
			SET ORDER TO tag pn
			select patient1
			set order to tag hn
			SELE pqueo
		DO WHIL ISDIGIT(pn) .AND. ! exist
			mpn=pn
			mnew=IIF(pque->new,'ใหม่','เก่า')
			select presc
			IF SEEK(mpn)
				@ 12,25 SAY 'กำลังพิมพ์ใบสั่งยาเลขที่ '+pn
				mhn=presc.hn
				mdate=str(day(presc.date),2)+' '+tmonth(month(presc.date))+str(year(presc.date)+543,4)
				mtime=substr(presc.time,1,2)+':'+substr(presc.time,3,2)+' น.'
				select patient1
				seek(mhn)
				mname = De_name(name)
				mage=nowage(birthday)
				mclinic=clinic
				mclass=class
				select social
				seek(mclass)
				mrights=rtrim(name)
				IF FILE('printpx.fxp')
					DO ('printpx')
				ELSE
					DO Printpxp
				ENDI
			ENDI
			SELE pqueo
			REPL  pn WITH 'AAAAAAA'
			GO TOP
		ENDD
	ENDI
	@ 12,0
	WAIT WIND NOWA '  กำลังคอยคิวใบสั่งยาเก่ามาพิมพ์ กด [ESC] ถ้าต้องการยกเลิก  '
	exist = INKEY(30) = 27
ENDD
REST SCREE FROM prescr
