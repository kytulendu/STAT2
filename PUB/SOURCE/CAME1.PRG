*** 					�к��ҹ�Ǫ����¹
*** 	�к��ҹ���·�� 2 �ҹ�����¹͡ ��Сͺ���§ҹ
***			- �ѹ�֡�����š�õ�Ǩ�����¹͡ ���Ф�չԤ
***			- �ѹ�֡�����š�ùѴ����
***			- �ѹ�֡�����š�� REFER ������
***		�����������ѡ ����� �� 3 ��� �ѧ���
***			1. ��� came     ���� ��͹
***			2. ��� appoint  ���� ��
***			3. ��� refer    ���� ��
***		��������ŷ�������� �� 6 ��� �ѧ���
***	��� patient1,contact,doctor,clinic,icd(icd10),icdcm
***	procedure ��������� ��� procedure utility
***	MEMO ��������� ��� OPDLAN
***		�������� �� 2 ������ӧҹ�����ѹ ��� ����� came1 ���
***	����� addcame ������¡��ҹ ������¡�ҡ ����� came1
***
***************************************************************
**							*  �����  CAME1  *             **
***************************************************************
PARA _pass
PRIV goon,NumMain,Chmain,ColSpace,Userright
*on error
canadmit = ADMIT = 'DISTRIBUTE'
NotUsePass = PARAMETER() = 1 .AND.  _pass
IF ! NotUsePass
	Userright = GetUser()
	cando = ('SUP' $ userright .OR. 'O' $ userright)
	IF ! cando
		=ALARM1()
		WAIT WIND NOWA '����� ! �س������Է�Էӧҹ�����¹͡'
		RETU
	ENDI
ENDI

goon = .T.
=ADIR(test,SYS(16))
fromhelp = .F.
m.clinic = ' '
*SET COLO TO &AtrScreen
CLOSE DATA
*StatInput = IIF(UPPE(GETENV('WORKSTATION'))='STAT',.T.,.F.)
col=Center(mhosp_name)
DIME LEVEL(6),OpdMess(6)
@ 0,col SAY mhosp_name COLO r+/b
OpdMess(1)='�ѹ�֡�����š�õ�Ǩ�����¹͡'
OpdMess(2)='��䢢����š�õ�Ǩ�����¹͡'
OpdMess(3)='����§ҹ��õ�Ǩ�����¹͡'
OpdMess(4)='���͡��Դ���Ҿ���������繪Ѵ���'
OpdMess(5)='�Ѵ����㹡�͹��Ѻ��ҹ'
OpdMess(6)='��Ѻ价��������ѡ  �ջѭ�ҵԴ����ٹ����������� FAX.5948630'
LEVEL(1)= '�ѹ�֡   '
LEVEL(2)= '���    '
LEVEL(3)= '����§ҹ   '
LEVEL(4)= '���Ҿ'
LEVEL(5)= '�Ѵ��.�'
LEVEL(6)= '������ѡ'
NumLEVEL=6             && �ӹǹ��¡����ѡ
CoLSpace=13
DO OpenCameDBF
DO mainscr
IF reccount('CLINIC')<16
	?? CHR(7)
	WAIT WIND '��ͧ������� STAT2 ������ʤ�չԡ��͹ ' TIME 1
	RETU
ENDI
IF reccount('WARD')<14
	?? CHR(7)
	WAIT WIND '��ͧ������� STAT2 ��������ͼ����¡�͹ ' TIME 1
	RETU
ENDI
IF RECCOUNT('DOCTOR') = 0
	?? CHR(7)
	WAIT WIND '��ͧ������� STAT2 �������ᾷ���͹ ' TIME 1
	RETU
ENDI
Chmain=1
do whil goon
	on key LABEL F1 do helpcame
	@ 2,0 SAY REPL('-',80)
	@ 21,0 SAY REPL('-',80)
	sysdate=DATE()
	thaiday=Ce2Cbe(sysdate)
	@ 1,0
	@ 1,4 SAY thaiday COLO gr+/b
	@ 22,0 CLEA
	DO title WITH '�ҹ��ͧ��Ǩ�����¹͡'
   @ 0,1
   @ 0,Center(mhosp_name) SAY mhosp_name COLO r+/b
   xx=1
   @22,0 to 24,80 clea
   DO WHIL xx<=NumLEVEL
      @ 22,1+ColSpace*(xx-1) PROMPT LEVEL(xx) MESSAGE OpdMess(xx)
      xx=xx+1
   ENDD
   MENU TO ChMain
   @3,0 to 20,80 clea
   @22,0 to 24,80 clea
   DO CASE
   	CASE ChMain=0
   		chmain = numlevel
   	CASE ChMain=1
   		DO AddCame
   	CASE ChMain=2
   		DO Changeca
	CASE ChMain=3
		DO Orp_menu
	CASE ChMain=4
		DO SeleMoni
	CASE ChMain=5
		DO In_Appo
	CASE ChMain=numlevel
		goon = .F.
		IF NotUsePass
			CLOSE DATA
			CANC
		ENDI
	OTHER
		ChMain = NumLevel
  ENDC
	do mainscr
ENDD
DO ClearScreen
RETURN

PROC OpenCameDBF
CLOSE DATA
dbfuse = codedir+'address'
USE (codedir+'address') ORDER 1 IN 0
dbfuse = codedir+'occupat'
USE (codedir+'occupat') ORDER 1 IN 0
dbfuse = patientdir+'contact'
USE (patientdir+'contact') ORDER 1 IN 0
dbfuse = patientdir+'patient2'
USE (patientdir+'patient2') ORDER 1 IN 0
dbfuse = patientdir+'patient1'
USE (patientdir+'patient1') ORDER 1 IN 0
SELE patient1
SET RELA TO hn INTO patient2
SET RELA TO hn INTO contact ADDI
dbfuse = codedir+'doctor'
USE (codedir+'doctor') ORDER 1 IN 0
dbfuse = codedir+'clinic'
USE (codedir+'clinic') ORDER 1 IN 0
dbfuse = opddir+'appoint'
USE (opddir+'appoint') ORDER 1 IN 0
dbfuse = codedir+'hospcode'
USE (codedir+'hospcode') ORDER 1 IN 0
dbfuse = codedir+'icd101'
USE (codedir+'icd101') ORDER 1 IN 0
dbfuse = codedir+'icdcm1'
USE (codedir+'icdcm1') ORDER 1 IN 0
dbfuse = patientdir+'medrec'
USE (patientdir+'medrec') ORDER 1 IN 0
dbfuse = codedir+'ward'
USE (codedir+'ward') ORDER 1 IN 0 ALIA ward
dbfuse = ipddir+'ancount'
USE  (ipddir+'ancount') IN 0 ALIA ancount
dbfuse = ipddir+'data\iptrana'
USE (ipddir+'data\iptrana') ORDER 1 IN 0 ALIA iptrana
dbfuse = codedir+'social'
USE (codedir+'social') ORDER 1 IN 0
dbfuse = codedir+'nation'
USE (codedir+'nation') ORDER 1 IN 0
dbfuse = patientdir+'countapp'
USE (patientdir+'countapp') ORDER 1 IN 0
dbfuse = patientdir+'holiday'
USE (patientdir+'holiday') ORDER 1 IN 0
dbfuse = ipddir+'cancelan'
USE (ipddir+'cancelan') ORDER 1 IN 0
dbfuse = ''
************************************************************

**********************  2 0 0  proc search month ***************
PROC SEARCH_MONTH
para mmyy
mm=month(date())
yy=MOD(YEAR(date())+543,100)
do whil .t.          && create file came
   @4,0 to 18,80 clea
   @6,5 say '���͡�����õ�Ǩ�������¾�������Ţ��͹��лվ.�.'
   @8,5 say '                             ��͹ ';
        get mm DEFA 0 PIcture '99' range 1,12
   @8,40 say '            �վ.�. ';
        get yy DEFA 0 picture '99'
   READ NOLOCK
   IF LASTKEY()=27
      return TO came1
   endi
   mmyy=alltrim(str(mm))+alltrim(str(yy))
   if len(mmyy)=3
      mmyy='0'+mmyy
   endi
   if ChMain=2
   	yymm=RIGHT(mmyy,2)+LEFT(mmyy,2)
    if ! file(opddir+'came&yymm+".dbf"')
      loop
    endi
   endi
   ask='Y'
   do confirm with ask,11,5
   if ask $ 'yY'
   @6,0 TO 11,80 CLEA
   b=val(subst(mmyy,1,2))
   @1,37 to 1,80 clear
   @1,29 say OpdMess(ChMain)+space(9)+' ��͹ '+Tmonth(b)
    else
    loop
   endi
   exit
endd

***************************    proc CONFIRM ******************
proc confirm
para s_ask,sub_row,sub_col
 @sub_row,sub_col say '��Ң����Ŷ١��ͧ ��顴��� Y ���͡� ENTER ' get s_ask
 READ NOLOCK
return s_ask
*************************** proc entry-screen ******************
proc entry_screen
@4,0 to 20,80 clea
text
      ������Ţ�������¹͡
      �����������      		          �ѹ����ҵ�Ǩ
      ���ҷ���ҵ�Ǩ                   ���ҷ���Ǩ����
   ..........................................................................
   .  DIAG/OPERATION ���1                          ����/���    ������      .
   .                                                                        .
   .  DIAG/OPERATION ���2                          ����/���    ������      .
   .                                                                        .
   .  DIAG/OPERATION ���3                          ����/���    ������      .
   .                                                                        .
   .  DIAG/OPERATION ���4                          ����/���    ������      .
   .                                                                        .
   ..........................................................................
   ���������ǡ���ѹ     �ѹ ���˹ѡ�á�Ѻ         ��. ����ᾷ�����Ǩ
   �š���ѡ��
endtext
return

******************    1 0 0   proc search_clinic   ****************
PROC search_clinic
PARA _mclinic,_clinicname
ON KEY LABEL F2 WAIT WIND NOWA '�س���ѧ�������¡������¹��չԡ��������'
DEFINE WIND clinic from 3,2 TO 19,79 SHADOW CLOSE
PRIVATE text_va3
SELE clinic
end_clinic= .t.
@22,1 say '�� [F1]��ҵ�ͧ��� ��͸Ժ��  '
@22,50 say '  �� [ESC] ��ҵ�ͧ���¡��ԡ'
ACTI WIND clinic
do whil end_clinic         && loop clinic

	@ 1,5 SAY '��������ʤ�չԤ����ҵ�Ǩ '  get text_va3 DEFA '   ' PICT '@!'
	READ NOLOCK
	IF LASTKEY()=27 .OR. EMPTY(text_va3)
		DEAC WIND clinic
		return to came1
	endi
	IF LEN(TRIM(text_va3)) = 2
		?? CHR(7)
		WAIT WIND NOWA '���ʤ�չԤ�����¹͡��ͧ������ú��� 3 ��ѡ'
	ELSE
		SET ORDER TO 1
		IF ! SEEK(text_va3)
			?? CHR(7)
			WAIT '��辺���ͤ�չԤ����ҵ�Ǩ' WIND NOWAIT
		ELSE
			@ 1,37 say name               && �������ͤ�չԤ
			ask='Y'
			do confirm with ask,8,5
			IF ask $ 'yY'
				DEAC WIND clinic
				h_name=mhosp_name + ' ��չԤ '+alltrim(name)
				h_name=rtrim(h_name)
				wide=(80-len(h_name))/2
				@ 0,0
				@ 0,wide say h_name
				end_clinic= .f.
			ENDI
		ENDI
	ENDI
endd                 && end loop clinic
STOR clinic TO _mclinic,nowclinic,dummyclinic,m.clinic
_clinicname = name
STOR name to mclinic
ON KEY LABEL F2 DO search_clinic
@22,1 say '�� [F1]��ҵ�ͧ��� ��͸Ժ��        [F2] ����¹��չԤ '
return

******             �ش������� �ͧ FUNCTION ��ҧ�  *******
FUNC CHECKTIMEOUT
PARA _time
IF LASTKEY() = 5 .OR. LASTKEY() = 19
	_CUROBJ = _CUROBJ - 1
ELSE
	min=VAL(LEFT(mt_in,2))*60+VAL(RIGHT(mt_in,2))
	mout=VAL(LEFT(_time,2))*60+VAL(RIGHT(_time,2))

* mout=IIF(VAL(LEFT(_time,2))=0 .AND. min>1379,24*60,VAL(LEFT(_time,2))*60+VAL(RIGHT(_time,2)))
	DO CASE
		CASE RIGHT(_time,2)>'59' .OR. LEFT(_time,2)>'24'
			?? CHR(7)
			_CUROBJ=_CUROBJ
		CASE mout < min
			IF min - mout < 12*60
				?? CHR(7)
				_CUROBJ=_CUROBJ
			ELSE
				mout = 24*60+mout
			ENDI
	ENDC

* IF (mout<min .AND. .OR. RIGHT(_time,2)>'59' .OR. LEFT(_time,2)>'24'
*	?? CHR(7)
*  _CUROBJ=_CUROBJ
* ENDI
ENDI

FUNC CHECKTIMEIN
PARA _time
IF RIGHT(_time,2)>'59' .OR. LEFT(_time,2)>'24'
	?? CHR(7)
	_CUROBJ=_CUROBJ
ENDI


FUNC CHECKICD1         		&& ��Ǩ�ͺ����� ICD ����������
PARA _icd
_mx='m'+VARREAD()
_x=RIGHT(_mx,1)
mf1='icd101'
mf2='icd102'
mf3='icd103'
IF ! USED('ICD102')
	dbfuse = codedir+'icd102'
	USE (codedir+'icd102') ORDER 1 IN 0
ENDI
IF ! USED('ICD103')
	dbfuse = codedir+'icd103'
	USE (codedir+'icd103') ORDER 1 IN 0
ENDI
IF ! USED('ICDCM1')
	dbfuse = codedir+'icdcm1'
	USE (codedir+'icdcm1') ORDER 1 IN 0
ENDI
IF ! USED('ICDCM2')
	dbfuse = codedir+'icdcm2'
	USE (codedir+'icdcm2') ORDER 1 IN 0
ENDI
IF ! USED('ICDCM3')
	dbfuse = codedir+'icdcm3'
	USE (codedir+'icdcm3') ORDER 1 IN 0
ENDI
dbfuse = ''
IF ! EMPTY(_icd)
	IF ISDIGIT(SUBS(_icd,2,1)) .OR. LEN(TRIM(_icd))=1
		IF LEFT(_icd,1)='*' .OR. ISDIGIT(_icd)
			_icd=IIF(ISDIGIT(_icd),LEFT(_icd,4),SUBS(_icd,2,4))
			mf1='icdcm1'
			mf2='icdcm2'
			mf3='icdcm3'
		ELSE
			mf1='icd101'
			mf2='icd102'
			mf3='icd103'
		ENDI
		_seek=ALLTRIM(_icd)
		_seek=IIF(LEN(_seek)>5,LEFT(_seek,5),_seek)
		_seek = IIF(mf1='icdcm1',LEFT(_seek,4),_seek)
		_seek=IIF(LEN(_seek)<3,_seek+SPAC(3-LEN(_seek)),_seek)
		slen=LEN(_seek)-1
		SELE (mf1)
		SET ORDER TO 1
		IF ! SEEK(_seek)
			success=.F.				&& �����ʷ�������辺
			FOR i = slen TO 1 STEP -1	&& Loop ���¡�õѴ����Ǩ������ 1 ���
				_seek=LEFT(_icd,i)
				IF SEEK(_seek)
					success=.T.		&& �����ʷ����辺����
					_prompt=sicd1(code+SPACE(3)+desc)
					FOR n = i+1 TO 3	&& ����ҡ��Ҥ�����Ǣͧ���� ���¡��� 4 ��������������ա
						_seek=LEFT(_prompt,n)
						IF SEEK(_seek)
							_prompt=sicd1(code+SPACE(3)+desc)
						ELSE
							EXIT
						ENDI
					NEXT
					EXIT
				ENDI
			NEXT
			IF success
				_icd=LEFT(_prompt,LEN(code))
				_icd=ShowICD(_icd)
				&_mx=SUBS(_prompt,LEN(code)+4,60)
				IF LEFT(_icd,1)='*'
					_CUROBJ=_CUROBJ+2
				ENDI
			ELSE
	            ?? CHR(7)
				WAIT '����������ä���  '+_icd  WIND NOWAIT
				_CUROBJ=_CUROBJ
			ENDI
		ELSE
			_icd=ShowICD(code)
			&_mx=LEFT(desc,60)
			IF LEFT(_icd,1)='*'
				_CUROBJ=_CUROBJ+2
			ENDI
		ENDI
	ELSE
		IF LEFT(_icd,1)='*'
			_icd=SUBS(_icd,2)
*		DO openicdcm
			mf1='icdcm1'
			mf2='icdcm2'
			mf3='icdcm3'
		ENDI
		SELE (mf1)
		mprompt=Keyword(_icd)
		IF ! EMPTY(mprompt)
			SELE (mf1)
			IF LASTKEY()#27
				_icd=LEFT(mprompt,LEN(code))
				_icd=Showicd(_icd)
				&_mx=SUBS(mprompt,LEN(code)+4,60)
				IF LEFT(_icd,1)='*'
					_CUROBJ=_CUROBJ+2
				ENDI
			ENDI
		ELSE
			IF ! USED('shorticd')
				dbfuse = patientdir+'shorticd'
				IF ! FILE(patientdir+'shorticd.dbf')
					SELE 0
					CREA TABLE (patientdir+'shorticd') ;
					(code C(7), desc C(60), type C(1), date C(4))
					INDEX ON UPPE(desc) TAG desc
					INDEX ON code TAG code ADDI
					USE
				ENDI
				USE (patientdir+'shorticd') ORDER 1 IN 0
				dbfuse = ''
			ENDI
			SELE shorticd
			mtag = IIF(LEFT(_icd,1)='#','code','desc')	&& �������������� ���� ����
			SET ORDER TO TAG (mtag)
			mseek = IIF( LEFT(_icd,1)='#',TRIM(_icd),_icd)
			IF ! SEEK(mseek)
				SET ORDER TO TAG desc	&& ����Ҵ٨ҡ����
				IF SEEK(TRIM(_icd))		&& �Ҿ��������繪����ä
					_trimicd = TRIM(_icd)
					icdlen = LEN(_trimicd)
					DIME ProvArr(100)
					xx=1
					DO WHIL UPPE(LEFT(desc,icdlen)) = _trimicd .AND. ! EOF()
						IF xx >100
							DIME ProvArr(xx)
						ENDI
						ProvArr(xx)=desc
						xx=xx+1
						SKIP
					ENDD
					IF xx > 2 	&& �ժ��ͤ���¡ѹ�ҡ���� 1 ����
						mchoice=0
						SET CONF ON
						@  10,20 MENU ProvArr,xx-1,10
						READ MENU TO mchoice
						SET CONF OFF
						IF mchoice = 0  && User ������ [Esc]
							= TONE(1200,5)
							=TONE(700,5)
							DEFINE WIND addname FROM 10,10 TO 17,70 SHAD
							ACTI WIND addname
							@ 1,2 SAY '��ͧ����������� '+TRIM(_icd)+' ���������������'
							@ 4,10 SAY '��������� ' GET yesno DEFA 'N' PICT '!'
							READ NOLOCK
							RELE WIND addname
							IF yesno $ 'Y��'
								SET ORDER TO TAG code
								SEEK '#'
								m.code = IIF( LEFT(code,1)='#', '#'+STR(VAL(SUBS(code,2))-1,4),;
								'#'+'9999')
								GO TOP
								IF ! EMPTY(code) .OR. BOF()
									APPE BLAN
								ENDI
								REPL code WITH m.code, desc WITH _icd, type WITH '1',;
								date WITH yy+mm
								FLUSH
								&_mx = _icd
								_icd = m.code
							ELSE
								_CUROBJ = _CUROBJ
								RETU
							ENDI
						ENDI
						SKIP mchoice-xx
					ELSE
						SKIP -1
					ENDI
					_icd = ShowICD(code)
					&_mx = LEFT(desc,60)
					REPL type WITH IIF( type>'1', '2', '1')
					FLUSH
					IF LEFT(_icd,1)='*'
						_CUROBJ=_CUROBJ+2
					ENDI
				ELSE		&& �ѧ����ժ����������ª������
					= TONE(1200,5)
					=TONE(700,5)
					DEFINE WIND addname FROM 10,10 TO 17,70 SHAD
					ACTI WIND addname
					@ 1,2 SAY '��ͧ����������� '+TRIM(_icd)+' ���������������'
					@ 4,10 SAY '��������� ' GET yesno DEFA 'N' PICT '!'
					READ NOLOCK
					RELE WIND addname
					IF yesno $ 'Y��'
						SET ORDER TO TAG code
						SEEK '#'
						m.code = IIF( LEFT(code,1)='#', '#'+STR(VAL(SUBS(code,2))-1,4),;
						'#'+'9999')
						GO TOP
						IF ! EMPTY(code) .OR. BOF()
							APPE BLAN
						ENDI
						REPL code WITH m.code, desc WITH _icd, type WITH '1',;
						date WITH yy+mm
						FLUSH
						&_mx = _icd
						_icd = m.code
					ELSE
						_CUROBJ = _CUROBJ
					ENDI
				ENDI
			ELSE
				_icd = ShowICD(code)
				&_mx = LEFT(desc,60)
				REPL type WITH IIF( type>'1', '2', '1')
				FLUSH
				IF LEFT(_icd,1)='*'
					_CUROBJ=_CUROBJ+2
				ENDI
			ENDI
		ENDI
	ENDI
	IF mf1='icdcm'
*	DO openicd10
		mf1='icd101'
		mf2='icd102'
		mf3='icd103'
	ENDI
ELSE
	IF LASTKEY()#5
		_icd=SPACE(20)
		&_mx=SPAC(60)
	ENDI
ENDI
SHOW GETS

PROC Keyword
PARA word
_wret=SPAC(LEN(word))
mkwd=rtrim(word)
dimension tmpdg(1)
select (mf3)
set order to tag desc
IF  seek(mkwd)
	num=1
	do while UPPE(desc)=mkwd
		dimension tmpdg(num)
		tmpdg(num)=desc
		num=num+1
		SKIP
	enddo
	choice=''
	DEFINE WIND sicd FROM 1,1 TO 23,78 SHAD
	ACTI WIND sicd
	lastkey=27
	@ 5,5 get choice from tmpdg &&color n/w,w+/n,w+/bg
	KEYB "{HOME}"
	READ NOLOCK
	IF LASTKEY()=27
		_CUROBJ=_CUROBJ
		RELE WIND sicd
		RETU
	ENDI
	CLEA
	set order to tag desc
	seek UPPE(choice)
	mcode=kwcode

*** ADD HERE ****
	select (mf2)
	set order to tag kwcode
	seek mcode
	num=0
	do while mcode=kwcode
		num=num+1
		dimension tmp(num)
		tmp(num)=code
		SKIP
	enddo
	select (mf1)
	set order to tag code

	for i=1 to alen(tmp)
		seek(LEFT(alltrim(tmp(i)),3))
		if !empty(text)
			tmp(i)=code+' * '+rtrim(desc)
		else
			tmp(i)=code+'   '+rtrim(desc)
		endif
	endfor
	num=alen(tmp)
*	set color to w+/b
	ftr='  ������ [F2] ���ʹ٢������������  '
	DEFINE POPUP sicd COLO r+/bg+,w+/n SHAD FOOT ftr FROM 0,1 TO 10,75
	for ii=1 to num
		DEFINE BAR ii OF sicd PROMPT padr(tmp(ii),70,' ')
	endfor
	mcode1=spac(3)
	_seek=space(4)
	keyf2=ON('KEY','F2')
	ON KEY LABEL F2 DO ShwMemo4 WITH PROMPT()
	ON SELE POPUP sicd DO  Sele_sicd WITH PROMPT(),_seek
	mkey=27
	DO WHIL mkey=27
		ACTI POPUP sicd
		mkey=lastkey()
	ENDD
	ON KEY LABEL F2 &keyf2
	_seek=LEFT(_seek,3)
	select (mf1)
	IF !seek(_seek)			&& expecting X99
		?? chr(7)
		wait 'WARNING : This code is currently NOT in the ICD files!' window timeout 1
	else
		_wret=Sicd1(code+SPACE(3)+desc)
	ENDI
	RELE WIND sicd
ENDI
select (mf3)
SET ORDER TO 1
select (mf2)
SET ORDER TO 1
select (mf1)
SET ORDER TO 1
RETU _wret

FUNC SHOWICD
PARA _showicd
IF ISDIGIT(_showicd) .OR. LEFT(_showicd,1)='*'
	RETU IIF(ISDIGIT(_showicd),'*'+_showicd+' '+SPAC(14),_showicd+SPAC(15))
ELSE
	_showicd= IIF(LEFT(_showicd,1)='#',_showicd,LEFT(_showicd,3)+;
	IIF(ISDIGIT(SUBS(_showicd,4,1)),'.','')+SUBS(_showicd,4))
	RETU _showicd+SPAC(20-LEN(_showicd))
ENDI

FUNC FINDICD
PARA _find
DIME tempicd(100),tempname(100)
PRIVATE xx,mchoice
xx=1
WAIT '���ѧ���Ң��������� ��سҤ���ѡ����' WIND NOWA
SET ORDER TO 0
SCAN FOR TRIM(_find)$name
	TempName(xx)=name
	TempICD(xx)=RECNO()
	xx=xx+1
	IF xx>100
		EXIT
	ENDI
ENDS
SET ORDER TO 1
IF xx=1 .OR. xx>100
	GO BOTT
	SKIP
	?? CHR(7)
	IF xx=1
		WAIT '����������ä����С������ '+_find WIND NOWAIT
	ELSE
		WAIT '��þ���������ǡ��ҹ�� �ժ��ͷӹͧ����ҡ�Թ�' wind nowait
	ENDI
	_CUROBJ=_CUROBJ
ELSE
	?? CHR(7)
	WAIT WIND '�������� �ԭ���͡��������' NOWA
	mchoice=0
	SET CONF ON
	DO WHIL mchoice=0
		@  10,20 MENU TempName,xx-1,10
		READ MENU TO mchoice
	ENDD
	SET CONF OFF
	GO TempICD(mchoice)
ENDI

FUNC ENTRYICD
PARA _oldicd,_newicd
IF EMPTY(_oldicd)
	_newicd=SPAC(60)
ELSE
	_newicd=con_icd(_newicd)
	_newicd=LEFT(_newicd+SPAC(60),60)
ENDI
SHOW GETS
*RETU IIF(_oldicd='     ',.F.,.T.)
RETU ! EMPTY(_oldicd)

FUNC CHECKHN
PARA _hn
IF EMPTY(_hn)
	CLEAR READ
ELSE
	_hn=PADZERO(_hn,7)
	SELE patient1
	SET ORDER TO TAG hn
	IF ! SEEK(_hn)
		?? CHR(7)+CHR(7)
		WAIT '����ռ����������Ţ '+_hn WIND NOWAIT
		m.found=.F.
	ELSE
		m.found=.T.
	ENDI
	ptname=de_name(name)
ENDI
SHOW GETS

FUNC MINUTEIN		&& �ӹǳ���ҷ�����繹ҷ�
PARA _time
RETU VAL(LEFT(_time,2))*60+VAL(RIGHT(_time,2))

FUNC MINUTEOUT		&& �ӹǳ���ҷ���Ǩ�����繹ҷ�
PARA _time
IF _time < mt_in
	RETU 24*60+VAL(LEFT(_time,2))*60+VAL(RIGHT(_time,2))
ELSE
	RETU VAL(LEFT(_time,2))*60+VAL(RIGHT(_time,2))
ENDI

FUNC EPISODE
PARA _episode,_varread
_varread=VARREAD()
_x=RIGHT(_varread,1)
_check=IIF(BETWEEN(LEFT(mdiag&_x,3),'Z23','Z27'),'12345','123')
IF LASTKEY()#5
	IF ! _episode $ _check
		?? CHR(7)
		WAIT '��� 1=����������  2=��������� �ä����  3=������ Follow up' WIND NOWAIT
		_CUROBJ=_CUROBJ
	ELSE
		IF USED('newcase')
			SELE newcase
			IF SEEK(m.hn) .AND. ! BETWEEN(LEFT(mdiag&_x,3),'Z23','Z27') ;
			.AND. _episode = '1' .AND. VISITED
				=ALARM1()
				WAIT WIND NOWA '�����������ç��Һ������ ��� 1 �����'
				_CUROBJ=_CUROBJ
			ENDI
		ENDI
	ENDI
ENDI

FUNC SEX
PARA _sex
IF LASTKEY()#5
	IF ! _sex $ '12'
		?? CHR(7)
		WAIT '����������  1 = ���      2 = ˭ԧ  ' WIND NOWAIT
		_CUROBJ=_CUROBJ
	ELSE
		IF _sex#' '
			@ row(),col()+3 SAY IIF(_sex='1','���','˭ԧ')
		ENDI
	ENDI
ENDI

FUNC INPROVINCE
PARA _inprovince
IF LASTKEY()#5
	IF ! _inprovince $ '01'
		?? CHR(7)
		WAIT '����������  1 = �ࢵ�ѧ��Ѵ     0 = �͡ࢵ�ѧ��Ѵ  ' WIND NOWAIT
		_CUROBJ=_CUROBJ
	ELSE
		IF _inprovince#' '
			@ row(),col()+3 SAY IIF(_inprovince='1','�ࢵ�ѧ��Ѵ','�͡ࢵ�ѧ��Ѵ')
		ENDI
	ENDI
ENDI

FUNC AGE
PARA _age
DO CASE
	CASE LEFT(_age,1)='1'
		IF VAL(SUBS(_age,2))<=0
			?? CHR(7)
			WAIT '�����繻�  ��ͧ������ҧ���� 1 �բ���  ' WIND NOWAIT
			_CUROBJ=_CUROBJ
		ENDI
	CASE LEFT(_age,1)='2'
		IF ! BETWEEN(VAL(SUBS(_age,2)),1,11)
			?? CHR(7)
			WAIT '��������͹  ��ͧ��������ҧ 1 �֧ 11  ' WIND NOWAIT
			_CUROBJ=_CUROBJ
		ENDI
	CASE LEFT(_age,1)='3'
		IF ! BETWEEN(VAL(SUBS(_age,2)),1,29)
			?? CHR(7)
			WAIT '�������ѹ   ��ͧ��������ҧ 1 �֧ 29  ' WIND NOWAIT
			_CUROBJ=_CUROBJ
		ENDI
	CASE LEFT(_age,1)=' '
	OTHER
		?? CHR(7)
		WAIT '����������  1XX = ��      2XX = ��͹  3xx = �ѹ ' WIND NOWAIT
		_CUROBJ=_CUROBJ
ENDC

FUNC HIDEWIN
PARA _hidewin
IF WVISIBLE(_hidewin)
	HIDE WIND &_hidewin
ENDI
RETU .T.


PROC FORREFER
DEFINE WIND win1 FROM 6,2 TO 19,78 SHAD
ACTI WIND win1
m.time=IIF(EMPTY(m.time),patient1.time,m.time)
m.time=IIF(EMPTY(m.time),LEFT(TIME(),2)+SUBS(TIME(),4,2),m.time)
@ 1,3 say '���ҷ���Ѻ refer     ' get m.time  PICT '@R ##:##';
valid TimeRefer(m.time) mess '��������繪������ �ҷ�'
@ 3,3 SAY '����ʶҹ��ԡ�÷�� refer ' get m.place VALID ;
hospital(m.place,referinplace) pict '@!'
@ 4,3 GET referinplace DISA
@ 6,3 say '�˵ؼŷ�� Refer ' get m.cause VALID CheckCause(m.cause)
@ 10,20 SAY '�����Ŷ١��ͧ������� ' GET m.correct DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
READ NOLOCK
m.type='1'
RELE WIND win1

PROC FORREFEROUT
DEFINE WIND win1 FROM 6,2 TO 19,78 SHAD
ACTI WIND win1
outtime=IIF(empty(outtime),LEFT(TIME(),2)+SUBS(TIME(),4,2),outtime)
@ 1,3 say '���ҷ���� refer   ' get outtime PICT '@R ##:##';
valid TimeRefer(outtime) mess '��������繪������ �ҷ�'
@ 3,3 SAY '����ʶҹ��ԡ�÷�� refer ' get outplace pict '@!' ;
VALID Hospital(outplace,referoutplace)
@ 4,3 GET referoutplace DISA
@ 6,3 say '�˵ؼŷ���� refer ' get outcause VALID CheckCause(outcause)
@ 10,20 SAY '�����Ŷ١��ͧ������� ' GET m.correct DEFA 'Y';
PICT '!' VALID CheckCorrect(m.correct)
READ NOLOCK
outtype='2'
RELE WIND win1

FUNC CHECKREM
PARA _check
IF LASTKEY()>27 .OR. LASTKEY() = 13
	IF ! _check	$ '1234' .OR. LASTKEY()=28
		?? CHR(7)
		WAIT '1=�ҵ���Ѵ  2=���ͧ   3=�Ѻ Consult  4=�Ѻ Refer' WIND NOWA
		_CUROBJ=_CUROBJ
	ELSE
		IF _check $ '34'
			IF _check='3'
				SELE camefile
				SET ORDER TO 1
				IF SEEK(m.hn)
					seekrec=0
					DO WHIL hn=m.hn
						IF result # '54' .OR. sequence#1 .OR. date#BE2CE(mdate)
							SKIP
						ELSE
							EXIT
						ENDI
					ENDD
				ENDI
				IF hn#m.hn
					?? CHR(7)
					WAIT '����ա�� Consult �Ţ�������� '+m.hn WIND NOWAIT
				ELSE
					mdiag1=diag
					SELE icd101
					SEEK mdiag1
					mmdiag1=desc
					SHOW GETS
				ENDI
			ELSE
				DO ForRefer
			ENDI
		ENDI
	ENDI
ENDI

FUNC CHECKRESULT
PARA _check
IF LASTKEY()>27 .OR. LASTKEY() = 13
	resultcode='01,02,03,04,05,06,07,08,09,10,11,12,14,51,52,53,54,ZZZ'
	IF ! _check $ resultcode .OR. LASTKEY()=28
		?? CHR(7)
		define window instr from 1,0 to 12,78 shadow title ;
		'   ���ʼš�õ�Ǩ�ѡ��  ' COLO bg+/gr+
		msg2='���������á������ͷӧҹ���'
		activate window instr
		@ 0,1 say '01 = �Ѻ���Ἱ�����á���      02 = �Ѻ���Ἱ����¡���'
		@ 1,1 say '03 = �Ѻ���Ἱ��ٵԡ���       04 = �Ѻ���Ἱ�����Ǫ����'
		@ 2,1 say '05 = �Ѻ���Ἱ�������Ǫ����   06 = �Ѻ���Ἱ��� �� ��١'
		@ 3,1 say '07 = �Ѻ���Ἱ��ѡ��          08 = �Ѻ���Ἱ����¡�����д١'
		@ 4,1 say '09 = �Ѻ���Ἱ��Ե�Ǫ         10 = �Ѻ���Ἱ��ѧ���Է��'
		@ 5,1 say '11 = �Ѻ���Ἱ��ѹ�����       12 = �Ѻ���Ἱ���� �'
		@ 6,1 SAY '14 = �Ѻ��� Observe'
		@ 7,1 SAY '51 = ��Ǩ��С�Ѻ��ҹ          52 = ��·���;մ�'
		@ 8,1 SAY '53 = Consult                  54 = Refer'
		@ 9,Center(msg2) say msg2 color g+/gr+
		wait '' window TIMEOUT 30
		release window instr
		_CUROBJ=_CUROBJ
	ELSE
		IF _check ='54'
			DO ForReferOUT
		ENDI
		IF _check = '53'
			DEFINE WIND medrec FROM 12,20 TO 17,60 SHAD
			ACTI WIND medrec
			@ 1,3 SAY '�觻�֡�ҷ���չԤ ' GET m.con_clinic VALID ;
			CheckClinic(m.con_clinic,mcon_clinic)
			@ 2,3 GET mcon_clinic DISA COLO ,,,,,,,,,/w
			READ NOLOCK
			RELE WIND medrec
		ENDI
	ENDI
ENDI

********************************
FUNC EditTimein
para iotime
if iotime='2400'
   retu
endi
if len(iotime)=4)
   if ! between(left(iotime,2),0,23) .and. !between(right(iotime,2),0,59)
   	??chr(7)
   	_curobj=-curobj
   ENDI
endi

FUNC AskYear
DEFI WIND askyear FROM 10,15 TO 14,65 COLO gr+/bg+ SHAD
ACTI WIND askyear
@ 1,3 SAY '��س����վط��ѡ�Ҫ����ͧ���  ' GET _myear DEFA ;
RIGHT(STR(YEAR(DATE())+543),2) PICT '99'
READ NOLOCK
RELE WIND askyear
RETU _myear

PROC MAINSCR
@ 3,0 CLEA TO 20,80
@ 2,0
TEXT
                          ���������Ѻ�ҹ��ͧ��Ǩ�����¹͡
                                OPD  Version <<statversion>>
                                 ��з�ǧ�Ҹ�ó�آ
ENDTEXT
? SPAC(Center(programdate))+programdate

PROC WORKSCR
TEXT
                               ��зӧҹ�Ѳ�������
    ���ᾷ���д�ɰ�  ǧ�줳��ѵ����        �ç��Һ�����ͧ��ط�
    ���ᾷ��Ե�      �Ѳ��Ө�              �ç��Һ�������ɮ��
    ���ᾷ��͹��Ѳ��  ����صԡ��            ʶҺѹ�Ԩ���к��Ҹ�ó�آ
    ���ᾷ�����ѵ��   ��������侺����       �ç��Һ����þ�Է�Ի��ʧ�� �غ��
    ���ᾷ���ط�����  ����ǧ                �ç��Һ���ʹ� ��ظ��
    ���ᾷ�����      ʡ�žҳԪ��           �ç��Һ�ž�оط��ҷ ��к���
    �ҧ��ǹԵ��       ����ɪ�¹��ó�        ʶҺѹ�Ҫ�ѯ �ǹ�عѹ��
    �ҧ��������       �ԧ������ҧ           ����Ҹ�ó�آ��ʵ�� ��Դ�
    �ҧ�������ó�     ����๵�              �ӹѡ෤��������ʹ��
    �ҧ��ɳ���        ���õ���������       �ͧ�ç��Һ�������Ҥ
����֡��... ���ᾷ���تҵ� �óʶҾ�        �ç��Һ�����ҸԺ��
��Ѻ��ا��... �����Թ��� �Ԣ�Թ��ҹ���     �ç��Һ�������� ���
             ��.�ش�⪤ ����ѧ  �ç��Һ�����稾���ѧ��Ҫ ͧ���� 17 �ؾ�ó����
ENDTEXT

FUNC OPENFILE
PARA _file1,_file2,_file3,_file4
PRIV numpara
numpara = PARAMETERS()
mat = AT('\',_file1)
nickname = _file1
DO WHIL mat > 0
	nickname = SUBS(nickname,mat+1)
	mat = AT('\',nickname)
ENDD
IF _file1 = patientdir+'patient1'
	IF ! USED('patient2')
		SELE 0
		dbfuse = patientdir+'patient2'
		USE (patientdir+'patient2') ORDER 1
	ENDI
	IF ! USED('CONTACT')
		SELE 0
		dbfuse = patientdir+'contact'
		USE (patientdir+'contact') ORDER 1
	ENDI
	IF ! USED('PATIENT1')
		SELE 0
		dbfuse = patientdir+'patient1'
		USE (patientdir+'patient1') ORDER 2
	ENDI
	SELE patient1
	SET RELA TO hn INTO patient2
	SET RELA TO hn INTO contact ADDI
	IF USED('NEWCASE')
		SET RELA TO hn INTO newcase ADDI
	ENDI
ELSE
	IF ! USED(nickname)
		SELE 0
		dbfuse = _file1
		USE (_file1)
		IF FILE(_file1+'.cdx')
			SET ORDER TO 1
		ENDI
	ENDI
	SELE (nickname)
ENDI
dbfuse = ''
FOR f = 2 TO numpara
	ff = STR(f,1)
	nickname = _file&ff
	mat = AT('\',nickname)
	DO WHIL mat > 0
		nickname = SUBS(nickname,mat+1)
		mat = AT('\',nickname)
	ENDD
	IF ! USED(nickname)
		SELE 0
		dbfuse = _file&ff
		USE (_file&ff)
		IF FILE(_file&ff+'.cdx')
			SET ORDER TO 1
		ENDI
	ENDI
	SELE (nickname)
NEXT
dbfuse = ''
FUNC CheckObj
=HideWin('win1')
IF goobj > 1
	?? CHR(7)
	_CUROBJ=goobj
ENDI

FUNC CAMEDATE
PARA _bedate,_mm,_yy
IF LASTKEY() = 5 .OR. LASTKEY() = 19
	_CUROBJ = _CUROBJ - 1
ELSE
	DO CASE
		CASE ! TRUEDATE(_bedate)
			?? CHR(7)
			WAIT WIND NOWA '����ѹ���������������ԧ ��س��������'
			_CUROBJ = _CUROBJ
		CASE  SUBS(_bedate,4,2) # _mm
			?? CHR(7)
			WAIT WIND NOWA '�����͹���ç�Ѻ������ӧҹ���� ��س��������'
			_CUROBJ = _CUROBJ
		CASE  RIGHT(_bedate,2) # _yy
			?? CHR(7)
			WAIT WIND NOWA '�������ç�Ѻ������ӧҹ���� ��س��������'
			_CUROBJ = _CUROBJ
		CASE  BE2CE(_bedate) > DATE()
			?? CHR(7)
			WAIT WIND NOWA '����ѹ��ǧ˹��������Ѻ ��س��������'
			_CUROBJ = _CUROBJ
	ENDC
ENDI

FUNC CHECKICD3
PARA _icd
_mx='m'+VARREAD()
_x=RIGHT(_mx,1)
IF ! EMPTY(_icd)
	IF ISDIGIT(_icd) .OR. LEFT(_icd,1)='*'
		SELE icdcm1
	ELSE
		SELE icd101
	ENDI
	SET ORDER TO 1
	IF ! SEEK(TRIM(_icd))
		?? CHR(7)
		WAIT WIND NOWA '��������� '+_icd
		_CUROBJ = _CUROBJ
	ELSE
		_icd=ShowICD(code)
		&_mx=LEFT(desc,60)
		IF LEFT(_icd,1)='*'
			_CUROBJ=_CUROBJ+2
		ENDI
	ENDI
ENDI
SHOW GETS

PROC ASKEMER
		DEFINE WIND win1 FROM 10,2 TO 15,78 SHAD
			ACTI WIND win1
			CLEA
			SELE ward
			SET ORDER TO TAG clinic
			m.dep=IIF(m.result < '13',m.result,m.dep)
*			_CUROBJ = IIF(m.result < '13',3,1)
			SEEK m.dep
			mward = name
			SELE camefile
			@ 1,1 SAY '�繤���Ἱ� ' GET m.dep DEFA '  ' WHEN ;
			Inputward(m.dep) VALID CheckDep(m.dep,mward)
			@ 1,20 GET mward DISA COLO ,,,,,,,,,/w
*			IF LEFT(m.clinic,2)='13'
*				m.emergency = .T.
				@ 2,3 SAY '�繤���ء�Թ������� ' GET m.emergency PICT 'Y'
				@ 3,3 SAY '�������ͧ���      ' GET m.forensic DEFA ' ' PICT '#'
*			ENDI
			READ NOLOCK
