parameter vname
DIME tempicd(100),tempname(100)
on key label F1 ??chr(7)
set talk off
lastwin=wlast()
oldarea=select()
finish = .F.
do case
case  substr(vname,1,2)='DR' OR substr(vname,1,6)='DOCTOR' OR substr(vname,1,7)='MDOCTOR'
		SELE doctor
		SET FILT TO ! EMPTY(name)
		DO SearchHelp
		m.&vname=DOCTOR
		SET FILT TO
		KEYB CHR(13)
		finish = .T.
case  substr(vname,1,5)='PTTYP'
		SELE social
		SET ORDER TO 1
		DO SearchHelp
		m.&vname=class
		KEYB CHR(13)
		finish = .T.
case substr(vname,1,4)='WARD'
		SELE WARD
		set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		DO SearchHelp
		m.&vname=clinic
		SET FILT TO
		KEYB CHR(13)
		finish = .T.
case substr(vname,1,6)='CLINIC' OR substr(vname,1,7)='MCLINIC'
		SELE clinic
		set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		DO SearchHelp
		m.&vname=clinic
		KEYB CHR(13)
		finish = .T.
case substr(vname,1,3)='DEP'
		SELE WARD
		set filter to subst(clinic,3,1) = ' '  .AND. ! EMPTY(name)
		DO SearchHelp
		m.&vname=clinic
		KEYB CHR(13)
		finish = .T.
case substr(vname,1,6)='HOSPTY'
	vsearch='XXXX'
case substr(vname,1,5)='CAUSE' .OR. substr(vname,1,8)='OUTCAUSE'
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
		RETU
case substr(vname,1,5)='PLACE' .OR. substr(vname,1,8)='OUTPLACE'
		SELE hospcode
		_seek=ProvPop(0,30)
		_seek1=HospType()
		_seek=_seek+STR(_seek1,1)
		=FindHosp(_seek)
		m.&vname=code
		KEYB "{ENTER}"
		on key label F1 do mhelp with varread()
		finish = .T.
otherwise
	vsearch=vname
endcase
SET FILT TO
IF finish
	on key label F1 do mhelp with varread()
	RETU
ENDI
if used('codefile')
	select codefile
else
	sele 25
	dbfuse = ipddir+'lib\codefile'
	use (ipddir+'lib\codefile') order tag code
	dbfuse = ''
endif
if wexist('helpwin')
	activate window helpwin
	clear
else
	define window helpwin from 5,10 to 15,63 shadow none
	define popup helppop from 0,0 to 10,52 margin prompt field rtrim(code)+' '+name color n/w
endif
set order to tag varname

if !seek(substr(vsearch,1,4))
	? chr(7)+chr(7)
	wait '����յ�����͡������к�' window timeout 1
	deactivate window helpwin
	on key label F1 do mhelp with varread()
	select (oldarea)
	return 0
endif
set filter to varname=substr(vsearch,1,4)
set order to tag code
activate window helpwin
choice2=''
@ 0,0 get choice2 popup helppop
keyboard "{HOME}"
READ NOLOCK

x=at(' ',choice2,1)

if substr(vname,1,8)='OPERATE('
	&vname=substr(choice2,1,x-1)
else
	m.&vname=substr(choice2,1,x-1)
endif
clear
release window helpwin

if substr(vname,1,8)='OPERATE('
	show get &vname
else
	show get m.&vname
endif

set filter to
keyboard '{Enter}'
on key label F1 do mhelp with varread()
select (oldarea)
return 1