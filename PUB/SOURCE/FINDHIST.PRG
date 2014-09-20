PRIV m.name
DEAC WIND rp_menu
DO CLEArSCREE
STOR SPACE(36) TO m.name
@ 5,10 SAY 'ต้องการค้นหา ' GET m.name
READ NOLOCK
new_one = .T.
IF LASTKEY() # 27 .AND. ! EMPTY(m.name)
	lenname = LEN(TRIM(m.name))
	mat = AT(' ',m.name)
	DO WHIL mat < lenname .AND. SUBS(m.name,mat,2) = '  '
		m.name = LEFT(m.name,mat)+SUBS(m.name,mat+2)+' '
		lenname = LEN(TRIM(m.name))
		mat = AT(' ',m.name)
	ENDD
	IF ISDIGIT(m.name)
		SELE patient1
		SET ORDER TO 1
		mhn=PADZERO(TRIM(m.name),7)
		IF ! SEEK(mhn)
			=Alarm1()
			WAIT WIND NOWA 'ไม่มีผู้ป่วยเลขประจำตัว '+mhn
		ELSE
			DO ShowHist
		ENDI
	ELSE
		DO chec_new WITH m.name,new_one
		IF ! new_one
			DO ShowHist
		ENDI
	ENDI
ENDI
DO CLEARSCREEN

PROC SHOWHIST
PRIV startdate,enddate
SELE patient1
m.hn = hn
m.name = DE_NAME(name)
@ 5,10 SAY 'ต้องการค้นหา ' GET m.name DISA
STOR SPACE(4) TO startdate
enddate = CE2BE(DATE(),2)
enddate = SUBS(enddate,4,2)+RIGHT(enddate,2)
@ 7,10 SAY 'ค้นหาตั้งแต่เดือน/ปี  ' GET startdate PICT '@R ##/##' VALID CheckDateFind(startdate)
@ 9,10 SAY 'ค้นหาถึงเดือน/ปี     ' GET enddate PICT '@R ##/##' VALID CheckDateFind(startdate)
READ NOLOCK
IF LASTKEY() # 27
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
	header = 'ประวัติการตรวจของ '+m.name
	ON PAGE AT line _plength-2 DO findhistheader WITH .T.,header
	KEYB ' '
	WAIT WIND NOWA 'โปรดคอยอีกสักครู่ กำลังจัดทำรายงานอยู่'
	startdate = RIGHT(startdate,2)+LEFT(startdate,2)
	enddate = RIGHT(enddate,2)+LEFT(enddate,2)
	IF startdate > enddate
		=SWAP(startdate,enddate)
	ENDI
	finddate = startdate
	err_mth = ''
	x=1
	now_date = date()
	STOR SPAC(4) TO now_clinic,now_time
	PRINTJOB
		DO findhistheader WITH .F.,header
		SELE 0
		DO WHIL finddate <= enddate
			IF FILE(opddir+'came'+finddate+'.dbf')
				dbfuse = opddir+'came'+finddate
				USE (opddir+'came'+finddate) ORDER 1 ALIA findhist
				dbfuse = ''
				IF SEEK(m.hn)
					DO PrintTOP
					SELE findhist
					DO WHIL hn = m.hn
						IF date=now_date .AND. clinic=now_clinic .AND. t_in=now_time
							IF LEFT(diag,1)='*' .OR. ISDIGIT(diag)
								mseek=IIF(ISDIGIT(diag),diag,SUBS(diag,2))
								mf1='icdcm1'
							ELSE
								mseek=diag
								mf1='icd101'
							ENDI
							IF LEFT(diag,1)='#'
								IF ! USED('shorticd')
									dbfuse = patientdir+'shorticd'
									USE (patientdir+'shorticd') IN 0
									dbfuse = ''
								ENDI
								SELE shorticd
								SET ORDER TO TAG code
							ELSE
								SELE (mf1)
							ENDI
							SEEK mseek
							? TRANSFORM(x,'999999')+'. '+LEFT(desc,60)
							x=x+1
							SELE findhist
							SKIP
						ELSE
							DO PrintTOP
							SELE findhist
						ENDI
					ENDD
				ENDI
			ELSE
				err=TMONTH(VAL(RIGHT(finddate,2)))+' '+FULLYEAR(LEFT(finddate,2))
				err_mth =err_mth+' '+err+','
			ENDI
			finddate = IIF(RIGHT(finddate,2)='12', ;
			STRZERO(VAL(LEFT(finddate,2))+1,2)+'01', ;
			LEFT(finddate,2)+STRZERO(VAL(RIGHT(finddate,2))+1,2))
		ENDD
		?
		? REPL('-',78)
		?
		? 'หมายเหตุ'
		? SPACE(10)+'ตั้งแต่เดือน '+TMONTH(VAL(RIGHT(startdate,2)))+' '+;
		FULLYEAR(LEFT(startdate,2))+' ถึงเดือน '+;
		TMONTH(VAL(RIGHT(enddate,2)))+' '+FULLYEAR(LEFT(enddate,2))
		IF ! EMPTY(err_mth)
			? SPACE(10)+'ไม่พบแฟ้มข้อมูลเดือน' + LEFT(err_mth,LEN(err_mth)-1)
		ENDI
		?
	ENDPRINTJOB
	mkeylabel=ON('KEY','F1')
	ON KEY LABEL F1 DO helpbrow
	DO Endprint WITH '  รายงานประวัติผู้ป่วย  ',reportfile
	ON KEY LABEL F1 &mkeylabel
	DELE FILE &reportfile
	SELE findhist
	USE
ENDI

FUNC CHECKDATEFIND
PARA _date
IF ! BETWEEN(LEFT(_date,2),'01','12')
	=ALARM1()
	WAIT WIND NOWA 'คุณใส่เดือนไม่ถูก กรุณาใส่ใหม่'
	_CUROBJ = _CUROBJ
ENDI

PROC FINDHISTHEADER
PARA _foreject,_header
PRIVATE mprint,mhosp
mhosp=TRIM(hosp_name)
*mtime1='ตั้งแต่วันที่ '+CE2CBE(startdate)+' ถึง วันที่ '+CE2CBE(enddate)
IF _foreject
	eject page
	eject
ENDI
mpagep='หน้าที่ '+LTRIM(STR(_pageno))
? mpagep AT 60
spacecol=CENTER(_header)
?SPACE(spacecol)+_header
?SPAC(CENTER(mhosp))+mhosp
?
IF _foreject
	?
ENDI

PROC PRINTTOP
now_date = date
now_clinic = clinic
now_time = t_in
m.doctor = doctor
m.result = result
?
? REPL('-',78)
?
? 'วันที่มาตรวจ  ' + CE2CBE(date)+' เวลา '+STRZERO(INT(t_in/60),2)+':'+;
STRZERO(MOD(t_in,60),2)+' น.'
SELE clinic
SEEK findhist.clinic
?? 'คลีนิคที่ตรวจ ' + TRIM(name) AT 50
SELE doctor
SEEK findhist.doctor
? 'แพทย์ผู้ตรวจ  ' + TRIM(name)
x=1
DO CASE
	CASE m.result = '01'
		mresult = 'รับไว้แผนกอายุรกรรม'
	CASE m.result = '02'
		mresult = 'รับไว้แผนกศัลยกรรม'
	CASE m.result = '03'
		mresult = 'รับไว้แผนกสูติกรรม '
	CASE m.result = '04'
		mresult = 'รับไว้แผนกนรีเวชกรรม'
	CASE m.result = '05'
		mresult = 'รับไว้แผนกกุมารเวชก'
	CASE m.result = '06'
		mresult = 'รับไว้แผนกหู คอ จมูก'
	CASE m.result = '07'
		mresult = 'รับไว้แผนกจักษุ    '
	CASE m.result = '08'
		mresult = 'รับไว้แผนกศัลยกรรมกระดูก'
	CASE m.result = '09'
		mresult = 'รับไว้แผนกจิตเวช   '
	CASE m.result = '10'
		mresult = 'รับไว้แผนกรังสีวิทยา'
	CASE m.result = '11'
		mresult = 'รับไว้แผนกทันตกรรม '
	CASE m.result = '12'
		mresult = 'รับไว้แผนกอื่น ๆ'
	CASE m.result $ '13,14'
		mresult = 'รับไว้ Observe'
	CASE m.result = '51'
		mresult = 'ตรวจและกลับบ้าน'
	CASE m.result = '52'
		mresult = 'ตายที่โอพีดี'
	CASE m.result = '53'
		mresult = 'ส่งปรึกษาแผนกอื่น'
	CASE m.result = '54'
		mresult = 'Refer'
ENDC
?? 'ผลการรักษา ' + mresult AT 50
? 'การวินิจฉัยโรค'
