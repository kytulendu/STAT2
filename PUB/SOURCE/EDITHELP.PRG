********************************************************************************
*  ���������Ѻ�������������͡��Ҩ���������������                          *
*  ��������Ť���������������ú�ҧ �������к�                                *
********************************************************************************

PRIVATE Colspace,PreScr,Cando,fromdos
#define numutil 12
@ 3,0 CLEA TO 20,80
fromdos = .T.
IF EMPTY(UserRight)
	Userright = GetUser()
ELSE
	fromdos = .F.
ENDI
IF ! UserRight == 'SUP       '
	=Alarm1()
	WAIT WIND NOWA '�س������Է��㹡�÷���¡�ù��'
	UserRight = IIF(fromdos,'  ',UserRight)
	RETU
ENDI
UserRight = IIF(fromdos,'  ',UserRight)
DIME chelp(numutil),EHelpMess(numutil)
chelp(1)='1. ��������չԤ'
chelp(2)='2. �������ͼ�����'
chelp(3)='3. ��䢪���ᾷ��'
chelp(4)='4. ����ºѵ�'
chelp[5]='5. ���͡���Ҿ'
chelp[6]='6. ���͡Ẻ OPD Card'
chelp[7]='7. ��������ä'
chelp[8]='8. ���ʨѧ��Ѵ ����� �Ӻ�'
chelp[9]='9. ��������Ѫ��'
chelp[10]='A. ����ʶҹ��Һ��'
chelp[11]='B. ������ ʻ�.'
chelp(numutil)='0. ��Ѻ��¡�����'

EHelpMess(1)='��䢢����Ť�չԤ��ҧ �'
EHelpMess(2)='��䢢������ͼ����µ�ҧ �'
EHelpMess(3)='��䢢�������ª���ᾷ��'
EHelpMess[4]='����ºѵ�����ͤú��˹�'
EHelpMess[5]='���͡��Դ�ͧ���Ҿ'
EHelpMess[6]='���͡��Ҩо����ѵü����¹͡���Ẻ�ͧ�ç��Һ���˹'
EHelpMess[7]='������������䢪�������ä��С�ü�ҵѴ'
EhelpMess[8]='����������������ʨѧ��Ѵ ����� �Ӻ�'
EhelpMess[9]='����������Ѫ�շ����������׹�� �ô���ѧ!'
EhelpMess[10]='��䢪�����������������ʶҹ��Һ��'
EhelpMess[11]='�֧�����Ũҡ������ѵ� ʻ�. (HIP)'
EHelpMess[numutil]='��Ѻ������¡����ѡ'

DEFINE WIND help_menu FROM 4,5 TO 4+ALEN(chelp)+3,40 SHAD COLO gr+/BG TITLE '  ��䢤�ҵ�ҧ �  '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	CLOSE DATA
	= ENGMODE()
	DO Title WITH '��¡����䢤�ҵ�ҧ �'
	ACTI WIND help_menu
	FOR i=1 TO ALEN(chelp)
		@ i,3 PROMPT chelp(i) MESS EhelpMess[i]
	NEXT
	dbfuse = codedir+'clinic'
	USE (codedir+'clinic') IN 0
	dbfuse = codedir+'ward'
	USE (codedir+'ward') IN 0
	dbfuse = codedir+'doctor'
	USE (codedir+'doctor') IN 0
	dbfuse = ''
	errorhelp = .F.
	IF RECCOUNT('WARD')<14 .OR. RECCOUNT('CLINIC')<16 .OR. ;
	RECCOUNT('DOCTOR') = 0
		Ch_help = IIF( RECCOUNT('DOCTOR') = 0, 3, Ch_help)
		Ch_help = IIF( RECCOUNT('WARD')<14, 2, Ch_help)
		Ch_help = IIF( RECCOUNT('CLINIC')<16, 1, Ch_help)
		errorhelp = .T.
	ENDI
	CLOSE DATA
	toedithelp = errorhelp
	fix_ch = Ch_help
	MENU TO Ch_help
	ACTI SCREE
	IF errorhelp .AND. ch_help # fix_ch
		?? CHR(7)
		DO CASE
			CASE fix_ch = 1
				fixsay = '��ͧ�������� ��չԤ '
			CASE fix_ch = 2
				fixsay = '��ͧ�������� �ͼ����� '
			CASE fix_ch = 3
				fixsay = '��ͧ�������� ᾷ�� '
			CASE fix_ch = 6
				fixsay = '��ͧ���͡Ẻ OPD Card ������'
		ENDC
		WAIT WIND NOWA fixsay +'��͹'
	ELSE
		DO CASE
			CASE Ch_help = 1
				DO HelpEdit WITH 'clinic'
			CASE Ch_help = 2
				DO HelpEdit WITH 'ward'
			CASE Ch_help = 3
				DO HelpEdit WITH 'doctor'
			CASE Ch_help = 4
				DO Expirec
			CASE Ch_help = 5
				DO SeleMoni
			CASE Ch_help = 6
				DO SeleCard
			CASE Ch_help = 7
				DO ShortICD
			CASE Ch_Help = 8
				DO editaddr
			CASE Ch_help = 9
				DO Reindex
			CASE Ch_help = 10
				?? CHR(7)
				WAIT WIND NOWA '�ѧ���͹حҵ������¡�ù�� �͡�õ�ŧ�ա˹���  '
*				DO Add_Srv
			CASE Ch_help = 11
				DO HipIMPO
			OTHER
				EXIT
		ENDC
	ENDI
ENDD
RELE WIND help_menu
CLOSE DATA

PROC SELECARD
SELE 0
IF ! FILE('prinform.dbf')
	dbfuse = patientdir+'prinform'
	USE (patientdir+'prinform')
ELSE
	dbfuse = 'prinform'
	USE prinform
ENDI
dbfuse = ''
DEFINE POPUP prinform FROM 10,20 TO 15,60 MARGIN SHADOW COLOR ;
SCHEME 4 PROMPT FIELD type MARK CHR(4)
ON SELE POPUP prinform DO makeprintopd
ACTI POPUP prinform

PROC MAKEPRINTOPD
COPY MEMO source TO printopd.prg
COPY MEMO compiled TO printopd.fxp
DEAC POPUP prinform
USE
CLEA PROG

PROC SHORTICD
IF ! USED('shorticd')
	IF ! FILE(patientdir+'shorticd.dbf')
		=TONE(1200,5)
		=TONE(700,5)
		WAIT WIND NOWA '�ѧ����ա���������ä���/��ҵѴ'
		RETU
	ELSE
		dbfuse = patientdir+'shorticd'
		USE (patientdir+'shorticd') ORDER 1 IN 0
	ENDI
	dbfuse = ''
ENDI
DEFINE WIND shorticd FROM 13,30 TO 20,70 SHAD 
ACTI WIND shorticd
numshort = 3
DIME shortmenu[numshort],shortmess[numshort]
shortmenu[1] = '1. �������'
shortmenu[2] = '2. ��䢪����������'
shortmenu[numshort] = '0. ��Ѻ��¡�á�͹˹�ҹ��'
shortmess[1] = '������ʢͧ�����ä���/���ͼ�ҵѴ���'
shortmess[2] = '���������Ъ����ä��ͷ������������'
shortmess[numshort] = ''
FOR i = 1 TO numshort 
	@ i,2 PROMPT shortmenu[i] MESS shortmess[i]
NEXT
MENU TO shortchoice
RELE WIND shorticd
DO CASE
	CASE shortchoice = 1
		DO InputShort
	CASE shortchoice = 2
		SELE shorticd
		ON KEY LABEL CTRL+N APPE BLAN
		ON KEY LABEL CTRL+F DO findabnormal
		DEFINE WIND browicd FROM 3,2 TO 20,77 SHAD PANEL ;
		TITLE '  ������������/�������  ' FOOT '�� [Esc] ���������'
		ACTI SCREE
		@ 23,0 SAY ;
' CTRL+N = ��������    CTRL+F = ���Ҥ�չԤ��������ʹ��  CTRL+W = ���稧ҹ'
		BROW FIELD code :h='���� ICD',desc :h='�����ä/��ü�ҵѴ' WIND browicd 
		RELE WIND browicd
		ACTI SCREE
		@ 23,0
ENDC
ON KEY LABEL CTRL+N
ON KEY LABEL CTRL+F

PROC FINDABNORMAL
DEFINE WIND findab FROM 21,2 TO 24,77 SHAD
openfile = opddir+'came'+date
ACTI WIND findab
IF FILE(openfile+'.dbf')
	SELE 0
	dbfuse = openfile
	USE (openfile) ALIA open1
	WAIT WIND NOWA '�ô��� ! ���ѧ�������� '+shorticd.code+' ���� '+openfile
	LOCA FOR diag = shorticd.code
	dbfuse = ''
	=ALARM1()
	IF ! EOF()
		IF ! USED('clinic')
			dbfuse = codedir+'clinic'
			USE (codedir+'clinic') ORDER 1 IN 0
			useaddr = .F.
		ELSE
			useaddr = .T.
		ENDI
		SELE clinic
		dbfuse = ''
		SEEK open1.clinic
		@ 0,3 SAY '������ '+shorticd.code+' 㹤�չԤ'+name
		= INKEY(0)
		IF ! useaddr
			SELE clinic
			USE
		ENDI
		SELE open1
		USE
	ELSE
		DO Deleteab
		SELE open1
		USE
	ENDI
ELSE
	DO Deleteab
ENDI
RELE WIND findab


PROC DELETEAB
@ 0,2 SAY '��辺����ա��������� '+shorticd.code
@ 1,2 SAY '��ͧ���ź���ʹ���������  ' GET confirmdel DEFA 'Y' PICT '!'
READ NOLOCK
IF confirmdel $ 'Y��'
	SELE shorticd
	SCAT MEMV BLAN
	GATHER MEMV
	FLUSH
ENDI

PROC INPUTSHORT
SELE shorticd
SET ORDER TO TAG code
GO TOP
goon = SEEK('#')
IF goon
	DEFINE WIND browicd FROM 3,2 TO 20,77 SHAD PANEL ;
	TITLE '  ������� ICD ���Ѻ�������  ' FOOT '�� [Esc] ���������'
	ACTI WIND browicd
	DIME newcode[100], oldcode[100], foropd[100], foripd[100], ;
	finddate[12], findtype[12]
	numchange = 0
	datestart = '9999'
	numfind = 0
	IF SEEK('#')
		DO WHIL goon .AND. LEFT(code,1) = '#' .AND. numchange <100
			m.correct = 'Y'
			SKIP
			nextrec = IIF(EOF(), 1, RECNO())
			SKIP -1
			CLEA
			SCAT MEMV
			@ 2,5 SAY '�����ä��� ' +m.desc
			@ 3,5 SAY '���� ICD ' GET m.code PICT '@!'
			@ 5,10 SAY '�׹�ѹ��Ҷ١��ͧ ' GET m.correct PICT '!'
			READ NOLOCK
			IF LASTKEY() = 27
				goon = .F.
			ELSE
				IF m.correct $ 'Y��'
					numchange = numchange + 1
					oldcode[numchange] = code
					newcode[numchange] = m.code
					m.pos = ASCAN(finddate,m.date)
					IF m.pos = 0 
						numfind = numfind+1
						finddate[numfind] = m.date
						findtype[numfind] = m.type
					ELSE
						findtype[m.pos] = IIF( findtype[m.pos]='2', '2', ;
						IIF( findtype[m.pos]=m.type, m.type, '2') )
					ENDI
**					datestart = MIN(datestart,m.date)
**					foropd = type > '1'
**					foripd = type < '3'
					GATH MEMV
					FLUSH
				ENDI
			ENDI
			GO nextrec
		ENDD
	ENDI
	SELE shorticd
	USE
	IF numfind > 0
		CLEA
		msg = '�ô��� ! ���ѧ����¹�������١��ͧ'
		@ 5,Center(msg) SAY msg
		FOR i = 1 TO numfind
			datestart = finddate[i]
			IF findtype[i] < '3'
				usefile = opddir+'came'+datestart
				USE	(usefile)
				msg = '���ѧ������ '+usefile
				@ 7,0
				@ 7,Center(msg) SAY msg
				SCAN
					IF LEFT(diag,1) = '#'
						mpos = ASCAN(oldcode,diag)
						IF mpos > 0
							REPL diag WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
				ENDS
			ENDI
			IF findtype[i] > '1'
				usefile = ipddir+'data\diag'+datestart
				USE	(usefile)
				msg = '���ѧ������ '+usefile
				@ 7,0
				@ 7,Center(msg) SAY msg
				SCAN
					IF LEFT(diag,1) = '#'
						mpos = ASCAN(oldcode,diag)
						IF mpos > 0
							REPL diag WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
				ENDS
				usefile = ipddir+'data\oper'+datestart
				USE	(usefile)
				msg = '���ѧ������ '+usefile
				@ 7,0
				@ 7,Center(msg) SAY msg
				SCAN
					IF LEFT(op,1) = '#'
						mpos = ASCAN(oldcode,op)
						IF mpos > 0
							REPL op WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
				ENDS
				usefile = ipddir+'data\death'+LEFT(datestart,2)
				USE	(usefile)
				msg = '���ѧ������ '+usefile
				@ 7,0
				@ 7,Center(msg) SAY msg
				SCAN
					IF LEFT(icd10,1) = '#'
						mpos = ASCAN(oldcode,icd10)
						IF mpos > 0
							REPL icd10 WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
					IF LEFT(cause1,1) = '#'
						mpos = ASCAN(oldcode,cause1)
						IF mpos > 0
							REPL cause1 WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
					IF LEFT(cause2,1) = '#'
						mpos = ASCAN(oldcode,cause2)
						IF mpos > 0
							REPL cause2 WITH newcode(mpos)
							FLUSH
						ENDI
					ENDI
				ENDS
			ENDI
**		
**		datestart = IIF( RIGHT(datestart,2)='12', ;
**		STRZERO(VAL(LEFT(datestart,2))+1,2)+'01', ;
**		LEFT(datestart,2)+STRZERO(VAL(RIGHT(datestart,2))+1,2) )
	NEXT
	USE
	ENDI
	RELE WIND browicd
ENDI
