SET PROC TO UTILITY
ON KEY LABEL ALT+X DO CancelProg
ON KEY LABEL F10 ACTI WIND CALCULATOR
ON KEY LABEL F1 DO HelpPhSTAT
PUBLIC Atrscreen,Atrbackgr,Atrdata,Atrmenu,Atrmenu2
fromhelp = .F.
hosp_name = '�ӹѡ��º�����Ἱ�Ҹ�ó�آ ��з�ǧ�Ҹ�ó�آ'
*SET CLOCK TO 0,68
DO startset
DO logo
ON error DO err WITH ERROR(),MESSAGE(),LINENO(),PROGRAM(),PROGRAM(2),PROGRAM(3),;
PROGRAM(4),PROGRAM(5),PROGRAM(6),PROGRAM(7),PROGRAM(8),PROGRAM(9)

IF FILE('DEFAULT.AGE')
	REST FROM default.age ADDI
ELSE
	DIME agecode(14),agecoded(14),agemax(14),agemin(14),agemaxtype(14),agemintype(14)
	STOR 0 TO agecount
	FOR in = 1 TO 14
		STOR SPACE(1) TO agemaxtype(in),agemintype(in)
		STOR SPACE(15) TO agecoded(in)
		STOR 0 TO agemax(in),agemin(in)
	NEXT
ENDI
IF FILE('DEFAULT.DX')
	REST FROM default.dx ADDI
ELSE
	DIME diagcode(14),diagcoded(14),diagmax(14),diagmin(14)
	STOR 0 TO diagcount
	FOR in = 1 TO 14
		STOR SPACE(5) TO diagmax(in),diagmin(in)
		STOR SPACE(15) TO diagcoded(in)
	NEXT
ENDI




numrec=0
dbfuse = ''
DropDead=.F.
tobedone=.T.
DIME Tmonth(12)
Tmonth(1) = '�.�.'
Tmonth(2) = '�.�.'
Tmonth(3) = '��.�.'
Tmonth(4) = '��.�.'
Tmonth(5) = '�.�.'
Tmonth(6) = '��.�.'
Tmonth(7) = '�.�.'
Tmonth(8) = '�.�.'
Tmonth(9) = '�.�.'
Tmonth(10) = '�.�.'
Tmonth(11) = '�.�.'
Tmonth(12) = '�.�.'
MONTH01='���Ҥ�'
MONTH02='����Ҿѹ��'
MONTH03='�չҤ�'
MONTH04='����¹'
MONTH05='����Ҥ�'
MONTH06='�Զع�¹'
MONTH07='�á�Ҥ�'
MONTH08='�ԧ�Ҥ�'
MONTH09='�ѹ��¹'
MONTH10='���Ҥ�'
MONTH11='��Ȩԡ�¹'
MONTH12='�ѹ�Ҥ�'
showname = '�ӹѡ��º�����Ἱ�Ҹ�ó�آ ��з�ǧ�Ҹ�ó�آ'
DO Mainmenu
*SHOW MENU PH_MENU
DO WHIL tobedone
	DEAC WIND ALL
	CLEA
	@ 0,Center(showname) SAY showname COLO r+
	ACTI MENU PH_MENU PAD rb504
	HIDE MENU ph_menu
ENDD
*READ VALID MYHANDLER()
SET TALK ON
CLEAR WINDOW ALL
CLOSE DATABASES
POP MENU _MSYSMENU
SET SYSMENU to defa

FUNCTION myhandler
PRIVATE m.temp, m.x

IF dropdead
   RETURN .T.				  && Only when 'Exit' is selected
ENDIF						  && from the menu.

IF LEN(tobedone) > 0		  && Launches an SPR which was
   m.temp = tobedone		  && specified from the menu
   tobedone = ""
   DO (m.temp)
   RETURN .F.
ENDIF

PROC LOGO
DIME logoname[28]
PRIVATE logoname,n,y
logoname[1]= '        ������ҵðҹ           '
logoname[2]= '            ����Ѻ               '
logoname[3]= '   ��ú����çҹ�Ҹ�ó�آ�������  '
logoname[4]= '             ��ҹ                '
logoname[5]= '        ����¹�����§ҹ         '
logoname[6]= '  PUBLIC HEALTH REPORT PROGRAM   '
logoname[7]= '         ** THAISTAT **           '
logoname[8]= '          VERSION 2.0            '
logoname[9]= '       ʧǹ�Ԣ�Է�����������  '
logoname[10]='                                 '
logoname[11]='         �Ѳ���������          '
logoname[12]='                                 '
logoname[13]='      ��ҹ ��.�� ����������      '
logoname[14]='          �غ��Ҫ�ҹ�          '
logoname[15]='                                 '
logoname[16]='   4. ��.�ط����� ����ǧ  '
logoname[17]='        �ç��Һ���ʹ� ��й�������ظ��'
logoname[18]='   5. ��.���� ʡ�žҹԪ '
logoname[19]='        �ç��Һ�ž�оط��ҷ ��к���'
logoname[20]='   6. ��.�Ե�� ����ɪ�¹��ó� '
logoname[21]= '       �ͧ�кҴ�Է�� '
logoname[22]='   7. ��.����ó� ����๵� '
logoname[23]='        �ٹ����������� '
logoname[24]='   8. �ҧ��ɳ��� ���õ��������� '
logoname[25]='        �ͧ�ç��Һ�������Ҥ '
logoname[26]='����֡��     '
logoname[27]='   1. ��.�تҵ� �óʶҾ�'
logoname[28]='        ���ᾷ���ʵ�� þ.���ҸԺ��'
DEFINE WIND logo From 6,20 TO 19,58 SHAD TITLE '  ���Ѳ���к�  '
ACTI WIND logo
n=1
mkey=0
DO WHIL mkey=0
   ? logoname[n]
   ?
   mkey=inkey(.5)
   n=IIF(n=15,1,n+1)
ENDD
RELE WIND logo

PROC GETDATE
PARA _mmyy
DEFINE WIND getdate FROM 6,20 TO 10,60 SHAD
ACTI WIND getdate
@ 1,5 SAY '��س������͹��лշ���ͧ��÷ӧҹ'
@ 2,10 GET _mmyy PICT '@R ##/##' VALID CheckDate(_mmyy)
READ
RELE WIND getdate

FUNC CheckDate
PARA _my
PRIVATE _mm,_yy
_mm = LEFT(_my,2)
_yy = RIGHT(_my,2)
IF ( EMPTY(_mm) OR _mm = LEFT(FULLYEAR(_yy),2)  .OR.  BETWEEN(_mm,'01','12')) .AND. (_yy = '  ' .OR. _yy > ' 9')
	RETU .T.
ELSE
	=TONE(347,10)
	DO CASE
	CASE _mm # LEFT(FULLYEAR(_yy),2)
		WAIT WIND '����� ! �س���վ.�. ���١��ͧ' NOWA
	CASE _yy > ' 9'
		WAIT WIND '����� ! �س�����͹���١��ͧ ��س��������' NOWA
	OTHER
		WAIT WIND '����� ! �س�����͹��л����١��ͧ ��س��������' NOWA
	ENDC
	_CUROBJ = _CUROBJ
ENDI

FUNC TONE
PARA _freq,_dura
SET BELL TO _freq,_dura
?? CHR(7)
SET BELL TO

PROC ASKHOSP
PARA _hcode,_hname
DEFINE WIND askhosp FROM 8,10 TO 14,70 SHAD
msg = '���������ʶҹ��Һ��  [Esc] = ��Ѻ�����¡����ѡ  [F1] = �ͤ������������'
@ 24,Center(msg) SAY msg COLO r+
ACTI WIND askhosp
@ 1,4 SAY '�������ʶҹ��Һ��  ' GET _hcode VALID Hospital(_hcode,_hname)
@ 2,4 SAY 'ʶҹ��Һ�Ū���  ' GET _hname DISA
@ 4,10 SAY '�����Ŷ١��ͧ�������  ' GET correct DEFA 'Y' VALID Correct(correct)
READ
RELE WIND askhosp
@ 24 ,0

PROC CANCELPROG
canc

PROC HelpPhSTAT
IF fromhelp
	WAIT WIND NOWA '�س���������������������������������'
	RETU
ENDI
fromhelp = .T.
IF VARREAD() = 'HOSP_CODE'
	=Hospital(hosp_code,hosp_name)		
ENDI
fromhelp = .F.
KEYB CHR(13)

PROC CREATERB
PARA _ffile,_mmm,_yyy,_numrec
SELE 0
	DIME rbstru[_numrec+2,4]
	rbstru[1,1]='HOSP'
	rbstru[1,2]='C'
	rbstru[1,3]=12
	rbstru[1,4]=0
	rbstru[2,1]='DATE'
	rbstru[2,2]='C'
	rbstru[2,3]=4
	rbstru[2,4]=0
	FOR i = 1 TO _numrec
		x=LTRIM(STR(i))
		rbstru[i+2,1]='CASE'+x
		rbstru[i+2,2]='N'
		rbstru[i+2,3]=6
		rbstru[i+2,4]=0
	NEXT
	reportfile = 'report\r'+_ffile+_yyy+_mmm
	CREAT TABLE (reportfile) FROM ARRAY rbstru
USE

PROC GetIndividual
PARA _file
PRIV type,drive,mm,yy,correct
type = IIF(_file='1','OPD','IPD')
DEFINE WIND rp_govn FROM 8,35 TO 15,69 SHAD TITLE '  �֧�����ż����� '+ type COLO gr+/b
ACTI WIND rp_govn
@ 1,4 SAY '����������������˹  ' 
@ 2,10 PROMPT 'A:'
@ 3,10 PROMPT 'B:'
MENU TO mdrive
IF mdrive=0
	=ALARM1()
	WAIT WIND '¡��ԡ��ô֧������' NOWA
ELSE
	drive = IIF(mdrive=1,'A:','B:')
	IF ! FILE(drive+'readme.'+type)
		=ALARM1()
		WAIT WIND NOWA '��辺��������ż����� '+type+ '���� '+drive
	ELSE
		fhandle = FOPEN(drive+'readme.'+type)
		IF fhandle = 0
			=ALARM1()
			WAIT WIND '�������ö��ҹ��� '+type+ '�ҡ��� '+drive+' ��'
		ELSE
			namehosp = TRIM(SUBS(FGETS(fhandle),5))
			codehosp = TRIM(SUBS(FGETS(fhandle),5))
			waste = FGETS(fhandle)
			waste = FGETS(fhandle)
			fileuse = FGETS(fhandle)
			fileuse = SUBS(fileuse,AT(',',fileuse)+1,6)
			=FCLOSE(fhandle)
			DEFINE WIND ask FROM 10,10 TO 17,70 SHAD
			ACTI WIND ask
			mm = RIGHT(fileuse,2)
			yy = SUBS(fileuse,3,2)
			? '��������ºؤ�Ţͧ������ '+type+' �ͧ'+namehosp
			? '��Ш���͹'+month&mm+' '+yy
			@4,5 SAY '�١��ͧ������� ' GET correct PICT '!' DEFA 'Y'
			READ
			IF correct $ 'Y��'
				DO CallData WITH drive,fileuse
			ELSE
				=ALARM1()
				WAIT WIND NOWA '¡��ԡ�����ͧ���'
			ENDI
			RELE WIND ask
		ENDI
	ENDI
ENDI
RELE WIND rp_govn

FUNC SHOWICD
PARA _showicd
IF ISDIGIT(_showicd) .OR. LEFT(_showicd,1)='*'
	RETU IIF(ISDIGIT(_showicd),'*'+_showicd+' '+SPAC(14),_showicd+SPAC(15))
ELSE
	_showicd= IIF(LEFT(_showicd,1)='#',_showicd,LEFT(_showicd,3)+;
	IIF(ISDIGIT(SUBS(_showicd,4,1)),'.','')+SUBS(_showicd,4))
	RETU _showicd+SPAC(20-LEN(_showicd))
ENDI

FUNC IsOne
PARA _para
RETU IIF(_para = '1', 1, 0)

FUNC IsTwo
PARA _para
RETU IIF(_para = '2', 1, 0)

FUNC DIAGGr
PARA _diag
PRIVATE mret
EXTERNAL ARRAY diagmin,diagmax
mret = '  '
FOR i = 1 TO 14
	mret = IIF(BETWEEN(_diag,diagmin[i],diagmax[i]),STR(i,2),mret)
	IF ! EMPTY(mret)
		i = 16
		mret = IIF(EMPTY(_diag),'  ',mret)
	ENDI
NEXT
RETU mret

FUNC AgeGr
PARA _agetype,_age
PRIVATE mret,magemintype,mage,magemaxtype,magemax,magemin,magetype
EXTERNAL ARRAY agemin,agemax,agemintype,agemaxtype
mret = '  '
FOR i = 1 TO 14
	magetype = IIF(_agetype = '1','3',IIF(_agetype = '3','1',_agetype))
	magemintype = IIF(agemintype[i] = '1','3',IIF(agemintype[i] = '3','1',agemintype[i]))
	magemaxtype = IIF(agemaxtype[i] = '1','3',IIF(agemaxtype[i] = '3','1',agemaxtype[i]))
	mage = STR(_age,2)
	magemin = STR(agemin[i],2)
	magemax = STR(agemax[i],2)
	mret = IIF(BETWEEN(magetype+mage,magemintype+magemin,magemaxtype+magemax),STR(i,2),mret)
	IF ! EMPTY(mret)
		i = 16
	ENDI
NEXT
RETU mret

FUNC NumDayAdmit
PARA _dateadm,_datedsc
PRIV admdate,dscdate
admdate = BE2CE(RIGHT(_dateadm,2)+'/'+SUBS(_dateadm,5,2)+'/'+LEFT(_dateadm,4))
dscdate = BE2CE(RIGHT(_datedsc,2)+'/'+SUBS(_datedsc,5,2)+'/'+LEFT(_datedsc,4))
RETU STR(dscdate-admdate+1,4)

PROC CHEC_REP
checkfile = startfile
DO WHIL checkfile <= endfile
	yyy = LEFT(checkfile,2)
	mmm = RIGHT(checkfile,2)
	IF ! FILE(_sourcefile+checkfile+'.dbf') .AND. ;
		! FILE(_mostfile+checkfile+'.dbf')
		=TONE(400,4)
		? '��辺�����͹'+month&mmm+' '+FULLYEAR(yyy)
		has_err=.T.               && ��Ǩ�����������ҧ��͹�Ҵ����
		err_mth = err_mth + month&mmm+' '+FullYear(yyy) + ','
		=INKEY(.5)
	ENDI
   checkfile = IIF(mmm = '12', STRZERO(VAL(yyy)+1,2)+'01',yyy+STRZERO(VAL(mmm)+1,2))
ENDD
IF  has_err
	err_mth = LEFT(err_mth,LEN(err_mth)-1)
ENDI
*RELE WIND err_check

FUNC R5DIAG
PARA _diag
PRIVATE mret,num
EXTERNAL ARRAY hospmin,hospmax,hospcode
num = ALEN(hospcode)
mret = SPAC(3)
FOR i = 1 TO num
	IF BETWEEN(_diag,hospmin[i],hospmax[i])
		mret = STR(hospcode[i],lEN(mret))
		i = num + 1
	ENDI
NEXT
RETU mret

FUNC HospZone
PARA _hospsvr
EXTERNAL ARRAY hospmin,hospmax,hospcode
PRIV numhosp,mret,i
numhosp = ALEN(hospcode)
mret = '  '
FOR i = 1 TO numhosp
	IF BETWEEN(_hospsvr,hospmin[i],hospmax[i])
		mret = hospcode[i]
		i = numhosp +1
	ENDI
NEXT
RETU mret
