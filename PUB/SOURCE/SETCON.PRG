************************************************************************
PRIV UserName,UserRight,_ret,pp,_mkey,goon,goon1
userright = GetUser()
*SELE 0
*USE (patientdir+'user') ORDER TAG name
goon1 = .T.
IF 'SUP       ' # userright
	RETU
ENDI
DEFI WIND setconfig FROM 3,1 TO 20,78 SHAD
ACTI WIND setconfig
STORE LEFT(patientdir+SPACE(30),30) TO patientdir
STORE LEFT(codedir+SPACE(30),30) TO codedir
STORE LEFT(tempdir+SPACE(30),30) TO tempdir
STORE LEFT(ipddir+SPACE(30),30) TO ipddir
STORE LEFT(opddir+SPACE(30),30) TO opddir
STORE LEFT(pharmdir+SPACE(30),30) TO pharmdir
STORE LEFT(notprintrx+SPACE(30),30) TO notprintrx
STORE LEFT(Wellbaby+SPACE(30),30) TO Wellbaby
STORE LEFT(billdir+SPACE(30),30) TO billdir
STORE LEFT(isdir+SPACE(30),30) TO isdir
STORE SPACE(30) TO configfile
backupdrive = IIF( EMPTY(backupdrive), ' ', LEFT(backupdrive,1) )

IsER = IIF(er,1,0)
IsStat = IIF(statinput,1,0)
IsBackup = IIF(UPPE(backup) == 'AUDIT',1,0)
IsAdmit = IIF(UPPE(TRIM(Admit))=='DISTRIBUTE',1,0)
isMicrowiz = IIF(UPPE(TRIM(Thaicard))=='MICROWIZ',1,0)
IsPerson = IIF(UPPE(TRIM(Person_id))=='YES',1,0)
IsPres = IIF(UPPE(TRIM(Prescription))=='YES',1,0)
Isnotque = IIF(UPPE(TRIM(notque))=='YES',1,0)

DEFINE WIND setconfig FROM 3,1 TO 20,78 SHAD
ACTI WIND setconfig
@ WROW()-1,Center('������ [Esc] �������������') SAY '������ [Esc] �������������'
@ 1,3 SAY 'Directory ��������ѡ        ' GET patientdir MESS ;
'������ Drive ��� Directory ������ Patient1 ����'
@ 2,3 SAY 'Directory �����ż����¹͡  ' GET opddir MESS ;
'������ Drive ��� Directory ����红����š���ԹԨ��¼����¹͡'
@ 3,3 SAY 'Directory �����ż������   ' GET ipddir MESS ;
'������ Drive ��� Directory ����红����š���ԹԨ��¼������'
@ 4,3 SAY 'Directory ������������    ' GET pharmdir MESS ;
'������ Drive ��� Directory ����红����������Ҽ����¹͡'
@ 5,3 SAY 'Directory ������������     ' GET codedir MESS ;
'������ Drive ��� Directory ������������� Doctor,Address ����'
@ 6,3 SAY 'Directory ����� BILLING   ' GET billdir MESS ;
'������ Drive ��� Directory �ͧ����� Billing'
@ 7,3 SAY 'Directory ����� IS        ' GET isdir MESS ;
'������ Drive ��� Directory �ͧ����� IS'
@ 8,3 SAY 'Directory �����Ū��Ǥ���    ' GET tempdir MESS ;
'������ Drive ��� Directory �������Ѻ��¹�����Ū��Ǥ���������ա�û����ż�'
@ 9,3 SAY '��չԤ����������������   ' GET notprintrx MESS ;
'������ʤ�չԤ�������ͧ��þ���������ҵ����������ͧ���� , �� 011,024'
@ 10,3 SAY '��չԤ�آ�Ҿ�硴�          ' GET Wellbaby MESS ;
'������� Well baby ��չԤ�����������ͧ���� , �� 011,024'
@ 11,3 GET Iser FUNC '*C ��ͧ�ѵù͡����' MESS ;
'����ͧ�ѵù͡���ҷ���ա���ԡ���������͹'
@ 11,32 GET IsStat FUNC '*C �׹��������ŧ����ԹԨ���' MESS ;
'������ա��ŧ����ԹԨ��¼����¹͡ �зӡ�ä׹�������ѵ��ѵ�' && WHEN Checkiser()
@ 12,3 GET Isbackup FUNC '*C �ա�����ͧ������' MESS ;
'�ա�úѹ�֡�����ŷ���ա����� ���ͨзӡ�����ͧ�������ѵ��ѵ�'
@ 12,32 GET isadmit FUNC '*C �Ѻ�������' MESS ;
'�����ͧ��Ǩ�����¹͡����öŧ����¹�Ѻ���������'
*@ 11,3 GET Isperson FUNC '*C �Ţ���ѵû�ЪҪ�' MESS ;
*'�ա�úѹ�֡�Ţ���ѵû�ЪҪ� 13 ��ѡ����'
@ 13,3 GET Ispres FUNC '*C ����������Ҽ�����' MESS ;
'�����ͧ�ѵ�����ö���������������ͷӡ�úѹ�֡�������������蹺ѵ������'
@ 13,32 GET Isnotque FUNC '*C ����ͧ�����Ҥ�����������' MESS ;
'����ͧ��������������� (੾�������Ҽ��������) ��������㹤��'
@ 14,3 SAY '���ͧ�����ŷ���������� Drive  ' GET backupdrive MESS ;
'������ Drive ���������ͧ�������ѵ��ѵ� ' PICT '!'
@ 15,3 SAY '�纵�ǵԴ����������     ' GET configfile MESS ;
'������ Drive\Directory\������� �����纵���к� ���Ẻ�ͧ DOS'
READ NOLOCK CYCLE
patientdir = ALLTRIM(patientdir)
patientdir = IIF(EMPTY(patientdir), '\pub\', patientdir)
patientdir = IIF(RIGHT(patientdir,1)#'\', patientdir+'\', patientdir)
opddir = ALLTRIM(opddir)
opddir = IIF(EMPTY(opddir), '\opd\', opddir)
opddir = IIF(RIGHT(opddir,1)#'\', opddir+'\', opddir)
ipddir = ALLTRIM(ipddir)
ipddir = IIF(EMPTY(ipddir), '\ipd\', ipddir)
ipddir = IIF(RIGHT(ipddir,1)#'\', ipddir+'\', ipddir)
codedir = ALLTRIM(codedir)
codedir = IIF(EMPTY(codedir), '\pub\', codedir)
codedir = IIF(RIGHT(codedir,1)#'\', codedir+'\', codedir)
tempdir = ALLTRIM(tempdir)
tempdir = IIF(! EMPTY(tempdir) .AND. RIGHT(tempdir,1)#'\', tempdir+'\', tempdir)
pharmdir = ALLTRIM(pharmdir)
pharmdir = IIF(EMPTY(pharmdir), '\pharm\', pharmdir)
pharmdir = IIF(RIGHT(pharmdir,1)#'\', pharmdir+'\', pharmdir)
billdir = ALLTRIM(billdir)
billdir = IIF(! EMPTY(billdir) .AND. RIGHT(billdir,1)#'\', billdir+'\', billdir)
isdir = ALLTRIM(isdir)
isdir = IIF(! EMPTY(isdir) .AND. RIGHT(isdir,1)#'\', isdir+'\', isdir)
notprintrx = ALLTRIM(notprintrx)
wellbaby = ALLTRIM(wellbaby)
work1 = IIF( isstat = 0, '', 'STAT')
work2 = IIF( iser = 0, '', 'ER')
statinput = isstat = 1
er = iser = 1
backup = IIF(isbackup=0, ' ', 'AUDIT')
admit = IIF(isadmit=0, ' ', 'DISTRIBUTE')
prescription = IIF(ispres=0, 'NO', 'YES')
printpx = prescription = 'YES'
*person_id = IIF(isperson=0, 'NO', 'YES')
thaicard = IIF(ismicrowiz=0, ' ', 'MICROWIZ')
notque = IIF(isnotque=0, 'NO', 'YES')
backupdrive = IIF( EMPTY(backupdrive), '',backupdrive+':')
configfile = IIF( EMPTY(configfile),'stat2.cfg',configfile)
mat = AT('.',configfile)
configfile = IIF( mat=0, TRIM(configfile)+'.cfg', TRIM(configfile) )
towrite = 'Y'
IF FILE(configfile)
	=ALARM1()
	CLEA
	@ WROW()/2,10 SAY '��� ' +configfile+ ' ����������'
	@ ROW()+2,10 SAY '��ͧ�����¹�Ѻ�������  ' GET towrite PICT '!'
	READ NOLOCK
ENDI
IF towrite = 'Y'
	fhandle = FCREA(configfile)
	IF fhandle > -1
		=FPUTS(fhandle,'patientdir = '+patientdir)
		=FPUTS(fhandle,'opddir = '+opddir)
		=FPUTS(fhandle,'ipddir = '+ipddir)
		=FPUTS(fhandle,'codedir = '+codedir)
		=FPUTS(fhandle,'tempdir = '+tempdir)
		=FPUTS(fhandle,'pharmdir = '+pharmdir)
		=FPUTS(fhandle,'billdir = '+billdir)
		=FPUTS(fhandle,'isdir = '+isdir)
		=FPUTS(fhandle,'notprintrx = '+notprintrx)
		=FPUTS(fhandle,'wellbaby = '+wellbaby)
		=FPUTS(fhandle,'workstation = '+work1)
		=FPUTS(fhandle,'backup = '+backup)
		=FPUTS(fhandle,'workstation = '+work2)
		=FPUTS(fhandle,'admit = '+admit)
		=FPUTS(fhandle,'prescription = '+prescription)
*		=FPUTS(fhandle,'person_id = '+person_id)
		=FPUTS(fhandle,'notque = '+notque)
		=FPUTS(fhandle,'thaicard = '+thaicard)
		=FPUTS(fhandle,'backupdrive = '+backupdrive)
		=FCLOSE(fhandle)
	ELSE
		=ALARM1()
		WAIT WIND NOWA '�������ö���ҧ��� '+configfile
	ENDI
ENDI
CLEA
=ALARM1()
@ 1,Center('����͹') SAY '����͹'
?
?
? '   ','�к��ͧ����ͧ���������¹仵������ҹ��˹�����'
?
IF towrite # 'Y'
	? '   ','�к�������¹੾��㹡�÷ӧҹ����'
	? '   ','������͡�ҡ�������С�Ѻ�ҷ����������������'
ELSE
	IF fhandle > -1
		? '   ','�����Ţͧ�к�����¹����������� ' + configfile +' ���º��������'
		exefile = SYS(16,1)
		IF UPPE(configfile) == 'STAT2.CFG' .OR. UPPE(configfile) == ;
		LEFT(exefile, AT('.',exefile))+'CFG'
			? '   ','����ͷ�ҹ������������ա���� �к������仵������ҹ�������'
		ELSE
			? '   ','�ô���ѧ ! ����ͷ�ҹ�͡�ҡ����� STAT2 '
			? '   ','��͹������� STAT2 ���駵��� ��ҹ�е�ͧ������'
			?'   ','        SET configfile=' + configfile
			?'   ','� DOS prompt ���� ������� AUTOEXEC.BAT'
			?'   ','�ԩй�鹷�ҹ��������к��������ҹ��ͧ���'
		ENDI
	ENDI
ENDI
@ WROW() -1,Center('���������á������ͷӧҹ���') SAY '���������á������ͷӧҹ���'
=INKEY(0)
RELE WIND setconfig
audit = backup = 'AUDIT'
F_STATION=workstation='FILE'
nottoque = UPPE(notque) = 'YES'

FUNC Checkiser
IF iser =1
	Isstat = 0
	SHOW GETS
	RETU .F.
ENDI