PARA _TYPE				&& ����������͡�������§ҹ 504 ���� 505
**************************************************************
#DEFINE colnum 67
#DEFINE mpict '9,999,999'
#DEFINE top_row 6
#DEFINE bott_row 20
#DEFINE col_t 3
#DEFINE returnk 13
#DEFINE dn_arrow 24      
#DEFINE up_arrow 5
#DEFINE pg_up 18   
#DEFINE pg_dn 3
#DEFINE escape 27
#DEFINE homekey 1
#DEFINE endkey 6
* �ͺ�����Ҩзӧҹ��͹/�� �˹
CLOSE DATA
mmyy = SPACE(4)
DO GETDATE WITH mmyy
mm = LEFT(mmyy,2)
yy = RIGHT(mmyy,2)
IF mm=' ' .OR. LASTKEY() = 27 .OR. yy = ' '
	?? CHR(7)
	WAIT '¡��ԡ��÷ӧҹ�������ҹ��ͧ���' WIND NOWA
	RETU
ENDI
************************************ ������������ҵ�ͧ����ä�˹
IF FILE('NAME&_TYPE..DBF')
	usefile = 'name'+_type 
ELSE
	usefile = 'name'+_type+'p'
ENDI
USE (usefile) IN 0 ALIA name
SELE name
max_field = RECCOUNT()
numrec = max_field
DIME title[max_field],in[max_field]
GO TOP
FOR i = 1 TO max_field		&& �纪��͡�����ä���� array title
	title[i] = STR(i,3)+'.'+LEFT(desc,55)
	in[i] = 0
	SKIP
NEXT
************************************** �Դ�����/��͹����ͧ��÷ӧҹ
* �����辺������ҧ������� ������������� subdirectory 'DATA'
IF ! FILE('DATA\D&_type&yy&mm..DBF')
	DO createda WITH mm,yy
ENDI
datafile = 'data\d'+_type+yy+mm
USE (datafile) IN 0 ALIA data
myear = IIF(mm=LEFT(FULLYEAR(yy),2),'�է�����ҳ ','��͹'+month&mm+' �.�. ')+ FULLYEAR(yy)
DIME input[3]
STOR '1. �֧�����Ũҡ�蹴�ʤ�' TO input[1]
STOR '2. ŧ�������ͧ' TO input[2]
STOR '3. ¡��ԡ���ŧ������' TO input[3]
@ 12,30 GET toinput DEFA 1 FROM input
READ
HIDE MENU ph_menu
DO CASE
	CASE toinput = 1
		DO DiskRead
	CASE toinput = 2
		DO ManualIn
ENDC
CLEA
CLOSE DATA

PROC  ManualIn
DO WHILE .T.
	STOR SPACE(12) TO hcode
	STOR SPACE(30) TO hname
	DO AskHosp WITH hcode,hname		&& �ͺ�����ҵ�ͧ���ŧ�����Ţͧʶҹ��Һ���˹
	IF LASTKEY() = 27
		EXIT
	ENDI
	DIME in[numrec]
	NAME=ALLTRIM(HNAME)
	totalnumber=0               && �ӹǹ�����·�����
	SELE data
	LOCA FOR hosp = hcode		&& ��Ǩ�ͺ����բ����Ţͧʶҹ��Һ�ŷ���ͧ����������
	IF ! FOUND()				&& ��������������ҧ���������
		APPE BLANK
		REPL hosp WITH hcode
	ENDI
	FOR n=1 to max_field
		x=LTRIM(STR(n))
		in[n]=case&x
		totalnumber=totalnumber + in[n]
	NEXT
	do KEYDATA  WITH '�ѹ�֡Ẻ ç.'+_TYPE
	CLEA
ENDD

PROC KEYDATA
PARA _form
ON KEY LABEL F2 DO jump_inp
@ 01,Center(_form) SAY _form
@ 01,55 SAY myear
@ 2,0
@ 02,Center(name) SAY name
@ 03,01 SAY REPL('-',77)
@ 04,02 SAY '      ���˵ػ��� '
@ 04,71 SAY '�ӹǹ'
DO WHIL .T.
   @ 23,0
   msg =  '������ [Esc] �����ŧ����������  [F2] = ���ⴴ仵��˹觷���ͧ���'
   @ 24,Center(msg) SAY msg COLO r+
   @ top_row,0 CLEA TO bott_row,79
   SET CONFIRM ON
   FIRST_FIELD=1          && ��˹���ҵ���÷�������÷Ѵ�á�ͧ��
   LAST_FIELD=1           && ��˹���ҵ���÷�������÷Ѵ�ش���¢ͧ��㹻Ѩ�غѹ
   CUR_FIELD=1            && ��˹���ҵ���÷������㹻Ѩ�غѹ
   CUR_ROW=top_row        && ��˹���Һ�÷Ѵ�����ѧ�����
   LAST_ROW=TOP_ROW       && ��˹���Һ�÷Ѵ�ش���·���ա���ʴ���
   GO_FIELD=1             && ��˹�������ҨС��ⴴ价�� field ���
   DO SCREEN_W            && ��¹��ͤ���ŧ���ͷ����ա�����
   @ 22,col_t SAY '  ******* ��������� *******'
   @ 22,colnum SAY totalnumber PICT mpict
   DO WHIL cur_field<=max_field  && ���Ө����Ҩ��������ء field ���͡����� [Esc]
      mbuffer=in[cur_field]      && ��˹���ҷ����������͹
      jump=.F.
      @ cur_row,colnum  GET in[cur_field] PICT mpict
      read
      @ cur_row,colnum  SAY in[cur_field] PICT mpict
      kq=lastkey()         && ��ҹ��ҷ���͡�ҡ��� READ ����繤������
      IF updated()
         totalnumber=totalnumber+in[cur_field]-mbuffer
         @ 22,colnum SAY totalnumber PICT mpict
      ENDI
      DO CASE
      CASE jump
         IF go_field-cur_field<=last_row-cur_row .AND. go_field>=first_field
            cur_row = cur_row + go_field - cur_field
            cur_field = go_field
         ELSE
            STOR go_field TO first_field,last_field,cur_field
            STOR TOP_ROW TO CUR_ROW,LAST_ROW
            @ TOP_ROW,0 CLEA TO BOTT_ROW,79
            DO SCREEN_W
         ENDI
         jump=.F.
      CASE kq =returnk    && [RETURN]
		IF CUR_ROW<BOTT_ROW
			CUR_ROW=CUR_ROW+1
			CUR_FIELD=CUR_FIELD+1
		ELSE
			IF cur_field<max_field
				DO SCROLL_U
			ELSE
				cur_field=cur_field+1
			ENDI
		ENDI
	CASE KQ= DN_ARROW  &&[DOWN]
		IF CUR_FIELD < MAX_FIELD
			IF CUR_ROW<BOTT_ROW
				CUR_ROW=CUR_ROW+1
				CUR_FIELD=CUR_FIELD+1
			ELSE
				DO SCROLL_U
			ENDI
		ENDI
	CASE KQ= UP_ARROW   && [UP]
		IF CUR_FIELD>1
			IF CUR_ROW>TOP_ROW
				CUR_ROW=CUR_ROW-1
				CUR_FIELD=CUR_FIELD-1
			ELSE
				DO SCROLL_D
			ENDI
		ENDI
	CASE KQ=ESCAPE
		CUR_FIELD=MAX_FIELD+1
	CASE KQ=PG_UP
		NUM_ROW=BOTT_ROW-TOP_ROW+1
		IF FIRST_FIELD>1
			IF FIRST_FIELD>NUM_ROW
				STOR FIRST_FIELD-NUM_ROW TO FIRST_FIELD,LAST_FIELD,;
				CUR_FIELD
			ELSE
				STOR 1 TO FIRST_FIELD,LAST_FIELD,CUR_FIELD
			ENDI
			STOR TOP_ROW TO CUR_ROW,LAST_ROW
			@ TOP_ROW,0 CLEA TO BOTT_ROW,79
			DO SCREEN_W
		ENDI
	CASE KQ=PG_DN
		IF LAST_FIELD<MAX_FIELD
			STOR LAST_FIELD+1 TO FIRST_FIELD,LAST_FIELD,CUR_FIELD
			STOR TOP_ROW TO CUR_ROW,LAST_ROW
			@ TOP_ROW,0 CLEA TO BOTT_ROW,79
			DO SCREEN_W
		ENDI
	ENDCASE
   ENDD
   SET CONFIRM OFF
   @ 24,0
   correct='Y'
   @ 23,15 PROMPT '�ѹ�֡���������'
   @ 23,35 PROMPT '¡��ԡ������'
   @ 23,55 PROMPT '��䢢�����'
   MENU TO choice
   DO CASE
   CASE choice=1
   		WAIT WIND NOWA '�ѹ�֡������ ' + TRIM(hname) + ' ���º����'
      EXIT
   CASE choice=2 .OR. choice=0
      ON KEY LABEL F2
   		WAIT WIND NOWA '¡��ԡ��úѹ�֡������ ' + TRIM(hname)
      RETU
   CASE choice=3
      LOOP
   ENDC
ENDD
SELE data
DIME in[numrec+1]
=AINS(in,1)
in[1] = hcode
GATH FROM in
ON KEY LABEL F2

PROC SCREEN_W
DO WHIL last_row<=bott_row .and. last_field<=max_field
   @ last_row,col_t SAY title[last_field]
   @ last_row,colnum SAY in[last_field] PICT mpict
   last_field=last_field+1
   last_row=last_row+1
ENDD
last_row=last_row-1
last_field=last_field-1

PROC SCROLL_U
SCROLL top_row,0,bott_row,79,1
last_field=last_field+1
first_field=first_field+1
cur_field=cur_field+1
@ cur_row,col_t SAY title[cur_field]
@ cur_row,colnum SAY in[cur_field] PICT mpict

PROC SCROLL_D
SCROLL top_row,0,bott_row,79,-1
IF last_row<bott_row
   last_row=last_row+1
   ELSE
   last_field=last_field-1
ENDI
first_field=first_field-1
cur_field=cur_field-1
@ cur_row,col_t SAY title[cur_field]
@ cur_row,colnum SAY in[cur_field] PICT mpict

PROC JUMP_INP
DEFINE WIND jump FROM 8,20 TO 12,60 SHAD
ACTI WIND jump
go_field=1
   @ 1,4 SAY '��ͧ�����������ŷ��  ' GET go_field PICT '999' Valid ;
   BETWEEN(go_field,1,max_field) ERROR '��ͧ����ҵ���Ţ�����ҧ 1 ��� ' + LTRIM(STR(max_field))
   READ
jump=.T.
KEYBOARD CHR(13)
RELE WIND jump

PROC CREATEda
PARA _mmm,_yyy
SELE 0
	DIME rbstru[numrec+1,4]
	rbstru[1,1]='HOSP'
	rbstru[1,2]='C'
	rbstru[1,3]=12
	rbstru[1,4]=0
	FOR i = 1 TO numrec
		x=LTRIM(STR(i))
		rbstru[i+1,1]='CASE'+x
		rbstru[i+1,2]='N'
		rbstru[i+1,3]=6
		rbstru[i+1,4]=0
	NEXT
	creafile = 'data\d'+_type+_yyy+_mmm
	CREAT TABLE (creafile) FROM ARRAY rbstru
USE

PROC DISKREAD
DEFINE WIND choosedisk FROM 12,60 TO 16,77 TITLE '�ҡ���' SHAD
DEFINE WIND fromdisk FROM 17,10 TO 22,70 SHAD
goon = .T.
DO WHIL goon
	ACTI WIND choosedisk
	@ 1,4 PROMPT 'A:'
	@ 2,4 PROMPT 'B:'
	MENU TO sdisk
	IF sdisk > 0
		sfile = IIF(sdisk = 1,'A:','B:')+'r'+_type+yy+mm
		IF FILE(sfile+'.dbf')
			USE (sfile) IN 0 alia report
			SELE report
			SCAT TO rb
			IF ! USED('HOSPCODE')
				USE hospcode IN 0
			ENDI
			SELE hospcode
			SET ORDER TO 1
			ACTI WIND fromdisk
			IF ! SEEK(rb[1])
				?? CHR(7)
				@ 1,3 SAY '�����ʶҹ��Һ������ ' + rb[1]
				@ 2,3 SAY '��ͧ������¡�����Ź��������������  ' GET godisk DEFA 'N' PICT '!'
				READ
				IF godisk $ 'Y��'
					DO DiskData
				ENDI
			ELSE
				DO DiskData
			ENDI
			SELE report
			USE
		ELSE
			?? CHR(7)
			WAIT WIND '��辺������' + myear NOWA
		ENDI
	ENDI
	ACTI WIND fromdisk
	CLEA
	@ 2,0 SAY '��ͧ��ô֧�����Ũҡ��ʤ�������ա�������  ' GET nextdisk DEFA 'Y' PICT '!'
	READ
	goon = IIF(nextdisk $ 'Y��',.T.,.F.)
	DEAC WIND fromdisk
ENDD
RELE WIND choosedisk,fromdisk

PROC DISKDATA
CLEA
@ 1,0 SAY '�����Ţͧʶҹ��Һ�Ū��� '+TRIM(De_NAME(hospcode.name))
@ 3,3 SAY '�١��ͧ�������  ' GET sure DEFA 'Y' PICT '!'
READ
msg = IIF(sure $ 'Y��','�红�����','����红�����')
CLEA
@ 2,Center(msg) SAY msg
=INKEY(1)
IF sure $ 'Y��'
	SELE data
	LOCA FOR hosp = rb[1]
	=ADEL(rb,2)
	IF ! FOUND()
		INSERT INTO data FROM ARRAY rb
	ELSE
		GATH FROM rb
	ENDI
ENDI