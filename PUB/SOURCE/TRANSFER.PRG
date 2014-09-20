***************************************************************
**					*  โปรแกรม  TRANSFER  *                  **
***************************************************************
DEAC WIND HELP_ADM
dr='99999'
man=0
anyy=subst(mdate,9,2)
yymm=space(4)
hospname=''
to_ward='   '
mno=' '
madm=date()
mdatetrf=ce2be(date())
manf='        '
m.ward='   '
store space(7) to hn,mhn
store space(25) to mward

dimension TrLEVEL(3)

TrLEVEL(1)='   บันทึก '
TrLEVEL(2)='   แก้ไข '
TrLEVEL(3)='  ยกเลิก '   

TrfLEVEL=3
TrfSpace=78/TrfLEVEL	

hdr1='ระบบงานรับผู้ป่วยใน '

***** MAIN LOOP *******

DO WHILE .T.

	FLUSH
	@ 0,0 clear to 2,78
	DO CLEARSCR

	@ 0,(wcols()-len(hdr1))/2 say hdr1 color g+/b
	@ 2,0 SAY REPL('-',80)
	@ 21,0 SAY REPL('-',80)

	store .F. to mexit

	DO WHILE  NOT mexit
		@ 0,0 clea to 1,80
		DO CLEARSCR
	 
*	 	@ 1,0 say '1' color gr+/r
		@ 1,2 say 'HN.'
		@ 1,23 say 'AN.'
		@ 1,45 say 'ชื่อ'
	
		@ 1,8 get mhn size 1,7 picture '!999999' ;
		mess 'กด ESC ถ้าต้องการเลิกงาน  ใส่ W นำหน้าถ้าต้องการหาตามหอผู้ป่วย'
		READ NOLOCK
	 	if LASTKEY() = 27 .OR. EMPTY(mhn)
			@ 0,0 clear to 1,80
			DO CLEARSCR
			on key label PGUP
			return 
		endif
		IF ISDIGIT(mhn)
			m.hn=PADZERO(mhn,7)
		
			SELE iptrana
			set order to tag hn
			go top
			dummyan=' '
			nowrec=recno()
			IF seek(m.hn)
				DO WHILE hn=m.hn
					nowrec  = IIF(an>dummyan,recno(),nowrec)
					dummyan = IIF(an>dummyan,an,dummyan)
					skip
				ENDDO
			ELSE
				wait 'ไม่มี HN นี้ในแฟ้มข้อมูลคนไข้ใน ' window timeout 2	
				return to adm_cen
			ENDIF
		
			go nowrec
			scat memvar
			DO InputTransfer
		ELSE
			IF LEFT(mhn,1) = 'W'
				mhn = SUBS(mhn,2,3)
				SELE ward
				SET ORDER TO 1
				IF SEEK(mhn)
					wardname = name
					disctemp = tempdir+SYS(3)
					SELE iptrana
					COPY TO (DISCTEMP) FOR ward_now = mhn ;
					.AND. EMPTY(datedsc) 
					dbfuse = disctemp
					use (disctemp) IN 0 alia disctemp
					dbfuse = ''
					SELE disctemp
					REPL ALL dr WITH 'อยู่'
					FLUSH
					SET RELA TO hn INTO patient1
					GO TOP
					DEFINE WIND BrowFull FROM 3,1 TO 20,78 SHAD TITLE '  รายชื่อผู้ป่วยในหอ'+wardname+'  '
					DEFINE WIND shownum FROM 21,1 TO 23,78 
					msg = '[Enter] = เปลี่ยนสถานะระหว่าง อยู่ และ ย้าย  [Esc] = เสร็จเรียบร้อย'
					@ 24,0
					@ 24,Center(msg) SAY msg COLO R+
					ACTI WIND shownum
					? '     จำนวนคนไข้ในตึก',reccount(),' คน'
					ON KEY LABEL ENTER REPL dr WITH IIF(dr='อยู่','ย้าย','อยู่')
					BROW FIELD hn :H= 'เลขที่ HN' ,aan =right(an,5)+'-'+left(an,2) :H='เลขที่ AN',named = DE_NAME(patient1.name) : H = 'ชื่อผู้ป่วย' ,;
					datea = CE2BE(dateadm,2) :H = 'วันที่รับไว้',dr :H='สถานะ' NOMO WIND browfull FREE hn
					RELE WIND browfull
					RELE WIND shownum
					ON KEY LABEL ENTER
					@ 23,0
					LOCA FOR dr = 'ย้าย'
					DO WHIL ! EOF()
						SCAT MEMV
						DO InputTransfer
						SELE disctemp
						CONT
					ENDD
					SELE disctemp
					USE
					DELE FILE (disctemp+'.dbf')
					STOR SPAC(7) TO mhn
				ENDI
			ENDI
		ENDI		
	ENDD
ENDDO
FLUSH
sele iptrana
set order to hn
on key label PGUP
on key label Alt+1
on key label Alt+2
on key label Alt+3

return

***********************************************
PROC NEWIN_S
***********************************************
PRIV nowrec, nowdate
sele  medrec
	set order to tag hn
	IF SEEK(m.hn)
		nowrec = RECNO()
		nowdate = date
		SKIP
		DO WHIL hn = m.hn .AND. ! EOF()
			IF date > nowdate
				nowrec = RECNO()
				nowdate = date
			ENDI
			SKIP
		ENDD
		GO nowrec
		repl who with 'W'+m.ward_adm
		FLUSH
	ENDI
sele  transfer
	insert into transfer from memvar
	FLUSH
sele iptrana
	set order to tag an
	seek m.an
	m.date_now = m.date_out
	m.time_now = m.time_out
	m.ward_now = m.ward_to
	gather memvar
	FLUSH

************* Reinitialize data
STOR SPAC(7) TO mhn
man=0
m.ward='   '
store space(25) to mward

sele transfer
	scat memv blank
sele iptrana
	set order to tag hn
	scat memv blank
retu	

PROC INPUTTRANSFER
@ 1,2 say 'HN.'
@ 1,8 SAY m.hn
@ 1,30 say subs(an,3,5)+'-'+subs(an,1,2) 
SELE patient1
seek m.hn
@ 1,50 say De_Name(name)
store .T. TO mexit
SELE transfer
SET order to tag an
IF SEEK(m.an)
	m.transfer = .T.
ENDIF
m.date_in = m.date_now
m.time_in = m.time_now
m.wardfrom= m.ward_now
@ 7,30 say 'หอผู้ป่วย '
SELE ward
SET ORDER TO TAG clinic
SEEK m.ward_now
@ 7,40 SAY  ward->name
@ 10,2 say 'วันที่รับไว้ในหอผู้ป่วย'
@ 10,28 say CE2CBE(m.date_in)
@ 12,2 say 'วันที่ย้ายผู้ป่วย'
@ 12,28 get mdatetrf PICT '99/99/9999' VALID TRUEDATE(mdatetrf) and BETWEEN(be2ce(mdatetrf),m.date_in,date()) ;
MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
@ 12,40 get mmdate defa space(12) when showbe(mdatetrf,mmdate)
@ 13,2 say 'หอผู้ป่วยที่ย้ายไป '
@ 13,28 get m.ward WHEN Inputward(m.ward) VALID (CheckWard(m.ward,mward) .AND. SameWard(m.ward,m.ward_now)) ;
MESS 'ใส่รหัสหอผู้ป่วย'
@ 13,31 get mward DISA COLO ,,,,,,,,,/w
READ NOLOCK
m.date_out = BE2CE(mdatetrf)
m.time_out = substr(time(),1,2)+substr(time(),4,2)
m.ward_to = m.ward
xx=1 
@ 21,0 SAY REPL('-',80)
@ 22,0
DO WHIL xx<=TrfLEVEL
	@ 22,1+TrfSpace*(xx-1) PROMPT TrLEVEL(xx) 
	xx=xx+1
ENDD
MENU TO ChTRF
IF ChTRF=0 
	ChTRF = TrfLEVEL
ENDI
DO CASE
	CASE ChTRF=1   && รายการต่อไป
		do newin_s
		@ 0,0 clear to 1,78
		DO CLEARSCR
	CASE ChTRF=3
		@ 0,0 clear to 1,78
		DO CLEARSCR
	CASE ChTRF=4
		@ 0,0 clear to 1,78
		DO CLEARSCR
		exit
ENDC
