PARA errnum,errmess,_line,_prog,_prog1,_prog2,_prog3,_prog4,_prog5,_prog6,_prog7,_prog8
SET PRIN OFF
SET DEVI TO SCREE
SET TALK OFF
IF TYPE('dbfuse') = 'U'
	dbfuse = ''
ENDI
DO CASE
CASE BETWEEN(errnum,108,109) .OR. errnum = 1705
	IF EMPTY(dbfuse)
		WAIT WINDOW '  ���ѧ�������Դ������� �ô����ѡ����  ' timeout 1
	ELSE
		WAIT WINDOW '  ���ѧ�������Դ��� ' + UPPE(dbfuse) +' ���� �ô����ѡ����  ' timeout 1
	ENDI
	IF INKEY(1)<>27
		RETRY
	ELSE
		@ 23,10 SAY '  �Դ����������� ��ԡ�ӧҹ  ' COLO r+/b
		close data
		DEAC WIND ALL
		RETU TO MASTER
	ENDI
CASE errnum = 1707 AND _prog $ 'REINDEX,DELECDX'
	KEYB 'I'
	RETRY
CASE errnum = 15 .AND. ! EMPTY(dbfuse)
	udfp = SET('UDFPARMS')
	SET UDFPARM TO VALUE
	canfix = .F.
	dbname = IIF(UPPE(RIGHT(dbfuse,4)) = '.DBF', dbfuse, dbfuse + '.dbf')
	mfix=FIXDBF(dbname,0)	
	IF mfix<>0
		IF mfix > 0
			=FIXDBF(dbname,1)
			canfix = .T.
		ENDIF
	ELSE
		canfix = .T.
	ENDIF
	SET UDFPARM TO &udfp
	IF canfix
		RETRY
	ELSE
		errmess = '������������� ������� FILEFIX ����'
		DO showerror
	ENDI
OTHER
	DO showerror
ENDC

PROC SHOWERROR
	?? CHR(7)
	errmess = IIF(errnum = 15, '������������� ������� FILEFIX ����', errmess)
	errmess = IIF(errnum = 125, '����ͧ������ѧ������� �ô���', errmess)
	DEFINE WIND errwin FROM 3,5 TO 19,74 SHAD FLOA
	ACTI WIND errwin
	@ 1,2 SAY '�����Ţ���Դ���� : ' + LTRIM(STR(errnum))
	@ 2,2 SAY '�����Դ���Է���Դ : ' + errmess
	IF errnum = 125
		@ ROW()+4,15 SAY '������ [ENTER] ���;������'
		@ ROW()+1,15 SAY '������ [ESC] ����¡��ԡ���þ����'
	ELSE
		IF ! EMPTY(dbfuse) 
			@ ROW()+1,2 SAY '��������Դ : ' + UPPE(dbfuse)
		ENDI
		@ ROW()+1,2 SAY '��÷Ѵ���     : ' + LTRIM(STR(_line))
		@ ROW()+1,2 SAY '�ͧ�����    : ' + _prog
		FOR _y = 1 TO 8
			_l = STR(_y,1)
			IF _prog&_l == _prog .OR. _prog&_l = 'ON...'
				EXIT
			ENDI
		NEXT
		FOR _i = _y-1 TO 1 STEP -1
			_x = STR(_i,1)
			@ ROW()+1,2 SAY '������     : ' + _prog&_x
		NEXT
		@ WROW() - 1,Center('������ [Esc] ���ͷӧҹ���') SAY '������ [Esc] ���ͷӧҹ���'
	ENDI
	mkey = INKEY(0) 
	DEAC WIND errwin
	ACTI SCREE
	IF mkey = 27
		CLOSE DATA
		DEAC WIND ALL
		ON PAGE
		RETU TO MASTER
	ELSE
		RETRY
	ENDI
