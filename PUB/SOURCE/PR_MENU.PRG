********************************************************************************
*  โมดูลสำหรับขึ้นเมนูให้เลือกว่าจะพิมพ์บัตรผู้ป่วยหรือพิมพ์ใบนัด              *
********************************************************************************

PRIVATE Colspace,PreScr
SET ESCA ON
ON ESCAPE STORE .T. TO exist
DIME PrintMenu(5),PrintMess(5)
PrintMenu(1)='N=ใหม่ทุกคน'
PrintMenu(2)='E=ใหม่หนึ่งคน'
PrintMenu(3)='O=ผู้ป่วยเก่า'
PrintMenu(4)='S=Summary'
PrintMess(1)='พิมพ์บัตรผู้ป่วยนอกใหม่ทุกคน'
PrintMess(2)='พิมพ์บัตรผู้ป่วยนอกใหม่ทีละคน'
PrintMess(3)='พิมพ์บัตรผู้ป่วยนอกเก่า'
PrintMess(4)='พิมพ์ซ่อมใบ Summary (รง.501 รง.502 รง.503)'
NumPr=4              && จำนวนรายการหลัก
ColSpace=78/NumPr    && ระยะห่างระหว่างแต่ละรายการ
ChPrint=1               && รายการที่เลือก
@ 22,0 CLEA
SAVE SCREEN TO PreScr
DO WHIL ChPrint>0
   DO title WITH 'รายการพิมพ์'
	@ 2,0 SAY REPL('-',80)
   xx=1
   DO WHIL xx<=NumPr
      @ 22,1+ColSpace*(xx-1) PROMPT PrintMenu(xx) MESSAGE PrintMess(xx)
      xx=xx+1
   ENDD
   = ENGMODE()
   MENU TO ChPrint
   @ 22,0
   DO CASE
      CASE ChPrint=0
         RETU
      CASE ChPrint=1
         DO Pr_card WITH .T.
      CASE ChPrint=2
         DO Pr_card WITH .F.
      CASE ChPrint=3
         DO PrOld
      CASE ChPrint=4
         DO PrSumary
   ENDC
   DO MainScr
ENDD
SET ESCA OFF
ON ESCAPE STORE .T. TO exist
REST SCREEN FROM PreScr

PROC PR_CARD
PARA PrintAll
PRIVATE printkey,retrykey,mkey
@ 22,0 CLEA
@ 3,0 CLEA TO 20,79
printkey=1
exist=.F.
DO WHIL ! PRINTSTATUS() .AND. ! exist
   ?? CHR(7)
   WAIT 'เครื่องพิมพ์ยังไม่พร้อม  โปรดตรวจสอบให้เรียบร้อย' WINDOW
ENDD
IF exist
	RETU
ENDI
@ 3,0 CLEA TO 20,79
SELE printque
SET ORDER TO TAG hn
go top
IF ! ISDIGIT(hn)
   ?? CHR(7)
   @ 12,25 SAY 'บัตรคนไข้ใหม่ได้พิมพ์ไปหมดเรียบร้อยแล้ว'
   mkey=INKEY(5)
ELSE
   DO WHIL ISDIGIT(hn) .AND. ! exist
      SELE patient1
      SET ORDER TO 1
      IF SEEK(printque->hn)
         @ 12,25 SAY 'กำลังพิมพ์บัตรเลขที่ '+hn
         IF FILE('printopd.fxp')
         	DO ('Printopd')
         ELSE
         	DO propdp
         ENDI
      ENDI
      SELE printque
      REPL NEXT 1 hn WITH 'AAAAAAA'
      FLUSH
      GO TOP
      IF ! PrintAll
         exist=.T.
      ENDI
   ENDD
ENDI

PROC PROLD
PRIVATE mstart,mend
@ 3,0 CLEA TO 20,79
STORE SPACE(7) TO mstart,mend
@ 10,25 SAY 'เริ่มพิมพ์ตั้งแต่เลขที่  ' GET mstart PICT '9999999'
@ 12,25 SAY ' พิมพ์ไปจนถึงเลขที่      ' GET mend PICT '9999999' VALID mend>=mstart
READ NOLOCK
exist=.F.
DO WHIL ! PRINTSTATUS() .AND. ! exist
   ?? CHR(7)
   WAIT 'เครื่องพิมพ์ยังไม่พร้อม  โปรดตรวจสอบให้เรียบร้อย' WINDOW
ENDD
IF exist
	RETU
ENDI
DO WHIL mstart<=mend .AND. ! exist
	SELE patient1
	SET ORDER TO 1
	mseek=PADZERO(mstart,7)
	IF ! SEEK(mseek)
	  	?? CHR(7)
		WAIT 'ไม่มีบัตรผู้ป่วยเลขที่ '+mseek WINDOW TIMEOUT 1
	ELSE
	IF FILE('printopd.fxp')
			DO ('printopd')
		ELSE
			DO propdp
		ENDI
	ENDI
	mstart=LTRIM(STR(VAL(mstart)+1))
ENDD

PROC PRAPPO
