**************************************************************************
*    						 MEDREC
**************************************************************************
@ 3,0 clear to 20,78
@ 22,0 clear to 24,78
SELE patient1
SET RELA TO
DIME REC(4),RecMess(4)
Rec(1)=padr('������',20,' ')
Rec(2)=padr('�׹���',20,' ')
Rec(3)=padr('�����ҧ��',20,' ')
Rec(4)=padr('��ԡ�ҹ',20,' ')
RecMess(1)='�������������͡�ҡ��ͧ�ѵ�'
RecMess(2)='�׹���������'
RecMess(3)='�������ª��������ҧ��'
RecMess(4)=''
numrec = 4
DEFINE WIND RECMENU FROM 4,5 TO 4+ALEN(REC)+3,35 SHAD COLO gr+/w TITLE '  ���/�׹��������¹͡ '
DO WHIL .T.
	ACTI WIND RECMENU
	FOR i=1 TO ALEN(REC)
		@ i,3 PROMPT REC(i)
	NEXT
	MENU TO ChRec
	ACTI SCREE
	DO CASE
		CASE ChRec = 1
            DO request
			DO CLEARSCREEN
		CASE ChRec = 2
            DO comeback
			DO CLEARSCREEN
		CASE ChRec = 3
      	    Do printrec
			DO CLEARSCREEN
		CASE ChRec = 4
			RELE WIND RECMENU
	    	RETURN
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND RECMENU
*SET COLO TO bg+/b

********************
PROC REQUEST
********************
DEAC WIND RECMENU
DO WHILE .T.

 @ 3,0 clear to 20,78
 @ 22,0 clear to 24,78
 
 SELE medrec
 scat memvar blank
 
 dimension rmenu(2)
 rmenu(1)='    �ѹ�֡      '
 rmenu(2)='     ���      '

 store .F. to mexit
 DO WHILE  NOT mexit

  mhn=0
  @ 4,2 say 'HN.'
  @ 4,45 say '����'
  @ 4,8 get mhn size 1,7 picture '9999999' && Valid !empty(mhn)
   	 READ NOLOCK
 	if LASTKEY() = 27 .OR. EMPTY(mhn)
		wait '¡��ԡ���������' window timeout 1
		DO ClearScreen
		RecSpace=78/NumRec    && ������ҧ�����ҧ������¡��
		return to medrec
	endif
	m.hn=padl(alltrim(str(mhn)),7,'0')
  SELE patient1
	seek m.hn
		IF .NOT. FOUND()
			WAIT "����� HN ���  ��������������� HN ����" window
			@ 3,0 clear to 20,78
			loop
		ENDIF	
	@ 4,50 say De_Name(name)
  SELE medrec
*  	set filter to status=.F.
 	seek m.hn
		IF FOUND()
			WAIT "�ռ�������� HN ������� ��������������� HN ����" window
			@ 3,0 clear to 20,78
			loop
		ENDIF	
   store .T. TO mexit
 ENDDO

   m.status = .F.
   m.time=substr(time(),1,2)+substr(time(),4,2)
   m.date=date()
   	
   @ 5,10 say '�ѹ������'
   @ 5,20 say ce2be(date())
   @ 6,10 say '������'
   @ 6,20 get m.who
	READ NOLOCK
   m.who=padblank(m.who,6)
 @ 23,0 clear
		n=1
		for n=1 to 2
			@ 23,(n-1)*25+5 prompt rmenu(n)
		endfor
		menu to choice
		do case 
			case choice=1   && ��¡�õ���
				do INS_REQ
				loop
			case choice=2
				@ 3,0 clear to 20,78
				@ 22,0 clear to 24,78
				loop
		endcase
ENDDO

************
PROC INS_REQ
************
SELE medrec

SET REPROCESS TO 2 SECONDS
 IF FLOCK()
 		go top
		if ! empty(hn) .or. eof()
			appe blank
		endif	
			gather memvar
			FLUSH
			scat memvar blank
		SELE patient1
		REPL clinic WITH RIGHT(m.who,3)
		FLUSH
		WAIT '�ѹ�֡������������º��������' WIND TIME 1 
 ELSE
       	WAIT '�������ö�ѹ�֡����������� ¡��ԡ��÷ӧҹ' WIND TIME 1
 ENDIF

UNLOCK ALL
SET REPROCESS TO AUTOMATIC
@ 3,0 clear to 20,78
@ 22,0 clear to 24,78

*************
PROC COMEBACK
*************
DEAC WIND RECMENU
DO WHILE .T.

 @ 3,0 clear to 20,78
 @ 22,0 clear to 24,78

 dimension cmenu(2)
 cmenu(1)='     �ѹ�֡     '
 cmenu(2)='     ���      '

 store .F. to mexit
 DO WHILE  NOT mexit

  mhn=0
  @ 4,2 say 'HN.'
  @ 4,45 say '����'
  @ 4,8 get mhn size 1,7 picture '9999999' && valid !empty(mhn)
   	 READ NOLOCK
 	if LASTKEY() = 27 .OR. EMPTY(mhn)
		wait '¡��ԡ��¡�ä׹���' window timeout 1
		DO ClearScreen
		RecSpace=78/NumRec    && ������ҧ�����ҧ������¡��
		return to medrec
	endif
	m.hn=padl(alltrim(str(mhn)),7,'0')
  SELE patient1
	IF seek(m.hn)
		@ 4,50 say De_Name(name)
	ELSE
		WAIT "����� HN ���  ��������������� HN ����" window
		@ 3,0 clear to 20,78
		loop
	ENDIF	
  SELE medrec
 	IF ! seek(m.hn)
		WAIT "�������¡����� HN ���  ��������������� HN ����" window
		@ 3,0 clear to 20,78
		loop
    ELSE	
		scat memvar
	ENDI	
	  store .T. TO mexit
 ENDDO

   m.status = .T.
   @ 5,10 say '�ѹ������'
   @ 5,20 say ce2cbe(m.date)
   @ 6,10 say '������'
   @ 6,20 say m.who
   @ 7,10 say '�ѹ���׹'
   @ 7,20 say ce2cbe(date())
   
 @ 23,0 clear
		n=1
		for n=1 to 2
			@ 23,(n-1)*25+5 prompt cmenu(n)
		endfor
		menu to choice
		do case 
			case choice=1   && ��¡�õ���
				do INS_CAME
				loop
			case choice=2
				@ 3,0 clear to 20,78
				@ 22,0 clear to 24,78
				loop
		endcase
ENDDO

*************
PROC INS_CAME
*************
mreturn = ce2be(date())
yy = subs(mreturn,9,2)

SELE 0
 target=patientdir+'FILE'+yy+'.DBF'
	dbfuse = target
	if !file(target)
		create table (target) (HN C(7), DATE D, TIME C(4), WHO C(6), STATUS L)
	endif
 USE (target) alias  CAMEFILE
 dbfuse = ''
SELE medrec

SET REPROCESS TO 2 SECONDS
 IF FLOCK()
		insert into  CAMEFILE from memvar
		FLUSH
			scat memvar blank
			gather memvar
			FLUSH
		SELE patient1
		REPL clinic WITH 'ZZZ'
		FLUSH
		WAIT '�ѹ�֡��ä׹������º��������' WIND TIME 1 
 ELSE
       	WAIT '�������ö�ѹ�֡��ä׹����� ¡��ԡ��÷ӧҹ'
 ENDIF

UNLOCK ALL
SELE camefile
	use
SET REPROCESS TO AUTOMATIC
@ 3,0 clear to 20,78
@ 22,0 clear to 24,78

***********************
PROC PRINTREC
***********************
DEAC WIND RECMENU
dimension Pmenu(2)
 Pmenu(1)=' �ʴ������ŷҧ���Ҿ'
 Pmenu(2)=' ����������ŧ��д�� '

mdate1=ce2be(date())
SELE MEDREC
SET ORDER TO TAG hn
SET RELA TO hn INTO PATIENT1

@ 3,0 clear to 20,78
@ 22,0 clear to 24,78
SET FILT TO STATUS = .F.
SET ORDER TO TAG date

@ 11,2 say '�ѹ���������'
@ 11,28 get mdate1  PICT '99/99/9999' VALID TRUEDATE(mdate1) ;
 		MESS '����ѹ ��͹ �� �繻վط��ѡ�Ҫ'
	READ NOLOCK

MDATEREQ=BE2CE(MDATE1)
IF ! seek(mdatereq)
	=TONE(1200,5)
	=TONE(700,5)
	WAIT WIND NOWA '����������ҧ��'
ELSE
	WAIT WIND NOWA '�ô����ѡ���� ���ѧ���Ң���������'
	SELE 0
	reportdbf = tempdir+SYS(3)
	dbfuse = reportdbf
	CREATE TABLE (reportdbf) ;
		(HN C(7),NAME C(36),D_REQ C(12),WHO C(6),STATUS L)
	USE (reportdbf) ALIA reportdbf
	dbfuse = ''
	SELE medrec
	DO WHILE date = MDATEreq .AND. ! EOF()
		scat fields HN, DATE, WHO, STATUS memvar
		m.d_req=ce2cbe(m.date)
		m.name = patient1.name
*		SELE WARD
*			set order to tag clinic
*			SEEK m.ward_now
*			m.wardname=NAME 
		INSERT INTO (reportdbf)  FROM memvar								
		FLUSH
		skip
	ENDDO

	SELE reportdbf
	index on who+hn tag whohn
	set order to 1
	totalnumber = RECCOUNT()
	reportfile=tempdir+SYS(3)+'.txt'
	SET PRINT TO &reportfile
	SET PRINT ON
	SET CONS OFF
	_wrap=.F.
	_plength=41
	_peject='NONE'
	_pageno=1
	_plineno=0
	_PLOFFSET = 0
	header = '       ��ª����������ѧ����觤׹  '
	ON PAGE AT line _plength-2 DO fileborrow WITH .T.,header
	KEYB ' '
	WAIT WIND NOWA '�ô����ա�ѡ���� ���ѧ�Ѵ����§ҹ����'
	PRINTJOB
		DO fileborrow WITH .F.,header
		SCAN
			? hn,'    ',De_Name(name) ,'   ',who
		ENDS
		?
		? '�����˵�'
		? SPACE(10)+'�����ҧ�觷�����������ѹ��� '+CE2CBE(MDATEREQ)
		? SPACE(10)+'�ӹǹ�����ҧ����� '+LTRIM(STR(totalnumber))+' ���'
		?
	ENDPRINTJOB
	mkeylabel=ON('KEY','F1')
	ON KEY LABEL F1 DO helpbrow
	DO Endprint WITH '  ��ª����������ѧ����觤׹  ',reportfile
	ON KEY LABEL F1 &mkeylabel
	DELE FILE &reportfile
	SELE reportdbf
	USE
	DELE FILE (reportdbf+'.DBF')
ENDI

@ 3,0 clear to 20,78
@ 22,0 clear to 24,78
SELE MEDREC
set order to tag HN

PROC FILEBORROW
PARA _foreject,_header
PRIVATE mprint,mhosp
mhosp=TRIM(hosp_name)
*mtime1='������ѹ��� '+CE2CBE(startdate)+' �֧ �ѹ��� '+CE2CBE(enddate)
IF _foreject
	eject page
	eject
ENDI
mpagep='˹�ҷ�� '+LTRIM(STR(_pageno))
spacecol=CENTER(_header)
?SPACE(spacecol)+_header+SPACE(65-spacecol-LEN(_header))+mpagep
?SPAC(CENTER(mhosp))+mhosp
?
?' �Ţ�������¹͡          ���� - ���ʡ��          ���������'
?
IF _foreject
	?
ENDI

