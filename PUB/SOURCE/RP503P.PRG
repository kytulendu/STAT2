***************************************************************
**							*  โปรแกรม  RP503  *             **
***************************************************************
FS=CHR(27)
V_enlarge=CHR(14)
C_v_enlarge=CHR(4)
_PLENGTH = 33
IF ! microwiz
startrow= 3
IF ! CancelPrint()
	SET DEVI TO PRINT
	mhn='       '
	mhn=subs(m.hn,1,7)
	SELE patient1
	seek m.hn
	DIME Tmonth(12),ProvArr(60)
	SELE social
*	@ 0,1 SAY 'สิทธิการรักษา'
*	SEEK m.pttyp
*	@ 0,16 say chr(27)+'E'+TRIM(name)+chr(27)+'F'

	*if m.pttyp ='34'
		*	@ 0,65 SAY 'SSN NUMBER '+m.ssn
	*endif
	@ startrow+1,5 SAY CHR(27)+'E'+subs(m.an,3,5)+'-'+subs(m.an,1,2) +CHR(27)+'F'

	SELE patient1
	@ startrow+1,24 SAY 'HN'
	@ startrow+1,28 SAY CHR(27)+'E'+hn+CHR(27)+'F'

	*row=row+1

	SELE patient1 
	*row=row+6
	mat=AT(',',name)
	IF mat>0
		mname1=SUBS(name,mat+1,LEN(TRIM(name))-mat)+LEFT(name,mat-1)
	ELSE
		mname1=name
	ENDI
	@ startrow+3,5 SAY CHR(27)+'E'+mname1+CHR(27)+'F'
	@ startrow+5,0 SAY ''
	
	EJECT
ELSE
	?? CHR(7)
	WAIT WIND 'ไม่ได้พิมพ์ผู้ป่วยเลขที่ AN '+RIGHT(m.an,5)+'-'+LEFT(m.an,2) TIME 10
ENDI
SET DEVI TO SCREE
ELSE
***************************************************************
**							*  โปรแกรม  RP501  *             **
***************************************************************
_PLENGTH = 33
startrow= 3
IF ! CancelPrint()
	SET DEVI TO PRINT
	mhn='       '
	mhn=subs(m.hn,1,7)
	SELE patient1
	seek m.hn
	DIME Tmonth(12),ProvArr(60)
	SELE social
*	@ 0,1 SAY 'สิทธิการรักษา'
*	SEEK m.pttyp
*	@ 0,16 say chr(27)+'E'+TRIM(name)+chr(27)+'F'

	*if m.pttyp ='34'
		*	@ 0,65 SAY 'SSN NUMBER '+m.ssn
	*endif
	@ startrow+2,5 SAY CHR(27)+'E'+subs(m.an,3,5)+'-'+subs(m.an,1,2) +CHR(27)+'F'

	SELE patient1
	@ startrow+2,24 SAY 'HN'
	@ startrow+2,28 SAY CHR(27)+'E'+hn+CHR(27)+'F'

	*row=row+1

	SELE patient1 
	*row=row+6
	mat=AT(',',name)
	IF mat>0
		mname1=SUBS(name,mat+1,LEN(TRIM(name))-mat)+LEFT(name,mat-1)
	ELSE
		mname1=name
	ENDI
	@ startrow+5,5 SAY CHR(27)+'E'+mname1+CHR(27)+'F'
	@ startrow+5,0 SAY ''
	
	EJECT
ELSE
	?? CHR(7)
	WAIT WIND 'ไม่ได้พิมพ์ผู้ป่วยเลขที่ AN '+RIGHT(m.an,5)+'-'+LEFT(m.an,2) TIME 10
ENDI
SET DEVI TO SCREE
endi