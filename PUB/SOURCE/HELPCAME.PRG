*******************   7 0  P R O C  HELP_CAME  ************************
IF fromhelp
	?? CHR(7)
	WAIT '�س�������¡�ê���������������� �������ö������ [F1] ���ա' WIND NOWA
	RETU
ELSE
	fromhelp = .T.
ENDI
varread=VARREAD()
DIME tempicd(100),tempname(100)
DO CASE
	CASE VARREAD='TEXT_VA3' .OR. varread='CLINIC' ;
	.OR. varread = 'CON_CLINIC'
		SELE clinic
		SET FILT TO RIGHT(clinic,1) # ' ' .AND. ! EMPTY(name)
		SET ORDER TO TAG name
		DO SearchHelp
		&varread=clinic
		SET FILT TO
		SET ORDER TO TAG clinic
		KEYB CHR(13)
	CASE VARREAD='WARD_ADM' .OR. varread = 'DEP'
		SELE WARD
		SET ORDER TO TAG name
		IF varread = 'DEP'
			SET FILTER TO RIGHT(clinic,1) = ' ' .AND. ! EMPTY(name)
		ELSE
			set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		ENDI
		DO SearchHelp
		&varread=LEFT(clinic,LEN(&varread))
		SET FILT TO
		SET ORDER TO TAG clinic
		KEYB CHR(13)
	CASE VARREAD $ 'HOSP_CODE,PLACE,OUTPLACE'
   		nowwindow = WONTOP()
   		IF ! EMPTY(nowwindow)
   			SAVE SCREE TO prewin
   			DEAC WIND (nowwindow)
   		ENDI
		SELE hospcode
		SET ORDER TO TAG name
		DO POPUP WITH 10,40,12,'hospcode','name'
		IF ! EOF()
			&varread = off_id
		ENDI
		IF ! EMPTY(nowwindow)
			ACTI WIND (nowwindow)
			REST SCREE FROM prewin
		ENDI
		SHOW GETS
   		KEYB CHR(13)
	CASE VARREAD='DOCTOR'
		SELE doctor
		SET FILT TO ! EMPTY(name)
		SET ORDER TO TAG name
		DO SearchHelp
		m.doctor=doctor
		SET FILT TO
		SET ORDER TO TAG doctor
		KEYB CHR(13)
	CASE LEFT(VARREAD,4)='MNEW'
		=EPISODE(&VARREAD)	
	CASE VARREAD='RESULT'
		=CheckResult(&VARREAD)	
	CASE VARREAD='REM_C'
		=CheckRem(&VARREAD)	
	CASE VARREAD='SEX'
		?? CHR(7)
		WAIT '����������  1 = ���      2 = ˭ԧ  ' WIND NOWAIT
	CASE VARREAD='PROVINCE'
		?? CHR(7)
		WAIT '����������  1 = �ࢵ�ѧ��Ѵ     0 = �͡ࢵ�ѧ��Ѵ  ' WIND NOWAIT
	CASE VARREAD='PTAGE'
		?? CHR(7)
		WAIT '����������  1XX = ��      2XX = ��͹  3xx = �ѹ ' WIND NOWAIT
	CASE VARREAD='CAUSE' .OR. VARREAD='OUTCAUSE' 
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
     CASE varread = 'SOCIAL'
			DO SearchHelp
			_m=field(1)
			SET ORDER TO 1
			ACTI SCREE
			KEYB &_m
     CASE LEFT(varread,6)='DXTYPE'
     		DEFINE WIND selehelp FROM 8,20 TO 15,50 SHAD
     		ACTI WIND selehelp
            @ 1,3 SAY '1 = Principal Diagnosis'
            @ 2,3 PROMPT '2 = Comorbidity'
            @ 3,3 PROMPT '3 = Complication'
            @ 4,3 PROMPT '4 = Other'
            MENU TO mchoice
            RELE WIND selehelp
            KEYB STR(mchoice+1,1)
	OTHER
		??CHR(7)
		WAIT '��سҴ٤�͸Ժ�º�÷Ѵ�ش���� �͢ͺ�س' WIND NOWA
ENDC
fromhelp = .F.
return 
