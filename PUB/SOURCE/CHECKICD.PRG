PARA _icd
_KeyPress = LASTKEY()
_mx='M'+VARREAD()
_x=RIGHT(_mx,1)
mf1='icd101'
mf2='icd102'
mf3='icd103'
IF ! USED('ICD101')
	dbfuse = codedir+'icd101'
	USE (codedir+'icd101') ORDER 1 IN 0
ENDI
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
IF ! EMPTY(_icd)
	_icd = IIF(LEFT(_mx,5)='MOPER' .AND. LEFT(_icd,1)#'*','*'+_icd,_icd)
	IF ISDIGIT(SUBS(_icd,2,1)) .OR. LEN(TRIM(_icd))=1
		IF LEFT(_icd,1)='*' .OR. ISDIGIT(_icd)
			_icd=IIF(ISDIGIT(_icd),LEFT(_icd,4),SUBS(_icd,2,4))
			mf1='icdcm1'
			mf2='icdcm2'
			mf3='icdcm3'
		ELSE
* udc
			IF LEFT(_icd,1) $ 'VWXYvwxy' .and. _x = '1'
				?? CHR(7)
				WAIT WIND ' ����ҡ�úҴ�纷��˹ѡ����ش���ä�á' + CHR(13) + ;
				' ���˵آͧ��úҴ�� (��鹵鹴��� V, W, X, Y) ���������ѹ�Ѻ��ѧ' NOWAIT
				_Curobj = _Curobj
				Return
* udc
				mf1='icd101'
				mf2='icd102'
				mf3='icd103'
			ENDIF && udc
		ENDI
		_seek=ALLTRIM(_icd)
		_seek=IIF(LEN(_seek)>5,LEFT(_seek,5),_seek)
		_seek = IIF(mf1='icdcm1',LEFT(_seek,4),_seek)
		_seek=IIF(LEN(_seek)<3,_seek+SPAC(3-LEN(_seek)),_seek)
		slen=LEN(_seek)-1
		IF LEFT(_seek,1)='#'
			SELE shorticd
			SET ORDER TO TAG code
			IF ! SEEK(_seek)
				=ALARM1()
				WAIT WIND NOWA '��辺�����ä '+_seek
				_CUROBJ = _CUROBJ
			ELSE
				_icd=ShowICD(code)
				&_mx=LEFT(desc,60)
				IF LEFT(_icd,1)= '*' .AND. _KeyPress # 5
					_CUROBJ=_CUROBJ+2
				ENDI
			ENDI
		ELSE
			SELE (mf1)
			SET ORDER TO 1
			IF ! SEEK(UPPE(_seek))
				success=.F.				&& �����ʷ�������辺
				FOR i = slen TO 1 STEP -1	&& Loop ���¡�õѴ����Ǩ������ 1 ���
					_seek=UPPE(LEFT(_icd,i))
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
					IF LEFT(_icd,1)='*' .AND. _KeyPress # 5
						_CUROBJ=_CUROBJ+2
					ENDI
				ELSE
	    	        ?? CHR(7)
					WAIT '����������ä���  '+TRIM(_icd)  WIND NOWAIT
					_CUROBJ=_CUROBJ
				ENDI
			ELSE
				_icd=ShowICD(code)
				&_mx=LEFT(desc,60)
				IF LEFT(_icd,1)='*' .AND. _KeyPress # 5
					_CUROBJ=_CUROBJ+2
				ENDI
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
		mprompt=IIF( notkeyword == 'YES',SPACE(5), Keyword(uppe(_icd)) )
		IF ! EMPTY(mprompt)
			SELE (mf1)
			IF LASTKEY()#27
				_icd=LEFT(mprompt,LEN(code))
				_icd=Showicd(_icd)
				&_mx=SUBS(mprompt,LEN(code)+4,60)
				IF LEFT(_icd,1)='*' .AND. _KeyPress # 5
					_CUROBJ=_CUROBJ+2
				ENDI
			ENDI
		ELSE
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
					DO WHIL LEFT(desc,icdlen) = _trimicd .AND. ! EOF()
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
					IF LEFT(_icd,1)='*' .AND. _KeyPress # 5
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
				IF LEFT(_icd,1)='*' .AND. _KeyPress # 5
					_CUROBJ=_CUROBJ+2
				ENDI
			ENDI
		ENDI
	ENDI
* udc
	IF LEFT(_icd,3) = 'Z37' .and. _x = '1'
		?? CHR(7)
		WAIT WIND ' ��� Delivery Outcome �� PDx �����' NOWAIT
		_Curobj = _Curobj
		Return
	ENDI
	IF BETWEEN(LEFT(_icd,3), 'O80', 'O84')
		?? CHR(7)
		WAIT WIND '���������� Delivery Outcome (Z37.-) ����' NOWAIT
	ENDI
	IF LEFT(_icd,3) = 'Z38'
		dAdmit = BE2CE(m.datea)
		dBirth = Lookup(Patient1.BirthDay,alltrim(m.HN),Patient1.HN,"HN")
		IF ! Empty(dBirth) and ! Empty(dAdmit) and dBirth # dAdmit
			?? CHR(7)
			WAIT WIND '�����������á�Դ �ѹ�Դ����ѹ�Ѻ��ҹ͹�ç��Һ�� (Admit)' + CHR(13) + ;
			'��ͧ���ѹ���ǡѹ ��سҵ�Ǩ�ͺ�ա����' NOWAIT
			_Curobj = _Curobj
			Return
		ENDI
	ENDI
	IF LEFT(_icd,4) = 'Z511'
		?? CHR(7)
		WAIT WIND '���������� ICD9CM 9925 ���¹�' NOWAIT
	ENDI
* udc

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

PROC Sicd1
PARA _sicd1c
_sret=_sicd1c
select (mf1)
DEFINE WIND sicd FROM 1,1 TO 23,78 SHAD
ACTI WIND sicd
ftr='  ������ [F2] ���ʹ٢������������  '
DEFINE POPUP sicd COLO r+/bg+,w+/n SHAD FOOT ftr FROM 0,1 TO 10,75
num=0
FOR ii=0 to 9
	IF SEEK(_seek+str(ii,1))
		num=num+1
		if !empty(text)
			DEFINE BAR num OF sicd PROMPT code+' * '+rtrim(desc)
		else
			DEFINE BAR num OF sicd PROMPT code+'   '+rtrim(desc)
		endif
	ENDI
NEXT
keyf2=ON('KEY','F2')
ON KEY LABEL F2 DO shwmemo4 WITH PROMPT()
ON SELE POPUP sicd DO  Sele_sicd WITH PROMPT(), _sret
mkey=27
DO WHIL mkey=27 .AND. num>0
	ACTI POPUP sicd
	mkey=lastkey()
ENDD
RELE WIND sicd
ON KEY LABEL F2 &keyf2
RETU _sret
*_par1=LEFT(_sret,LEN(code))
*_par2=SUBS(_sret,LEN(code)+4)

*****************
Procedure shwmemo4
*****************
parameter scode
on key label F2
scode=LEFT(scode,4)
define window mem from 15,5 to 23,75 shadow COLO w+/bg+
select (mf1)
seek scode
if !empty(text)
	modify memo text noedit window mem
endif
on key label F2 do shwmemo4 WITH PROMPT()
return

PROC Sele_sicd
PARA _pmt,_sst
_sst=_pmt
DEAC POPUP sicd
