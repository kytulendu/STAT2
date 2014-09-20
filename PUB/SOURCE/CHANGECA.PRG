* ________รายการที่ 2  แก้ไขข้อมูลการตรวจผู้ป่วยนอก __________
#define numdiag  9
@22,0 to 22,80 clea
end_add=.t.
m.found=.F.						&& Flag เพื่อบอกว่าหาเลขที่ผู้ป่วยพบไหม
_printappoint=.F.
DO WHIL .T.
	my=SUBS(DTOC(DATE()),4,2)+STR(YEAR(DATE())+543,2)
   do search_month with my
   mm=LEFT(my,2)
	yy=RIGHT(my,2)
   check_file=opddir+'came&yy&mm'+'.dbf'
 if ! file('&check_file')
   @6,10 say 'ไม่พบ แฟ้ม '+'came&yy&mm'
   wait=inkey(2)
   @6,0 clea
   loop
 else
 	SELE 0
 	dbfuse = opddir+'appoin'+yy
 	USE (opddir+'appoin'+yy) ORDER 1 ALIA nowappoint
    sele 0
    dbfuse = opddir+'refer'+yy
    USE (opddir+'refer'+yy) ALIA refer
    SELE 0
    dbfuse = opddir+'came'+yy+mm
    Use (opddir+'came'+yy+mm) ORDER 1 alia camefile
	newcamefile = .F.
	FOR i = 1 TO FCOUNT()
		IF UPPE(FIELD(i)) = 'DXTYPE'
			newcamefile = .T.
		ENDI
	NEXT
	IF ! newcamefile
		_asksure = 'แฟ้มผู้ป่วยนอกเป็นแบบเก่า ต้องแก้ไข ให้หยุดเครื่ออื่นก่อน'
		nAsksure = 1
		DO asksure.spr
		IF nAsksure = 1
			COPY TO tempfile STRU EXTE
			USE tempfile
			APPE BLANK
			REPL FIELD_NAME WITH 'DXTYPE', field_type WITH 'C', ;
			field_len WITH 1
			CREA backup FROM tempfile
			USE backup
			APPE FROM (dbfuse)
			COPY TO (dbfuse)
			USE (dbfuse) ALIA camefile
			REPL ALL dxtype WITH '1' FOR sequence = 1
			REPL ALL dxtype WITH '2' FOR sequence # 1
			DELE FILE tempfile.dbf
			DELE FILE backup.dbf
			DO Reindex WITH .F.
		ELSE
			RETU TO opd
		ENDI
	ENDI
    SET RELA TO clinic INTO clinic
 endi
 dbfuse = ''
   exit
endd
dimension choice(3)
store '    เลือกแก้ไขข้อมูล จาก HN  ' to choice(1)
store '    เลือกแก้ไขข้อมูล จาก ชื่อคนไข้  ' to choice(2)
store '    เลือกแก้ไขข้อมูล ที่ไม่สมบูรณ์  ' to choice(3)
@3,18 say '   รายการเลือก-สำหรับแก้ไขข้อมูล  '
@5,15 menu choice,3,3
read menu to mchoice
do case
case mchoice = 1
     do case_hn                            &&  search 700
case mchoice = 2
     shn = space(7)
     do case_name             &&  ค้นหา จากชื่อ
CASE mchoice = 3
	DO case_complete
endcase
SELE camefile
USE
SELE refer
USE
SELE nowappoint
USE
return

**********************************************************************
proc case_hn
@3,0 to 16,80 clea
do whil .t.
  @22,0 to 22,80 clea
  @ 24,0
  shn=space(7)
  SELE camefile
  @9,10 say 'พิมพ์เลขที่คนไข้ (HN) ' get shn picture '9999999';
    valid foundhn(shn)
  READ NOLOCK
  IF EMPTY(shn) .OR. shn = '0000000' .OR. LASTKEY() = 27
  	EXIT
  ENDI
 do check_hn
endd
************************
func foundhn
para _shn
if empty(_shn)
  return -2
endi
*sele camefile
_shn=padzero(_shn,7)
SEEK _shn
if ! found()
   ??chr(7)
   WAIT 'ไม่มีข้อมูลผู้ป่วยเลขที่ '+_shn WIND NOWA
   _shn=SPACE(LEN(_shn))
   _curobj=_curobj
endi

************************
proc check_hn
dime b(120),c(120)      && b=เก็บ date+clinic   c=day(date)+clinic
i=1      && วันที่+คลีนิค
SELE camefile
SET RELA TO clinic INTO clinic
SEEK shn
DO WHIL hn=shn .AND. i < 120
	b(i)=CE2CBE(date)+SPAC(6)+clinic->name
	c(i)=STR(DAY(date),2)+clinic
	SKIP
	DO WHIL sequence # 1 .AND. hn=shn
   		SKIP
   	ENDD
   	i = i+1
ENDD
i=IIF(sequence=1 .OR. EOF(),i-1,i)
*@3,59 clea
*@5,1 to 9,80 clea
*@24,0 clea
DO ClearScreen
@5,25 say 'เลือก วันที่      จากคลีนิค'
@7,25 menu b,i,10      && array b
read menu to sele_date
IF LASTKEY() # 27
	@5,1 to 15,80 clea
	flag=.t.
	do check_date with flag
	if flag=.f.
    	return
	endi
	curr_rec=1
	SELE camefile
	SEEK shn+c(sele_date)
	do collect_diag WITH 1
ENDI
DEAC WIND ALL
@4,0 to 20,80 clea
retu

*----------------------
proc check_date                   && CALLED BY PROC CASE_HN
para flag1
wai='Y'
@21,0 say repli('-',80)
@11,10 say 'วันที่มาตรวจ'
@11,33 say b(sele_date)
@14,10 say 'เคาะ <ENTER> ถ้าถูกต้อง // หรือ พิมพ์ อักษรอื่นฯ ถ้าไม่ถูกต้อง' get wai
@15,31 say repl('-',30)
READ NOLOCK
if wai # 'Y'
  flag1=.f.
endi
@11,8 to 15,77 clea
RETU
*-------------------
proc collect_diag         && CALLED BY PROC CASE_HN
PARA _goobj
SELE refer
SCAT MEMV BLANK
SELE camefile
SCAT MEMV BLANK
STOR SPACE(30) TO mdoctor,ptname,referinplace,referoutplace,mclinic
STOR SPACE(60) TO mmdiag1,mmdiag2,mmdiag3,mmdiag4,mreferdiag,moutdiag
STOR SPACE(60) TO mdiag1,mdiag2,mdiag3,mdiag4,referdiag,outdiag
STOR SPACE(4) TO mt_in,mt_out,outtime
STOR SPAC(5) TO outplace
STOR SPAC(2) TO outcause
STOR SPAC(1) TO mnew1,mnew2,mnew3,mnew4,outtype,m.dxtype1,m.dxtype2,m.dxtype3,;
m.dxtype4
*** udc
* m.admwt= space(6) && add by harin && rem by udc
m.AdmWt = 0.000
*** udc
FOR i = 1 TO numdiag
	x = LTRIM(STR(i))
	STOR SPAC(1) TO mnew&x, m.dxtype&x
	STORE SPACE(60) TO mmdiag&x, m.mdiag&x
NEXT
STOR 0 TO ill_d
mdiag0='adfe'					&& ทำ dummy ไว้สำหรับตรวจสอบ
now_date = DATE()
STOR SPACE(10) TO mdate
mdate=CE2BE(date)
now_clinic=clinic
now_time=t_in
now_date=date
x=1
curr_rec=RECNO()
DO WHIL date=now_date .AND. clinic=now_clinic .AND. t_in=now_time
  	_xxx=LTRIM(STR(x))
    IF LEFT(diag,1)='*' .OR. ISDIGIT(diag)
    	mseek=IIF(ISDIGIT(diag),diag,SUBS(diag,2))
    	mf1='icdcm1'
    	mf2='icdcm2'
    	mf3='icdcm3'
    ELSE
    	mseek=diag
    	mf1='icd101'
    	mf2='icd102'
    	mf3='icd103'
    ENDI
    SELE (mf1)
    SEEK mseek
    IF LEFT(mseek,1)='#'
    	IF ! USED('shorticd')
	    	dbfuse = patientdir+'shorticd'
    		USE (patientdir+'shorticd') IN 0
    		dbfuse = ''
    	ENDI
    	SELE shorticd
    	SET ORDER TO TAG code
    	SEEK mseek
    ENDI
    mmdiag&_xxx=LEFT(desc,60)
    SELE camefile
    mdiag&_xxx = ShowICD(diag)
    mnew&_xxx=episode
    m.dxtype&_xxx = dxtype
    SKIP
    x=x+1
    SELE camefile
    IF X = numdiag + 1 .OR. sequence = 1
       EXIT
    ENDI
ENDD
	goobj=_goobj
	do move_var
RETU
**********************************************************************

proc move_var                  && CALLED BY PROC COLLECT_DIAG
SELE camefile
go curr_rec
now_hn=hn
now_clinic=clinic
now_doctor=doctor
SELE doctor
SEEK now_doctor
mdoctor=De_Name(name)
SELE patient1
Seek shn
ptname=De_Name(name)
sele camefile
scat memv
STOR SPACE(3) TO m.con_clinic
STOR SPACE(25) TO mcon_clinic
mt_in =STRZERO(INT(t_in/60),2)+STRZERO(MOD(t_in,60),2)
mt_in = IIF(LEFT(mt_in,2) >='24','00'+RIGHT(mt_in,2),mt_in)
mt_out=STRZERO(INT(t_out/60),2)+STRZERO(MOD(t_out,60),2)
mt_out = IIF(LEFT(mt_out,2) >='24','00'+RIGHT(mt_out,2),mt_out)
ill_d=date - ill_date
mrem=rem_c
mresult=result
now_day=DTOC(camefile.date)
now_day=SUBS(now_day,4,2)+LEFT(now_day,2)
IF mrem = '4'
	m.type='1'
	SELE refer
	LOCA for hn=now_hn .AND. day=now_day .AND. type=m.type
	m.time = time
	m.place = place
	m.cause = cause
	SELE hospcode
	SEEK m.place
	referinplace = De_name(name)
ENDI
IF mresult = '54'
	m.type='2'
	SELE refer
	LOCA for hn=now_hn .AND. day=now_day .AND. type=m.type
	outtime = time
	outplace = place
	outcause = cause
	SELE hospcode
	SEEK outplace
	referoutplace = De_Name(name)
ENDI
SELE camefile
mdiag0='dfghj'
h_name=mhosp_name + ' คลีนิค '+clinic->name
mclinic = clinic.name
h_name=rtrim(h_name)
wide=(80-len(h_name))/2
@0,wide say h_name
do entry_screen
DEFINE WIND win1 FROM 10,2 TO 15,78 SHAD
ON KEY LABEL F2 DO search_clinic WITH m.clinic,mclinic
	@5,30 get m.hn pict "#######" WHEN CheckObj() VALID CheckHn(m.hn);
		MESS 'ใส่หมายเลขผู้ป่วยนอก ไม่ต้องมี 0 นำหน้า'
	@ 5,40 GET ptname DEFA SPAC(30) DISA COLO ,,,,,,,,,/w
	@6,24 GET m.rem_c PICT '#' VALID CheckRem(m.rem_c) ;
		MESS 'ใส่ 1=มาตามนัด  2=มาเอง   3=รับ ปรึกษา  4=รับ Refer'
	@6,60 get mdate PICT '99/99/9999' VALID TRUEDATE(mdate) ;
		MESS 'ใส่วัน เดือน ปี เป็นปีพุทธศักราช'
	@7,24 get mt_in pict '@R ##:##'  WHEN CheckFirst() VALID CheckTimeIn(mt_in) ;
		MESS 'ใส่เวลาที่มาทำบัตรเป็นชั่วโมง นาที'
	@7,60 get mt_out pict '@R ##:##' WHEN CheckFirst() VALID CheckTimeOut(mt_out) ;
		MESS 'ใส่เวลาที่ตรวจเสร็จเป็นชั่วโมง นาที'
	@9,28 get mdiag1 PICT '@!' WHEN EntryICD(mdiag0,mdiag1) VALID CheckICD(mdiag1) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 1' SIZE 1,20
	@9,61 get mnew1 pict '9' WHEN CheckFirst() VALID EPISODE(mnew1);
		MESS 'ใส่รหัสว่าเป็น 1 = ผู้ป่วยใหม่ 2 = เก่า หรือ 3 = ติดตามโรค'
	@9,73 get m.dxtype1 DISA COLO ,,,,,,,,,/w
	@10,5 GET mmdiag1  DISA COLO ,,,,,,,,,/w
	@11,28 get mdiag2 PICT '@!' WHEN EntryICD(mdiag1,mdiag2) VALID CheckICD(mdiag2) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 2 ถ้าไม่มีให้ใส่เป็นช่องว่าง' SIZE 1,20
	@11,61 get mnew2 pict '9' WHEN CheckFirst() VALID EPISODE(mnew2);
		MESS 'ใส่รหัสว่าเป็น 1 = ผู้ป่วยใหม่ 2 = เก่า หรือ 3 = ติดตามโรค'
	@11,73 get m.dxtype2 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype2,mdiag2);
		MESS 'ใส่รหัสว่าเป็น 2 = Comorbidity 3 = Complication หรือ 4 = Other'
	@12,5 GET mmdiag2 DISA COLO ,,,,,,,,,/w
	@13,28 get mdiag3 PICT '@!' WHEN EntryICD(mdiag2,mdiag3) VALID CheckICD(mdiag3) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 3 ถ้าไม่มีให้ใส่เป็นช่องว่าง' SIZE 1,20
	@13,61 get mnew3 pict '9' WHEN CheckFirst() VALID EPISODE(mnew3);
		MESS 'ใส่รหัสว่าเป็น 1 = ผู้ป่วยใหม่ 2 = เก่า หรือ 3 = ติดตามโรค'
	@13,73 get m.dxtype3 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype3,mdiag3);
		MESS 'ใส่รหัสว่าเป็น 2 = Comorbidity 3 = Complication หรือ 4 = Other'
	@14,5  GET mmdiag3 DISA COLO ,,,,,,,,,/w
	@15,28 get mdiag4 PICT '@!' WHEN EntryICD(mdiag3,mdiag4) VALID CheckICD(mdiag4) ;
		MESS 'ใส่รหัสโรคหรือชื่อโรคที่ 4 ถ้าไม่มีให้ใส่เป็นช่องว่าง' SIZE 1,20
	@15,61 get mnew4 pict '9' WHEN CheckFirst() VALID EPISODE(mnew4);
		MESS 'ใส่รหัสว่าเป็น 1 = ผู้ป่วยใหม่ 2 = เก่า หรือ 3 = ติดตามโรค'
	@15,73 get m.dxtype4 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype4,mdiag4);
		MESS 'ใส่รหัสว่าเป็น 2 = Comorbidity 3 = Complication หรือ 4 = Other'
	@ 16,5 GET mmdiag4 DISA COLO ,,,,,,,,,/w
	@18,21 get ill_d pict '##' ;
		MESS 'ใส่จำนวนวันที่ผู้ป่วยไม่สบาย'
	@18,42 get m.AdmWt pict '999.999' VALID ChkAdmWt() mess 'ใส่น้ำหนักเป็นกิโลกรัม'
	@18,71 get m.doctor WHEN InputDoctor(m.doctor) VALID CheckDoctor(m.doctor,mdoctor) ;
		MESS 'ใส่รหัสแพทย์ที่ทำการรักษาผู้ป่วย'
	@19,21 get m.result PICT '99' VALID CheckResult(m.result) ;
		MESS 'ใส่ผลการรักษาผู้ป่วย'
	@19,47 GET mdoctor DISA COLO ,,,,,,,,,/w
	@20,20 say 'กด ENTER ถ้าแก้ไขข้อมูลเรียบร้อย' GET ASK defa 'Y' pict '!';
WHEN WAITFORER() valid checkcorrect(ask)
READ NOLOCK
ON KEY LABEL ALt+E
		IF LEFT(m.clinic,2) $ '13,14'
			DO AskEmer
		ELSE
			m.dep = IIF(EMPTY(m.dep),LEFT(m.clinic,2),m.dep)
		ENDI
do rewrite_var
	SELE appoint
	SET ORDER TO 1
	IF ! SEEK(now_hn+now_clinic) 	&& หาว่ามีการนัดหมายอยู่เดิมหรือไม่
		APPE BLANK
	ENDI
	SCAT MEMV MEMO
	mmtime=m.time
	mdateappo=CE2BE(date)
	showdate=CE2CBE(date)
	SELE camefile
	go curr_rec
	m.doctor=IIF(EMPTY(m.doctor), doctor, m.doctor)
	m.hn=hn
	m.clinic=IIF( EMPTY(m.clinic), clinic, m.clinic)
	m.fromclinic = IIF( EMPTY(m.fromclinic), clinic, m.fromclinic)
	SELE doctor
	SEEK m.doctor
	mdoctor = DE_name(name)
	SELE clinic
	SEEK m.clinic
	mclinic = name
	IF m.result = '51'
		DO appointment WITH .F.
	ENDI
	SELE appoint
	IF LASTKEY()=27
		GATHER MEMV MEMO
		FLUSH
	ENDI
	SET ORDER TO 1
ON KEY LABEL F2

****** แก้ไขข้อมูลการเงิน
DEFINE WIND OPDChrg1 FROM 10,10 TO 14,70 SHAD
ACTI WIND OPDChrg1
goon1='N'
CLEA
@ 1,3 SAY 'ต้องการแก้ไขข้อมูลค่าใช้จ่ายหรือไม่  ' GET goon1 PICT '!'
READ
RELE WIND
IF goon1='Y'
	DO ED_OPDCHRG
ENDI

return
*-------------------------------
proc rewrite_var           && CALLED BY PROC MOVE_VAR
SELE camefile
go curr_rec
diag_count=4
m.t_in=MINUTEIN(mt_in)
m.t_out=MINUTEOUT(mt_out)
m.date = BE2CE(mdate)
m.ill_date=m.date - ill_d
ii=1
eof=.F.
DO WHIL ii <= numdiag
	_xxx=LTRIM(STR(ii))
	If EMPTY(mdiag&_xxx)
		EXIT
	ELSE
		m.diag=Con_ICD(mdiag&_xxx)
		m.diag=IIF(ISDIGIT(m.diag),' '+LEFT(m.diag,4),m.diag)
		m.dxtype = m.dxtype&_xxx
   		m.sequence=ii
		IF sequence#ii .OR. eof
     		APPE BLANK
     	ENDI
		SKIP
		IF ! EOF()
			pre_rec=RECNO()
			eof=.F.
		ELSE
			eof=.T.
			pre_rec=1
		ENDI
		SKIP -1
		m.episode=mnew&_xxx
     	GATH MEMV
     	FLUSH
    	GO pre_rec
     ENDI
     ii=ii+1
ENDD
eof=EOF()
DO WHIL sequence#1 .AND. ! EOF
	SKIP
	IF ! EOF()
		pre_rec=RECNO()
		eof=.F.
	ELSE
		eof=.T.
		pre_rec=1
	ENDI
	SKIP -1
	scat memv blan
	gath memv
	FLUSH
	GO pre_rec
ENDD
IF StatInput
	SELE medrec
	SEEK m.hn
	DO WHIL hn = m.hn .AND. status
		REPL status WITH .T.,hn WITH SPACE(7)
		FLUSH
		SKIP
	ENDD
	REPL patient1.clinic WITH 'ZZZ'
	FLUSH
ENDI

SELE refer
IF mrem = '4'
	m.type='1'
	now_day=DTOC(now_date)
	now_day=SUBS(now_day,4,2)+LEFT(now_day,2)
	LOCA for hn=now_hn .AND. day=now_day .AND. type='1'
ENDI
IF m.rem_c = '4'
	m.type='1'
	IF ! mrem = '4'
		LOCA FOR EMPTY(hn)
	ENDI
	IF EOF()
		APPE BLANK
	ENDI
	m.day = SUBS(mdate,4,2)+LEFT(mdate,2)
	m.diag=Con_ICD(mdiag1)
	m.diag=IIF(ISDIGIT(m.diag),' '+LEFT(m.diag,4),m.diag)
	m.hn = now_hn
	m.clinic = now_clinic
	GATHE MEMV
	FLUSH
ELSE
	IF mrem = '4'
		SCAT MEMV BLANK
		GATHER MEMV
		FLUSH
	ENDI
ENDI
IF mresult = '54'
	now_day=DTOC(now_date)
	now_day=SUBS(now_day,4,2)+LEFT(now_day,2)
	LOCA for hn=now_hn .AND. day=now_day .AND. type='2'
ENDI
IF m.result = '54'
	m.type='2'
	m.place=outplace
	m.cause=outcause
	m.time = outtime
	IF ! mresult ='54'
		LOCA FOR EMPTY(hn)
	ENDI
	IF EOF()
		APPE BLANK
	ENDI
	m.day = SUBS(mdate,4,2)+LEFT(mdate,2)
	m.diag=Con_ICD(mdiag1)
	m.diag=IIF(ISDIGIT(m.diag),' '+LEFT(m.diag,4),m.diag)
	m.hn = now_hn
	m.clinic = now_clinic
	GATHE MEMV
	FLUSH
ELSE
	IF mresult = '54'
		SCAT MEMV BLANK
		GATHER MEMV
		FLUSH
	ENDI
ENDI
IF m.result = '53'
	SELE medrec
	SEEK m.hn
	DO WHIL hn = m.hn .AND. status
		SKIP
	ENDD
	IF hn = m.hn
		REPL who WITH m.con_clinic
		FLUSH
	ENDI
ENDI

****************************************
PROC case_name							&&   ค้นหา จากชื่อ
****************************************
dime fname(20),fhn(20)
@3,0 clea
do whil .t.
	SELE patient1
  search_name=space(30)
  i=0
  @6,15 say 'พิมพ์ชื่อคนไข้ ' get search_name
  READ NOLOCK
  @21,0 say repl('-',80)
  if empty(search_name)
     exit
  endi
	found = .F.
	DO Chec_new WITH search_name,found
	SET ORDER TO 1
	IF ! found
		shn = hn
		_showname = TRIM(DE_NAME(name))
		sele camefile
    	if SEEK (shn)
        	 do check_hn
        ELSE
        	WAIT WIND NOWA 'ไม่มีคนไข้ชื่อ '+_showname+' มาตรวจในเดือนนี้'
	    endi
	ELSE
		WAIT WIND NOWA 'ไม่ได้เลือกชื่อคนไข้เพื่อค้นหา'
	ENDI
endd
RETU
***************************************************************

PROC CASE_COMPLETE
@3,0 to 16,80 CLEA
cdate = DATE()
mbdate = CE2BE(cdate)
@ 4,10 SAY 'ต้องการทำงานของวันที่ ' GET mbdate VALID TRUEDATE(mbdate)
READ NOLOCK
cdate = BE2CE(mbdate)
curr_rec = 1
DO WHILE .T.
	@22,0 to 22,80 CLEA
	@ 24,0
	@ 3,0 TO 20,80 CLEA
	shn=space(7)
	SELE camefile
	@9,10 say 'พิมพ์เลขที่คนไข้ (HN) ' get shn picture '9999999';
	valid foundhn(shn)
	READ NOLOCK
	IF EMPTY(shn) .OR. shn = '0000000' .OR. LASTKEY() = 27
		EXIT
	ENDI
	IF SEEK(shn+STR(day(cdate),2))
  		DO WHIL hn = shn .AND. (date # cdate .OR. ! EMPTY(diag) ;
  		.OR. sequence # 1)
  			SKIP
  		ENDD
  		IF hn # shn
  			?? CHR(7)
  			WAIT WIND NOWA 'ผู้ป่วยเลขที่ '+shn+' ลงการวินิจฉัยแล้ว '
  		ELSE
			DO Collect_diag WITH 7
		ENDI
	ELSE
		?? CHR(7)
		WAIT WIND NOWA 'ผู้ป่วยเลขที่ '+shn+' ลงการวินิจฉัยแล้ว '
	ENDI
ENDD

FUNC WAITFORER
ON KEY LABEL ALT+E DO AskEMER

*********************
PROC ED_OPDCHRG
*********************
PARA _new
*DEAC WIND ALL
define window ed_opdchrg from 03,0 to 22,79 shadow
activate window ed_opdchrg
@3,0 TO 22,80 clea
do editopdchrg_screen           && search parag 5000
do entry_editopdchrg            && search parag 6000
rele window ed_opdchrg
***---------------------   5000   ----------------
proc editopdchrg_screen
text
    				ค่ารักษาพยาบาลผู้ป่วยนอก
  HN :            ค่ารักษาของ                                        สิทธิ์
  รายละเอียด                          จ่าย        ฟรี
      ค่ายา
      ค่าบริการทางการแพทย์
      ค่าบริการทันตกรรม
      ค่าบริการทางห้องปฏิบัติการ
      ค่า X-Ray
      ค่าวัสดุการแพทย์
      ค่าห้อง
      ค่าบำรุง
      ใบรับรองแพทย์
      บริจาค
      อื่น ๆ
      รวม
      จ่ายจริง                             สปร.

endtext
***------------------------   8000  บันทึกค่ารักษา ---------------
PROC ENTRY_editopdchrg
fromin = PROGRAM(3) = 'IN_opdchrg'
firstenter = _new 	&& ให้รู้ว่าเป็นการเพิ่งเข้ามาลงข้อมูล
stor 0 to m01,m02,m03,m04,m05,m06,m07,m08,m09,m010,m011,m.sum,mpaid
stor 0 to s01,s02,s03,s04,s05,s06,s07,s08,s09,s010,s011,m.ssum,mspaid
cItem1 = "01"
cItem2 = "02"
cItem3 = "03"
cItem4 = "04"
cItem5 = "05"
cItem6 = "06"
cItem7 = "07"
cItem8 = "08"
cItem9 = "09"
cItem10 = "10"
cItem11 = "11"
sele patient1
seek(hn)
mclass = class
@ 2,8 say m.hn colo /w
@ 2,31 SAY ptname colo /w
@ 2,75 say mclass colo /w
@ 4,4 say cItem1 colo /w
@ 4,36 GET m01 PICT '@R #######' COLO ,,,,,,,,,/w
@ 4,50 GET s01 PICT '@R #######' COLO ,,,,,,,,,/w
@ 5,4 say cItem2 colo /w
@ 5,36 GET m02 PICT '@R #######' COLO ,,,,,,,,,/w
@ 5,50 GET s02 PICT '@R #######' COLO ,,,,,,,,,/w
@ 6,4 say cItem3 colo /w
@ 6,36 GET m03 PICT '@R #######' COLO ,,,,,,,,,/w
@ 6,50 GET s03 PICT '@R #######' COLO ,,,,,,,,,/w
@ 7,4 say cItem4 colo /w
@ 7,36 GET m04 PICT '@R #######' COLO ,,,,,,,,,/w
@ 7,50 GET s04 PICT '@R #######' COLO ,,,,,,,,,/w
@ 8,4 say cItem5 colo /w
@ 8,36 GET m05 PICT '@R #######' COLO ,,,,,,,,,/w
@ 8,50 GET s05 PICT '@R #######' COLO ,,,,,,,,,/w
@ 9,4 say cItem6 colo /w
@ 9,36 GET m06 PICT '@R #######' COLO ,,,,,,,,,/w
@ 9,50 GET s06 PICT '@R #######' COLO ,,,,,,,,,/w
@ 10,4 say cItem7 colo /w
@ 10,36 GET m07 PICT '@R #######' COLO ,,,,,,,,,/w
@ 10,50 GET s07 PICT '@R #######' COLO ,,,,,,,,,/w
@ 11,4 say cItem8 colo /w
@ 11,36 GET m08 PICT '@R #######' COLO ,,,,,,,,,/w
@ 11,50 GET s08 PICT '@R #######' COLO ,,,,,,,,,/w
@ 12,4 say cItem9 colo /w
@ 12,36 GET m09 PICT '@R #######' COLO ,,,,,,,,,/w
@ 12,50 GET s09 PICT '@R #######' COLO ,,,,,,,,,/w
@ 13,4 say cItem10 colo /w
@ 13,36 GET m010 PICT '@R #######' COLO ,,,,,,,,,/w
@ 13,50 GET s010 PICT '@R #######' COLO ,,,,,,,,,/w
@ 14,4 say cItem11 colo /w
@ 14,36 GET m011 PICT '@R #######' COLO ,,,,,,,,,/w
@ 14,50 GET s011 PICT '@R #######' COLO ,,,,,,,,,/w
***********เปิดแฟ้ม
IF USED('RCOPD')
	SELE RCOPD
	use
ENDI
	sele 0
	target=billdir+'opd\rcopd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (RC_NO C(10), HN C(9), DATE D, TOTAL N(7);
		,PAID N(7) )
			index on hn tag hn addi
			index on RC_NO tag RC_NO addi
	endif
	use (target) alias RCOPD
	dbfuse = ''
	set order to tag rc_no
IF USED('DTOPD')
	SELE DTOPD
	use
ENDI
	sele 0
	target=billdir+'opd\dtopd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (RC_NO C(10), SV_ID C(2), AMT N(7),FREE N(7), HN C(9) )
			index on HN tag HN
			index on rc_no tag rc_no addi
	endif
	use (target) alias DTOPD
	dbfuse = ''
	set order to tag rc_no
IF USED('CREDOPD')
	SELE CREDOPD
	use
ENDI
	sele 0
	target=billdir+'opd\credopd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (CR_ID C(2), RC_NO C(10), HN C(9) )
			index on HN tag HN addi
			index on rc_no tag rc_no addi
	endif
	use (target) alias CREDOPD
	dbfuse = ''
	set order to tag rc_no
***********
sele rcopd
set order to tag rc_no
LOCA for hn=now_hn .AND. date=BE2CE(mdate)
mnrc_no = rc_no
sele dtopd
set order to tag rc_no
IF seek(mnrc_no)
	DO WHIL hn=now_hn .and. rc_no = mnrc_no
		mcitem = sv_id
		do case
			case mcitem = "01"
				m01 = AMT
				s01 = FREE
				skip+1
			case mcitem = "02"
				m02 = AMT
				s02 = FREE
				skip+1
			case mcitem = "03"
				m03 = AMT
				s03 = FREE
				skip+1
			case mcitem = "04"
				m04 = AMT
				s04 = FREE
				skip+1
			case mcitem = "05"
				m05 = AMT
				s05 = FREE
				skip+1
			case mcitem = "06"
				m06 = AMT
				s06 = FREE
				skip+1
			case mcitem = "07"
				m07 = AMT
				s07 = FREE
				skip+1
			case mcitem = "08"
				m08 = AMT
				s08 = FREE
				skip+1
			case mcitem = "09"
				m09 = AMT
				s09 = FREE
				skip+1
			case mcitem = "10"
				m010 = AMT
				s010 = FREE
				skip+1
			case mcitem = "11"
				m011 = AMT
				s011 = FREE
				skip+1
		endc
		enddo
	endif
@ 4,33 say m01 COLO ,,,,,,,,,/w
@ 4,47 say s01 COLO ,,,,,,,,,/w
@ 5,33 say m02 COLO ,,,,,,,,,/w
@ 5,47 say s02 COLO ,,,,,,,,,/w
@ 6,33 say m03 COLO ,,,,,,,,,/w
@ 6,47 say s03 COLO ,,,,,,,,,/w
@ 7,33 say m04 COLO ,,,,,,,,,/w
@ 7,47 say s04 COLO ,,,,,,,,,/w
@ 8,33 say m05 COLO ,,,,,,,,,/w
@ 8,47 say s05 COLO ,,,,,,,,,/w
@ 9,33 say m06 COLO ,,,,,,,,,/w
@ 9,47 say s06 COLO ,,,,,,,,,/w
@ 10,33 say m07 COLO ,,,,,,,,,/w
@ 10,47 say s07 COLO ,,,,,,,,,/w
@ 11,33 say m08 COLO ,,,,,,,,,/w
@ 11,47 say s08 COLO ,,,,,,,,,/w
@ 12,33 say m09 COLO ,,,,,,,,,/w
@ 12,47 say s09 COLO ,,,,,,,,,/w
@ 13,33 say m010 COLO ,,,,,,,,,/w
@ 13,47 say s010 COLO ,,,,,,,,,/w
@ 14,33 say m011 COLO ,,,,,,,,,/w
@ 14,47 say s011 COLO ,,,,,,,,,/w

read nolock
m.sum = m01+m02+m03+m04+m05+m06+m07+m08+m09+m010+m011
m.ssum = s01+s02+s03+s04+s05+s06+s07+s08+s09+s010+s011
@ 15,36 SAY m.sum COLO /w
@ 16,25 GET mpaid COLO /w
read nolock
m.free = m.sum-mpaid
@ 16,50 say m.free COLO /w
@ 17,20 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET ask DEFA 'Y';
PICT '!' WHEN WAITFORER() valid checkcorrect(ask)
READ NOLOCK
=ClearKey()

******************* ถ้ามีข้อมูลค่ารักษาบันทึกใน rcopd,dtopd,credopd
sele credopd
IF Seek(mnrc_no)
	scatter memvar
	GATH MEMV
	FLUSH
ENDI

sele RcoPd
IF Seek(mnrc_no)
	scatter memvar
	m.date = BE2CE(mdate)
	m.total = m.sum
	m.paid = mpaid
	GATH MEMV
	FLUSH
ENDI

sele dtopd
IF seek(mnrc_no)
	scat MEMV
	DO WHILE Seek(mnrc_no)
		REPL RC_NO with space(10),SV_ID with space(2), AMT with 0,HN with space(9),FREE WITH 0
	ENDD
	FLUSH
	=1
	DO WHIL n <= 11
		sv_id = 'cItem'+alltrim(str(n))
		mget = 'm0'+alltrim(str(n))
		sget = 's0'+alltrim(str(n))
		m.sv_id = &msv_id
		m.amt = &mget
		m.free = &sget
		m.rc_no = mnrc_no
		go top
		IF m.amt = 0
			*skip
			n = n+1
		ELSE
			DO WHIL !empty(rc_no) .or.  BOF() .OR. ! RLOCK()
				appe blank
			ENDD
			gather memvar
			FLUSH
			UNLOCK ALL
			n = n+1
		ENDI
	ENDD
ELSE
	n=1
	DO WHIL n <= 11
		msv_id = 'cItem'+alltrim(str(n))
		mget = 'm0'+alltrim(str(n))
		sget = 's0'+alltrim(str(n))
		m.sv_id = &msv_id
		m.amt = &mget
		m.free = &sget
		m.rc_no = mnrc_no
		go top
		IF m.amt = 0
			*skip
			n = n+1
		ELSE
			DO WHIL !empty(rc_no) .or.  BOF() .OR. ! RLOCK()
				appe blank
			ENDD
			gather memvar
			FLUSH
			UNLOCK ALL
			n = n+1
		ENDI
	ENDD
ENDI

***********************************
	Function ChkAdmWt
***********************************
	dAdmit = BE2CE(mdate)
	dBirth = Lookup(Patient1.BirthDay,alltrim(m.HN),Patient1.HN,"HN")
	IF ! Empty(dBirth) and ! Empty(dAdmit) and ;
		dBirth > gomonth(dAdmit,-12) and Empty(m.AdmWt)
		?? Chr(7)
		WAIT WIND " ผู้ป่วยอายุต่ำกว่า 1 ปี ต้องบันทึกน้ำหนักด้วย " NOWAIT
		_Curobj = ObjNum(m.AdmWt)
		Return
	ELSE
		IF m.AdmWt > 500
			?? Chr(7)
			WAIT WIND " ใครจะน้ำหนักมากขนาดนั้น !!!  ลองตรวจสอบอีกครั้ง " NOWAIT
			_Curobj = ObjNum(m.AdmWt)
			Return
		ENDI
	ENDI
