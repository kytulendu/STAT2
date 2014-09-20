***************************************************************
**							*  โปรแกรม  RP502  *             **
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
*	SELE social
*	@ 0,1 SAY 'สิทธิการรักษา'
*	SEEK m.pttyp
*	@ 0,16 say chr(27)+'E'+TRIM(name)+chr(27)+'F'

	*if m.pttyp ='34'
		*	@ 0,65 SAY 'SSN NUMBER '+m.ssn
	*endif
	@ startrow+1,52 SAY CHR(27)+'E'+subs(m.an,3,5)+'-'+subs(m.an,1,2) +CHR(27)+'F'

	SELE patient1
	@ startrow+1,67 SAY 'HN'
	@ startrow+1,71 SAY CHR(27)+'E'+hn+CHR(27)+'F'

	*row=row+1

	SELE patient1 
	*row=row+6
	mat=AT(',',name)
	IF mat>0
		mname1=SUBS(name,mat+1,LEN(TRIM(name))-mat)+LEFT(name,mat-1)
	ELSE
		mname1=name
	ENDI
	@ startrow+2,5 SAY CHR(27)+'E'+mname1+CHR(27)+'F'
	SELE patient2
	mmarriage=patient2->marriage
	@ startrow+2,60 SAY marry&mmarriage
	*row=row+2

	SELE contact
	@ startrow+3,2 SAY TRIM(contact->address)+;
	IIF(VAL(contact->village)>0,' หมู่ '+TRIM(contact->village),'')

	SELE address
	SEEK '3'+contact->changwat+contact->ampur+contact->tambon
	@ startrow+3,PCOL()+1 SAY IIF(empty(name),'','ต.'+TRIM(name))
	SEEK '2'+contact->changwat+contact->ampur
	@ startrow+3,PCOL() SAY IIF(EMPTY(name),'',' อ.'+TRIM(name))
	SEEK '1'+contact->changwat
	@ startrow+3,PCOL()+1 SAY 'จ.'+TRIM(name)

	SELE patient1
*	@ startrow+5,60 SAY IIF(sex='1','ชาย','หญิง') 
	SELE nation
	SEEK patient2.nation
	@ startrow+5,33 SAY TRIM(name)
	SELE occupat
	SEEK patient2->occupa
	*row=row+2
	@ startrow+5,50 SAY TRIM(name)	&& อาชีพ

	*row=row+2
	@ startrow+6,10 SAY TRIM(DE_NAME(patient2.contact))
	mage=Nowage(patient1->birthday,patient1.derive)
	thaidate=Ce2Cbe(patient1->birthday)
	curyear=year(date())+543
	@ startrow+6,39 SAY thaidate
	@ startrow+6,56 SAY mage
	SELE contact
	IF owner = '3'
		@ startrow+7,10 SAY 'บ.ด.ก.'
	ELSE
		SKIP
		@ startrow+7,2 SAY TRIM(contact->address)+;
		IIF(VAL(contact->village)>0,' หมู่ '+contact->village,'')
		SELE address
		SEEK '3'+contact->changwat+contact->ampur+contact->tambon
		@ startrow+7,PCOL()+1 SAY IIF(name='    ','','ต.'+TRIM(name))
		SEEK '2'+contact->changwat+contact->ampur
		@ startrow+7,PCOL() SAY IIF(name='    ','',' อ.'+TRIM(name))
		SEEK '1'+contact->changwat
		@ startrow+7,PCOL()+1 SAY 'จ.'+TRIM(name)
	ENDI
	
	SELE patient1
	*@ startrow+row,35 SAY '('+str(curyear,4,2)+')'
	*row=row+3  && admit information              

	@ startrow+8,54 SAY CE2BE(m.dateadm)
	*row=row+2
	SELE ward
*	SEEK m.result
*	@ startrow+10,21 SAY  CHR(27)+'E'+m.result+CHR(27)+'F'
	SEEK m.ward_adm
	@ startrow+10,37 SAY  CHR(27)+'E'+name+CHR(27)+'F'


	*row=row+2
	*@ startrow+row,0 SAY '  '
	@ startrow+16,0 SAY ' '
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
FS=CHR(27)
V_enlarge=CHR(14)
C_v_enlarge=CHR(4)
_PLENGTH = 33
startrow= 3
IF ! CancelPrint()
	SET DEVI TO PRINT
	mhn='       '
	mhn=subs(m.hn,1,7)
	SELE patient1
	seek m.hn
	DIME Tmonth(12),ProvArr(60)
*	SELE social
*	@ 0,1 SAY 'สิทธิการรักษา'
*	SEEK m.pttyp
*	@ 0,16 say chr(27)+'E'+TRIM(name)+chr(27)+'F'

	*if m.pttyp ='34'
		*	@ 0,65 SAY 'SSN NUMBER '+m.ssn
	*endif
	@ startrow+2,48 SAY CHR(27)+'E'+subs(m.an,3,5)+'-'+subs(m.an,1,2) +CHR(27)+'F'

	SELE patient1
	@ startrow+2,64 SAY 'HN'
	@ startrow+2,68 SAY CHR(27)+'E'+hn+CHR(27)+'F'

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
	*row=row+2

	SELE contact
	@ startrow+4,2 SAY TRIM(contact->address)+;
	IIF(VAL(contact->village)>0,' หมู่ '+TRIM(contact->village),'')

	SELE address
	SEEK '3'+contact->changwat+contact->ampur+contact->tambon
	@ startrow+4,PCOL()+1 SAY IIF(empty(name),'','ต.'+TRIM(name))
	SEEK '2'+contact->changwat+contact->ampur
	@ startrow+4,PCOL() SAY IIF(EMPTY(name),'',' อ.'+TRIM(name))
	SEEK '1'+contact->changwat
	@ startrow+4,PCOL()+1 SAY 'จ.'+TRIM(name)
	SELE patient2
	mmarriage=patient2->marriage
	@ startrow+4,60 SAY marry&mmarriage

	SELE patient1
*	@ startrow+5,60 SAY IIF(sex='1','ชาย','หญิง') 
	SELE nation
	SEEK patient2.nation
	@ startrow+7,33 SAY TRIM(name)
	SELE occupat
	SEEK patient2->occupa
	*row=row+2
	@ startrow+7,44 SAY TRIM(name)	&& อาชีพ

	*row=row+2
	@ startrow+9,10 SAY TRIM(DE_NAME(patient2.contact))
	mage=Nowage(patient1->birthday,patient1.derive)
	thaidate=Ce2Cbe(patient1->birthday)
	curyear=year(date())+543
	@ startrow+9,33 SAY thaidate
	@ startrow+9,50 SAY mage
	SELE contact
	IF owner = '3'
		@ startrow+10,10 SAY 'บ.ด.ก.'
	ELSE
		SKIP
		@ startrow+10,2 SAY TRIM(contact->address)+;
		IIF(VAL(contact->village)>0,' หมู่ '+contact->village,'')
		SELE address
		SEEK '3'+contact->changwat+contact->ampur+contact->tambon
		@ startrow+10,PCOL()+1 SAY IIF(name='    ','','ต.'+TRIM(name))
		SEEK '2'+contact->changwat+contact->ampur
		@ startrow+10,PCOL() SAY IIF(name='    ','',' อ.'+TRIM(name))
		SEEK '1'+contact->changwat
		@ startrow+10,PCOL()+1 SAY 'จ.'+TRIM(name)
	ENDI
	
	SELE patient1
	*@ startrow+row,35 SAY '('+str(curyear,4,2)+')'
	*row=row+3  && admit information              

	@ startrow+11,48 SAY CE2BE(m.dateadm)
	*row=row+2
	SELE ward
*	SEEK m.result
*	@ startrow+10,21 SAY  CHR(27)+'E'+m.result+CHR(27)+'F'
	SEEK m.ward_adm
	@ startrow+14,35 SAY  CHR(27)+'E'+name+CHR(27)+'F'


	*row=row+2
	*@ startrow+row,0 SAY '  '
	@ startrow+16,0 SAY ' '
	EJECT
ELSE
	?? CHR(7)
	WAIT WIND 'ไม่ได้พิมพ์ผู้ป่วยเลขที่ AN '+RIGHT(m.an,5)+'-'+LEFT(m.an,2) TIME 10
ENDI
SET DEVI TO SCREE
ENDI