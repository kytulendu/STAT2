DO OpenLanMaster
DEAC WIND ALL
DO CLEARSCREEN
@ 23,0 CLEA
expiredate = CE2BE(DATE()-(5*365),2)
@ 12,10 SAY 'ต้องการล้มบัตรที่มาตรวจครั้งสุดท้ายก่อนวันที่  ' ;
GET expiredate PICT '99/99/99' VALID TrueDate(expiredate)
READ NOLOCK
IF LASTKEY() # 27
	tempfile = tempdir+SYS(3)
	SELE 0
	dbfuse = tempfile
	CREA TABLE (tempfile) ;
	(HN C(7),SEX C(4),NAME C(36),LASTDATE D(8),STATUS C(7))
	INDEX ON hn TAG hn
	USE (tempfile) ALIA temp
	dbfuse = ''
	SELE patient1
	SET ORDER TO TAG lastdate DESC
	expiredate = BE2CE(expiredate)
	IF ! SEEK(expiredate)
		GO RECNO(0)
	ENDI
	m.status = 'ไม่ล้ม'
	m.lastdate=lastdate
	DO WHIL lastdate <= m.lastdate .AND. ! EOF()
		m.hn = hn
		m.lastdate = lastdate
		m.name = De_name(name)
		INSERT INTO temp FROM MEMV
		FLUSH
		WAIT WIND ALLTRIM(STR(RECNO('temp'))) NOWA
		SKIP
	ENDD
	SELE temp
	GO TOP
	PUSH KEY CLEA
	ON KEY LABEL F1 DO ExpireHelp
	ON KEY LABEL F2 DO deleall
	ON KEY LABEL F3 DO undeleall
	ON KEY LABEL F4 DO delerest
	ON KEY LABEL F5 DO undelerest
	ON KEY LABEL HOME GO TOP
	ON KEY LABEL END GO BOTT
	ON KEY LABEL CTRL+F DO FindExpire
	ON KEY LABEL CTRL+P DO PrintDele
	ON KEY LABEL ENTER REPL status WITH IIF(status='ล้ม','ไม่ล้ม','ล้ม')
	KEYB ' '
	DEFINE WIND show1 FROM 0,30 TO 2,78 SHAD
	ACTI WIND show1
	? 'จำนวนบัตรที่ล้มทั้งหมด '+ALLTRIM(STR(RECCOUNT()))+' ใบ'
	DEFINE WIND browicd FROM 3,2 TO 20,77 SHAD PANEL ;
	TITLE '  รายชื่อและเลขที่บัตรที่จะล้ม  ' FOOT 'กด [Esc] เมื่อเสร็จ'
	ACTI SCREE
		@ 23,0 SAY ;
'               F1 = ขอดูความช่วยเหลือ  CTRL+W = ทำงานต่อ'
	BROW FIELD hn :h='เลขที่ HN',name :h='ชื่อ-นามสกุล',;
	tdate = CE2CBE(lastdate) :h='วันมาครั้งสุดท้าย', ;
	status :h='ล้ม/ไม่ล้ม' FREE hn WIND browicd NOMO
	SCAN FOR status = 'ล้ม'
		WAIT WIND NOWA 'กำลังล้มบัตรเลขที่ '+temp.hn
		SELE patient1
		SET ORDER TO TAG hn
		DO WHIL SEEK(temp.hn)
			SCAT MEMV BLANK
			GATH MEMV
			FLUSH
		ENDD
		SELE patient2
		DO WHIL SEEK( temp.hn)
			SCAT MEMV BLAN
			GATH MEMV
			FLUSH
		ENDD
		SELE CONTACT
		DO WHIL SEEK(temp.hn)
			SCAT MEMV BLANK
			GATH MEMV
			FLUSH
		ENDD
		SELE temp
	ENDS
	KEYB '!'
	RELE WIND browicd
	RELE WIND show1
	ACTI SCREE
	@ 23,0
	DO CLEARSCREEN
	POP KEY
	USE
	DELE FILE (tempfile+'.dbf')
ENDI

PROC EXPIREHELP
define window instr from 1,0 to 10,78 shadow COLO bg+/gr+
activate window instr
@ 0,1 say 'F2 = ล้มบัตรหมดทุกคน'
@ 1,1 say 'F3 = ไม่ล้มบัตรทุกคน'
@ 2,1 say 'F4 = ล้มบัตรที่เหลือตั้งแต่ใบที่แถบแสงอยู่'
@ 3,1 say 'F5 = ไม่ล้มบัตรที่เหลือตั้งแต่ใบที่แถบแสงอยู่'
@ 4,1 SAY '[HOME] = ไปที่คนแรก'
@ 5,1 SAY '[END] = ไปที่คนสุดท้าย'
@ 6,1 SAY 'CTRL+F = ค้นหาจากเลขที่ผู้ป่วยนอก'
@ 7,1 SAY 'CTRL+P = พิมพ์รายชื่อคนที่จะล้มบัตร'
wait '' window TIMEOUT 30
release window instr

PROC DELEALL
_nowrec=RECNO()
REPL ALL status WITH 'ล้ม'
FLUSH
GO _nowrec

PROC UNDELEALL
_nowrec=RECNO()
REPL ALL status WITH 'ไม่ล้ม'
FLUSH
GO _nowrec

PROC DELEREST
_nowrec=RECNO()
REPL status WITH 'ล้ม' REST
FLUSH
GO _nowrec

PROC UNDELEREST
_nowrec=RECNO()
REPL status WITH 'ไม่ล้ม' REST
FLUSH
GO _nowrec

PROC PRINTDELE
_nowrec = RECNO()
SET CONS OFF
_pageno=1
_plineno=0
_PLOFFSET = 0
_plength=41
ON PAGE AT line _plength-2 DO foreject
SET ORDER TO 1
PRINTJOB
IF ! CANCELPRINT()
	SET PRINT ON
*	SET CONS OFF
	SCAN FOR status = 'ล้ม'
		? hn,'  ',name
	ENDS
	?
	EJECT
	EJECT PAGE
	SET PRINT OFF
*	SET CONS ON
	SET ORDER TO 0
	GO _nowrec
ENDI
ENDPRINT
SET PRIN OFF
SET CONS ON
ON PAGE

PROC FINDEXPIRE
DEFINE WIND find FROM 12,20 TO 16,60 SHAD
ACTI WIND find
ON KEY LABEL ENTER
@ 1,5 SAY 'ต้องการไปที่หมายเลข HN ' GET fhn DEFA SPACE(7) PICT '#######'
READ NOLOCK
ON KEY LABEL ENTER REPL status WITH IIF(status='ล้ม','ไม่ล้ม','ล้ม')
IF LASTKEY() # 27
	fhn = PADZERO(fhn)
	SET ORDER TO 1
	IF ! SEEK(fhn)
		GO RECNO(0)
	ENDI
	SET ORDER TO 0
ENDI
RELE WIND find

PROC FOREJECT
EJECT PAGE
EJECT