*****************************************************************
*	โปรแกรมสำหรับค้นหาชื่อผู้ป่วยตามเงื่อนไข                    *
* 	โดยจะมีรายชื่อตัวแปรเป็นภาษาไทยให้เลือก                    *
*	ตัวแปรทั้งหลายจะอยู่ในแฟ้ม ROBE.DBF และ RQBE.FPT			*
*	และสามารถกำหนดเงื่อนไขได้อีก 6 เงื่อนไข โดยตัวแปรเงื่อนไข	*
*	สามารถเลือกได้โดยกดปุ่ม [F1] หรือพิมพ์ตัวแปรเป็นภาษาไทย		*
*	ตามใน LIST													*
*	ไม่ควรเลือกวันที่มาตรวจเป็นเงื่อนไข เพราะสามารถกำหนดได้จาก	*
*	การกำหนดว่าจะหาข้อมูลตั้งแต่วันไหนถึงวันไหนอยู่แล้ว			*
*****************************************************************
PRIV xline,yline,xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,;
yhelp1,yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess
STOR '' TO xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,yhelp1,;
yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess
DIME xcode(1),xcoded(1),ycode(1),ycoded(1),xmin(1),xmax(1),ymin(1),ymax(1)
STOR 0 TO xline,yline
DEAC WIND rp_menu
IF ! USED('StatRQBE')
	SELE 0
	IF FILE('StatRQBE.dbf')
		dbfuse = 'statrqbe'
		USE StatRQBE
	ELSE
		dbfuse = patientdir+'StatRQBE'
		USE (patientdir+'StatRQBE')
	ENDI
ELSE
	SELE StatRQBE
ENDI
dbfuse = ''
numshow = RECCOUNT()
GO TOP
DIME condition[3,2],offer[5,2],condtype[6]
numshow = RECCOUNT()
DIME show(numshow)
DO GetCond WITH 2,1,'O'
	IF LASTKEY() = 27 .OR. EMPTY(mmyy) .OR. EMPTY(mmyy1)
		DEAC WIND all
		RETU
	ENDI
*************************	กำหนดตัวแปรที่จะใช้คำนวณ
startdate = BE2CE(mmyy)
enddate = BE2CE(mmyy1)
startfile=RIGHT(mmyy,2)+SUBS(mmyy,4,2)
endfile=RIGHT(mmyy1,2)+SUBS(mmyy1,4,2)
STOR 0 TO xx,yy
errmonth=''
*SELE patient2
*SELE contact
SELE 0

*********************	เริ่มวนลูปเพื่อคำนวณข้อมูล
EXTERNAL ARRAY Tmonth
tablefile=tempdir+SYS(3)
dbfuse = tablefile
CREA TABLE (tablefile) ('HN' C(7),'NAME' C(35),'FC' C(2),'RESULT' C(2))
INDEX ON hn TAG hn
USE (tablefile) ALIA tablefile ORDER TAG hn
dbfuse = ''
SELE 0
DO WHIL startfile <= endfile
	err=TMONTH(VAL(RIGHT(startfile,2)))+' '+FULLYEAR(LEFT(startfile,2))
	IF ! FILE(opddir+'CAME'+startfile+'.dbf')
		?? CHR(7)
		WAIT WIND 'ไม่พบแฟ้มเดือน'+err NOWAIT
		errmonth = errmonth+' '+err+','
	ELSE
		WAIT WIND 'กำลังคำนวณข้อมูลเดือน' + err NOWAIT
		dbfuse = opddir+'came'+startfile
		USE (opddir+'came'+startfile) ALIA came
		dbfuse = ''
		SET RELA TO hn INTO patient1
		SET RELA TO hn INTO tablefile ADDI
		DO resulthn			&& Module ที่คำนวณข้อมูลแต่ละเดือน
		SELE came
		USE
	ENDI
	IF RIGHT(startfile,2)='12'	&& เพิ่มเดือนทีละหนึ่งเดือน
		startfile=STRZERO(VAL(LEFT(startfile,2))+1,2)+'01'
	ELSE
		startfile=LEFT(startfile,2)+STRZERO(VAL(RIGHT(startfile,2))+1,2)
	ENDI
ENDD

**********************		จัดเรียงข้อมูลตามลำดับ
DEAC WIND ALL
DO ClearScreen
reportfile=tempdir+SYS(3)+'.txt'
SET PRINT TO &reportfile
SET PRINT ON
SET CONS OFF
_wrap=.F.
_plength=41
_peject='NONE'
_pageno=1
_plineno=0
_PLOFFSET = 0
header = 'รายชื่อผู้ป่วยเรียงตามเลขประจำตัว'
ON PAGE AT line _plength-2 DO rqbehnheader WITH .T.,header
KEYB ' '
WAIT WIND NOWA 'โปรดคอยอีกสักครู่ กำลังจัดทำรายงานอยู่'
SELE tablefile
PRINTJOB
	DO rqbehnheader WITH .F.,header
	SCAN
		? hn,'    ',name,'   ',fc,'           ' ,result
	ENDS
	?
	? 'รวมจำนวนคนไข้ทั้งหมด '+ALLTRIM(STR(RECCOUNT()))+' คน'
	? 'หมายเหตุ'
	? SPACE(10)+'ตั้งแต่วันที่ '+CE2CBE(startdate)+' ถึงวันที่ '+CE2CBE(enddate)
	IF condcode # '.T.'
		? SPACE(10)+'โดย ' + condmess
	ENDI
	IF ! EMPTY(errmonth)
		? SPACE(10)+'ไม่พบแฟ้มข้อมูลเดือน' + LEFT(errmonth,LEN(errmonth)-1)
	ENDI
	?
ENDPRINTJOB
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpbrow
DO Endprint WITH '  รายงานแบบตาราง  ',reportfile
ON KEY LABEL F1 &mkeylabel
*CLOSE DATA
DELE FILE &reportfile
SELE tablefile
USE
DELE FILE &tablefile..dbf
DELE FILE &tablefile..cdx
SELE patient1
SET RELA TO hn INTO patient2
SET RELA TO hn INTO contact ADDI

PROC ResultHN
div_num=ROUND((RECCOUNT()/40)+.5,0)
recno = 0
DO ShowProgress
SCAN FOR BETWEEN(date,startdate,enddate)
	recno=recno+1
	@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
	IF &condcode
		SELE tablefile
		IF EOF()
			APPE BLAN
			REPL hn WITH came.hn
		ENDI
		REPL name WITH De_Name(patient1.name),fc WITH came.fc,result ;
		WITH came.result
		SELE came
	ENDI
ENDS
RELE WIND comment

PROC rqbehnheader
PARA _foreject,_header
PRIVATE mprint,mhosp
mhosp=TRIM(hosp_name)
*mtime1='ตั้งแต่วันที่ '+CE2CBE(startdate)+' ถึง วันที่ '+CE2CBE(enddate)
IF _foreject
	eject page
	eject
ENDI
mpagep='หน้าที่ '+LTRIM(STR(_pageno))
spacecol=CENTER(_header)
?SPACE(spacecol)+_header+SPACE(65-spacecol-LEN(_header))+mpagep
?SPAC(CENTER(mhosp))+mhosp
?
?' เลขที่ผู้ป่วยนอก          ชื่อ - นามสกุล      สิทธิการรักษา   ผลการรักษา'
?
IF _foreject
	?
ENDI

