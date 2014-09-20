PRIV startdate, enddate, mstartdate, menddate, startfile, endfile, ;
mm, yy, mm1, yy1, social, socialcond
CLOSE DATA
DEFINE WIND mostcommon FROM 8,20 TO 14,60 SHAD
STOR SPAC(8) TO startdate,enddate
STORE SPACE(2) TO social
ACTI WIND mostcommon
dbfuse = codedir + 'social'
USE (dbfuse) ORDER 1
CLEA
@ 1,4 SAY '     เฉพาะผู้มีสิทธิ์   ' GET social
@ 2,4 SAY 'ต้องการหาตั้งแต่วันที่  ' get startdate PICT '##/##/##' ;
VALID TRUEDATE(startdate)
@ 3,4 SAY '          ถึงวันที่     ' get enddate PICT '##/##/##' ;
VALID TRUEDATE(enddate)
READ NOLOCK
RELE WIND mostcommon
IF LASTKEY() # 27 AND ! EMPTY(startdate) AND ! EMPTY(enddate)
********** เปิดแฟ้มที่จำเป็นต้องใช้ แต่ยังไม่ได้เปิดแฟ้มที่ใช้คำนวณ
	dbfuse = patientdir + 'patient1'
	USE (dbfuse) IN 0
	dbfuse = patientdir + 'patient2'
	USE (dbfuse) IN 0
	dbfuse = codedir + 'icd101'
	USE (dbfuse) ORDER 1 IN 0
	dbfuse = codedir + 'ward'
	USE (dbfuse) ORDER 1 IN 0
	dbfuse = codedir + 'occupat'
	USE (dbfuse) ORDER 1 IN 0
	dbfuse = codedir + 'address'
	USE (dbfuse) ORDER 1 IN 0
	dbfuse = codedir + 'contact'
	USE (dbfuse) ORDER 1 IN 0
	dbfuse = codedir + 'icdcm1'
	USE (dbfuse) ORDER 1 IN 0
	dbfuse = ipddir + 'data\iptrana'
	USE (dbfuse) ORDER 1 IN 0
	dbfuse = patientdir + 'insure'
	USE (dbfuse) ORDER 1 IN 0
	dbfuse = ''
	
	mstartdate = BE2CE(startdate)
	menddate = BE2CE(enddate)
	IF menddate < mstartdate
		= SWAP(mstartdate,menddate)
		= SWAP(startdate,enddate)
	ENDI
	yy = RIGHT(startdate,2)
	mm = SUBS(startdate,4,2)
	yy1 = RIGHT(enddate,2)
	mm1 = SUBS(enddate,4,2)

	startfile=RIGHT(startdate,2)+SUBS(startdate,4,2)
	endfile=RIGHT(enddate,2)+SUBS(enddate,4,2)
	errmonth=''
	*********************	เริ่มวนลูปเพื่อคำนวณข้อมูล
	EXTERNAL ARRAY Tmonth
	DEFINE WIND showtemp FROM 16,15 TO 20,65
	ACTI WIND showtemp
	tempfile = SYS(3)
	tempfile1 = SYS(3)
	DO WHIL startfile <= endfile
		err=TMONTH(VAL(RIGHT(startfile,2)))+' '+FULLYEAR(LEFT(startfile,2))
		IF ! FILE(opddir+'CAME'+startfile+'.dbf')
			?? CHR(7)
			WAIT WIND 'ไม่พบแฟ้มเดือน '+err NOWAIT
			errmonth = errmonth+' '+err+','
		ELSE
			WAIT WIND 'กำลังดึงข้อมูลเดือน ' + err NOWAIT
			dbfuse = opddir + 'came' + startfile
			IF ! FILE(tempfile + '.dbf')
				USE (dbfuse) IN 0 ALIA test
				SELE test
				COPY TO (tempfile) stru
				USE (tempfile) ALIA test
			ENDI
			SELE test
			APPE FROM (dbfuse) FOR BETWEEN(date,mstartdate,menddate) .AND. ;
			IIF(Empty(social),.t.,fc=social)
			dbfuse = ''
		ENDI
		IF RIGHT(startfile,2)='12'	&& เพิ่มเดือนทีละหนึ่งเดือน
			startfile=STRZERO(VAL(LEFT(startfile,2))+1,2)+'01'
		ELSE
			startfile=LEFT(startfile,2)+STRZERO(VAL(RIGHT(startfile,2))+1,2)
		ENDI
	ENDD
	SET TALK ON
SELE CE2CBE(test.date) AS date1, test.hn, De_name(patient1.name) AS name, ;
IIF(test.sex = '1', 'ชาย  ','หญิง  ') AS sex, FindAge(test.age_type,test.age) ;
AS age, occupat.name AS occupation, ;
FindLocation('2'+contact.changwat+contact.ampur) AS ampur, ;
FindLocation('1'+contact.changwat) AS changwat, FindDiag(test.diag) AS diag, ;
FindWard(test.hn,test.result,test.date) AS ward, CIDFORMAT(insure.cid) AS cid, ;
CE2CBE(insure.dateexp) AS dateexp ;
FROM test, patient1, contact, patient2, occupat, insure ;
WHERE test.hn = patient1.hn AND test.hn = contact.hn AND test.hn = ;
patient2.hn AND patient2.occupa = occupat.occupa AND (test.hn + test.fc) = (LEFT(insure.hn,7)+insure.inscl) ;
GROUP BY test.hn, test.date, test.clinic, test.diag ;
ORDER BY test.date, test.hn ;
INTO TABLE (tempfile1)
	SET TALK OFF
	DEFINE WIND showbrow FROM 3,0 TO 20,77 SHAD
*	SELE tempfile1
	BROW FIELD date1 :h='วันที่มาตรวจ', hn :h='เลขที่ผู้ป่วยนอก', name ;
:h='  ชื่อ - สกุล  ', sex :h='เพศ', age :h='อายุ', occupation :h='อาชีพ', ;
ampur :h='อำเภอ', changwat :h='จังหวัด', diag :h='การวินิจฉัยโรค', ward ;
:h='ผลการรักษา', cid :h='เลขที่บัตร', dateexp :h='วันที่หมดอายุ' NOMO WIND showbrow
	DEFI WIND showtemp FROM 10,10 TO 14,70 SHAD
	ACTI WIND showtemp
	goon = .T.
	DO WHIL goon
		CLEA
		@ 1,1 SAY 'ต้องการเก็บรายงานไว้ในแฟ้มชื่อ  ' GET mfile DEFA SPACE(20)
		READ NOLOCK
		pmfile = ALLTRIM(mfile)
		IF EMPTY(pmfile)
			= ALARM1()
			@ 2,1 SAY 'ไม่ต้องเก็บข้อมูลไว้แน่หรือ ' GET sure PICT '!' DEFA 'N'
			READ NOLOCK
			goon = sure # 'Y'
		ELSE
			pmfile = IIF(AT('.',pmfile) = 0, pmfile + '.dbf', pmfile)
			IF FILE(pmfile)
				=ALARM1()
				@ 2,1 SAY 'แฟ้ม ' + pmfile + ' มีอยู่แล้ว ต้องการเบียนทับหรือไม่ ' ;
				GET overwrite PICT '!' DEFA 'N'
				READ NOLOCK
				IF overwrite = 'Y'
					IF UPPE(RIGHT(pmfile,3)) = 'DBF'
						COPY TO (mfile)
					ELSE
						COPY TO (mfile) SDF
					ENDI
					goon = .F.
				ENDI
			ELSE
				IF UPPE(RIGHT(pmfile,3)) = 'DBF'
					COPY TO (mfile)
				ELSE
					COPY TO (mfile) SDF
				ENDI
				goon = .F.
			ENDI
		ENDI
	ENDD
	RELE WIND showtemp
	CLOSE DATA
	DELE FILE (tempfile+'.dbf')
	DELE FILE (tempfile1 + '.dbf')
ENDI

FUNC FindLocation
PARA _find
= SEEK(_find,'address')
RETU LEFT(address.name+SPACE(30),30)

FUNC FindAge
PARA _agetype,_age
_mret = SPACE(8)
DO CASE
	CASE _agetype > '2'
		_mret = STR(_age,2)+' วัน  '
	CASE _agetype > '1'
		_mret = STR(_age,2)+' เดือน'
	CASE _agetype > '0'
		_mret = STR(_age,2) + ' ปี     '
ENDC
RETU _mret

FUNC FindDiag
PARA _diag
= SEEK(_diag,IIF(ISDIGIT(_diag),'icdcm1','icd101'))
RETU IIF(ISDIGIT(_diag),icdcm1.desc,icd101.desc)

FUNC FindWard
PARA _hn, _ward, _date
PRIV mward, mdate
mward = _ward
IF LEFT(_ward,1) = '5'
	mward = _ward + ' ' 
ELSE
	IF SEEK(_hn,'iptrana')
		mdate = DATE() - 365
		DO WHIL iptrana.dateadm < _date .AND. iptrana.hn = _hn
			SKIP IN iptrana
		ENDD
		IF iptrana.hn # _hn
			SKIP -1 IN iptrana
		ENDI
		mward = iptrana.ward_now
	ENDI
ENDI
= SEEK(mward,'ward')
RETU ward.name

FUNC CIDFORMAT
PARA _cid
PRIV pcid
pcid = TRIM(_cid)
DO CASE
	CASE LEN(pcid) = 15
		pcid = TRANS(pcid, '@R #####-#-####-#####')
	CASE LEN(pcid) = 10
		pcid = TRANS(pcid, '@R ##-#######-#')
	CASE LEN(pcid) = 12
		pcid = TRANS(pcid, '@R #####-#-#####-#')
ENDC
RETU LEFT(pcid + SPACE(LEN(_cid)), LEN(_cid)+5 )