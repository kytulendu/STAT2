*........PROCEDURE UTILITY
PARA _util
DO CASE 
   CASE _util='1'
     DO ADD_SRV
   CASE _util='2'
     DO EDIT_DPT
   CASE _util='3'
     DO BACKUP
   CASE _util='4'
     DO RESTORE
   CASE _util='5'
     DO DEL_FILE
   CASE _util='6'
     DO LOGO
     CLEA
ENDCASE
RETURN

PROC ADD_SRV
USE hospcode ORDER 1
DO WHILE .T.
	CLEAR
	m.hosp=SPACE(12)
	@ 7,1 SAY "����ʶҹ��ԡ�� "  GET m.hosp
	READ
	IF ! EMPTY(m.hosp) .AND. LASTKEY() # 27
		IF ! SEEK(m.hosp)
			m.name=SPACE(60) 
		ELSE
			m.name=name
			=TONE(478,8)
		ENDI
		@ 8,1 SAY "����ʶҹ��ԡ�� " GET m.name
		READ
		IF ! EMPTY(m.name) .AND. LASTKEY() # 27
			@ 9,1 SAY '�дѺʶҹ��Һ�� ' GET m.level PICT '9' ;
			DEFA ' ' VALID BETWEEN(m.leveL,'1','4') MESS ;
			'1 = �ʨ,þ�,þ�   2 = þ�,þ�  3 = ���,��   4 = �͡ ʸ.' ;
			ERROR '������Ţ����� 1 �֧ 4'
			READ
			CORR="Y"
			@12,15 SAY "����� Y ��Ҷ١��ͧ " GET CORR PICT '!' MESS ' '
			READ
			IF CORR="Y"
				IF EOF()
					APPE BLANK
					REPL CODE WITH m.hosp
				ENDI
			ENDI	
            REPL name WITH m.name,level WITH SUBS(m.hosp,5,2)+m.level+SUBS(m.hosp,7,2)
		ENDI
	ELSE
		EXIT
	ENDI
ENDDO
CLEA
USE
RETURN

PROC EDIT_DPT
CLEAR
DO opdlan
CLEA
RETURN

PROC BACKUP
DEFINE WIND backup FROM 10,25 TO 17,60 SHAD TITLE '  ���ͧ������  '
ACTI WIND backup
DIME back[4]
back[1]='������ ç.504'
back[2]='��§ҹ ç.504'
back[3]='������ ç.505'
back[4]='��§ҹ ç.505'
@ 1,2 SAY '���ͧ'
FOR i = 1 TO 4
	@ i,9 PROMPT back[i]
NEXT
MENU TO rep
IF rep > 0
   _rep=IIF(rep<3,'504','505')
   _tfile=IIF(rep=1 .OR. rep=3,'data\d','report\r')
	CLEA
	@ 1,Center(back[rep]) SAY back[rep] COLO r+
	@ 2,2 SAY '���ͧ��������͹/�� ' GET mmyy DEFA SPAC(4) PICT '@R ##/##' ;
	VALID Checkdate(mmyy)
	READ
	mm = LEFT(mmyy,2)
	yy = RIGHT(mmyy,2)
	IF ! FILE('&_tfile&_rep&yy&mm..dbf')
		=TONE(590,6)
		@ 4,2 SAY '����������������͹���'
		=INKEY(15)
	ELSE
		@ 3,2 SAY '���ͧ���������㹪�ͧ�Ѻ '
		@ 3,28 PROMPT 'A:' MESS '���ͧ������������� A'
		@ 4,28 PROMPT 'B:' MESS '���ͧ������������� B'
		MENU TO mdrive
		IF mdrive > 0
			drive=IIF(mdrive=1,'a','b')
			filecopy = _tfile+_rep+yy+mm
			SELE 0
			USE (filecopy)
			copyfile = drive+':'+RIGHT(_tfile,1)+_rep+yy+mm
			COPY TO (copyfile)
			USE
		ENDI
	ENDI
ENDI
RELE WIND backup

PROC RESTORE
DEFIN WIND restore FROM 10,25 TO 17,60 SHAD TITLE '  �֧�����Ť׹  '
ACTI WIND restore
DIME back[4]
back[1]='������ ç.504'
back[2]='��§ҹ ç.504'
back[3]='������ ç.505'
back[4]='��§ҹ ç.505'
@ 1,2 SAY '���¡�׹'
FOR i = 1 TO 4
	@ i,12 PROMPT back[i]
NEXT
MENU TO rep
IF rep > 0
	_rep=IIF(rep<3,'504','505')
	_tfile=IIF(rep=1 .OR. rep=3,'data\d','report\r')
	CLEA
	@ 1,Center(back[rep]) SAY back[rep] COLO r+
	@ 2,2 SAY '���¡�׹��������͹/�� ' GET mmyy DEFA SPAC(4) PICT '@R ##/##' ;
	VALID Checkdate(mmyy)
	READ
	mm = LEFT(mmyy,2)
	yy = RIGHT(mmyy,2)
	overwrite='Y'
	@ 3,2 SAY '���¡�׹�����Ũҡ��ͧ�Ѻ '
	@ 3,28 PROMPT 'A:' MESS '���¡�����Ũҡ��� A'
	@ 4,28 PROMPT 'B:' MESS '���¡�����Ũҡ��� B'
	MENU TO mdrive
	IF mdrive > 0
		drive=IIF(mdrive=1,'a:','b:')
		sourcefile = drive+RIGHT(_tfile,1)+_rep+yy+mm
		IF ! FILE(sourcefile+'.dbf')
			=TONE(590,6)
			@ 4,2 SAY '����բ��������ͧ��͹�������'
			=INKEY(15)
		ELSE
			IF FILE('&_tfile&_rep&yy&mm..dbf')
				CLEA
				@ 2,2 SAY back[rep]+month&mm+' '+FULLYEAR(yy)+' ����������'
				=TONE(560,7)
				@ 3,2 SAY '��ͧ�����¹�Ѻ������� ' GET overwrite PICT '!'
				READ
			ENDI
			IF overwrite = 'Y'
				USE (sourcefile)
				targetfile = _tfile+_rep+yy+mm
				COPY TO (targetfile)
				USE
			ENDI
		ENDI
	ENDI
ENDI
RELE WIND restore

PROC DEL_FILE
DEFIN WIND restore FROM 10,25 TO 17,60 SHAD TITLE '  ź���������  '
ACTI WIND restore
DIME back[4]
back[1]='������ ç.504'
back[2]='��§ҹ ç.504'
back[3]='������ ç.505'
back[4]='��§ҹ ç.505'
CLEA
@ 1,2 SAY 'ź���'
FOR i = 1 TO 4
	@ i,12 PROMPT back[i]
NEXT
MENU TO rep
IF rep > 0
	_rep=IIF(rep<3,'504','505')
	_tfile=IIF(rep=1 .OR. rep=3,'data\d','report\r')
	CLEA
	@ 1,Center(back[rep]) SAY back[rep] COLO r+
	@ 2,2 SAY 'ź�����������͹/�� ' GET mmyy DEFA SPAC(4) PICT '@R ##/##' ;
	VALID Checkdate(mmyy)
	READ
	mm = LEFT(mmyy,2)
	yy = RIGHT(mmyy,2)
	IF ! FILE('&_tfile&_rep&yy&mm..dbf')
		=TONE(478,6)
		@ 3,2 SAY '����������������͹���'
		=INKEY(10)
	ELSE
		sure='N'
		@ 4,2 SAY '��ͧ���ź������  ' GET sure PICT '!'
		READ
		IF sure='Y'
			DELE FILE &_tfile&_rep&yy&mm..dbf
		ENDI
   ENDI
ENDI
RELE WIND restore

