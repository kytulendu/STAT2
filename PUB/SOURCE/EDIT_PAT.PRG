********************************************************************************
*  โมดูลสำหรับแก้ไขข้อมูลทั่วไปของผู้ป่วย                                      *
********************************************************************************
SELE patient1
SET RELA TO hn INTO patient2
SET RELA TO hn INTO contact ADDI
IF ! healthin
	SET RELA TO clinic INTO clinic ADDI
ENDI
SET RELA TO class INTO social ADDI
ON KEY LABEL Shift+F2 DO AlertWin WITH 'คุณอยู่ในรายการแก้ไขข้อมูลอยู่แล้ว'
Shift_f2=.F.
PRIVATE mchoice,fq,kq,fmin,fmax,mhn,mbirthday,utdtam1,PrePage,;
patient1,patient2,contact1,contact2,m.currarea, m.cid, m.hn, ;
m.inscl, m.subtype, m.datein, m.dateexp, m.name, m.hospmain, m.hospsub, ;
m.recordby, m.verifyby, namestart, nameend, namemain, namesub, ;
m.startdate, m.enddate
m.currarea = SELECT()
m.curr_rec=IIF(EOF() .OR. BOF(),1,recno())
SELE insure
SET ORDER TO TAG hncl
SCAT MEMV BLANK
SELE patient1
SCAT MEMV BLANK
SELE patient2
SCAT MEMV BLANK
SELE contact
SCAT MEMV BLANK
m.owner='3'
mhn=SPAC(7)
mstype='  '
SAVE SCREEN TO Prepage
DO newhnscr
= ENGMODE()
@ 4,70 GET mhn PICT '9999999'
DO title WITH 'แก้ไขผู้ป่วย'
DO bottmess WITH 'ใส่เลขที่ผู้ป่วยนอกที่จะแก้ไข'
READ NOLOCK
IF LASTKEY()#27
	mhn=PADZERO(mhn,7)
	new_one=.F.
	SELE patient1
	SET ORDER TO 1
	IF ! SEEK(mhn)
		?? CHR(7)
		DEFINE WIND wind1 FROM 4,15 TO 11,65 SHAD COLO g+/b
		ACTI WIND wind1
		@ 1,3 SAY 'ไม่มีผู้ป่วยเลขที่ '+mhn COLO r+/b
		@ 3,3 SAY 'ต้องการเพิ่มผู้ป่วยเลขที่นี้หรือไม่  ' GET appe ;
		COLO r+/b DEFA 'N' PICT '!'
		READ NOLOCK
		DEAC WIND wind1
		IF appe$'Yัํ'
			m.hn=mhn
			INSERT INTO patient1 FROM MEMV
			FLUSH
			SELE patient2
			IF ! SEEK(mhn)
				INSERT INTO patient2 FROM MEMV
				FLUSH
			ENDI
			SELE contact
			IF ! SEEK(mhn)
				INSERT INTO contact FROM MEMV
				FLUSH
			ENDI
			SELE insure
			SCATTER MEMV BLANK
			STORE '' TO namestart, nameend, namemain, namesub, m.verifyby
			STORE SPACE(8) TO m.startdate, m.enddate
			STORE m.username TO m.recordby, m.verifyby
			SELE patient1
			DO On_Edit
		ENDI
	ELSE
		m.hn=mhn
		IF EOF("PATIENT2")
			INSERT INTO patient2 FROM MEMV
			FLUSH
		ENDI
		IF EOF("CONTACT")
			INSERT INTO contact FROM MEMV
			FLUSH
		ENDI
		DO On_Edit
	ENDI
ENDI
@ 4,70 SAY SPAC(7)
REST SCREEN FROM prepage
ON KEY LABEL Shift+F2 DO edit_pat
Shift_f2=.T.
SELECT (m.currarea)
IF m.curr_rec>1 .AND. m.curr_rec<=RECCOUNT()
	GO m.curr_rec
ENDI

PROC ON_EDIT
@ 4,70 SAY mhn COLO r+/b
SCATTER TO patient1
mbirthday=IIF(EMPTY(birthday),'  /  /    ',STR(DAY(birthday),2)+'/'+STR(MONTH(birthday),2)+'/'+STR(YEAR(birthday)+543,4))
* harin patient1[7] = DATE()
SELE patient2
SCATTER TO patient2
SELE contact
SCATTER TO contact1
owner1 = RECNO()
IF owner='1'
	SKIP
	IF hn # m.hn
		SKIP -1
	ENDI
ENDI
SCATTER TO contact2
FQ=1
KQ=1
FMIN= 1
FMAX= 24
@ 22,0 CLEA
DO TITLE WITH 'แก้ไขข้อมูลทั่วๆไปของผู้ป่วย'
DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
DO showfull
DO WHIL .T.
	UNLOCK ALL
   DO inputpt WITH .F.
   @ 22,0 CLEA
   @ 23,1 PROMPT 'A = บันทึกข้อมูล'
   @ 23,20 PROMPT 'C = ยกเลิกข้อมูล'
   @ 23,40 PROMPT 'E = แก้ไขข้อมูล'
   @ 23,58 PROMPT 'P = บันทึกและพิมพ์บัตร'
   MENU TO mchoice

   @ 22,0 CLEA
      DO CASE
         CASE mchoice =1 .OR. mchoice=4
   			IF patient1(2)=' ' .OR. patient2(3)=' ' .OR. patient2(6)='  ' .OR. ;
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
			     SELE patient1
			     patient1(4)=Be2Ce(mbirthday)
			     GATHER FROM patient1
			     FLUSH
			     SELE patient2
			     GATHER FROM patient2
			     FLUSH
			     SELE contact
			     _old2=owner#'3' .AND. RECNO() # owner1
			     IF _old2
			     	_oldrec=recno()
			        SKIP -1
			     ENDI
			     IF contact2(2)='บ.ด.ก.' .OR. (contact1(2)=contact2(2) .AND.;
			     contact1(3)=contact2(3) .AND. contact1(4)=contact2(4) .AND.;
			     contact1(5)=contact2(5) .AND. contact1(6)=contact2(6))
			     	contact1(7)='3'
			     ELSE
			     	contact1(7)='1'
			     	contact2(7)='2'
			     ENDI
			         GATHER FROM contact1
			         FLUSH
			     IF contact1(7)='1'
			     	IF _old2
			        	GO _oldrec
			        	GATHER FROM contact2
			        	FLUSH
			        ELSE
			        	GO TOP
			        	IF ! EMPTY(hn)
			        		APPE BLANK
			        	ENDI
		        		GATHER FROM contact2
		        		FLUSH
	         		ENDI
               	ELSE
              		IF _old2
   			   			GO _oldrec
   						REPL hn WITH SPAC(7)
   						FLUSH
               		ENDI
               	ENDI
				m.hn = patient1[1] + RIGHT(TRIM(CE2BE(DATE())),2)
				m.name = patient1[3]
				m.inscl = patient1[8]
				SELE insure
				SEEK(LEFT(m.hn,7)+m.inscl)
				IF ! EOF()
*					IF EMPTY(m.cid)
						GATHER MEMV
*					ENDI
				ELSE
					IF ! EMPTY(m.cid)
						INSERT INTO insure FROM MEMV
					ENDI
				ENDI
               IF mchoice=4
                   SELE patient1
                   SET ORDER TO 1
                   SEEK mhn
                   IF FILE('printopd.fxp')
	                   DO ('printopd')
	               ELSE
	               	DO propdp
	               ENDI
   			    ENDI
                EXIT
             ENDI
         CASE mchoice=3
   			fq=1
            DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล'
	      OTHER
			EXIT
	ENDC
ENDD
IF (mchoice = 1 .OR. mchoice = 4) .AND. audit
	SELE hnchange
	IF EOF()
		GO TOP
		DO WHIL ISDIGIT(hn) .OR. BOF()
			APPE BLANK
		ENDD
	ENDI
	REPL hn WITH patient1[1]
	FLUSH
ENDI
UNLOCK ALL
CLEAR TYPEAHEAD
IF WEXIST('person')
	DEAC WIND person
ENDI
