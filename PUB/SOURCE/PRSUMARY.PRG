PRIV nowrec,useicd1,useicd2,useicd3,useaddress
STOR .F. TO useicd1,useicd2,useicd3,usedoctor
DEFINE WIND prsumary FROM 9,10 TO 14,70 SHAD
IF USED('icd101')
	SELE icd101
	USE
	useicd1 = .T.
ENDi
IF USED('icd102')
	SELE icd102
	USE
	useicd2 = .T.
ENDi
IF USED('icd103')
	SELE icd103
	USE
	useicd = .T.
ENDi
IF USED('doctor')
	SELE doctor
	USE
	usedoctor = .T.
ENDi
SELE patient1
nowrec = IIF( ! EOF(),RECNO(),RECCOUNT())
SET RELA TO
SET RELA TO hn INTO patient2
SET RELA TO hn INTO contact ADDI
SET RELA TO clinic INTO clinic ADDI
SET RELA TO class INTO social ADDI
IF ! USED('address')
	dbfuse = codedir+'address'
	USE (codedir+'address') ORDER 1 IN 0
	useaddress=.F.
ELSE
	useaddress = .T.
ENDI
dbfuse = ''
ACTI WIND prsumary
=ENGMODE()
PRIV man,myear,m.an,m.hn,m.result
@ 1,10 SAY 'พิมพ์ใบ Summary ของเลขที่ผู้ป่วยใน  ' GET man DEFA 0 ;
PICT '99999'
@ 1,COL() SAY '-'
@ 1,COL() GET myear DEFA 0 PICT '99'
READ NOLOCK
man = STRZERO(myear,2)+STRZERO(man,5)
SELE iptrana
SET ORDER TO TAG an
IF SEEK(man)
	SCAT MEMV
	m.result=dep
	DIME printrp[5]	
	printrp(1)= 'พิมพ์501' 
	printrp(2)= 'พิมพ์502'
	printrp(3)= 'พิมพ์503'
	printrp(4)= 'แก้ไข'
	printrp(5)= 'ยกเลิก'
	prinLEVEL=3
	prinSpace=58/prinLEVEL	
	xx=1
	DO WHIL xx<=prinlevel
		@ 3,1+prinSpace*(xx-1) PROMPT printrp(xx)
		xx=xx+1
	ENDD
	MENU TO Chprin
	DO CASE
		CASE ChPrin=1
			IF FILE('rp501.fxp')
				DO ('RP501')
			ELSE
				DO rp501p
			ENDI
		CASE ChPrin=2
			IF FILE('rp502.fxp')
				DO ('RP502')
			ELSE
				DO rp502p
			ENDI
		CASE ChPrin=3
			IF FILE('rp503.fxp')
				DO ('RP503')
			ELSE
				DO rp503p
			ENDI
	ENDC
ELSE
	?? CHR(7)
	WAIT WIND 'ไม่มีหมายเลข AN '+RIGHT(man,5)+'-'+LEFT(man,2) ;
	NOWA
ENDI
RELE WIND prsumary
* SET ORDER TO 1
IF ! useaddress
	SELE address
	USE
ENDI
IF useicd1
	dbfuse = codedir+'icd101'
	USE (codedir+'icd101') ORDER 1 IN 0
ENDI
IF useicd2
	dbfuse = codedir+'icd102'
	USE (codedir+'icd102') ORDER 1 IN 0
ENDI
IF useicd3
	dbfuse = codedir+'icd103'
	USE (codedir+'icd103') ORDER 1 IN 0
ENDI
IF usedoctor
	dbfuse = codedir+'doctor'
	USE (codedir+'doctor') ORDER 1 IN 0
ENDI
dbfuse = ''
SELE patient1
SET RELA TO hn INTO patient2
SET RELA TO hn INTO contact ADDI
SET RELA TO hn INTO newcase ADDI
GO nowrec
SCAT MEMV