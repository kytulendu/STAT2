PRIV openpatient1,starthn,endhn
DEFINE WIND add_srv FROM 6,1 TO 16,78 SHAD
ACTI WIND add_srv
CLEA
DO OpenLanMaster
SELE patient1
SET ORDER TO TAG hn
STORE 0 TO starthn,endhn
@ 3,10 SAY '�����ѵôѪ�յ�����Ţ���  ' GET starthn PICT '9999999'
@ 5,10 SAY '           �֧�Ţ���         ' GET endhn PICT '9999999'
READ NOLOCK
starthn = STRZERO(starthn,7)
endhn = STRZERO(endhn,7)
IF starthn > endhn
	=SWAP(starthn,endhn)
ENDI
GO BOTT
IF hn < starthn
	=ALARM1()
	WAIT WIND NOWA '�Ţ�������¹͡�ش���·���դ�� '+hn
	DEACTI WIND add_srv
	RETU
ENDI
DO WHIL ! SEEK(starthn) .AND. endhn >= starthn
	starthn = STRZERO(VAL(starthn)+1,7)
ENDD
IF EOF()
	=ALARM1()
	WAIT WIND '��辺�Ţ�������¹͡�������к�' TIME 10
ELSE
	SELE 0
	tmpfile = SYS(3)
	dbfuse = tempdir+tmpfile
	CREA TABLE (tempdir+tmpfile)  ;
	( hn C(7),name C(30),thaisound C(8),birthday D,;
	mother C(30),address1 C(30),address2 C(30) )
	USE (tempdir+tmpfile) ALIA target
	dbfuse = ''
	SELE patient1
	DO WHIL starthn <= endhn .AND. ! EOF()
		SCAT MEMV
		m.name = DE_NAME(name)
		m.thaisound = ThaiSoundex(name)
		SELE contact
		m.address1 = TRIM(contact->address)+;
		IIF(VAL(contact->village)>0,' ���� '+TRIM(contact->village),'')
		SELE address
		SEEK '3'+contact->changwat+contact->ampur+contact->tambon
		m.address1 = m.address1+' '+ IIF(empty(name),'','�.'+TRIM(name))
		SEEK '2'+contact->changwat+contact->ampur
		m.address2 = IIF(EMPTY(name),'','�.'+TRIM(name))
		SEEK '1'+contact->changwat
		m.address2 = m.address2 + ' �.'+TRIM(name)
		SELE patient1
		INSERT INTO target FROM MEMV
		SKIP
		starthn = hn
	ENDD
	SELE target
	IF RECCOUNT() > 0
		DIME linepr[7]
		numblock = 1
		DEFINE WIND askprin FROM 10,20 TO 15,60 SHAD
		ACTI WIND askprin
		@ 1,5 PROMPT '1. ������д�ɷ�����'
		@ 2,5 PROMPT '2. ������д�ɵ�����ͧ'
		MENU TO chprin
		prcont =  IIF(chprin = 1,.F.,.T.)
		RELE WIND askprin
		IF ! CancelPrint()
			GO TOP
			SET PRIN ON
			DO WHIL ! EOF()
				linepr[1] = SPACE(28)+ThaiSoundex(name)+SPACE(4)
				linepr[2] = '�Ţ�������¹͡ ' + hn + SPACE(16)
				linepr[3] = '����  '+ name +SPACE(4)
				linepr[4] = '������� ' + mother +SPACE(2)
				mbirth = CE2CBE(birthday)
				linepr[5] = '�ѹ�Դ ' + mbirth + SPACE(32-LEN(mbirth))
				linepr[6] = '������� ' + address1 + SPACE(2)
				linepr[7] = '    ' + address2 + SPACE(6)
				SKIP
				IF ! EOF()
					linepr[1] = linepr[1] + SPACE(28)+ThaiSoundex(name)+SPACE(4)
					linepr[2] = linepr[2] + '�Ţ�������¹͡ ' + hn + SPACE(16)
					linepr[3] = linepr[3] + '����  '+ name +SPACE(4)
					linepr[4] = linepr[4] + '������� ' + mother +SPACE(2)
					mbirth = CE2CBE(birthday)
					linepr[5] = linepr[5] + '�ѹ�Դ ' + mbirth + SPACE(32-LEN(mbirth))
					linepr[6] = linepr[6] + '������� ' + address1 + SPACE(2)
					linepr[7] = linepr[7] + '    ' + address2 + SPACE(6)
					SKIP
				ENDI
				FOR i = 1 TO 7
					? linepr[i]
				NEXT
				?
				?
				?
				IF numblock = 4
					EJECT
					numblock = 0
					IF ! prcont
						=ALARM1()
						WAIT WIND '��س�����¹��д�� ���ǡ��������á���'
					ENDI
				ENDI
				numblock = numblock + 1
			ENDD
		ENDI
		IF numblock > 1
			EJECT
		ENDI
		SET PRIN OFF
	ENDI
	USE
	DELE FILE (tempdir+tmpfile+'.dbf')
ENDI
DEAC WIND add_srv
CLOSE DATA