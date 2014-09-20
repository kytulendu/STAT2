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
				WAIT WIND ' ใส่อาการบาดเจ็บที่หนักที่สุดเป็นโรคแรก' + CHR(13) + ;
				' สาเหตุของการบาดเจ็บ (ขึ้นต้นด้วย V, W, X, Y) ให้ใส่เป็นอันดับหลัง' NOWAIT
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
				WAIT WIND NOWA 'ไม่พบรหัสโรค '+_seek
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
				success=.F.				&& หารหัสที่ใส่ไม่พบ
				FOR i = slen TO 1 STEP -1	&& Loop หาโดยการตัดที่ตัวจนเหลือ 1 ตัว
					_seek=UPPE(LEFT(_icd,i))
					IF SEEK(_seek)
						success=.T.		&& หารหัสที่ใส่พบแล้ว
						_prompt=sicd1(code+SPACE(3)+desc)
						FOR n = i+1 TO 3	&& ถ้าหากว่าความยาวของรหัส น้อยกว่า 4 ให้หารหัสย่อยอีก
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
					WAIT 'ไม่มีรหัสโรคนี้  '+TRIM(_icd)  WIND NOWAIT
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
			mtag = IIF(LEFT(_icd,1)='#','code','desc')	&& ดูว่าเป็นรหัสย่อ หรือ ชื่อ
			SET ORDER TO TAG (mtag)
			mseek = IIF( LEFT(_icd,1)='#',TRIM(_icd),_icd)
			IF ! SEEK(mseek)
				SET ORDER TO TAG desc	&& ให้หาดูจากชื่อ

				IF SEEK(TRIM(_icd))		&& หาพบว่าใส่เป็นชื่อโรค
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
					IF xx > 2 	&& มีชื่อคล้ายกันมากกว่า 1 ชื่อ
						mchoice=0
						SET CONF ON
						@  10,20 MENU ProvArr,xx-1,10
						READ MENU TO mchoice
						SET CONF OFF
						IF mchoice = 0  && User กดปุ่ม [Esc]
							= TONE(1200,5)
							=TONE(700,5)
							DEFINE WIND addname FROM 10,10 TO 17,70 SHAD
							ACTI WIND addname
							@ 1,2 SAY 'ต้องการเพิ่มชื่อ '+TRIM(_icd)+' เข้าไปในแฟ้มชื่อย่อ'
							@ 4,10 SAY 'ใช่หรือไม่ ' GET yesno DEFA 'N' PICT '!'
							READ NOLOCK
							RELE WIND addname
							IF yesno $ 'Yัํ'
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
				ELSE		&& ยังไม่มีชื่ออยู่ในรายชื่อย่อ
					= TONE(1200,5)
					=TONE(700,5)
					DEFINE WIND addname FROM 10,10 TO 17,70 SHAD
					ACTI WIND addname
					@ 1,2 SAY 'ต้องการเพิ่มชื่อ '+TRIM(_icd)+' เข้าไปในแฟ้มชื่อย่อ'
					@ 4,10 SAY 'ใช่หรือไม่ ' GET yesno DEFA 'N' PICT '!'
					READ NOLOCK
					RELE WIND addname
					IF yesno $ 'Yัํ'
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
		WAIT WIND ' ใส่ Delivery Outcome เป็น PDx ไม่ได้' NOWAIT
		_Curobj = _Curobj
		Return
	ENDI
	IF BETWEEN(LEFT(_icd,3), 'O80', 'O84')
		?? CHR(7)
		WAIT WIND 'อย่าลืมใส่ Delivery Outcome (Z37.-) ด้วย' NOWAIT
	ENDI
	IF LEFT(_icd,3) = 'Z38'
		dAdmit = BE2CE(m.datea)
		dBirth = Lookup(Patient1.BirthDay,alltrim(m.HN),Patient1.HN,"HN")
		IF ! Empty(dBirth) and ! Empty(dAdmit) and dBirth # dAdmit
			?? CHR(7)
			WAIT WIND 'ผู้ป่วยเป็นเด็กแรกเกิด วันเกิดและวันรับเข้านอนโรงพยาบาล (Admit)' + CHR(13) + ;
			'ต้องเป็นวันเดียวกัน กรุณาตรวจสอบอีกครั้ง' NOWAIT
			_Curobj = _Curobj
			Return
		ENDI
	ENDI
	IF LEFT(_icd,4) = 'Z511'
		?? CHR(7)
		WAIT WIND 'อย่าลืมใส่ ICD9CM 9925 ด้วยนะ' NOWAIT
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
ftr='  กดปุ่ม [F2] เพื่อดูข้อมูลเพิ่มเติม  '
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
