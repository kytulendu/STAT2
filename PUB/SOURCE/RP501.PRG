***************************************************************
**							*  �����  RP501  *             **
***************************************************************
FS=CHR(27)
V_enlarge=CHR(14)
C_v_enlarge=CHR(4)
_PLENGTH = 33
IF  ! microwiz
	startrow= 3
	IF ! CancelPrint()
		SET DEVI TO PRINT
		mhn='       '
		mhn=subs(m.hn,1,7)
		SELE patient1
		seek m.hn
		DIME Tmonth(12),ProvArr(60)
		SELE social
		@ 0,1 SAY '�Է�ԡ���ѡ��'
		SEEK m.pttyp
		@ 0,16 say chr(27)+'E'+TRIM(name)+chr(27)+'F'
		@ startrow+1,8 SAY chr(27)+'E'+subs(m.an,3,5)+'-'+subs(m.an,1,2)+chr(27)+'F'
		SELE patient1
		@ startrow+1,67 SAY 'HN'
		@ startrow+1,71 SAY chr(27)+'E'+hn+chr(27)+'F'
		SELE patient1 
		mat=AT(',',name)
		IF mat>0
			mname1=SUBS(name,mat+1,LEN(TRIM(name))-mat)+LEFT(name,mat-1)
		ELSE
			mname1=name
		ENDI
		@ startrow+2,5 SAY CHR(27)+'E'+mname1+CHR(27)+'F'
		SELE patient2
		mmarriage=patient2->marriage
		@ startrow+2,58 SAY marry&mmarriage
		SELE contact
		@ startrow+4,2 SAY TRIM(contact->address)+;
		IIF(VAL(contact->village)>0,' ���� '+TRIM(contact->village),'')
		SELE address
		SEEK '3'+contact->changwat+contact->ampur+contact->tambon
		@ startrow+4,PCOL()+1 SAY IIF(empty(name),'','�.'+TRIM(name))
		SEEK '2'+contact->changwat+contact->ampur
		@ startrow+4,PCOL() SAY IIF(EMPTY(name),'',' �.'+TRIM(name))
		SEEK '1'+contact->changwat
		@ startrow+4,PCOL()+1 SAY '�.'+TRIM(name)
		SELE patient1
		@ startrow+4,60 SAY IIF(sex='1','���','˭ԧ') 
		SELE nation
		SEEK patient2.nation
		@ startrow+6,33 SAY TRIM(name)
		SELE occupat
		SEEK patient2->occupa
		@ startrow+6,50 SAY TRIM(name)	&& �Ҫվ
		@ startrow+7,10 SAY TRIM(DE_NAME(patient2.contact))
		mage=Nowage(patient1->birthday,patient1.derive)
		thaidate=Ce2Cbe(patient1->birthday)
		curyear=year(date())+543
		@ startrow+7,39 SAY thaidate
		@ startrow+7,56 SAY mage
		SELE contact
		IF owner = '3'
			@ startrow+8,10 SAY '�.�.�.'
		ELSE
			SKIP
			@ startrow+8,2 SAY TRIM(contact->address)+;
			IIF(VAL(contact->village)>0,' ���� '+contact->village,'')
			SELE address
			SEEK '3'+contact->changwat+contact->ampur+contact->tambon
			@ startrow+8,PCOL()+1 SAY IIF(name='    ','','�.'+TRIM(name))
			SEEK '2'+contact->changwat+contact->ampur
			@ startrow+8,PCOL() SAY IIF(name='    ','',' �.'+TRIM(name))
			SEEK '1'+contact->changwat
			@ startrow+8,PCOL()+1 SAY '�.'+TRIM(name)
		ENDI
		SELE patient1
		@ startrow+9,54 SAY CE2BE(m.dateadm)
		SELE ward
		set order to 1
		@ startrow+10,21 SAY  CHR(27)+'E'+m.result+CHR(27)+'F'
		SEEK m.ward_adm
		@ startrow+11,37 SAY  CHR(27)+'E'+name+CHR(27)+'F'
		@ startrow+16,0 SAY ' '
		EJECT
	ELSE
		?? CHR(7)
		WAIT WIND '���������������Ţ��� AN '+RIGHT(m.an,5)+'-'+LEFT(m.an,2) TIME 10
	ENDI
	SET DEVI TO SCREE
ELSE
	startrow= 4 	&& microwiz
	IF ! CancelPrint()
		SET DEVI TO PRINT
		mhn='       '
		mhn=subs(m.hn,1,7)
		SELE patient1
		seek m.hn
		DIME Tmonth(12),ProvArr(60)
		SELE social
		@ 0,1 SAY '�Է�ԡ���ѡ��'
		SEEK m.pttyp
		@ 0,16 say chr(27)+'E'+TRIM(name)+chr(27)+'F'
		@ startrow+1,8 SAY CHR(27)+'E'+subs(m.an,3,5)+'-'+subs(m.an,1,2) +CHR(27)+'F'
		SELE patient1
		@ startrow+1,67 SAY 'HN'
		@ startrow+1,71 SAY CHR(27)+'E'+hn+CHR(27)+'F'
		SELE patient1 
		mat=AT(',',name)
		IF mat>0
			mname1=SUBS(name,mat+1,LEN(TRIM(name))-mat)+LEFT(name,mat-1)
		ELSE
			mname1=name
		ENDI
		SELE patient2
		mmarriage=patient2->marriage
		@ startrow+2,58 SAY marry&mmarriage
		@ startrow+3,5 SAY CHR(27)+'E'+mname1+CHR(27)+'F'
		SELE contact
		@ startrow+5,2 SAY TRIM(contact->address)+;
		IIF(VAL(contact->village)>0,' ���� '+TRIM(contact->village),'')
		SELE address
		SEEK '3'+contact->changwat+contact->ampur+contact->tambon
		@ startrow+5,PCOL()+1 SAY IIF(empty(name),'','�.'+TRIM(name))
		SEEK '2'+contact->changwat+contact->ampur
		@ startrow+5,PCOL() SAY IIF(EMPTY(name),'',' �.'+TRIM(name))
		SEEK '1'+contact->changwat
		@ startrow+5,PCOL()+1 SAY '�.'+TRIM(name)
		SELE patient1
		@ startrow+5,60 SAY IIF(sex='1','���','˭ԧ') 
		SELE nation
		SEEK patient2.nation
		@ startrow+7,33 SAY TRIM(name)
		SELE occupat
		SEEK patient2->occupa
		@ startrow+7,50 SAY TRIM(name)	&& �Ҫվ
		@ startrow+9,10 SAY TRIM(DE_NAME(patient2.contact))
		mage=Nowage(patient1->birthday,patient1.derive)
		thaidate=Ce2Cbe(patient1->birthday)
		curyear=year(date())+543
		@ startrow+9,39 SAY thaidate
		@ startrow+9,56 SAY mage
		SELE contact
		IF owner = '3'
			@ startrow+10,10 SAY '�.�.�.'
		ELSE
			SKIP
			@ startrow+10,2 SAY TRIM(contact->address)+;
			IIF(VAL(contact->village)>0,' ���� '+contact->village,'')
			SELE address
			SEEK '3'+contact->changwat+contact->ampur+contact->tambon
			@ startrow+10,PCOL()+1 SAY IIF(name='    ','','�.'+TRIM(name))
			SEEK '2'+contact->changwat+contact->ampur
			@ startrow+10,PCOL() SAY IIF(name='    ','',' �.'+TRIM(name))
			SEEK '1'+contact->changwat
			@ startrow+10,PCOL()+1 SAY '�.'+TRIM(name)
		ENDI
		SELE patient1
		@ startrow+12,50 SAY CE2BE(m.dateadm)
		SELE ward
		@ startrow+13,21 SAY  CHR(27)+'E'+m.result+CHR(27)+'F'
		SEEK m.ward_adm
		@ startrow+14,32 SAY  CHR(27)+'E'+name+CHR(27)+'F'
		@ startrow+16,0 SAY ' '
		EJECT
	ELSE
		?? CHR(7)
		WAIT WIND '���������������Ţ��� AN '+RIGHT(m.an,5)+'-'+LEFT(m.an,2) TIME 10
	ENDI
	SET DEVI TO SCREE
ENDI
