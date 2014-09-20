********************************************************************************
*  โมดูลสำหรับกรอกประวัติผู้ป่วยใหม่                                           *
*  และตรวจสอบชื่อและประวัติผู้ป่วยเก่า                                         *
********************************************************************************
PARA _health
healthin = IIF(PARAMETERS() > 0, _health, .F.)
PRIV goon
***********************************************************
* กำหนดค่าต่าง ๆ เพื่อตรวจสอบความถูกต้องของการคีย์ข้อมูล  *
***********************************************************
ismale = ',ดช.,นาย,พระภิกษุ,พภ.,บช.นาง,เด็กชาย,บุตรชายนาง,สณ.,สามเณร,นพ.,นายแพทย์,น.พ.,'
isfemale = ',น.ส.,นาง,นางสาว,นส.,บญ.นาง,บุตรหญิงนาง,ดญ.,เด็กหญิง,พญ.,แพทย์หญิง,พ.ญ.,แม่ชี,'
ismarried = ',นาง,'
ischildren = ',ดช.,เด็กชาย,ดญ.,เด็กหญิง,บุตรชายนาง,บช.นาง,บญ.นาง,บุตรหญิงนาง,'
isadult = ',นาง,นางสาว,นส.,น.ส.,นาย,พภ.,นพ.,นายแพทย์,พ.ญ.,แพทย์หญิง,น.พ.,พ.ญ.,'
issingle = ',น.ส.,นส.,นางสาว,'
isbuddha = ',พระภิกษุ,พภ.,สณ.,สามเณร,'
mvs_id = ''
DO OpenLanMaster
dbfuse = patientdir + 'insure'
= OPENDBF(dbfuse,'','hn')
dbfuse = LEFT(patientdir,AT('\',patientdir)) + 'credit\data\' + 'insurlog'
= OPENDBF(dbfuse,'','hn')
dbfuse = ''
ON KEY LABEL SHIFT+F1 DO showhelp
PRIVATE mchoice
EXTERNAL ARRAY hlpname,hlpcode,AmCode,AmName,TamCode,TamName,Tamnum
STOR 0 to m.pos,m.tam,m.tam1
FQ=1
KQ=1
@ 22,0 CLEA
DO TITLE WITH IIF(healthin,'ลงทะเบียนผู้ทำบัตร','ลงทะเบียนผู้ป่วย')+IIF(er,'ฉุกเฉิน','')
mstype='  '
ON KEY LABEL Alt+R DO TOprs_menu
mhn = ' '
DO WHIL .T.
	ON KEY LABEL Shift+F2 DO edit_pat
	Shift_f2=.T.
	FLUSH
	UNLOCK ALL
	DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
	DO NewHnScr
	SELE patient1
	SCATTER TO patient1 BLANK
	SELE patient2
	SCATTER TO patient2 BLANK
	SELE contact 
	SCATTER TO contact1 BLANK
	contact1[6] = SUBS(hosp_code,5,2)
	SCATTER TO contact2 BLANK
	SELE insure
	SCATTER MEMV BLANK
	STORE '' TO namestart, nameend, namemain, namesub, m.verifyby
	STORE SPACE(8) TO m.startdate, m.enddate
	STORE m.username TO m.recordby, m.verifyby
	new_one = .F.
	contact2(2)='บ.ด.ก.'+SPAC(19)
	mbirthday=SPACE(10)
	STOR '99' TO patient2[5],patient2[6]
	SameAddr=.T.
	FMIN=1
	FMAX=24
	fq=1
	first_loop=.T.
	mess1='[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
	DO WHIL .T.
		UNLOCK ALL
		DO inputpt WITH .T.
		IF EMPTY(patient1[3])
			RETU
		ENDI
		@ 22,0 CLEA
		= ENGMODE()
		@ 23,1 PROMPT 'A = บันทึกข้อมูล'
		@ 23,20 PROMPT 'C = ยกเลิกข้อมูล'
		@ 23,40 PROMPT 'E = แก้ไขข้อมูล'
		IF ! healthin
			@ 23,58 PROMPT 'P = บันทึกและพิมพ์บัตร'
		ENDI
		mchoice=IIF(Er,4,1)
		MENU TO mchoice
		@ 22,0 CLEA
		patient1(7)=DATE()
		mtime=time()
		patient1(11)=LEFT(mtime,2)+SUBS(mtime,4,2)
		m.notedate = DATE()
		DO CASE
			CASE (mchoice =1 .OR. mchoice = 4) .AND. ! new_one
		
				**---------- Make file for visit number  19/07/39
				IF ! healthin
					DO checkvs
    	            DO inputvs  && บันทึกเลขที่ VS
				**--- 19/07/39
	
					SELE medrec
					IF EOF()
						GO TOP
						IF ! EMPTY(hn) .OR. BOF() .OR. ! RLOCK()
        	       			APPE BLANK
	            	   		=RLOCK()
		            	ENDI
	    	        ENDI
		 			medrec(1)=patient1(1)
			 		medrec(2)=DATE()
			 		medrec(3)=LEFT(mtime,2)+SUBS(mtime,4,2)
			 		medrec(4)=DATE()-patient1(4)
		 			STOR 'O'+patient1(9) TO medrec(5)
			 		medrec(6)=.F.
					GATHER FROM medrec
	         		IF EOF('newcase')
    	     			m.visited = .F.
        	 			m.hn = patient1[1]
         				INSERT INTO newcase FROM MEMV
         			ENDI
         		ENDI
				SELE patient1
         		GATHER FROM patient1
				IF ! EMPTY(m.cid)
					m.hn = patient1[1] + RIGHT(TRIM(CE2BE(DATE())),2)
					m.name = patient1[3]
					m.inscl = patient1[8]
					SELE insure
					IF ! EOF()
						numfield = FCOUNT()
						FOR f = 1 TO numfield
							mfield = FIELD(f)
*							m.var = &mfield
*							m.var1 = m.&mfield
							IF ! mfield $ 'USER,NOTEDATE,RECORDBY,VERIFYBY' ;
							.AND. m.&mfield # &mfield
								INSERT INTO insurlog FROM MEMV
								f = numfield + 1
							ENDI
						NEXT
						GATHER MEMV
					ELSE
						INSERT INTO insure FROM MEMV
						INSERT INTO insurlog FROM MEMV
					ENDI
				ENDI
				if ! healthin
					do pnque with patient1(1),patient1(7),patient1(11),.F.
				endif
				IF mchoice=4 .AND. ! healthin
					SET ESCA ON
					ON ESCAPE STORE .T. TO exist
					exist=.F.
					DO WHIL ! PRINTSTATUS() .AND. ! exist
   						?? CHR(7)
   						WAIT 'เครื่องพิมพ์ยังไม่พร้อม  โปรดตรวจสอบให้เรียบร้อย' WINDOW
					ENDD
					IF ! exist
						SELE PATIENT1
						SET ORDER TO 1
						SEEK patient1(1)
						IF FILE('printopd.fxp')
							DO ('printopd')
						ELSE
							DO propdp
						ENDI
					ENDI
					SET ESCA OFF
				ENDI
         		EXIT
         	CASE mchoice =1 .OR. mchoice=4
            	IF ! patient1(2)$'12' .OR. ! patient2(3)$'123456' .OR. patient2(6)='  ' .OR. ;
				patient2(5)='  ' .OR. contact1(6)='  '
					?? chr(7)
					DO CASE
						CASE ! patient1(2)$'12'
							fq=2
						CASE contact1(6)='  '   
							fq=4
						CASE ! patient2(3)$'123456'
							fq=11
						CASE patient2(6)='  '
							fq=13
						CASE patient2(5)='  '
							fq=14
					ENDC
				ELSE
					IF Er
						SELE 0
						dbfuse = patientdir+'er_hn'
						use (patientdir+'er_hn') EXCL
						dbfuse = ''
    	     			IF start1=0 .OR. start1>end1
							IF start2=0
								?? CHR(7)
    	        				WAIT '  แฟ้มที่เบิกมาหมดแล้ว ต้องเบิกใหม่ ไม่สามารถทำรายการนี้ได้  ';
        	    				WINDOW TIMEOUT 10
            					USE
            					UNLOCK ALL
            					RETU TO MASTER
	            			ELSE
    	        				REPL start1 WITH start2,end1 WITH end2,;
        	    				start2 WITH 0
            				ENDI
						ENDI
            			m.start1=start1
	                  	mhn=STRZERO(m.start1,7)
    	             	SELE patient1
        	         	SET ORDER TO TAG hn
            	      	DO WHIL SEEK(mhn)
							SELE er_hn
							m.start1=m.start1+1
		         			IF m.start1>end1
								IF start2=0
	         						?? CHR(7)
	    	        				WAIT '  แฟ้มที่เบิกมาหมดแล้ว ต้องเบิกใหม่ ไม่สามารถทำรายการนี้ได้  ';
			        	   			WINDOW TIMEOUT 10
        			    			USE
        			    			UNLOCK ALL
            						RETU TO MASTER
            					ELSE
		            				REPL start1 WITH start2,end1 WITH end2,;
        		    				start2 WITH 0
            					ENDI
	            			ENDI
		                	mhn=STRZERO(m.start1,7)
	    	            	SELE patient1
            	      	ENDD
                	  	SELE er_hn
                  		REPL start1 WITH m.start1+1
						USE
					ELSE
						SELE hncount
						mkey=0
						DO WHIL ! FLOCK() .AND. mkey<>27
							WAIT WIND NOWA 'กำลังขอหมายเลข HN อยู่'
							mkey=inkey()
						ENDD
						IF ! FLOCK()
							WAIT 'ไม่สามารถเรียกหมายเลขผู้ป่วยได้ เลิกทำงาน';
							WINDOW TIME 5
							UNLOCK ALL
							RETU TO MASTER
						ENDI
						newhn=IIF(lasthn<9999999,lasthn+1,1)
						mhn=Padzero(STR(newhn),7)
						SELE patient1
						SET ORDER TO TAG hn
						DO WHILE SEEK(mhn)
							newhn=newhn+1
	                  		mhn=STRZERO(newhn,7)
						ENDD
						SELE hncount
						REPL lasthn WITH newhn
					ENDI
					UNLOCK ALL
*					WAIT WIND NOWA 'ได้เลขที่ผู้ป่วยนอก '+mhn
					SELE patient1
					SET ORDER TO 1
					STORE mhn TO patient1(1),patient2(1),contact1(1),contact2(1)
					patient1(7)=DATE()
					patient1(4)=Be2Ce(mbirthday)
					GO TOP
					DO WHIL ! EMPTY(hn) .OR. BOF() .OR. ! RLOCK()
						APPE BLANK
					ENDD
					GATHER FROM patient1
					SELE patient2
					GO TOP
					DO WHIL ! EMPTY(hn) .OR. BOF() .OR. ! RLOCK()
    	           		APPE BLANK
					ENDD
					GATHER FROM patient2
					SELE contact
					IF contact2(2)='บ.ด.ก.'
						contact1(7)='3'
						GO TOP
						DO WHIL ! EMPTY(hn) .OR. BOF() .OR. ! RLOCK()
                	  		APPE BLANK
						ENDD
						GATHER FROM contact1
					ELSE 
						contact1(7)='1'
						contact2(7)='2'
						GO TOP
						DO WHIL ! EMPTY(hn) .OR. BOF() .OR. ! RLOCK()
                  			APPE BLAN
						ENDD
						GATHER FROM contact1
						GO TOP
						DO WHIL ! EMPTY(hn) .OR. BOF() .OR. ! RLOCK()
                	  		APPE BLAN
						ENDD
						GATHER FROM contact2
					ENDI
					IF ! EMPTY(m.cid)
						m.hn = patient1[1] + RIGHT(TRIM(CE2BE(DATE())),2)
						m.name = patient1[3]
						m.inscl = patient1[8]
						SELE insure
						GO TOP
						IF EMPTY(hn) .AND. ! BOF()
							GATHER MEMV
						ELSE
							INSERT INTO insure FROM MEMV
						ENDI
							INSERT INTO insurlog FROM MEMV
					ENDI
					UNLOCK ALL
					IF mchoice=4 .AND. ! healthin
						SET ESCA ON
						ON ESCAPE STORE .T. TO exist
						exist=.F.
						DO WHIL ! PRINTSTATUS() .AND. ! exist
   							?? CHR(7)
   							WAIT 'เครื่องพิมพ์ยังไม่พร้อม  โปรดตรวจสอบให้เรียบร้อย' WINDOW
						ENDD
						IF ! exist
							SELE PATIENT1
							SET ORDER TO 1
							SEEK patient1(1)
							IF FILE('printopd.fxp')
								DO ('printopd')
							ELSE
								DO propdp
							ENDI
						ELSE
                  			SELE printque
                  			GO BOTT
	                  		IF ISDIGIT(hn) .OR. BOF() .OR. ! RLOCK()
    	                 		APPE BLANK
        	          		ENDI
            	      		REPL NEXT 1 hn WITH mhn
            	      		UNLOCK
						ENDI
						SET ESCA OFF
					ELSE
						SELE printque
						GO BOTT
						DO WHIL ISDIGIT(hn) .OR. BOF() .OR. ! RLOCK()
							APPE BLANK
						ENDD
						REPL NEXT 1 hn WITH mhn
						UNLOCK
					ENDI
					IF ! healthin
						**---------- Make file for visit number  19/07/39
						DO checkvs
    		            DO inputvs  && บันทึกเลขที่ VS
						**--- 19/07/39
	
						**---------- Save foreign type			30/07/39
					ENDI
					dbfuse = patientdir + 'foreign'
					SELECT foreign
					SET ORDER TO TAG hn
					IF ! SEEK(mhn)					&& ถ้าพบ hn เขียนทับ	
						IF EOF()
							GO TOP
							IF ! EMPTY(hn) .OR. BOF() .OR. ! RLOCK()
	        	       			APPE BLANK
							ENDI
						ENDI
					ENDIF
					hn		= mhn
					nation	= patient2(5)
					GATHER  MEMVAR
					USE										&& Close file
					**----
					IF ! healthin
						SELE medrec
						IF EOF()
							GO TOP
							IF ! EMPTY(hn) .OR. BOF() .OR. ! RLOCK()
	            	   			APPE BLANK
							ENDI
						ENDI
						medrec(1)=patient1(1)
						medrec(2)=DATE()
						medrec(3)=LEFT(mtime,2)+SUBS(mtime,4,2)
						medrec(4)=DATE()-patient1(4)
				 		STOR 'O'+patient1(9) TO medrec(5)
						medrec(6)=.F.
						GATHER FROM medrec
	        	 		IF EOF('newcase')
    	     				m.visited = .F.
        	 				m.hn = patient1[1]
         					INSERT INTO newcase FROM MEMV
	         			ENDI
						do pnque with patient1(1),patient1(7),patient1(11),.T.
					ENDI
					EXIT
				ENDI
				UNLOCK ALL
			CASE mchoice=3
            	fq=fmin
	            DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล'
			OTHER          
            	EXIT
		ENDC
	ENDD
	UNLOCK ALL
	IF (mchoice = 1 .OR. mchoice = 4) .AND. audit
		SELE hnchange
		IF EOF()
			GO BOTT
			DO WHIL ISDIGIT(hn) .OR. EOF() .OR. ! RLOCK()
				APPE BLANK
			ENDD
		ENDI
		REPL hn WITH patient1[1]
		UNLOCK ALL
	ENDI
	IF ! healthin .AND. RIGHT(patient1(9),1) = ' ' .AND. (mchoice = 1 .OR. mchoice = 4) ;
	.AND. UPPE(notstatadmit) # 'YES'
		m.hn = patient1.hn
		m.result = LEFT(patient1(9),2)
		DO askadmit WITH .T.
	ENDI
ENDD
UNLOCK ALL
ON KEY LABEL Shift+F2
ON KEY LABEL Alt+H
ON KEY LABEL Alt+A
ON KEY LABEL Shift+F1
Shift_f2=.F.

FUNC CH_ER
IF mfinish<mstart
	_CUROBJ=1
ENDI

***********************
Procedure PNQUe
***********************
parameter phn,pdate,ptime,_newpat
pnew=.T.
select patient1
SET ORDER TO TAG hn
seek(phn)
If clinic $ NotPrintRx		&& STD Clinic
	return
endif
pclass=patient1.class
pdtime=ptime
pdr=space(6)
select newcase
if seek(phn)
	pnew=.F.
else
	pnew=.T.
endif
SELE pncount
do while ! FLOCK() 
	WAIT WIND NOWA 'โปรดคอย กำลังเรียกเลขที่ใบสั่งยา'
ENDD
	ppn=iif(empty(pncount.lastpn),1,pncount.lastpn+1)
	mpn=padl(alltrim(str(ppn)),7,'0')
	replace lastpn with ppn
	unlock
	IF healthin
		WAIT WIND NOWA 'ลำดับที่ลงทะเบียน ' + mhn
	ELSE
		WAIT WIND NOWA 'ได้เลขที่ผู้ป่วยนอก '+mhn + CHR(13) + ;
		'ได้เลขที่ใบสั่งยา '+mpn + CHR(13) + ;
		'ได้ลำดับคิวที่ ' + mvs_id
	ENDI
mdd=padl(alltrim(str(day(date()),2)),2,'0')
mmm=padl(alltrim(str(month(date()),2)),2,'0')
myy=RIGHT(str(year(date())+543),2)
target1=pharmdir+'presc'+myy+'.dbf'
if !file(target1)
	select prtoday
	copy stru to (target1) with cdx
endif
insert into (target1) (pn,hn,date,time,class,dtime,dr,printed) value (mpn,phn,pdate,ptime,pclass,pdtime,pdr,.F.)
select prtoday
SET ORDER TO TAG date ASCE
GO TOP
IF date < DATE()-1
	REPL pn WITH mpn,hn WITH phn,date WITH pdate,time WITH ptime,;
	class WITH pclass,dtime WITH pdtime,dr WITH pdr,printed WITH .F.
ELSE
	insert into prtoday (pn,hn,date,time,class,dtime,dr,printed) ;
	value (mpn,phn,pdate,ptime,pclass,pdtime,pdr,.F.)
ENDI
select pque 
set order to tag pn
GO BOTT
IF ISDIGIT(pn) .OR. BOF()
   APPE BLANK
ENDI
REPL NEXT 1 pn WITH mpn, new with pnew

flush

return

PROC TOAUDIT
PRIV prepage
ON KEY LABEL ALT+B
SAVE SCREE TO prepage
CREA VIEW (tempdir+'nowview')
DO CLEARSCREEN
DO Audit
SET VIEW TO nowview
REST SCREE FROM prepage
ON KEY LABEL ALT+B DO ToAudit
DELE FILE (tempdir+'nowview.vue')
CLEAR TYPEAHEAD

PROC TOprs_menu
IF FILE(tempdir+'nowview.vue')
	=ALARM1()
	HIDE WINDOW Scr 
	WAIT WIND NOWA 'โปรดคอยสักครู่'
	CREA VIEW (tempdir+'audit')
	SET VIEW TO (tempdir+'nowview.vue')
	KEYB '!'
ENDI
ACTI SCREE
DO prs_menu
IF FILE(tempdir+'audit.vue')
	SET VIEW TO (tempdir+'audit')
	DELE FILE (tempdir+'audit.vue')
	ACTI WINDOW Scr 
ENDI
ON KEY LABEL ALT+R DO TOprs_menu

PROC SHOWHELP
DEFINE WIND showhelp FROM 3,20 TO 18,78 SHAD COLO r/bg
ACTI WIND showhelp
? '  กดปุ่ม [F1] เมื่อไม่สามารถใส่ข้อมูลได้'
? '  กดปุ่ม [Shift]+[F2] เพื่อแก้ไขข้อมูล'
? '  กดปุ่ม [Alt]+[N] เพื่อพิมพ์บัตรผู้ป่วยใหม่ในคิว'
? '  กดปุ่ม [Alt]+[ญ] เพื่อพิมพ์บัตรผู้ป่วยรายปัจจุบัน'
? '  กดปุ่ม [Alt]+[H] เพื่อตั้งค่าเลขที่ผู้ป่วยนอกใหม่ '
? '       ใช้ได้เฉพาะผู้มีสิทธิ์เป็น Supevisor เท่านั้น'
? '  กดปุ่ม [Alt]+[A] เพื่อตั้งค่าเลขที่ผู้ป่วยในใหม่ '
? '       ใช้ได้เฉพาะผู้มีสิทธิ์เป็น Supevisor เท่านั้น'
? '  กดปุ่ม [Alt]+[R] เพื่อเข้ารายการพิมพ์ใบสั่งยา'
? '       ใช้ได้เมื่อกำหนดให้ระบบพิมพ์ใบสั่งยาด้วย'
? '  กดปุ่ม [Alt]+[B] เพื่อสำรองข้อมูล'
WAIT '' TIME 30
RELE WIND showhelp

PROC Changehn
PRIV nowalia,lasthn
IF 'SUP' $ userright
	nowalia = ALIAS()
	IF ! er
		SELE hncount
		m.lasthn = lasthn +1
	ELSE
		SELE 0
		dbfuse = patientdir+'er_hn'
		use (patientdir+'er_hn') EXCL
		dbfuse = ''
		IF start1=0 .OR. start1>end1
			IF start2=0
				=ALARM1()
				WAIT '  แฟ้มที่เบิกมาหมดแล้ว ต้องเบิกใหม่ ไม่สามารถทำรายการนี้ได้  ';
				WINDOW TIMEOUT 10
				USE
				SELE (nowalia)
				RETU 
			ELSE
				REPL start1 WITH start2,end1 WITH end2,start2 WITH 0
			ENDI
		ENDI
		m.lasthn = start1
	ENDI
	dbfuse = ''
	DEFI WIND change FROM 5,10 TO 9,60 SHAD COLO n/bg
	ACTI WIND change
	@ 1,2 SAY 'ต้องการเริ่มต้นที่หมายเลข HN ' GET m.lasthn PICT '9999999'
	READ
	IF ! ER
		m.lasthn =IIF(m.lasthn>0, m.lasthn-1,m.lasthn)
		GATH MEMV
	ELSE
		IF ! BETWEEN(m.lasthn,start1,end1)
			IF ! BETWEEN(m.lasthn,start2,end2)
				= ALARM1()
				WAIT WIND NOWA '  หมายเลขผู้ป่วยนอก ' + STRZERO(m.lasthn,7) + ' ไม่ได้เบิกมา ให้ใส่ใหม่  '
				USE
				SELE (nowalia)
				RELE WIND change
				RETU
			ELSE
				REPL start1 WITH start2,end1 WITH end2,start2 WITH 0,end2 WITH 0
			ENDI
		ENDI
		m.start1 = IIF(m.lasthn = 0,1,m.lasthn)
		GATH MEMV
		USE
	ENDI
	FLUSH
	SELE (nowalia)
	RELE WIND change
ELSE
	=ALARM1()
	WAIT WIND NOWA '  คุณไม่มีสิทธิ์ที่จะกำหนดเลขที่ผู้ป่วยนอก  ' TIME 10
ENDI

PROC ChangeAN
PRIV nowalia,lasthn
IF 'SUP' $ userright
	DEFI WIND change FROM 5,10 TO 9,60 SHAD COLO n/bg
	ACTI WIND change
	nowalia = ALIAS()
	SELE ancount
	SCAT MEMV
	m.year = IIF( EMPTY(m.year), RIGHT(CE2BE(DATE()),2), m.year)
	m.lastan = m.lastan+1
	@ 1,2 SAY 'ต้องการเริ่มต้นที่หมายเลข AN '
	_col = COL() + 1
	@ 1,_col GET m.lastan PICT '99999'
	@ 1,_col+5 SAY '-'
	@ 1,_col+6 GET m.year PICT '99'
	READ
	m.lastan = IIF(m.lastan>0, m.lastan-1, m.lastan)
	GATH MEMV
	FLUSH
	dbfuse = ''
	SELE (nowalia)
	RELE WIND change
ELSE
	=ALARM1()
	WAIT WIND NOWA '  คุณไม่มีสิทธิ์ที่จะกำหนดเลขที่ผู้ป่วยใน  ' TIME 10
ENDI

************
Proc Inputvs
************
DIMENSION dvs(11)

SELE Dvisit
SET ORDER TO TAG date
SEEK DATE()
IF !found()
    =alarm1()
    wait wind '<< ไม่พบการจองวันทำงานไว้ ... >>' nowait
    RETU TO MASTER
ELSE
    mkey=0
    DO WHIL ! FLOCK() .AND. mkey<>27
        WAIT WIND NOWAIT 'กำลังขอหมายเลข คิว อยู่'
        mkey=inkey()
    ENDD
    IF ! FLOCK()
        WAIT 'ไม่สามารถเรียกหมายเลขลำดับคิวได้ เลิกทำงาน';
        WINDOW TIME 5
        UNLOCK ALL
        RETU TO MASTER
    ENDI
    newid=IIF(nvs_id<9999,nvs_id+1,1)
    mvs_id=Padzero(STR(newid),4)
ENDIF

SELECT Dvs
SET ORDER TO TAG vs_iddate

DO WHILE SEEK(mvs_id+dtoc(DATE()))
    newid=newid+1
    mvs_id=STRZERO(newid,4)
ENDD

**----------------------------- Replace with new que number
SELECT dvisit
REPL nvs_id WITH newid

**----------------------------- Crate patient que
SELECT dvs
SET ORDER TO tag vs_id
dvs(1)=patient1(1)
dvs(2)=m.mvs_id
dvs(3)=DATE()
dvs(4)=SUBST(TIME(),1,2)+SUBST(TIME(),4,2)
dvs(8)= '2'
dvs(9)=patient1(8)
dvs(11)= 'R'

*if z_his=.t.
    dvs(6)=patient1(9)			&& clinic
*endif

dvs(10)=UPPE(GETENV('logname'))					&& user login name
GO TOP

DO WHIL ! EMPTY(hn) .OR. BOF() .OR. ! RLOCK()
    APPE BLANK
ENDD
GATHER FROM dvs

*WAIT WINDOW ' ได้ลำดับการมาตรวจที่ '+mvs_id  NOWAIT


