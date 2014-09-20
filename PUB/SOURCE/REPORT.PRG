PARA _type,_top
STORE SPACE(4) TO mmyy,mmyy1
Cr0=IIF(_top,'รายงานเรียงตามโรคที่พบบ่อย','รายงานตาม รง.'+_type)
CR1="รายงานรวม"
CR2="รายงานแยกตามสถานบริการ"
@ 8,Center(cr0) SAY cr0 COLO r+
@ 10,20 PROMPT cr1
@ 12,20 PROMPT cr2
CLOSE DATA
SELE 0
IF FILE('NAME&_TYPE..DBF')
	usefile = 'name'+_type 
ELSE
	usefile = 'name'+_type+'p'
ENDI
USE (usefile) IN 0 ALIA name
max_field = RECCOUNT()
MENU TO ask
IF ASK>0
	IF ask = 2
		STOR SPACE(12) TO hcode
		STOR SPACE(30) TO hname
		DO AskHosp WITH hcode,hname		&& สอบถามว่าต้องการลงข้อมูลของสถานพยาบาลไหน
		IF LASTKEY() = 27
			RETU
		ENDI
	ELSE
		hcode=hosp_code
		hname=hosp_name
	ENDI
	@20,0 CLEAR
	@20,9 SAY "ใส่เดือน/ปีเริ่มต้น   " GET mmyy PICT "@R ##/##" ;
	VALID Checkdate(mmyy)
	@22,9 SAY "ใส่เดือน/ปีสิ้นสุด    " GET mmyy1 PICT "@R ##/##" ;
	WHEN Startdate(mmyy,mmyy1) VALID Checkdate(mmyy1)
	READ
	mm=LEFT(mmyy,2)
	yy=RIGHT(mmyy,2)
	mm1=LEFT(mmyy1,2)
	yy1=RIGHT(mmyy1,2)
	IF mm = ' ' .OR. yy = ' ' .OR. mm1 = ' ' .OR. yy1 = ' ' .OR. LASTKEY() = 27
		RETU
	ENDI
	IF yy+mm > yy1 + mm1
		tempmm = mm
		tempyy = yy
		mm = mm1
		yy = yy1
		mm1 = tempmm
		yy1 = tempyy
	ENDI
	DO CalReport
ENDI
RETURN

PROC CALREPORT
mname=ALLTRIM(hname)
annual=IIF(mm='10' .AND. mm1='09' .AND. yy1=STRZERO(VAL(yy)+1,2),.T.,.F.)
many=IIF(yy1+mm1=yy+mm,.F.,.T.)
DEFINE WIND rep2 FROM 10,10 TO 15,70 SHAD
ACTI WIND rep2
goon1='Y'
err_mth = ''
annualfile = FULLYEAR(yy1)
IF annual .AND. (FILE('data\d&_type' + annualfile + '.dbf') .OR. ;
FILE('report\r' + _type + annualfile + '.dbf'))
   =TONE(600,10)
   goon1='N'
   CLEA
   @ 1,5 SAY 'แฟ้มปีงบประมาณ '+FULLYEAR(yy1)+'มีอยู่แล้ว'
   @ 3,6 SAY 'ต้องการคำนวณใหม่หรือไม่  ' GET goon1 PICT '!'
   READ
ENDI
IF goon1='Y'
	CLEA
	IF many
		@ 0,Center('โปรดคอยสักครู่') SAY 'โปรดคอยสักครู่'
      	@ 1,Center('กำลังตรวจสอบแฟ้มข้อมูลอยู่') SAY 'กำลังตรวจสอบแฟ้มข้อมูลอยู่'
      	has_err=.F.                 && ตั้งสมมติฐานว่ามีแฟ้มครบทุกเดือน
      	DO chec_rep WITH _type
      	IF has_err
         	goon='N'
         	?
         	@ ROW(),2 SAY 'ต้องการทำงานต่อไหม  ' GET goon PICT '!'
         	READ
         	IF goon # 'Y'
         		RELE WIND rep2
         		CLEA
            	RETU
         	ENDI
      	ENDI
	ELSE
    	IF ! FILE("data\d&_type&yy&mm..dbf") .AND. ! ;
    	FILE("report\r&_type&yy&mm..dbf")
        	=TONE(600,10)
        	CLEA
			@ 1,2 SAY "ไม่มีแฟ้มข้อมูลรายงาน"+_type+" "+month&mm+' '+Fullyear(yy)
      		mkey=INKEY(30)
      		RELE WIND rep2
      		CLEA
        	RETU
     	ENDI
   	ENDI
   	CLEA
	@ 0,Center('โปรดคอยสักครู่') SAY 'โปรดคอยสักครู่'
	@ 2,Center('กำลังเตรียมข้อมูลทำรายงาน') SAY 'กำลังเตรียมข้อมูลทำรายงาน'
	mmm=mm
	yyy=yy
   	DIME mnum[max_field],in[max_field]
   	STOR 0 to mtotalnum
   	FOR i=1 to max_field
    	STOR 0 to mnum[i]
   	NEXT
   	IF annual .AND. ask = 1 .AND. ! has_err
    	SELE 0
    	datafile = 'data\d'+_type+yy+mm
      	USE (datafile)
      	tocopy = 'data\d'+_type+annualfile
      	COPY TO ('data\d' + _type + annualfile) STRU
      	USE ('data\d' + _type + annualfile) ALIA annual
   	ENDI
   	DO WHIl .T.
    	IF FILE('data\d&_type&yyy&mmm..dbf') .OR. ;
    	FILE('report\r&_type&yyy&mmm..dbf')
    		CLEA
    		msg = 'ข้อมูล'+month&mmm+' '+Fullyear(yyy)
         	@ 1,Center(msg) SAY msg COLO r+
         	IF ask = 1
	         	DO sum2 WITH _type,mmm,yyy,.f.
	         ELSE
	         	DO sum1 WITH _type,mmm,yyy,.F.
	         ENDI
         	FOR i=1 to max_field
            	mnum[i]=mnum[i]+in[i]
            	mtotalnum = mtotalnum + in[i]
         	NEXT
      	ENDI
      	IF yy1+mm1=yyy+mmm
        	EXIT
      	ELSE
        	IF mmm='12'
            	mmm='01'
            	yyy=STRZERO(VAL(yyy)+1,2)
         	ELSE
            	mmm=STRZERO(VAL(mmm)+1,2)
         	ENDI
     	ENDI
   	ENDD
   	totalnum=0
   	FOR i=1 to max_field
    	in[i]=mnum[i]
	  	totalnum=totalnum+mnum[i]
   	NEXT
ELSE
	SELE 0
   	USE ('report\r' + _type + FULLYEAR(yy1) )
   	SCAT TO in
   	=ADEL(in,1)
   	=ADEL(in,1)
   	totalnum=0
   	FOR i=1 to max_field
      	totalnum=totalnum+in[i]
   	NEXT
   	USE
ENDI
RELE WIND rep2
header=IIF(_type='504','รายงานผู้ป่วยนอกตามกลุ่มสาเหตุ (กลุ่มโรค) ',;
'รายงานผู้ป่วยในตามกลุ่มโรค ')
IF ! many
   DO rep_data  WITH 'บันทึกแบบ รง.'+_TYPE,header+'ประจำเดือน'+month&mm+' '+FULLYEAR(yy)
ELSE
   IF annual .AND. ask = 1 
   		IF goon1= 'Y' .AND. ! has_err
   	  		SELE annual
      		DO CreateRB WITH _type,RIGHT(annualfile,2),LEFT(annualfile,2),max_field
      		USE ('report\r' + _type + annualfile) ALIA report1
      		DIME in[ALEN(in)+2]
      		=AINS(in,1)
      		=AINS(in,1)
      		STOR hosp_code TO in[1]
      		STOR FULLYEAR(yy1) TO in[2]
      		INSERT INTO report1 FROM array in
      		=ADEL(in,1)
      		=ADEL(in,1)
      		USE
      	ENDI
      saymonth = 'ประจำปีงบประมาณ ' + FullYear(yy1)
  ELSE
	  saymonth = 'ตั้งแต่เดือน'+month&mm+' '+Fullyear(yy)+' ถึงเดือน'+;
	  month&mm1+' '+Fullyear(yy1)
   ENDI
   DO rep_data WITH 'บันทึกแบบ รง.'+_TYPE,header+saymonth
ENDI

PROC SUM1
* _FILE  เป็น Character บอกว่าเป็น '504' หรือ '505'
* _MM    เป็นเดือนที่จะหาค่า
* _YY    เป็นปีที่จะหาค่า
PARA _FILE,_MM,_YY,_report
SELE 0
USE data\d&_file&_yy&_mm
LOCA FOR hosp=hcode
SCAT TO in
=ADEL(in,1)

PROC SUM2
* _FILE  เป็น Character บอกว่าเป็น '504' หรือ '505'
* _MM    เป็นเดือนที่จะหาค่า
* _YY    เป็นปีที่จะหาค่า
* _report เป็นตัวบอกว่าถูกเรียกจากโปรแกรม report หรือไม่
PARA _FILE,_MM,_YY,_report
USE data\d&_file&_yy&_mm IN 0 ALIA data
SELE data
FOR n=1 TO max_field
   stor 0 to in[n]
NEXT
DO WHIL ! EOF()
   n=1
   CLEA
	@ 1,1 SAY 'คำนวณข้อมูล'+month&_mm+' '+FULLYEAR(_yy)
   FOR N =1 TO max_field
      x=LTRIM(STR(n))
      in[n]=in[n]+case&x
   NEXT
   SKIP
ENDD
DO CreateRb WITH _file,_mm,_yy,max_field
USE report\r&_file&_yy&_mm IN 0 ALIA report
DIME in[ALEN(in)+2]
=AINS(in,1)
=AINS(in,1)
STOR hosp_code TO in[1]
STOR _yy+_mm TO in[2]
INSERT INTO report FROM ARRAY in
IF annual .AND. ask = 1 .AND. ! has_err
   	SELE data
   	GO TOP
   	DO WHIL ! EOF()
   		SCAT MEMV
    	SELE annual
      	LOCA FOR hosp=data->hosp
      IF ! FOUND()
      	INSERT INTO annual FROM MEMVAR
      ELSE
      	GATH MEMV
      ENDI
      SELE data
      SKIP
   ENDD
ENDI
=ADEL(in,1)
=ADEL(in,1)
SELE data
USE
SELE report
USE

PROC CHEC_REP
PARA _file
mmm=mm
yyy=yy
mmm1=mm1
yyy1=yy1
*err_line=14
*DEFINE WIND err_check FROM 1,60 TO 5,78 SHAD
*ACTI WIND err_check
DO WHIL .T.
   IF ! FILE('data\d&_file&yyy&mmm..dbf')
		=TONE(400,4)
      ? 'ไม่พบแฟ้มเดือน'+month&mmm+' '+FULLYEAR(yyy)
      has_err=.T.               && ตรวจพบว่ามีแฟ้มบางเดือนขาดหายไป
      err_mth = err_mth + month&mmm+' '+FullYear(yyy) + ','
      =INKEY(.5)
   ENDI
   IF mmm=mmm1 .and. yyy=yyy1
      EXIT
   ELSE
      IF mmm='12'
         mmm='01'
         yyy=strzero(VAL(yyy)+1,2)
         ELSE
         mmm=strzero(VAL(mmm)+1,2)
      ENDI
   ENDI
ENDD
IF  has_err
	err_mth = LEFT(err_mth,LEN(err_mth)-1)
ENDI
*RELE WIND err_check

PROC REP_DATA
* _form  เป็น CHARACTER แสดงข้อความหัวเรื่อง
* _type  เป็น CHARACTER เพื่อบอกว่าเป็น 504 หรือ 505
* _one   เป็น LOGIC ถ้า .T. หมายถึงข้อมูลเดือนเดียว .F. ข้อมูลหลายเดือน
PARA _form,_header
SELE name
GO TOP
DIME name[max_field]
IF _top
	DIME temp[max_field,2]
	FOR i = 1 TO max_field
		STOR in[i] TO temp[i,1]
		STOR STR(i,3)+'.'+LEFT(desc,54) TO temp[i,2]
		SKIP
	NEXT
	=ASORT(temp,1,-1,1)
	FOR i = 1 TO max_field
		STOR temp[i,1] TO in[i]
		STOR temp[i,2] TO name[i]
	NEXT
ELSE
	FOR i = 1 TO max_field
		STOR LEFT(desc,58) TO name[i]
		SKIP
	NEXT
ENDI
reportfile=SYS(3)+'.txt'
SET PRINT TO &reportfile
SET PRINT ON
SET CONS OFF
_wrap=.F.
_plength=34
_peject='NONE'
_pageno=1
_plineno=0
_PLOFFSET = 0
ON PAGE AT line _plength-2 DO rbheader WITH .T.
CLEA
shwmsg = 'โปรดคอย กำลังพิมพ์รายงานอยู่'
@ 3,Center(shwmsg) SAY shwmsg

PRINTJOB
	mhosp=TRIM(hname)
	IF USED('address')
		SELE address
		SET ORDER TO 1
	ELSE
		SELE 0
		USE address ORDER 1
	ENDI
	mchangwat='1'+SUBS(hcode,5,2)
	mampur = '2'+SUBS(hcode,5,4)
	mampur = IIF(RIGHT(mampur,2)='00',LEFT(mampur,3)+'01',mampur)
	SEEK mchangwat
	changwatname = ALLTRIM(name)
	SEEK mampur
	ampurname = ALLTRIM(name)
	USE
	SELE name
	GO TOP
	mpagep='- '+LTRIM(STR(_pageno))+' -'
	?SPACE(60)+_form
	?_header+IIF(_top,' เรียงตามที่พบบ่อย','')
	?'ชื่อหน่วยงาน '+mhosp+' '+'อำเภอ '+ampurname+' จังหวัด '+changwatname
	?'ชื่อผู้รายงาน ................................ ตำแหน่ง .......................'
	?'วันเดือนปีที่รายงาน  ' + CE2CBE(DATE())
	DO rbheader WITH .F.
 
	? SPACE(49),'รวมทั้งหมด    ',TRANSFORM(totalnum,'999,999,999')
	FOR i = 1 TO max_field
		? STR(i,3),name[i],' ',TRANSFORM(in[i],'999,999,999')
		SKIP
	NEXT
	?
	IF ! EMPTY(err_mth)
		? 'หมายเหตุ   ไม่พบแฟ้มเดือน' + err_mth
		?
	ENDI
ENDPRINTJOB
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpbrow
DO Endprint WITH '  รายงานโรค 504  ',reportfile
ON KEY LABEL F1 &mkeylabel
DELE FILE &reportfile
CLOSE DATA

PROC rbheader
PARA _foreject,_header
PRIVATE mprint,mhosp
IF _foreject
	eject page
	eject
	mpagep='- '+LTRIM(STR(_pageno))+' -'
	?SPACE(37)+mpagep
?
ENDI
?'..............................................................................'
?' ลำดับที่            สาเหตุการป่วย (กลุ่มโรค)                          จำนวน '
?'..............................................................................'

IF _foreject
	?
ENDI

FUNC STARTDATE
PARA _sdate,_edate
_edate = IIF(EMPTY(_edate) .OR. RIGHT(_edate,2)+LEFT(_edate,2) < ;
RIGHT(_sdate,2)+LEFT(_sdate,2),_sdate,_edate)