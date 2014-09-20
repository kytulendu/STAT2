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
	USE (dbfuse) IN 0 ORDER TAG hn
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
	DO OpenFile1
	IF m.social = '00'
		socialcond = '.T.'
		nowsocial = 'ทุกสิทธิการรักษา'
	ELSE
		= SEEK(social, 'social')
		socialcond = 'PTTYP = m.social'
		nowsocial = social.name
	ENDI
	rfile=ipddir+'report\IPtemp.dbf'
	dbfuse = rfile
	create table (rfile) (name C(30), AGE C(10), SEX C(4), OCCUPA C(30), ;
	HN C(9), AN C(8), DATEADM C(14), DATEDSC C(14),;
	WARD C(20), DG1 C(60),;
	DG2 C(60), DG3 C(60), DG4 C(60),;
	OP1 C(60), OP2 C(60), OP3 C(60), OP4 C(60), OPDR C(30), DATEOP C(14), ;
	ONSET N(2,0),;
	DISCH C(2), REFERIN C(30), REFEROUT C(30), PTTYP C(30), ;
	cid C(20), dateexp C(15))
	use (rfile) alia REPORTM
	dbfuse = ''
	SELE patient1
	set order to tag hn

	SELE inp
	SET ORDER TO 0
	SET RELA TO hn INTO patient1, hn INTO patient2, hn INTO contact, hn INTO insure
	GO TOP
	IF RECCOUNT() = 0
		wait 'ยังไม่ได้ใส่ข้อมูล' wind time 2
		sele reportm
		USE
		SELE PATIENT2
		use
		SELE CONTACT
		use
		RETU
	ENDI
	div_num=ROUND((RECCOUNT()/40)+.5,0)
	recno = 0
	DO ShowProgress
	SCAN FOR BETWEEN(datedsc,mstartdate,menddate) AND &socialcond
		@ 3,3 SAY SPACE((ROUND(recno('inp')/div_num+.5,0))) COLO gr/r
		SELE reportm
		SCAT TO rep BLANK
		SELE inp
		IF ! EMPTY(hn)
			rep(1)=De_name(patient1.name)
			_mage=inp.DATEDSC - patient1.birthday
			DO CASE
				CASE _mage<=30
					rep(2) = ALLTRIM(STR(_mage)) + ' วัน'
				CASE _mage<=365
					rep(2)= ALLTRIM(STR(INT(_mage/31))) + ' เดือน'
				OTHER
					rep(2) = ALLTRIM(STR(INT(_mage/365))) + ' ปี'
			ENDC
			rep(3) = IIF(patient1.SEX = '1', 'ชาย', 'หญิง')
			=SEEK(patient2.occupa,'occupat')
			rep(4) = occupat.name
			rep(5) = hn
			rep[6] = RIGHT(an,5) + '-' + LEFT(an,2)
			rep[7] = CE2CBE(dateadm)
			rep[8] = CE2CBE(datedsc)
			= SEEK(ward_dsc,'ward')
			rep[9] = ward.name
			SELE diagnosis
			=SEEK(inp.an)
			n = 10
			DO WHIL an = inp.an
				= SEEK(diag, 'icd101')
				rep[n] = icd101.desc
				n = n + 1
				SKIP
			ENDD
			SELE operation
			= SEEK(inp.an)
			IF ! USED('doctor')
				USE (codedir + 'doctor') ORDER 1 IN 0
			ENDI
			= SEEK(surgeon, 'doctor')
			rep[18] = doctor.name
			rep[19] = CE2CBE(dateop)
			n = 14
			DO WHIL an = inp.an
				= SEEK(op, 'icdcm1')
				rep[n] = icdcm1.desc
				n = n + 1
				SKIP
			ENDD
			SELE REFER
			if seek(inp.an)
				= SEEK(place, 'hospcode')
				rep(22)=  TRIM(hospcode.off_name2) + TRIM(hospcode.off_name1)
			endif
			IF ! USED('hospcode')
				USE (codedir + 'hospcode') IN 0 ORDER TAG off_id
			ENDI
			SELE Admyear

			IF SEEK(inp.an)
				= SEEK(place, 'hospcode')
				rep(23)=  TRIM(hospcode.off_name2) + TRIM(hospcode.off_name1)
				rep[20] = onset
			ENDI
			rep(21)=inp.DISC
			rep[24] = nowsocial
			rep[25] = CIDFORMAT(insure.cid)
			rep[26] = CE2CBE(insure.dateexp)
			insert into REPORTM from array rep
			FLUSH
		ENDI
		rep=''
		SELE inp
	ENDS
	SELE reportm
	RELE WIND progress
ENDI
	DEFINE WIND showbrow FROM 3,0 TO 20,77 SHAD
	BROW FIELD hn :h='เลขที่ผู้ป่วยนอก', name :h='  ชื่อ - สกุล  ', ;
	sex :h='เพศ', age :h='อายุ', occupa :h='อาชีพ', ;
	an :h='เลขที่ผู้ป่วยใน', dateadm :h='วันที่รับไว้ในรพ.', datedsc ;
	:h='วันที่ออกจากรพ.', ward :h='รักษาที่แผนก', dg1 :h='การวินิจฉัยโรคที่ 1', ;
	dg1 :h='การวินิจฉัยโรคที่ 2', dg3 :h='การวินิจฉัยโรคที่ 3', dg4 ;
	:h='การวินิจฉัยโรคที่ 4', op1 :h='การผ่าตัดที่ 1', op2 :h='การผ่าตัดที่ 2 ', ;
	op3 :h='การผ่าตัดที่ 3', op4 :h='การผ่าตัดที่ 4', opdr :h='แพทย์ผู้ผ่าตัด', ;
	dateop :h='วันที่ผ่าตัด', onset :h='จำนวนวัน', disch :h='ผลการรักษา ' ,;
	referin :h = 'รับมาจากรพ.', referout :h='ส่งต่อไปที่รพ.', pttyp :h='สิทธิการรักษา' , ;
	cid :h='เลขที่บัตร', dateexp :h='วันที่หมดอายุ' NOMO WIND showbrow
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

FUNC NoError
PARA _handle,reason
_ret=.T.
IF _handle < 0                &&Error generated creating file
   	DO CASE 						     && Determine which error
			CASE FERROR() = 4
				reason = 'เปิดแฟ้มมากเกินไป ไม่สามารถทำได้'
			CASE FERROR() = 5
 				reason = 'ไม่สามารถอ่าน-เขียนได้'
 			CASE FERROR() = 8
 				reason = 'ความจำไม่เพียงพอ'
			CASE FERROR() = 29
				reason = 'ไม่มีที่ว่าง'
	    CASE FERROR() = 31
	    		reason = 'มีข้อผิดพลาดทั่ว ๆ ไป'
	 	ENDCASE
	_ret=.F.
ENDI
RETURN _ret



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