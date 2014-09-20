***************************************************************
**					     *  โปรแกรม  EDIT_ADM  *             **
***************************************************************
DEAC WIND help_edit
yy=substr(mdate,9,2)

mssn='99-       - '
mfacn='99'+space(14)
mhn=0
man=0
anyy=subst(mdate,9,2)
hospname=''
dep='  '
ward_adm='   '
ward_now='   '
store space(25) to mdep,mward

dimension emenu(3)
 emenu(1)=' บันทึกการแก้ไข '
 emenu(2)=' ยกเลิกการแก้ไข '
 emenu(3)=' ลบรายการนี้ '
 
hdr1='ระบบงานแก้ไขการรับผู้ป่วยใน '

***** MAIN LOOP *******

DO WHILE .T.

FLUSH
@ 0,0 clear to 1,78
DO CLEARSCR

on key label Alt+1 _curobj=objnum(m.hn)
on key label Alt+2 _curobj=objnum(m.pttyp)
on key label Alt+3 _curobj=objnum(mdate)

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

	 @ 1,0 say '1' color gr+/r
     @ 1,2 say 'HN.'
 	 @ 1,23 say 'AN.'
 	 @ 1,34 say '/'
 	 @ 1,45 say 'ชื่อ'
	
		@ 1,28 get man size 1,5 picture '99999' valid !empty(man) mess 'กด ESC ถ้าต้องการเลิกงาน'
		@ 1,35 get anyy picture '99' 
		    READ NOLOCK
	 	if readkey()=12 or readkey()=268
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
mdate=CE2BE(m.dateadm)

@ 4,0 say '2' color gr+/r
@ 4,2 say 'สิทธิการรักษา'
@ 4,16 get m.pttyp picture '99' valid v_pttyp()
	READ NOLOCK

@ 12,0 say '3' color gr+/r
@ 12,2 say 'วันที่รับไว้ในโรงพยาบาล'
@ 12,28 get mdate  PICT '99/99/9999' VALID TRUEDATE(mdate) ;
 		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
@ 12,40 get mmdate defa space(12) when showbe(mdate,mmdate)

@ 13,2 say 'แผนก'
@ 13,7 get m.dep WHEN Inputdep(m.dep) VALID CheckDep(m.dep,mdep) ;
	MESS 'ใส่รหัสแผนกที่รับผู้ป่วย'
@ 13,9 get mdep DISA COLO ,,,,,,,,,/w

@ 13,37 say 'หอผู้ป่วย'
@ 13,48 get m.ward_adm WHEN Inputward(m.ward_adm) VALID CheckWard(m.ward_adm,mward) ;
	MESS 'ใส่รหัสหอผู้ป่วย'
@ 13,51 get mward DISA COLO ,,,,,,,,,/w

	READ NOLOCK

 m.an=anyy+padl(alltrim(str(m.man)),5,'0')
 m.dateadm=BE2CE(mdate)
 m.timeadm=substr(time(),1,2)+substr(time(),4,2)
 m.ssn=substr(m.mssn,1,2)+substr(m.mssn,4,7)+substr(m.mssn,12,1)
 *m.facn=m.facn1
 m.dep=padl(m.dep,2,'0')
 m.ward_now=m.ward_adm
 m.result = m.dep

@ 23,0 clear
		n=1
		for n=1 to 3
			@ 23,(n-1)*20+1 prompt emenu(n)
		endfor
		menu to choice
		do case 
			case choice=1   && รายการต่อไป
				do newins_a
				@ 0,0 clear to 1,78
				DO CLEARSCR
			case choice=2
				@ 0,0 clear to 1,78
				DO CLEARSCR
			case choice=3   && ลบรายการนี้
				sele  medrec
				_man = m.an
				SET ORDER TO TAG hn
					seek m.hn
					repl who with '99999'		
					FLUSH
				sele transfer
					seek m.an
						do while an=m.an
							scat memv blank
						gath memv
						FLUSH
						enddo
				sele iptrana
					scat memv blank
					gather memv		
					FLUSH
					set order to tag hn
				sele Cancelan
						go top
						if ISDIGIT(an) .or. Bof()
							appe blank
						endif	
						REPL an WITH _man
						FLUSH
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

*********************
Procedure v_pttyp
*********************
select social
locate for class=m.pttyp 
if !found()
	??chr(7)
	wait 'Invalid code! Press F1 for help' window timeout 1
	return 0
endif
return

**************
PROC NEWINS_A
**************
sele  medrec
	set order to tag date desc
	locate for hn=m.hn
	repl who with 'W'+m.ward_adm
	FLUSH
sele  iptrana
	gather memvar
	FLUSH

************* Reinitialize data
dr='99999'
mssn='99-       - '
mhn=0
man=0
anyyf=yy
mfacn='99'+space(14)
facn1='99'+space(14)
dep='  '
ward_adm='   '
store space(25) to mdep,mward

select iptrana
	set order to tag hn
	scatter memvar blank
