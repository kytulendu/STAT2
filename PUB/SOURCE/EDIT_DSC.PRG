***************************************************************
**					     *  โปรแกรม  EDIT_DSC  *             **
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
mmhn=space(7)
STOR SPAC(2) TO outcause
STOR SPAC(3) TO clinic,wardnow,m.clinic,mclinic,nowclinic
STOR SPAC(4) TO outtime
STOR SPAC(6) TO m.doctor
STOR SPAC(5) TO outplace
STOR SPAC(25) TO mward
STOR SPAC(30) TO referoutplace,mdoctor

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
mdate1=CE2CBE(m.dateadm)
mdate2=CE2BE(m.datedsc)
dcstatus=subs(disc,1,1)
dctype=subs(disc,2,1)

@ 4,0 say '2' color gr+/r
@ 4,2 say 'สิทธิการรักษา'
SELE social
  GO TOP	
  locate for subst(class,1,2)=m.pttyp  
  @ 4,16 SAY  social->name

@ 11,0 say '3' color gr+/r
@ 11,2 say 'วันที่รับไว้ในโรงพยาบาล'
@ 11,28 say mdate1 

@ 11,45 say 'หอผู้ป่วยที่รับ'
SELE ward
  GO TOP	
  locate for subst(clinic,1,3)=m.ward_now 
  @ 11,61 SAY  ward->name

@ 13,2 say 'วันที่จำหน่ายจากโรงพยาบาล'
@ 13,30 get mdate2  PICT '99/99/9999' VALID TRUEDATE(mdate2) and BETWEEN(be2ce(mdate2),m.dateadm,DATE()) ;
 		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
@ 13,45 get mmdate2 defa space(12) when showbe(mdate2,mmdate2)
@ 13,60 SAY 'เวลา ' GET m.timedsc PICT '@R ##:##'

@ 15,0 say '3' color gr+/r
@ 15,2 say 'Discharge status : '
@ 15,21 get dcstatus picture '9' valid v_dc()
@ 15,30 say 'Discharge type   : '
@ 15,49 get dctype picture '9' 
@ 15,52 say 'แพทย์เจ้าของไข้'
@ 15,68 get m.dr WHEN InputDoctor(m.dr) VALID CheckDoctor(m.dr) ;
	MESS 'ใส่รหัสแพทย์ที่ทำการรักษาผู้ป่วย'

	READ NOLOCK

 m.an=anyy+padl(alltrim(str(m.man)),5,'0')
 m.datedsc=BE2CE(mdate2)
* m.timedsc=substr(time(),1,2)+substr(time(),4,2)
 m.disc=dcstatus+dctype
 m.dr=padblank(m.dr)

@ 23,0 clear
		n=1
		for n=1 to 3
			@ 23,(n-1)*20+1 prompt emenu(n)
		endfor
		menu to choice
		do case 
			case choice=1   && รายการต่อไป
				do newins_d
				@ 0,0 clear to 1,78
				DO CLEARSCR
			case choice=2
				@ 0,0 clear to 1,78
				DO CLEARSCR
			case choice=3
				sele iptrana
					STORE CTOD(' / / ') TO mdatedsc
					STORE SPACE(5) TO m.dr
					STORE SPACE(4) TO m.timedsc
					STORE SPACE(3) TO m.disc
					gather memv		
					FLUSH
					set order to tag hn
				@ 0,0 clear to 1,78
				DO CLEARSCR
				EXIT
		endcase
ENDDO
sele iptrana
set order to tag an
on key label PGUP
on key label Alt+1
on key label Alt+2
on key label Alt+3
return

***********************************
Procedure v_dc
***********************************
if !m.dcstatus$'123456789'
	?? chr(7)
	wait 'Invalid input' window timeout 1
	return 0
endif

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

*********************************
PROC NEWINS_D
*********************************
sele  iptrana
	gather  memvar
	FLUSH

************* Reinitialize data
dr='99999'
mhn=0
man=0
dcstatus='2'
dctype='1'
mmhn=space(7)
STOR SPAC(2) TO outcause
STOR SPAC(3) TO clinic,wardnow,m.clinic,mclinic,nowclinic
STOR SPAC(4) TO outtime
STOR SPAC(6) TO m.doctor
STOR SPAC(5) TO outplace
STOR SPAC(25) TO mward
STOR SPAC(30) TO referoutplace,mdoctor
sele iptrana
	set order to tag hn
	scat memv blank
return


