SET ESCA ON
DEFI WIND accrep FROM 08,10 TO 15,70 SHAD TITLE '��§ҹ�����¤��'
ACTI WIND accrep
STORE CE2BE(DATE()-1,2) TO startdate,enddate
STORE SPAC(9) TO typefind
@ 1,3 SAY '�ҵ�����ѹ���  ' GET startdate VALID Truedate(startdate) PICT '##/##/##'
@ 3,3 SAY '���֧�ѹ���      ' GET enddate VALID Truedate(enddate) PICT '##/##/##'
@ 5,3 SAY '��������շ���ͧ����� ' GET typefind PICT '#########'
READ NOLOCK
IF LASTKEY() = 27 .OR. LEFT(startdate,2) = '  ' .OR. LEFT(enddate,2) = '  ' ;
.OR. EMPTY(typefind)
	=ALARM1()
	WAIT WIND NOWA '¡��ԡ��÷���§ҹ�����ͧ���'
ELSE
	mstartdate = BE2CE(startdate)
	menddate = BE2CE(enddate)
	IF mstartdate > menddate
		=SWAP(mstartdate,menddate)
		=SWAP(startdate,enddate)
	ENDI
	mtypefind = ALLTRIM(typefind)
	startfile = RIGHT(startdate,2)+SUBS(startdate,4,2)
	endfile = RIGHT(enddate,2)+SUBS(enddate,4,2)
	tmpdbf = tempdir+SYS(3)
	SELE 0
	dbfuse = tmpdbf
	CREAT TABLE (tmpdbf) ;
		(forensic C(1),NAME C(30),HN C(7),treatment C(40))
		INDEX ON treatment TAG treatment
	USE (tmpdbf) ORDER 1 ALIA target
	SELE 0
	dbfuse = ''
	DO WHIL startfile <= endfile
		dbfuse = opddir+'CAME'+startfile
		USE (opddir+'came'+startfile) ALIA camefile
		SET RELA TO hn INTO patient1,hn INTO iptrana
		dbfuse = ''
		DEFINE WIND show FROM 1,60 TO 5,64 SHAD
		ACTI WIND show
		numrec = 1
		SCAN
			numrec = numrec+1
			DO CASE
				CASE MOD(numrec,4) = 2
					@ 1,1 SAY '/'
				CASE MOD(numrec,4) = 0
					@ 1,1 SAY '\'
				OTHER
					@ 1,1 SAY '|'
			ENDC
			IF BETWEEN(date,mstartdate,menddate) .AND. sequence = 1 ;
			.AND. forensic $ mtypefind
				m.hn = hn
				m.forensic = forensic
				m.name = De_name(patient1.name)
				m.result = result
				DO CASE
					CASE m.result = '51'
						m.treatment = '�����Ǩ��Ѻ'
					CASE m.result = '52'
						m.treatment = '�����·�� OPD'
					CASE m.result = '53'
						m.treatment = '�����觻�֡��Ἱ����'
					CASE m.result = '54'
						m.treatment = '�����觵����ѡ�ҷ�����'
					CASE m.result = '  '
						m.treatment = '��������š���ѡ��'
					OTHER
						SELE iptrana
						IF SEEK(m.hn)
							m.an = an
							m.rec = recno()
							DO WHIL hn = m.hn .AND. ! EOF()
								m.rec = IIF(m.an>an,m.rec,RECNO())
								m.an = IIF(m.an>an,m.an,an)
								SKIP
							ENDD
							GO m.rec
							SELE ward
							SEEK iptrana.ward_now
							m.treatment = '�Ѻ���'+name
						ELSE
							SELE ward
							SEEK m.result
							m.treatment = TRIM(name)+' ��Ѻ��ҹ����'
						ENDI
				ENDC
				INSERT INTO target FROM MEMV
			ENDI
			SELE camefile
		ENDS
		RELE WIND show
		SELE camefile
		USE
		IF RIGHT(startfile,2)='12'
			startfile = STRZERO(VAL(LEFT(startfile,2))+1,2)+'01'
		ELSE
			startfile = LEFT(startfile,2)+STRZERO(VAL(RIGHT(startfile,2))+1,2)
		ENDI
	ENDD
	SELE target
	GO TOP
	DO StartPrint
	reportfile=tempdir+SYS(3)+'.txt'
	SET PRINT TO &reportfile
	SET PRINT ON
	SET CONS OFF
	ON PAGE AT line _plength-2 DO accrepheader WITH .T.
	WAIT WIND NOWA '�ô��� ���ѧ�������§ҹ����'
	ACTI SCREE
	m.treatment = '  '
	num = 0
	totalnum = 0
	PRINTJOB
		DO accrepheader WITH .F.
		DO WHIL ! EOF()
			num = num + 1
			totalnum = totalnum + 1
			IF m.treatment # treatment
				m.treatment = treatment
				? m.treatment
				num = 1
			ENDI
			? STR(num,5)+'.'+SPACE(8)+hn+SPACE(5)+name+SPACE(8)+forensic
			SKIP
		ENDD
	ENDPRINT
	KEYB '!'
	mkeylabel=ON('KEY','F1')
	ON KEY LABEL F1 DO helpbrow
	DO Endprint WITH '  ��§ҹ�����¤��  ',reportfile
	ON KEY LABEL F1 &mkeylabel
	SELE target
	USE
	DELE FILE (tmpdbf+.'dbf')
	DELE FILE (tmpdbf+.'cdx')
	DELE FILE (reportfile)
ENDI
RELE WIND accrep

PROC AccRepheader
PARA _foreject
PRIVATE mprint,mhosp,_header
IF _foreject
	eject page
	eject
?
ENDI

	mpagep=LTRIM(STR(_pageno))
_header = '��§ҹ�����¤�յ�����ѹ��� '+CE2CBE(mstartdate)+' �֧�ѹ��� '+CE2CBE(menddate)
?'˹�ҷ�� '+mpagep
? SPACE(Center(_header))+_header
?'........................................................................'
?' �ӴѺ���  �Ţ�������¹͡    ���� - ���ʡ��               ���������'
?'........................................................................'
?
