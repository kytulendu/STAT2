dbfuse = codedir+'hospcode'
USE (codedir+'hospcode') ORDER 1
dbfuse = ''
DEFINE WIND add_srv FROM 6,1 TO 16,78 SHAD
ACTI WIND add_srv
DO WHILE .T.
	CLEAR
	m.hosp=SPACE(5)
	= ENGMODE()
	@ 1,1 SAY "����ʶҹ��ԡ�� "  GET m.hosp
	READ NOLOCK
	IF ! EMPTY(m.hosp) .AND. LASTKEY() # 27
		IF ! SEEK(m.hosp)
			m.name=SPACE(60)
		ELSE
			m.name=name
			=TONE(478,8)
		ENDI
		= THAIMODE()
		@ 3,1 SAY "����ʶҹ��ԡ�� " GET m.name
		READ NOLOCK
		= ENGMODE()
		IF ! EMPTY(m.name) .AND. LASTKEY() # 27
			@ 5,1 SAY '�дѺʶҹ��Һ�� ' GET m.level PICT '9' ;
			DEFA ' ' VALID BETWEEN(m.leveL,'1','4') MESS ;
			'1 = �ʨ,þ�,þ�   2 = þ�,þ�  3 = ���,��   4 = �͡ ʸ.' ;
			ERROR '������Ţ����� 1 �֧ 4'
			READ NOLOCK
			CORR="Y"
			@ 7,15 SAY "����� Y ��Ҷ١��ͧ " GET CORR PICT '!' MESS ' '
			READ NOLOCK
			IF CORR="Y"
				IF EOF()
					APPE BLANK
					REPL CODE WITH m.hosp
					FLUSH
				ENDI
			ENDI
            REPL name WITH m.name,level WITH SUBS(m.hosp,5,2)+m.level+SUBS(m.hosp,7,2)
            FLUSH
		ENDI
	ELSE
		EXIT
	ENDI
ENDDO
RELE WIND add_srv
USE
RETURN