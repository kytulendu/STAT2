PRIV GOON
*DEAC WIND ALL
CLOSE DATA
DO TITLE WITH 'กำลังสำรองข้อมูล'
DEFI WIND errindex FROM 10,10 TO 14,70 SHAD
*DO CLEARSCREEN
WAIT WIND NOWA 'โปรดคอย ! กำลังตรวจสอบระบบอยู่'
PreBackup = '99'
IF ! FILE(patientdir+'patient1.dbf') .OR. ! FILE(patientdir+'patient2.dbf') .OR. ! ;
FILE(patientdir+'contact.dbf')
	?? CHR(7)
	WAIT WIND 'No data or wrong directory' TIME 20
	RETU
ENDI
IF ! FILE(patientdir+'hnchange.dbf')
	dbfuse = patientdir+'hnchange'
	CREATE TABLE (patientdir+'hnchange') ;
	(hn C(7))
	INDEX ON hn TAG hn
ENDI
CLOSE DATA
* duplex = SYS(5) # 'C:' .AND. FILE('c:\command.com')
dbfuse = patientdir+'patient1'
USE (patientdir+'patient1') order 1 ALIA source1
dbfuse = patientdir+'patient2'
USE (patientdir+'patient2') ORDER 1 ALIA source2 IN 0
dbfuse = patientdir+'contact'
USE (patientdir+'contact') ORDER 1 ALIA source3 IN 0
SELE 0
dbfuse = ''
* ตรวจสอบว่ามีแฟ้มที่จะทำ mirror แล้วหรือยัง ถ้ายังให้สร้างขึ้นมา
IF ! FILE(patientdir+'pat1.dbf')
	WAIT WIND NOWA 'โปรดคอย ! กำลังสำเนาแฟ้ม PATIENT1 ไปเป็นแฟ้ม PAT1'
	SELE source1
	COPY TO (patientdir+'pat1') CDX stru
	SELE source2
	WAIT WIND NOWA 'โปรดคอย ! กำลังสำเนาแฟ้ม PATIENT2 ไปเป็นแฟ้ม PAT2'
	COPY TO (patientdir+'pat2') CDX stru
	SELE source3
	WAIT WIND NOWA 'โปรดคอย ! กำลังสำเนาแฟ้ม CONTACT ไปเป็นแฟ้ม CONT'
	COPY TO (patientdir+'cont') CDX stru
	UNLOCK ALL
	firsttime = .T.
ELSE
	firsttime = .F.
*	SET TALK ON
*SET ECHO ON
	
* ตรวจสอบว่ามีแฟ้มดัชนีครบถูกต้องหรือไม่
	IF ! FILE(patientdir+'pat1.cdx')
		SELE 0
		dbfuse = patientdir+'pat1'
		USE (patientdir+'pat1') EXCL
		WAIT WIND NOWA 'กำลังสร้างแฟ้มดัชนี PAT1 Tag hn'
		INDEX ON hn TAG hn
		WAIT WIND NOWA 'กำลังสร้างแฟ้มดัชนี PAT1 Tag name'
		INDEX ON name TAG name ADDI
		WAIT WIND NOWA 'กำลังสร้างแฟ้มดัชนี PAT1 Tag last'
		INDEX ON SUBS(name,AT(' ',name)+1,4) TAG last ADDI
		WAIT WIND NOWA 'กำลังสร้างแฟ้มดัชนี PAT1 Tag namelast'
		INDEX ON LEFT(name,4)+SUBS(name,AT(' ',name)+1,4) TAG namelast ADDI
		WAIT WIND NOWA 'กำลังสร้างแฟ้มดัชนี PAT1 Tag clinic'
		INDEX ON clinic TAG clinic ADDI
		WAIT WIND NOWA 'กำลังสร้างแฟ้มดัชนี PAT1 Tag lastdate'
		INDEX ON lastdate TAG lastdate ADDI
		FOR i = 1 TO FCOUNT()
			IF FIELD(i) = 'PERSON_ID'
				WAIT WIND NOWA 'กำลังสร้างแฟ้มดัชนี PAT1 Tag person_id'
				INDEX ON person_id TAG person_id ADDI
				EXIT
			ENDI
		NEXT
	ENDI
	IF ! FILE(patientdir+'pat2.cdx')
		dbfuse = patientdir+'pat2'
		USE (patientdir+'pat2') EXCL
		WAIT WIND NOWA 'กำลังสร้างแฟ้มดัชนี PAT2 Tag hn'
		INDEX ON hn TAG hn
	ENDI
	IF ! FILE(patientdir+'cont.cdx')
		dbfuse = patientdir+'cont'
		USE (patientdir+'cont')  EXCL
		WAIT WIND NOWA 'กำลังสร้างแฟ้มดัชนี CONT Tag hn'
		INDEX ON hn TAG hn
	ENDI
	USE
	dbfuse = ''
*	SET ECHO OFF
*	SET TALK OFF
	KEYB '!'
	= INKEY()
*	DO CLEARSCREEN
ENDI

localbackup = IIF(EMPTY(backupdrive),.F.,.T.)
* ถ้าต้องการสำรองข้อมูลไปที่ Local disk
IF localbackup
	backupdrive = LEFT(backupdrive,1)+':'
	DO CheckDir 	&& ตรวจสอบว่ามี directory ครบหรือไม่ ถ้าไม่ครบก็ให้สร้างให้ครบ
	IF adir(backupfile,backupdrive+'\pub\patient1.dbf')	= 0
		DO CopyToLocal
	ELSE
		=ADIR(mirrorfile,patientdir+'pat1.dbf')
		IF mirrorfile(2) # backupfile(2) .AND. (DTOS(mirrorfile(3))+mirrorfile(4) > DTOS(backupfile(3))+backupfile(4))
			DO CopyToLocal
		ENDI
	ENDI
	dbfuse = backupdrive+'\pub\patient1'
	USE (backupdrive+'\pub\patient1') order 1 ALIA backup1 IN 0 
	dbfuse = backupdrive+'\pub\patient2'
	USE (backupdrive+'\pub\patient2') ORDER 1 ALIA backup2 IN 0 
	dbfuse = backupdrive+'\pub\contact'
	USE (backupdrive+'\pub\contact') ORDER 1 ALIA backup3 IN 0 
	dbfuse = patientdir+'hncount'
	USE (patientdir+'hncount') IN 0
	dbfuse = patientdir+'er_hn'
	USE (patientdir+'er_hn') IN 0
	dbfuse = ''
	SELE hncount
	COPY TO (backupdrive+'\pub\hncount')
	USE
	SELE er_hn
	COPY TO (backupdrive+'\pub\er_hn')
	dbfuse = ipddir+'ancount'
	USE (ipddir+'ancount')
	COPY TO (backupdrive+'\ipd\ancount')
	dbfuse = ''
	USE
	UNLOCK ALL
ENDI
dbfuse = patientdir+'pat1'
USE (patientdir+'pat1') order 1 ALIA target1 IN 0 
dbfuse = patientdir+'pat2'
USE (patientdir+'pat2') ORDER 1 ALIA target2 IN 0 
dbfuse = patientdir+'cont'
USE (patientdir+'cont') ORDER 1 ALIA target3 IN 0 
dbfuse = ''
IF firsttime
	SELE source1
	WAIT WIND NOWA 'กำลังสร้างแฟ้มสำรองอยู่'
	GO BOTT
	lasthn = VAL(hn)
	FOR i = 1 TO lasthn
		m.hn = STRZERO(i,7)
		SELE source1
		IF SEEK(m.hn)
			@ 19,30 SAY 'ADD HN  ' + m.hn
			SCAT MEMV
			INSERT INTO target1 FROM MEMV
			SELE source2
			IF SEEK(m.hn)
				SCAT MEMV
				INSERT INTO target2 FROM MEMV
			ENDI
			SELE source3
			IF SEEK(m.hn)
				SCAT MEMV
				INSERT INTO target3 FROM MEMV
				IF owner = '1'
					_nowrec = RECNO()
				 	SKIP
				 	IF hn = m.hn .AND. owner = '2'
				 		SCAT MEMV
				 		INSERT INTO target3 FROM MEMV
				 	ELSE
				 		SELE target3
				 		REPL owner WITH '3'
				 		SELE source3
				 		IF hn = m.hn
					 		SCAT MEMV BLANK
					 		GATH MEMV
					 		GO _nowrec
					 		REPL owner WITH '3'
					 	ENDI
				 	ENDI
				 ENDI
			ENDI
		ENDI
		IF INKEY() = 27
			CLOSE DATA
			CANC
		ENDI
	NEXT
	@ 19,30 SAY SPACE(40)
	IF LocalBackup
		SELE target1
		USE
		SELE target2
		USE
		SELE target3
		USE
		SELE backup1
		USE
		SELE backup2
		USE
		SELE backup3
		USE
		DO CopyToLocal
		dbfuse = backupdrive+'\pub\patient1'
		USE (backupdrive+'\pub\patient1') order 1 ALIA backup1 IN 0 
		dbfuse = backupdrive+'\pub\patient2'
		USE (backupdrive+'\pub\patient2') ORDER 1 ALIA backup2 IN 0 
		dbfuse = backupdrive+'\pub\contact'
		USE (backupdrive+'\pub\contact') ORDER 1 ALIA backup3 IN 0 
		dbfuse = patientdir+'pat1'
		USE (patientdir+'pat1') order 1 ALIA target1 IN 0 
		dbfuse = patientdir+'pat2'
		USE (patientdir+'pat2') ORDER 1 ALIA target2 IN 0 
		dbfuse = patientdir+'cont'
		USE (patientdir+'cont') ORDER 1 ALIA target3 IN 0 
		dbfuse = ''
	ENDI
ENDI		
*SET ESCA OFF
goon = .T.
ON KEY LABEL F10 SUSP
dbfuse = patientdir+'hnchange'
USE (patientdir+'hnchange') ORDER 1 IN 0
dbfuse = ''
SELE hnchange
mrow=MOD(VAL(SYS(3)),20)
mcol=MOD(VAL(SYS(3)),74)
Up=IIF(MOD(mrow,2)=1,.T.,.F.)
Left=IIF(MOD(mcol,2)=1,.T.,.F.)
DEFINE WIND scr FROM mrow,mcol TO mrow+5,mcol+15 FLOAT COLO SCHE 5 && NONE
ACTI WINDOW Scr 
*@ 0,2 to 1,4
*@ 0,8 to 1,10
@ 0,2 SAY '    ' && COLO r/b
@ 1,2 SAY '    '
@ 3,1 to 3,11
KEYB  ' '
= INKEY()
numdone = 0
prehn = 'XXXXXXX'
samehn = 1
DO WHIL goon
	SELE hnchange
	GO TOP
	IF ISDIGIT(hn) .AND. ! EOF()
		IF hn = prehn
			WAIT WIND NOWA 'หมายเลขที่ซ้ำคือ ' + hn
			@ 2,3 SAY STR(samehn,7)
			samehn = samehn + 1
		ELSE
			samehn = 1
			KEYB '!'
			m.hn = hn
			@ 2,3 SAY m.hn
			SELE source1
			IF SEEK(m.hn)
				SCAT MEMV
				SELE target1
				IF ! SEEK(m.hn)
					GO TOP
					IF ISDIGIT(hn) .OR. BOF()
						APPE BLAN
					ENDI
				ENDI
				GATH MEMV
				SELE source2
				IF SEEK(m.hn)
					SCAT MEMV
					SELE target2
					IF ! SEEK(m.hn)
						GO TOP
						IF ISDIGIT(hn) .OR. BOF()
							APPE BLAN
						ENDI
					ENDI
					GATH MEMV
				ENDI
				SELE source3
				IF SEEK(m.hn)
					SCAT MEMV
					SELE target3
					newcon = .F.		&& สมมุติว่ามีข้อมูลในแฟ้ม CONTACT อยู่แล้ว
					IF ! SEEK(m.hn)
						GO TOP
						IF ISDIGIT(hn) .OR. BOF()
							APPE BLAN
					ENDI
						newcon = .T.
					ENDI
					GATH MEMV
					SELE source3
					IF owner = '1'
						SKIP
						IF hn = m.hn .AND. owner = '2'
							SCAT MEMV
							IF newcon
								INSERT INTO target3 FROM MEMV
							ELSE
								SELE target3
								SKIP
								IF hn = m.hn
									GATH MEMV
								ELSE
									INSERT INTO target3 FROM MEMV
								ENDI
							ENDI
						ELSE
							SKIP -1
							REPL owner WITH '3'
							SELE target3
							REPL owner WITH '3'
						ENDI
					ENDI
				ENDI
				IF LocalBackup
					SELE source1
					SCAT MEMV
					SELE backup1
					IF ! SEEK(m.hn)
						GO TOP
						IF ISDIGIT(hn) .OR. BOF()
							APPE BLAN
						ENDI
					ENDI
					GATH MEMV
					SELE source2
					IF SEEK(m.hn)
						SCAT MEMV
						SELE backup2
						IF ! SEEK(m.hn)
							GO TOP
							IF ISDIGIT(hn) .OR. BOF()
								APPE BLAN
							ENDI
						ENDI
						GATH MEMV
					ENDI
					SELE source3
					IF SEEK(m.hn)
						SCAT MEMV
						SELE backup3
						newcon = .F.		&& สมมุติว่ามีข้อมูลในแฟ้ม CONTACT อยู่แล้ว
						IF ! SEEK(m.hn)
							GO TOP
							IF ISDIGIT(hn) .OR. BOF()
								APPE BLAN
							ENDI
						newcon = .T.
						ENDI
						GATH MEMV
						SELE source3
						IF owner = '1'
							SKIP
							IF hn = m.hn .AND. owner = '2'
								SCAT MEMV
								IF newcon
									INSERT INTO backup3 FROM MEMV
								ELSE
									SELE backup3
									SKIP
									IF hn = m.hn
										GATH MEMV
									ELSE
										INSERT INTO backup3 FROM MEMV
									ENDI
								ENDI
							ELSE
								SKIP -1
								REPL owner WITH '3'
								SELE backup3
								REPL owner WITH '3'
							ENDI
						ENDI
					ENDI
					IF numdone > 100
						SELE 0
						dbfuse = patientdir+'hncount'
						USE (patientdir+'hncount') 			
						COPY TO (backupdrive+'\pub\hncount')
						dbfuse = patientdir+'er_hn'
						USE (patientdir+'er_hn') 
						COPY TO (backupdrive+'\pub\er_hn')
						dbfuse = ipddir+'ancount'
						USE (ipddir+'ancount')
						COPY TO (backupdrive+'\ipd\ancount')
						USE
						dbfuse = ''
						numdone = 0
					ENDI
					numdone = numdone +1
				ENDI
			ENDI
		ENDI
		SELE hnchange
		prehn = hn
		REPL hn WITH 'ZZZZZZZ'
		FLUSH
		UNLOCK ALL
	ELSE
		IF ! BOF() .AND. LEFT(hn,2) # 'ZZ'
			REPL hn WITH 'ZZZZZZZ'
		ENDI
		UNLOCK ALL
	
		DO CASE
			CASE RECCOUNT('source1')  > RECCOUNT('target1')
				SELE source1
				GO TOP
				s1 = 0
				DO WHIL EMPTY(hn) .AND. ! BOF() .AND. ! EOF()
					s1 = s1+1
					SKIP
				ENDD
				SELE target1
				GO TOP
				s2 = 0
				DO WHIL EMPTY(hn) .AND. ! BOF() .AND. ! EOF()
					s2 = s2+1
					SKIP
				ENDD
				numlack = RECCOUNT('source1') - RECCOUNT('target1') - s1 + s2
				IF numlack > 0
					SELE source1
					DO Rescan
				ENDI
			CASE  RECCOUNT('target1') # RECCOUNT('target2')
				SELE target1
				t1 = RECCOUNT('target1')
				GO TOP
				DO WHIL EMPTY(hn) .AND. ! BOF() .AND. ! EOF()
					t1 = t1 - 1
					SKIP
				ENDD
				SELE target2
				t2 = RECCOUNT('target2')
				GO TOP
				DO WHIL EMPTY(hn) .AND. ! BOF() .AND. ! EOF()
					t2 = t2 - 1
					SKIP
				ENDD
				IF t1 > t2
					DO checklack
				ENDI
				IF t2 > t1
					SELE target2
					DO CheckDup
				ENDI
					
			CASE RECCOUNT('source2') > RECCOUNT('target2') .OR. ;
				RECCOUNT('source2') > RECCOUNT('source1')
				SELE source2
				DO CHECKDUP
				DO CheckOver
			OTHER
				CLOSE DATA
					FOR i = 1 TO 60
						DO MoveWind
						mkey = INKEY(1)
						IF mkey = -9 .OR. mkey = 27
							STOR .F. TO goon
							EXIT
						ENDI
					NEXT
				dbfuse = patientdir+'patient1'
				USE (patientdir+'patient1') order 1 ALIA source1 IN 0
				dbfuse = patientdir+'patient2'
				USE (patientdir+'patient2') ORDER 1 ALIA source2 IN 0
				dbfuse = patientdir+'contact'
				USE (patientdir+'contact') ORDER 1 ALIA source3 IN 0
				dbfuse = patientdir+'pat1'
				USE (patientdir+'pat1') order 1 ALIA target1 IN 0
				dbfuse = patientdir+'pat2'
				USE (patientdir+'pat2') ORDER 1 ALIA target2 IN 0
				dbfuse = patientdir+'cont'
				USE (patientdir+'cont') ORDER 1 ALIA target3 IN 0
				dbfuse = patientdir+'hnchange'
				USE (patientdir+'hnchange') ORDER 1 IN 0
				IF localbackup
					dbfuse = backupdrive+'\pub\patient1'
					USE (backupdrive+'\pub\patient1') order 1 ALIA backup1 IN 0 
					dbfuse = backupdrive+'\pub\patient2'
					USE (backupdrive+'\pub\patient2') ORDER 1 ALIA backup2 IN 0 
					dbfuse = backupdrive+'\pub\contact'
					USE (backupdrive+'\pub\contact') ORDER 1 ALIA backup3 IN 0 
				ENDI
				dbfuse = ''
				SELE hnchange
		ENDC
				NowTime = LEFT(TIME(),2)
				TimeToBackup = IIF(LocalBackup .AND. PreBackup # Nowtime,.T.,.F.)
				IF TimeToBackup
					CLOSE DATA
					PreBackup = Nowtime
					DO BackupData
					CLOSE DATA
					dbfuse = patientdir+'patient1'
					USE (patientdir+'patient1') order 1 ALIA source1 IN 0
					dbfuse = patientdir+'patient2'
					USE (patientdir+'patient2') ORDER 1 ALIA source2 IN 0
					dbfuse = patientdir+'contact'
					USE (patientdir+'contact') ORDER 1 ALIA source3 IN 0
					dbfuse = patientdir+'pat1'
					USE (patientdir+'pat1') order 1 ALIA target1 IN 0
					dbfuse = patientdir+'pat2'
					USE (patientdir+'pat2') ORDER 1 ALIA target2 IN 0
					dbfuse = patientdir+'cont'
					USE (patientdir+'cont') ORDER 1 ALIA target3 IN 0
					dbfuse = patientdir+'hnchange'
					USE (patientdir+'hnchange') ORDER 1 IN 0
					IF localbackup
						dbfuse = backupdrive+'\pub\patient1'
						USE (backupdrive+'\pub\patient1') order 1 ALIA backup1 IN 0 
						dbfuse = backupdrive+'\pub\patient2'
						USE (backupdrive+'\pub\patient2') ORDER 1 ALIA backup2 IN 0 
						dbfuse = backupdrive+'\pub\contact'
						USE (backupdrive+'\pub\contact') ORDER 1 ALIA backup3 IN 0 
					ENDI
					dbfuse = ''
					SELE hnchange
				ENDI
	ENDI
	DO MoveWind
	IF INKEY() = 27
		goon = .F.
	ENDI
ENDD	
DEAC WIND ALL
CLOSE DATA

PROC STRZERO
* FORMAT: string = STRZERO(numeric 1,numeric 2)
* เปลี่ยนค่า numeric 1 ให้เป็น string ที่มีความยาวเท่ากับ numeric 2
* โดยให้มีเลข '0' นำหน้า
PARA _str,_num
RETU RIGHT(STR(1000000000+_str,10),_num)

PROC STOPIT
STOR .F. TO goon

PROC MOVEWIND
	IF Up
		Up=IIF(mrow<1,.F.,.T.)
		mrow=IIF(mrow<1,1,mrow-1)
	ELSE
		Up=IIF(mrow>18,.T.,.F.)
		mrow=IIF(mrow>18,18,mrow+1)
	ENDI
	IF Left
		LEFT=IIF(mcol<1,.F.,.T.)
		mcol=IIF(mcol<1,1,mcol-1)
	ELSE
		Left=IIF(mcol>63,.T.,.F.)
		mcol=IIF(mcol>63,63,mcol+1)
	ENDI
	MOVE WINDOW scr TO mrow,mcol
	
PROC RESCAN
*SET ESCA ON
WAIT WIND NOWA 'PLEASE WAIT ! NOW RESCAN FILE PATIENT1'
MOVE WIND scr CENTER
SELE source1
SET ORDER TO TAG hn
SET RELA TO hn INTO target1
*SET RELA TO hn INTO hnchange ADDI
*SET ORDER TO 0
_x = 0
GO BOTT
prehn = 'ZZZZZZZ'
prerec = 0
DO WHIL ! BOF() .AND. _x < numlack .AND. INKEY() # 27
	@ 2,3 SAY hn
IF hn > prehn
	ACTI WIND errindex
	@ 1,2 SAY 'มีปัญหาที่แฟ้มดัชนีของแฟ้ม PATIENT1 กรุณาซ่อมแฟ้มดัชนีใหม่'
	ACTI SCREE
ELSE
	prehn = hn
	prerec = RECNO()
ENDI
	IF EOF('target1') && .AND. EOF('hnchange')
		SELE hnchange
		GO TOP
		IF ISDIGIT(hn) .OR. BOF()
			APPE BLAN
		ENDI
		REPL hn WITH source1.hn
		SELE source1
		_x = _x + 1
	ENDi
	SELE source1
	IF ! BOF()
		SKIP -1
	ENDI
ENDD
SELE source1
SET ORDER TO TAG hn

IF BOF() 
	SELE source1
	DO CheckDup
*	SET STAT OFF
ENDI
*SET ESCA OFF
KEYB ' '
= INKEY()

PROC ERRTRAP
PARA errnum,errmess,_line,_prog
SET PRIN OFF
SET DEVI TO SCREE
IF errnum=108 .OR. errnum = 109
	WAIT WINDOW 'Please Wait ! Try To Open File' timeout 1
	IF INKEY(30)<>27
		RETRY
	ELSE
		@ 23,10 SAY 'Can Not Open File. Procedure Abort' COLO r+/b
		close data
		canc
	ENDI
ELSE
	ACTI SCREE
	@ 23,10 SAY ;
	' Error ! '+LTRIM(STR(Errnum))+' '+errmess
	canc
ENDI

PROC CHECKLACK
numlack = t1 - t2
SELE target1
SET RELA TO hn INTO target2
MOVE WIND scr CENTER
GO TOP
x=0
WAIT WIND NOWA 'Wait! Check for inconsistency of backup  '+ALLTRIM(STR(numlack-x))
*SET ESCA ON
DO WHIL ! EOF() .AND. x < numlack .AND. INKEY() # 27
	@ 2,3 SAY hn
	IF EOF('target2')
		x = x+1
		WAIT WIND NOWA 'Wait! Check for inconsistency of backup  '+ALLTRIM(STR(numlack-x))
		m.hn = hn
		SELE source2
		IF SEEK(m.hn)
			SCAT MEMV
		ENDI
		INSERT INTO target2 fROM MEMV
		SELE source3
		IF SEEK(m.hn)
			SELE target3
			newcon = .F.		&& สมมุติว่ามีข้อมูลในแฟ้ม CONTACT อยู่แล้ว
			IF ! SEEK(m.hn)
				GO TOP
				IF ISDIGIT(hn) .OR. BOF()
					APPE BLAN
				ENDI
				newcon = .T.
			ENDI
			GATH MEMV
			SELE source3
			IF owner = '1'
				SKIP
				IF hn = m.hn .AND. owner = '2'
					SCAT MEMV
					IF newcon
						INSERT INTO target3 FROM MEMV
					ELSE
						SELE target3
						SKIP
						IF hn = m.hn
							GATH MEMV
						ELSE
							INSERT INTO target3 FROM MEMV
						ENDI
					ENDI
				ELSE
					SKIP -1
					REPL owner WITH '3'
					SELE target3
					REPL owner WITH '3'
				ENDI
			ENDI
		ELSE
			SELE target3
			IF ! SEEK(m.hn)
				m.owner='3'
				GO TOP
				IF ISDIGIT(hn) .OR. BOF()
					APPE BLAN
				ENDI
			ENDI
			GATH MEMV
		ENDI
		SELE target1
	ENDI
	SKIP
ENDD
*SET ESCA OFF
KEYB ' '
= INKEY()

PROC CHECKDUP
	GO TOP
	WAIT WIND NOWA 'Waiting ! Checking For Duplicated Record OF ' + DBF()
	m.hn = 'ZZZZZ'
	DO WHIL EMPTY(hn)
		SKIP
	ENDD
*	SET ESCA ON
	DO WHIL ! EOF() .AND. INKEY() # 27
		@ 2,3 SAY hn
		IF hn = m.hn 
			REPL hn WITH SPACE(7)
			SEEK m.hn
		ENDI
		m.hn = hn
		IF ! EOF()
			SKIP
		ENDI
	ENDD
*	SET ESCA OFF
KEYB ' '
=INKEY()

PROC CHECKDIR
IF ADIR(test,backupdrive+'\pub.','D') = 0
	makedir = backupdrive+'\pub'
	! md &makedir
ENDI
IF ADIR(test,backupdrive+'\opd.','D') = 0
	makedir = backupdrive+'\opd'
	! md &makedir
	makedir = backupdrive+'\opd\report'
	! md &makedir
ENDI
IF ADIR(test,backupdrive+'\ipd.','D') = 0
	makedir = backupdrive+'\ipd'
	! md &makedir
	makedir = backupdrive+'\ipd\data'
	! md &makedir
	makedir = backupdrive+'\ipd\lib'
	! md &makedir
	makedir = backupdrive+'\ipd\report'
	! md &makedir
ENDI
IF ADIR(test,backupdrive+'\pharm.','D') = 0
	makedir = backupdrive+'\pharm'
	! md &makedir
ENDI

PROC CopyToLocal
		WAIT WIND NOWA 'โปรดคอย ! กำลังสำเนาแฟ้ม PATIENT1.DBF ไปที่ Drive ' + backupdrive
		COPY FILE (patientdir+'pat1.dbf') TO (backupdrive+'\pub\patient1.dbf')
		WAIT WIND NOWA 'โปรดคอย ! กำลังสำเนาแฟ้ม PATIENT2.DBF ไปที่ Drive ' + backupdrive
		COPY FILE (patientdir+'pat2.dbf') TO (backupdrive+'\pub\patient2.dbf')
		WAIT WIND NOWA 'โปรดคอย ! กำลังสำเนาแฟ้ม CONTACT.DBF ไปที่ Drive ' + backupdrive
		COPY FILE (patientdir+'cont.dbf') TO (backupdrive+'\pub\contact.dbf')
		WAIT WIND NOWA 'โปรดคอย ! กำลังสำเนาแฟ้ม PATIENT1.CDX ไปที่ Drive ' + backupdrive
		COPY FILE (patientdir+'pat1.CDX') TO (backupdrive+'\pub\patient1.CDX')
		WAIT WIND NOWA 'โปรดคอย ! กำลังสำเนาแฟ้ม PATIENT2.CDX ไปที่ Drive ' + backupdrive
		COPY FILE (patientdir+'pat2.CDX') TO (backupdrive+'\pub\patient2.CDX')
		WAIT WIND NOWA 'โปรดคอย ! กำลังสำเนาแฟ้ม CONTACT.CDX ไปที่ Drive ' + backupdrive
		COPY FILE (patientdir+'cont.CDX') TO (backupdrive+'\pub\contact.CDX')
		KEYB ' '
		= INKEY()
		
PROC BackupData
PRIV numfile,i,numdirec,n
SELE 0
numdirec = 5
DIME backdir[numdirec],targetdir[numdirec]
backdir[1] = patientdir
backdir[2] = codedir
backdir[3] = opddir
backdir[4] = ipddir+'data\'
backdir[5] = pharmdir
targetdir[1] = backupdrive+'\pub\'
targetdir[2] = backupdrive+'\pub\'
targetdir[3] = backupdrive+'\opd\'
targetdir[4] = backupdrive+'\ipd\data\'
targetdir[5] = backupdrive+'\pharm\'
n=1
DO WHIL n <= numdirec
	WAIT WIND NOWA 'โปรดคอย ! กำลังตรวจสอบแฟ้มที่จะสำรองใน Directory ' + backdir[n]
	numfile = ADIR(dbffile,backdir[n]+'*.dbf')
	=ASORT(dbffile)
	FOR i = 1 TO numfile
		IF ! LEFT(dbffile[i,1],3) $ 'PAT,CON,HNC,FOX' .AND. ! ISDIGIT(dbffile[i,1])
			IF ADIR(cdbf,targetdir[n]+dbffile[i,1]) > 0
				IF dbffile[i,2] # cdbf[2] .OR. DTOS(dbffile[3])+dbffile[4] ;
				> DTOS(cdbf[3])+cdbf[4]
					WAIT WIND NOWA 'โปรดคอย ! กำลังสำรองแฟ้ม '+dbffile[i,1]
					dbfuse = backdir[n]+dbffile[i,1]
					USE (backdir[n]+dbffile[i,1])
					COPY TO (targetdir[n]+cdbf[1]) CDX
				ELSE
					WAIT WIND NOWA 'ไม่ต้องสำรองแฟ้ม ' + dbffile[i,1]
				ENDI
			ELSE
				WAIT WIND NOWA 'โปรดคอย ! กำลังสำรองแฟ้ม '+dbffile[i,1]
				dbfuse = backdir[n]+dbffile[i,1]
				USE (backdir[n]+dbffile[i,1])
				COPY TO (targetdir[n]+dbffile[i,1]) CDX
			ENDI
		ENDI
		dbfuse = ''
		IF INKEY() = 27
			n = numdirec + 1
			EXIT
		ENDI
	NEXT
	n = IIF(n=1 .AND. codedir = patientdir, 3, n+1)
ENDD
KEYB '!'
=INKEY()

PROC CheckOver
WAIT WIND NOWA 'โปรดคอย ! กำลังกำจัดขยะในแฟ้ม Patient2'
SELE source2
SET RELA TO hn INTO source1
GO TOP
DO WHIL EMPTY(hn) .AND. ! EOF()
	SKIP
ENDD
prehn = 'ZZZZ'
DO WHIL ! EOF() .AND> INKEY() # 27
	IF EOF('source1')
		REPL hn WITH SPACE(7)
		SEEK prehn
	ENDI
	prehn = hn
	IF ! EOF()
		SKIP
	ENDI
ENDD
KEYB '!'
=INKEY()