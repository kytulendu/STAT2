DEFINE WIND EditAddrMenu FROM 12,50 TO 18,74 SHAD
DIME addr[3], addrmess[3]

addr[1] = '1. เพิ่มเติมรหัส'
addr[2] = '2. แก้ไขรหัส'
addr[3] = '0. กลับรายการเดิม'

addrmess[1] = 'เพิ่มเติมรหัสจังหวัด อำเภอ ตำบล ในกรณีที่ยังไม่มีรหัสนี้อยู่'
addrmess[2] = 'แก้ไขรหัสจังหวัด อำเภอ ตำบล ในกรณีที่ใส่รหัสไม่ถูกต้อง'
addrmess[3] = 'กลับไปสู่รายการก่อนหน้านี้'

editaddr = .T.
*susp
DO WHIL editaddr
	ACTI WIND EditAddrMenu
	FOR i = 1 TO 3
		@ i,3 PROMPT addr[i] MESS addrmess[i]
	NEXT
	MENU TO ch_addr
	DO CASE
		CASE ch_addr = 1
			DO newaddr
		CASE ch_addr = 2
			DO ChangeAddr
		OTHER
			editaddr = .F.
	ENDC
ENDD
RELE WIND EditAddrMenu

PROC CHANGEADDR
PRIV goon
DEFINE WIND Editaddr FROM 6,10 TO 16,70 SHAD
ACTI WIND Editaddr
goon = .T.
SELE 0
dbfuse = tempdir+'chanaddr'
CREA TABLE (tempdir+'chanaddr') (oldaddr C(6),newaddr C(6))
INDEX ON oldaddr TAG oldaddr
IF ! USED('address')
	dbfuse = codedir+'address'
	USE (codedir+'address') IN 0
ENDI
SELE address
SET ORDER TO 1
dbfuse = ''
SCAT TO addr1 BLANK
SCAT TO address BLAN
*susp
DO WHIL goon
	@ 1,5 SAY 'รหัสที่จะเปลี่ยน  ' GET addr1[1] PICT '999999' VALID ShowAddr(addr1)
	@ 2,10 GET addr1[2] DISA
	@ 4,5 SAY 'เปลี่ยนเป็นรหัส   ' GET address[1] PICT '999999' VALID ShowAddr(address)
	@ 5,10 GET address[2] DISA
	@ 7,20 SAY 'ข้อมูลถูกต้องหรือไม่  ' GET m.correct DEFA 'Y' PICT '!'
	READ NOLOCK
	IF LASTKEY() = 27 .OR. EMPTY(addr1[1]) .OR. EMPTY(address[1])
		goon = .F.
	ELSE
		IF m.correct $ 'Yัํ'
			SELE chanaddr
			APPE BLAN
			REPL oldaddr WITH addr1[1],newaddr WITH address[1]
			FLUSH
			SELE address
			SEEK '3'+addr1[1]
			SCAT MEMV BLAN
			GATH MEMV
			FLUSH
			IF ! SEEK('3'+LEFT(addr1[1],4))
				SEEK '2'+LEFT(addr1[1],4)
				SCAT MEMV BLAN
				GATH MEMV
				FLUSH
				IF ! SEEK('2'+LEFT(addr1[1],2))
					SEEK '1'+LEFT(addr1[1],2)
					SCAT MEMV BLAN
					GATH MEMV
					FLUSH
				ENDI
			ENDI
			SCAT TO addr1 BLANK
			SCAT TO address BLAN
		ENDI
	ENDI
ENDD
SELE chanaddr
IF RECCOUNT() > 0
	IF ! USED('contact')
		dbfuse = patientdir+'contact'
		USE (patientdir+'contact') ORDER 1 IN 0
	ENDI
	dbfuse = ''
	SELE contact
	SET ORDER TO 0
	div_num=ROUND((RECCOUNT()/40)+.5,0)
	recno = 0
	DO ShowProgress
	SCAN
		recno=recno+1
		@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
		mseek = changwat+ampur+tambon
		SELE chanaddr
		IF SEEK(mseek)
			SCAT MEMV
			SELE contact
			REPL changwat WITH LEFT(m.newaddr,2), ampur WITH SUBS(m.newaddr,3,2),;
			tambon WITH RIGHT(m.newaddr,2)
			FLUSH
		ENDI
		SELE contact
	ENDS
	RELE WIND progress
ENDI
SET ORDER TO 1
SELE chanaddr
USE
DELE FILE (tempdir+'chanaddr.dbf')
DELE FILE (tempdir+'chanaddr.cdx')
RELE WIND Editaddr

FUNC SHOWADDR
PARA _code
EXTERNAL ARRAY _code
IF LASTKEY() # 27 .AND. ! EMPTY(_code[1])
	IF RIGHT(_code[1],2) = '00'
		=Alarm1()
		WAIT WIND NOWA 'ต้องเปลี่ยนในระดับตำบล'
		_CUROBJ = _CUROBJ
	ELSE
		_code[3] = '3'
		IF ! SEEK(_code[3]+_code[1])
			=ALARM1()
			WAIT WIND NOWA 'ไมีมีรหัสสถานที่นี้อยู่'
			_CUROBJ = _CUROBJ
		ENDI
		_code[2] = name
		SHOW GETS
	ENDI
ELSE
	goon = .F.
	_CUROBJ = 100
ENDI

PROC NEWADDR
PRIV goon
DEFINE WIND Editaddr FROM 7,10 TO 15,70 SHAD
ACTI WIND Editaddr
goon = .T.
IF ! USED('address')
	dbfuse = codedir+'address'
	USE (codedir+'address') ORDER 1 IN 0
ENDI
dbfuse = ''
SELE address
SET ORDER TO 1
SCAT MEMV BLANK
DO WHIL goon
	CLEA
	@ 1,5 SAY 'รหัสที่อยู่  ' GET m.code PICT '999999' VALID CheckAddr(m.code)
	@ 3,5 SAY 'ชื่อสถานที่  ' GET m.name
	@ 5,20 SAY 'ข้อมูลถูกต้องหรือไม่  ' GET m.correct DEFA 'Y' PICT '!'
	READ NOLOCK
	IF LASTKEY() = 27
		goon = .F.
	ELSE
		IF m.correct $ 'Yัํ'
			IF ! SEEK(m.type+m.code)
				GO TOP
				IF ! EMPTY(m.code) .OR. BOF()
					APPE BLAN
				ENDI
			ENDI
			GATH MEMV
			FLUSH
		ENDI
		SCAT MEMV BLAN
	ENDI
ENDD
RELE WIND Editaddr

FUNC CHECKADDR
PARA _code
IF LASTKEY() # 27 .AND. ! EMPTY(_code)
	DO CASE
		CASE RIGHT(_code,4) = '0000'
			m.type = '1'
		CASE RIGHT(_code,2) = '00'
			m.type = '2'
		OTHER
			m.type = '3'
	ENDC
	IF ! SEEK(m.type+_code)
		IF m.type # '1'
			IF m.type ='2'
				IF ! SEEK('1'+LEFT(_code,2)+'0000')
					=ALARM1()
					WAIT WIND NOWA 'ต้องใส่รหัสจังหวัดก่อนถึงจะใส่รหัสอำเภอได้'
					_code = SPACE(6)
					_CUROBJ = 1
				ENDI
			ELSE
				IF ! SEEK('2'+LEFT(_code,4)+'00')
					=ALARM1()
					WAIT WIND NOWA 'ต้องใส่รหัสอำเภอก่อนถึงจะใส่รหัสตำบลได้'
					_code = SPACE(6)
					_CUROBJ = 1
				ENDI
			ENDI
		ENDI
		GO BOTT
		SKIP
	ENDI
	m.name = name
ELSE
	goon = .F.
	_CUROBJ = 100
ENDI