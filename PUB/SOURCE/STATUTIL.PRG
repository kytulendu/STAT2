********************************************************************************
*  ���������Ѻ������ٺ��ا�ѡ���к��ͧ����� STAT2                           *
********************************************************************************

PRIVATE Colspace,PreScr,Ch_help
#define numutil 10
@ 3,0 CLEA TO 20,80
DIME chelp(numutil),EHelpMess(numutil)
chelp(1)='1. ��˹������'
chelp(2)='2. ��˹������Է��'
chelp(3)='3. ������ʼ�ҹ'
chelp(4)='4. ���ͧ������'
chelp(5)='5. ��˹���Ңͧ�к�'
chelp(6)='6. ��������Ѫ��'
chelp(7)='7. ��Ǩ�ͺ����Ѫ��'
chelp(8)='8. ����ç���ҧ����� Version 2.8'
chelp(9)='9. ����ç���ҧ����� Version 2.95'
chelp(numutil)='0. ��Ѻ��¡�����'

EHelpMess(1)='��˹����ͼ����ҹ��к� ����Է��㹡����ҹ'
EHelpMess(2)='��˹������Է�ԡ���ѡ������ʹ���ͧ�Ѻ���ʡ�ҧ'
EHelpMess(3)='������ʼ�ҹ�ͧ����ͧ'
EHelpMess(4)='���ͧ������������ͤ�����ʹ���'
EHelpMess(5)='��˹� Configuration �ͧ�к���Ҩ������������ҧ'
EhelpMess(6)='����������Ѫ�շ����������׹�� �ô���ѧ!'
EhelpMess(7)='��Ǩ�ͺ������Ѫ�շ������'
EhelpMess(8)='��Ǩ�ͺ�������ç���ҧ����ͧ STAT Ver2.6 �����Ẻ STAT Ver2.8'
EhelpMess(9)='��Ǩ�ͺ�������ç���ҧ����ͧ STAT Ver2.8 �����Ẻ STAT Ver2.95'
EHelpMess(numutil)='��Ѻ������¡����ѡ'

DEFINE WIND help_menu FROM 4,5 TO 4+ALEN(chelp)+3,45 SHAD COLO gr+/BG TITLE '    ��˹���ҵ�ҧ �    '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	= ENGMODE()
	DO Title WITH '��¡�á�˹���ҵ�ҧ �'
	ACTI WIND help_menu
	CLEA
	FOR i=1 TO ALEN(chelp)
		@ i,3 PROMPT chelp(i) MESS EhelpMess(i)
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
			DO InputUser
		CASE Ch_help = 2
			DO SocialRight
		CASE Ch_help = 3
			DO ChangeUsrPass
		CASE Ch_help = 4
			DO Audit
		CASE Ch_help = 5
			DO SetCon
		CASE Ch_help = 6
			DO Reindex
		CASE Ch_help = 7
			DO Checkind
		CASE Ch_help = 8
			DO CheckStructure
		CASE Ch_help = 9
			DO CheckStru295
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_menu
CLOSE DATA

PROC CheckStructure
********************************************************************************
*  ���������Ѻ�����������ç���ҧ���������                         *
********************************************************************************

PRIVATE Colspace,PreScr,Ch_help
#define numstru 10
@ 3,0 CLEA TO 20,80
DIME shelp(numstru),shelpmess(numstru)
shelp(1)='1. ����ҹ��������ѡ'
shelp(2)='2. �������ʶҹ��ԡ��'
shelp(3)='3. ����Է�ԡ���ѡ��'
shelp(4)='4. ��������¹͡'
shelp(5)='5. ��� refer �����¹͡'
shelp(6)='6. ����Ѻ������'
shelp(7)='7. ����ԹԨ����ä�������'
shelp(8)='8. ��� refer �������'
shelp(9)='9. ����Ѻ������㹻�Шӻ�'
shelp(numstru)='0. ��Ѻ��¡�����'

shelpmess(1) = '��Ǩ�ͺ�������ç���ҧ��� PATIENT1'
shelpmess(2) = '��Ǩ�ͺ�������ç���ҧ�������ʶҹ��ԡ��'
shelpmess(3) = '��Ǩ�ͺ�������ç���ҧ����Է�ԡ���ѡ��'
shelpmess(4) = '��Ǩ�ͺ�������ç���ҧ��������¹͡'
shelpmess(5) = '��Ǩ�ͺ�������ç���ҧ��� refer �����¹͡'
shelpmess(6) = '��Ǩ�ͺ�������ç���ҧ����Ѻ������� (IPTRANA) ��ͧ�����ҹҹ�ҡ'
shelpmess(7) = '��Ǩ�ͺ�������ç���ҧ���������� ��С�ü�ҵѴ'
shelpmess(8) = '��Ǩ�ͺ�������ç���ҧ��� refer �������'
shelpmess(9) = '��Ǩ�ͺ�������ç���ҧ����Ѻ������㹻�Шӻ� (ADMyy) ��С�õ��'
shelpmess(numstru)='��Ѻ������¡����ѡ'

DEFINE WIND ChkStru_menu FROM 4,5 TO 4+ALEN(shelp)+3,45 SHAD COLO gr+/BG TITLE ' ���͡�������ͧ��� '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	= ENGMODE()
	DO Title WITH '����ç���ҧ����� Version 2.8'
	ACTI WIND ChkStru_menu
	CLEAR
	FOR i=1 TO ALEN(shelp)
		@ i,3 PROMPT shelp(i) MESS shelpmess(i)
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
			DO CheckPatient1
		CASE Ch_help = 2
			DO CheckHospCode
		CASE Ch_help = 3
			DO CheckSocial
		CASE Ch_help = 4
			DO CheckCame
		CASE Ch_help = 5
			DO CheckRFO
		CASE Ch_help = 6
			DO CheckIPTRANA
		CASE Ch_help = 7
			DO CheckIPDFile
		CASE Ch_help = 8
			DO CheckRFI
		CASE Ch_help = 9
			DO CheckADM
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND ChkStru_menu
CLOSE DATA


PROC InputUser
PRIV UserName,UserRight,_ret,pp,_mkey,goon,goon1
userright = GetUser()
SELE 0
dbfuse = patientdir+'user'
USE (patientdir+'user') ORDER TAG name
dbfuse = ''
goon1 = .T.
IF 'SUP       ' == userright
	DEFI WIND inputuser FROM 5,10 TO 19,70 SHAD
	ACTI WIND inputuser
	DO WHIL goon1
		CLEA
		goon = .T.
		yn = 'N'
		UserName = SPACE(12)
		@ 1,3 SAY '���ͼ����  : ' GET UserName PICT '@!'
		READ NOLOCK
		IF ! EMPTY(UserName) .AND. LASTKEY() # 27
			IF SEEK(UserName)
				=ALARM1()
				@ 3,5 SAY '���� '+ UserName + ' �µ������ ��ͧ�������������'
				@ 4,10 SAY 'Yes/No ' GET yn PICT '!'
				READ NOLOCK
				IF yn # 'Y'
					goon = .F.
				ENDI
				@ 3,0 CLEA
			ENDI
			IF goon
				msg = '����ͧ������ʼ�ҹ��ҵ�ͧ���ź�����'

				@ WROW() - 1,Center(msg) SAY msg
				@ 3,3 SAY '���ʼ�ҹ    : '
				_ret = ''
				FOR pp = 1 TO 10
					_mkey = INKEY(0)
					IF _mkey = 13
						EXIT
					ENDI
					_ret = _ret+CHR(_mkey)
					@ 3,COL() SAY '*'
				NEXT
				IF EMPTY(_ret)
					IF ! EOF()
						SCAT MEMV BLANK
						GATH MEMV
					ENDI
				ELSE
					_ret = UPPE(LEFT(_ret+SPAC(10),10))
					IF 'SUP       ' == right
						STORE 1 TO sright,aright,oright,iright,suright
					ELSE
						sright = IIF( 'S' $ right,1,0)
						aright = IIF('A' $ right,1,0)
						oright = IIF('O' $ right,1,0)
						iright = IIF('I' $ right,1,0)
						suright = 0
					ENDI
					@ WROW() - 1,0
					@ WROW() -1,Center('������ [Esc] ���������') SAY '������ [Esc] ���������'
					@ 5,8 GET suright FUNC '*C �Է�Ԣͧ Supervisor'
					@ 6,8 GET sright FUNC '*C �Է�����������ͧ�ѵ�' WHEN suright = 0
					@ 7,8 GET oright FUNC '*C �Է��������������¹͡' WHEN suright = 0
					@ 8,8 GET aright FUNC '*C �Է����������Ѻ������' WHEN suright = 0
					@ 9,8 GET iright FUNC '*C �Է����������������' WHEN suright = 0
					READ NOLOCK CYCLE
					IF suright = 1
						userright = 'SUP'
					ELSE
						userright = IIF(sright=1,'S,','')
						userright = IIF(oright=1,userright+'O,',userright)
						userright = IIF(aright=1,userright+'A,',userright)
						userright = IIF(iright=1,userright+'I,',userright)
					ENDI
					IF EOF()
						GO TOP
						IF ! EMPTY(name) .OR. BOF()
							APPE BLAN
						ENDI
					ENDI
					REPL name WITH UserName,psw WITH Encrypt(_ret),right WITH userright
				ENDI
			ENDI
		ELSE
			goon1 = .F.
		ENDI
	ENDD
	RELE WIND inputuser
ENDI
SELE user
USE

PROC ChangeUsrPass
PRIV UsrName,NewPass
STORE ' ' TO UsrName,NewPass
IF ! EMPTY(GetUser(UsrName))
	IF ChangePass(NewPass)
		SELE 0
		dbfuse = patientdir+'user'
		USE (patientdir+'user') ORDER TAG name
		dbfuse = ''
		SEEK UsrName
		REPL psw WITH Encrypt(LEFT(NewPass+SPACE(10),10))
		USE
		=ALARM1()
		WAIT WIND NOWA '�ô���ѧ ! ������¹���ʼ�ҹ��������ͧ������� �ô��������'
	ENDI
ENDI

PROC SocialRight
PRIV UserName,UserRight,_ret,pp,_mkey,goon,goon1
userright = GetUser()
SELE 0
dbfuse = patientdir+'social'
= OpenDBF(dbfuse,'',1)
dbfuse = patientdir+'pttyp'
= OpenDBF(dbfuse,'',1)
dbfuse = ''
goon1 = .T.
IF 'SUP       ' == userright
	msg = '[CTRL]+[N] = ��������     [CTRL]+[V] = �ʹ����ʨҡ��ǹ��ҧ  [Esc] = ����'
	ACTI SCREE
	@ 23, Center(msg) SAY msg
	ON KEY LABEL CTRL+N DO APPE_BLANK
	ON KEY LABEL CTRL+V DO viewpttype
	SELE social
	DEFINE WIND social FROM 3,10 TO 17,70 SHAD
	BROW FIELD class :h='����', name :h='    �Է�ԡ���ѡ��', pttyp :h='�����ҵðҹ' WIND social
	RELE WIND pttype, social
	ON KEY LABEL CTRL+N
	ON KEY LABEL CTRL+V
	ACTI SCREE
	@ 23,0
ENDI

PROC ViewPTTYPE
ON KEY LABEL CTRL+V
SELE pttyp
DEFINE WIND pttype FROM 13,10 TO 22,70 SHAD
BROW FIELD pttyp :h='�����ҵðҹ', typname :h='   �Է�ԡ���ѡ��' WIND pttype
SELE social
ON KEY LABEL CTRL+V DO viewpttype


PROC APPE_BLANK
APPE BLANK

PROC CHECKPATIENT1
*******************************************************************
*  ��Ǩ�ͺ����ա�����Ţ���ѵû�ЪҪ����������ѧ                *
*******************************************************************

SET EXCL ON
SELE 0
DEFINE WIND showready FROM 19,20 TO 23,78 SHAD COLO SCHEM 6

dbfuse = patientdir + 'patient1.dbf'
beupdate= .T.
IF FILE(dbfuse)
	USE (dbfuse)
	FOR I = 1 TO FCOUNT()
		IF FIELD(i) = 'PERSON_ID'
			i = 100
			beupdate = .F.
		ENDI
	NEXT
	IF beupdate						&& �ѧ����ա�����Ţ���ѵû�ЪҪ�
		DO Patient1Correct			&& ������������Ţ���ѵû�ЪҪ�
	ENDI
ENDI
SET EXCL OFF
KEYB '!'
CLOSE DATA

PROC CHECKHOSPCODE
*******************************************************************
*  ��Ǩ�ͺ���������ʶҹ��ԡ���������������ѧ                     *
*******************************************************************
dbfuse = codedir + 'hospcode'
USE (dbfuse) ORDER 1
IF FCOUNT() < 5 					&& �ѧ�����������ʶҹ��ԡ������
	USE
	SET DEFA TO (patientdir)
	IF ! FILE(patientdir + 'helpdbf.zip')
		?? CHR(7)
		CLEA
		WAIT WIND '�ô��Һ ! ��õԴ�������� STAT2 Ver ' + statversion + ;
		' �������ó�' + CHR(13) + '��س� Install �������١��ͧ' TIME 10
		SET DEFA TO (currentdirectory)
		RETU
	ENDI
	! PKUNZIP -o helpdbf  hospcode.*
	CLEAR
ENDI
dbfuse = patientdir + 'hospcode.dbf'
USE (dbfuse) ORDER 1 EXCL
IF TAG(3) # 'CODE'
	INDEX ON code TAG code ADDI
ENDI
SET ORDER TO TAG code
IF TYPE('hosp_code') = 'C' .AND. LEN(hosp_code) > 5
	= SEEK(hosp_code)
	hosp_code = off_id
	SAVE ALL LIKE hosp_* TO (patientdir+'opdlan')
ENDI
CLOSE DATA
SET DEFA TO (currentdirectory)
KEYB '!'

PROC CHECKSOCIAL
***************************************************************
*  ������ Social                                           *
***************************************************************

dbfuse = patientdir + 'social.dbf'
SELE 0
IF FILE(dbfuse)
	WAIT WIND NOWA '�ô��� ���ѧ������ SOCIAL'
	USE (dbfuse) EXCL
	IF FCOUNT() < 3
		DO SocialCorrect
	ENDI
ENDI

***************************************************************
*  �������ʶҹ��Һ�Ţͧ��� INSURE                          *
***************************************************************

dbfuse = patientdir + 'insure.dbf'
IF ! USED('hospcode')
	SELE 0
	USE codedir + 'hospcode'
ENDI
SELE hospcode
IF FCOUNT('hospcode') < 5 .OR. TAG(3) # 'CODE'
	?? CHR(7)
	WAIT WIND NOWA '��ͧ����ç���ҧ�������ʶҹ��Һ�š�͹'
	ch_help = 2
	RETU
ENDI
SELE hospcode
SET ORDER TO TAG code
SELE 0
IF FILE(dbfuse)
	WAIT WIND NOWA '�ô��� ���ѧ������ INSURE'
	USE (dbfuse) EXCL
	IF LEN(hospmain) > 5
		n = 1
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SCAN
			@ 2,10 SAY n
			= SEEK(hospmain,'hospcode')
			REPL insure.hospmain WITH hospcode.off_id
			= SEEK(hospsub, 'hospcode')
			REPL insure.hospsub WITH hospcode.off_id
			n = n + 1
		ENDS
		DO InsureCorrect
	ENDI
ENDI

***************************************************************
*  �������ʶҹ��Һ�Ţͧ��� INSURLOG                        *
***************************************************************

dbfuse = LEFT(patientdir,AT('\',patientdir)) + 'credit\data\insurlog.dbf'
SELE 0
IF FILE(dbfuse)
	WAIT WIND NOWA '�ô��� ���ѧ������ INSURLOG'
	USE (dbfuse) EXCL
	n = 1
	DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
	ACTI WIND trycorrect
	SCAN
		@ 2,10 SAY n
		= SEEK(hospmain, 'hospcode')
		REPL insurlog.hospmain WITH hospcode.off_id
		= SEEK(hospsub, 'hospcode')
		REPL insurlog.hospsub WITH hospcode.off_id
		n = n + 1
	ENDS
	DO InsureCorrect
ENDI
RELE WIND trycorrect
CLOSE DATA
KEYB '!'

PROC CHECKIPTRANA
*****************************************************************
*  �������ʶҹ��Һ������ IPTRANA                            *
*****************************************************************
dbfuse = ipddir + 'data\iptrana.dbf'
IF FILE(dbfuse)
	USE (dbfuse) EXCL
	IF (LEN(place)) > 5
		IF ! USED('hospcode')
			SELE 0
			USE codedir + 'hospcode'
		ENDI
		IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
			?? CHR(7)
			WAIT WIND NOWA '��ͧ����ç���ҧ�������ʶҹ��Һ�š�͹'
			ch_help = 2
			RETU
		ENDI
		SELE hospcode
		SET ORDER TO TAG code
		SELE iptrana
		WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
		n = 1
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SCAN FOR ! EMPTY(place)
			@ 2,10 SAY n
			= SEEK(place, 'hospcode')
			REPL iptrana.place WITH hospcode.off_id
			n = n + 1
		ENDS
		DO IptranaCorrect
	ENDI
ENDI
RELE WIND trycorrect
CLOSE DATA
KEYB '!'

PROC CHECKRFO
**************************************************************
*  �������ʶҹ��Һ������ REFER �����¹͡                *
**************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY '��䢵�����  ' GET startmonth DEFA SPACE(2)
@ 2,2 SAY '      �֧��     ' GET endmonth DEFA SPACE(2)
@ 3,7 SAY '�١��ͧ�������  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Y��' .AND. LASTKEY() # 27
	IF ! USED('hospcode')
		SELE 0
		USE codedir + 'hospcode'
	ENDI
	IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
		?? CHR(7)
		WAIT WIND NOWA '��ͧ����ç���ҧ�������ʶҹ��Һ�š�͹'
		ch_help = 2
		RETU
	ENDI
	SELE hospcode
	SET ORDER TO TAG code
	SELE 0
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = opddir + 'refer' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) ALIA source
			IF (LEN(place)) > 5
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN
					@ 2,10 SAY n
					= SEEK(place, 'hospcode')
					REPL source.place WITH hospcode.off_id
					SELE source
					n = n + 1
				ENDS
				DO ReferCorrect
			ENDI
		ENDI
		startmonth = STRZERO(VAL(startmonth)+1, 2 )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ¡��ԡ��÷ӧҹ�����ͧ���  '
ENDI
CLOSE DATA
RELE WIND trycorrect
KEYB '!'

PROC CHECKCAME
******************************************************************
*  ��Ǩ�ͺ��� came �����Ẻ�����������                       *
******************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY '��䢵������͹/��  ' GET startmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(startmonth)
@ 2,2 SAY '      �֧��͹/��     ' GET endmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(endmonth)
@ 3,7 SAY '�١��ͧ�������  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Y��' .AND. LASTKEY() # 27
	startmonth = RIGHT(startmonth,2) + LEFT(startmonth,2)
	endmonth = RIGHT(endmonth,2) + LEFT(endmonth,2)
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = opddir + 'came' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse)
			newcamefile = .F.
			FOR i = 1 TO FCOUNT()
				IF UPPE(FIELD(i)) = 'DXTYPE'
					newcamefile = .T.
				ENDI
			NEXT
			IF ! newcamefile
				COPY TO temp STRU EXTE
				USE temp
				APPE BLANK
				REPL FIELD_NAME WITH 'DXTYPE', field_type WITH 'C', ;
				field_len WITH 1
				USE
				CREAT (opddir + 'temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = opddir + 'temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
				USE (dbfuse) ORDER 1
				div_num=ROUND((RECCOUNT()/40)+.5,0)
				recno = 0
				DO ShowProgress
				prehn = 'zzzzzzz'
				firstop = .T.
				SCAN
					firstop = IIF(hn + DTOS(date) + clinic # prehn, .T., firstop)
					recno=recno+1
					@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '�' COLO gr+
					IF LEFT(diag,1) = '*' OR ISDIGIT(diag)
						IF firstop
							REPL dxtype WITH '1'
							firstop = .F.
						ELSE
							REPL dxtype WITH '2'
						ENDI
					ELSE
						REPL dxtype WITH IIF(sequence = 1, '1', '2')
					ENDI
					prehn = hn + DTOS(date) + clinic
				ENDS
				RELE WIND progress
			ENDI
		ENDI
		startmonth = IIF(RIGHT(startmonth, 2 ) = '12', ;
		STRZERO(VAL(LEFT(startmonth, 2))+1, 2 ) + '01', ;
		LEFT(startmonth, 2) + STRZERO(VAL(RIGHT(startmonth, 2)) + 1, 2) )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ¡��ԡ��÷ӧҹ�����ͧ���  '
ENDI
CLOSE DATA
RELE WIND trycorrect
KEYB '!'

PROC CHECKRFI
***************************************************************
*  �������ʶҹ��Һ������ REFER �������                  *
***************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY '��䢵�����  ' GET startmonth DEFA SPACE(2)
@ 2,2 SAY '      �֧��     ' GET endmonth DEFA SPACE(2)
@ 3,7 SAY '�١��ͧ�������  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Y��' .AND. LASTKEY() # 27
	IF ! USED('hospcode')
		SELE 0
		USE codedir + 'hospcode'
	ENDI
	IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
		?? CHR(7)
		WAIT WIND NOWA '��ͧ����ç���ҧ�������ʶҹ��Һ�š�͹'
		ch_help = 2
		RETU
	ENDI
	SELE hospcode
	SET ORDER TO TAG code
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	SELE 0
	DO WHIL startmonth <= endmonth
		dbfuse = ipddir + 'data\refer' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) ALIA source EXCL
			IF (LEN(place)) > 5
				WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN
					@ 2,10 SAY n
					= SEEK(place, 'hospcode')
					REPL source.place WITH hospcode.off_id
					n = n + 1
				ENDS
				DO ReferipdCorrect
			ENDI
		ENDI
		startmonth = STRZERO(VAL(startmonth)+1, 2 )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ¡��ԡ��÷ӧҹ�����ͧ���  '
ENDI
CLOSE DATA
RELE WIND trycorrect
KEYB '!'

PROC CHECKADM
***************************************************************
*  ��Ǩ�ͺ��� ipd adm �����Ẻ����������                 *
***************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY '��䢵�����  ' GET startmonth DEFA SPACE(2)
@ 2,2 SAY '      �֧��     ' GET endmonth DEFA SPACE(2)
@ 3,7 SAY '�١��ͧ�������  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Y��' .AND. LASTKEY() # 27
	IF ! USED('hospcode')
		SELE 0
		USE codedir + 'hospcode'
	ENDI
	IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
		?? CHR(7)
		WAIT WIND NOWA '��ͧ����ç���ҧ�������ʶҹ��Һ�š�͹'
		ch_help = 2
		RETU
	ENDI
	SELE hospcode
	SET ORDER TO TAG code
	SELE 0
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = ipddir + 'data\adm' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			IF LEN(place) > 5
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN FOR ! EMPTY(place)
					@ 2,10 SAY n
					= SEEK(place, 'hospcode')
					REPL in.place WITH hospcode.off_id
					n = n + 1
				ENDS
				COPY TO temp STRU EXTE
				USE temp
				LOCA FOR field_name = 'PLACE'
				REPL field_len WITH 5
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
			ENDI
		ENDI

		dbfuse = ipddir + 'data\death' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) EXCL
			newcamefile = .F.
			IF LEN(hospcare) > 5
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN
					@ 2,10 SAY n
					= SEEK(hospcare, 'hospcode')
					REPL hospcare WITH hospcode.off_id
					n = n + 1
				ENDS
				COPY TO temp STRU EXTE
				USE temp
				LOCA FOR field_name = 'HOSPCARE'
				REPL field_len WITH 5
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
			ENDI
		ENDI
		startmonth = STRZERO(VAL(startmonth)+1, 2 )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ¡��ԡ��÷ӧҹ�����ͧ���  '
ENDI
RELE WIND trycorrect
CLOSE DATA
RELE WIND trycorrect
KEYB '!'

PROC CHECKIPDFILE
***************************************************************
*  ��Ǩ�ͺ��� ipd in �����Ẻ����������                 *
***************************************************************

DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
IF ! USED('hospcode')
	SELE 0
	USE codedir + 'hospcode'
ENDI
IF FCOUNT('hospcode') < 5 OR TAG(3) # 'CODE'
	?? CHR(7)
	WAIT WIND NOWA '��ͧ����ç���ҧ�������ʶҹ��Һ�š�͹'
	ch_help = 2
	RETU
ENDI
SELE hospcode
SET ORDER TO TAG code
ACTI WIND ask
@ 1,2 SAY '��䢵������͹/��  ' GET startmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(startmonth)
@ 2,2 SAY '      �֧��͹/��     ' GET endmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(endmonth)
@ 3,7 SAY '�١��ͧ�������  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Y��' .AND. LASTKEY() # 27
	startmonth = RIGHT(startmonth,2) + LEFT(startmonth,2)
	endmonth = RIGHT(endmonth,2) + LEFT(endmonth,2)
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	SELE 0
	DO WHIL startmonth <= endmonth
		IF ! USED('hospcode')
			USE (codedir + 'hospcode') ORDER 1 IN 0
		ENDI
		SELE 0
		dbfuse = ipddir + 'data\in' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			IF LEN(place) > 5
				n = 1
				DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
				ACTI WIND trycorrect
				SCAN FOR ! EMPTY(place)
					@ 2,10 SAY n
					= SEEK(place, 'hospcode')
					REPL place WITH hospcode.off_id
					n = n + 1
				ENDS
				COPY TO temp STRU EXTE
				USE temp
				LOCA FOR field_name = 'PLACE'
				REPL field_len WITH 5
				LOCA FOR field_name = 'TIMEADM'
				IF EOF()
					APPE BLANK
					REPL field_name WITH 'TIMEADM', field_type WITH 'C', field_len WITH 4
				ENDI
				LOCA FOR field_name = 'TIMEDSC'
				IF EOF()
					APPE BLANK
					REPL field_name WITH 'TIMEDSC', field_type WITH 'C', field_len WITH 4
				ENDI
				LOCA FOR field_name = 'DEP'
				IF EOF()
					APPE BLANK
					REPL field_name WITH 'DEP', field_type WITH 'C', field_len WITH 4
				ENDI
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				predbf = dbfuse
				DO Reindex WITH .F.
				dbfuse = predbf

				USE (dbfuse) ALIA nowadm
				= OPENDBF(ipddir + '\data\adm' + LEFT(startmonth,2),'adm', 'an')
				SELE nowadm
				SET RELA TO
				SET RELA TO an INTO adm
				SCAN
					? SPACE(5), an
					REPL timeadm WITH adm.timeadm, timedsc WITH adm.timedsc, ;
					dep WITH adm.dep
				ENDS
				SELE adm
				USE
				SELE nowadm
				USE
			ENDI
		ENDI
***************************************************************
*  ��Ǩ�ͺ��� ipd diag �����Ẻ����������                 *
***************************************************************
		dbfuse = ipddir + 'data\diag' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) EXCL
			newcamefile = .F.
			FOR i = 1 TO FCOUNT()
				IF UPPE(FIELD(i)) = 'DXTYPE'
					newcamefile = .T.
				ENDI
			NEXT
			IF ! newcamefile
				COPY TO temp STRU EXTE
				USE temp
				APPE BLANK
				REPL FIELD_NAME WITH 'DXTYPE', field_type WITH 'C', ;
				field_len WITH 1
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
				GO TOP
				prean = 'zzzzz'
				DO WHIL ! EOF()
					? SPACE(5), an
					REPL dxtype WITH IIF(an = prean, '2', '1')
					prean = an
				SKIP
				ENDD
				USE
			ENDI
		ENDI

***************************************************************
*  ��Ǩ�ͺ��� ipd oper �����Ẻ����������                 *
***************************************************************

		dbfuse = ipddir + 'data\oper' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) EXCL
			IF FCOUNT() < 6
				COPY TO temp STRU EXTE
				USE temp
				APPE BLANK
				REPL FIELD_NAME WITH 'TIMEIN', field_type WITH 'C', ;
				field_len WITH 4
				APPE BLANK
				REPL FIELD_NAME WITH 'DATEOUT', field_type WITH 'D'
				APPE BLANK
				REPL FIELD_NAME WITH 'TIMEOUT', field_type WITH 'C', ;
				field_len WITH 4
				APPE BLANK
				REPL FIELD_NAME WITH 'OPTYPE', field_type WITH 'C', ;
				field_len WITH 1
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
				GO TOP
				prean = 'zzzzz'
				DO WHIL ! EOF()
					? SPACE(5), an
					REPL optype WITH IIF(an = prean, '2', '1')
					prean = an
					SKIP
				ENDD
				USE
			ENDI
		ENDI
		startmonth = IIF(RIGHT(startmonth, 2 ) = '12', ;
		STRZERO(VAL(LEFT(startmonth, 2))+1, 2 ) + '01', ;
		LEFT(startmonth, 2) + STRZERO(VAL(RIGHT(startmonth, 2)) + 1, 2) )
		CLOSE DATA
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ¡��ԡ��÷ӧҹ�����ͧ���  '
ENDI
CLOSE DATA
RELE WIND Trycorrect
KEYB '!'

PROC Patient1Correct
*****************************************************************
*  ����������� patient1 ������Ţ���ѵû�ЪҪ�           *
*****************************************************************

		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		APPE BLAN
		REPL field_name WITH 'PERSON_ID', field_type WITH 'C', field_len WITH 13
		USE
		CREAT (patientdir + 'temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = patientdir + 'temp1.dbf'
		targetfile = patientdir + 'patient1.dbf'
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		INDEX ON hn TAG hn
		INDEX ON name TAG name ADDI
		INDEX ON SUBS(name,AT(' ',name)+1,4) TAG last ADDI
		INDEX ON LEFT(name,4)+SUBS(name,AT(' ',name)+1,4) TAG namelast ADDI
		INDEX ON clinic TAG clinic ADDI
		INDEX ON lastdate TAG lastdate ADDI
		INDEX ON person_id TAG person_id ADDI
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC InsureCorrect
****************************************************************
*  ����������� insure ���������ʶҹ��ԡ��Ẻ����         *
*  �����䢢��������١��ͧ                                    *
****************************************************************

		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'HOSPMAIN'
		REPL field_len WITH 5
		LOCA FOR field_name = 'HOSPSUB'
		REPL field_len WITH 5
		USE
		CREAT (patientdir + 'temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = patientdir + 'temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC IptranaCorrect
****************************************************************
*  ����������� iptrana ���������ʶҹ��ԡ��Ẻ����        *
*  �����䢢��������١��ͧ                                    *
****************************************************************

		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'PLACE'
		REPL field_len WITH 5
		USE
		CREAT (ipddir + 'data\temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = ipddir + 'data\temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC ReferCorrect
****************************************************************
*  ����������� refer ���������ʶҹ��ԡ��Ẻ����          *
*  �����䢢��������١��ͧ                                    *
****************************************************************
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'PLACE'
		REPL field_len WITH 5
		USE
		CREAT (opddir + 'temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = opddir + 'temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC ReferIpdCorrect
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'PLACE'
		REPL field_len WITH 5
		USE
		CREAT (ipddir + 'data\temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = ipddir + 'data\temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

PROC SocialCorrect
		DEFINE WIND trycorrect FROM 10,20 TO 16,60 SHAD
		ACTI WIND trycorrect
		SET TALK ON
		COPY TO temp STRU EXTE
		USE temp
		APPE BLAN
		REPL field_name WITH 'pttyp', field_type WITH 'C', field_len WITH 2
		USE
		CREAT (patientdir + 'temp1') FROM temp
		DELE FILE temp.dbf
		APPE FROM (dbfuse)
		DELE FILE (dbfuse)
		USE
		sourcefile = patientdir + 'temp1.dbf'
		targetfile = dbfuse
		RENAME &sourcefile TO &targetfile
		USE (dbfuse) EXCL
		DO reindex WITH .F.
		SET TALK OFF
		RELE WIND trycorrect
		KEYB '!'

FUNC TrueMonth
PARA _month
IF ! BETWEEN(_month, '0100', '1299')
	?? CHR(7)
	WAIT WIND NOWA IIF( ! BETWEEN(LEFT(_month,2),'01', '12'), ;
	'  �����͹���١��ͧ  ', '  �������١��ͧ  ')
	RETU 0
ENDI

********************************************************************************
*  ���������Ѻ�����������ç���ҧ����������� Version 2.95                *
********************************************************************************
PROC CheckStru295

PRIVATE Colspace,PreScr,Ch_help
#define numstru2 5
@ 3,0 CLEA TO 20,80
DIME s2help(numstru2),s2helpmess(numstru2)
s2help(1)='1. �����ª���ᾷ��'
s2help(2)='2. ����������'
s2help(3)='3. ��������¹͡'
s2help(4)='4. ����Ѻ������㹻�Шӻ�'
s2help(numstru2)='0. ��Ѻ��¡�����'

s2helpmess(1) = '��Ǩ�ͺ�������ç���ҧ�����ª���ᾷ�� (Doctor)'
s2helpmess(2) = '��Ǩ�ͺ�������ç���ҧ���������� (INyymm)'
s2helpmess(3) = '��Ǩ�ͺ�������ç���ҧ��������¹͡ (CAMEyymm)'
s2helpmess(4) = '��Ǩ�ͺ�������ç���ҧ����Ѻ������㹻�Шӻ� (ADMyy)'
s2helpmess(numstru2)='��Ѻ������¡����ѡ'

DEFINE WIND ChkStru295_menu FROM 4,25 TO 4+ALEN(s2help)+3,52 SHAD COLO gr+/BG TITLE ' ���͡�������ͧ��� '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	= ENGMODE()
	DO Title WITH '����ç���ҧ����� Version 2.95'
	ACTI WIND ChkStru295_menu
	CLEAR
	FOR i=1 TO ALEN(s2help)
		@ i,3 PROMPT s2help(i) MESS s2helpmess(i)
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
			DO CheckDOCTOR
		CASE Ch_help = 2
			DO CheckINyymm
		CASE Ch_help = 3
			DO CheckCAMEyymm
		CASE Ch_help = 4
			DO CheckADMyy
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND ChkStru295_menu
CLOSE DATA

***************************************************************
*  ������ Doctor                                           *
***************************************************************
PROC CheckDOCTOR
	dbfuse = patientdir+'doctor.dbf'
	IF ! FILE(dbfuse)
		?? CHR(7)
		WAIT WIND NOWA '  ��辺��� ' + dbfuse
	ELSE
		WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
		USE (dbfuse) ALIA in EXCL
		newcamefile = .F.
		COPY TO temp STRU EXTE
		USE temp
		LOCA FOR field_name = 'STATUS'
		IF ! EOF()
			WAIT WIND NOWA ' �ç���ҧ��� Doctor �١��ͧ���� '
		ELSE
			APPE BLANK
			REPL field_name WITH 'STATUS', field_type WITH 'L'
			USE
			CREAT (patientdir + 'temp1') FROM temp
			DELE FILE temp.dbf
			APPE FROM (dbfuse)
			DELE FILE (dbfuse)
			USE
			sourcefile = patientdir + 'temp1.dbf'
			targetfile = dbfuse
			RENAME &sourcefile TO &targetfile
			USE (dbfuse) EXCL
			REPL ALL status WITH .T.
			DO Reindex WITH .F.
			WAIT WIND NOWA ' ����ç���ҧ�����ª���ᾷ�� (Doctor) �������º�������� '
			USE
		ENDI
	ENDI

PROC CHECKINyymm
***************************************************************
*  ������ INyymm �����Ẻ Version 2.95                   *
***************************************************************

DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY '��䢵������͹/��  ' GET startmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(startmonth)
@ 2,2 SAY '      �֧��͹/��     ' GET endmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(endmonth)
@ 3,7 SAY '�١��ͧ�������  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Y��' .AND. LASTKEY() # 27
	startmonth = RIGHT(startmonth,2) + LEFT(startmonth,2)
	endmonth = RIGHT(endmonth,2) + LEFT(endmonth,2)
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = ipddir + 'data\in' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			COPY TO temp STRU EXTE
			USE temp
			LOCA FOR field_name = 'ADM_W'
			IF ! EOF()
				IF field_type ='C'
					REPL field_type WITH 'N', field_len WITH 7, field_dec WITH 3 FOR field_name = 'ADM_W'
					USE
					CREAT (ipddir + 'data\temp1') FROM temp
					DELE FILE temp.dbf
					APPE FROM (dbfuse)
					DELE FILE (dbfuse)
					USE
					sourcefile = ipddir + 'data\temp1.dbf'
					targetfile = dbfuse
					RENAME &sourcefile TO &targetfile
					USE (dbfuse) EXCL
					predbf = dbfuse
					DO Reindex WITH .F.
					WAIT WIND NOWA ' ����ç���ҧ���������� INyymm �������º�������� :) '
					USE
				ELSE
					WAIT WIND NOWA ' �ç���ҧ��� ' + dbfuse + ' �١��ͧ���� '
				ENDI
			ELSE
				APPE BLANK
				REPL field_name WITH 'ADM_W', field_type WITH 'N', field_len WITH 7, field_dec WITH 3
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				predbf = dbfuse
				DO Reindex WITH .F.
				WAIT WIND NOWA ' ����ç���ҧ���������� INyymm �������º�������� '
				USE
			ENDI
		ENDI
		startmonth = IIF(RIGHT(startmonth, 2 ) = '12', ;
		STRZERO(VAL(LEFT(startmonth, 2))+1, 2 ) + '01', ;
		LEFT(startmonth, 2) + STRZERO(VAL(RIGHT(startmonth, 2)) + 1, 2) )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ¡��ԡ��÷ӧҹ�����ͧ���  '
ENDI
CLOSE DATA

PROC CheckADMyy
***************************************************************
*  ������ ADMyy �����Ẻ Version 2.95                    *
***************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY '��䢵�����  ' GET startmonth DEFA SPACE(2)
@ 2,2 SAY '      �֧��     ' GET endmonth DEFA SPACE(2)
@ 3,7 SAY '�١��ͧ�������  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Y��' .AND. LASTKEY() # 27
	SELE 0
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = ipddir + 'data\adm' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			COPY TO temp STRU EXTE
			USE temp
			LOCA FOR field_name = 'ADM_W'
			IF ! EOF()
				IF field_type ='C'
					REPL field_type WITH 'N', field_len WITH 7, field_dec WITH 3 FOR field_name = 'ADM_W'
					USE
					CREAT (ipddir + 'data\temp1') FROM temp
					DELE FILE temp.dbf
					APPE FROM (dbfuse)
					DELE FILE (dbfuse)
					USE
					sourcefile = ipddir + 'data\temp1.dbf'
					targetfile = dbfuse
					RENAME &sourcefile TO &targetfile
					USE (dbfuse) EXCL
					DO Reindex WITH .F.
					WAIT WIND NOWA ' ����ç���ҧ����Ѻ������㹻�Шӻ� ADMyy �������º�������� :) '
					USE
				ELSE
					WAIT WIND NOWA ' �ç���ҧ��� ' + dbfuse + ' �١��ͧ���� '
				ENDI
			ELSE
				APPE BLANK
				REPL field_name WITH 'ADM_W', field_type WITH 'N', field_len WITH 7, field_dec WITH 3
				USE
				CREAT (ipddir + 'data\temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = ipddir + 'data\temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				DO Reindex WITH .F.
				WAIT WIND NOWA ' ����ç���ҧ����Ѻ������㹻�Шӻ� ADMyy �������º�������� =:)'
				USE
			ENDI
		ENDI
	startmonth = STRZERO(VAL(startmonth)+1, 2 )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ¡��ԡ��÷ӧҹ�����ͧ���  '
ENDI

PROC CheckCAMEyymm
***************************************************************
*  ������ CAMEyymm �����Ẻ Version 2.95                 *
***************************************************************
DEFINE WIND ask FROM 10,40 TO 16,75 SHAD
ACTI WIND ask
@ 1,2 SAY '��䢵������͹/��  ' GET startmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(startmonth)
@ 2,2 SAY '      �֧��͹/��     ' GET endmonth DEFA SPACE(4) ;
PICT '@R ##/##' VALID truemonth(endmonth)
@ 3,7 SAY '�١��ͧ�������  ' GET correct PICT '!' DEFA 'N'
READ NOLOCK
RELE WIND ask
IF correct $ 'Y��' .AND. LASTKEY() # 27
	startmonth = RIGHT(startmonth,2) + LEFT(startmonth,2)
	endmonth = RIGHT(endmonth,2) + LEFT(endmonth,2)
	IF startmonth > endmonth
		=Swap(startmonth, endmonth)
	ENDI
	DO WHIL startmonth <= endmonth
		dbfuse = opddir + 'CAME' + startmonth + '.dbf'
		IF ! FILE(dbfuse)
			?? CHR(7)
			WAIT WIND NOWA '  ��辺��� ' + dbfuse
		ELSE
			WAIT WIND NOWA ' ! �ô��� ���ѧ������ ' + dbfuse
			USE (dbfuse) ALIA in EXCL
			newcamefile = .F.
			COPY TO temp STRU EXTE
			USE temp
			LOCA FOR field_name = 'ADMWT'
			IF ! EOF()
				WAIT WIND NOWA ' �ç���ҧ��� ' + dbfuse + ' �١��ͧ���� '
			ELSE
				APPE BLANK
				REPL field_name WITH 'ADMWT', field_type WITH 'N', field_len WITH 7, field_dec WITH 3
				USE
				CREAT (opddir + 'temp1') FROM temp
				DELE FILE temp.dbf
				APPE FROM (dbfuse)
				DELE FILE (dbfuse)
				USE
				sourcefile = opddir + 'temp1.dbf'
				targetfile = dbfuse
				RENAME &sourcefile TO &targetfile
				USE (dbfuse) EXCL
				predbf = dbfuse
				DO Reindex WITH .F.
				WAIT WIND NOWA ' ����ç���ҧ���������� CAMEyymm �������º�������� '
				USE
			ENDI
		ENDI
		startmonth = IIF(RIGHT(startmonth, 2 ) = '12', ;
		STRZERO(VAL(LEFT(startmonth, 2))+1, 2 ) + '01', ;
		LEFT(startmonth, 2) + STRZERO(VAL(RIGHT(startmonth, 2)) + 1, 2) )
	ENDD
ELSE
	?? CHR(7)
	WAIT WIND NOWA '  ¡��ԡ��÷ӧҹ�����ͧ���  '
ENDI
CLOSE DATA
