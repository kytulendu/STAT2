PARA _startprog
PRIV goon
SET RESOURCE OFF
*RELE ALL
SET PROC TO Utility
_toprog = IIF(PARAMETER()=0,'  ',_startprog)
DO StartSet
#DEFINE UpArrow 5
#DEFINE LeftArrow 19
PUBLIC Atrscreen,Atrbackgr,Atrdata,Atrmenu,Atrmenu2
STORE '\pub\' TO patientdir,codedir
STOR '' TO tempdir,workstation,backup,admit,thaicard,person_id,;
prescription,notprintrx,wellbaby,notkeyword,backupdrive,dbfuse,notstatadmit
STORE '\ipd\' TO ipddir
STORE '\opd\' TO opddir
STORE '\pharm\' TO pharmdir
ON error DO err WITH ERROR(),MESSAGE(),LINENO(),PROGRAM(),PROGRAM(2),PROGRAM(3),;
PROGRAM(4),PROGRAM(5),PROGRAM(6),PROGRAM(7),PROGRAM(8),PROGRAM(9)
DIME ProvArr(60)
goon = .T.
DIME test(4)
=ADIR(test,SYS(16))
programdate=CE2CBE(test[3])
fromhelp = .F.
backup = UPPE(GETENV('BACKUP')) 
workstation = UPPE(GETENV('workstation'))
DO GetConfig
audit = backup = 'AUDIT'
F_STATION=workstation='FILE'
ER=workstation='ER'
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
	DO makedbf			&& ��Ǩ�ͺ�������������繤ú������� ��ҢҴ������ҧ����
	PUSH KEY CLEA
	ON KEY LABEL F1 KEYB '{ENTER}'
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
	READ
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
SET MESSAGE TO 24
SET TEXT ON
mhosp_name=LTRIM(TRIM(hosp_name))
statversion = '2.6'
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
			MainMess(NumMain)='��ԡ��÷ӧҹ  �ջѭ�ҵԴ����ٹ����������� FAX.5918630'
			ColSpace=78/NumMain    && ������ҧ�����ҧ������¡��
			ChMain=1               && ��¡�÷�����͡
DO Lan WITH .T.
= ENGMODE()
? CHR(155)+'KE'
DO EndSet
CLEA

PROC MAINSCR
@ 3,0 CLEA TO 20,80
@ 2,0
TEXT
                        ���������Ѻ�ҹ�Ǫ����¹���ʶԵ�
                                STAT  Version <<statversion>>
                                 ��з�ǧ�Ҹ�ó�آ
ENDTEXT
? SPAC(Center(programdate))+programdate

PROC WORKSCR
TEXT
                               ��зӧҹ�Ѳ�������

    ���ᾷ���д�ɰ�  ǧ�줳��ѵ����           �ç��Һ��⾸����
    ���ᾷ��Ե�      �Ѳ��Ө�                 �ç��Һ���Ҫ����
    ���ᾷ��͹��Ѳ��  ����صԡ��               �ͧ�ç��Һ�������Ҥ
    ���ᾷ�����ѵ��   ��������侺����          �ç��Һ����þ�Է�Ի��ʧ�� �غ��
    ���ᾷ���ط�����  ����ǧ                   �ç��Һ���ʹ� ��ظ��
    ���ᾷ�����      ʡ�žҹԪ                �ç��Һ�ž�оط��ҷ ��к���
    �ҧ��ǹԵ��       ����ɪ�¹��ó�           �ͧ�кҴ�Է��
    �ҧ��������       �ԧ������ҧ              ����Ҹ�ó�آ��ʵ�� ��Դ�
    �ҧ�������ó�     ����๵�                 �ٹ�����������
    �ҧ��ɳ���        ���õ���������          �ͧ�ç��Һ�������Ҥ
����֡��
    ���ᾷ���تҵ�    �óʶҾ�                 �ç��Һ�����ҸԺ��
ENDTEXT

***------------------------  �Ѵ����  --------------------
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
READ
IF correct # 'Y'
	RELE WIND warnnew
	RETU TO MASTER
ELSE
	CLEA
	@ 2,3 SAY '��ҹ��ͧ���������� ' + _newfile + ' ���١��ͧ'
	@ 4,3 SAY '��ҹ��ͧ����������������ͧ�����ش������¡��������'
	@ 7,3 SAY '��ҹ������������������ ' gET correct PICT '!'
	READ
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
proc appointment
PARA _new
DEAC WIND ALL
@3,0 TO 20,80 clea
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
m.date = {  /  /  }
firstenter = _new 	&& ����������繡����������ŧ������
@ 4,60 SAY IIF(_printappoint,'�����㺹Ѵ    ','�������㺹Ѵ ') COLO /w
@8,30 get mdateappo WHEN HideWin('win1') PICT '@!' VALID CHECKAPPOINT(mdateappo);
mess '��� �ѹ��͹��(ddmmyyyy) ���� W ��ͷ���᷹�ѻ���� ���� M ��ͷ���᷹��͹' 
@ 9,25 GET showdate DEFA SPACE(20) DISA COLO ,,,,,,,,,/w
@ 8,56 get mmtime pict '@r ##:##' VALID TimeAPPO(mmtime) ;
  mess '������ҷ��Ѵ�� ��������ҷ�'
@ 11,34 GET m.clinic VALID ;
CheckClinic(m.clinic,mclinic)
@ 11,38 GET mclinic DISA COLO ,,,,,,,,,/w
@13,26 get m.doctor WHEN InputDoctor(m.doctor) VALID ;
CheckDoctor(m.doctor,mdoctor) MESS '�������ᾷ����Ѵ������仾�'
@ 13,33 GET mdoctor WHEN CLEARKEY() DISA COLO ,,,,,,,,,/w
@16,24 EDIT m.lab SIZE 3,40  WHEN EditLab() COLO ,/w;
  mess ' LAB ����ͧ���Сͺ ����ö�����������Ţ˹�Ҫ�����'
@ 20,20 SAY '�����Ŷ١��ͧ������� ' GET m.correct WHEN Clearkey()DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
read
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
		DO printapp
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
	SELE holiday
	IF SEEK(m.date)
		?? CHR(7)
		WAIT WIND NOWA '�Ѵ�ç�Ѻ�ѹ '+holiname
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

DEFINE WIND lab FROM 1,1 TO 15,23
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
@10,0 SAY ' ^A = Ultrasound'
@11,0 SAY ' ^B = HBsAg'
@12,0 SAY ' ^X = X-ray ��� �'
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
ON KEY LABEL ENTER
DEAC WIND lab


PROC PrintStatus
STOR IIF(_printappoint,.F.,.T.) TO _printappoint
@ 4,60 SAY IIF(_printappoint,'�����㺹Ѵ    ','�������㺹Ѵ ') COLO /w

PROC PrintApp
DAY1='�ѹ�ҷԵ��'
DAY2='�ѹ�ѹ���'
DAY3='�ѹ�ѧ���'
DAY4='�ѹ�ظ'
DAY5='�ѹ�����'
DAY6='�ѹ�ء��'
DAY7='�ѹ�����'
SELE patient1
seek hn
cut_name=TRIM(De_Name(name))
SELE icd101
mseek=Con_ICD(TRIM(mdiag1))
SEEK mseek
sele appoint
aa=str(dow(date),1)
mday=DAY&aa+'��� '+CE2CBE(date)
mtime=left(time,2)+'.'+right(time,2)+' �.'
SET CONS OFF
SET PRINT ON
hospname=RTRIM(hosp_name)
IF ! CancelPrint()
	?
	?
	?SPACE(40-LEN(hospname)),CHR(14),hospname
	?
	?space(5),'�Ţ�������¹͡',CHR(14),hn
	?
	? space(5),'����',cut_name
 
	? space(5),'�Ѵ��Ǩ',mday,'����',mtime
	? space(5),'����ԹԨ����ä',TRIM(icd101.desc) &&CHR(14),
	? space(5),'�Ūѹ�ٵ÷���ͧ�� '
	? space(10),lab
	?
	? space(5),'ᾷ����Ѵ  ',rtrim(mdoctor) ,SPACE(5),'��չԤ',rtrim(mclinic)
	?

	eject
ENDI
SET PRINT OFF
SET CONS ON

FUNC CHECKFIRST
varread=VARREAD()
DO CASE
	CASE varread='MT_IN'
		IF mt_in='  '
			mt_in=patient1->time
			SHOW GETS
			RETU IIF(mt_in='  ',.T.,.F.)
		ENDI
	CASE varread='MT_OUT'
		IF mt_out='  '
			_mtime=TIME()
			mt_out=LEFT(_mtime,2)+SUBS(_mtime,4,2)
		ENDI
	CASE LEFT(varread,4)='MNEW'
		_x=RIGHT(varread,1)
		IF EMPTY(mdiag&_x)
			mnew&_x=' '
			RETU .F.
		ELSE
			IF USED('newcase')
				SELE newcase
				IF ! SEEK(m.hn)
					mnew&_x = '1'
				ENDI
			ENDI
		ENDI
		
ENDC
	
