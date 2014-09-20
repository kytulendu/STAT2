***************************
PROC RP_IPD
***************************
*mtime1 = '0700'
*mtime2 = '1459'
*mtime3 = '1500'
*mtime4 = '2259'
*mtime5 = '2300'
*mtime6 = '2400'
*mtime7 = '0000'
*mtime8 = '0659'

mdate_a = CE2BE(DATE())

DIME repipd(8)
repipd(1)=padr('ยอดผู้ป่วยในเวรเช้า',20,' ')
repipd(2)=padr('ยอดผู้ป่วยในเวรบ่าย',20,' ')
repipd(3)=padr('ยอดผู้ป่วยในเวรดึก',20,' ')
repipd(4)=padr('รายงานยอดผู้ป่วยใน',20,' ')
repipd(5)=padr('ใบสรุป 501',20,' ')
repipd(6)=padr('ใบสรุป 502',20,' ')
repipd(7)=padr('ใบสรุป 503',20,' ')
repipd(8)=padr('เมนูเดิม',20,' ')

DEFINE WIND help_rep FROM 4,5 TO 4+ALEN(repipd)+3,32 SHAD COLO gr+/w TITLE 'พิมพ์ / รายงาน'
DO WHIL .T.
	ACTI WIND help_rep
	FOR i=1 TO ALEN(repipd)
		@ i,3 PROMPT repipd(i)
	NEXT
	MENU TO Ch_rep
	ACTI SCREE
	DO CASE
		CASE Ch_rep = 1
	   		DO morn_ipd WITH 1
			DO CLEARSCR
		CASE Ch_rep = 2
	   		DO morn_ipd WITH 2
			DO CLEARSCR
		CASE Ch_rep = 3
	   		DO morn_ipd WITH 3
			DO CLEARSCR
		CASE Ch_rep = 4
	        DO nurseipd  
		CASE Ch_rep = 5
			DEAC WIND help_rep
			nreport='RP501'
		    DO Rp_Menu with nreport
		CASE Ch_rep = 6
			DEAC WIND help_rep
			nreport='RP502'
			DO Rp_Menu with nreport
		CASE Ch_rep = 7
			DEAC WIND help_rep
			nreport='RP503'
			DO Rp_Menu with nreport
		CASE Ch_rep = 8
			RELE WIND help_rep
			DO CLEARSCR
			RETURN 
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_rep
*SET COLO TO bg+/b

*************
PROC MORN_IPD
*************
PARA _step
DEAC WIND help_rep
DO CASE
	CASE _step = 1
		STOR mtime1 TO times,times1 
		STOR mtime2 TO timee,timee1
		titlea = 'เวรเช้า'
	CASE _step = 2
		STOR mtime3 TO times,times1 
		STOR mtime4 TO timee,timee1
		titlea = 'เวรบ่าย'
	CASE _step = 3
		times = mtime5
		timee = mtime6
		times1 = mtime7
		timee1 = mtime8
		titlea = 'เวรดึก'
ENDC
SELE IPTRANA
SET ORDER TO TAG DATEADM

@ 0,0 clear to 1,78
DO CLEARSCR

@ 11,2 say 'วันที่รับไว้ในโรงพยาบาล'
@ 11,28 get mdate_a  PICT '99/99/9999' VALID TRUEDATE(mdate_a) ;
 		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
	READ NOLOCK

MDATEADM=BE2CE(mdate_a)
SELE patient1
SET ORDER TO TAG hn
SELE IPTRANA
SET ORDER TO TAG dateadm
SET RELA TO hn INTO patient1
IF ! SEEK(MDATEADM)
	?? CHR(7)
	showdate = CE2CBE(mdateadm)
	WAIT WIND 'ไม่มีคนไข้รับไว้ในวันที่ ' + showdate NOWA
ELSE
	reportfile=tempdir+SYS(3)+'.txt'
	reportdbf = tempdir+SYS(3)
	SET PRINT TO &reportfile
	SET PRINT ON
	SET CONS OFF
	_wrap=.F.
	_plength=41
	_peject='AFTER'
	_pageno=1
	_plineno=0
	_PLOFFSET = 0
	ON PAGE AT line _plength-2 DO adm_header WITH .T.
	KEYB ' '
	SELE ward
	SET ORDER TO TAG clinic
	SELE iptrana
	COPY TO (reportdbf) STRU
	SELE 0
	dbfuse = reportdbf
	USE (reportdbf) EXCL ALIA tempfile
	INDEX ON an TAG an
	dbfuse = ''
	SELE iptrana
	DO WHIL dateadm = mdateadm
		IF BETWEEN (timeadm,times,timee) .OR. BETWEEN (timeadm,times1,timee1)	
			SCAT TO adm_cen
			INSERT INTO tempfile FROM array adm_cen
			FLUSH
		ENDI
		SKIP
	ENDD
	PRINTJOB
		DO adm_header WITH .F.
		SELE tempfile
		SET RELA TO hn INTO patient1
		SCAN
			SELE ward
			SEEK tempfile.ward_now
			SELE tempfile
			? ' '+hn+'  '+LEFT(DE_NAME(patient1.name),25),' '+IIF(day(dateadm)<10,' ',''),Ce2CBE(dateadm),;
			' '+' '+SUBST(timeadm,1,2)+'.'+SUBST(timeadm,3,2),;
			+' '+SUBST(AN,3,5)+'-'+SUBST(AN,1,2),;
			TRIM(ward.name) AT 70
		ENDS
		?
		? 'จำนวนคนไข้'+titlea+'วันที่ '+CE2CBE(mdateadm)+' มี '+;
		ALLTRIM(STR(RECCOUNT('tempfile')))+' คน'
		?
	ENDPRIN
	SELE tempfile
	USE
	DELE FILE (reportfile+'.dbf')
	DELE FILE (reportfile+'.cdx')
	mkeylabel=ON('KEY','F1')
	ON KEY LABEL F1 DO helpbrow
	ON KEY LABEL PGUP	
	DO Endprint WITH '  รายงานผู้ป่วยในโรงพยาบาล  ',reportfile
	ON KEY LABEL F1 &mkeylabel
	DELE FILE &reportfile
ENDI

***********************

********************************************************************
PROC adm_header
********************************************************************
PARA _foreject
PRIVATE mprint,mhosp
mhosp='รายชื่อผู้ป่วยใน '+TRIM(hosp_name)
IF _foreject
	eject page
	eject
ENDI
mpagep='หน้าที่ '+LTRIM(STR(_pageno))
? REPL('-',90)
?'วันที่ '+CE2CBE(DATE())+SPACE(44) + mpagep
?SPAC(CENTER(mhosp))+mhosp
? REPL('-',90)
?
?'   HN        ชื่อ นามสกุล                วันรับ       เวลา     AN         หอผู้ป่วย'
?
IF _foreject
	?
ENDI
