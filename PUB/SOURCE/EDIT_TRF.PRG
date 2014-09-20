***************************************************************
**					*  โปรแกรม  EDIT_TRF  *                  **
***************************************************************
DEAC WIND help_edit

dr='99999'
mhn=0
man=0
anyy=subst(mdate,9,2)
yymm=space(4)
hospname=''
ward_to='   '
mno=' '
madm=date()
m.ward='   '
STOR SPACE(25) TO fromname,toname

dimension emenu(3)
 emenu(1)=' บันทึกการแก้ไข '
 emenu(2)=' ยกเลิกการแก้ไข '
 emenu(3)=' ลบรายการนี้ '

hdr1='แก้ไขการย้ายผู้ป่วยใน '

***** MAIN LOOP *******
DO WHILE .T.

	FLUSH
	@ 0,0 clear to 1,80
	DO CLEARSCR

	@ 0,(wcols()-len(hdr1))/2 say hdr1 color g+/b
	@ 2,0 SAY REPL('-',80)
	@ 21,0 SAY REPL('-',80)

	store .F. to mexit

	DO WHILE  NOT mexit
*	 man=0
		@ 0,0 clea to 1,80
		DO CLEARSCR

		@ 0,(wcols()-len(hdr1))/2 say hdr1 color g+/b
		@ 2,0 SAY REPL('-',80)
		@ 21,0 SAY REPL('-',80)

		@ 1,2 say 'HN.'
		@ 1,23 say 'AN.'
		@ 1,34 say '/'
		@ 1,45 say 'ชื่อ'

		@ 1,28 get man size 1,5 picture '99999' && valid !empty(man)
		@ 1,35 get anyy picture '99'
		READ NOLOCK
	 	if LASTKEY() = 27 .OR. EMPTY(man)
			@ 0,0 clear to 1,80
			DO CLEARSCR
			on key label PGUP
			return
		endif
		m.an=anyy+padl(alltrim(str(m.man)),5,'0')
		SELE iptrana
		set order to tag an
		seek m.an
		IF .NOT. FOUND()
			WAIT "ไม่มี AN นี้  กดปุ่มใดๆเพื่อเริ่มงานใหม่" window
			loop
		ENDIF
		scatter memvar
		@ 1,8 say m.hn color gr+/b
		mhn=subst(hn,1,7)
		SELE patient1
		seek mhn
		@ 1,50 say name
		store .T. TO mexit
	ENDDO

	SELE transfer
	set order to tag an
*	go top
	IF ! seek(m.an)
	    WAIT 'ถึง record สุดท้าย ไม่มีข้อมูลในฐานข้อมูลแล้ว' WINDOW TIMEOUT 2
		EXIT
	 ENDIF
*	set filter to AN=m.an
	scat memvar


	mdate1=CE2BE(m.date_in)
	mdate2=CE2BE(m.date_out)

	@ 11,1 say 'วันที่รับไว้ในหอผู้ป่วย'
	@ 11,26 get mdate1 PICT '99/99/9999' VALID TRUEDATE(mdate1) ;
		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
	@ 11,40 get mmdate1 defa space(12) when showbe(mdate1,mmdate1)

	@ 12,1 say 'หอผู้ป่วยเดิม '
	@ 12,26 get m.wardfrom picture '999'  message 'F1 = List';
	WHEN INPUTWARD(m.wardfrom,m.fromname) VALID CheckWard(m.wardfrom,m.fromname)
    @ 12,34 GET  fromname DISA COLO ,,,,,,,,,/w

	@ 13,1 say 'วันที่ย้ายผู้ป่วย'
	@ 13,26 get mdate2 PICT '99/99/9999' VALID TRUEDATE(mdate2) ;
 		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
	@ 13,40 get mmdate2 defa space(12) when showbe(mdate2,mmdate2)

	@ 14,1 say 'หอผู้ป่วยที่ย้ายไป '
	@ 14,26 get m.ward_to picture '999'  message 'F1 = List' ;
	WHEN InputWard(m.ward_to,toname) VALID (CheckWard(m.ward_to,toname) .AND. SameWard(m.wardfrom,m.ward_to))
    @ 14,34 GET  toname DISA COLO ,,,,,,,,,/w
	READ NOLOCK

	m.date_out = BE2CE(mdate2)
    m.date_in  = BE2CE(mdate1)

	@ 23,0 clear
	n=1
	for n=1 to 3
		@ 23,(n-1)*20+1 prompt emenu(n)
	endfor
	menu to choice
	do case
		case choice=1   && รายการต่อไป
			do newin_s
			@ 0,0 clear to 1,78
			DO CLEARSCR
			sele transfer
			SKIP
			IF EOF()
				WAIT 'ถึง record สุดท้าย ไม่มีข้อมูลในฐานข้อมูลแล้ว' WINDOW TIMEOUT 2
				SKIP -1
			ENDIF
			scat memvar
			exit
		case choice=2
			@ 0,0 clear to 1,78
			DO CLEARSCR
		case choice=3
			sele transfer
			scat memv blank
			gath memv
			FLUSH
			sele iptrana
			set order to tag hn
			@ 0,0 clear to 1,78
			DO CLEARSCR
			EXIT
	endcase
ENDDO
on key label PGUP
on key label Alt+1
on key label Alt+2
on key label Alt+3

return

********************************************************************************
PROC NEWIN_S
********************************************************************************
sele  medrec
	set order to tag hn
	SEEK m.hn
	DO WHIL hn = m.hn .AND. status
		SKIP
	ENDD
	IF EOF()
		APPE BLAN
		REPL hn WITH m.hn,date WITH m.date_out
		FLUSH
	ENDI
	repl who with 'W'+m.ward_to
	FLUSH

sele  transfer
	gather memvar
	FLUSH

sele iptrana
	seek m.an
	m.date_now = m.date_out
	m.time_now = m.time_out
	m.ward_now = m.ward_to
	gather memvar
	FLUSH

************* Reinitialize data
mhn=0
man=0
m.ward='   '
sele transfer
	scat memv blank
sele iptrana
	set order to tag hn
	scat memv blank