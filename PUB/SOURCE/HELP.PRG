********************************************************************************
*  ���������Ѻ�ʴ���ͤ����������������ͼ���顴���� [F1]                       *
*  �´٨ҡ Field ���ӧҹ����㹢�й��                                        *
********************************************************************************
PARA _field,_callprg
PRIVATE PreScr,mchoice
?? chr(7)
*IF Shift_f2
*	WAIT '  [SHIFT+F2] = ��䢢����ż�����  ' WINDOW NOWAIT
*ENDI
IF fromhelp
	WAIT WIND '�س���������������������������' NOWA
	RETU
ENDI
fromhelp = .T.
*SET COLO TO w+/b
DO CASE
	CASE _field='WARD_ADM' .OR. _field = 'PATIENT1(9)'
		IF _field = 'WARD_ADM'
			SELE WARD
			set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		ELSE
			SELE clinic
			SET FILT TO ! EMPTY(name)
		ENDI
		SET ORDER TO TAG name
		= THAIMODE()
		DO SearchHelp
		&_field=clinic
		SET FILT TO
		SET ORDER TO 1
		ACTI SCREE
		KEYB CHR(13)
   CASE _field='CONTACT1(6)' .OR. _field='CONTACT2(6)'
		= THAIMODE()
   		KEYB '  '
   CASE _field='CONTACT1(5)' .OR. _field='CONTACT2(5)'
		= THAIMODE()
      KEYB '00'
   CASE _field='CONTACT1(4)' .OR. _field='CONTACT2(4)'
		= THAIMODE()
      KEYB '00'
   CASE _field='PATIENT1(3)'
      IF RIGHT(_callprg,11)='EDITOLD.PRG'
         DO bottmess WITH ;
'�����;�������ʡ��  �������˹�觪�ͧ������¹��ʡ��  ��������Ţ�������¹͡'
      ELSE
         DO bottmess WITH ;
         '������й��ʡ���¡�ѹ���� 1 ��ͧ��ҧ ��ʹ���,��Фӹ�˹�� ��������Ţ�������¹͡'
      ENDI
   CASE _field='CONTACT1(2)' 
      DO bottmess WITH '����ҹ�Ţ��� ��� ��ж��'
   CASE _field='CONTACT1(3)' .OR. _field='CONTACT2(3)'
      DO bottmess WITH '����������������'
   CASE _field='PATIENT1(6)'
      DO bottmess WITH '��������ôҢͧ������'
   CASE _field='PATIENT1(10)'
      DO bottmess WITH '�����ͺԴҢͧ������'
   CASE _field='PATIENT2(2)'
      DO bottmess WITH '�����ͼ���������ö�Դ�����  1=�������  2=���;��'
   CASE _field='CONTACT2(2)'
      DO bottmess WITH '���������ͧ�����еԴ�����  �.�.�.=��ҹ���ǡѹ'
   CASE _field='PATIENT2(7)'
      DO bottmess WITH '������ʷҧ����������Ţ���Ѿ�� �����'
   CASE _field='MBIRTHDAY'
      DO bottmess WITH '����ѹ��͹���Դ �����վط��ѡ�Ҫ'
   CASE _field='MAGE'
      DO bottmess WITH '��������� �� ���� ��͹/12 ���� �ѹ/365'
	CASE _field = 'RECEIPT'
		SELE user
		SET ORDER TO TAG fullname
		DO POPUP WITH 10,40,12,'user','fullname'
		IF ! EOF()
			&_field = name
		ENDI
		SHOW GETS
		KEYB CHR(13)
   CASE _field $ 'HOSPMAIN,HOSPSUB,HOSP_CODE,PLACE'
   		nowwindow = WONTOP()
   		IF ! EMPTY(nowwindow)
   			SAVE SCREE TO prewin
   			DEAC WIND (nowwindow)
   		ENDI
		SELE hospcode
		SET ORDER TO TAG name
		DO POPUP WITH 10,40,12,'hospcode','name'
		IF ! EOF()
			&_field = off_id
		ENDI
		IF ! EMPTY(nowwindow)
			ACTI WIND (nowwindow)
			REST SCREE FROM prewin
		ENDI
		SHOW GETS
   		KEYB CHR(13)
   OTHER
      SAVE SCREEN TO PreScr
      DO CASE
         CASE _field='PATIENT1(2)'
            @ 9,20 CLEA TO 14,50
            @ 9,20 TO 14,50
            @ 11,33 PROMPT '1 = ���'
            @ 12,33 PROMPT '2 = ˭ԧ'
            MENU TO mchoice
            KEYB STR(mchoice,1)
         CASE _field='PATIENT1(5)'
            @ 9,20 CLEA TO 14,50
            @ 9,20 TO 14,50
            @ 11,28 PROMPT '1 = ���Ͷ������'
            @ 12,28 PROMPT '2 = ������'
            MENU TO mchoice
            KEYB STR(mchoice,1)
         CASE _field='PATIENT2(3)'
            @ 8,20 CLEA TO 17,50
            @ 8,20 TO 17,50
            @ 10,32 PROMPT '1 = �ʴ'
            @ 11,32 PROMPT '2 = ����'
            @ 12,32 PROMPT '3 = �����'
            @ 13,32 PROMPT '4 = ����'
            @ 14,32 PROMPT '5 = �¡'
            @ 15,32 PROMPT '6 = ����'
            MENU TO mchoice
            KEYB STR(mchoice,1)
         CASE _FIELD $ 'PATIENT2(4),PATIENT2(6),PATIENT2(5),PATIENT1(8)'
			= THAIMODE()
			DO SearchHelp
			_m=field(1)
			SET ORDER TO 1
			ACTI SCREE
			KEYB &_m
      ENDC
      REST SCREE FROM PreScr
ENDC
fromhelp = .F.
*SET COLO TO bg+/b