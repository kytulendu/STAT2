PARA _startprog
PRIV goon
SET RESOURCE OFF
*RELE ALL
SET PROC TO Utility
_toprog = IIF(PARAMETER()=0,'  ',_startprog)
DO StartSet
#DEFINE UpArrow 5
#DEFINE LeftArrow 19
PUBLIC Atrscreen,Atrbackgr,Atrdata,Atrmenu,Atrmenu2
STORE '\stat2\pub\' TO patientdir,codedir
STOR '' TO tempdir,workstation,backup,admit,thaicard,person_id,;
prescription,notprintrx,wellbaby,notkeyword,backupdrive,dbfuse,notstatadmit
STORE '\stat2\ipd\' TO ipddir
STORE '\stat2\opd\' TO opddir
STORE '\stat2\pharm\' TO pharmdir
ON error DO err WITH ERROR(),MESSAGE(),LINENO(),PROGRAM(),PROGRAM(2),PROGRAM(3),;
PROGRAM(4),PROGRAM(5),PROGRAM(6),PROGRAM(7),PROGRAM(8),PROGRAM(9)
DIME ProvArr(60)
goon = .T.
DIME test(4)
=ADIR(test,SYS(16))
programdate=CE2CBE(test[3])
fromhelp = .F.
backup = UPPE(GETENV('BACKUP')) 
workstation = UPPE(GETENV('workstation'))
DO GetConfig
audit = backup = 'AUDIT'
F_STATION=workstation='FILE'
ER=workstation='ER'
IF ! FILE(patientdir+'user.dbf')
	SELE 0
	dbfuse = patientdir+'user'
	CREA TABLE (patientdir+'user') ;
	(NAME C(12),PSW C(10),RIGHT C(10))
	INDEX ON name TAG name
	dbfuse = ''
	USE
ENDI
	
IF ! FILE(patientdir + "opdlan.mem")
	DO makedbf			&& ตรวจสอบว่ามีแฟ้มที่จำเป็นครบหรือไม่ ถ้าขาดให้สร้างเพิ่ม
	PUSH KEY CLEA
	ON KEY LABEL F1 KEYB '{ENTER}'
	DO OpdLan  			&& สอบถามข้อมูลพื้นฐานของโรงพยาบาล
	POP KEY
	DO CLearScreen
*	DO OpenLanMaster
	SELE 0
	dbfuse = patientdir+'hncount'
	USE (patientdir+'hncount')
	m.lasthn = lasthn +1
	SELE 0
	dbfuse = ipddir+'ancount'
	USE (ipddir+'ancount') 
	dbfuse = ''
	SCAT MEMV
	m.year = IIF( EMPTY(m.year), RIGHT(CE2BE(DATE()),2), m.year)
	m.lastan = m.lastan+1
	@ 10,20 SAY 'ต้องการเริ่มต้นที่หมายเลข HN ' GET m.lasthn PICT '9999999'
	@ 12,20 SAY 'ต้องการเริ่มต้นที่หมายเลข AN '
	_col = COL() + 1
	@ 12,_col GET m.lastan PICT '99999'
	@ 12,_col+5 SAY '-'
	@ 12,_col+6 GET m.year PICT '99'
	READ
	m.lasthn =IIF(m.lasthn>0, m.lasthn-1,m.lasthn)
	m.lastan = IIF(m.lastan>0, m.lastan-1, m.lastan)
	GATH MEMV
	FLUSH
	SELE hncount
	GATH MEMV
	FLUSH
	CLOSE DATA
ENDI
REST FROM (patientdir+'opdlan') ADDI
SET MESSAGE TO 24
SET TEXT ON
mhosp_name=LTRIM(TRIM(hosp_name))
statversion = '2.6'
col=Center(mhosp_name)
@ 0,col SAY mhosp_name COLO g+/b
DO mainscr
DO workscr
			NumMain=6           && จำนวนรายการหลัก
			DIME MAIN(NumMain),MainMess(NumMain)
			Main(1)='ห้องบัตร'
			Main(2)='ผู้ป่วยนอก'
			Main(3)='รับผู้ป่วยใน'
			Main(5)='บำรุงรักษาระบบ'
			Main(4)='ผู้ป่วยใน'
			Main(NumMain)='เลิกงาน'
			MainMess(1)='งานห้องบัตรและห้องทะเบียน'
			MainMess(2)='งานลงข้อมูลการมาตรวจผู้ป่วยนอก'
			MainMess(3)='งานลงทะเบียนผู้ป่วยรับไว้ในโรงพยาบาล และประชาสัมพันธ์'
			MainMess(4)='งานลงผลการรักษาผู้ป่วยใน'
			MainMess(5)='งานกำหนดค่าระบบ และอรรถประโยชน์'
			MainMess(NumMain)='เลิกการทำงาน  มีปัญหาติดต่อศูนย์คอมพิวเตอร์ FAX.5918630'
			ColSpace=78/NumMain    && ระยะห่างระหว่างแต่ละรายการ
			ChMain=1               && รายการที่เลือก
DO Lan WITH .T.
= ENGMODE()
? CHR(155)+'KE'
DO EndSet
CLEA

PROC MAINSCR
@ 3,0 CLEA TO 20,80
@ 2,0
TEXT
                        โปรแกรมสำหรับงานเวชระเบียนและสถิติ
                                STAT  Version <<statversion>>
                                 กระทรวงสาธารณสุข
ENDTEXT
? SPAC(Center(programdate))+programdate

PROC WORKSCR
TEXT
                               คณะทำงานพัฒนาโปรแกรม

    นายแพทย์ประดิษฐ์  วงษ์คณารัตนกูล           โรงพยาบาลโพธาราม
    นายแพทย์ฐิติ      พัฒนกำจร                 โรงพยาบาลราชบุรี
    นายแพทย์อนุวัฒน์  ศุภชุติกุล               กองโรงพยาบาลภูมิภาค
    นายแพทย์วิรัตน์   ลือวิเศษไพบูลย์          โรงพยาบาลสรรพสิทธิประสงค์ อุบลฯ
    นายแพทย์ยุทธพงศ์  พตด้วง                   โรงพยาบาลเสนา อยุธยา
    นายแพทย์ถาวร      สกุลพานิช                โรงพยาบาลพระพุทธบาท สระบุรี
    นางสาวนิตณา       วิเศษชัยนุสรณ์           กองระบาดวิทยา
    นางสาวลี่ลี       อิงศรีสว่าง              คณะสาธารณสุขศาสตร์ มหิดล
    นางสาวสุวรรณา     เสมอเนตร                 ศูนย์คอมพิวเตอร์
    นางอุษณีย์        เกียรติเสริมขจร          กองโรงพยาบาลภูมิภาค
ที่ปรึกษา
    นายแพทย์สุชาติ    สรณสถาพร                 โรงพยาบาลรามาธิบดี
ENDTEXT

***------------------------  นัดคนไข้  --------------------
********************
FUNC CheckClinic
********************
PARA _clinic,_mclinic
SELE clinic
IF ! EMPTY(_clinic)
   	SET ORDER TO TAG clinic
	IF ! SEEK(_clinic)
		?? CHR(7)+CHR(7)
		WAIT 'ไม่มีคลีนิครหัส '+_clinic WIND NOWAIT
		_CUROBJ=_CUROBJ
	ENDI
	_mclinic=name
ELSE
	?? CHR(7)
	WAIT WIND NOWA 'ต้องใส่รหัสคลีนิกด้วย'
	_CUROBJ=_CUROBJ	
ENDI
SHOW GETS

PROC WARNNEW
PARA _newfile
PRIV correct,tempfile
=ALARM1()
DEFI WIND warnnew FROM 4,5 TO 14,70 SHAD
ACTI WIND warnnew
@ 1,3 SAY 'โครงสร้างของแฟ้ม ' + _newfile +' ไม่ถูกต้อง'
@ 3,3 SAY 'ท่านต้องการแก้ไขให้ถูกต้องหรือไม่' GET correct PICT '!' DEFA 'Y'
READ
IF correct # 'Y'
	RELE WIND warnnew
	RETU TO MASTER
ELSE
	CLEA
	@ 2,3 SAY 'ท่านต้องการแก้ไข้แฟ้ม ' + _newfile + ' ให้ถูกต้อง'
	@ 4,3 SAY 'ท่านต้องให้คอมพิวเตอร์เครื่องอื่นหยุดการเรียกใช้แฟ้มนี้'
	@ 7,3 SAY 'ท่านพร้อมแล้วใช่หรือไม่ ' gET correct PICT '!'
	READ
	IF correct # 'Y'
		RELE WIND warnnew
		RETU TO MASTER
	ELSE
		USE 
		tempfile = PATIENTDIR + SYS(3)
		RENA (_newfile+'.dbf') TO (tempfile+'.dbf')
		dbfuse = _newfile
		CREATE TABLE (_newfile) (HN C(7),VISITED L)
		INDEX ON hn TAG hn
		dbfuse = _newfile
		USE (_newfile) ORDER TAG hn ALIA newcase
		dbfuse = patientdir+tempfile
		USE (tempfile) IN 0 ALIA temp
		dbfuse = ''
		SELE temp
		div_num=ROUND((RECCOUNT()/40)+.5,0)
		recno = 0
		DO ShowProgress
		SCAN 
			recno=recno+1
			@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
			m.hn = hn
			m.visited = .T.
			INSERT INTO newcase FROM MEMV
		ENDS
		DEAC WIND progress
		USE
		DELE FILE (tempfile+'.dbf')
	ENDI
ENDI
RELE WIND warnnew
CLEA TYPEAHEAD
proc appointment
PARA _new
DEAC WIND ALL
@3,0 TO 20,80 clea
do appo_screen           && search parag 3000
do entry_appo            && search parag 4000

***---------------------   3000   ----------------
proc appo_screen
text

    				กำหนดการนัดตรวจคนไข้
  					
    
           วันที่นัด                           เวลานัด
       
       
           นัดตรวจคนไข้ที่คลีนิค  

           แพทย์ผู้นัด
       
       
           ส่งชันสูตร
       
endtext       
***------------------------   4000  บันทึกการนัด  ---------------
PROC ENTRY_APPO
fromin = PROGRAM(3) = 'IN_APPO'
ON KEY LABEL CTRL+P DO PrintStatus
m.date = {  /  /  }
firstenter = _new 	&& ให้รู้ว่าเป็นการเพิ่งเข้ามาลงข้อมูล
@ 4,60 SAY IIF(_printappoint,'พิมพ์ใบนัด    ','ไม่พิมพ์ใบนัด ') COLO /w
@8,30 get mdateappo WHEN HideWin('win1') PICT '@!' VALID CHECKAPPOINT(mdateappo);
mess 'ใส่ วันเดือนปี(ddmmyyyy) หรือ W ต่อท้ายแทนสัปดาห์ หรือ M ต่อท้ายแทนเดือน' 
@ 9,25 GET showdate DEFA SPACE(20) DISA COLO ,,,,,,,,,/w
@ 8,56 get mmtime pict '@r ##:##' VALID TimeAPPO(mmtime) ;
  mess 'ใส่เวลาที่นัดเป็น ชั่วโมงนาที'
@ 11,34 GET m.clinic VALID ;
CheckClinic(m.clinic,mclinic)
@ 11,38 GET mclinic DISA COLO ,,,,,,,,,/w
@13,26 get m.doctor WHEN InputDoctor(m.doctor) VALID ;
CheckDoctor(m.doctor,mdoctor) MESS 'ใส่รหัสแพทย์ที่นัดผู้ป่วยไปพบ'
@ 13,33 GET mdoctor WHEN CLEARKEY() DISA COLO ,,,,,,,,,/w
@16,24 EDIT m.lab SIZE 3,40  WHEN EditLab() COLO ,/w;
  mess ' LAB ที่ต้องใช้ประกอบ สามารถกดปุ่มหมายเลขหน้าชื่อได้'
@ 20,20 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET m.correct WHEN Clearkey()DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
read
=ClearKey()
**********

@ 4,60
if LEFT(mdateappo,2) # '  '
	m.doctor = PADBLANK(m.doctor)
	IF ! fromin .AND. USED('camefile')
		sele camefile
		m.hn    =hn
	ENDI
   m.time=mmtime
   sele appoint
	IF  _new
	   	GO TOP
   		IF ! EMPTY(hn) .OR. BOF()
   			appe blank
   		ENDI
   ENDI
   gather memv MEMO
   FLUSH
	IF _printappoint
		DO printapp
	ENDI
ELSE
	SELE appoint
	IF ! _new .AND. ! EOF()
		REPL hn WITH '  ',DATE WITH CTOD('  /  /  '),lab WITH ''
		FLUSH
	ENDI
endi
IF ! fromin
	IF PROGRAM(2) = 'ADM_CEN'
		SELE iptrana
	ELSE
		IF USED('camefile')
			SELE camefile
		ENDI
	ENDI
ENDI
ON KEY LABEL CTRL+P
RETURN

FUNC CHECKAPPOINT
para _check
private _date
IF LEFT(_check,2)='  '
	CLEA READ
	RETU
ENDI
	
_date=ALLTRIM(_check)
_type=RIGHT(_date,1)
   if _type $ 'WM'
      newdate=VAL(SUBS(_check,1,LEN(_date)-1))
      IF PROGRAM(3) = 'IN_APPO' .OR. ! used('camefile')
      	m.date=IIF(_type = 'W',DATE()+(newdate*7),DATE()+(newdate*28))
      ELSE
      	m.date=IIF(_type = 'W',camefile->date+(newdate*7),camefile->date+(newdate*28))
      ENDI
   ELSE
   	  _check=IIF(LEN(_date)<10,LEFT(_check,2)+'/'+SUBS(_check,3,2)+'/'+SUBS(_check,5,4),_check)
   	  IF TRUEDATE(_check)
   	  	m.date=BE2CE(_check)
   	  	IF USED('camefile')
	   	  	_cdate = IIF(PROGRAM(3)='IN_APPO',DATE(),camefile.date)
		ELSE
			_cdate = DATE()
		ENDI
   	  	IF m.date<=_cdate
    	    ?? CHR(7)
    	    WAIT 'ใส่วันที่นัดก่อนวันนี้ ไม่ถูกต้อง' WIND NOWA
    	    _CUROBJ=_CUROBJ
    	ENDI
   	  ELSE
   	    ?? CHR(7)
   	    WAIT 'ใส่วันที่นัดไม่ถูกต้อง' WIND NOWA
   	    _CUROBJ=_CUROBJ
   	  ENDI
   endi   
dayofweek = DOW(m.date)   
IF dayofweek = 1 .OR. dayofweek = 7
	?? CHR(7)
	showdayofweek = IIF(dayofweek = 1,'วันอาทิตย์','วันเสาร์')
	WAIT WIND NOWA 'โปรดระวัง ! นัดตรงกับวัน'+showdayofweek
ELSE
	SELE holiday
	IF SEEK(m.date)
		?? CHR(7)
		WAIT WIND NOWA 'นัดตรงกับวัน '+holiname
	ENDI
ENDI
showdate=CE2CBE(m.date)
SHOW GETS

FUNC TIMEAPPO
PARA _mmtime
IF ! BETWEEN(VAL(LEFT(_mmtime,2)),8,15)
	=ALARM1()
	WAIT 'โปรดระวัง ! ไม่ใช่เวลาราชการ ไม่ควรนัดคนไข้' WIND NOWA
ENDI

FUNC EditLab
IF firstenter
	SELE countapp
	IF SEEK(DTOS(m.date)+m.clinic)
		numcount = number+1
		repl number WITH numcount
		FLUSH
	ELSE
		go top
		IF date < m.date
			APPE BLAN
		ENDI
		REPL date WITH m.date,clinic WITH m.clinic,number WITH 1
		FLUSH
		numcount = 1
	ENDI
	firstenter = .F.
	WAIT WIND NOWA 'ผู้ป่วยนัดเป็นคนที่ ' + LTRIM(STR(numcount))
ENDI

DEFINE WIND lab FROM 1,1 TO 15,23
ACTI WIND lab 
@ 0,1 SAY 'ALT+1 = CBC'
@ 1,1 SAY 'ALT+2 = UA'
@ 2,1 SAY 'ALT+3 = CXR'
@ 3,1 SAY 'ALT+4 = EKG'
@ 4,1 SAY 'ALT+5 = BUN Cr'
@ 5,1 SAY 'ALT+6 = Electrolyte'
@ 6,1 SAY 'ALT+7 = LFT'
@ 7,1 SAY 'ALT+8 = FBS'
@ 8,1 SAY 'ALT+9 = VDRL'
@ 9,1 SAY 'ALT+0 = Anti HIV'
@10,0 SAY ' ^A = Ultrasound'
@11,0 SAY ' ^B = HBsAg'
@12,0 SAY ' ^X = X-ray อื่น ๆ'
SHOW WIND lab
ACTI SCREE
ON KEY LABEL ALT+1 KEYB 'CBC '
ON KEY LABEL ALT+2 KEYB 'UA '
ON KEY LABEL ALT+3 KEYB 'CXR '
ON KEY LABEL ALT+4 KEYB 'EKG '
ON KEY LABEL ALT+5 KEYB 'BUN Cr '
ON KEY LABEL ALT+6 KEYB 'Electrolyte '
ON KEY LABEL ALT+7 KEYB 'LFT '
ON KEY LABEL ALT+8 KEYB 'FBS '
ON KEY LABEL ALT+9 KEYB 'VDRL '
ON KEY LABEL ALT+0 KEYB 'Anti HIV '
ON KEY LABEL CTRL+A KEYB 'Ultrasound '
ON KEY LABEL CTRL+B KEYB 'HBsAg '
ON KEY LABEL CTRL+X KEYB 'X-ray อื่น ๆ '
ON KEY LABEL ENTER KEYB "{TAB}"
*DO ClearKey

FUNC ClearKey
ON KEY LABEL ALT+1
ON KEY LABEL ALT+2
ON KEY LABEL ALT+3
ON KEY LABEL ALT+4
ON KEY LABEL ALT+5
ON KEY LABEL ALT+6
ON KEY LABEL ALT+7
ON KEY LABEL ALT+8
ON KEY LABEL ALT+9
ON KEY LABEL ALT+0
ON KEY LABEL CTRL+A 
ON KEY LABEL CTRL+B
ON KEY LABEL CTRL+X                       
ON KEY LABEL ENTER
DEAC WIND lab


PROC PrintStatus
STOR IIF(_printappoint,.F.,.T.) TO _printappoint
@ 4,60 SAY IIF(_printappoint,'พิมพ์ใบนัด    ','ไม่พิมพ์ใบนัด ') COLO /w

PROC PrintApp
DAY1='วันอาทิตย์'
DAY2='วันจันทร์'
DAY3='วันอังคาร'
DAY4='วันพุธ'
DAY5='วันพฤหัส'
DAY6='วันศุกร์'
DAY7='วันเสาร์'
SELE patient1
seek hn
cut_name=TRIM(De_Name(name))
SELE icd101
mseek=Con_ICD(TRIM(mdiag1))
SEEK mseek
sele appoint
aa=str(dow(date),1)
mday=DAY&aa+'ที่ '+CE2CBE(date)
mtime=left(time,2)+'.'+right(time,2)+' น.'
SET CONS OFF
SET PRINT ON
hospname=RTRIM(hosp_name)
IF ! CancelPrint()
	?
	?
	?SPACE(40-LEN(hospname)),CHR(14),hospname
	?
	?space(5),'เลขที่ผู้ป่วยนอก',CHR(14),hn
	?
	? space(5),'ชื่อ',cut_name
 
	? space(5),'นัดตรวจ',mday,'เวลา',mtime
	? space(5),'การวินิจฉัยโรค',TRIM(icd101.desc) &&CHR(14),
	? space(5),'ผลชันสูตรที่ต้องใช้ '
	? space(10),lab
	?
	? space(5),'แพทย์ผู้นัด  ',rtrim(mdoctor) ,SPACE(5),'คลีนิค',rtrim(mclinic)
	?

	eject
ENDI
SET PRINT OFF
SET CONS ON

FUNC CHECKFIRST
varread=VARREAD()
DO CASE
	CASE varread='MT_IN'
		IF mt_in='  '
			mt_in=patient1->time
			SHOW GETS
			RETU IIF(mt_in='  ',.T.,.F.)
		ENDI
	CASE varread='MT_OUT'
		IF mt_out='  '
			_mtime=TIME()
			mt_out=LEFT(_mtime,2)+SUBS(_mtime,4,2)
		ENDI
	CASE LEFT(varread,4)='MNEW'
		_x=RIGHT(varread,1)
		IF EMPTY(mdiag&_x)
			mnew&_x=' '
			RETU .F.
		ELSE
			IF USED('newcase')
				SELE newcase
				IF ! SEEK(m.hn)
					mnew&_x = '1'
				ENDI
			ENDI
		ENDI
		
ENDC
	
