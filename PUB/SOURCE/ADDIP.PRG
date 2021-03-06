************************* proc ADDIP*****************
***							�������
***				����� ��ǹ��� 2 ����Ѻ�ѹ�֡�����ż������
***				   �����ҹ ���¡�ҡ����� IPD
***						ALFA VERSION 1.5
***							���Ҥ� 2536
****************************              ******************
***
#define numdaydisc 7
#define numdiag 12
#define numoper 12
SET ESCA OFF
EXTERNAL ARRAY MenuMess,Tmonth

on key label F1 do ipdhelp with varread()
*on key label F3 do disprec
*on key label PgUp ?? chr(7)
*on key label PgDn ?? Chr(7)
*on key label Home ?? chr(7)
*on key label End ?? chr(7)
SET DATE BRITISH
my=SUBS(DTOC(DATE()),4,2)+STR(YEAR(DATE())+543-2500,2)
mm=left(my,2)
yy=RIGHT(my,2)
col=Center(mhosp_name)
diag0='adfe'
oper0='adfe'
@ 0,col SAY mhosp_name color gr+/
col=center('�ѹ�֡�����š���ѡ�Ҽ������')
@ 1,col say '�ѹ�֡�����š���ѡ�Ҽ������'

@ 3,0 clear to 20,79
@ 22,0 clear to 23,79
@ 3,0

*do openfile

@ 3,2 say 'AN'
@ 3,11 say '/'
@ 3,15 say 'HN'
@ 3,26 say '����'
@ 3,68 say '����'
@ 4,0 say replicate('-',80)
@ 5,1 say '�Է�ԡ���ѡ��'
@ 5,18 say 'Ward : '
@ 5,29 say '�ѹ admit'
@ 5,47 say '�ѹ D/C'
@ 5,63 say '���� D/C'
@ 6,1 say '�ä 1'
@ 6,70 SAY '������'
@ 7,1 say '    2'
@ 7,70 SAY '������'
@ 8,1 say '    3'
@ 8,70 SAY '������'
@ 9,1 say '    4'
@ 9,70 SAY '������'
@ 10,1 say '��� 1'
@ 11,1 say '�����           ����        ����           ����         �����'
@ 12,1 say '   2'
@ 13,1 say '�����           ����        ����           ����         �����'
@ 14,1 say '   3'
@ 15,1 say '�����           ����        ����           ����         �����'
@ 16,1 say '   4'
@ 17,1 say '�����           ����        ����           ����         �����'
@ 18,0 say replicate('-',80)
@ 19,2 say '��. Admit'
@ 19,27 say '��. (��á�á�Դ ��������˹ѡ����ͤ�ʹ)'
@ 20,2 say 'D/C Status'
@ 20,17 say 'D/C Type'
@ 20,30 say 'ᾷ��'
*@ 21,65 say '��ùѴ'
@ 22,12 say '              [ESC] = ������鹡��ŧ������'

dimension smenu(3)
smenu(1)=padc('�ѹ�֡��¡�õ���',24,' ')
smenu(3)=padc('¡��ԡ��¡�ù��',24,' ')
smenu(2)=padc('���',24,' ')
sitem=3
select INP
scatter memvar blank
select patient1
scatter memvar blank
select iptrana
scatter memvar blank
SELE death_yr
SCAT TO death BLAN
m.annum=space(5)
m.anyy=RIGHT(STR(YEAR(DATE())+543),2)
m.hn=space(7)
m.ward=space(3)
m.name=space(36)
m.age=space(5)
m.DATEA='  /  /  '
m.DATED='  /  /  '
m.TIMED=space(4)
m.pt=space(2)
m.app='N'
m.adm_w=0.000
store space(60) to mdiag0,moper0
FOR i = 1 TO numdiag
	x = LTRIM(STR(i))
	store space(60) to diag&x, mdiag&x
	STORE ' ' TO m.dxtype&x
NEXT
FOR i = 1 TO numoper
	x = LTRIM(STR(i))
	store space(6) to surg&x
	store space(60) to oper&x, moper&x
	STORE SPACE(4) TO timein&x, timeout&x
	STORE SPACE(25) TO msurg&x
	store '  /  /  ' to dateop&x, dateout&x
NEXT
store ' ' to dcstatus, dctype
store space(25) to mdr
STOR SPACE(2) TO outcause
STOR SPACE(4) TO outtime
STOR SPACE(5) TO outplace
STOR SPACE(25) TO referoutplace
STOR '1' TO m.dxtype1
*Do initvar

******** Entry loop *********
do while .t.
	UNLOCK ALL
	FLUSH
	entrydateadm = .F.
	@ 3,6 get m.annum picture '99999' valid ChkAN(m.annum) message '��͹ AN 5 ��ѡ'
	@ 3,12 get m.anyy picture '99' valid CheckAN(m.annum,m.anyy) message '�վط��ѡ�Ҫ'
	@ 3,18 get m.hn picture '9999999' WHEN entrydateadm VALID ShowHn(m.hn) &&disable COLO ,,,,,,,,,gr+
	@ 3,31 get m.name disable  COLO ,,,,,,,,,gr+
	@ 3,73 get m.age disable COLO ,,,,,,,,,gr+
	@ 5,14 get m.pttyp picture '99' message '�Է�ԡ���ѡ��    F1 = List'
	@ 5,25 get m.ward_dsc picture '999' message 'Ward �ش���¡�͹�͡�ҡ�ç��Һ��  F1=List'
	@ 5,38 get m.datea WHEN entrydateadm PICT '99/99/99' VALID TrueDATE(m.datea) && disable COLO ,,,,,,,,,gr+
	@ 5,54 get m.dated pict '99/99/99' valid truedate(m.dated) and BETWEEN(be2ce(m.dated),be2ce(m.datea),date()) ;
		mess '����ѹ����˹���'
	@ 5,72 get m.timed pict '@R ##:##' VALID CheckTime(m.timed) message '������ҷ���˹���'
	@ 6,7 get m.diag1 WHEN EntryICD(m.diag0,m.diag1) VALID CheckICD(m.diag1) ;
		MESS '��������ä���ͪ����ä��� 1' SIZE 1,20
	@ 6,7 get m.mdiag1	disable color ,,,,,,,,,gr+
	@ 6,77 GET m.dxtype1 DISA color ,,,,,,,,,gr+
	@ 7,7 get m.diag2 WHEN EntryICD(m.diag1,m.diag2) VALID CheckICD(m.diag2) ;
		MESS '��������ä���ͪ����ä��� 2' SIZE 1,20
	@ 7,7 get m.mdiag2	disable color ,,,,,,,,,gr+
	@ 7,77 get m.dxtype2 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype2, diag2);
		MESS '������������ 2 = Comorbidity 3 = Complication ���� 4 = Other'
	@ 8,7 get m.diag3 WHEN EntryICD(m.diag2,m.diag3) VALID CheckICD(m.diag3) ;
		MESS '��������ä���ͪ����ä��� 3' SIZE 1,20
	@ 8,7 get m.mdiag3	disable color ,,,,,,,,,gr+
	@ 8,77 get m.dxtype3 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype3, diag3);
		MESS '������������ 2 = Comorbidity 3 = Complication ���� 4 = Other'
	@ 9,7 get m.diag4 WHEN EntryICD(m.diag3,m.diag4) VALID CheckICD(m.diag4) ;
		MESS '��������ä���ͪ����ä��� 4' SIZE 1,20
	@ 9,7 get m.mdiag4 disable color ,,,,,,,,,gr+ message ' '
	@ 9,77 get m.dxtype4 pict '9' WHEN CheckFirst() VALID CheckDxtype(m.dxtype4, diag4);
		MESS '������������ 2 = Comorbidity 3 = Complication ���� 4 = Other'
	@ 10,7 get m.oper1 WHEN EntryICD(m.oper0,m.oper1) VALID CheckICD(m.oper1) ;
		MESS '������ʼ�ҵѴ���ͪ��͡�ü�ҵѴ��� 1' SIZE 1,20
	@ 10,7 get m.moper1 disable color ,,,,,,,,,gr+ message ' '
	@ 11,8 get m.dateop1 when Entrydateop(m.oper1) picture '##/##/##' ;
	valid Checkdateop(m.dateop1)
	@ 11,23 GET m.timein1 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop1,2)) VALID CheckTime(m.timein1)
	@ 11,36 GET m.dateout1 WHEN ! EMPTY(LEFT(m.dateop1,2)) PICT '##/##/##' ;
	valid Checkdateop(m.dateout1,m.dateop1)
	@ 11,50 GET m.timeout1 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop1,2)) VALID Checktimeout(m.dateop1,m.timein1,m.dateout1,m.timeout1)
	@ 11,68 get m.surg1 when EntryDateOP(m.oper1) picture '######' valid CheckDoctor(m.surg1,m.msurg1) message '����ᾷ�����ҵѴ  F1=List'
	@ 11,68 get msurg1 defa space(25) disable color ,,,,,,,,,gr+
	@ 12,7 get m.oper2 WHEN EntryICD(m.oper1,m.oper2) VALID CheckICD(m.oper2) ;
		MESS '������ʼ�ҵѴ���ͪ��͡�ü�ҵѴ��� 2' SIZE 1,20
	@ 12,7 get m.moper2 disable color ,,,,,,,,,gr+ message ' '
	@ 13,8 get m.dateop2 when Entrydateop(m.oper2) picture '##/##/##' ;
	valid Checkdateop(m.dateop2)
	@ 13,23 GET m.timein2 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop2,2)) VALID CheckTime(m.timein2)
	@ 13,36 GET m.dateout2 WHEN ! EMPTY(LEFT(m.dateop2,2)) PICT '##/##/##' ;
	valid Checkdateop(m.dateout2,m.dateop2)
	@ 13,50 GET m.timeout2 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop2,2)) VALID Checktimeout(m.dateop2,m.timein2,m.dateout2,m.timeout2)
	@ 13,68 get m.surg2 when EntryDateOP(m.oper2) picture '######' valid CheckDoctor(m.surg2,m.msurg2) message '����ᾷ�����ҵѴ  F1=List'
	@ 13,68 get msurg2 defa space(25) disable color ,,,,,,,,,gr+
	@ 14,7 get m.oper3 WHEN EntryICD(m.oper2,m.oper3) VALID CheckICD(m.oper3) ;
		MESS '������ʼ�ҵѴ���ͪ��͡�ü�ҵѴ��� 3' SIZE 1,20
	@ 14,7 get m.moper3 disable color ,,,,,,,,,gr+ message ' '
	@ 15,8 get m.dateop3 when Entrydateop(m.oper3) picture '##/##/##' ;
	valid Checkdateop(m.dateop3)
	@ 15,23 GET m.timein3 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop3,2)) VALID CheckTime(m.timein3)
	@ 15,36 GET m.dateout3 WHEN ! EMPTY(LEFT(m.dateop3,2)) PICT '##/##/##' ;
	valid Checkdateop(m.dateout3,m.dateop3)
	@ 15,50 GET m.timeout3 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop3,2)) VALID Checktimeout(m.dateop3,m.timein3,m.dateout3,m.timeout3)
	@ 15,68 get m.surg3 when EntryDateOP(m.oper3) picture '######' valid CheckDoctor(m.surg3,m.msurg3) message '����ᾷ�����ҵѴ  F1=List'
	@ 15,68 get msurg3 defa space(25) disable color ,,,,,,,,,gr+
	@ 16,7 get m.oper4 WHEN EntryICD(m.oper3,m.oper4) VALID CheckICD(m.oper4) ;
		MESS '������ʼ�ҵѴ���ͪ��͡�ü�ҵѴ��� 4' SIZE 1,20
	@ 16,7 get m.moper4 disable color ,,,,,,,,,gr+ message ' '
	@ 17,8 get m.dateop4 when Entrydateop(m.oper4) picture '##/##/##' ;
	valid Checkdateop(m.dateop4)
	@ 17,23 GET m.timein4 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop4,2)) VALID CheckTime(m.timein4)
	@ 17,36 GET m.dateout4 WHEN ! EMPTY(LEFT(m.dateop4,2)) PICT '##/##/##' ;
	valid Checkdateop(m.dateout4,m.dateop4)
	@ 17,50 GET m.timeout4 PICT '@R ##:##' WHEN ! EMPTY(LEFT(m.dateop4,2)) VALID Checktimeout(m.dateop4,m.timein4,m.dateout4,m.timeout4)
	@ 17,68 get m.surg4 when EntryDateOP(m.oper4) picture '######' ;
	valid CheckDoctor(m.surg4,m.msurg4) message '����ᾷ�����ҵѴ  F1=List'
	@ 17,68 get msurg4 defa space(25) disable color ,,,,,,,,,gr+
	@ 19,12 get m.adm_w valid ChkAdm_W() mess '�����˹ѡ�繡��š���'
	@ 20,13 get m.dcstatus picture '9' WHEN ClearOper() valid ChkDeath(m.dcstatus) message 'ʶҹ� ��˹���       F1 = List'
	@ 20,26 get m.dctype picture '9' valid v_refer() message '�ѡɳС�è�˹���      F1 = List'
	@ 20,37 get m.dr WHEN InputDoctor(m.dr) VALID CheckDoctor(m.dr,m.mdr) ;
	MESS '�������ᾷ����ӡ���ѡ�Ҽ�����    F1 = List'
	@ 20,45 GET m.mdr defa space(20) DISA COLO ,,,,,,,,,gr+
	READ NOLOCK
	IF LASTKEY() = 27
		wait 'Terminate and exit' window timeout 1
		exit
	ENDI
	define window ask from 22,0 to 24,79 shadow
	activate window ask
	for i=1 to sitem
		@ 0,(i-1)*25+2 prompt smenu(i)
	endfor
	menu to SChoice
	do case
		CASE SChoice=0 .OR. Schoice = 3
			WAIT WIND NOWA '¡��ԡ��úѹ�֡�����ż����� AN '+m.annum+'-'+m.anyy
			DO initvar
		case SChoice=1
			IF Empty(diag1)
				?? chr(7)
				wait '��ͧ�����ҧ���� 1 Diagnosis' window timeout 1
				_curobj=objnum(diag1)
			ELSE
				do saveip
				DEFINE WIND IPDChrg FROM 10,10 TO 14,70 SHAD
				ACTI WIND IPDChrg
				goon1='N'
				CLEA
				@ 1,3 SAY '��ͧ��û�͹�����Ť��������������  ' GET goon1 PICT '!'
				READ
				RELE WIND
				IF goon1='Y'
					DO INCHRG WITH .T.
				ENDI
	   			do initvar
			ENDI
	endcase
	release window ask

enddo
*wait '' window
on key label F1
*on key label F3
on key label PgUp
on key label PgDn
on key label Home
on key label End
*Close database
return

*******************************
Function ChkAN
Para _an
_an=padl(alltrim(_an),5,'0')
m.man=_an
IF _an = '00000'
	RETU TO IPD
ELSE
	@ 3,6 say m.man
ENDI
return

***********************************
	Function ChkAdm_W
***********************************
	dAdmit = BE2CE(m.datea)
	dBirth = Lookup(Patient1.BirthDay,alltrim(m.HN),Patient1.HN,"HN")
	IF ! Empty(dBirth) and ! Empty(dAdmit) and ;
		dBirth > gomonth(dAdmit,-12) and Empty(m.Adm_W)
		?? Chr(7)
		WAIT WIND " ���������ص�ӡ��� 1 �� ��ͧ�ѹ�֡���˹ѡ�á�Ѻ���� " NOWAIT
		_Curobj = ObjNum(m.Adm_W)
		Return
	ELSE
		IF m.Adm_W > 500
			?? Chr(7)
			WAIT WIND " �èй��˹ѡ�ҡ��Ҵ��� �ͧ��Ǩ�ͺ�ա���� " NOWAIT
			_Curobj = ObjNum(m.Adm_W)
			Return
		ENDI
	ENDI

***********************************
	Function CheckAN
***********************************
Para _an, _anyy
private XAN
XAN=_anyy+padl(alltrim(_an),5,'0')
SELE admyear	&& ��Ǩ�ͺ������������Ź�������ѧ
				&& �ж������������纨���������ǡѺ�Ţ���������
*IF _anyy # yy	&& ��Ǩ�ͺ����Դ������١��ͧ
	infile=ipddir+'data\ADM'+_anyy
	USE
	dbfuse = infile
	IF ! FILE(infile+'.dbf')
		CREATE TABLE (infile) ;
		(HN C(7),AN C(7),PTTYP C(2),DEP C(2),WARD_ADM C(3),DATEADM D,;
		TIMEADM C(4),WARD_NOW C(3),DATE_NOW D,TIME_NOW C(4),BED_NO C(2),;
		BED_TYPE C(1),TRANSFER L,DATEDSC D,TIMEDSC C(4),DISC C(4),;
		DR C(6),SENT L,DX_STAT L,PLACE C(5),CAUSE C(2),ONSET N(2),ADM_W N(7,3))
		INDEX ON an TAG an
		INDEX ON hn TAG hn ADDI
	ENDI
	USE (infile) ORDER 1 ALIA ADMyear
*** udc
	newcamefile = .F.
	COPY TO temp STRU EXTE
	USE temp
	LOCA FOR field_name = 'ADM_W'
	IF EOF() OR field_type ='C'
		WAIT WIND '�ç���ҧ��������� ' +infile +' ���١��ͧ' + CHR(13) + ;
		'��س�����ç���ҧ�����͹ �������� ���ا�ѡ���к�' + CHR(13) + ;
		'�ԩй���Ҩ�Դ�����Դ��Ҵ㹡�÷ӧҹ' + CHR(13) + ;
		'...������� � ���ͷӧҹ���...' TIME 100
	ENDI
	USE
	DELE FILE temp.dbf
	USE (infile) ORDER 1 ALIA ADMyear && open amdyy again
*** udc
	dbfuse = ''
*ENDI
*** udc
IF !seek(XAN)
	anyy = Val(_anyy)+1
	infile=ipddir+'data\ADM'+Alltrim(Str(anyy))
	USE
	dbfuse = infile
	IF ! FILE(infile+'.dbf')
		CREATE TABLE (infile) ;
		(HN C(7),AN C(7),PTTYP C(2),DEP C(2),WARD_ADM C(3),DATEADM D,;
		TIMEADM C(4),WARD_NOW C(3),DATE_NOW D,TIME_NOW C(4),BED_NO C(2),;
		BED_TYPE C(1),TRANSFER L,DATEDSC D,TIMEDSC C(4),DISC C(4),;
		DR C(6),SENT L,DX_STAT L,PLACE C(5),CAUSE C(2),ONSET N(2),ADM_W N(7,3))
		INDEX ON an TAG an
		INDEX ON hn TAG hn ADDI
	ENDI
	USE (infile) ORDER 1 ALIA ADMyear
	dbfuse = ''
ENDI
*** udc
IF seek(XAN)		&& ��ҵ�Ǩ�ͺ�����Ţ��������㹹�������� ADMyy
	?? chr(7)		&& �����͹حҵ���ŧ�����ū��
	wait '�բ����� AN �������  ��ҵ�ͧ������ ������͡��䢨ҡ��¡����ѡ' window timeout 2
	_curobj=1
	m.anyy=space(5)
else
	select iptrana
	if !seek(XAN)
		?? chr(7)
		wait '��辺 AN ������� Admit' window NOWA
		entrydateadm = .T.
	ENDI
	mdoc=m.dr
	scatter memvar
	m.AN=XAN
	m.hn=HN
	m.ward_dsc=WARD_NOW
	m.DATEA=DATEADM
	m.DATED=IIF(! EMPTY(datedsc),DATEDSC,m.dated)
	m.TIMED=m.TIMED
	m.dr=mdoc
	m.pt=PTTYP
	m.dcstatus=IIF( ! EMPTY(disc),substr(disc,1,1),m.dcstatus)
	m.dctype=IIF( ! EMPTY(disc),substr(disc,2,1),m.dctype)

	select patient1
	set order to tag HN
	seek m.hn
	scatter memvar
	m.hn = iptrana.hn
	m.mname=NAME
	m.age=NOWAGE(BIRTHDAY)
	m.datea=ce2be(dateadm,2)
	m.dated=IIF( ! EMPTY(datedsc),ce2be(datedsc,2),m.dated)
	m.timed=m.timed
	show gets

endif
m.an = xan

*******************************
Procedure initvar

Select INP
scatter memvar blank
select patient1
scatter memvar blank
select iptrana
scatter memvar blank
SELE death_yr
SCAT TO death BLAN
m.annum=space(5)
m.anyy=RIGHT(STR(YEAR(DATE())+543),2)
m.hn=space(7)
m.ward=space(3)
m.name=space(36)
m.age=space(5)
m.DATEA='  /  /  '
m.DATED='  /  /  '
m.TIMED=space(4)
m.ADM_W=0.000
m.pt=space(2)
m.app='N'
store space(60) to mdiag0,moper0
FOR i = 1 TO numdiag
	x = LTRIM(STR(i))
	store space(60) to diag&x, mdiag&x
NEXT
FOR i = 1 TO numoper
	x = LTRIM(STR(i))
	store space(6) to surg&x
	store space(60) to oper&x, moper&x
	STORE SPACE(4) TO timein&x, timeout&x
	STORE SPACE(25) TO msurg&x
	store '  /  /  ' to dateop&x, dateout&x
NEXT
store ' ' to dcstatus, dctype, dxtype2, dxtype3, dxtype4
store space(25) to mdr
STOR SPACE(2) TO outcause
STOR SPACE(4) TO outtime
STOR SPACE(5) TO outplace
STOR SPACE(25) TO referoutplace
STOR '1' TO m.dxtype1

*****************************
Func V_mon
Para _mm

if !between(val(_mm),1,12)
	??chr(7)
	wait 'Invalid input' window timeout 0.5
	_curobj=_curobj
else
	@ 1,13 say tmonth(val(_mm))+' '
endif

*****************************
Procedure SaveIP
*****************************

yy1 = RIGHT(m.dated,2)
mm1 = SUBS(m.dated,4,2)
*IF yy1+mm1 # yy+mm		&& ��Ǩ�ͺ��͹/�� ����Դ������١��ͧ
	yy = yy1
	mm = mm1
	DO OpenFile1
*ENDI
*	IF LEFT(m.an,2) # yy
		SELE admyear
		dbfuse = ipddir+'\data\adm'+LEFT(m.an,2)
		USE (ipddir+'\data\adm'+LEFT(m.an,2)) ORDER 1 ALIA admyear
		dbfuse = ''
*	ENDI
m.disc=m.dcstatus+m.dctype
m.datedsc=be2ce(m.dated)
m.timedsc=m.timed
m.dateadm=be2ce(m.datea)
m.adm_w=m.adm_w
m.dr=PADBLANK(m.dr,6)
***************************  Update ��������� INyymm
SELE INP
	go top
	DO WHIL ! empty(an) .or. BOF() .OR. ! RLOCK()
		appe blank
	endd
	gather memvar
	FLUSH
	UNLOCK ALL

*************************	�ѹ�֡�����š���ԹԨ���
DIME test[4]
SELE DIAGNOSIS
goon = .t.
n=1
DO WHIL goon .AND. n <= numdiag
	xx = LTRIM(STR(n))
	IF ! EMPTY(m.diag&xx)
		m.DIAG=Con_ICD(m.diag&xx)
		m.dxtype = m.dxtype&xx
		go top
		DO WHIL ! empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
		gather memvar
		FLUSH
		UNLOCK ALL
	ELSE
		goon = .F.
	ENDI
	n = n+1
ENDD
************************	�ѹ�֡�����š�ü�ҵѴ
SELE OPERATION
test[1] = oper1
test[2] = oper2
test[3] = oper3
test[4] = oper4
goon = .T.
n=1
DO WHIL goon .AND. n <= numoper
	x=LTRIM(STR(n))
	IF ! EMPTY(oper&x)
		m.op = IIF(substr(oper&x,1,1)='*',substr(oper&x,2),oper&x)
		m.dateop = be2ce(dateop&x)
		m.timein = m.timein&x
		m.dateout = be2ce(m.dateout&x) && udc ��� m.dateout&x
		m.timeout = m.timeout&x
		m.SURGEON=surg&x
		m.optype = IIF(n = 1, '1','2')
		go top
		DO WHIL ! empty(an) .or. BOF() .OR. ! RLOCK()
			appe blank
		endD
		gather memvar
		FLUSH
		UNLOCK ALL
	ELSE
		goon = .F.
	ENDI
	n = n+1
ENDD
****************************	��Ҥ����� ���ѹ�֡�����š�õ�´���
IF m.dcstatus $ '89'
	SELE death_yr
	GO TOP
	DO WHIL ! EMPTY(an) .OR. BOF() .OR. ! RLOCK()
		APPE BLANK
	ENDD
	GATH FROM death
	FLUSH
	UNLOCK ALL
ENDI

***************************		��Ҥ��� REFER ���ѹ�֡������ REFER
IF m.dctype = '4'
	SELE refer
	m.day = SUBS(m.dated,4,2) + LEFT(m.dated,2)
	m.time = m.outtime
	m.place = m.outplace
	m.cause = m.outcause
	m.diag = m.diag1
	m.ward = m.ward_dsc
	GO TOP
	DO WHIL ISDIGIT(an) .OR. BOF() .OR. ! RLOCK()
		APPE BLANK
	ENDD
	GATH MEMV
	FLUSH
	UNLOCK ALL
ENDI
UNLOCK ALL
*********************************	�ѹ�֡ŧ���� IPTRANA ���ŧ����ԹԨ�������
sele iptrana
SET ORDER TO TAG AN
SEEK m.an
	m.dx_stat=.T.
	IF ! EOF()
		GATHER MEMVAR FIELD dx_stat, disc, datedsc, dr
		FLUSH
		SCAT MEMV
	ENDI
IF ! SEEK(m.an,'admyear')
	INSERT INTO admyear FROM MEMV		&& �碢������������ Admit ��Шӻ�
ENDI
FLUSH

*********************************	��ҡ�Ѻ��ҹ�Թ 7 �ѹ ���ź�������͡
IF datedsc + 7 < date() .AND. ! EOF()
	SCAT TO test BLAN
	GATHER FROM test
	FLUSH
ENDI
**********************************	���ŧ�����ŷ����ͧ�ѵ����׹�������

IF STATINPUT=.T.
	SELE 0
	target=patientdir+'FILE'+yy+'.DBF'
	dbfuse = target
	if !file(target)
		create table (target) (HN C(7), DATE D, TIME C(4), WHO C(6), STATUS L)
	endif
    USE (target) alias  CAMEFILE
    dbfuse = ''
	SELE medrec
	SET ORDER TO TAG hn
*	SET REPROCESS TO 2 SECONDS
	mseek = m.hn
	DO WHIL SEEK(mseek) .AND. ! EMPTY(mseek)
		scat memvar
		m.status = .T.
		insert into  CAMEFILE from memvar
		FLUSH
		scat memvar blank
		gather memvar
		FLUSH
	ENDD

	UNLOCK ALL
	SELE camefile
		use
	SET REPROCESS TO AUTOMATIC

ENDIF
************* �ѹ�֡�ѹ dischrg � RCPD ��� �Է��� � creditpd
*sele RcPd
*SET ORDER TO TAG AN
*SEEK m.an
*m.date = datedsc
*	GATH MEMV FIELD date
*	FLUSH
*	UNLOCK ALL
*
*if !used('social')
*	dbfuse = patientdir + 'social'
*	USE (patientdir + 'social') ORDER 1 IN 0
*ENDI
*
*sele creditpd
*SET ORDER TO TAG AN
*SEEK m.an
*IF SEEK(m.pt,'social')
*	m.Cr_id = social.pttyp
*ENDI
**m.Cr_id = m.pt
*	GATH MEMV FIELD Cr_id
*	FLUSH
*	UNLOCK ALL

=ALARM1()
WAIT '�ѹ�֡����ԹԨ��¼���������º��������' WIND TIME 1

*****************************************
Procedure disprec

on key label F1
on key label F3
set escape off

private all

select INP
set order to
go top
top=recno()
go bottom
bott=recno()
go top
scatter memvar
select iptrana
seek(alltrim(m.AN))
scatter memvar
select patient1
seek(m.HN)
scatter memvar
age=NOWAGE(BIRTHDAY)
man=substr(m.AN,3)+'/'+substr(m.AN,1,2)
my=SUBS(DTOC(DATE()),4,2)+STR(YEAR(DATE())+543-2500,2)
mm=left(my,2)
yy=RIGHT(my,2)

define window test from 5,1 to 13,78 shadow title ' �ͺ��  FILE:IN'+m.yy+m.mm+' '
activate window test
@ 1,2 say 'AN'
@ 1,15 say 'HN'
@ 2,15 say '����'
@ 2,55 say '����'
@ 3,15 say '�ѹ ADMIT'
@ 3,45 say '�ѹ D/C'
@ 4,0 say replicate('-',76)
@ 5,2 say 'F' color w+
@ 5,3 say '=First'
@ 5,18 say 'L' color gr+
@ 5,19 say '=Last'
@ 5,33 say ' PgUp PgDn' color gr+
@ 5,45 say '=Skip'
@ 5,60 say '[Esc]' color gr+
@ 5,65 say '=Exit'

clear typeahead

do while .t.
	@ 1,5 say m.man color gr+
	@ 1,21 say m.hn color gr+
	@ 2,21 say rtrim(m.name) color gr+
	@ 2,63 say m.age color gr+
	@ 3,26 say ce2be(m.DATEADM,2) color gr+
	@ 3,54 say ce2be(m.DATEDSC,2) color gr+
	mkey=inkey(0.5,'H')
	do case
		case mkey=27
			exit
		case mkey=108		&& L
			select INP
			if recno()=bott
				?? chr(7)
				wait 'Already at LAST Record' window timeout 1
				loop
			else
				go bottom
				scatter memvar
				select iptrana
				seek(m.AN)
				scatter memvar
				select patient1
				seek(m.HN)
				scatter memvar
				age=NOWAGE(BIRTHDAY)
				man=substr(m.AN,3)+'/'+substr(m.AN,1,2)
				@ 1,5 say space(7)
				@ 1,21 say space(7)
				@ 2,21 say space(34)
				@ 2,65 say space(10)
				loop
			endif
		case mkey=102		&& F
			select INP
			if recno()=top
				?? chr(7)
				wait 'Already at FIRST Record' window timeout 1
				loop
			else
				go top
				scatter memvar
				select iptrana
				seek(m.AN)
				scatter memvar
				select patient1
				seek(m.HN)
				scatter memvar
				age=NOWAGE(BIRTHDAY)
				man=substr(m.AN,3)+'/'+substr(m.AN,1,2)
				@ 1,5 say space(7)
				@ 1,21 say space(7)
				@ 2,21 say space(34)
				@ 2,65 say space(10)
				loop
			endif
		case mkey=5 or mkey=18		&& Up,PgUp
			select INP
			if recno()=top
				?? chr(7)
				wait 'Already at FIRST Record' window timeout 1
				loop
			else
				skip -1
				scatter memvar
				select iptrana
				seek(m.AN)
				scatter memvar
				select patient1
				seek(m.HN)
				scatter memvar
				age=NOWAGE(BIRTHDAY)
				man=substr(m.AN,3)+'/'+substr(m.AN,1,2)
				@ 1,5 say space(7)
				@ 1,21 say space(7)
				@ 2,21 say space(34)
				@ 2,65 say space(10)
				loop
			endif

		case mkey=24 or mkey=3		&& Dn,PgDn
			select INP
			if recno()=bott
				?? chr(7)
				wait 'Already at LAST Record' window timeout 1
				loop
			else
				skip +1
				scatter memvar
				select iptrana
				seek(m.AN)
				scatter memvar
				select patient1
				seek(m.HN)
				scatter memvar
				age=NOWAGE(BIRTHDAY)
				man=substr(m.AN,3)+'/'+substr(m.AN,1,2)
				@ 1,5 say space(7)
				@ 1,21 say space(7)
				@ 2,21 say space(34)
				@ 2,65 say space(10)
				loop
			endif

	endcase
enddo

select INP
set order to tag AN
release window test

on key label F1 do ipdhelp with varread()
*on key label F3 do disprec