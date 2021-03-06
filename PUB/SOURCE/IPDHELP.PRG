*************** Procedure IPDHELP *******************
Para _var

on key label F1
on key label PgUp
on key label PgDn
on key label Home
on key label End
on key label F3

_varname=Upper(rtrim(_var))

do case
	case substr(_varname,1,4)='SURG' or _varname='DR'
		SELE doctor
		SET ORDER TO NAME
		SET FILT TO ! EMPTY(name)
		DO SearchHelp
		SET FILT TO
		m.&_varname=DOCTOR
		KEYB CHR(13)
		on key label F1 do ipdhelp with varread()
		RETURN
	case _varname='PTTYP'
		SELE social
		DO SearchHelp
		m.&_varname = class
		KEYB CHR(13)
	case _varname='DCSTATUS'
		do hlpdcs
	case _varname='DCTYPE'
		do hlpdct
	case substr(_varname,1,4)='WARD'
		SELE WARD
		SET ORDER TO TAG name
		set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		DO SearchHelp
		m.&_varname=LEFT(clinic,LEN(m.&_varname))
		SET FILT TO
		SET ORDER TO 1
		KEYB CHR(13)
     CASE LEFT(_var,6)='DXTYPE'
     		DEFINE WIND selehelp FROM 8,20 TO 15,50 SHAD
     		ACTI WIND selehelp
            @ l1,3 SAY '1 = Principal Diagnosis'
            @ 2,3 PROMPT '2 = Comorbidity'
            @ 3,3 PROMPT '3 = Complication'
            @ 4,3 PROMPT '4 = Other'
            MENU TO mchoice
            RELE WIND selehelp
            KEYB STR(mchoice+1,1)
	CASE _VAR='CAUSE' .OR. _VAR='OUTCAUSE'
		?? CHR(7)
		msg2='�Ҩ����˵ؼ��� 2 ��� �� 45  ���������á������ͷӧҹ���'
		define window instr from 1,0 to 11,78 shadow title ;
		'   �������˵ء���觵�ͼ�����  ' COLO bg+/gr+
		activate window instr
		@ 0,1 say '1 = �ԹԨ��� �ѹ�ٵ�����觡�Ѻ'
		@ 1,1 say '2 = ���͡���ѡ�����ͧ�ҡ�մ��������ö���ʹ�ҹ�ؤ��ҡ�'
		@ 2,1 say '3 = ���͡���ѡ�����ͧ�ҡ�մ��������ö����㹴�ҹ����ͧ��� ʶҹ���'
		@ 3,1 say '4 = ���͡���ѡ�����ͧ�ҡ�մ��������ö���ͷ�駢�� 2 ��� 3'
		@ 4,1 say '5 = ���͡���ѡ�����ͧ�ҡ�մ��������ö����㹴�ҹ�Ԫҡ��'
		@ 5,1 say '6 = ���͡���ѡ�����ͧ�ҡ�մ��������ö����������'
		@ 6,1 SAY '7 = ���͡���ѡ�����ͧ�ҡ�մ��������ö���������/�ҵԵ�ͧ���'
		@ 7,1 SAY '8 = ���͡���ѡ�����ͧ�ҡ�մ��������ö�������͵�ͧ������Է��'
		@ 8,Center(msg2) say msg2 color g+/gr+
		wait '' window TIMEOUT 30
		release window instr
	CASE _VAR='PLACE' .OR. _VAR='OUTPLACE'
   		nowwindow = WONTOP()
   		IF ! EMPTY(nowwindow)
   			SAVE SCREE TO prewin
   			DEAC WIND (nowwindow)
   		ENDI
		SELE hospcode
		SET ORDER TO TAG name
		DO POPUP WITH 10,40,12,'hospcode','name'
		IF ! EOF()
			m.&_varname = off_id
		ENDI
		IF ! EMPTY(nowwindow)
			ACTI WIND (nowwindow)
			REST SCREE FROM prewin
		ENDI
		SHOW GETS
   		KEYB CHR(13)
	otherwise
		wait '�ô��ҹ���йӷ���÷Ѵ��ҧ�ش' window timeout 2
endcase

on key label F1 do ipdhelp with varread()
on key label F3 do disprec
*on key label PgUp ?? chr(7)
*on key label PgDn ?? chr(7)
*on key label Home ?? chr(7)
*on key label End ?? chr(7)

***********************************

FUNC HLPDCS
select codefile
set order to 0
LOCA FOR varname='DCST'
DIME dcsname[10]
numdcs = 0
DO WHIL varname = 'DCST'
	numdcs=numdcs+1
	dcsname(numdcs)=LEFT(code,1)+' ' + TRIM(name)+'  '
	skip
ENDD
DIME dcsname(numdcs)
mchoice=0
SET CONF ON
define window showDCt from 5,20 to 15,60 none shadow

activate window showdct
DO WHIL mchoice=0
   @ 0,0 MENU dcsname,numdcs,10
   READ MENU TO mchoice
ENDD
SET CONF OFF
release window showdct
m.&_var=LEFT(dcsname(mchoice),1)
KEYB CHR(13)

************************************
Func HlpDct
************************************
select codefile
SET ORDER TO TAG 0
LOCA FOR varname='DCTY'
DIME dcsname[10]
numdcs = 0
DO WHIL varname = 'DCTY'
	numdcs=numdcs+1
	dcsname(numdcs)=LEFT(code,1)+' ' + TRIM(name)+'  '
	skip
ENDD
DIME dcsname(numdcs)
mchoice=0
SET CONF ON
define window showDCt from 5,20 to 15,60 none shadow

activate window showdct
DO WHIL mchoice=0
   @ 0,0 MENU dcsname,numdcs,10
   READ MENU TO mchoice
ENDD
SET CONF OFF
release window showdct
m.&_var=LEFT(dcsname(mchoice),1)
KEYB CHR(13)

********************************
