DO OpenLanMaster
DEAC WIND ALL
DO CLEARSCREEN
@ 23,0 CLEA
expiredate = CE2BE(DATE()-(5*365),2)
@ 12,10 SAY '��ͧ�������ѵ÷���ҵ�Ǩ�����ش���¡�͹�ѹ���  ' ;
GET expiredate PICT '99/99/99' VALID TrueDate(expiredate)
READ NOLOCK
IF LASTKEY() # 27
	tempfile = tempdir+SYS(3)
	SELE 0
	dbfuse = tempfile
	CREA TABLE (tempfile) ;
	(HN C(7),SEX C(4),NAME C(36),LASTDATE D(8),STATUS C(7))
	INDEX ON hn TAG hn
	USE (tempfile) ALIA temp
	dbfuse = ''
	SELE patient1
	SET ORDER TO TAG lastdate DESC
	expiredate = BE2CE(expiredate)
	IF ! SEEK(expiredate)
		GO RECNO(0)
	ENDI
	m.status = '������'
	m.lastdate=lastdate
	DO WHIL lastdate <= m.lastdate .AND. ! EOF()
		m.hn = hn
		m.lastdate = lastdate
		m.name = De_name(name)
		INSERT INTO temp FROM MEMV
		FLUSH
		WAIT WIND ALLTRIM(STR(RECNO('temp'))) NOWA
		SKIP
	ENDD
	SELE temp
	GO TOP
	PUSH KEY CLEA
	ON KEY LABEL F1 DO ExpireHelp
	ON KEY LABEL F2 DO deleall
	ON KEY LABEL F3 DO undeleall
	ON KEY LABEL F4 DO delerest
	ON KEY LABEL F5 DO undelerest
	ON KEY LABEL HOME GO TOP
	ON KEY LABEL END GO BOTT
	ON KEY LABEL CTRL+F DO FindExpire
	ON KEY LABEL CTRL+P DO PrintDele
	ON KEY LABEL ENTER REPL status WITH IIF(status='���','������','���')
	KEYB ' '
	DEFINE WIND show1 FROM 0,30 TO 2,78 SHAD
	ACTI WIND show1
	? '�ӹǹ�ѵ÷����������� '+ALLTRIM(STR(RECCOUNT()))+' �'
	DEFINE WIND browicd FROM 3,2 TO 20,77 SHAD PANEL ;
	TITLE '  ��ª�������Ţ���ѵ÷������  ' FOOT '�� [Esc] ���������'
	ACTI SCREE
		@ 23,0 SAY ;
'               F1 = �ʹ٤������������  CTRL+W = �ӧҹ���'
	BROW FIELD hn :h='�Ţ��� HN',name :h='����-���ʡ��',;
	tdate = CE2CBE(lastdate) :h='�ѹ�Ҥ����ش����', ;
	status :h='���/������' FREE hn WIND browicd NOMO
	SCAN FOR status = '���'
		WAIT WIND NOWA '���ѧ����ѵ��Ţ��� '+temp.hn
		SELE patient1
		SET ORDER TO TAG hn
		DO WHIL SEEK(temp.hn)
			SCAT MEMV BLANK
			GATH MEMV
			FLUSH
		ENDD
		SELE patient2
		DO WHIL SEEK( temp.hn)
			SCAT MEMV BLAN
			GATH MEMV
			FLUSH
		ENDD
		SELE CONTACT
		DO WHIL SEEK(temp.hn)
			SCAT MEMV BLANK
			GATH MEMV
			FLUSH
		ENDD
		SELE temp
	ENDS
	KEYB '!'
	RELE WIND browicd
	RELE WIND show1
	ACTI SCREE
	@ 23,0
	DO CLEARSCREEN
	POP KEY
	USE
	DELE FILE (tempfile+'.dbf')
ENDI

PROC EXPIREHELP
define window instr from 1,0 to 10,78 shadow COLO bg+/gr+
activate window instr
@ 0,1 say 'F2 = ����ѵ�����ء��'
@ 1,1 say 'F3 = �������ѵ÷ء��'
@ 2,1 say 'F4 = ����ѵ÷������͵����㺷��ᶺ�ʧ����'
@ 3,1 say 'F5 = �������ѵ÷������͵����㺷��ᶺ�ʧ����'
@ 4,1 SAY '[HOME] = 价�褹�á'
@ 5,1 SAY '[END] = 价�褹�ش����'
@ 6,1 SAY 'CTRL+F = ���Ҩҡ�Ţ�������¹͡'
@ 7,1 SAY 'CTRL+P = �������ª��ͤ���������ѵ�'
wait '' window TIMEOUT 30
release window instr

PROC DELEALL
_nowrec=RECNO()
REPL ALL status WITH '���'
FLUSH
GO _nowrec

PROC UNDELEALL
_nowrec=RECNO()
REPL ALL status WITH '������'
FLUSH
GO _nowrec

PROC DELEREST
_nowrec=RECNO()
REPL status WITH '���' REST
FLUSH
GO _nowrec

PROC UNDELEREST
_nowrec=RECNO()
REPL status WITH '������' REST
FLUSH
GO _nowrec

PROC PRINTDELE
_nowrec = RECNO()
SET CONS OFF
_pageno=1
_plineno=0
_PLOFFSET = 0
_plength=41
ON PAGE AT line _plength-2 DO foreject
SET ORDER TO 1
PRINTJOB
IF ! CANCELPRINT()
	SET PRINT ON
*	SET CONS OFF
	SCAN FOR status = '���'
		? hn,'  ',name
	ENDS
	?
	EJECT
	EJECT PAGE
	SET PRINT OFF
*	SET CONS ON
	SET ORDER TO 0
	GO _nowrec
ENDI
ENDPRINT
SET PRIN OFF
SET CONS ON
ON PAGE

PROC FINDEXPIRE
DEFINE WIND find FROM 12,20 TO 16,60 SHAD
ACTI WIND find
ON KEY LABEL ENTER
@ 1,5 SAY '��ͧ���价�������Ţ HN ' GET fhn DEFA SPACE(7) PICT '#######'
READ NOLOCK
ON KEY LABEL ENTER REPL status WITH IIF(status='���','������','���')
IF LASTKEY() # 27
	fhn = PADZERO(fhn)
	SET ORDER TO 1
	IF ! SEEK(fhn)
		GO RECNO(0)
	ENDI
	SET ORDER TO 0
ENDI
RELE WIND find

PROC FOREJECT
EJECT PAGE
EJECT