PARA _startprog
currentdirectory = SYS(5) + SYS(2003)
notremovethai = .F.
havepara = .F.
STORE .F. TO healthin    && Not a program of HEALTH INSURANCE
IF PARAMETERS() > 0
	notremovethai = UPPE(_startprog) = 'T'
	havepara = .T.
ENDI
statversion = '2.95 TM'
*RELE ALL
SET PROC TO Utility
SET LIBR TO foxfix ADDI
_toprog = IIF(PARAMETER()=0,'  ',_startprog)
DO StartSet
ba = CHR(201) + CHR(205) + CHR(187) + CHR(186) + CHR(188) + CHR(205) + CHR(200) + CHR(186)
bb = CHR(204) + CHR(205) + CHR(185) + CHR(186) + CHR(188) + CHR(205) + CHR(200) + CHR(186)
PRIV goon
SET RESOURCE OFF
#DEFINE UpArrow 5
#DEFINE LeftArrow 19
PUBLIC Atrscreen,Atrbackgr,Atrdata,Atrmenu,Atrmenu2
STORE '\pub\' TO patientdir,codedir
STORE '' TO tempdir,workstation,backup,admit,thaicard,person_id,;
prescription,notprintrx,wellbaby,notque,backupdrive,dbfuse,;
notstatadmit, isdir
STORE '\ipd\' TO ipddir
STORE '\opd\' TO opddir
STORE '\pharm\' TO pharmdir
STORE '\billing\' TO billdir
STORE .F. TO printpx, nottoque
*youngright	=	'71,81'
*poorright	=	'72,82'
*studentright =	'73,83'
*disableright =  '74,84'
*warright	=	'75,85'
*monkright	=	'76,86'
*oldright	=	'77,87'
*tempright	=	'78,88'
*ucright 	=	'89'
*fwfright	=	''
*leaderright =	''
*hcvright	=	''
** udc ***
youngright	=	'62,63,64'
poorright	=	'51'
studentright =	'34,35,36,37,38'
disableright = 	'66'
warright	=	'41,42,43,44,45'
monkright	=	'65'
oldright	=	'61'
tempright	=	''
ssoright	=	'71,72,73'
ucright 	=	'30,3C'
fwfright	=	'99'
leaderright =	'32'
hcvright	=	'33'
*** udc ***

*ON error DO err WITH ERROR(),MESSAGE(),LINENO(),PROGRAM(),PROGRAM(2),PROGRAM(3),;
*PROGRAM(4),PROGRAM(5),PROGRAM(6),PROGRAM(7),PROGRAM(8),PROGRAM(9)
DIME ProvArr(60)
goon = .T.
DIME test(4)
=ADIR(test,SYS(16))
programdate=CE2CBE(test[3])
fromhelp = .F.
backup = UPPE(GETENV('BACKUP'))
workstation = UPPE(GETENV('workstation'))
er = workstation = 'ER'
statinput = workstation = 'STAT'
notkeyword = 'NO'
DO GetConfig
audit = backup = 'AUDIT'
printpx = prescription = 'YES'
nottoque = UPPE(notque) = 'YES'
F_STATION=workstation='FILE'
*ER=workstation='ER'
drive = LEFT(patientdir,AT('\',patientdir))
IF ADIR(directory,drive+'credit','D') = 0
	makedir = drive+billdir
	! md &makedir
	makedir = drive+billdir +'data'
	! md &makedir
	makedir = drive+billdir + 'report'
	! md &makedir
ENDI
IF ADIR(directory,patientdir,'D') = 0
	makedir = LEFT(patientdir,LEN(patientdir)-1)
	! md &makedir
	makedir = LEFT(opddir,LEN(opddir)-1)
	! md &makedir
	makedir = makedir + '\report'
	! md &makedir
	makedir = LEFT(ipddir,LEN(ipddir)-1)
	! md &makedir
	makedir = makedir + '\report'
	! md &makedir
	makedir = makedir + '\data'
	! md &makedir
	makedir = makedir + '\lib'
	! md &makedir
ENDI

**billing
IF ADIR(directory,billdir,'D') = 0
	makedir = LEFT(billdir,LEN(billdir)-1)
	! md &makedir
ENDI
IF ADIR(directory,billdir+'All','D') = 0
	makedir = billdir +'ALL'
	! md &makedir
ENDI
IF ADIR(directory,billdir+'OPD','D') = 0
	makedir = billdir + 'OPD'
	! md &makedir
ENDI
IF ! FILE(billdir+'opd\chrgitem.dbf')
	SELE 0
	dbfuse = billdir+'opd\chrgitem'
	CREA TABLE (billdir+'opd\chrgitem') ;
	(CHRGITEM C(2),CHR_NAME C(25))
	APPE BLANK
	REPL CHRGITEM WITH '00',CHR_name WITH '�����'
	APPE BLANK
	REPL CHRGITEM WITH '01',CHR_name WITH '��Һ�ԡ�÷ҧ���ᾷ��'
	APPE BLANK
	REPL CHRGITEM WITH '02',CHR_name WITH '��Һ�ԡ�÷ҧ�ѹ�����'
	APPE BLANK
	REPL CHRGITEM WITH '03',CHR_name WITH '��ҵ�Ǩ�ҧ��ͧ��Ժѵԡ��'
	APPE BLANK
	REPL CHRGITEM WITH '04',CHR_name WITH '��� X-Ray'
	APPE BLANK
	REPL CHRGITEM WITH '05',CHR_name WITH '�����ʴء��ᾷ��'
	APPE BLANK
	REPL CHRGITEM WITH '06',CHR_name WITH '�����ͧ'
	APPE BLANK
	REPL CHRGITEM WITH '07',CHR_name WITH '��Һ��ا'
	APPE BLANK
	REPL CHRGITEM WITH '08',CHR_name WITH '��Ѻ�ͧᾷ��'
	APPE BLANK
	REPL CHRGITEM WITH '09',CHR_name WITH '��ԨҤ'
	APPE BLANK
	REPL CHRGITEM WITH '10',CHR_name WITH '��� �'
	dbfuse = ''
	USE
ENDI
IF ! FILE(billdir+'all\chrgitem.dbf')
	SELE 0
	dbfuse = billdir+'all\chrgitem'
	CREA TABLE (billdir+'all\chrgitem') ;
	(CHRGITEM C(2),CHR_NAME C(25))
	APPE BLANK
	REPL CHRGITEM WITH '00',CHR_name WITH '�ѹ�ٵ���ͧ��Ժѵԡ��'
	APPE BLANK
	REPL CHRGITEM WITH '01',CHR_name WITH 'X-Ray'
	APPE BLANK
	REPL CHRGITEM WITH '02',CHR_name WITH '��Ǩ�ѹ�ٵ���� �'
	APPE BLANK
	REPL CHRGITEM WITH '03',CHR_name WITH '��ҵѴ'
	APPE BLANK
	REPL CHRGITEM WITH '04',CHR_name WITH '����ѡ����� �'
	APPE BLANK
	REPL CHRGITEM WITH '05',CHR_name WITH '������Ǫ�ѳ��'
	APPE BLANK
	REPL CHRGITEM WITH '06',CHR_name WITH 'ICU'
	APPE BLANK
	REPL CHRGITEM WITH '07',CHR_name WITH '�����ͧ'
	APPE BLANK
	REPL CHRGITEM WITH '08',CHR_name WITH '��������'
	APPE BLANK
	REPL CHRGITEM WITH '09',CHR_name WITH '��� �'
	dbfuse = ''
USE
ENDI
IF USED('RCOPD')
	SELE RCOPD
	use
ENDI
	sele 0
	target=billdir+'opd\rcopd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (RC_NO C(10), HN C(9), DATE D, TOTAL N(7);
		,PAID N(7) )
			index on hn tag hn
			index on RC_NO tag RC_NO addi
	endif
	use (target) alias RCOPD
	dbfuse = ''
	set order to tag rc_no
IF USED('DTOPD')
	SELE DTOPD
	use
ENDI
	sele 0
	target=billdir+'opd\dtopd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (RC_NO C(10), SV_ID C(2), AMT N(7),FREE N(7), HN C(9) )
			index on HN tag HN
			index on rc_no tag rc_no addi
	endif
	use (target) alias DTOPD
	dbfuse = ''
	set order to tag rc_no
IF USED('CREDOPD')
	SELE CREDOPD
	use
ENDI
	sele 0
	target=billdir+'opd\credopd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (CR_ID C(2), RC_NO C(10), HN C(9) )
			index on HN tag HN
			index on rc_no tag rc_no addi
	endif
	use (target) alias CREDOPD
	dbfuse = ''
	set order to tag rc_no
IF USED('RCPD')
	SELE RCPD
	use
ENDI
	sele 0
	target=billdir+'all\rcpd'+'.dbf'
	dbfuse = target
	IF !FILE(target)
		create dbf (target) (RC_NO C(10), HN C(9), DATE D, TOTAL N(7);
		,PAID N(7) , AN C(9) )
			index on AN tag AN
			INDEX ON RC_NO TAG RC_NO ADDI
	ENDI
	use (target) alias RCPD
	dbfuse = ''
	set order to tag AN
IF USED('DTPD')
	SELE DTPD
	use
ENDI
	sele 0
	target=billdir+'all\dtpd'+'.dbf'
	dbfuse = target
	IF !file(target)
		create dbf (target) (RC_NO C(10), SV_ID C(2), AMT N(7), AN C(9) )
			index on AN tag AN
			INDEX ON RC_NO TAG RC_NO ADDI
	ENDI
	use (target) alias DTPD
	dbfuse = ''
	set order to tag AN
IF USED('CREDITPD')
	SELE CREDITPD
	use
ENDI
	sele 0
	target=billdir+'all\creditpd'+'.dbf'
	dbfuse = target
	if !file(target)
		create dbf (target) (CR_ID C(2), RC_NO C(10), AN C(9) )
			index on An tag An
			index on Rc_no tag Rc_no ADDI
	endif
	use (target) alias CREDITPD
	dbfuse = ''
	set order to tag Rc_no

***

IF ! FILE(patientdir+'user.dbf')
	SELE 0
	dbfuse = patientdir+'user'
	CREA TABLE (patientdir+'user') ;
	(NAME C(12),PSW C(10),RIGHT C(10))
	INDEX ON name TAG name
	dbfuse = ''
	USE
ENDI

IF ! FILE(patientdir + "opdlan.mem")
	DO makedbf WITH patientdir+'patient1'  && ��Ǩ�ͺ�������������繤ú������� ��ҢҴ������ҧ����
	PUSH KEY CLEA
	ON KEY LABEL F1 DO HELP WITH SYS(18),SYS(16)
	USE (codedir+'hospcode') ORDER 1 IN 0
	DO OpdLan  			&& �ͺ��������ž�鹰ҹ�ͧ�ç��Һ��
	POP KEY
	DO CLearScreen
*	DO OpenLanMaster
	SELE 0
	dbfuse = patientdir+'hncount'
	USE (patientdir+'hncount')
	m.lasthn = lasthn +1
	SELE 0
	dbfuse = ipddir+'ancount'
	USE (ipddir+'ancount')
	dbfuse = ''
	SCAT MEMV
	m.year = IIF( EMPTY(m.year), RIGHT(CE2BE(DATE()),2), m.year)
	m.lastan = m.lastan+1
	@ 10,20 SAY '��ͧ���������鹷�������Ţ HN ' GET m.lasthn PICT '9999999'
	@ 12,20 SAY '��ͧ���������鹷�������Ţ AN '
	_col = COL() + 1
	@ 12,_col GET m.lastan PICT '99999'
	@ 12,_col+5 SAY '-'
	@ 12,_col+6 GET m.year PICT '99'
	READ NOLOCK
	m.lasthn =IIF(m.lasthn>0, m.lasthn-1,m.lasthn)
	m.lastan = IIF(m.lastan>0, m.lastan-1, m.lastan)
	GATH MEMV
	FLUSH
	SELE hncount
	GATH MEMV
	FLUSH
	CLOSE DATA
ENDI
REST FROM (patientdir+'opdlan') ADDI
getperson_id = .T.
dbfuse = codedir + 'social'
USE (dbfuse) IN 0 ORDER 1
SELE social
IF ! SEEK('71')
	m.class = '71'
	m.name = '�����ص�ӡ��� 12 �� �ࢵ'
	INSERT INTO social FROM MEMV
	m.class = '81'
	m.name = '�����ص�ӡ��� 12 �� �͡ࢵ'
	INSERT INTO social FROM MEMV
	m.class = '72'
	m.name = '������������� �ࢵ       '
	INSERT INTO social FROM MEMV
	m.class = '82'
	m.name = '������������� �͡ࢵ      '
	INSERT INTO social FROM MEMV
	m.class = '73'
	m.name = '�ѡ���¹ �ࢵ              '
	INSERT INTO social FROM MEMV
	m.class = '83'
	m.name = '�ѡ���¹ �͡ࢵ             '
	INSERT INTO social FROM MEMV
	m.class = '74'
	m.name = '���ԡ�� �ࢵ              '
	INSERT INTO social FROM MEMV
	m.class = '84'
	m.name = '���ԡ�� �͡ࢵ             '
	INSERT INTO social FROM MEMV
	m.class = '75'
	m.name = '���ü�ҹ�֡ �ࢵ           '
	INSERT INTO social FROM MEMV
	m.class = '85'
	m.name = '���ü�ҹ�֡ �͡ࢵ          '
	INSERT INTO social FROM MEMV
	m.class = '76'
	m.name = '�ԡ��/������ʹ� �ࢵ      '
	INSERT INTO social FROM MEMV
	m.class = '86'
	m.name = '�ԡ��/������ʹ� �͡ࢵ     '
	INSERT INTO social FROM MEMV
	m.class = '77'
	m.name = '����٧���� �ࢵ            '
	INSERT INTO social FROM MEMV
	m.class = '87'
	m.name = '����٧���� �͡ࢵ           '
	INSERT INTO social FROM MEMV
	m.class = '78'
	m.name = '�ѵê��Ǥ��� �ࢵ          '
	INSERT INTO social FROM MEMV
	m.class = '88'
	m.name = '�ѵê��Ǥ��� �͡ࢵ         '
	INSERT INTO social FROM MEMV
	m.class = '89'
	m.name = '�ѵ��آ�Ҿ�ն�ǹ˹��(30�ҷ)  '
	INSERT INTO social FROM MEMV
ENDI
SET MESSAGE TO 24
SET TEXT ON
mhosp_name=LTRIM(TRIM(hosp_name))
dbfuse = patientdir + 'referin.dbf'
SELE 0
IF ! FILE(dbfuse)
	CREATE TABLE (dbfuse) ;
	(HN C(7), ref_no C(7), place C(5), referdate D, refertime C(4), ;
	toclinic C(3), cause C(2) )
	INDEX ON hn TAG hn
	INDEX ON DTOS(referdate) TAG referdate ADDI
ENDI
dbfuse = patientdir + 'referno.dbf'
IF ! FILE(dbfuse)
	CREATE TABLE (dbfuse) ;
	( lastrefer N(5), year C(2) )
	APPE BLANK
ENDI
USE
dbfuse = patientdir + 'patient1'
USE (dbfuse) IN 0
SELE patient1
IF FCOUNT() < 12
	= ALARM1()
	WAIT WIND '�ӹǹ Field ���� Patient1 ���١��ͧ' + CHR(13) + ;
	'�е�ͧ�շ����� 12 Field ��� Field ��� 12 �е�ͧ��' + CHR(13) + ;
	'Person_id �� Character 13 ��ѡ' + CHR(13) + ;
	'��ҵ�ͧ�������������سҡ����� [Y]' TO correct
	IF correct $ 'y�Y�'
		DO Patient1Correct
	ELSE
		WAIT WIND '��� Patient1 ���١��ͧ �������ö�ӧҹ����� ' TIME 100
		RETU
	ENDI
ENDI
USE

*** UDC
PRIVATE yy,mm
mdate=CE2BE(DATE())
yy=RIGHT(mdate,2)
mm=SUBS(mdate,4,2)
dbfuse = patientdir + 'doctor.dbf'
USE (dbfuse) IN 0
SELE doctor
IF FCOUNT() < 3
	= ALARM1()
	WAIT WIND '�ç���ҧ��������� Doctor ���١��ͧ' + CHR(13) + ;
	'��س�����ç���ҧ�����͹ �������� ���ا�ѡ���к�' + CHR(13) + ;
	'�ԩй���Ҩ�Դ�����Դ��Ҵ㹡�÷ӧҹ' + CHR(13) + ;
	'...������� � ���ͷӧҹ���...' TIME 100
ENDI
USE
*** UDC
*i=0
*dbfuse = ipddir+'data\IN'+yy +mm +'.dbf'
*DO WHIL !FILE(dbfuse)
*	IF VAL(mm) = 1
*		mm ='12'
*		yy = ALLTRIM(STR(VAL(yy) - 1))
*	ELSE
*		mm = RIGHT('0'+ALLTRIM(STR(VAL(mm)-1)),2)
*	ENDI
*	dbfuse = ipddir+'data\IN'+yy +mm +'.dbf'
*	i=i+1
*	WAIT WIND 'i =' +STR(i)
*	IF i = 5
*		!FILE(dbfuse) = .T.
*		WAIT WIND 'STOP'
*		EXIT
*	ENDIF
*ENDD
*USE (dbfuse) IN 0
*COPY TO temp STRU EXTE
*USE temp
*LOCA FOR field_name = 'ADM_W'
*IF EOF()
*	WAIT WIND '�ç���ҧ��������� ' +dbfuse + ' ���١��ͧ' + CHR(13) + ;
*	'��س�����ç���ҧ�����͹ �������� ���ا�ѡ���к�' + CHR(13) + ;
*	'�ԩй���Ҩ�Դ�����Դ��Ҵ㹡�÷ӧҹ' + CHR(13) + ;
*	'...������� � ���ͷӧҹ���...' TIME 100
*ENDI
*USE
*DELE FILE temp.dbf

*dbfuse = ipddir+'data\ADM'+yy
*USE (dbfuse) IN 0
*COPY TO temp STRU EXTE
*USE temp
*LOCA FOR field_name = 'ADM_W'
*IF EOF()
*	WAIT WIND '�ç���ҧ��������� ADM' +yy +' ���١��ͧ' + CHR(13) + ;
*	'��س�����ç���ҧ�����͹ �������� ���ا�ѡ���к�' + CHR(13) + ;
*	'�ԩй���Ҩ�Դ�����Դ��Ҵ㹡�÷ӧҹ' + CHR(13) + ;
*	'...������� � ���ͷӧҹ���...' TIME 100
*ENDI
*USE
*DELE FILE temp.dbf
*** UDC

col=Center(mhosp_name)
@ 0,col SAY mhosp_name COLO g+/b
DO mainscr
DO workscr
			NumMain=6           && �ӹǹ��¡����ѡ
			DIME MAIN(NumMain),MainMess(NumMain)
			Main(1)='��ͧ�ѵ�'
			Main(2)='�����¹͡'
			Main(3)='�Ѻ�������'
			Main(5)='���ا�ѡ���к�'
			Main(4)='�������'
			Main(NumMain)='��ԡ�ҹ'
			MainMess(1)='�ҹ��ͧ�ѵ������ͧ����¹'
			MainMess(2)='�ҹŧ�����š���ҵ�Ǩ�����¹͡'
			MainMess(3)='�ҹŧ����¹�������Ѻ�����ç��Һ�� ��л�Ъ�����ѹ��'
			MainMess(4)='�ҹŧ�š���ѡ�Ҽ������'
			MainMess(5)='�ҹ��˹�����к� �����ö����ª��'
			MainMess(NumMain)='��ԡ��÷ӧҹ'
			ColSpace=78/NumMain    && ������ҧ�����ҧ������¡��
			ChMain=1               && ��¡�÷�����͡
DO WHIL goon
	DO CASE
		CASE UPPE(_toprog) == 'S'
			DO lan WITH .T.
		CASE UPPE(_toprog) == 'P'
			DO lan WITH .T.
		CASE UPPE(_toprog) == 'O'
			DO came1 WITH .T.
		CASE UPPE(_toprog) == 'A'
			DO Adm_cen WITH .T.
		CASE UPPE(_toprog) == 'I'
			DO ipd WITH .T.
		OTHER
			CLOSE DATA
			sysdate=DATE()
			thaiday=Ce2Cbe(sysdate)
			@ 1,0
			@ 1,4 SAY thaiday COLO gr+/b
			@ 22,0 CLEA
			DO title WITH '��¡����ѡ'
			xx=1
			@ 2,0 SAY REPL('-',80)
			@ 21,0 SAY REPL('-',80)
			@ 22,0
			SELE 0
			dbfuse = patientdir+'user'
			USE (patientdir+'user')
			dbfuse = ''
			ChMain =IIF(RECCOUNT('user') = 0,5,ChMain)
			USE
			DO WHIL xx<=NumMain
				@ 22,Col()+2 PROMPT Main(xx) MESSAGE MainMess(xx)
				xx=xx+1
			ENDD
			= EngMODE()
			MENU TO ChMain
			@ 22,0 CLEA
			DO CASE
				CASE ChMain=1
					DO Lan
				CASE Chmain=2
					DO Came1
				CASE Chmain=3
					DO Adm_cen
				CASE ChMain=4
					DO Ipd
				CASE ChMain=5
					DO StatUtil
				CASE ChMain=nummain
					CLOSE DATA
					ON ERROR
					goon = .F.
				OTHER
					Chmain = nummain
			ENDC
		DO mainScr
	ENDC
ENDD
= ENGMODE()
? CHR(155)+'KE'
DO EndSet
CLEA

PROC MAINSCR
@ 3,0 CLEA TO 20,80
@ 2,0
TEXT
                          ���������Ѻ�ҹ�Ǫ����¹���ʶԵ�
                                STAT Version <<statversion>>
                                 ��з�ǧ�Ҹ�ó�آ
ENDTEXT
? SPAC(Center(programdate))+programdate

PROC WORKSCR
TEXT
                               ��зӧҹ�Ѳ�������
    ���ᾷ���д�ɰ�  ǧ�줳��ѵ����        �ç��Һ�����ͧ��ط�
    ���ᾷ��Ե�      �Ѳ��Ө�              �ç��Һ�������ɮ��
    ���ᾷ��͹��Ѳ��  ����صԡ��            ʶҺѹ�Ԩ���к��Ҹ�ó�آ
    ���ᾷ�����ѵ��   ��������侺����       �ç��Һ����þ�Է�Ի��ʧ�� �غ��
    ���ᾷ���ط�����  ����ǧ                �ç��Һ���ʹ� ��ظ��
    ���ᾷ�����      ʡ�žҳԪ��           �ç��Һ�ž�оط��ҷ ��к���
    �ҧ��ǹԵ��       ����ɪ�¹��ó�        ʶҺѹ�Ҫ�ѯ �ǹ�عѹ��
    �ҧ��������       �ԧ������ҧ           ����Ҹ�ó�آ��ʵ�� ��Դ�
    �ҧ�������ó�     ����๵�              �ӹѡ෤��������ʹ��
    �ҧ��ɳ���        ���õ���������       �ͧ�ç��Һ�������Ҥ
����֡��... ���ᾷ���تҵ� �óʶҾ�        �ç��Һ�����ҸԺ��
��Ѻ��ا��... �����Թ��� �Ԣ�Թ��ҹ���     �ç��Һ�������� ���
             ��.�ش�⪤ ����ѧ  �ç��Һ�����稾���ѧ��Ҫ ͧ���� 17 �ؾ�ó����
ENDTEXT

***------------------------  �Ѵ����  --------------------
proc appointment
PARA _new
DEAC WIND ALL
@3,0 TO 20,80 clea
SELE holiday
COPY TO ARRA HLDDATE FOR DATE > DATE()
IF TYPE('hlddate') # 'D'
	DIME hlddate(1,2)
	hlddate[1,1] = {01/01/1700}
	hlddate[1,2] = '             '
ENDI
DO AddRoutHld WITH DATE(),hlddate

do appo_screen           && search parag 3000
do entry_appo            && search parag 4000

***---------------------   3000   ----------------
proc appo_screen
text

    				��˹���ùѴ��Ǩ����


           �ѹ���Ѵ                           ���ҹѴ


           �Ѵ��Ǩ�������չԤ


           ᾷ����Ѵ



           �觪ѹ�ٵ�

endtext
***------------------------   4000  �ѹ�֡��ùѴ  ---------------
PROC ENTRY_APPO
fromin = PROGRAM(3) = 'IN_APPO'
ON KEY LABEL CTRL+P DO PrintStatus
ON KEY LABEL ALT+C DO Showcalendar WITH mdateappo
m.date = {  /  /  }
firstenter = _new 	&& ����������繡����������ŧ������
@ 4,60 SAY IIF(_printappoint,'�����㺹Ѵ    ','�������㺹Ѵ ') COLO /w
@ 8,28 get mdateappo WHEN HideWin('win1') .AND. ActiCalendar() PICT '@!' ;
VALID CHECKAPPOINT(mdateappo) .AND. DeacCalendar() ;
mess '��� �ѹ��͹��(ddmmyyyy) ���� W ��ͷ���᷹�ѻ���� ���� M ��ͷ���᷹��͹ (ALT+C)'
@ 9,28 GET showdate DEFA SPACE(20) DISA COLO ,,,,,,,,,/w
@ 8,56 get mmtime pict '@r ##:##' VALID TimeAPPO(mmtime) ;
  mess '������ҷ��Ѵ�� ��������ҷ�'
@ 11,34 GET m.clinic VALID CheckClinic(m.clinic,mclinic)
@ 11,38 GET mclinic DISA COLO ,,,,,,,,,/w
@ 14,28 get m.doctor WHEN InputDoctor(m.doctor) VALID ;
CheckDoctor(m.doctor,mdoctor) MESS '�������ᾷ����Ѵ������仾�'
@ 14,35 GET mdoctor WHEN CLEARKEY() DISA COLO ,,,,,,,,,/w
@ 18,28 EDIT m.lab SIZE 3,40  WHEN EditLab() COLO ,/w;
  mess ' LAB ����ͧ���Сͺ ����ö�����������Ţ˹�Ҫ�����'
@ 22,20 SAY '�����Ŷ١��ͧ������� ' GET m.correct WHEN Clearkey()DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
READ NOLOCK
=ClearKey()
**********

@ 4,60
if LEFT(mdateappo,2) # '  '
	m.doctor = PADBLANK(m.doctor)
	IF ! fromin .AND. USED('camefile')
		sele camefile
		m.hn    =hn
	ENDI
   m.time=mmtime
   sele appoint
	IF  _new
	   	GO TOP
   		IF ! EMPTY(hn) .OR. BOF()
   			appe blank
   		ENDI
   ENDI
   gather memv MEMO
   FLUSH
	IF _printappoint
		IF FILE('printapp.fxp')
			DO ('printapp')
		ELSE
			DO Prappop
		ENDI
	ENDI
ELSE
	SELE appoint
	IF ! _new .AND. ! EOF()
		REPL hn WITH '  ',DATE WITH CTOD('  /  /  '),lab WITH ''
		FLUSH
	ENDI
endi
IF ! fromin
	IF PROGRAM(2) = 'ADM_CEN'
		SELE iptrana
	ELSE
		IF USED('camefile')
			SELE camefile
		ENDI
	ENDI
ENDI
ON KEY LABEL CTRL+P
RETURN

FUNC CHECKAPPOINT
para _check
private _date
IF LEFT(_check,2)='  '
	CLEA READ
	RETU
ENDI

_date=ALLTRIM(_check)
_type=RIGHT(_date,1)
   if _type $ 'WM'
      newdate=VAL(SUBS(_check,1,LEN(_date)-1))
      IF PROGRAM(3) = 'IN_APPO' .OR. ! used('camefile')
      	m.date=IIF(_type = 'W',DATE()+(newdate*7),DATE()+(newdate*28))
      ELSE
      	m.date=IIF(_type = 'W',camefile->date+(newdate*7),camefile->date+(newdate*28))
      ENDI
   ELSE
   	  _check=IIF(LEN(_date)<10,LEFT(_check,2)+'/'+SUBS(_check,3,2)+'/'+SUBS(_check,5,4),_check)
   	  IF TRUEDATE(_check)
   	  	m.date=BE2CE(_check)
   	  	IF USED('camefile')
	   	  	_cdate = IIF(PROGRAM(3)='IN_APPO',DATE(),camefile.date)
		ELSE
			_cdate = DATE()
		ENDI
   	  	IF m.date<=_cdate
    	    ?? CHR(7)
    	    WAIT '����ѹ���Ѵ��͹�ѹ��� ���١��ͧ' WIND NOWA
    	    _CUROBJ=_CUROBJ
    	ENDI
   	  ELSE
   	    ?? CHR(7)
   	    WAIT '����ѹ���Ѵ���١��ͧ' WIND NOWA
   	    _CUROBJ=_CUROBJ
   	  ENDI
   endi
dayofweek = DOW(m.date)
IF dayofweek = 1 .OR. dayofweek = 7
	?? CHR(7)
	showdayofweek = IIF(dayofweek = 1,'�ѹ�ҷԵ��','�ѹ�����')
	WAIT WIND NOWA '�ô���ѧ ! �Ѵ�ç�Ѻ�ѹ'+showdayofweek
ELSE
	ms = ASCAN(hlddate,m.date)
	IF ms > 0
		= ALARM1()
		WAIT WIND NOWA '�Ѵ�ç�Ѻ�ѹ '+ hlddate(ms+1)
	ENDI
ENDI
showdate=CE2CBE(m.date)
SHOW GETS

FUNC TIMEAPPO
PARA _mmtime
IF ! BETWEEN(VAL(LEFT(_mmtime,2)),8,15)
	=ALARM1()
	WAIT '�ô���ѧ ! ����������Ҫ��� ����ùѴ����' WIND NOWA
ENDI

FUNC EditLab
IF firstenter
	SELE countapp
	IF SEEK(DTOS(m.date)+m.clinic)
		numcount = number+1
		repl number WITH numcount
		FLUSH
	ELSE
		go top
		IF date < m.date
			APPE BLAN
		ENDI
		REPL date WITH m.date,clinic WITH m.clinic,number WITH 1
		FLUSH
		numcount = 1
	ENDI
	firstenter = .F.
	WAIT WIND NOWA '�����¹Ѵ�繤���� ' + LTRIM(STR(numcount))
ENDI

DEFINE WIND lab FROM 1,1 TO 18,26  && ��� 15,23
ACTI WIND lab
@ 0,1 SAY 'ALT+1 = CBC'
@ 1,1 SAY 'ALT+2 = UA'
@ 2,1 SAY 'ALT+3 = CXR'
@ 3,1 SAY 'ALT+4 = EKG'
@ 4,1 SAY 'ALT+5 = BUN Cr'
@ 5,1 SAY 'ALT+6 = Electrolyte'
@ 6,1 SAY 'ALT+7 = LFT'
@ 7,1 SAY 'ALT+8 = FBS'
@ 8,1 SAY 'ALT+9 = VDRL'
@ 9,1 SAY 'ALT+0 = Anti HIV'
@10,1 SAY '^A = Ultrasound'
@11,1 SAY '^B = HBsAg'
@12,1 SAY '^X = X-ray ��� �'
@13,1 SAY '^C = CHO TG HDL'
@14,1 SAY '^N = NPO ��ѧ���§�׹'
@15,1 SAY '^M = NPO ��ѧ 2 ����'

SHOW WIND lab
ACTI SCREE
ON KEY LABEL ALT+1 KEYB 'CBC '
ON KEY LABEL ALT+2 KEYB 'UA '
ON KEY LABEL ALT+3 KEYB 'CXR '
ON KEY LABEL ALT+4 KEYB 'EKG '
ON KEY LABEL ALT+5 KEYB 'BUN Cr '
ON KEY LABEL ALT+6 KEYB 'Electrolyte '
ON KEY LABEL ALT+7 KEYB 'LFT '
ON KEY LABEL ALT+8 KEYB 'FBS '
ON KEY LABEL ALT+9 KEYB 'VDRL '
ON KEY LABEL ALT+0 KEYB 'Anti HIV '
ON KEY LABEL CTRL+A KEYB 'Ultrasound '
ON KEY LABEL CTRL+B KEYB 'HBsAg '
ON KEY LABEL CTRL+X KEYB 'X-ray ��� � '
ON KEY LABEL CTRL+C KEYB 'CHO TG HDL '
ON KEY LABEL CTRL+N KEYB '���������������ѧ���§�׹ '
ON KEY LABEL CTRL+M KEYB '���������������ѧ 2 ���� '
ON KEY LABEL ENTER KEYB "{TAB}"
*DO ClearKey

FUNC ClearKey
ON KEY LABEL ALT+1
ON KEY LABEL ALT+2
ON KEY LABEL ALT+3
ON KEY LABEL ALT+4
ON KEY LABEL ALT+5
ON KEY LABEL ALT+6
ON KEY LABEL ALT+7
ON KEY LABEL ALT+8
ON KEY LABEL ALT+9
ON KEY LABEL ALT+0
ON KEY LABEL CTRL+A
ON KEY LABEL CTRL+B
ON KEY LABEL CTRL+X
ON KEY LABEL CTRL+C
ON KEY LABEL CTRL+N
ON KEY LABEL CTRL+M
ON KEY LABEL ENTER
DEAC WIND lab

PROC PrintStatus
STOR IIF(_printappoint,.F.,.T.) TO _printappoint
@ 4,60 SAY IIF(_printappoint,'�����㺹Ѵ    ','�������㺹Ѵ ') COLO /w

FUNC CHECKFIRST
PARA _add
numpara = PARAMETERS()
varread=VARREAD()
DO CASE
	CASE varread='MT_IN'
		IF mt_in='  '
			mt_in=patient1->time
			SHOW GETS
			IF numpara > 0 .AND. UPPER(_add) = 'ADDCAME'
				mseek = m.hn + STR(DAY(BE2CE(mdate)),2) + m.clinic + STR(MINUTEIN(mt_in),4)
				IF SEEK(mseek,'camefile')
					?? CHR(7)
					WAIT WIND NOWA '�����¤������ŧ����������'
					RETU .T.
				ELSE
					RETU IIF(mt_in='  ',.T.,.F.)
				ENDI
			ELSE
				RETU IIF(mt_in='  ',.T.,.F.)
			ENDI
		ENDI
	CASE varread='MT_OUT'
		IF mt_out='  '
			_mtime=TIME()
			mt_out=LEFT(_mtime,2)+SUBS(_mtime,4,2)
		ENDI
	CASE LEFT(varread,4) $ 'MNEW,DXTY'
		_x=RIGHT(varread,2)
		_x = IIF( ISDIGIT(_x), _x, RIGHT(_x,1) )
		IF EMPTY(mdiag&_x)
			mnew&_x=' '
			RETU .F.
		ELSE
			IF LEFT(varread,4) = 'MNEW'
				IF USED('newcase')
					SELE newcase
					IF ! SEEK(m.hn)
						mnew&_x = '1'
					ENDI
				ENDI
			ENDI
		ENDI

ENDC
SHOW GETS


***------------------------  ����ѡ�Ҽ������ --------------------
proc inchrg
PARA _new
*DEAC WIND ALL
define window inchrg from 03,0 to 20,79 shadow
activate window inchrg
@3,0 TO 20,80 clea
do inchrg_screen           && search parag 5000
do entry_inchrg            && search parag 6000
rele window inchrg
***---------------------   5000   ----------------
proc inchrg_screen
text
    				����ѡ�Ҿ�Һ�ż������
  AN :            ����ѡ�Ңͧ
  ��������´
           ��Ҫѹ�ٵ���ͧ��Ժѵԡ��
           ��� X-Ray
           ��ҵ�Ǩ�ѹ�ٵ���� �
           ��Ҽ�ҵѴ
           ��ҡ���ѡ����� �
           ���������Ǫ�ѳ��
           ��� ICU
           �����ͧ
           ��������
           ��� �
        ���
        ���¨�ԧ

endtext
***------------------------   6000  �ѹ�֡����ѡ�� ---------------
PROC ENTRY_inchrg
fromin = PROGRAM(3) = 'IN_inchrg'
m.date = {  /  /  }
firstenter = _new 	&& ����������繡����������ŧ������
stor 0 to m01,m02,m03,m04,m05,m06,m07,m08,m09,m010,m.sum,m.paid
cItem1 = "0A"
cItem2 = "0B"
cItem3 = "0C"
cItem4 = "0D"
cItem5 = "0E"
cItem6 = "0F"
cItem7 = "0G"
cItem8 = "0H"
cItem9 = "0I"
cItem10 = "0J"
@ 1,8 SAY m.an COLO /w
@ 1,31 SAY m.name colo /w
@ 3,8 say cItem1 colo /w
@ 3,37 GET m01 PICT '@R #######' COLO ,,,,,,,,,/w
@ 4,8 say cItem2 colo /w
@ 4,37 GET m02 PICT '@R #######' COLO ,,,,,,,,,/w
@ 5,8 say cItem3 colo /w
@ 5,37 GET m03 PICT '@R #######' COLO ,,,,,,,,,/w
@ 6,8 say cItem4 colo /w
@ 6,37 GET m04 PICT '@R #######' COLO ,,,,,,,,,/w
@ 7,8 say cItem5 colo /w
@ 7,37 GET m05 PICT '@R #######' COLO ,,,,,,,,,/w
@ 8,8 say cItem6 colo /w
@ 8,37 GET m06 PICT '@R #######' COLO ,,,,,,,,,/w
@ 9,8 say cItem7 colo /w
@ 9,37 GET m07 PICT '@R #######' COLO ,,,,,,,,,/w
@ 10,8 say cItem8 colo /w
@ 10,37 GET m08 PICT '@R #######' COLO ,,,,,,,,,/w
@ 11,8 say cItem9 colo /w
@ 11,37 GET m09 PICT '@R #######' COLO ,,,,,,,,,/w
@ 12,8 say cItem10 colo /w
@ 12,37 GET m010 PICT '@R #######' COLO ,,,,,,,,,/w
read nolock
m.sum = m01+m02+m03+m04+m05+m06+m07+m08+m09+m010
@ 13,37 SAY m.sum COLO /w
@ 14,37 GET m.paid COLO /w
@ 15,20 SAY '�����Ŷ١��ͧ������� ' GET m.correct WHEN Clearkey()DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
READ NOLOCK
=ClearKey()

********************************** ����բ����Ť���ѡ�Һѹ�֡� rcpd,dtpd,creditpd
*	= OPENDBF(BILLDIR+'all\DtPd','DtPd')
*	= OPENDBF(BILLDIR+'all\RcPd','RcPd')
*	= OPENDBF(BILLDIR+'all\CreditPd','CreditPd')
do openfile1
sele creditpd
*SET ORDER TO TAG Rc_no
go bott
mRc_no = Rc_no
m.Rc_no = str(val(mRc_no)+1)
	DO WHIL ! empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
	GATH MEMV
	FLUSH
	UNLOCK ALL

sele RcPd
m.date = datedsc
m.total = m.sum
m.paid = m.paid
	DO WHIL ! empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
	GATH MEMV
	FLUSH
	UNLOCK ALL

sele dtpd
goon = .T.
n=1
DO WHIL n <= 10
	msv_id = 'cItem'+alltrim(str(n))
	mget = 'm0'+alltrim(str(n))
	m.sv_id = &msv_id
	m.amt = &mget
		go top
		if m.amt = 0
			*skip
			n = n+1
		else
		DO WHIL ! empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
		gather memvar
		FLUSH
		UNLOCK ALL
	n = n+1
ENDI
ENDD

********************
FUNC CheckClinic
********************
PARA _clinic,_mclinic
SELE clinic
IF ! EMPTY(_clinic)
   	SET ORDER TO TAG clinic
	IF ! SEEK(_clinic)
		?? CHR(7)+CHR(7)
		WAIT '����դ�չԤ���� '+_clinic WIND NOWAIT
		_CUROBJ=_CUROBJ
	ENDI
	_mclinic=name
ELSE
	?? CHR(7)
	WAIT WIND NOWA '��ͧ������ʤ�չԡ����'
	_CUROBJ=_CUROBJ
ENDI
SHOW GETS

PROC WARNNEW
PARA _newfile
PRIV correct,tempfile
=ALARM1()
DEFI WIND warnnew FROM 4,5 TO 14,70 SHAD
ACTI WIND warnnew
@ 1,3 SAY '�ç���ҧ�ͧ��� ' + _newfile +' ���١��ͧ'
@ 3,3 SAY '��ҹ��ͧ���������١��ͧ�������' GET correct PICT '!' DEFA 'Y'
READ NOLOCK
IF correct # 'Y'
	RELE WIND warnnew
	RETU TO MASTER
ELSE
	CLEA
	@ 2,3 SAY '��ҹ��ͧ���������� ' + _newfile + ' ���١��ͧ'
	@ 4,3 SAY '��ҹ��ͧ����������������ͧ�����ش������¡��������'
	@ 7,3 SAY '��ҹ������������������ ' GET correct PICT '!'
	READ NOLOCK
	IF correct # 'Y'
		RELE WIND warnnew
		RETU TO MASTER
	ELSE
		USE
		tempfile = PATIENTDIR + SYS(3)
		RENA (_newfile+'.dbf') TO (tempfile+'.dbf')
		dbfuse = _newfile
		CREATE TABLE (_newfile) (HN C(7),VISITED L)
		INDEX ON hn TAG hn
		dbfuse = _newfile
		USE (_newfile) ORDER TAG hn ALIA newcase
		dbfuse = patientdir+tempfile
		USE (tempfile) IN 0 ALIA temp
		dbfuse = ''
		SELE temp
		div_num=ROUND((RECCOUNT()/40)+.5,0)
		recno = 0
		DO ShowProgress
		SCAN
			recno=recno+1
			@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '�' COLO gr+
			m.hn = hn
			m.visited = .T.
			INSERT INTO newcase FROM MEMV
		ENDS
		DEAC WIND progress
		USE
		DELE FILE (tempfile+'.dbf')
	ENDI
ENDI
RELE WIND warnnew
CLEA TYPEAHEAD

FUNC ActiCalendar
ON KEY LABEL Alt+C DO Showcalendar WITH mdateappo

FUNC DeacCalendar
ON KEY LABEL Alt+C

PROC ShowCalendar
PARA _date
PRIV dateappo
dateappo = IIF(! EMPTY(_date) .AND. Truedate(_date),BE2CE(_date),DATE() + 1)
nextdate = GOMONTH(DATE(),6)
nextdate = nextdate - DAY(nextdate)
dateappo = IIF(dateappo > nextdate, nextdate, dateappo)
DO hifu WITH DATE(),dateappo
_date = CE2BE(dateappo)
SHOW GETS
KEYB CHR(13)

PROC AddRoutHld
PARA _date,_arr
PRIV year
numadd = 22
DIME routhld[numadd,2]
year = STR(YEAR(_date),4)
year1 = STR(YEAR(_date)+1,4)
routhld[1,1] = CTOD('01/01/'+year)
routhld[1,2] = '�ѹ��鹻�����   '
routhld[2,1] = CTOD('06/04/'+year)
routhld[2,2] = '�ѹ�ѡ��   '
routhld[3,1] = CTOD('13/04/'+year)
routhld[3,2] = '�ѹʧ��ҹ��      '
routhld[4,1] = CTOD('14/04/'+year)
routhld[4,2] = '�ѹʧ��ҹ��      '
routhld[5,1] = CTOD('15/04/'+year)
routhld[5,2] = '�ѹʧ��ҹ��      '
routhld[6,1] = CTOD('05/05/'+year)
routhld[6,2] = '�ѹ�ѵ�����      '
routhld[7,1] = CTOD('12/08/'+year)
routhld[7,2] = '�ѹ������Ъ��� �ҪԹ�'
routhld[8,1] = CTOD('23/10/'+year)
routhld[8,2] = '�ѹ��������Ҫ '
routhld[9,1] = CTOD('05/12/'+year)
routhld[9,2] = '�ѹ������Ъ������� ���ǧ'
routhld[10,1] = CTOD('10/12/'+year)
routhld[10,2] = '�ѹ�Ѱ�����٭    '
routhld[11,1] = CTOD('31/12/'+year)
routhld[11,2] = '�ѹ��鹻�        '
routhld[12,1] = CTOD('01/01/'+year1)
routhld[12,2] = '�ѹ��鹻�����   '
routhld[13,1] = CTOD('06/04/'+year1)
routhld[13,2] = '�ѹ�ѡ��   '
routhld[14,1] = CTOD('13/04/'+year1)
routhld[14,2] = '�ѹʧ��ҹ��      '
routhld[15,1] = CTOD('14/04/'+year1)
routhld[15,2] = '�ѹʧ��ҹ��      '
routhld[16,1] = CTOD('15/04/'+year1)
routhld[16,2] = '�ѹʧ��ҹ��      '
routhld[17,1] = CTOD('05/05/'+year1)
routhld[17,2] = '�ѹ�ѵ�����      '
routhld[18,1] = CTOD('12/08/'+year1)
routhld[18,2] = '�ѹ������Ъ��� �ҪԹ�'
routhld[19,1] = CTOD('23/10/'+year1)
routhld[19,2] = '�ѹ��������Ҫ '
routhld[20,1] = CTOD('05/12/'+year1)
routhld[20,2] = '�ѹ������Ъ������� ���ǧ'
routhld[21,1] = CTOD('10/12/'+year1)
routhld[21,2] = '�ѹ�Ѱ�����٭    '
routhld[22,1] = CTOD('31/12/'+year1)
routhld[22,2] = '�ѹ��鹻�        '

oldarrlen = ALEN(_arr,1)
DIME _arr[oldarrlen+numadd,2]
FOR i = 1 TO numadd
	_arr[oldarrlen+i,1] = routhld[i,1]
	_arr[oldarrlen+i,2] = routhld[i,2]
NEXT

FUNC CHECKDXTYPE
PARA _dxtype, _mdiag
preprogram = PROGRAM(2)
varread = VARREAD()
numpara = PARAMETERS()
IF numpara = 1 .OR. ! (ISDIGIT(_mdiag) .OR. LEFT(_mdiag,1) = '*')
* udc
	IF LEFT(_mdiag,1) $ 'VWXYvwxy' .and. _dxtype <> '4'
		= CHR(7)
		WAIT WIND NOWA '�����������١��ͧ' + CHR(13) + ;
		'���˵آͧ��úҴ�� (��鹵鹴��� V, W, X, Y) ��ͧ���������� 4'
		RETU 0
	ELSE
		IF LEFT(_mdiag,3) = 'Z37' .and. _dxtype <> '4'
			= CHR(7)
			WAIT WIND NOWA '�����������١��ͧ' + CHR(13) + ;
			'Delivery Outcome (��鹵鹴��� Z37) ��ͧ���������� 4'
			RETU 0
		ELSE
* udc
			IF ! BETWEEN(_dxtype,'2','4')
				= CHR(7)
				WAIT WIND NOWA '�����������١��ͧ ������ [F1] ��ҵ�ͧ��ä������������'
				RETU 0
			ENDI
		ENDI && udc
	ENDI && udc
ENDI
IF RIGHT(varread,1) = '4' AND LASTKEY() # 5
	IF preprogram = 'CAME1'
		DO diaginpu.spr
	ELSE
		DO diagip.spr
	ENDI
ENDI

****************
FUNC CheckDoctor
****************
PARA _doctor,_mdoctor
SELE doctor
validinput = .T.
varread = VARREAD()
IF ! EMPTY(_doctor)
	_doctor=PadBlank(_doctor,6)
   	SET ORDER TO TAG doctor
	IF ! SEEK(_doctor)
		?? CHR(7)+CHR(7)
		WAIT '�����ᾷ������ '+_doctor WIND NOWAIT
		_doctor=RemoveBlank(_doctor)
		_CUROBJ = _CUROBJ - 1
		validinput = .F.
	ELSE
		IF ! STATUS
			?? CHR(7)+CHR(7)
			WAIT '!!! �ô���ѧ... ᾷ���ҹ��������ӧҹ��������� !!!' WIND NOWAIT
		ENDIF
	ENDI
	_mdoctor=name
ENDI
SHOW GETS
IF validinput .AND. UPPE(varread) = 'SURG4'
	DO OperIP.spr
ENDI