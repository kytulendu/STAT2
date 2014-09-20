***************************************************************
**							*  โปรแกรม  ADMIT  *             **
***************************************************************
DEAC WIND HELP_ADM
yy=substr(mdate,9,2)

dimension AdLEVEL(6), AdMess(6)

AdMess(1)='บันทึกรับผู้ป่วยใน โดยไม่พิมพ์ใบสรุป'
AdMess(2)='บันทึกรับผู้ป่วยใน และพิมพ์ รง.501 (ผู้ป่วยทั่วไป)'
AdMess(3)='บันทึกรับผู้ป่วยใน และพิมพ์ รง.502 (ผู้ป่วยคลอด)'
AdMess(4)='บันทึกรับผู้ป่วยใน และพิมพ์ รง.503 (ทารกแรกคลอด)'
AdMess(5)='แก้ไขข้อผิดพลาด'
AdMess(6)='ยกเลิกการบันทึกทั้งหมด และกลับเมนูหลัก'

AdLEVEL(1)= 'บันทึก/ไม่พิมพ์ '
AdLEVEL(2)= '    พิมพ์501' 
AdLEVEL(3)= '    พิมพ์502'
AdLEVEL(4)= '    พิมพ์503'
AdLEVEL(5)= '    แก้ไข'
AdLEVEL(6)= '    ยกเลิก'
   
AdmLEVEL=6
AdmSpace=78/AdmLEVEL	

hdr1='ระบบงานรับผู้ป่วยใน '

mssn='99-       - '
mfacn='99'+space(14)
mhn=0
man=0
anyy=subst(mdate,9,2)
mdateadm=ce2be(date())
dep='  '
ward_adm='   '
ward_now='   '
facn1='9999999999999999'
store space(25) to mdep,mward

select iptrana
	scatter memvar blank

 m.dep='  '

***** MAIN LOOP *******

DO WHILE .T.

	FLUSH
	@ 0,0 clear to 1,78
	DO CLEARSCR

	@ 0,(wcols()-len(hdr1))/2 say hdr1 color g+/b
	@ 2,0 SAY REPL('-',80)
	@ 21,0 SAY REPL('-',80)
 
	store .F. to mexit
	DO WHILE  NOT mexit
		@ 1,2 say 'HN.'
		@ 1,45 say 'ชื่อ'
		@ 1,8 get mhn size 1,7 picture '9999999' mess 'กด ESC ถ้าต้องการเลิกงาน'
		READ NOLOCK
		if LASTKEY() = 27 .OR. EMPTY(mhn)
			@ 0,0 clear to 1,80
			DO CLEARSCR
			on key label PGUP
			return 
		endif
		m.hn=padl(alltrim(str(mhn)),7,'0')
		SELE patient1
		SET ORDER TO TAG hn
		IF .NOT. SEEK(m.hn)
			WAIT "ไม่มี HN นี้  กดปุ่มใดๆเพื่อใส่ HN ใหม่" window
			@ 0,0 clear to 1,78
			DO CLEARSCR
		ELSE
			scat memv		
			@ 1,50 say DE_NAME(m.name)
			SELE iptrana
			set filter to EMPTY(datedsc)
			set order to tag hn
			IF seek(m.hn)  			
				scat memvar
				SELE ward
				SEEK m.ward_now
				DEFINE WIND notice FROM 3,5 TO 11,70 SHAD COLO gr+/w 
				ACTI WIND notice
				@ 1,1 say "          ตรวจพบชื่อผู้ป่วยอยู่ในโรงพยาบาล กรุณาตรวจสอบอีกครั้ง"
				@ 2,1 say "    ถ้าไม่ต้องการทำ ADMIT ต่อ          กด Esc เพื่อเลิกงาน" 
				@ 4,1 say "    HN       AN           WARD                     ADMIT"
				@ 5,1 say hn+'   '+an+'      '+ward->name+' '+ce2cbe(dateadm)
				wait ' '			
				IF lastkey()=27
					clear
					on key label PGUP
					RELE WIND notice
*					SET COLO TO bg+/b
					return to adm_cen
				ENDIF
				RELE WIND notice
*				SET COLO TO bg+/b
	  		ENDIF
			SELE iptrana
			set filter to
  			set order to tag hn	
			store .T. TO mexit
		ENDI
	ENDD

	@ 4,2 say 'สิทธิการรักษา'
	@ 4,16 say m.class 
 
	SELE social
	SEEK m.class 
	@ 4,20 say social->name
 
	SELE patient1
	mage=Nowage(patient1->birthday, patient1.derive)
	thaidate=Ce2Cbe(patient1->birthday)
	curyear=year(date())+543
	@ 7,2 SAY 'วันเกิด '+thaidate
	@ 7,25 SAY 'อายุ ' +mage
	@ 7,37 SAY 'เพศ '+IIF(sex='1','ชาย','หญิง') 

	SELE patient2
	mmarriage=patient2->marriage
	@ 7,48 SAY 'สถานภาพ '+IIF(VAL(patient2->marriage)>0,marry&mmarriage,'')

	SELE occupat
	SEEK patient2->occupa
	@ 8,2 SAY 'อาชีพ '+TRIM(name)

	SELE contact
	@ 9,2 SAY 'ที่อยู่ '+TRIM(contact->address)+;
	IIF(VAL(contact->village)>0,' หมู่ '+contact->village,'')

	SELE address
	SEEK '3'+contact->changwat+contact->ampur+contact->tambon
	@ 10,2 SAY IIF(name='    ','','ต.'+TRIM(name))
	SEEK '2'+contact->changwat+contact->ampur
	@ 10,COL()+1 SAY IIF(name='    ','',' อ.'+TRIM(name))
	SEEK '1'+contact->changwat
	@ 10,COL()+1 SAY 'จ.'+TRIM(name)

	@ 12,2 say 'วันที่รับไว้ในโรงพยาบาล'
	@ 12,28 get mdateadm  PICT '99/99/9999' VALID TRUEDATE(mdateadm) and (be2ce(mdateadm) <= date()) ;
	MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
	@ 12,40 get mmdate defa space(12) when showbe(mdateadm,mmdate) 
	@ 13,2 say 'แผนก'
	@ 13,7 get m.dep WHEN Inputdep(m.dep) VALID CheckDep(m.dep,mdep) ;
	MESS 'ใส่รหัสแผนกที่รับผู้ป่วย'
	@ 13,9 get mdep DISA COLO ,,,,,,,,,/w

	@ 13,37 say 'หอผู้ป่วย'
	@ 13,48 get m.ward_adm WHEN Inputward(m.ward_adm) VALID CheckWard(m.ward_adm,MWARD) ;
	MESS 'ใส่รหัสหอผู้ป่วย'
	@ 13,51 get mward DISA COLO ,,,,,,,,,/w
	READ NOLOCK

	m.pttyp=m.class	   
	m.dateadm=BE2CE(mdateadm)
	m.timeadm=substr(time(),1,2)+substr(time(),4,2)
	m.ssn=substr(m.mssn,1,2)+substr(m.mssn,4,7)+substr(m.mssn,12,1)
	m.facn=m.facn1
	m.dep=padl(m.dep,2,'0')
	m.ward_now=m.ward_adm
	m.date_now=m.dateadm
	m.time_now=m.timeadm
	m.result=m.dep

	xx=1 
	@21,0 SAY REPL('-',80)
	@ 22,0
	DO WHIL xx<=AdmLEVEL
		@ 22,1+AdmSpace*(xx-1) PROMPT AdLEVEL(xx) MESSAGE AdMess(xx)
		xx=xx+1
	ENDD
	MENU TO ChMain
	IF ChMain=0 
		EXIT
	ENDI
	DO CASE
	CASE ChMain=1
		do save_adm
		do INI_VAR
	CASE ChMain=2
   		do save_adm
   		printfile = 'rp501.fxp'
   		IF FILE(printfile)
   			DO (printfile)
   		ELSE
   			DO rp501p
   		ENDI
   		do ini_var 
    CASE ChMain=3
    	do save_adm
    	IF FILE('rp502.fxp')
    		DO ('rp502')
    	ELSE
        	DO rp502p
        ENDI
		do ini_var
    CASE ChMain=4
    	do save_adm
    	IF FILE('rp503.fxp')
    		DO ('rp503')
    	ELSE
    		DO rp503p
    	ENDI
		do ini_var
    CASE ChMain=5
		@ 0,0 clear to 1,78
		DO CLEARSCR
    CASE ChMain=6 or ChMain=0
		@ 0,0 clear to 1,78
		DO CLEARSCR
			exit
	ENDC
ENDD
 
return

**************
PROC SAVE_ADM
**************
SET REPROCESS TO 1 SECONDS
SELE cancelan
GO TOP
anyy = RIGHT(ce2be(date()),2)
DO WHIL ! RLOCK() .AND. ! EOF()
	SKIP
ENDD
IF ISDIGIT(an) .AND. LEFT(an,2) # anyy
	REPL an WITH 'ZZZZZZZ'
	FLUSH
ENDI
IF ! EOF() .AND. ISDIGIT(an) 
	m.an = an
	REPL an WITH 'ZZZZZZZ'
	FLUSH
ELSE
	SELE ancount
	DO WHIL ! LASTKEY() = 27 .AND. ! FLOCK()
		WAIT WIND NOWA 'กำลังเรียกหมายเลข AN อยู่ โปรดคอยสักครู่'
	ENDD
	IF FLOCK()
		IF anyy # year
			REPL year WITH anyy,lastan WITH 0
			FLUSH
		ENDI
	ELSE
		WAIT WIND 'ไม่สามารถออกเลขที่ผู้ป่วยในได้ ยกเลิกการ Admit ' TIME 2
		UNLOCK ALL
		RETU
	ENDI
	newan=IIF(lastan<99999,lastan+1,1)
	m.an = year+STRZERO(newan,5)
	REPL lastan WITH newan
	FLUSH
ENDI

UNLOCK ALL

SET REPROCESS TO AUTOMATIC

SELE medrec
SET ORDER TO TAG hn
SEEK m.hn
DO WHIL hn = m.hn .AND. status
	SKIP
ENDD
IF hn = m.hn
	REPL who WITH 'W'+m.ward_adm
	FLUSH
ENDI
sele  iptrana
set order to tag hn
go top
if ! empty(hn)
	SET ORDER TO TAG datedsc
	SET FILT TO ! EMPTY(datedsc) AND dx_stat
	GO TOP
	IF EOF() OR (datedsc + 7  > DATE())
		APPE BLANK
	ENDI
	SET FILT TO
	SET ORDER TO TAG hn
ELSE
	IF EOF()
		APPE BLANK
	ENDI
endif	
gather memvar
FLUSH

UNLOCK ALL
WAIT WIND NOWA 'ได้เลขที่ AN ' + RIGHT(m.an,5)+'-'+LEFT(m.an,2)	

*************
PROC INI_VAR
*************
dr='99999'
mssn='99-       - '
mhn=0
man=0
anyy=yy
mfacn='99'+space(14)
facn1='99'+space(14)
dep='  '
ward_adm='   '
store space(25) to mdep,mward
@ 0,0 clear to 1,78
DO CLEARSCR

***********
PROC extra
***********
SET REPROCESS TO 2 SECONDS
SELE iptrana
SET FILTER TO (DATE()-DATEDSC >7) AND (VAL(DTOC(DATE())) <> 0)
GO TOP
IF FLOCK()
	DO WHILE .NOT. EOF()
		if dx_stat = .T.
			scat memvar
			m.admyear = LEFT(m.an,2)
			IF m.admyear # yy
				SELE admyear
				dbfuse = ipddir+'data\adm'+m.admyear
				USE (ipddir+'data\adm'+m.admyear) ALIA admyear ORDER 1
				INSERT INTO admyear FROM MEMV
				dbfuse = ipddir+'data\adm'+yy
				USE (ipddir+'data\adm'+yy) ALIA admyear ORDER 1
				SELE iptrana
			ELSE
				insert into ADMyear from memvar
			ENDI
			dbfuse = ''
			FLUSH
			scat memv blank
			gather memvar
			FLUSH
		endif
		skip  
	ENDDO
ELSE
	WAIT 'ไม่สามารถล็อค File IPTRANA ได้  ยกเลิกการลบข้อมูล ADMIT เก่า';
	WINDOW TIME 2
	RETU TO MASTER
ENDIF
SET REPROCESS TO AUTOMATIC
UNLOCK ALL
set filt to
select iptrana
	set order to tag hn
	scatter memvar blank

@ 0,0 clear to 1,78
DO CLEARSCR

*************
PROC INSERTAN
*************
SELE ancount
      	mkey=0
	 DO WHIL ! FLOCK() .AND. mkey<>27
       		mkey=inkey()
	 ENDD
        	IF ! FLOCK()
             	WAIT 'ไม่สามารถเรียกหมายเลขผู้ป่วยในได้ เลิกทำงาน';
               	WINDOW TIME 10
               	RETU TO MASTER
	        ENDI
	scat memvar
	IF anyy > m.year
		m.lastan=0
	ENDIF	
		    newan=IIF(m.lastan<99999,m.lastan+1,1)
		    man=Padzero(STR(newan),5)
			m.an=anyy+padl(alltrim(m.man),5,'0')	
    REPL lastan WITH newan
    FLUSH
	REPL year WITH anyy    	
	FLUSH
