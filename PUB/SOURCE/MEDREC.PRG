**************************************************************************
*    						 MEDREC
**************************************************************************
@ 3,0 clear to 20,78
@ 22,0 clear to 24,78
SELE patient1
SET RELA TO
DIME REC(4),RecMess(4)
Rec(1)=padr('ยืมแฟ้ม',20,' ')
Rec(2)=padr('คืนแฟ้ม',20,' ')
Rec(3)=padr('แฟ้มค้างส่ง',20,' ')
Rec(4)=padr('เลิกงาน',20,' ')
RecMess(1)='ยืมแฟ้มผู้ป่วยออกจากห้องบัตร'
RecMess(2)='คืนแฟ้มผู้ป่วย'
RecMess(3)='พิมพ์รายชื่อแฟ้มค้างส่ง'
RecMess(4)=''
numrec = 4
DEFINE WIND RECMENU FROM 4,5 TO 4+ALEN(REC)+3,35 SHAD COLO gr+/w TITLE '  ยืม/คืนแฟ้มผู้ป่วยนอก '
DO WHIL .T.
	ACTI WIND RECMENU
	FOR i=1 TO ALEN(REC)
		@ i,3 PROMPT REC(i)
	NEXT
	MENU TO ChRec
	ACTI SCREE
	DO CASE
		CASE ChRec = 1
            DO request
			DO CLEARSCREEN
		CASE ChRec = 2
            DO comeback
			DO CLEARSCREEN
		CASE ChRec = 3
      	    Do printrec
			DO CLEARSCREEN
		CASE ChRec = 4
			RELE WIND RECMENU
	    	RETURN
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND RECMENU
*SET COLO TO bg+/b

********************
PROC REQUEST
********************
DEAC WIND RECMENU
DO WHILE .T.

 @ 3,0 clear to 20,78
 @ 22,0 clear to 24,78
 
 SELE medrec
 scat memvar blank
 
 dimension rmenu(2)
 rmenu(1)='    บันทึก      '
 rmenu(2)='     แก้ไข      '

 store .F. to mexit
 DO WHILE  NOT mexit

  mhn=0
  @ 4,2 say 'HN.'
  @ 4,45 say 'ชื่อ'
  @ 4,8 get mhn size 1,7 picture '9999999' && Valid !empty(mhn)
   	 READ NOLOCK
 	if LASTKEY() = 27 .OR. EMPTY(mhn)
		wait 'ยกเลิกการยืมแฟ้ม' window timeout 1
		DO ClearScreen
		RecSpace=78/NumRec    && ระยะห่างระหว่างแต่ละรายการ
		return to medrec
	endif
	m.hn=padl(alltrim(str(mhn)),7,'0')
  SELE patient1
	seek m.hn
		IF .NOT. FOUND()
			WAIT "ไม่มี HN นี้  กดปุ่มใดๆเพื่อใส่ HN ใหม่" window
			@ 3,0 clear to 20,78
			loop
		ENDIF	
	@ 4,50 say De_Name(name)
  SELE medrec
*  	set filter to status=.F.
 	seek m.hn
		IF FOUND()
			WAIT "มีผู้ยืมแฟ้ม HN นี้แล้ว กดปุ่มใดๆเพื่อใส่ HN ใหม่" window
			@ 3,0 clear to 20,78
			loop
		ENDIF	
   store .T. TO mexit
 ENDDO

   m.status = .F.
   m.time=substr(time(),1,2)+substr(time(),4,2)
   m.date=date()
   	
   @ 5,10 say 'วันที่ยืม'
   @ 5,20 say ce2be(date())
   @ 6,10 say 'ผู้ยืม'
   @ 6,20 get m.who
	READ NOLOCK
   m.who=padblank(m.who,6)
 @ 23,0 clear
		n=1
		for n=1 to 2
			@ 23,(n-1)*25+5 prompt rmenu(n)
		endfor
		menu to choice
		do case 
			case choice=1   && รายการต่อไป
				do INS_REQ
				loop
			case choice=2
				@ 3,0 clear to 20,78
				@ 22,0 clear to 24,78
				loop
		endcase
ENDDO

************
PROC INS_REQ
************
SELE medrec

SET REPROCESS TO 2 SECONDS
 IF FLOCK()
 		go top
		if ! empty(hn) .or. eof()
			appe blank
		endif	
			gather memvar
			FLUSH
			scat memvar blank
		SELE patient1
		REPL clinic WITH RIGHT(m.who,3)
		FLUSH
		WAIT 'บันทึกการยืมแฟ้มเรียบร้อยแล้ว' WIND TIME 1 
 ELSE
       	WAIT 'ไม่สามารถบันทึกการยืมแฟ้มได้ ยกเลิกการทำงาน' WIND TIME 1
 ENDIF

UNLOCK ALL
SET REPROCESS TO AUTOMATIC
@ 3,0 clear to 20,78
@ 22,0 clear to 24,78

*************
PROC COMEBACK
*************
DEAC WIND RECMENU
DO WHILE .T.

 @ 3,0 clear to 20,78
 @ 22,0 clear to 24,78

 dimension cmenu(2)
 cmenu(1)='     บันทึก     '
 cmenu(2)='     แก้ไข      '

 store .F. to mexit
 DO WHILE  NOT mexit

  mhn=0
  @ 4,2 say 'HN.'
  @ 4,45 say 'ชื่อ'
  @ 4,8 get mhn size 1,7 picture '9999999' && valid !empty(mhn)
   	 READ NOLOCK
 	if LASTKEY() = 27 .OR. EMPTY(mhn)
		wait 'ยกเลิกรายการคืนแฟ้ม' window timeout 1
		DO ClearScreen
		RecSpace=78/NumRec    && ระยะห่างระหว่างแต่ละรายการ
		return to medrec
	endif
	m.hn=padl(alltrim(str(mhn)),7,'0')
  SELE patient1
	IF seek(m.hn)
		@ 4,50 say De_Name(name)
	ELSE
		WAIT "ไม่มี HN นี้  กดปุ่มใดๆเพื่อใส่ HN ใหม่" window
		@ 3,0 clear to 20,78
		loop
	ENDIF	
  SELE medrec
 	IF ! seek(m.hn)
		WAIT "ไม่มีรายการยืม HN นี้  กดปุ่มใดๆเพื่อใส่ HN ใหม่" window
		@ 3,0 clear to 20,78
		loop
    ELSE	
		scat memvar
	ENDI	
	  store .T. TO mexit
 ENDDO

   m.status = .T.
   @ 5,10 say 'วันที่ยืม'
   @ 5,20 say ce2cbe(m.date)
   @ 6,10 say 'ผู้ยืม'
   @ 6,20 say m.who
   @ 7,10 say 'วันที่คืน'
   @ 7,20 say ce2cbe(date())
   
 @ 23,0 clear
		n=1
		for n=1 to 2
			@ 23,(n-1)*25+5 prompt cmenu(n)
		endfor
		menu to choice
		do case 
			case choice=1   && รายการต่อไป
				do INS_CAME
				loop
			case choice=2
				@ 3,0 clear to 20,78
				@ 22,0 clear to 24,78
				loop
		endcase
ENDDO

*************
PROC INS_CAME
*************
mreturn = ce2be(date())
yy = subs(mreturn,9,2)

SELE 0
 target=patientdir+'FILE'+yy+'.DBF'
	dbfuse = target
	if !file(target)
		create table (target) (HN C(7), DATE D, TIME C(4), WHO C(6), STATUS L)
	endif
 USE (target) alias  CAMEFILE
 dbfuse = ''
SELE medrec

SET REPROCESS TO 2 SECONDS
 IF FLOCK()
		insert into  CAMEFILE from memvar
		FLUSH
			scat memvar blank
			gather memvar
			FLUSH
		SELE patient1
		REPL clinic WITH 'ZZZ'
		FLUSH
		WAIT 'บันทึกการคืนแฟ้มเรียบร้อยแล้ว' WIND TIME 1 
 ELSE
       	WAIT 'ไม่สามารถบันทึกการคืนแฟ้มได้ ยกเลิกการทำงาน'
 ENDIF

UNLOCK ALL
SELE camefile
	use
SET REPROCESS TO AUTOMATIC
@ 3,0 clear to 20,78
@ 22,0 clear to 24,78

***********************
PROC PRINTREC
***********************
DEAC WIND RECMENU
dimension Pmenu(2)
 Pmenu(1)=' แสดงข้อมูลทางจอภาพ'
 Pmenu(2)=' พิมพ์ข้อมูลลงกระดาษ '

mdate1=ce2be(date())
SELE MEDREC
SET ORDER TO TAG hn
SET RELA TO hn INTO PATIENT1

@ 3,0 clear to 20,78
@ 22,0 clear to 24,78
SET FILT TO STATUS = .F.
SET ORDER TO TAG date

@ 11,2 say 'วันที่ยืมแฟ้ม'
@ 11,28 get mdate1  PICT '99/99/9999' VALID TRUEDATE(mdate1) ;
 		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
	READ NOLOCK

MDATEREQ=BE2CE(MDATE1)
IF ! seek(mdatereq)
	=TONE(1200,5)
	=TONE(700,5)
	WAIT WIND NOWA 'ไม่มีแฟ้มค้างส่ง'
ELSE
	WAIT WIND NOWA 'โปรดคอยสักครู่ กำลังค้นหาข้อมูลอยู่'
	SELE 0
	reportdbf = tempdir+SYS(3)
	dbfuse = reportdbf
	CREATE TABLE (reportdbf) ;
		(HN C(7),NAME C(36),D_REQ C(12),WHO C(6),STATUS L)
	USE (reportdbf) ALIA reportdbf
	dbfuse = ''
	SELE medrec
	DO WHILE date = MDATEreq .AND. ! EOF()
		scat fields HN, DATE, WHO, STATUS memvar
		m.d_req=ce2cbe(m.date)
		m.name = patient1.name
*		SELE WARD
*			set order to tag clinic
*			SEEK m.ward_now
*			m.wardname=NAME 
		INSERT INTO (reportdbf)  FROM memvar								
		FLUSH
		skip
	ENDDO

	SELE reportdbf
	index on who+hn tag whohn
	set order to 1
	totalnumber = RECCOUNT()
	reportfile=tempdir+SYS(3)+'.txt'
	SET PRINT TO &reportfile
	SET PRINT ON
	SET CONS OFF
	_wrap=.F.
	_plength=41
	_peject='NONE'
	_pageno=1
	_plineno=0
	_PLOFFSET = 0
	header = '       รายชื่อแฟ้มที่ยังไม่ส่งคืน  '
	ON PAGE AT line _plength-2 DO fileborrow WITH .T.,header
	KEYB ' '
	WAIT WIND NOWA 'โปรดคอยอีกสักครู่ กำลังจัดทำรายงานอยู่'
	PRINTJOB
		DO fileborrow WITH .F.,header
		SCAN
			? hn,'    ',De_Name(name) ,'   ',who
		ENDS
		?
		? 'หมายเหตุ'
		? SPACE(10)+'แฟ้มค้างส่งที่ยืมเมื่อวันที่ '+CE2CBE(MDATEREQ)
		? SPACE(10)+'จำนวนแฟ้มค้างส่งรวม '+LTRIM(STR(totalnumber))+' แฟ้ม'
		?
	ENDPRINTJOB
	mkeylabel=ON('KEY','F1')
	ON KEY LABEL F1 DO helpbrow
	DO Endprint WITH '  รายชื่อแฟ้มที่ยังไม่ส่งคืน  ',reportfile
	ON KEY LABEL F1 &mkeylabel
	DELE FILE &reportfile
	SELE reportdbf
	USE
	DELE FILE (reportdbf+'.DBF')
ENDI

@ 3,0 clear to 20,78
@ 22,0 clear to 24,78
SELE MEDREC
set order to tag HN

PROC FILEBORROW
PARA _foreject,_header
PRIVATE mprint,mhosp
mhosp=TRIM(hosp_name)
*mtime1='ตั้งแต่วันที่ '+CE2CBE(startdate)+' ถึง วันที่ '+CE2CBE(enddate)
IF _foreject
	eject page
	eject
ENDI
mpagep='หน้าที่ '+LTRIM(STR(_pageno))
spacecol=CENTER(_header)
?SPACE(spacecol)+_header+SPACE(65-spacecol-LEN(_header))+mpagep
?SPAC(CENTER(mhosp))+mhosp
?
?' เลขที่ผู้ป่วยนอก          ชื่อ - นามสกุล          ผู้ยืมแฟ้ม'
?
IF _foreject
	?
ENDI

