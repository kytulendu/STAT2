
********************************************************************************
*   PROCEDURE ต่าง ๆ ที่มีใน File Utility				       *
*   1. STRZERO	  เปลี่ยนค่าตัวเลขเป็น string ที่มี 0 นำหน้า		       *
*   2. PADZERO	  เติมเลข 0 นำหน้า string				       *
*   3. PROVINCE   แสดงชื่อจังหวัดตามรหัสที่ให้ถ้าไม่มีจะ Popup ชื่อให้เลือก    *
*   4. PROVPOP	  ใช้แสดง Popup ชื่อจังหวัดให้เลือก			       *
*   5. AMPUR	  แสดงชื่ออำเภอตามรหัส ถ้าไม่มีจะ Popup ชื่อให้เลือก	       *
*   6. TAMBON	  แสดงชื่อตำบลตามรหัส ถ้าไม่มีจะ Popup ชื่อให้เลือก	       *
*   7. PROV_POP   ใช้แสดง Popup ชื่ออำเภอ หรือ ตำบลให้เลือก		       *
*   8. MAKEHELP   สร้าง memory file สำหรับใช้ใน HELP			       *
*   9. GETKEY	  READ ค่าและดู Exit key ว่าเป็นอะไร เพื่อทำ Full screen       *
*		  editing						       *
*  10. TRUEDATE   ตรวจสอบว่าวันเดือนปีที่ใส่เป็นพุทธศักราชถูกต้องหรือไม่       *
*  11. BE2CE	  เปลี่ยนวันที่จาก character พุทธศักราชเป็น date คริสต์ศักราช  *
*  12. CE2CBE	  เปลี่ยนวันที่ของปีคริสต์ศักราช เป็น character ปีพุทธศักราช   *
*  13. HEADER	  หาจำนวนไบต์ของหัวแฟ้มข้อมูล				       *
*  14. MAINSCR	  แสดงรายชื่อคณะทำงานพัฒนาโปรแกรมในจอหลัก		       *
*  15. LENTHAI	  นับความยาวของคำหรือประโยคไทย โดยตัดสระบนและล่างออก	       *
*  16. CENTER	  ใช้สำหรับหาสดมภ์เพื่อเขียนข้อความให้อยู่กึ่งกลาง	       *
*  17. PADBLANK   เติมเลขช่องว่างนำหน้า string				       *
*  18. BOTTMESS   แสดงข้อความที่กึ่งกลางบรรทัดสุดท้าย			       *
*  19. BIRTHDAT   ใช้สำหรับเปลี่ยนอายุเป็นวันเดือนปีเกิดเป็นปีพุทธศักราช       *
*  20. LISTHELP   จะแสดงข้อมูลในแฟ้มช่วยเหลือ				       *
*  21. PAINT_HS   เป็นโปรแกรมย่อยถูกเรียกโดย LISTHELP เพื่อเขียนข้อมูลบนจอ     *
*  22. NOWAGE	  ใช้สำหรับหาอายุปัจจุบันโดยการส่งค่าวันเดือนปีเกิดมาให้       *
*		   แล้วจะเทียบกับวันที่ขณะนี้				       *
*  23. SETCOLOR    เปลี่ยน attribute ของจอ และคืนค่า attribute เดิมให้	       *
*  24. POP_HELP    ใช้แสดง Popup ของแฟ้มช่วยเหลือต่าง ๆ ขึ้นมาให้เลือก	       *
*  25. CE2BE	   ใช้สำหรับเปลี่ยนปี ค.ศ. เป็นปี พ.ศ.			       *
*  26. DE_NAME	   ใช้สำหรับแสดงชื่อให้ถูกต้อง				       *
*  27. ADDHELP		สำหรับถามว่าจะเพิ่มเติมความช่วยเหลือหรือไม่		   *
*  28. ADDHELPNAME	สำหรับให้ใส่ชื่อเต็มของรหัสความช่วยเหลือที่เพิ่ม	   *
*  29. THAI			เปลี่ยนเป็นโหมดภาษาไทย					   *
*  30. ENGLISH		เปลี่ยนเป็นโหมดภาษาอังกฤษ				   *
*  31. REMOVEBLANK	ตัดช่องว่างข้างหน้าออก					   *
*  32. OPDLAN		สำหรับใส่ชื่อและรหัสโรงพยาบาล				   *
*  33. FULLYEAR     สำหรับเปลี่ยนปีพุทธศักราชแบบ 2 หลักให้เป็น 4 หลัก	       *
*  34. STARTSET 	สำหรับกำหนดค่าต่าง ๆ ที่ใช้ในโปรแกรม			   *
*  35. ENDSET		สำหรับคืนค่าเมื่อสิ้นสุดโปรแกรม 			   *
*  36. COLORSET 	สำหรับกำหนดสีที่จะใช้ในโปรแกรม				   *
*  37. CHECKDATE	สำหรับตรวจสอบว่าวันที่ที่ใส่ถูกต้องหรือไม่		   *
*  38. SHOWPROGRESS สำหรับแสดงเปอร์เซ็นต์ของข้อมูลที่คำนวณได้		       *
********************************************************************************

PROC STRZERO
* FORMAT: string = STRZERO(numeric 1,numeric 2)
* เปลี่ยนค่า numeric 1 ให้เป็น string ที่มีความยาวเท่ากับ numeric 2
* โดยให้มีเลข '0' นำหน้า
PARA _str,_num
RETU RIGHT(STR(1000000000+_str,10),_num)

PROC PADZERO
* FORMAT: string = PADZERO(string 1,numeric)
* เติม '0' หน้า string 1 จนมีความยาวเท่ากับ numeric
PARA _str,_num
_past = IIF(PARAMETERS() = 1,LEN(_str),_num)
RETU RIGHT('000000000'+LTRIM(RTRIM(_str)),_past)

PROC PROVINCE
* FORMAT: DO PROVINCE WITH string,numeric1,numeric2
* แสดงชื่อจังหวัดตามรหัส
* string = ตัวแปรที่เป็นรหัสจังหวัด
* numeric1 และ numeric 2  เป็นแถวและสดมภ์ที่ตัวแปรอยู่
PARAMETER _var,_row,_col
= THAIMODE()
IF EMPTY(_var) .OR. ! SEEK(_var)
   _var=Provpop(10,20)
ELSE
   _var=RIGHT(_var,2)
ENDI
= ENGMODE()
@ _row,_col SAY _var COLO gr+/b
@ _row,_col+3 SAY name COLO gr+/b
RETU _var

PROC PROVPOP
* FORMAT: var = PROVPOP()
* Popup ชื่อจังหวัดให้เลือก จะให้ค่าคืนเป็นรหัสจังหวัด
PARA _row,_col
DIME PROVNAME(200),PROVCODE(200)
IF USED('ADDRESS')
	SELE address
ELSE
	SELE 0
	dbfuse = codedir+'address'
	USE (codedir+'address')
ENDI
dbfuse = ''
SET ORDER TO 1
ProvNum=0
SEEK '1'
DO WHIL type='1'
	ProvNum=ProvNum+1
	ProvName(Provnum)=name
	ProvCode(Provnum)=LEFT(code,2)
	skip
ENDD
DIME provcode(provnum),provname(provnum)
mchoice=0
SET CONF ON
*SET COLO TO W+/B
DO WHIL mchoice=0
   @  _row,_col MENU ProvName,ProvNum,10
   READ MENU TO mchoice
ENDD
SET CONF OFF
*SET COLO TO bg+/b
SEEK '1'+provcode(mchoice)
RETU ProvCode(mchoice)

PROC AMPUR
* FORMAT: DO AMPUR WITH string,numeric1,numeric2
* แสดงชื่ออำเภอตามรหัส	ถ้าไม่พบจะ Popup ชื่อให้เลือก
* string = ตัวแปรที่เป็นรหัสอำเภอ
* numeric1 และ numeric 2  เป็นแถวและสดมภ์ที่ตัวแปรอยู่
PARAMETER _var,_row,_col
IF ! SEEK(_var)
   = THAIMODE()
   _var=IIF(Prov_Pop(_var),SUBS(code,3,2),'  ')
   = ENGMODE()
ELSE
   _var=SUBS(code,3,2)
ENDI
@ _row,_col SAY _var COLO gr+/b
@ _row,_col+3 SAY name COLO gr+/b
RETU _var

PROC TAMBON
* FORMAT: DO TAMBON WITH string,numeric1,numeric2
* แสดงชื่อตำบลตามรหัส  ถ้าไม่พบจะ Popup ชื่อให้เลือก
* string = ตัวแปรที่เป็นรหัสตำบล
* numeric1 และ numeric 2  เป็นแถวและสดมภ์ที่ตัวแปรอยู่
PARAMETER _var,_row,_col
IF ! SEEK(_var)
   = THAIMODE()
   _var=IIF(Prov_Pop(_var),RIGHT(code,2),'  ')
   = ENGMODE()
ELSE
   _var=RIGHT(code,2)
ENDI
@ _row,_col SAY _var COLO gr+/b
@ _row,_col+3 SAY name COLO gr+/b
RETU _var

PROC PROV_POP
* FORMAT: var = PROV_POP()
* Popup ชื่ออำเภอหรือตำบลแล้วให้ค่ารหัสอำเภอ หรือตำบล แล้วแต่โปรแกรมที่เลือก
PARAMETER _type
PRIVATE num,xx,var,logic,mseek
EXTERNAL ARRAY ProvArr
DIME provarr[60]
logic=.T.
var=IIF(LEFT(_type,1)='2',SUBS(_type,2,2),SUBS(_type,2,4))
num=IIF(LEFT(_type,1)='2',2,4)
mseek=LEFT(_type,num+1)
*SET COLO TO w+/b
IF ! SEEK(mseek)
   logic=.F.
ELSE
   xx=1
   DO WHIL LEFT(code,num)=var .AND. ! EOF()
      ProvArr(xx)=name
      xx=xx+1
      SKIP
   ENDD
   mchoice=0
   SET CONF ON
   DO WHIL mchoice=0
      @  10,20 MENU ProvArr,xx-1,10
      READ MENU TO mchoice
   ENDD
   SET CONF OFF
   SKIP mchoice-xx
ENDI
*SET COLO TO bg+/b
RETU logic

PROC MAKEHELP
* FORMAT: DO MAKEPROV
* สร้างแฟ้ม PROVINCE.MEM จากแฟ้ม Address
* เก็บค่ารหัสจังหวัดและชื่อจังหวัดไว้ใน array แล้ว save ไว้ใน province.mem
DIME PROVNAME(200),PROVCODE(200)
IF ! FILE(hosp_dir+"hlpoccu.mem")
   HlpNo=0
   dbfuse = hosp_dir+'occupat'
   USE (hosp_dir+'occupat') ORDER 1
   dbfuse = ''
   DO WHIL ! EOF()
      HlpNo=HlpNo+1
      ProvName(HlpNo)=TRIM(name)
      ProvCode(HlpNo)=occupa
      skip
   ENDD
   DIME HlpCode(HlpNo),HlpName(HlpNo)
   xx=1
   DO WHIL xx<=HlpNo
      HlpCode(xx)=ProvCode(xx)
      HlpName(xx)=ProvName(xx)
      xx=xx+1
   ENDD
   mfile=hosp_dir+'HlpOccu'
   SAVE ALL LIKE Hlp* TO &mfile
   RELEASE ALL LIKE Hlp*
ENDI
IF ! FILE(hosp_dir+"hlpnati.mem")
   HlpNo=0
   dbfuse = hosp_dir+'nation'
   USE (hosp_dir+'nation') ORDER 1
   dbfuse = ''
   DO WHIL ! EOF()
      HlpNo=HlpNo+1
      ProvName(HlpNo)=TRIM(name)
      ProvCode(HlpNo)=code
      skip
   ENDD
   DIME HlpCode(HlpNo),HlpName(HlpNo)
   xx=1
   DO WHIL xx<=HlpNo
      HlpCode(xx)=ProvCode(xx)
      HlpName(xx)=ProvName(xx)
      xx=xx+1
   ENDD
   mfile=hosp_dir+'HlpNati'
   SAVE ALL LIKE Hlp* TO &mfile
   RELEASE ALL LIKE Hlp*
ENDI
PROC GETKEY
* FORMAT: DO GETKEY WITH string,numeric1,numeric2
* ใช้ READ ตัวแปร string แล้วเขียนค่าลงไปในแถว numeric1,สดมภ์ numeric2
* ต้องกำหนดค่าต่างๆไว้ก่อนในโปรแกรมที่เรียกโมดูลนี้ คือ
* KQ = ค่าที่อ่านได้จาก READKEY()  กำหนดไว้เป็น 1
* FQ = ค่าที่จะบอกว่าจะกลับไปอ่านฟิลด์ไหน
* FMIN = ค่าต่ำสุดของฟิลด์  ปกติมักเป็น 1
* FMAX = ค่ำสูงสุดของฟิลด์ที่จะมีได้
PARA _var,_row,_col
READ NOLOCK
kq=MOD(READKEY(),256)	  && ดูว่า KEY ที่ออกจากการ READ เป็นอะไร
Do CASE
   CASE kq=15	  && [RETURN]
      fq=IIF(fq<fmax,fq+1,-1)
   CASE kq=5	  &&[Up]
      fq=IIF(fq<fmax,fq+1,fmin)
   CASE kq=4	  && [DOWN]
      fq=IIF(fq>fmin,fq-1,fmax)
   CASE kq=12	  && [Esc]
      fq=-1
   CASE kq=2	  && [HOME]
      fq=fmin
   CASE kq=3	  && [END]
      fq=fmax
   CASE kq=14	  && [Ctrl-W]
      fq=-1
ENDCASE
RETU

PROC TRUEDATE
* FORMAT: var = TRUEDATE(string)
* ใช้ตรวจสอบว่า วันเดือนปี ที่ใส่เป็นพุทธศักราช เป็นวันที่ถูกต้องหรือไม่
* ตัวแปรที่ผ่านค่ามาเป็น character ในรูปแบบ วว/ดด/ปปปป
* จะคืนค่าเป็น Logical value
PARAMETER _str,_dateshow
PRIVATE _date,_mret,_para
_para = PARAMETERS()
IF LEFT(_str,2)='  '
	RETU .T.
ENDI
_date = CTOD(LEFT(_str,6)+IIF(LEN(_str)=10,STR(VAL(RIGHT(_str,4))-543,4),RIGHT(STR(VAL(RIGHT(_str,2))+1957),4)))
_mret = DAY(_date) > 0
*susp
IF _mret .AND. _para > 1
	_dateshow = CE2CBE(_date)
	SHOW GETS
ENDI
RETU _mret

PROC BE2CE
* FORMAT: var = BE2CE(string)
* เปลี่ยนวันที่จาก character พุทธศักราชเป็น date คริสต์ศักราช
PARAMETER _str
PRIVATE _dates
_dates = LEFT(_str,6)+IIF(LEN(_str)=10,STR(VAL(RIGHT(_str,4))-543,4),RIGHT(STR(VAL(RIGHT(_str,2))+1957),4))
RETU CTOD(_dates)

PROC CE2CBE
* FORMAT: var = CE2CBE(date,s)
* เปลี่ยนวันที่ของปีคริสต์ศักราช เป็น character ปีพุทธศักราช
PARA _str,_short
EXTERNAL ARRAY Tmonth
IF EMPTY(_str)
	RETU SPACE(14)
ELSE
	IF PARAMETER() = 2 AND TYPE('_short') = 'N'
		RETU LTRIM(STR(DAY(_str)))+' '+Tmonth(MONTH(_str))+' '+RIGHT(STR(YEAR(_str)+543,4),_short)
	ELSE
		RETU LTRIM(STR(DAY(_str)))+' '+Tmonth(MONTH(_str))+' '+STR(YEAR(_str)+543,4)
	ENDI
ENDI

PROC HEADER
* FORMAT: var = HEADER()
* หาจำนวนไบต์ของหัวแฟ้มข้อมูล
RETU 32+32*FCOUNT()

FUNC LENTHAI  && นับความยาวของคำหรือประโยคไทย โดยตัดสระบนและล่างออก
PARA _string
PRIVATE num,i
num=0
FOR i = 1 TO LEN(_string)
   num=IIF(SUBS(_string,i,1) $ 'ุ ู ึ ั ํ ิ ์ ื ่ ๋ ี๊ ้ ็'.AND. _string # ' ',num,num+1)
NEXT
RETU (num)

FUNC CENTER	&& ใช้สำหรับหาสดมภ์เพื่อเขียนข้อความให้อยู่กึ่งกลาง
PARA _string,_numcol
PRIVATE numthai,num,col,numcol,numpara
numpara=PARAMETERS()
numthai=Lenthai(TRIM(_string))
num=LEN(TRIM(_string))
numcol=IIF(numpara=2,_numcol,WCOLS())
col=INT((numcol/2)-(numthai/2))
col=IIF((col+num)>=(numcol-1),INT((numcol-1-num)/2),col)
RETU (col)

PROC PADBLANK
* FORMAT: string = PADBLANK(string 1,numeric)
* เติมช่องว่างหน้า string 1 จนมีความยาวเท่ากับ numeric
PARA _str,_num
_past = IIF(PARAMETERS() = 1,LEN(_str),_num)
RETU RIGHT('         '+LTRIM(RTRIM(_str)),_past)

PROC BOTTMESS
* FORMAT: DO BOTTMESS WITH string
* แสดงข้อความที่กึ่งกลางบรรทัดสุดท้าย
PARA _mess
PRIVATE _col
ACTI SCREE
@ 23,0
_col=Center(_mess)
@ 23,_col SAY _mess COLO ggr+/b

PROC BIRTHDAT
* FORMAT: var=BIRTHDAT(var1)
* ใช้สำหรับเปลี่ยนอายุเป็นวันเดือนปีเกิดเป็นปีพุทธศักราช โดย
* var1= XX ปี หรือ XX/12 ปี(เดือน) หรือ XX/365 ปี(วัน)
PARA _str
PRIVATE mday,deli_day
IF RIGHT(_str,3)='   '
   mday=VAL(_str)*365+182
ELSE
   IF SUBS(_str,4,2)='12'
      mday=VAL(SUBS(_str,1,2))*31+15
   ELSE
      mday=VAL(SUBS(_str,1,2))
   ENDI
ENDI
deli_day=DATE()-mday
deli_day= STRZERO(DAY(deli_day),2)+'/'+STRZERO(MONTH(deli_day),2)+'/';
+STR(YEAR(deli_day)+543,4)
IF RIGHT(_str,3)='   '
	deli_day='01/07/'+STR(YEAR(DATE())-VAL(LEFT(_str,2))+543,4)
ENDI
RETU deli_day

PROC LISTHELP
* FORMAT: DO LISTHELP
* Pop up ข้อมูลในแฟ้มที่เลือกไว้ โดยจะใช้ index order ที่ 2
* สามารถใช้คีย์ลูกศรขึ้นลง หรือ PgUp,PgDn,Backspace, หรือจะพิมพ์ชื่อลงไปทีละ
* ตัวอักษร  เลือกโดยการกด Enter
PRIVATE oldcolor,PreScr,Bott_mess,mhn,thn,PreName,NextName,Gname,BottName
PRIVATE FirstName
SET ORDER TO 2
Gname=''
oldcolor=Setcolor('')
@ 22,0 CLEA
field1=FIELD(1)
field2=FIELD(2)
top_line=6
bott_line=17
bott_rec=0
top_rec=0
top_col=21
bott_col=59
bott_mess='[Enter]=เลือก    [ลูกศร]=เลื่อนขึ้นลง  [ตัวอักษร]=ค้นหา'
@ top_line-2,20 TO bott_line+2,60
@ top_line-1,21 CLEA TO bott_line+1,59
DO bottmess WITH bott_mess
last_line=5
GO BOTT
last_record=recno()
GO TOP
firstname=name
first_recor=recno()
top_rec=first_recor
IF ! EOF()
   DO paint_hs
ENDI
curr_line=top_line
@ curr_line,23 SAY FirstName
@ bott_line+1,23 SAY SPAC(LEN(name))
GO Bott_rec
BottName=name
GO top
SKIP
NextName=name
SKIP -1
mkey=0
mhn=''
DO WHIL mkey<>13
   mkey=inkey(10)
   DO bottmess WITH bott_mess
   DO CASE
      CASE mkey=5		 &&  Up arrow
	 IF RECNO()=first_recor
	    ?? CHR(7)
	    DO bottmess WITH 'ขณะนี้อยู่ในรายชื่อแรกอยู่แล้ว'
	 ELSE
	    @ curr_line,23 SAY name
	    IF curr_line>top_line
	       curr_line=curr_line-1
	       @ curr_line,23 SAY PreName
	       NextName=name
	       Skip -1
	    ELSE
	       SCROLL top_line,23,bott_line,59,-1
	       @ curr_line,23 SAY PreName
	       IF last_line<bott_line
		  last_line=last_line+1
	       ELSE
		  GO bott_rec
		  Gname=name
		  skip -1
		  bott_rec=RECNO()
		  bottname=name
	       ENDI
	       GO top_rec
	       NextName=name
	       SKIP -1
	       top_rec=RECNO()
	       firstname=name
	    ENDI
	    IF RECNO()<>First_recor
	       SKIP -1
	       PreName=name
	       SKIP
	    ELSE
	       PreName=''
	    ENDI
	 ENDI
      CASE mkey=24		 &&  Down arrow
	 IF RECNO()=last_record
	    ?? CHR(7)
	    DO bottmess WITH 'ขณะนี้อยู่ในชื่อสุดท้ายอยู่แล้ว'
	 ELSE
	    @ curr_line,23 SAY name
	    IF curr_line<bott_line
	       curr_line=curr_line+1
	       @ curr_line,23 SAY NextName
	       Prename=name
	       SKIP 1
	    ELSE
	       SCROLL top_line,23,bott_line,59,1
	       @ curr_line,23 SAY NextName
	       PreName=name
	       GO top_rec
	       SKIP
	       top_rec=RECNO()
	       FirstName=name
	       GO bott_rec
	       SKIP
	       bott_rec=RECNO()
	       bottname=name
	    ENDI
	    IF RECNO()<>Last_record
	       SKIP
	       NextName=name
	       SKIP -1
	    ELSE
	       NextName=''
	    ENDI
	 ENDI
      CASE mkey=3		   && [PgDn]
	 IF bott_rec=last_record
	    ?? CHR(7)
	    DO bottmess WITH 'ไม่มีรายชื่อถัดจากนี้อีกแล้ว'
	 ELSE
	    GO bott_rec
	    PreName=name
	    SKIP
	    top_rec=RECNO()
	    DO paint_hs
	    @ curr_line,23 SAY FirstName
	    GO Bott_rec
	    BottName=name
	    GO top_rec
	    SKIP
	    NextName=name
	    SKIP -1
	 ENDI
      CASE mkey=18		    && [PgUp]
	 IF top_rec=first_recor
	    ?? CHR(7)
	    DO bottmess WITH 'ไม่มีรายชื่อก่อนหน้านี้อีกแล้ว'
	 ELSE
	    GO top_rec
	    SKIP -12
	    IF BOF()
	       GO TOP
	    ENDI
	    top_rec=RECNO()
	    DO paint_hs
	    @ curr_line,23 SAY FirstName
	    GO Bott_rec
	    BottName=name
	    GO top_rec
	    SKIP
	    NextName=name
	    SKIP -1
	    IF RECNO()<>FIRST_RECOR
	       SKIP -1
	       PreName=name
	       SKIP
	    ELSE
	       Prename=''
	    ENDI
	 ENDI
      CASE mkey=1		 && [Home]
	 @ curr_line,23 SAY name
	 curr_line=top_line
	 @ curr_line,23 SAY FirstName
	 GO top_rec
	 IF RECNO()<>First_recor
	    SKIP -1
	    PreName=name
	    SKIP
	 ENDI
	 SKIP
	 NextName=name
	 SKIP -1
      CASE mkey=6		 && [End]
	 @ curr_line,23 SAY name
	 curr_line=last_line-1
	 @ curr_line,23 SAY BottName
	 GO bott_rec
	 IF RECNO()<>Last_record
	    SKIP
	    NextName=name
	    SKIP -1
	 ENDI
	 SKIP -1
	 PreName=name
	 SKIP
      CASE mkey=127
	 IF LEN(mhn)>=1
	    mhn=LEFT(mhn,LEN(mhn)-1)
	    SEEK mhn
	    top_rec=RECNO()
	    DO paint_hs
	    @ curr_line,23 SAY FirstName
	    @ bott_line+1,23 say mhn+' '
	    GO Bott_rec
	    BottName=name
	    GO top_rec
	    IF RECNO()<>First_recor
	       SKIP -1
	       Prename=name
	       SKIP
	    ENDi
	    SKIP
	    NextName=name
	    SKIP -1
	 ENDI
      CASE mkey>=32
	 thn=mhn+CHR(mkey)
	 old_rec=RECNO()
	 IF ! SEEK(thn)
	    GO old_rec
	 ELSE
	    mhn=thn
	    top_rec=RECNO()
	    DO paint_hs
	    @ curr_line,23 SAY FirstName
	    @ bott_line+1,23 say mhn
	    GO Bott_rec
	    BottName=name
	    GO top_rec
	    IF RECNO()<>First_recor
	       SKIP -1
	       Prename=name
	       SKIP
	    ENDi
	    SKIP
	    NextName=name
	    SKIP -1
	 ENDI
   ENDC
ENDD
SET ORDER TO 1
KEYB &field1

PROC PAINT_HS
* เป็นโปรแกรมย่อยถูกเรียกโดย LISTHELP เพื่อเขียนข้อมูลบนจอ
last_line=6
@ top_line,top_col CLEA TO bott_line,bott_col
FirstName=name
DO WHIL ! EOF() .AND. last_line<=bott_line
   @ last_line,23  SAY name
   bott_rec=RECNO()
   SKIP
   last_line=last_line+1
ENDD
curr_line=top_line
Gname=name

PROC NOWAGE
* FORMAT var=NOWAGE(date)
* ใช้สำหรับหาอายุปัจจุบันโดยการส่งค่าวันเดือนปีเกิดมาให้ แล้วจะเทียบกับวันที่ขณะนี้
PARA _age,_derive
IF ! EMPTY(_age)
	PRIVATE _mage
	_mage=DATE()-_age
	IF PARAMETERS() > 1
		IF _derive='2' .AND. _mage >=365
			RETU LTRIM(STR(YEAR(DATE())-YEAR(_age)))+' ปี      '
		ENDI
	ENDI
	DO CASE
		CASE _mage<=30
			RETU STR(_mage,2)+' วัน     '
		CASE _mage<=365
			RETU STR(INT(_mage/31),2)+' เดือน   '
		OTHER
			_mage = INT(_mage/365)
			RETU IIF( _mage>99, '99', STR(_mage,2) ) +' ปี      '
	ENDC
ELSE
	RETU SPACE(11)
ENDI

PROC SETCOLOR
* FORMAT: oldcolor=SETCOLOR(newcolor)
* เปลี่ยน attribute ของจอตาม newcolor และส่งค่า attribute เดิมให้ oldcolor
PARA _str
PRIVATE mcolor
mcolor=SYS(2001,"COLOR")
RETU mcolor

PROC POP_HELP
mchoice=0
SET CONF ON
= THAIMODE()
DO WHIL mchoice=0
   @  10,20 MENU HlpName,HlpNo,10 TITLE mtitle
   READ MENU TO mchoice
ENDD
= ENGMODE()
SET CONF OFF
KEYB HlpCode(mchoice)

FUNC CE2BE
PARA _date,_number
PRIV para
para = PARAMETERS()
_m=SYS(2001,'CENTURY')
_d=SYS(2001,'DATE',1)
SET CENTURY ON
SET DATE BRITISH
_ret=DTOC(_date)
_ret=IIF(EMPTY(_date),DTOC(_date),LEFT(_ret,6)+STR(VAL(RIGHT(_ret,4))+543,4))
_ret=IIF(para=2 .AND. _number=2,LEFT(_ret,6)+RIGHT(_ret,2),_ret)
SET DATE &_d
SET CENTURY &_m
RETU _ret

FUNC DE_NAME
PARA _name
_len=LEN(_name)
_var=TRIM(_name)
_at=AT(',',_name)
RETU IIF(_at=0,_name,SUBS(_var,_at+1)+LEFT(_var,_at-1)+SPAC(_len-LEN(_var)+1))

FUNC AddHelp
PRIV maddhelp
DEFINE WIND addhelp FROM 6,15 TO 9,64 SHAD COLO gr+/b
ACTI WIND addhelp
maddhelp='Y'
@ 1,5 SAY 'ต้องการเพิ่มเติมรหัสช่วยเหลือหรือไม่ ' GET maddhelp PICT '!'
READ NOLOCK
RELE WIND addhelp
RETU maddhelp $ 'Yํั'

FUNC AddHelpName
PRIV addhelpname,confirm
DEFINE WIND addhelp FROM 6,5 TO 12,74 SHAD COLO gr+/b
ACTI WIND addhelp
confirm=.F.
DO WHIL ! confirm
	confirm=.T.
	@ 1,1 SAY 'ชื่อเต็มของรหัสที่เพิ่มคือ ' GET addhelpname WHEN THAI() ;
	DEFA SPAC(LEN(name))
	@ 3,15 SAY 'ชื่อนี้ถูกต้องแน่' GET confirm DEFA '.T.' PICT 'Y' ;
	WHEN ENGLISH()
	READ NOLOCK
ENDD
RELE WIND addhelp
RETU addhelpname

FUNC THAIMODE
*IF thaipro
*	CALL thikey
*	ON KEY LABEL F10 CALL engkey
*ENDI

FUNC THAI
@ 1,0 SAY IIF(microwiz,CHR(155)+'KT','')

FUNC ENGLISH
@ 1,0 SAY IIF(microwiz,CHR(155)+'KE','')

FUNC ENGMODE
*IF thaipro
*	CALL engkey
*	ON KEY LABEL F10
*ENDI

FUNC REMOVEBLANK
PARA _remove
_removal=ALLTRIM(_remove)
RETU _removal+SPACE(LEN(_remove)-LEN(_removal))

PROC OpdLAN
@ 3,0 CLEA TO 20,80
@ 5,15 SAY 'รหัสโรงพยาบาล      ' GET hosp_code DEFA SPAC(5) PICT '@!' WHEN ENGLISH() ;
VALID Hospital(hosp_code,hosp_name)
@ 7,15 SAY 'ชื่อโรงพยาบาล      ' GET hosp_name DEFA SPAC(30) WHEN THAIMODE()
@ 9,15 SAY 'สถานที่ตั้ง        ' GET hosp_addr1 DEFA SPAC(30) WHEN THAIMODE()
@ 11,15 SAY '                   ' GET hosp_addr2 DEFA SPAC(30) WHEN THAIMODE()
@ 13,15 SAY 'รหัสไปรษณีย์       ' GET hosp_zip DEFA SPAC(5) PICT '99999' WHEN ENGMODE()
@ 15,15 SAY 'รหัสจังหวัด        ' GET hosp_province DEFA '  ' PICT '99' WHEN ENGMODE()
@ 17,15 SAY 'หมายเลขโทรศัพท์    ' GET hosp_tel DEFA SPAC(10) WHEN ENGMODE()
@ 19,15 SAY 'หมายเลขโทรสาร      ' GET hosp_fax DEFA SPAC(10) WHEN ENGMODE()
READ NOLOCK
=EngMODE()
SAVE ALL LIKE hosp_* TO (patientdir+'opdlan')

FUNC Hospital
PARA _code,_name
IF ! FILE(codedir+'hospcode.dbf')
	?? CHR(7)
	CLEA
	@ 10,20 SAY 'ไม่สามารถหาแฟ้ม '+'hospcode.dbf' COLO r+
	CANC
ENDI
IF ! USED('hospcode')
	SELE 0
	dbfuse = codedir+'hospcode'
	USE (codedir+'hospcode') ORDER 1
ELSE
	SELE hospcode
	SET ORDER TO 1
ENDI
dbfuse = ''
IF ! EMPTY(_code)
	IF ! SEEK(_code)
		?? CHR(7)
		WAIT WIND 'ไม่มีสถานพยาบาลรหัส '+_code NOWAIT
		RETU 0
	ENDI
	_code= off_id
	_name=DE_NAME(name)
	SHOW GETS
ENDI

FUNC Hospital1
PARA _code,_name
IF ! FILE(codedir+'hospcode.dbf')
	?? CHR(7)
	CLEA
	@ 10,20 SAY 'ไม่สามารถหาแฟ้ม '+'hospcode.dbf' COLO r+
	CANC
ENDI
IF ! USED('hospcode')
	SELE 0
	dbfuse = codedir+'hospcode'
	USE (codedir+'hospcode') ORDER 1
ELSE
	SELE hospcode
	SET ORDER TO 1
ENDI
dbfuse = ''
IF LEN(TRIM(_code))= 5 AND ISDIGIT(_code)
	IF ! SEEK(_code)
		?? CHR(7)
		WAIT WIND 'ไม่มีสถานพยาบาลรหัส '+_code NOWAIT
		_seek=ProvPop(0,30)
		_seek1=HospType()
		_seek=_seek+STR(_seek1,1)
		=FindHosp(_seek)
	ENDI
ELSE
	_seek=LEFT(_code,3)
	SET ORDER TO 2
	IF RIGHT(_seek,1)=' '
		_seek=LEFT(_seek,2)
		IF EMPTY(_seek) .OR. ! SEEK(_seek)
			_seek=ProvPop(0,30)
		ENDI
		_seek1=HospType()
		_seek=_seek+STR(_seek1,1)
	ENDI
	=FindHosp(_seek)
	SET ORDER TO 1
ENDI
_code=code
_name=DE_NAME(name)
SHOW GETS

FUNC HospType
DEFINE WIND hosptype FROM 08,40 TO 14,70 SHAD COLO w+/gr TITLE ;
'  เลือกประเภทสถานพยาบาล  '
ACTI WIND hosptype
_ch=0
DO WHIL _ch=0
	@ 1,5 PROMPT '1. สสจ. รพศ. รพท'
	@ 2,5 PROMPT '2. รพช. รพร.'
	@ 3,5 PROMPT '3. สถานีอนามัย สสอ.'
	@ 4,5 PROMPT '4. อื่น ๆ '
	MENU TO _ch
ENDD
RELE WIND hosptype
RETU _ch


FUNC FindHosp
PARA _var
IF USED("HOSPCODE")
	SELE hospcode
ELSE
	SELE 0
	dbfuse = codedir+'hospcode'
	USE (codedir+'hospcode')
ENDI
dbfuse = ''
SET ORDER TO 2
IF SEEK(_var)
	IF RIGHT(_var,1)>'2'
		DEFINE POPUP findhosp FROM 7,5 TO 17,70 PROMPT FIELD name+'  '+SUBS(code,7,2) ;
		COLO SCHE 4 SHAD
	ELSE
		DEFINE POPUP findhosp FROM 7,5 TO 17,70 PROMPT FIELD name ;
		COLO SCHE 4 SHAD
	ENDI
	SET FILTER TO level = _var
	ACTI SCREE
	ON SELECTION POPUP findhosp DO choosehosp
	SET CONF ON
	ACTI POPUP findhosp
ELSE
	?? CHR(7)
	WAIT WIND 'ไม่สามารถหาสถานบริการตามต้องการได้' NOWA
	_CUROBJ=_CUROBJ
ENDI
SET ORDER TO 1
*SET COLO TO bg+/b

PROC CHOOSEHOSP
SET FILT TO
SET ORDER TO 1
SET CONF OFF
DEAC POPUP findhosp
RELE POPUP findhosp

FUNC VDIR
hosp_dir=ALLTRIM(hosp_dir)
IF LEN(hosp_dir)>0
	hosp_dir=IIF(LEN(hosp_dir)=1,hosp_dir+':',hosp_dir)
	hosp_dir=IIF( ! RIGHT(hosp_dir,1) $ ':\',hosp_dir+'\',hosp_dir)
ENDI

FUNC EntryDir
hosp_dir=hosp_dir+SPAC(30-LEN(hosp_dir))
=English()

FUNC CancelPrint
_cancelprint=.F.
_printer=SET('PRINT')
_console=SET('CONSOLE')
SET PRINT OFF
SET CONS ON
DO WHIL ! PRINTSTATUS() .AND. ! _cancelprint
	?? CHR(7)
	WAIT WIND 'เครื่องพิมพ์ยังไม่พร้อม โปรดแก้ไข หรือกดปุ่ม [ESC] ยกเลิกการพิมพ์'
	mkey=LASTKEY()
	_cancelprint=IIF(mkey=27,.T.,.F.)
ENDD
SET PRINT &_printer
SET CONS &_console
RETU _cancelprint

PROC SearchHelp
PRIVATE xx,mchoice
DIME tempname(150),tempicd(150)
xx=1
*SET ORDER TO 0
SCAN FOR ! EMPTY(name)
	TempName(xx)=name
	TempICD(xx)=RECNO()
	xx=xx+1
	IF xx > 150
		DIME tempname(xx),tempicd(xx)
	ENDI
ENDS
mchoice=0
SET CONF ON
DEFINE WIND showsearch from 5,20 TO 20,60 NONE SHAD
ACTI WIND showsearch
DO WHIL mchoice=0
	@  1,4 MENU TempName,xx-1,10
	READ MENU TO mchoice
ENDD
SET CONF OFF
RELE WIND showsearch
IF mchoice=0
	GO BOTT
	SKIP
ELSE
	GO TempICD(mchoice)
ENDI
SET ORDER TO 1

PROC StartSet
SET TALK OFF
SET ECHO OFF
SET BELL OFF
SET STAT OFF
SET SCOR OFF
SET SAFE OFF
SET CLOCK TO 0,0
SET CLOCK ON
SET DATE BRITISH
SET CENT ON
SET EXCLU OFF
SET ESCA OFF
SET UDFPARMS TO REFERENCE
SET CONF OFF
SET SYSMENU off
SET AUTOSAVE ON
SET MEMO TO 70
CLOSE DATA
DEAC WIND ALL
PUSH KEY CLEA
ON KEY
ACTI SCREE
=INSMODE(.F.)
=NUMLOCK(.T.)
PUBL Tmonth(12),month01,month02,month03,month04,month05,month06,month07,;
month08,month09,month10,month11,month12
PUBL derive1,derive2,sex1,sex2,marry1,marry2,marry3,marry4,marry5,marry6,microwiz
Tmonth(1) = 'ม.ค.'
Tmonth(2) = 'ก.พ.'
Tmonth(3) = 'มี.ค.'
Tmonth(4) = 'เม.ย.'
Tmonth(5) = 'พ.ค.'
Tmonth(6) = 'มิ.ย.'
Tmonth(7) = 'ก.ค.'
Tmonth(8) = 'ส.ค.'
Tmonth(9) = 'ก.ย.'
Tmonth(10) = 'ต.ค.'
Tmonth(11) = 'พ.ย.'
Tmonth(12) = 'ธ.ค.'
MONTH01='มกราคม'
MONTH02='กุมภาพันธ์'
MONTH03='มีนาคม'
MONTH04='เมษายน'
MONTH05='พฤษภาคม'
MONTH06='มิถุนายน'
MONTH07='กรกฎาคม'
MONTH08='สิงหาคม'
MONTH09='กันยายน'
MONTH10='ตุลาคม'
MONTH11='พฤศจิกายน'
MONTH12='ธันวาคม'
derive1='ได้'
derive2='ไม่'
marry1='โสด  '
marry2='สมรส '
marry3='หม้าย'
marry4='หย่า '
marry5='แยก  '
marry6='สมณะ '
sex1='ชาย '
sex2='หญิง'
*microwiz = UPPE(GETENV('THAICARD'))='MICROWIZ'
*? CHR(155)+'CD2'
*? CHR(155)+'KS'
*?chr(155)+'K2'+CHR(0)+CHR(74)
*IF UPPE(GETENV('THAICARD'))=='MICROWIZ'
*	? CHR(155)+'KL5'
*ENDI
DO Colorset WITH ISCOLOR() && udc

PROC EndSet
CLOSE DATA
*=English()
SET SYSMENU AUTO
ON KEY
ON ERROR
SET ESCA ON
SET TALK ON
=INSMODE(.T.)
SET UDFPARMS TO VALUE
POP KEY
SET RESO ON

FUNC TITLE
********************************************************************************
* โมดูลสำหรับแสดงข้อความที่บรรทัดบน เพื่อให้ทราบว่ากำลังทำงานรายการไหนอยู่     *
********************************************************************************
PARA _title
PRIVATE col
ACTI SCREE
@ 1,18
col=Center(_title)
@ 1,col SAY _title COLO gr+/b

PROC COLORSET1
PARA _Colorset
IF _Colorset
	SET BLINK OFF
	SET COLOR OF SCHEME 1 TO ;
		W+/B,W+/B,W+/BG,W+/BG,W/BG,B+/W*,r+/BG,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 2 TO ;
		W+/BG,W+/B,BG+/BG,BG+/BG,BG/N*,B/W*,W+/R,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 3 TO ;
		W/BG,N/BG,R/G,R/G,R/G,W+/B,W+/BG,R/G,R/G,R/G,+
	SET COLOR OF SCHEME 4 TO ;
		W+/BG,N/BG,BG+/BG,R/G,R/G,W+/B,W+/BG,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 5 TO ;
		N/BG,W+/N,BG+/BG,R/G,R/G,B+/W*,W+/BG,N+/N,N/BG,W/BG,+
	SET COLOR OF SCHEME 6 TO ;
		W/W*,N/W*,B/W*,R/G,R/G,W+/B,R/G,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 7 TO ;
		N/BG,R/G,BG+/BG,W+/N,R/G,W+/B,W+/BG,N+/N,N/BG,W/BG,+
	SET COLOR OF SCHEME 8 TO ;
		W+/B,W+/N,W+/BG,W+/B,R/G,B+/W*,BG+/B,N+/N,W+/B,W/B,+
	SET COLOR OF SCHEME 9 TO ;
		W/W*,N/W*,B/W*,R/G,R/G,W+/B,R/G,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 10 TO ;
		W+/B,W+/N,W+/BG,W+/BG,W/BG,B+/W*,W+/BG,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 11 TO ;
		W+/B,W+/N,W+/BG,W+/BG,W/BG,B+/W*,BG+/BG,N+/N,W+/B,N/BG,+
	SET COLOR OF SCHEME 12 TO ;
		W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
ELSE
	SET COLOR OF SCHEME 1 TO W/N,N/W,W+/N,W+/N,W/N,W/N,N/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 2 TO W/N,W+/N,W+/N,W+/N,N/W,N+/W,W+/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 3 TO N/W,N/W,N/W,W+/N,N+/W,W+/N,N+/W,N+/N,W+/N,N+/W
	SET COLOR OF SCHEME 4 TO W/N,W+/N,W+/N,W+/N,W/N,N+/W,W+/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 5 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,W+/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 6 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,W+/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 7 TO N+/W,W/N,N/W,N+/W,N/W,W+/N,W+/W,N+/N,N+/W,N/W
	SET COLOR OF SCHEME 8 TO W/N,W+/N,N/W,N+/W,N/W,N/W,W+/N,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 9 TO W/N,W+/N,W+/N,N+/W,N/W,N/W,N/W,N+/N,N+/W,N/W
	SET COLOR OF SCHEME 10 TO W/N,N/W,N/W,N/W,W/N,W+/N,N/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 11 TO W/N,N/W,W+/N,W+/N,W/N,W/N,N/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 12 TO W/N,N+/W,W+/N,W+/N,W/N,W+/N,W+/N,N+/N,W+/N,W/N
ENDI
AtrBackGr = IIF( _Colorset , [N/W*]		  , [W+/N,N/W] )
AtrScreen = IIF( _Colorset , [GR+/B,N/W]	  , [W+/N,N/W] )
AtrData   = IIF( _Colorset , [W+/BR+,N/W]	  , [W/N,W+/N] )
AtrMenu   = IIF( _Colorset , [W+/B,W+/BR]	  , [W+/N,N/W] )
AtrMenu2  = IIF( _Colorset , [N/W+,W+/R]	  , [W+/N,N/W] )
RETU
FUNC FULLYEAR
PARA _year
PRIVATE year,myear,myear1,_xx
DO CASE
	CASE TYPE('_year')='C'
		_xx=RIGHT(_year,2)
	CASE TYPE('_year')='D'
		_xx=IIF(DATE()-_year>5000,RIGHT(DTOC(_year),2),RIGHT(STR(YEAR(_year)+543),2))
	OTHER
		_xx=STRZERO(_year,2)
ENDC
myear=YEAR(date())+543
myear1=LEFT(STR(myear,4),2)
year=myear1+_xx
mret = IIF(VAL(year)-myear>9,STR(VAL(myear1)-1,2)+_xx,year)
RETU IIF(TYPE('_year') = 'C' .AND. LEN(_year) = 8,LEFT(_year,6)+mret,mret)

PROC COLORSET
PARA _Colorset
*susp
IF _Colorset
	SET BLINK OFF
	SET COLOR OF SCHEME 1 TO ;
		W+/B,W+/,W+/BG,W+/BG,GR+,B+6W,r+/BG,N+/N,R/G,R/G,+
*SET COLOR OF SCHEME 1 TO ;
*	W+/B,W+/BG,W+/BG,W+/BG,gr+,B+/W,BG+/BG,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 2 TO ;
		GR+/w,W+/B,BG+/BG,BG+/BG,gr+/r,gr+/r+,W+/R,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 3 TO ;
		W/BG,N/BG,R/G,R/G,R/G,r+/g,W+/BG,R/G,R/G,R/G,+
	SET COLOR OF SCHEME 4 TO ;
		W+/BG,N/BG,BG+/BG,R/G,R/G,r+/B,W+/BG,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 5 TO ;
		N/BG,W+/N,BG+/BG,R/G,R/G,B+/W,W+/BG,N+/N,N/BG,W/BG,+
	SET COLOR OF SCHEME 6 TO ;
		W/W,N/W,B/W,R/G,R/G,W+/B,R/G,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 7 TO ;
		N/BG,R/G,BG+/BG,W+/N,R/G,W+/B,W+/BG,N+/N,N/BG,W/BG,+
	SET COLOR OF SCHEME 8 TO ;
		W+/B,W+/N,W+/BG,W+/B,R/G,B+/r,BG+/B,N+/N,W+/B,W/B,+
	SET COLOR OF SCHEME 9 TO ;
		W/W,N/W,B/W,R/G,R/G,W+/B,R/G,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 10 TO ;
		W+/B,W+/N,W+/BG,W+/BG,W/BG,B+/W,W+/BG,N+/N,R/G,R/G,+
	SET COLOR OF SCHEME 11 TO ;
		W+/B,W+/N,W+/BG,W+/BG,W/BG,B+/W,BG+/BG,N+/N,W+/B,N/BG,+
	SET COLOR OF SCHEME 12 TO ;
		W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+
ELSE
	SET COLOR OF SCHEME 1 TO W/N,N/W,W+/N,W+/N,W/N,W/N,N/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 2 TO W/N,W+/N,W+/N,W+/N,N/W,N+/W,W+/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 3 TO N/W,N/W,N/W,W+/N,N+/W,W+/N,N+/W,N+/N,W+/N,N+/W
	SET COLOR OF SCHEME 4 TO W/N,W+/N,W+/N,W+/N,W/N,N+/W,W+/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 5 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,W+/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 6 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,W+/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 7 TO N+/W,W/N,N/W,N+/W,N/W,W+/N,W+/W,N+/N,N+/W,N/W
	SET COLOR OF SCHEME 8 TO W/N,W+/N,N/W,N+/W,N/W,N/W,W+/N,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 9 TO W/N,W+/N,W+/N,N+/W,N/W,N/W,N/W,N+/N,N+/W,N/W
	SET COLOR OF SCHEME 10 TO W/N,N/W,N/W,N/W,W/N,W+/N,N/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 11 TO W/N,N/W,W+/N,W+/N,W/N,W/N,N/W,N+/N,W+/N,W/N
	SET COLOR OF SCHEME 12 TO W/N,N+/W,W+/N,W+/N,W/N,W+/N,W+/N,N+/N,W+/N,W/N
ENDI
AtrBackGr = IIF( _Colorset , [N/W]		 , [W+/N,N/W] )
AtrScreen = IIF( _Colorset , [GR+/B,N/W]	  , [W+/N,N/W] )
AtrData   = IIF( _Colorset , [W+/BR+,N/W]	  , [W/N,W+/N] )
AtrMenu   = IIF( _Colorset , [W+/B,W+/BR]	  , [W+/N,N/W] )
AtrMenu2  = IIF( _Colorset , [N/W+,W+/R]	  , [W+/N,N/W] )
RETU

PROC ShowProgress
DEFINE WIND progress FROM 8,15 TO 15,65 SHAD COLO gr+/b+
ACTI WIND progress
msg='โปรดคอย กำลังคำนวณข้อมูลอยู่'
@ 0,Center(msg) SAY msg COLO r
@ 2,3 TO 4,45

PROC CLEARSCREEN
@ 3,0 TO 22,79 CLEA

PROC SELEMONI
DO Clearscreen
DEFINE WIND monitor FROM 4,10 TO 10,60 SHAD TITLE '  เลือกชนิดจอภาพ  '
ACTI WIND monitor
DIME monitor[2]
monitor[1] = 'จอภาพแบบสีเดียว (MONOCHROME)'
monitor[2] = 'จอภาพแบบหลายสี (COLOR)'
selemon = 1
@ 1,4 GET selemon FROM monitor
READ NOLOCK
IF LASTKEY() # 27
	DO Colorset WITH IIF(selemon=1,.F.,.T.)
ENDI
RELE WIND monitor

PROC HELPEDIT
PARA _file
PRIVATE oldcolor,PreScr,Bott_mess
EXTERNAL ARRAY EhelpMess
ON KEY LABEL CTRL+E DO ChangeHelp WITH .F.
ON KEY LABEL CTRL+N DO ChangeHelp WITH .T.
ON KEY LABEL CTRL+D DO SUREDELETE
IF USED(_file)
	SELE (_file)
	SET ORDER TO 1
	old_use=.T.
ELSE
	SELE 0
	mselect=codedir+_file
	dbfuse = mselect
	USE (mselect) ORDER 1 ALIA &_file
	old_use=.F.
ENDI
dbfuse = ''
@ 22,0 CLEA
DO TITLE WITH EhelpMess(Ch_help)
FOR i = 1 TO FCOUNT()
	x=LTRIM(STR(i))
	field&x=FIELD(i)
NEXT
bott_mess=;
'[Esc]=สิ้นสุด   [F1]=ขอความช่วยเหลือ ' && [Ctrl+N]=เพิ่มเติม  [CTRL+E]=แก้ไข'
DO bottmess WITH bott_mess
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpedithelp
DEFINE WIND browsewin FROM 3,3 TO 20,75 SHAD COLO w+/b
DO WHIL LASTKEY()#27
	ACTI WIND browsewin
	do case
		case fcount()=2
*	IF FCOUNT() = 2
			BROW FIELD &field1 :10 :h='  รหัส  ',&field2 :30 :h='     ชื่อเต็ม' ;
				FOR ! EMPTY(&field1) NOMO NOMENU IN browsewin
*	ELSE
		case upper(_file)='DOCTOR'
			BROW FIELD &field1 :10 :h='  รหัส  ',&field2 :30 :h='     ชื่อเต็ม',;
				&field3 :10 :h='สถานะ ':p='Y' FOR ! EMPTY(&field1) NOMO NOMENU IN browsewin
		other
			BROW FIELD &field1 :10 :h='  รหัส  ',&field2 :30 :h='     ชื่อเต็ม',;
				&field3 :10 :h=' แผนก ' FOR ! EMPTY(&field1) NOMO NOMENU IN browsewin
*	ENDI
	endcase
ENDD
RELE WIND browsewin
ACTI SCREE
@ 23,0
ON KEY LABEL CTRL+E
ON KEY LABEL CTRL+N
ON KEY LABEL CTRL+D
ON KEY LABEL F1 &mkeylabel

PROC ChangeHelp
PARA _append
IF _append
	SCAT TO helparr BLANK
ELSE
	SCAT TO helparr
ENDI
DEFINE WIND appendwin FROM 21,3 TO 24,75 SHAD COLO W+/b
ACTI WIND appendwin
_mhelp=helparr(1)
@ 0,1 GET helparr(1) VALID CheckCode(helparr)
@ 0,12 GET helparr(2) FUNC 'S40'
IF FCOUNT() = 3 .AND. TYPE(FIELD(3)) # 'M'
	@ 0,46 GET helparr(3)
ENDI
@ 1,20 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET m.corr DEFA 'Y' PICT '!' COLO gr+/b ;
VALID IIF(m.corr='Y',.T.,-2)
READ NOLOCK
RELE WIND appendwin
IF _append
	IF m.corr='Y' .AND. ! EMPTY(helparr(1)) .AND. ! EMPTY(helparr(2))
		GO TOP
		IF ! EMPTY(&field1) .OR. BOF()
			APPE BLANK
		ENDI
		GATH FROM helparr
		FLUSH
	ENDI
ELSE
	IF m.corr='Y'
		GATH FROM helparr
		FLUSH
	ENDI
ENDI
KEYB '{CTRL+W}'

FUNC CheckCode
PARA _check
EXTERNAL ARRAY _check
IF RECCOUNT() = 0
	APPE BLAN
ENDI
_curr=RECNO()
IF ! EMPTY(_check[1]) .AND. _check[1]#_mhelp
	_check[1] = IIF(RIGHT(DBF(),10) = 'DOCTOR.DBF',PADBLANK(_check[1]),_check[1])
	IF SEEK(_check[1])
		?? CHR(7)
		WAIT 'รหัส '+_check[1]+' มีอยู่แล้ว ไม่สามารถใช้ได้' WIND NOWAI
		_check[1] = RemoveBlank(_check[1])
		_CUROBJ=_CUROBJ
	ENDI
	GO _curr
ENDI

PROC SUREDELETE
DEFINE WIND appendwin FROM 21,3 TO 24,75 SHAD COLO W+/b
ACTI WIND appendwin
?? CHR(7)
@ 0,1 SAY &field1 COLO gr+/b
@ 0,12 SAY &field2 COLO gr+/b
@ 1,20 SAY 'ต้องการลบข้อมูลนี้ออกแน่หรือไม่ ' GET m.corr DEFA 'N' PICT '!' COLO gr+/b
READ NOLOCK
IF m.corr='Y'
	SCAT MEMV BLAN
	GATH MEMV
	FLUSH
ENDI
RELE WIND appendwin

PROC DESTROY

FUNC HelpEditHelp
?? CHR(7)
msg2='กดปุ่มอะไรก็ได้เพื่อทำงานต่อ'
define window instr from 1,0 to 9,78 shadow title ;
'  แก้ไขแฟ้มช่วยเหลือ  ' COLO bg+/gr+
activate window instr
@ 1,1 say 'กดปุ่ม '
@ row(),col() SAY '[CTRL+E]' COLO r+/gr+
@ row(),COL() SAY ' เพื่อแก้ไขข้อมูล'
@ 2,1 say 'กดปุ่ม '
@ row(),col() SAY '[CTRL+N] ' COLO r+/gr+
@ row(),col() SAY 'เพื่อเพิ่มเติมรหัส'
@ 3,1 say 'กดปุ่ม '
@ row(),col() SAY '[CTRL+D] ' COLO r+/gr+
@ row(),col() SAY 'เพื่อลบรหัสที่เส้นทึบแสงอยู่'
@ 4,1 say 'กดปุ่ม '
@ row(),col() SAY '[Esc] 'COLO r+/gr+
@ row(),col() SAY 'เพื่อเลิกรายการนี้'
@ 6,Center(msg2) say msg2 color g+/gr+
wait '' window TIMEOUT 30
release window instr

*********************
PROC STARTPRINT
*********************
	_wrap=.F.
	_plength=41
	_peject='NONE'
	_pageno=1
	_plineno=0
	_PLOFFSET = 0


*********************
PROC ENDPRINT
*********************
PARA _heading,_file
SET PRINT OFF
SET PRINT TO
SET CONS ON
ON PAGE
DEFINE WIND browwin FROM 3,0 TO 20,78 SHAD TITLE _heading COLO W+/b
DO WHIL LASTKEY()#27
	ON KEY LABEL P KEYB CHR(23)+CHR(21) &&DO ToPrint
	ON KEY LABEL C KEYB CHR(23)+CHR(22)
	MODI COMM &_file  WIND browwin NOEDIT
	ON KEY LABEL p
	ON KEY LABEL c
	IF LASTKEY()<>27
		WAIT WIND
		IF LASTKEY()=21
			DO ToPrint WITH _file
		ENDI
		IF LASTKEY()=22
			DO CopyFile WITH _file
		ENDI
	ENDI
ENDD

PROC HelpBrow
?? CHR(7)
msg2='กดปุ่มอะไรก็ได้เพื่อทำงานต่อ'
define window instr from 1,0 to 8,78 shadow title ;
'  รายงาน  ' COLO bg+/gr+
activate window instr
@ 1,1 say 'กดปุ่ม '
@ row(),col() SAY '[P]' COLO r+/gr+
@ row(),COL() SAY ' เพื่อพิมพ์รายงานลงกระดาษ'
@ 2,1 say 'กดปุ่ม '
@ row(),col() SAY '[C] ' COLO r+/gr+
@ row(),col() SAY 'เพื่อเก็บรายงานลงดิสเก็ต'
@ 3,1 say 'กดปุ่ม '
@ row(),col() SAY '[Esc] 'COLO r+/gr+
@ row(),col() SAY 'เพื่อเลิกรายการนี้'
@ 5,Center(msg2) say msg2 color g+/gr+
wait '' window TIMEOUT 30
release window instr
RETU

PROC ToPrint
PARA _printfile
fhandle=FOPEN(_printfile)
IF fhandle<0
	?? CHR(7)
	WAIT 'ไม่สามารถเปิดแฟ้มมาพิมพ์ได้ '+STR(fhandle,3) WIND NOWAIT
ELSE
	DEFINE WIND askprin FROM 10,20 TO 15,60 SHAD
	ACTI WIND askprin
	@ 1,5 PROMPT '1. พิมพ์กระดาษทีละแผ่น'
	@ 2,5 PROMPT '2. พิมพ์กระดาษต่อเนื่อง'
	MENU TO chprin
	prcont =  IIF(chprin = 1,.F.,.T.)
	RELE WIND askprin
	SET CONS OFF
	SET PRINT ON
	DO WHIL ! FEOF(fhandle) .AND. ! CancelPrint()
			mp=FGETS(fhandle)
			?mp
			IF LEFT(mp,1)='' .AND. ! FEOF(fhandle)
				IF ! prcont
					?? CHR(7)
					WAIT 'เปลี่ยนกระดาษแผ่นใหม่ด้วย' WIND
				ENDI
			ENDI
	ENDD
	=FCLOSE(fhandle)
	IF printstatus()
		EJECT
	ENDI
	SET PRINT OFF
	SET CONS ON
ENDI

PROC CopyFile
PARA _copyfile
DEFINE WIND askname FROM 8,5 TO 12,74 SHAD COLO W+/b+
ACTI WIND askname
PUSH KEY CLEA
@ 1,5 SAY 'เก็บข้อมูลไว้ในแฟ้มชื่อ  ' GET targetfile DEFA SPAC(30) ;
PICT '@!' WHEN English()
READ NOLOCK
IF EMPTY(targetfile) .OR. LASTKEY()=27
	?? CHR(7)
	WAIT 'ยกเลิกการสำรองแฟ้มตามต้องการ' WIND NOWA
ELSE
	filetarget=ALLTRIM(targetfile)
	COPY FILE &_copyfile TO (filetarget)
ENDI
RELE WIND askname
POP KEY


*********************
FUNC SHOWBE
*********************
PARA _DATE,_SHOWDATE
_showdate = ce2cbe(be2ce(_date))
show gets
*if lastkey()=19 .or. lastkey()=5
*	_curobj=_curobj-1
*else
*	keyboard CHR(13)
*endif
RETU .F.
*************************************************************************
FUNC THAISOUNDEX
*************************************************************************
PARA _soundname
i=2
no=3
mname= ' '

dimen code(8)

if	substr(_soundname,at(' ',_soundname)+1,1) $ 'แเไใโ'
    do case
	  case	substr(_soundname,at(' ',_soundname)+2,1) = 'ซ' .and. substr(_soundname,at(' ',_soundname)+3,1) = '่' .and. substr(_soundname,at(' ',_soundname)+4,1) $ 'แเไใโ'
		code(1)=substr(_soundname,at(' ',_soundname)+5,1)
		i=i+4
	  case substr(_soundname,at(' ',_soundname)+2,1) = 'ซ' .and. substr(_soundname,at(' ',_soundname)+3,1) = '่'
		code(1)=substr(_soundname,at(' ',_soundname)+4,1)
		i=i+3
      otherwise
		code(1)=substr(_soundname,at(' ',_soundname)+2,1)
		i=i+1
	endcase
else
		code(1)=substr(_soundname,at(' ',_soundname)+1,1)
endif

code(2)='.'
code(6)='.'

do while no < 6
  cut = substr(_soundname,at(' ',_soundname)+i,1)
  DO CODE_FIL
endd

no=7
i=0
do while no < 9
 cut = substr(_soundname,1+i,1)
 DO CODE_FIL

endd
RETU code(1)+code(2)+code(3)+code(4)+code(5)+code(6)+code(7)+code(8)
*@ row,1 say CHR(27)+'E'+code(1)+code(2)+code(3)+code(4)+code(5)+code(6)+code(7)+code(8)+CHR(27)+'F'


**************************************************************
PROC CODE_FIL
**************************************************************

  do case
	case cut  $ 'กขคงจฆ'
		mname ='1'
		code(no)=mname
		no=no+1
			DO CHECK
		i=i+1
	case cut $ 'สศษมว'
		mname = '2'
		code(no)=mname
		no=no+1
			DO CHECK
		i=i+1
	case cut $ 'ฉชซฌหอฮ'
		mname ='3'
		code(no)=mname
		no=no+1
			DO CHECK
		i=i+1
	case cut $ 'นณยรลญฤฬ'
		mname ='4'
		code(no)=mname
		no=no+1
			DO CHECK
		i=i+1
    case cut $ 'ทธถฒฐฑดตฎฏ'
	mname ='5'
	code(no)=mname
	no=no+1
		DO CHECK
	i=i+1
    case cut $ 'พฟผฝภบป'
	mname ='6'
	code(no)=mname
	no=no+1
			DO CHECK
	i=i+1
	case cut = ' '
	    mname = '0'
	    code(no)=mname
	    no=no+1
			DO CHECK
	    i=i+1
    case cut = ','
      do while no < 6
	mname = '0'
	code(no)=mname
	no=no+1
      enddo
    otherwise
	i=i+1
   endcase

***************************************************************
PROC CHECK
***************************************************************
    if	mname = code(no-2) .and. code(no-2)<>'0'
			no=no-1
	endif
FUNC Inputward
***********************************
PARA _ward,_nameward
_para = PARAMETERS()
_ward=RemoveBlank(_ward)
IF _para = 2
	SELE ward
	SET ORDER TO TAG clinic
	SEEK _ward
	_nameward = name
ENDI
SHOW GETS

************************************
FUNC CheckWard
************************************
PARA _ward,_mward
_para = PARAMETERS()
SELE ward
SET ORDER TO tag clinic
IF ! EMPTY(_ward)
	_ward=Padblank(_ward)
	IF ! SEEK(_ward)
		?? CHR(7)+CHR(7)
		WAIT 'ไม่มีหอผู้ป่วยรหัส '+_ward WIND NOWAIT
		_CUROBJ=_CUROBJ
	ENDI
	IF _PARA = 2
		_mward=name
	ENDI
ENDI
SHOW GETS

***********************************
FUNC Inputdep
***********************************
PARA _dep
_dep=RemoveBlank(_dep)


************************************
FUNC CheckDep
************************************
PARA _ward,_mward
_para = PARAMETERS()
SELE ward
SET ORDER TO tag clinic
IF BETWEEN(_ward,'01','11')
	 SEEK _ward
	IF _PARA = 2
		_mward=name
	ENDI
ELSE
	DO AlertWin WITH 'ต้องใส่รหัสแผนก 01 - 11'
	_CUROBJ = _CUROBJ
ENDI
SHOW GETS

PROC ALERTWIN
PARA _head
= ALARM1()
IF PARAMETERS() >0
	WAIT WIND NOWA _head
ENDI

FUNC TimeRefer
para _mtime
if ! BETWEEN(LEFT(_mtime,2),'  ','23') .OR. ! BETWEEN(RIGHT(_mtime,2),'  ','59')
	?? CHR(7)
	WAIT 'ใส่เวลาไม่ถูกต้อง' WIND NOWA
	_CUROBJ=_CUROBJ
ENDI

FUNC CHECKCORRECT
PARA _check
IF _check#'Y'
	_CUROBJ=1
ENDI

FUNC CheckCause
PARA _cause
IF LASTKEY()>27
	IF ! LEFT(_cause,1) $ '12345678' .OR. ! RIGHT(_cause,1) $ ' 12345678'
		_CUROBJ=_CUROBJ
		KEYB "{F1}"
	ENDI
ENDI

FUNC con_icd
PARA _conicd
RETU IIF(SUBS(_conicd,4,1)='.',LEFT(_conicd,3)+SUBS(_conicd,5),_conicd)

FUNC SWAP
PARA _first,_second
PRIV _temp
_temp = _first
_first = _second
_second = _temp

FUNC TONE
PARA _freq,_dura
SET BELL TO _freq,_dura
?? CHR(7)
SET BELL TO

FUNC GETPASS
PARA _prompt,_passwrd
_prompt1 = IIF(PARAMETERS() = 1,'กรุณาใส่รหัสผ่าน', _prompt)
_password = IIF(PARAMETERS() = 1, _prompt, _passwrd)
_strlen = LEN(_prompt1)+16
_firstcol = INT((_strlen+4)/2)
DEFINE WIND Passwrd FROM 10,_firstcol TO 14,_firstcol+_strlen+4 SHAD
ACTI WIND Passwrd
@ 1,1 SAY _prompt1+' '
_ret = ''
FOR pp = 1 TO 16
	_mkey = INKEY(0)
	IF _mkey = 13
		EXIT
	ENDI
	_ret = _ret+CHR(_mkey)
	@ 1,COL() SAY '*'
NEXT
DEAC WIND Passwrd
RETU UPPE(LEFT(_ret+SPAC(16),16)) =  UPPE(LEFT(_password+SPAC(16),16))

FUNC GETUSER
PARA _Usr
DEFINE WIND Passwrd FROM 10,15 TO 16,65 SHAD
PRIV UserName,_code,_ret,_col,NumPara
NumPara = PARAMETER()
dbfuse = patientdir+'user'
USE (patientdir+'user') ORDER TAG name IN 0
dbfuse = ''
ACTI WIND Passwrd
UserName = SPACE(12)
= EngMode()
@ 1,1 SAY 'กรุณาใส่ชื่อ  : ' GET UserName PICT '@!'
@ 3,1 SAY 'รหัสผ่าน      : '
_col = COL() + 1
READ NOLOCK
_code=' '
IF RECCOUNT('user') = 0 .AND. TRIM(UserName) == 'SUPERVISOR'
	_code = 'SUP       '
ELSE
	@ 3,_col
	_ret = ''
	FOR pp = 1 TO 10
		_mkey = INKEY(0)
		IF _mkey = 13
			EXIT
		ENDI
		_ret = _ret+CHR(_mkey)
		@ 3,COL() SAY '*'
	NEXT
	SELE user
	_ret = UPPE(LEFT(_ret+SPAC(16),10))
	IF ! SEEK(UserName)
		=ALARM1()
		WAIT WIND NOWA 'คุณไม่มีสิทธิทำงานในระบบ'
	ELSE
		IF psw == EnCrypt(_ret)
			_code = right
		ELSE
			=ALARM1()
			WAIT WIND NOWA 'เสียใจ ! คุณใส่รหัสผ่านผิด'
		ENDI
	ENDI	
ENDI
DEAC WIND Passwrd
IF NumPara # 0
	_Usr = UserName
ENDI
SELE user
USE
RETU _code

FUNC CHANGEPASS
PARA _psw
PRIV _ret,pp,p1
DEFINE WIND Passwrd FROM 10,10 TO 14,60 SHAD
ACTI WIND Passwrd
@ 1,1 SAY 'เปลี่ยนรหัสผ่านเป็น'+' '
_ret = ''
FOR pp = 1 TO 10
	_mkey = INKEY(0)
	IF _mkey = 13
		EXIT
	ENDI
	_ret = _ret+CHR(_mkey)
	@ 1,COL() SAY '*'
NEXT
_p1 = _ret
CLEA
@ 1,1 SAY 'ยืนยันรหัสอีกครั้ง'+' '
_ret = ''
FOR pp = 1 TO 10
	_mkey = INKEY(0)
	IF _mkey = 13
		EXIT
	ENDI
	_ret = _ret+CHR(_mkey)
	@ 1,COL() SAY '*'
NEXT
DEAC WIND Passwrd
IF UPPE(LEFT(_ret+SPAC(10),10)) =  UPPE(LEFT(_p1+SPAC(10),10))
	_psw = _p1
	RETU .T.
ELSE
	=ALARM1()
	WAIT WIND NOWA 'คุณพิมพ์ไม่ถูกต้อง รหัสผ่านยังคงเดิม'
	RETU .F.
ENDI

FUNC ALARM1
=TONE(1200,5)
=TONE(700,5)

FUNC CON_AGE
PARA st1,st2
do case
case st1='1'
   if st2<45
      do case
      case st2>=1 .and. st2<5
      retu '3'
      case st2>=5 .and. st2<10
      retu '4'
      case st2>=10 .and. st2<15
      retu '5'
      case st2>=15 .and. st2<20
      retu '6'
      case st2>=20 .and. st2<25
      retu '7'
      case st2>=25 .and. st2<30
      retu '8'
      case st2>=30 .and. st2<35
      retu '9'
      case st2>=35 .and. st2<40
      retu '10'
      case st2>=40 .and. st2<45
      retu '11'
      endc
   else
      do case
      case st2>=45 .and. st2<50
      retu '12'
      case st2>=50 .and. st2<55
      retu '13'
      case st2>=55 .and. st2<60
      retu '14'
      case st2>=60 .and. st2<65
      retu '15'
      case st2>=65 .and. st2<70
      retu '16'
      case st2>=70 .and. st2<75
      retu '17'
      case st2>=75 .and. st2<80
      retu '18'
      case st2>=80 .and. st2<85
      retu '19'
      case st2>=85
      retu '20'
      endc
   endi
   case st1='2'
   retu '2'
   case st1='3'
   retu '1'
   OTHER
		RETU ''
endc

PROC GETCONFIG
exedir = SYS(16,1)
exefile = SUBS(exedir, RAT('\',exedir)+1)
exefile = LEFT( exefile,AT('.',exefile)-1)
exedir = LEFT(exedir,RAT('\',exedir))
configfile = IIF( EMPTY(UPPE(GETENV('configfile'))), exefile+'.cfg',GETENV('configfile'))
IF FILE(configfile)
	confighand = FOPEN(configfile)
	DO WHIL ! FEOF(confighand)
		mtext = FGETS(confighand)
		mat = AT('=',mtext)
		IF mat > 0
			ccommand = ALLTRIM(UPPE(LEFT(mtext,mat-1)))
			cresult = UPPE(SUBS(mtext,mat+1))
			cresult = IIF( AT('*',cresult)>0, ;
			ALLTRIM(LEFT(cresult,AT('*',cresult)-1)),;
			ALLTRIM(cresult))
			IF ! EMPTY(cresult) .AND. ! EMPTY(ccommand)
				cresult = IIF(RIGHT(cresult,1)='\',cresult,cresult+'\')
				DO CASE
					CASE ccommand == 'PATIENTDIR'
						patientdir = cresult
					CASE ccommand == 'CODEDIR'
						codedir = cresult
					CASE ccommand == 'THAICARD'
						thaicard = LEFT(cresult,LEN(cresult)-1)
					CASE ccommand == 'WORKSTATION'
						workstation = LEFT(cresult,LEN(cresult)-1)
						DO CASE
							CASE workstation = 'ER'
								er = .T.
							CASE workstation = 'STAT'
								statinput = .T.
						ENDC
					CASE ccommand == 'TEMPDIR'
						TEMPDIR = cresult
					CASE ccommand == 'OPDDIR'
						opddir = cresult
					CASE ccommand == 'IPDDIR'
						ipddir = cresult
					CASE ccommand == 'BACKUP'
						BACKUP = LEFT(cresult,LEN(cresult)-1)
					CASE ccommand == 'ADMIT'
						ADMIT = LEFT(cresult,LEN(cresult)-1)
					CASE ccommand == 'BACKUPDIR'
						backupdir = cresult
					CASE ccommand == 'BACKUPDRIVE'
						backupdrive = cresult
*					CASE ccommand == 'PERSON_ID'
*						person_id = LEFT(cresult,LEN(cresult)-1)
					CASE ccommand == 'NOTPRINTRX'
						notprintrx = cresult
					CASE ccommand == 'WELLBABY'
						wellbaby = cresult
					CASE ccommand == 'PHARMDIR'
						pharmdir = cresult
					CASE ccommand == 'BILLDIR'
						billdir = cresult
					CASE ccommand == 'ISDIR'
						isdir = cresult
					CASE ccommand == 'PRESCRIPTION'
						prescription = LEFT(cresult,LEN(cresult)-1)
					CASE ccommand == 'NOTQUE'
						notque = LEFT(cresult,LEN(cresult)-1)
					CASE ccommand == 'NOTSTATADMIT'
						notstatadmit = LEFT(cresult,LEN(cresult)-1)
				ENDC
			ENDI
		ENDI
	ENDD
	= FCLOSE(confighand)
ENDI
FUNC NAMERQBE
PRIVATE _varread
EXTERNAL ARRAY pcond3,cond3,prqbe,condtype,recshow
_varread=VARREAD()
_key = LASTKEY()
IF EMPTY(&_varread) .AND. _key # 5
	_l = VAL(SUBS(_varread,10,1))
	IF _l > 1
		STOR '  ' TO pcond3[_l-1]
		STOR SPACE(10) TO cond3[_l-1]
	ENDI
	_CUROBJ=1000
ELSE
DO CASE
CASE _key=5 .AND. _CUROBJ > 1
	_CUROBJ = _CUROBJ - 4
CASE _key = 24
	_CUROBJ = _CUROBJ + 4
CASE _key = 13
	LOCA FOR name = &_varread
	DO WHIL ! EOF() .AND. ! _call $ callprg
		CONT
	ENDD
	DO CASE
		CASE  ! FOUND()
			=ALARM1()
			WAIT WIND NOWA 'ไม่พบตัวแปรตามที่ต้องการ'
			_CUROBJ = _CUROBJ
		CASE fieldtype = 'D'
			=ALARM1()
			WAIT 'ตัวแปรเป็นวันที่ ให้เลือกระยะเวลาที่ค้นหาแทน' WIND NOWA
			_CUROBJ = _CUROBJ
		CASE TRIM(name) $ 'เวรที่ทำบัตร,เวรที่รับไว้'
			=ALARM1()
			WAIT 'ให้เลือกตัวแปรเวลาที่แทน' WIND NOWA
			_CUROBJ = _CUROBJ
		OTHER
			_row=ROW()
			STOR TRIM(filename)+'.'+TRIM(fieldname) TO prqbe[_row]
			STOR fieldtype TO condtype[_row]
	ENDC
ENDC
ENDI

PROC HELPCOND
PARA _varread
EXTERNAL ARRAY prbqe,condtype
PUSH KEY CLEA
IF UPPE(LEFT(_varread,8))='RQBECOND'
	_row=ROW()
	ACTI WIND toprqbe
	vchoice=1
	@ 2,5 GET vchoice from show WIND toprqbe
	READ NOLOCK
	DEAC WIND toprqbe
	GO recshow(vchoice)
	&_varread=name
	STOR fieldtype TO condtype[_row]
	STOR TRIM(filename)+'.'+TRIM(fieldname) TO prqbe[_row]
ENDI
POP KEY
KEYB CHR(13)

FUNC INCOND1
EXTERNAL ARRAY pcond1,offer
_varread=VARREAD()
_level=VAL(SUBS(_varread,7,1))
mc=1
IF fieldtype='L'
	&_varread=offer[1]
ELSE
	DEFINE WIND test FROM _level+8,30 TO _level+17,60 SHAD TITLE ''
	ACTI WIND test
	mc=1
	@ 1,3 GET mc FROM offer
	READ NOLOCK
	&_varread=offer(mc,1)
	RELE WIND test
ENDI
STOR offer[mc,2] TO pcond1[_level]
SHOW GETS
RETU .F.

FUNC INCOND2
EXTERNAL ARRAY pcond1,pcond2
_varread=VARREAD()
_level=VAL(SUBS(_varread,7,1))
IF pcond1[_level]=' BETWEEN' .OR. EMPTY(desc) .OR. TRIM(fieldname) = 'T_IN'
	pcond2[_level] = ' '
	RETU .T.
ELSE
	numline=MEMLINES(desc)
	DIME showhelp[numline]
	FOR i=1 to numline
		STOR mline(desc,i) TO showhelp(i)
	NEXT
	mc=1
	DEFINE WIND test FROM _level+8,45 TO _level+15,70
	ACTI WIND test
	@ 1,3 GET mc FROM showhelp
	READ NOLOCK
	RELE WIND test
	&_varread=showhelp[mc]
	STOR mline(code,mc) TO pcond2[_level]
	IF fieldtype='L'
		pcond2[_level]=IIF(pcond2[_level]='1',.T.,.F.)
	ENDI
	SHOW GETS
	RETU .F.
ENDI

FUNC INCOND3
EXTERNAL ARRAY pcond3,condition
_varread=VARREAD()
_level=VAL(SUBS(_varread,7,1))
mc=1
DEFINE WIND test FROM _level+8,60 TO _level+15,78
ACTI WIND test
@ 1,3 GET mc FROM condition SIZE 5,10
READ NOLOCK
RELE WIND test
IF mc=3
	_CUROBj=1000
	STOR condition[mc,2] TO pcond3[_level]
ELSE
	STOR condition[mc,2] TO pcond3[_level]
	&_varread =  condition[mc,1]
	SHOW GETS
	RETU .F.
ENDI

FUNC CHECKDATE
PARA _date
IF ! TRUEDATE(_date)
	?? CHR(7)
	WAIT WIND 'ใส่วันที่ไม่ถูกต้อง' NOWA
	_CUROBJ = _CUROBJ
ELSE
	_varread=VARREAD()
	IF _varread='MMYY1' .AND. BE2CE(_date)<BE2CE(mmyy)
		?? CHR(7)
		WAIT WIND 'วันที่เริ่มต้นต้องน้อยกว่าวันที่สิ้นสุด  ' NOWA
		_CUROBJ = 1
	ENDI
ENDI
RETU

FUNC SHOWDAY
PARA _show,_date
PRIVATE date
date=FULLYEAR(_date)
date=BE2CE(date)
_show=CE2CBE(date)
SHOW GETS
RETU .F.

*****************************************
****************
FUNC InputDoctor
****************
PARA _doctor
_doctor=RemoveBlank(_doctor)

**************************
Function Encrypt
**************************
parameter inputstr

inputstr=upper(inputstr)

strlength=len(inputstr)
password=''

for i=1 to strlength
	if i%2=0
		password=password+chr(asc(substr(inputstr,i,1))+10)
	else
		password=password+chr(asc(substr(inputstr,i,1))-10)
	endif
endfor

return password

*************************
Function Decrypt
*************************
parameter inputstr

inputstr=upper(inputstr)

strlength=len(inputstr)
password=''

for i=1 to strlength
	if i%2=0
		password=password+chr(asc(substr(inputstr,i,1))-10)
	else
		password=password+chr(asc(substr(inputstr,i,1))+10)
	endif
endfor

return password

FUNC havecode
PARA _cvar, _cdesc, _cname, _cdbf, _calias, _ctag
******************************************************************
* เป็นฟังชั่นสำหรับตรวจสอบว่ามีรหัสนี้อยู่ในแฟ้มข้อมูลหรือไม่ และส่งค่าความหมาย *
* ของรหัสคืนให้ โดย                                              *
*      _cvar  คือ  ตัวแปรรหัสที่จะให้ค้นหา                       *
*      _cdesc คือ  ตัวแปรที่ใช้เก็บชื่อความหมายของรหัส           *
*      _cname คือ  ชื่อ field ที่เก็บค่าความหมายของรหัส          *
*      _cdbf  คือ  ชื่อของ Database ที่เก็บตัวแปรนั้น            *
*      _alias คือ  ชื่อของ Alias ที่จะกำหนดให้กับแฟ้มข้อมูล      *
*      _ctag  คือ  ชื่อของ tag ที่ index รหัสนั้นอยู่            *
******************************************************************
PRIV numpara, mret
numpara = PARAMETERS()
mret = .F.

IF numpara < 5
	= ALARM1()
	DEFINE WIND showerr FROM 1,5 TO 15,75 SHAD
	ACTI WIND showerr
	? '   Function นี้จะต้องมี Parameter อย่างน้อย 5 ตัว คือ'
	? '       CheckCode(cvar, cdesc, cname, cdbf, calias, ctag)  โดย'
	? '      _cvar  คือ  ตัวแปรรหัสที่จะให้ค้นหา'
	? '      _cdesc คือ  ตัวแปรที่ใช้เก็บชื่อความหมายของรหัส '
	? '      _cname คือ  ชื่อ field ที่เก็บค่าความหมายของรหัส '
	? '      _cdbf  คือ  ชื่อของ Database ที่เก็บตัวแปรนั้น '
	? '      _alias คือ  ชื่อของ Alias ที่จะกำหนดให้กับแฟ้มข้อมูล '
	? '      _ctag  คือ  ชื่อของ tag ที่ index รหัสนั้นอยู่ '
	? '   โดยถ้าไม่ได้ระบุ ctag จะ set order to 1 '
	?
	WAIT '      กดปุ่มอะไรก็ได้เพื่อทำงานต่อ' TIME 20
	RELE WIND showerr
ELSE
	canopen = IIF( numpara > 5, OpenDBF(_cdbf, _calias, _ctag), OpenDBF(_cdbf, _calias) )
	IF canopen
		IF numpara = 5
			SET ORDER TO 1
		ENDI
		IF SEEK(_cvar)
			_cdesc = &_cname
			mret = .T.
		ENDI
	ENDI
ENDi
RETU mret

FUNC OpenDBF
PARA _odbf, _oalias, _otag
PRIV numpara, mret, canmakedbf
numpara = PARAMETERS()
mret = .F.
_oalias = IIF( EMPTY(_oalias), IIF( AT('\',_odbf)>0, SUBS(_odbf,RAT('\',_odbf)+1), _odbf), _oalias)
STORE .T. TO canmakedbf
IF numpara < 2
	= ALARM1()
	DEFINE WIND showerr FROM 2,5 TO 10,70 SHAD
	ACTI WIND showerr
	? '   Function นี้จะต้องมี Parameter อย่างน้อย 3 ตัว คือ'
	? '       OpenDBF(odbf, oalias, otag)  โดย'
	? '      _odbf  คือ  ชื่อของ Database ที่เก็บตัวแปรนั้น '
	? '      _olias คือ  ชื่อของ Alias ที่จะกำหนดให้กับแฟ้มข้อมูล '
	? '      _otag  คือ  ชื่อของ tag ที่ index รหัสนั้นอยู่ '
	WAIT '      กดปุ่มอะไรก็ได้เพื่อทำงานต่อ' TIME 20
	DEAC WIND ALL
	RETU TO MASTER
ELSE
	canmakedbf = IIF( ! FILE(_odbf+'.dbf'), MakeDBF(_odbf) , .T. )
	IF ! canmakedbf
		= ALARM1()
		WAIT WIND NOWA 'ไม่มีแฟ้มข้อมูล ' + _odbf
	ELSE
		dbfuse = _odbf
		SELE IIF( USED(_oalias), (_oalias), 0 )
		mret = .T.
		USE (_odbf) ALIAS (_oalias) AGAIN
		IF numpara > 2
			IF ! FILE(_odbf+'.cdx')
				= ALARM1()
				WAIT WIND NOWA 'ไม่มีแฟ้มดัชนีของแฟ้ม ' + _odbf
				mret = .F.
			ELSE
				IF TYPE('_otag') = 'N'
					SET ORDER TO (_otag)
				ELSE
					IF EMPTY(_otag)
						SET ORDER TO 1
					ELSE
						SET ORDER TO TAG (_otag)
					ENDI
				ENDI
			ENDI
		ENDI
	ENDI
ENDI
RETU mret
