PARA _type
DEFINE WIND sendrepo From 9,20 TO 15,70 SHAD TITLE '����§ҹ���´�ʤ�'
ACTI WIND sendrepo
STOR SPACE(4) TO mmyy
@ 1,2 SAY '����§ҹ ç'+_type+' ��͹/�� ' GET mmyy ;
PICT '@R ##/##' VALID Checkdate(mmyy)
READ
annual=.F.
mm = LEFT(mmyy,2)
yy = RIGHT(mmyy,2)
IF mm='  ' .OR. LASTKEY() = 27
	?? CHR(7)
	WAIT '¡��ԡ��÷ӧҹ�������ҹ��ͧ���' WIND NOWA
	RETU
ENDI
IF ! FILE('report\r&_type&yy&mm..dbf')
	=TONE(450,5)
	CLEA
	@ 1,1 SAY '�ѧ����������§ҹç.'+_type+'�ͧ'+;
	IIF(mm = LEFT(FULLYEAR(yy),2),'�է�����ҳ','��͹'+month&mm)+' '+FullYear(yy)
	@ 3,1 SAY '��س����͡��¡�÷���§ҹ��͹'
	=INKEY(10)
ELSE
	CLEA
	@ 1,1 SAY '�����§ҹ���㹪�ͧ�Ѻ'
	@ 1,25 PROMPT 'A:' MESS '�����§ҹ������� A'
	@ 3,25 PROMPT 'B:' MESS '�����§ҹ������� B'
	MENU TO mdrive
	IF mdrive=0
		RETU
	ELSE
		drive=IIF(mdrive=1,'a','b')
		SELE 0
		USE report\r&_type&yy&mm
		COPY TO &drive.:r&_type&yy&mm
		USE
	ENDI
ENDI
RELE WIND sendrepo