EXTERNAL ARRAY PCOND3,COND3,CONDTYPE,PRQBE, OFFER ,PCOND1 ,PCOND2 ,CONDITION
#define numreport 9
DIME rp(numreport),rpmsg[numreport]
rp(1)='1. ทำรายงานประจำ'
rp(2)='2. ค้นหาตามเงื่อนไข'
rp(3)='3. Optional Report'
rp[4] = '4. ค้นหา HN ตามเงื่อนไข'
rp[5] = '5. กำหนดค่า'
rp[6] = '6. ค้นประวัติผู้ป่วย'
rp[7] = '7. อุบัติเหตุจราจร'
rp[8] = '8. รายงานสิทธิบัตร'
rp(numreport)='0. กลับรายการเดิม'

rpmsg[1] = 'ทำรายงานประจำเดือน และรายงานประจำปี'
rpmsg[2] = 'หาจำนวนแบบตาราง 2 มิติ โดยสามารถกำหนดเงื่อนไขต่าง ๆ ได้'
rpmsg[3] = 'หาจำนวนตามตัวแปรที่เลือก หา HN ผู้ป่วยที่นัดมาตรวจในแต่ละวัน'
rpmsg[4] = 'แสดงเลขที่ผู้ป่วยนอกตามเงื่อนไขที่กำหนดไว้'
rpmsg[5] = 'แบ่งกลุ่มอายุ และ กลุ่มโรคที่ต้องการหา'
rpmsg[6] = 'ค้นประวัติผู้ป่วยตามช่วงเวลาที่กำหนด'
rpmsg[7] = 'หาจำนวนอุบัติเหตุจราจรตามช่วงเวลาที่กำหนด'
rpmsg[8] = 'หาผู้ป่วยที่มารักษาและมีสิทธิบัตรต่าง ๆ'
rpmsg[numreport] = 'กลับไปที่รายการก่อนหน้านี้'

IF FILE('DEFAULT.AGE')
	REST FROM default.age ADDI
ELSE
	DIME agecode(14),agecoded(14),agemax(14),agemin(14),agemaxtype(14),agemintype(14)
	STOR 0 TO agecount
	FOR in = 1 TO 14
		STOR SPACE(1) TO agemaxtype(in),agemintype(in)
		STOR SPACE(15) TO agecoded(in)
		STOR 0 TO agemax(in),agemin(in)
	NEXT
ENDI
IF FILE('DEFAULT.DX')
	REST FROM default.dx ADDI
ELSE
	DIME diagcode(14),diagcoded(14),diagmax(14),diagmin(14)
	STOR 0 TO diagcount
	FOR in = 1 TO 14
		STOR SPACE(5) TO diagmax(in),diagmin(in)
		STOR SPACE(15) TO diagcoded(in)
	NEXT
ENDI
DEFINE WIND rp_menu FROM 4,5 TO 4+ALEN(rp)+3,40 SHAD TITLE 'รายงานผู้ป่วยนอก' COLO gr+/bg
DO WHIL .T.
	ACTI WIND rp_menu
	ON KEY LABEL CTRL+P
	CLEA
	IF USED('rqbe')
		SELE rqbe
		USE
	ENDI
	FOR i=1 TO numreport
		@ i,3 PROMPT rp(i) MESS rpmsg[i]
	NEXT
	MENU TO Ch_rp
	DO CASE
		CASE Ch_Rp = 1
			DO RoutRep
		CASE Ch_Rp = 2
			DO rqbe
		CASE Ch_Rp = 3
			DO bar
			@ 2,0 SAY REPL('-',80)
			@ 21,0 SAY REPL('-',80)
			@ 0,Center(mhosp_name) SAY mhosp_name COLO r+/b
			@1,2 SAY Ce2CBe(date()) COLO gr+/b
			DO OpenCameDBF
		CASE Ch_Rp = 4
			DO RQBEHn
		CASE Ch_Rp = 5
			DO InstallRp
		CASE Ch_Rp = 6
			DO FindHist
		CASE Ch_Rp = 7
			DO AcciTime
		CASE Ch_Rp = 8
			DO Cardrepo
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND Rp_Menu

PROC RoutRep
ACTI SCREEN
DIME routine[9]
routine[1] = '1. รายงานส่งกระทรวง  '
routine[2] = '2. รายงานส่ง สปสช.  '
routine[3] = '3. รายงาน 504  '
routine[4] = '4. รายงานอุบัติเหตุจราจร  '
routine[5] = '5. รายงานโรคที่พบบ่อย '
routine[6] = '6. รายงาน 506  '
*routine[7] = '7. รายงานโรคตา  '
routine[7] = '7. รายงานแยกโรค  '
routine[8] = '8. รายงานผู้ป่วยคดี  '
routine[9] = '0. กลับรายการเดิม  '
ch_rout = 1
DO WHIL .T.
	ACTI SCREEN
	DO ClearScreen
	@ 11,44 GET ch_rout FROM routine
	READ NOLOCK
	DO CASE
		CASE LASTKEY() = 27
			EXIT
		CASE ch_rout = 1
			DO Rp_Govn
		CASE ch_rout = 2
			DO Rp_NHSO
		CASE ch_rout = 3
			DO ToCal504
  		CASE ch_rout = 4
			DO CalAcci
  		CASE ch_rout = 5
			DO MostOPD
  		CASE ch_rout = 6
			DO 506
*  		CASE ch_rout = 7
*			DO EYE101
		CASE ch_rout = 7
			DO OPDIAG
  		CASE ch_rout = 8
			DO ACCREP
		OTHER
			EXIT
	ENDC
ENDD
DO ClearScreen
*DO MAINSCR

PROC INSTALLRP
ACTI SCREEN
DIME installrp[3]
installrp[1] = '1. กำหนดกลุ่มอายุ'
installrp[2] = '2. กำหนดกลุ่มโรค'
installrp[3] = '0. กลับรายการเดิม'
ch_inst = 1
DO WHIL .T.
	ACTI SCREE
	DO ClearScreen
	@ 13,45 GET ch_inst FROM installrp
	READ NOLOCK
	DO CASE
		CASE LASTKEY() = 27
			EXIT
		CASE ch_inst = 1
			DO InstallAge
		CASE ch_inst = 2
			DO InstallDiag
		OTHER
			EXIT
	ENDC
ENDD
DO ClearScreen

PROC Rp_Govn
DEFINE WIND rp_govn FROM 8,35 TO 15,79 SHAD TITLE 'รายงานผู้ป่วยนอกส่งกระทรวง' COLO gr+/b
ACTI WIND rp_govn
@ 1,4 SAY 'ต้องการใส่รายงานไว้ในไดร์ฟไหน  '
@ 2,10 PROMPT 'A:'
@ 3,10 PROMPT 'B:'
MENU TO mdrive
?? CHR(7)
IF mdrive=0
	WAIT WIND 'ยกเลิกการส่งรายงานไปกระทรวงตามต้องการ' NOWA
ELSE
	drive=IIF(mdrive=1,'A:','B:')
	mfile=drive+'readme.opd'
	WAIT WIND 'กรุณาใส่แผ่นดิสก์ไว้ในไดร์ฟ '+drive+' แล้วกดปุ่มอะไรก็ได้'
	fhandle=FCREATE(mfile)
	errmsg=''
	IF NoError(fhandle,errmsg)
		=FCLOSE(fhandle)
		@ 4,2 SAY 'ต้องการส่งรายงานเดือนไหน mm/yy ' GET mmyy DEFA '    ';
		PICT '@R 99/99' COLO gr+/b
		READ NOLOCK
		mm=LEFT(mmyy,2)
		IF LASTKEY()=27 .OR. mm<'01' .OR. mm>'12'
			DEAC WIND ALL
			WAIT 'ยกเลิกการทำรายงาน' WIND NOWA
			RETU
		ENDI
		yy=RIGHT(mmyy,2)
		yymm=yy+mm
		recal = 'Y'
		IF ! FILE(opddir+'came'+yymm+'.dbf')
			?? CHR(7)
			WAIT WIND 'ไม่มีแฟ้มผู้ป่วยเดือน'+month&mm+' ปี '+yy NOWA
		ELSE
			IF FILE(opddir+'report\op'+yymm+'.zip')
				DEFINE WIND askgo FROM 10,20 TO 15,60 SHAD
				ACTI WIND askgo
				@ 1,3 SAY 'ข้อมูลเดือน'+month&mm+' '+FullYear(yy)+' เคยคำนวณแล้ว'
				@ 2,3 SAY 'ต้องการคำนวณใหม่หรือไม่ ' GET recal DEFA 'N' PICT '!'
				READ NOLOCK
				RELE WIND askgo
			ENDI
			IF recal = 'Y'
				SELE 0
				dbfuse = opddir+'refer&yy'
				USE (opddir+'refer&yy') ALIA refer
				SELE 0
				dbfuse = opddir+'came'+yymm
				USE (opddir+'came'+yymm) ORDER 1 ALIA camefile
				dbfuse = ''
				numrec=RECCOUNT()
				div_num=ROUND((numrec/40)+.5,0)
				DO ShowProgress
				SELE 0
				mdbf=drive+'op'+yymm
				dbfuse = opddir+'report\op'+yymm
				CREATE TABLE (opddir+'report\op'+yymm);
				(HN C(7),CHANGWAT C(2),AMPUR C(2),TAMBON C(2),VILLAGE C(2),;
				SEX C(1),AGE_TYPE C(1),AGE N(2),MARRIAGE C(1),OCCUPA C(3),;
				NATION C(2),WARD C(3),DATE C(8),DG1 C(7),EPISODE1 C(1),;
				DG2 C(7),EPISODE2 C(1),DG3 C(7),EPISODE3 C(1),DG4 C(7),;
				EPISODE4 C(1),DG5 C(7),EPISODE5 C(1),DG6 C(7),EPISODE6 C(1),;
				DG7 C(7),EPISODE7 C(1),DG8 C(7),EPISODE8 C(1),DG9 C(7),;
				EPISODE9 C(1),DG10 C(7),EPISODE10 C(1),DG11 C(7),EPISODE11 C(1),;
				DG12 C(7),EPISODE12 C(1),ONSET N(2),RESULT C(2),REFERIN C(5),;
				REFEROUT C(5),CAUSEIN C(2),CAUSEOUT C(2),PTTYP C(2))
				USE (opddir+'report\op'+yymm) ALIA target
				dbfuse = ''
*			filesize=HEADER()+(RECSIZE()*numrec)+1
				SELE camefile
				SET ORDER TO 0
				GO TOP
				SET RELA TO hn INTO patient2
				SET RELA TO hn INTO contact ADDI
				SCAN FOR ! EMPTY(camefile.hn) .AND. ! EMPTY(camefile.sequence)
					@ 3,3 SAY SPACE((ROUND(recno('camefile')/div_num+.5,0))) COLO gr/r
					IF sequence=1
						numdiag=1
						SELE target
						SCAT MEMV BLANK
						SELE contact
						SCAT MEMV
						SELE patient2
						SCAT MEMV
						searchday=DTOC(camefile.date)
						searchday=LEFT(searchday,2)+SUBS(searchday,4,2)
						IF camefile.rem_c='4'
							SELE refer
							LOCA FOR hn=camefile.hn  .AND. type='1' .AND. ;
							day=searchday
							m.referin=place
							m.causein=cause
						ENDI
						IF camefile.result='54'
							SELE refer
							LOCA FOR hn=camefile.hn  .AND. type='2' .AND. ;
							day=searchday
							m.referout=place
							m.causeout=cause
						ENDI
						SELE camefile
						SCAT MEMV
						m.onset=date-ill_date
						IF EMPTY(m.changwat)
							m.changwat=IIF(m.province='1',hosp_province ,m.changwat)
						ENDI
						m.dg1=m.diag
						m.episode1=m.episode
						m.pttyp=m.fc
						m.date=STR(YEAR(m.date)+543,4)+STRZERO(month(m.date),2)+STRZERO(DAY(m.date),2)
						m.ward=m.clinic
						INSERT INTO target FROM MEMV
						FLUSH
					ELSE
						SELE target
						dd=STR(camefile.sequence,1)
						REPL dg&dd WITH camefile.diag,episode&dd WITH camefile.episode
						FLUSH
					ENDI
					SELE camefile
				ENDS
				FLUSH
				USE
				SELE target
				USE
				SELE refer
				USE
			ENDI
			DEFINE WIND comment FROM 7,10 TO 12,70 SHAD ;
			TITLE 'ข้อความฝากถึงส่วนกลาง' COLO r+/w
			ACTI WIND comment
			ON KEY LABEL ENTER KEYB "{TAB}"
			@ 1,4 EDIT m.comment DEFA '' SIZE 3,50
			READ NOLOCK
			ON KEY LABEL ENTER
			?? CHR(7)
			WAIT WIND 'โปรดคอย กำลังเก็บข้อมูลใส่ไว้ในแผ่นดิสต์ในช่อง ';
			+drive NOWA
			tofile = opddir+'report\op'+yymm
			IF recal = 'Y'
				ACTI SCREE
				zipfile = opddir+'report\op'+yymm+'.dbf'
				exefile = patientdir+'PKZIP'
				RUN &exefile -m &tofile &zipfile
				CLEA
			ENDI
			IF ! FILE(tofile+'.zip')
				=ALARM1()
				WAIT WIND 'ไม่สามารถสร้าง ZIP ไฟล์ได้ กดปุ่มอะไรก็ได้เพื่อยกเลิกการส่งข้อมูล'
				RELE WIND comment
				RELE WIND progress
				RETU
			ENDI
			DIME tfile[5]
			=ADIR(tfile,opddir+'report\op'+yymm+'.zip')
			olddrive=SYS(5)
			SET DEFA TO &drive
			freespace=DISKSPACE()
			samefile = 0
			IF FILE(drive+'op'+yymm+'.zip')
				DIME pfile[5]
				=ADIR(pfile,drive+'op'+yymm+'.zip')
				samefile = pfile[2]
			ENDI
			DO WHIL freespace<=tfile[2]+4000-samefile
				?? CHR(7)
				WAIT WIND 'เนื้อที่ว่างในไดร์ฟ '+drive+' มีไม่พอ'
				freespace = DISKSPACE()
			ENDD
			SET DEFA TO &olddrive
			IF LASTKEY() # 27
				DIME rp_file(5)
				=ADIR(rp_file,opddir+'report\op'+yymm+'.zip')
				filelen=LTRIM(STR(rp_file(2)))
				filedate=CE2CBE(rp_file(3))
				fhandle=FCREATE(mfile)
				=FWRITE(fhandle,'HP: ')
				=FPUTS(fhandle,hosp_name)
				=FWRITE(fhandle,'HC: ')
				=FPUTS(fhandle,hosp_code)
				=FPUTS(fhandle,'VL: OPD')
				=FWRITE(fhandle,'RD: ')
				=FPUTS(fhandle,DTOC(date()))
				=FPUTS(fhandle,'CT: 01,'+'OP'+yymm+'.ZIP'+','+filedate+','+filelen)
				=FWRITE(fhandle,'CM: ')
				=FPUTS(fhandle,m.comment)
				SELE doctor
				COPY TO (drive+'doctor')
				SELE clinic
				COPY TO (drive+'clinic')
				tofile = drive+'op'+yymm+'.zip'
				fromfile = opddir+'report\op'+yymm+'.zip'
				COPY FILE (fromfile) TO (tofile)
			ELSE
				?? CHR(7)
				WAIT WIND NOWA 'ไม่ได้เก็บข้อมูลไว้ในไดร์ฟ '+drive
			ENDI
			RELE WIND comment
			RELE WIND progress
		ENDI
		=FCLOSE(fhandle)
	ELSE
		?? CHR(7)
		WAIT WIND 'ไม่สามารถสร้างแฟ้มได้เนื่องจาก'+errmsg NOWA
	ENDI
ENDI
RELE WIND rp_govn
ACTI SCREE
@ 24,0
KEYB '!'

PROC Rp_NHSO

DEFINE WIND rp_NHSO FROM 8,35 TO 19,79 SHAD TITLE 'รายงานผู้ป่วยนอกส่ง สปสช.' COLO gr+/b
ACTI WIND rp_NHSO
@ 1,4 SAY 'ต้องการใส่รายงานไว้ในไดร์ฟไหน  '
@ 2,10 PROMPT 'A:'
@ 3,10 PROMPT 'B:'
@ 4,10 PROMPT 'C:'
MENU TO mdrive
?? CHR(7)
IF mdrive=0
	WAIT WIND 'ยกเลิกการส่งรายงานไป สปสช. ตามต้องการ' NOWA
ELSE
	drive = IIF(mdrive = 1,'A:\',IIF(mdrive = 2,'B:\','C:\'))
	mfile=drive+'readme.opd'
	WAIT WIND 'รายงานจะถูกเก็บไว้ในไดร์ฟ '+drive+' กดปุ่มอะไรก็ได้'
	fhandle=FCREATE(mfile)
	errmsg=''
	IF NoError(fhandle,errmsg)
		=FCLOSE(fhandle)
		@ 5,2 SAY 'ต้องการส่งรายงานเดือนไหน mm/yy ' GET mmyy DEFA '    ';
		PICT '@R 99/99' COLO gr+/b
		@ 6,2 SAY 'ใส่จำนวนเตียงทั้งหมดในปัจจุบัน' GET mbed defa '    ';
		pict '@R 9999' colo gr+/b
		READ NOLOCK
		mm=LEFT(mmyy,2)
		IF LASTKEY()=27 .OR. mm<'01' .OR. mm>'12'
			DEAC WIND ALL
			WAIT 'ยกเลิกการทำรายงาน' WIND NOWA
			RETU
		ENDI
		yy=RIGHT(mmyy,2)
		yymm=yy+mm
		recal = 'Y'
		IF ! FILE(opddir+'came'+yymm+'.dbf')
			?? CHR(7)
			WAIT WIND 'ไม่มีแฟ้มผู้ป่วยเดือน'+month&mm+' ปี '+yy NOWA
		ELSE
			IF FILE(opddir+'report\op'+yymm+'.zip')
				DEFINE WIND askgo FROM 10,20 TO 15,60 SHAD
				ACTI WIND askgo
				@ 1,3 SAY 'ข้อมูลเดือน'+month&mm+' '+FullYear(yy)+' เคยคำนวณแล้ว'
				@ 2,3 SAY 'ต้องการคำนวณใหม่หรือไม่ ' GET recal DEFA 'N' PICT '!'
				READ NOLOCK
				RELE WIND askgo
			ENDI
			IF recal = 'Y'
				SELE 0
				dbfuse = opddir+'refer&yy'
				USE (opddir+'refer&yy') ALIA refer
				SELE 0
				dbfuse = opddir+'came'+yymm
				USE (opddir+'came'+yymm) ORDER 1 ALIA camefile
				dbfuse = ''
				numrec=RECCOUNT()
				div_num=ROUND((numrec/40)+.5,0)
				DO ShowProgress
				SELE 0
				mdbf=drive+'op'+yymm
				dbfuse = opddir+'report\op'+yymm
				CREATE TABLE (opddir+'report\op'+yymm);
				(HCODE C(5),BED C(4),HN C(9),DATEADM D,DOB D,AGE C(3),AGEDAY C(3),;
				ADMWT N(7,3),SEX C(1),CHANGWAT C(2),PDX C(7),SPDX1 C(7),SPDX2 C(7),;
				SPDX3 C(7),SPDX4 C(7),SPDX5 C(7),SPDX6 C(7),SPDX7 C(7),SPDX8 C(7),;
				SPDX9 C(7),SPDX10 C(7),SPDX11 C(7),SPDX12 C(7),PROC1 C(7),PROC2 C(7),;
				PROC3 C(7),PROC4 C(7),PROC5 C(7),PROC6 C(7),PROC7 C(7),PROC8 C(7),;
				PROC9 C(7),PROC10 C(7),PROC11 C(7),PROC12 C(7),PTTYP C(2),PID C(13),;
				CID C(16),REFER C(5),REFERTYPE C(1),HOSPMAIN C(5),TOTAL N(7,0))
				USE (opddir+'report\op'+yymm) ALIA target
				dbfuse = ''
*			filesize=HEADER()+(RECSIZE()*numrec)+1
				SELE camefile
				SET ORDER TO 0
				GO TOP
				SET RELA TO hn INTO patient2
				SET RELA TO hn INTO contact ADDI
				SCAN FOR ! EMPTY(camefile.hn) .AND. ! EMPTY(camefile.sequence)
					@ 3,3 SAY SPACE((ROUND(recno('camefile')/div_num+.5,0))) COLO gr/r
					IF sequence=1
						numdiag=1
						SELE target
						SCAT MEMV BLANK
						SELE contact
						SCAT MEMV
						SELE patient1
							seek camefile.hn
						SCAT MEMV
							m.pid=m.person_id
							m.dob=m.birthday
						if !used('insure')
						dbfuse = patientdir + 'insure'
						= OPENDBF(dbfuse,'','hncl')
						dbfuse = ''
						endif
							SELE insure
							seek camefile.hn
						SCAT MEMV
							mcid=m.cid
							mhospmain=m.hospmain
						if !used('social')
							dbfuse = patientdir + 'social'
							USE (patientdir + 'social') ORDER 1 IN 0
						ENDI
						SELE social
							= seek(camefile.fc,'social')
						SCAT MEMV

						SELE patient2
						SCAT MEMV
						searchday=DTOC(camefile.date)
						searchday=SUBS(searchday,4,2)+LEFT(searchday,2)
						IF camefile.rem_c='4'
							SELE refer
							LOCA FOR hn=camefile.hn .AND. day=searchday
							m.refer=place
							m.refertype=type
						ENDI
						IF camefile.result='54'
							SELE refer
							LOCA FOR hn=camefile.hn  .AND. type='2' .AND. ;
							day=searchday
							m.refer=place
							m.refertype=type
						ENDI
						if !used('rcopd')
						dbfuse = billdir + 'opd\rcopd'
						= OPENDBF(dbfuse,'','hn')
						dbfuse = ''
						endif
						SELE rcopd
						LOCA FOR hn=camefile.hn .AND. date=camefile.date
							m.total= total

						SELE camefile
						SCAT MEMV
					 	m.onset=date-ill_date
					 	IF EMPTY(m.changwat)
					 		m.changwat=IIF(m.province='1',hosp_province ,m.changwat)
					 	ENDI
					 	m.hcode=hosp_code
					 	m.bed = mbed
					 	if m.diag = "*"
					 		m.proc1 = m.diag
					 	else
					 	   m.pdx=m.diag
					 	endif
					 	m.prox1=iif(m.episode='',m.diag,m.diag)
					 	m.episode1=m.episode
						m.pttyp=social.pttyp
						m.dateadm=m.date
						if camefile.age_type = "1"
							m.age = alltrim(str(camefile.age))
						endif
						if camefile.age_type = "2"
							m.age = alltrim(str(camefile.age))
						endif
						if camefile.age_type = "3"
							m.age = space(0)
							m.ageday = alltrim(str(camefile.age))
						endif
						m.cid=mcid
						m.hospmain = mhospmain
						INSERT INTO target FROM MEMV
						FLUSH
					ELSE
						SELE target
						dd1=val(STR(camefile.sequence,1))-1
						dd=ltrim(str(dd1))
						if camefile.diag = "*"
							REPL proc&dd WITH camefile.diag
						FLUSH
						else
							REPL spdx&dd WITH camefile.diag
						FLUSH
						endif
					ENDI
					SELE camefile
				ENDS
				FLUSH
				USE
				SELE target
				USE
				SELE refer
				USE
			ENDI
			DEFINE WIND comment FROM 7,10 TO 12,70 SHAD ;
			TITLE 'ข้อความฝากถึงส่วนกลาง' COLO r+/w
			ACTI WIND comment
			ON KEY LABEL ENTER KEYB "{TAB}"
			@ 1,4 EDIT m.comment DEFA '' SIZE 3,50
			READ NOLOCK
			ON KEY LABEL ENTER
			?? CHR(7)
			WAIT WIND 'โปรดคอย กำลังเก็บข้อมูลใส่ไว้ในแผ่นดิสต์ในช่อง ';
			+drive NOWA
*			tofile = opddir+'report\op'+yymm
			tofile = opddir+'report\O' + yymm + LEFT(hosp_code,3) + '.' + RIGHT(hosp_code,2)
			IF recal = 'Y'
				ACTI SCREE
				zipfile = opddir+'report\op'+yymm+'.dbf'
				exefile = patientdir+'PKZIP'
				RUN &exefile -m &tofile &zipfile
				CLEA
			ENDI
			IF ! FILE(tofile)
				=ALARM1()
				WAIT WIND 'ไม่สามารถสร้าง ZIP ไฟล์ได้ กดปุ่มอะไรก็ได้เพื่อยกเลิกการส่งข้อมูล'
				RELE WIND comment
				RELE WIND progress
				RETU
			ENDI
			DIME tfile[5]
			=ADIR(tfile,opddir+'report\O'+yymm+ LEFT(hosp_code,3) + '.' + RIGHT(hosp_code,2))
			olddrive=SYS(5)
			SET DEFA TO &drive
			freespace=DISKSPACE()
			samefile = 0
			IF FILE(drive+'O'+yymm+ LEFT(hosp_code,3) + '.' + RIGHT(hosp_code,2))
				DIME pfile[5]
				=ADIR(pfile,drive+'O'+yymm+ LEFT(hosp_code,3) + '.' + RIGHT(hosp_code,2))
				samefile = pfile[2]
			ENDI
			DO WHIL freespace<=tfile[2]+4000-samefile
				?? CHR(7)
				WAIT WIND 'เนื้อที่ว่างในไดร์ฟ '+drive+' มีไม่พอ'
				freespace = DISKSPACE()
			ENDD
			SET DEFA TO &olddrive
			IF LASTKEY() # 27
				DIME rp_file(5)
				=ADIR(rp_file,opddir+'report\O'+yymm+ LEFT(hosp_code,3) + '.' + RIGHT(hosp_code,2))
				filelen=LTRIM(STR(rp_file(2)))
				filedate=CE2CBE(rp_file(3))
				fhandle=FCREATE(mfile)
				=FWRITE(fhandle,'HP: ')
				=FPUTS(fhandle,hosp_name)
				=FWRITE(fhandle,'HC: ')
				=FPUTS(fhandle,hosp_code)
				=FPUTS(fhandle,'VL: OPD')
				=FWRITE(fhandle,'RD: ')
				=FPUTS(fhandle,DTOC(date()))
				=FPUTS(fhandle,'CT: 01,'+'O'+yymm+ LEFT(hosp_code,3) + '.' + RIGHT(hosp_code,2)+','+filedate+','+filelen)
				=FWRITE(fhandle,'CM: ')
				=FPUTS(fhandle,m.comment)
				SELE doctor
				COPY TO (drive+'doctor')
				SELE clinic
				COPY TO (drive+'clinic')
				tofile = drive+'O'+yymm+ LEFT(hosp_code,3) + '.' + RIGHT(hosp_code,2)
				fromfile = opddir+'report\O'+yymm+ LEFT(hosp_code,3) + '.' + RIGHT(hosp_code,2)
				COPY FILE (fromfile) TO (tofile)
			ELSE
				?? CHR(7)
				WAIT WIND NOWA 'ไม่ได้เก็บข้อมูลไว้ในไดร์ฟ '+drive
			ENDI
			RELE WIND comment
			RELE WIND progress
		ENDI
		=FCLOSE(fhandle)
	ELSE
		?? CHR(7)
		WAIT WIND 'ไม่สามารถสร้างแฟ้มได้เนื่องจาก'+errmsg NOWA
	ENDI
ENDI
RELE WIND rp_NHSO
ACTI SCREE
@ 24,0
KEYB '!'


FUNC NoError
PARA _handle,reason
_ret=.T.
IF _handle < 0                &&Error generated creating file
   	DO CASE 						     && Determine which error
			CASE FERROR() = 4
				reason = 'เปิดแฟ้มมากเกินไป ไม่สามารถทำได้'
			CASE FERROR() = 5
 				reason = 'ไม่สามารถอ่าน-เขียนได้'
 			CASE FERROR() = 8
 				reason = 'ความจำไม่เพียงพอ'
			CASE FERROR() = 29
				reason = 'ไม่มีที่ว่าง'
	    CASE FERROR() = 31
	    		reason = 'มีข้อผิดพลาดทั่ว ๆ ไป'
	 	ENDCASE
	_ret=.F.
ENDI
RETURN _ret

PROC INSTALLAGE
PUSH KEY
ON KEY LABEL F2 DO Saveage WITH '.age','age*'
ON KEY LABEL F3 DO Restoreage WITH '.age','age*'
DEFINE WIND installage FROM 3,15 TO 20,75 SHAD TITLE '  กำหนดกลุ่มอายุ  ';
FOOT '  [Esc]=เรียบร้อย  [F2]=เก็บข้อมูล  [F3]=เรียกข้อมูล  '
ACTI WIND installage
@ 0,0 SAY ' กลุ่มที่  ตั้งแต่อายุ  ถึงอายุ  ข้อความที่แสดง'
DO Editage
ACTI SCREE
@ 24,0
agecount=ASCAN(agemintype,' ')
agecount=IIF(agecount = 0,ALEN(agemintype),agecount-1)
IF ! FILE('default.age')
	SAVE ALL LIKE age* TO default.age
ENDI
RELE WIND installage
POP KEY

PROC RESTOREAGE
PARA _ext,_wild
DIME filefound[1,1]
PUSH KEY CLEA
wildcard = '*'+_ext
IF ADIR(filefound,wildcard)>0
	FOR i = 1 TO ALEN(filefound) STEP 5
		filefound[i] = LEFT(filefound[i],AT('.',filefound[i])-1)
	ENDF
	choosefile = 1
	DEFINE WIND choosefile FROM  3,4 TO 13,18 SHAD TITLE '  เลือก  '
	ACTI WIND choosefile
	@ 1,1 GET choosefile FROM filefound && SIZE 8,11
*	KEYB '{HOME} '
	READ NOLOCK
	RELE WIND choosefile
	IF ! EMPTY(choosefile)
		choosefile = filefound[choosefile+(4*(choosefile-1))]
		REST FROM (choosefile+_ext) ADDI
		SHOW GETS
	ENDI
ENDI
POP KEY

PROC SAVEAGE
PARA _ext,_wild
DEFINE WIND Asksave FROM 10,20 TO 15,65 SHAD
PUSH KEY CLEA
ACTI WIND asksave
CLEA
overwrite = 'Y'
@ 1,3 SAY 'ต้องการเก็บค่าไว้ในแฟ้มชื่อ ' GET filename DEFA SPACE(8)
READ NOLOCK
IF FILE(filename+_ext)
	?? CHR(7)
	overwrite = 'N'
	@ 2,3 SAY 'มีแฟ้มชื่อ '+TRIM(filename)+' อยู่แล้ว'
	@ 3,3 SAY 'ต้องการเขียนทับหรือไม่ ' GET overwrite PICT '!'
	READ NOLOCK
ENDI
IF overwrite $ 'ัํY' .AND. ! EMPTY(filename)
	IF UPPE(_wild) = 'AGE*'
		agecount=ASCAN(agemintype,' ')
		agecount=IIF(agecount = 0,ALEN(agemintype),agecount-1)
	ELSE
		diagcount = ASCAN(diagmin,'  ')
		diagcount = IIF(diagcount = 0, ALEN(diagmin), diagcount-1)
	ENDI
	SAVE ALL LIKE (_wild) TO (filename+_ext)
ENDI
RELE WIND asksave
POP KEY

PROC EDITAGE
FOR in = 1 TO 14
	@ in+1,2 SAY STR(in,2)+'.'
	@ in+1,12 GET agemintype(in)  PICT '#' MESS '1 = ปี  2 = เดือน  3 = วัน ' VALID Checkat()
	@ in+1,14 GET agemin(in) PICT '##'
	@ in+1,24 GET agemaxtype(in) PICT '#' MESS '1 = ปี  2 = เดือน  3 = วัน ' VALID Checkat()
	@ in+1,26 GET agemax(in) PICT '##'
	@ in+1,34 GET agecoded(in)
NEXT
READ NOLOCK CYCLE

PROC INSTALLDIAG
PUSH KEY
ON KEY LABEL F2 DO Saveage WITH '.dx','diag*'
ON KEY LABEL F3 DO Restoreage WITH '.dx','diag*'
DEFINE WIND installage FROM 3,15 TO 20,75 SHAD TITLE '  กำหนดกลุ่มโรค  ';
FOOT '  [Esc]=เรียบร้อย  [F2]=เก็บข้อมูล  [F3]=เรียกข้อมูล  '
ACTI WIND installage
@ 0,0 SAY ' กลุ่มที่  ตั้งแต่รหัส  ถึงรหัส  ข้อความที่แสดง'
FOR in = 1 TO 14
	@ in+1,2 SAY STR(in,2)+'.'
	@ in+1,12 GET diagmin(in) PICT '@!'
	@ in+1,24 GET diagmax(in) PICT '@!'
	@ in+1,34 GET diagcoded(in)
NEXT
READ NOLOCK CYCLE
ACTI SCREE
@24,0
diagcount=ASCAN(diagmin,' ')
diagcount=IIF(diagcount = 0,ALEN(diagmin),diagcount-1)
IF ! FILE('default.dx')
	SAVE ALL LIKE diag* TO default.dx
ENDI
RELE WIND installage
POP KEY

FUNC CHECKAT
xxx=VARREAD()
IF ! &xxx $ ' 123'
	?? CHR(7)
	WAIT WIND '1 = ปี  2 = เดือน  3 = วัน ' NOWA
	_CUROBJ=_CUROBJ
ENDI
