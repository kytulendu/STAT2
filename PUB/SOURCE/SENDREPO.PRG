PARA _type
DEFINE WIND sendrepo From 9,20 TO 15,70 SHAD TITLE 'ส่งรายงานด้วยดิสค์'
ACTI WIND sendrepo
STOR SPACE(4) TO mmyy
@ 1,2 SAY 'ส่งรายงาน รง'+_type+' เดือน/ปี ' GET mmyy ;
PICT '@R ##/##' VALID Checkdate(mmyy)
READ
annual=.F.
mm = LEFT(mmyy,2)
yy = RIGHT(mmyy,2)
IF mm='  ' .OR. LASTKEY() = 27
	?? CHR(7)
	WAIT 'ยกเลิกการทำงานตามที่ท่านต้องการ' WIND NOWA
	RETU
ENDI
IF ! FILE('report\r&_type&yy&mm..dbf')
	=TONE(450,5)
	CLEA
	@ 1,1 SAY 'ยังไม่มีแฟ้มรายงานรง.'+_type+'ของ'+;
	IIF(mm = LEFT(FULLYEAR(yy),2),'ปีงบประมาณ','เดือน'+month&mm)+' '+FullYear(yy)
	@ 3,1 SAY 'กรุณาเลือกรายการทำรายงานก่อน'
	=INKEY(10)
ELSE
	CLEA
	@ 1,1 SAY 'ใส่รายงานไว้ในช่องขับ'
	@ 1,25 PROMPT 'A:' MESS 'ใส่รายงานไว้ในไดร์ฟ A'
	@ 3,25 PROMPT 'B:' MESS 'ใส่รายงานไว้ในไดร์ฟ B'
	MENU TO mdrive
	IF mdrive=0
		RETU
	ELSE
		drive=IIF(mdrive=1,'a','b')
		SELE 0
		USE report\r&_type&yy&mm
		COPY TO &drive.:r&_type&yy&mm
		USE
	ENDI
ENDI
RELE WIND sendrepo