***************************************************************************
*
* Routine for create billing files for sending to Health Insurance Office
*
***************************************************************************
private LCDATE, LCMONTH, LCYY, LCMM, LCDD, LCOK, LCEDIT, LCCANCEL

if  .not. WEXIST('wrcreatedb') .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.PJX' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.SCX' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.MNX' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.PRG' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.FRX' .or. UPPER(WTITLE('WRCREATEDB'))=='WRCREATEDB.QPR'
   define WINDOW WRCREATEDB FROM INT((SROWS()-9)/2), INT((SCOLS()-60)/2) TO INT((SROWS()-9)/2)+8, INT((SCOLS()-60)/2)+59 NOFLOAT NOCLOSE SHADOW NOMINIMIZE COLOR SCHEME 1
endif
LCMONTH = SPACE(7)
on KEY LABEL Esc KEYB CHR(7)
if WVISIBLE('wrcreatedb')
   activate WINDOW SAME WRCREATEDB
else
   activate WINDOW NOSHOW WRCREATEDB
endif
@ 2, 4 SAY '��͹����ͧ��û����ż� ' SIZE 1, 32, 0
@ 2, 40 GET LCMONTH DEFAULT ' ' SIZE 1, 7 PICTURE '99/9999' VALID _vmonth() MESSAGE '�����͹ ���繻վط��ѡ�Ҫ'
@ 5, 10 GET LCOK DEFAULT 1 SIZE 1, 9, 1 PICTURE '@*VT �١��ͧ' VALID _vOK()
@ 5, 24 GET LCEDIT DEFAULT 1 SIZE 1, 7, 1 PICTURE '@*VN ���' VALID _vEdit()
@ 5, 36 GET LCCANCEL DEFAULT 1 SIZE 1, 8, 1 PICTURE '@*HN ¡��ԡ' VALID _vCancel() MESSAGE '¡��ԡ��÷ӧҹ ��Ѻ�������'
if  .not. WVISIBLE('wrcreatedb')
   activate WINDOW WRCREATEDB
endif
READ NOLOCK CYCLE
on KEY LABEL Esc
release WINDOW WRCREATEDB

********************
procedure _vmonth
********************
*if VAL(SUBSTR(LCMONTH,1,2))<=MONTH(DATE())
   if TRUEDATE('10/'+LCMONTH)
      @ ROW()+1, 28 SAY SUBSTR(CE2CBE(BE2CE('10/'+LCMONTH)),3,14)
   else
      wait WINDOW TIMEOUT 3 '����ѹ����繻վط��ѡ�Ҫ���١��ͧ ��س�����ѹ�������'
      _CUROBJ = _CUROBJ
   endif
*else
*   wait WINDOW TIMEOUT 3 '�����͹�͹Ҥ����ͻѨ�غѹ�����'+CHR(13)+'��س������͹����'
*   _CUROBJ = _CUROBJ
*endif

********************
procedure _vOK
********************
on KEY LABEL Esc
LCMM = SUBSTR(LCMONTH,1,2)
LCYY = SUBSTR(LCMONTH,6,2)

********************************************************
*  �Դ������е�ͧ��㹡���觢����Ť���             *
********************************************************
m.hcode = hosp_code
DO MakeDBF WITH ipddir + 'report\ins' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\pat' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\opd' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\orf' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\odx' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\oop' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\ipd' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\irf' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\idx' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\iop' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\cht' + lcyy + lcmm
DO MakeDBF WITH ipddir + 'report\cha' + lcyy + lcmm
* ����������ҧ������ 14 AERyymm
DO MakeDBF WITH ipddir + 'report\aer' + lcyy + lcmm
SET EXCL ON
= OpenDBF(ipddir + 'report\ins' + lcyy + lcmm, 'ins', 1)
= OpenDBF(ipddir + 'report\pat' + lcyy + lcmm, 'pat', 1)
= OpenDBF(ipddir + 'report\opd' + lcyy + lcmm, 'opd', 1)
SET EXCL OFF
= OpenDBF(ipddir + 'report\orf' + lcyy + lcmm, 'orf')
= OpenDBF(ipddir + 'report\odx' + lcyy + lcmm, 'odx')
= OpenDBF(ipddir + 'report\oop' + lcyy + lcmm, 'oop')
= OpenDBF(ipddir + 'report\ipd' + lcyy + lcmm, 'ipd')
= OpenDBF(ipddir + 'report\irf' + lcyy + lcmm, 'irf')
= OpenDBF(ipddir + 'report\idx' + lcyy + lcmm, 'idx')
= OpenDBF(ipddir + 'report\iop' + lcyy + lcmm, 'iop')
canopen = Opendbf(patientdir + 'patient1', 'patient1','hn')
canopen = IIF(Opendbf(patientdir + 'insure', 'insure', 1), canopen, .F.)
canopen = IIF(Opendbf(patientdir + 'patient2', 'patient2', 1), canopen, .F.)
canopen = IIF(Opendbf(patientdir + 'contact', 'contact', 1), canopen, .F.)
canopen = IIF(Opendbf(patientdir + 'social', '', 1), canopen, .F.)
lcyymm = lcyy + lcmm
IF ! canopen
	?? CHR(7)
	WAIT WIND NOWA '����բ����ż�������§�ͷ��з���§ҹ'
	RETU
ELSE
************************************************************
*  �觢����ż����¹͡����ӹѡ�ҹ��Сѹ�آ�Ҿ              *
************************************************************
	IF FILE(opddir + 'came' + lcyy + lcmm + '.dbf')
		= Opendbf(opddir + 'came' + lcyy + lcmm, 'camefile', 1)
		SELE camefile
		SET RELA TO hn INTO patient1, hn INTO insure, hn INTO pat, hn INTO ins, ;
		hn INTO patient2, hn INTO contact
		div_num=ROUND((RECCOUNT()/40)+.5,0)
		recno = 0
		DO ShowProgress
		SCAN
			recno=recno+1
			@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '�' COLO gr+
			mhn = hn
			SCAT MEMV
			STORE ALLTRIM(doctor) TO m.drdx, m.drop
			STORE date TO m.dateopd, m.dateop, m.datedx
			STORE IIF(LEFT(diag,1) = '*' ,SUBS(diag,2), diag) TO m.diag, m.oper
			STORE ALLTRIM(doctor) TO m.drdx, m.drop
			IF ! SEEK( m.hn + DTOS(m.dateopd) + m.clinic, 'opd')
				INSERT INTO opd FROM MEMV
			ENDI
			IF ! EOF('insure') .AND. ! SEEK(m.hn, 'ins')
				SELE insure
				DO WHIL hn = mhn .AND. ! EOF() .AND. NOTEDATE >= m.dateopd
					SCAT MEMV
					IF SEEK(inscl,'social')
						m.inscl = social.pttyp
					ENDI
					m.hn = LEFT(hn,7)
					INSERT INTO ins FROM MEMV
					SKIP
				ENDD
			ENDI
			SELE camefile
			m.hn = LEFT(m.hn,7)
			IF ISDIGIT(m.diag)
				INSERT INTO oop FROM MEMV
			ELSE
				INSERT INTO odx FROM MEMV
			ENDI
			IF EOF('pat') .AND. ! EOF('patient1')
				SELE contact
				SCAT MEMV
				SELE patient2
				SCAT MEMV
				SELE patient1
				SCAT MEMV
				m.dob = birthday
				m.nation = patient2.nation
				m.amphur = m.ampur
* by udc		m.person_id = Encode(m.person_id)
* ������������ PAT
				*m.namepat = LEFT(name,AT(',',name)-1)
				m.namepat = m.name
* ������������ PAT
				INSERT INTO pat FROM MEMV
			ENDI
			SELE camefile
		ENDS
		RELE WIND progress
		IF FILE(opddir + 'refer' + lcyy + '.dbf')
			= OPENDBF(opddir + 'refer' + lcyy, 'refer')
			targetfile = ipddir + '\report\orf' + lcyy + lcmm
			WAIT WIND NOWA '�ô��� ! ���ѧ�Ӥ����觵�ͼ����¹͡����'
			SELE LEFT(hn + '      ',9) AS hn, BE2CE(RIGHT(day,2)+'/'+LEFT(day,2)+'/'+lcyy) ;
			AS dateopd, clinic, place AS refer, type AS refertype FROM refer ;
			WHERE LEFT(day,2) = lcmm INTO TABLE &targetfile
		ENDI
	ENDI

***********************************************************
*  �觢����ż����������ӹѡ�ҹ��Сѹ�آ�Ҿ              *
***********************************************************
	IF FILE(ipddir + 'data\in' + lcyymm + '.dbf')
		= OPENDBF(ipddir + 'data\in' + lcyymm, 'in')
		= OpendBF(ipddir + 'data\adm' + lcyy, 'adm', 'an')
		SELE 0
		targetfile = ipddir + '\report\ipd' + lcyy + lcmm
		WAIT WIND NOWA '�ô��� ! ���ѧ�Ӽ����������'
*		SELE LEFT(in.hn + '      ',9) AS hn, LEFT(in.an + '      ',9) AS an, ;
*		in.dateadm, adm.timeadm, in.datedsc, adm.timedsc, LEFT(in.disc,1) AS dischs, ;
*		RIGHT(in.disc,1) AS discht, in.ward_dsc AS warddsc, adm.dep AS dept ;
*		FROM in, adm WHERE in.an = adm.an ;
*		INTO TABLE &targetfile
		SELE in
		SET RELA TO hn INTO patient1, hn INTO insure, hn INTO pat, hn INTO ins, ;
		hn INTO patient2, hn INTO contact, an INTO adm
		div_num=ROUND((RECCOUNT()/40)+.5,0)
		recno = 0
		DO ShowProgress
		SCAN
			recno=recno+1
			@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '�' COLO gr+
			SCAT MEMV
			m.timeadm = adm.timeadm
			m.timedsc = adm.timedsc
			m.dischs = LEFT(in.disc,1)
			m.discht = RIGHT(in.disc,1)
			m.warddsc = in.ward_dsc
			m.dept = adm.dep
			m.adm_w = in.adm_w  && udc
			INSERT INTO (targetfile) FROM MEMV
			mhn = hn
			m.dateadm=adm.dateadm && UDC
			IF ! EOF('insure') .AND. ! SEEK(m.hn, 'ins')
				SELE insure
				DO WHIL hn = mhn .AND. NOTEDATE >= m.dateadm
					SCAT MEMV
					IF SEEK(inscl,'social')
						m.inscl = social.pttyp
					ENDI
					m.hn = LEFT(hn,7)
					INSERT INTO ins FROM MEMV
					SKIP
				ENDD
			ELSE
				IF EOF('insure')
					SELE ins
					SCAT MEMV BLANK
					SELE in
					SCAT MEMV
					= SEEK(in.pttyp, 'social')
					m.inscl = IIF(EMPTY(social.pttyp),in.pttyp, social.pttyp)
					m.name = patient1.name
					INSERT INTO ins FROM MEMV
				ENDI
			ENDI
			IF  EOF('pat') .AND. ! EOF('patient1')
				SELE contact
				SCAT MEMV
				SELE patient2
				SCAT MEMV
				SELE patient1
				SCAT MEMV
				m.dob = birthday
				m.nation = patient2.nation
* by udc		m.person_id = Encode(m.person_id)
				m.namepat = m.name
				INSERT INTO pat FROM MEMV
			ENDI
		ENDS
		RELE WIND progress
		IF FILE(ipddir + 'data\refer' + lcyy + '.dbf')
			= OPENDBF(ipddir + 'data\refer' + lcyy, 'referin')
			targetfile = ipddir + '\report\irf' + lcyy + lcmm
			WAIT WIND NOWA '�ô��� ! ���ѧ����§ҹ�觵�ͼ����������'
			SELE LEFT(an + '      ',9) AS an, place AS refer, type AS refertype ;
			FROM referin ;
			WHERE LEFT(day,2) = lcmm INTO TABLE &targetfile
		ELSE
			WAIT WIND '�������������š���觵�ͼ������' TIME 5
		ENDI
		IF FILE(ipddir + 'data\diag' + lcyymm + '.dbf')
			= OPENDBF(ipddir + 'data\diag' + lcyymm, 'diag')
			targetfile = ipddir + '\report\idx' + lcyy + lcmm
			WAIT WIND NOWA '�ô��� ! ���ѧ����§ҹ�ԹԨ����ä�����������'
			SELE LEFT(diag.an + '      ',9) AS an, diag , dxtype, LEFT(ALLTRIM(in.dr) + SPACE(6),6) AS drdx ;
			FROM diag, in ;
			WHERE diag.an = in.an INTO TABLE &targetfile
		ENDI
		IF FILE(ipddir + 'data\oper' + lcyymm + '.dbf')
			= OPENDBF(ipddir + 'data\oper' + lcyymm, 'oper')
			targetfile = ipddir + '\report\iop' + lcyy + lcmm
			WAIT WIND NOWA '�ô��� ! ���ѧ����§ҹ��ҵѴ�����������'
			SELE LEFT(an + '      ',9) AS an, IIF(LEFT(op,1)='*', SUBS(op,2), LEFT(op,4)) AS oper , ;
			optype, LEFT(ALLTRIM(surgeon) + SPACE(6),6) AS drop, dateop AS datein, ;
			timein, dateout, timeout ;
			FROM oper INTO TABLE &targetfile
		ENDI
	ELSE
		?? CHR(7)
		WAIT WIND '����բ����ż�����������' TIME 10
	ENDI
ENDI
SELE pat
DELE TAG ALL
SELE ins
DELE TAG ALL
SELE opd
DELE TAG ALL
CLOSE DATA
*-- Check for existing of Billing file
if  ! EMPTY(billdir) .AND. FILE(BILLDIR+'all\RcPd.DBF')
	WAIT WIND NOWA '�ô��� ���ѧ�Ӣ����š���Թ����'
	= OPENDBF(BILLDIR+'all\DtPd','DtPd')
	= OPENDBF(BILLDIR+'all\RcPd','RcPd')
	= OPENDBF(BILLDIR+'all\CreditPd','CreditPd')

	*-- Create Heading file
	select RCPD.RC_NO, RCPD.HN, RCPD.DATE, RCPD.TOTAL, RCPD.PAID;
	   FROM RCPD;
	   HAVING substr(dtos(RCPD.DATE),1,6) =;
    	substr(dtos(BE2CE('10/'+LCMONTH)),1,6);
       INTO DBF (TEMPDIR+'RCTEMP.DBF')
* harin	   HAVING substr(dtos(CTOD('1/1/89')+RCPD.DATE),1,6) =;
	= OPENDBF(TEMPDIR+'RCTEMP','RCTEMP')
	index ON RC_NO TAG RC_NO

	*-- Create Credit file
	select RCPD.RC_NO, CREDITPD.CR_ID ;
	   FROM RCPD, CREDITPD;
    	WHERE CREDITPD.RC_NO=RCPD.RC_NO;
	   HAVING substr(dtos(RCPD.DATE),1,6) =;
   		 substr(dtos(BE2CE('10/'+LCMONTH)),1,6);
	   ORDER BY RCPD.RC_NO;
     INTO DBF (TEMPDIR+'CREDTEMP.DBF')
* harin	   HAVING substr(dtos(CTOD('1/1/89')+RCPD.DATE),1,6) =;
	= OPENDBF(TEMPDIR+'CREDTEMP','CREDTEMP')
	index ON RC_NO TAG RC_NO

	*-- Create Detail file
	select DTPD.* FROM DTPD, RCPD;
	 WHERE RCPD.RC_NO==DTPD.RC_NO;
	  HAVING substr(dtos(RCPD.DATE),1,6) =;
   	 	 substr(dtos(BE2CE('10/'+LCMONTH)),1,6);
	  ORDER BY DTPD.RC_NO INTO DBF (TEMPDIR+'DTTEMP.DBF')
* harin	  HAVING substr(dtos(CTOD('1/1/89')+RCPD.DATE),1,6) =;
	= OPENDBF(TEMPDIR+'DTTEMP','DTTEMP')
	index ON RC_NO TAG RC_NO

	if  .not. FILE(TEMPDIR+'HeadRcNO.dbf')
	   create DBF TEMPDIR+'HeadRcNO';
    	( HN C ( 9 ), AN C ( 9 ), DATE D ,;
	     TOTAL N ( 7,0 ), PAID N ( 7,0 ), PTTYP C ( 2 ) )
	endif
	= OPENDBF(ipddir+'report\cht'+lcYY+lcMM,'HEADRCNO')

	if  .not. FILE(TEMPDIR+'DtRcNO.dbf')
	   create DBF TEMPDIR+'DtRcNO';
    	( HN C ( 9 ), AN C ( 9 ), DATE D ,;
	     CHRGITEM C ( 2 ), AMOUNT N ( 7,0 ) )
	endif
	= OPENDBF(ipddir+'report\cha'+lcYY+lcMM,'DTRCNO')

	*-- Create Sending file
	= OPENDBF(TEMPDIR+'CREDTEMP','CREDTEMP','RC_NO')
	= OPENDBF(TEMPDIR+'DTTEMP','DTTEMP','RC_NO')
	= OPENDBF(TEMPDIR+'RCTEMP','RCTEMP','RC_NO')
	SET RELATION OFF INTO DTTEMP
	SET RELATION OFF INTO RCTEMP
	SET RELATION TO RC_NO INTO DTTEMP
	SET RELATION TO RC_NO INTO CREDTEMP ADDITIVE

	GO TOP
	SCAN
		SCATTER MEMVAR
		IF ISDIGIT(SUBSTR(M.RC_NO,1,1))#.T.
			SELECT CREDTEMP
* udc				M.PAID 	= 0
				M.PTTYPE = CREDTEMP.CR_ID
			sele rcpd
			set order to tag rc_no
* Add by Harin
			IF seek(M.RC_no)
				M.AN = RCPD.AN
			ENDI
* Add by Harin
		ELSE
			M.PTTYPE  = '10'
* Add by Harin
			sele rcpd
			set order to tag rc_no
			IF seek(M.RCNO)
				M.AN = RCPD.AN
			ENDI
* Add by Harin
		ENDI
* harin		M.RCNODATE	= (CTOD('1/1/89')+M.DATE)
* harin		M.DATE = M.RCNODATE
		SELECT DTTEMP
			DO WHILE DTTEMP.RC_NO = M.RC_NO
				IF EOF()
					EXIT
				ENDIF
				M.AMOUNT	=	DTTEMP.AMT
				DO CASE
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0A'
						M.CHRGITEM	=	'00'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0B'
						M.CHRGITEM	=	'01'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0C'
						M.CHRGITEM	=	'02'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0D'
						M.CHRGITEM	=	'03'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0E'
						M.CHRGITEM	=	'04'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0F'
						M.CHRGITEM	=	'05'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0G'
						M.CHRGITEM	=	'06'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0H'
						M.CHRGITEM	=	'07'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0I'
						M.CHRGITEM	=	'08'
					CASE SUBSTR(DTTEMP.SV_ID,1,2) = '0J'
						M.CHRGITEM	=	'09'
				ENDCASE
				INSERT INTO DTRCNO	 FROM MEMVAR	&& CREATE DTRCNO
				SKIP
			ENDDO
			INSERT INTO HEADRCNO FROM MEMVAR	&& CREATE HEADRCNO

		SELECT RCTEMP
	ENDSCAN

	SELECT CREDTEMP
	USE
	SELECT DTTEMP
	USE
	SELECT RCTEMP
	USE

	DELETE FILE TEMPDIR+'CREDTEMP.DBF'
	DELETE FILE TEMPDIR+'CREDTEMP.CDX'
	DELETE FILE TEMPDIR+'DTTEMP.DBF'
	DELETE FILE TEMPDIR+'DTTEMP.CDX'
	DELETE FILE TEMPDIR+'RCTEMP.DBF'
	DELETE FILE TEMPDIR+'RCTEMP.CDX'
ELSE
	WAIT WIND NOWA '����բ����š���Թ������'
ENDIF
CLOSE DATA
CLEA
@ 1,2 SAY '�红������������  '
@ 2,10 PROMPT '�Ѩ�غѹ  '
@ 3,10 PROMPT 'A:  '
@ 4,10 PROMPT 'B:  '
MENU TO ch_drive
IF ch_drive > 0
	targetdrive = IIF(ch_drive = 1, ipddir + 'report\', IIF(ch_drive = 2, 'A:\', 'B:\') )
	targetfile = targetdrive + 'H' + lcyymm + LEFT(hosp_code,3) + '.' + RIGHT(hosp_code,2)
	sourcefile = ipddir + '\report\???' + lcyymm + '.dbf'
	IF ch_drive = 1
		! PKZIP -a &targetfile &sourcefile
	ELSE
		! PKZIP -&v &targetfile &sourcefile
	ENDI
	ACTI SCREE
	CLEA
ELSE
	WAIT WIND NOWA '¡��ԡ��� zip �������ͧ���'
ENDI

********************
procedure _vEdit
********************
_CUROBJ = _CUROBJ-2

********************
procedure _vCancel
********************
* release WINDOW WRCREATEDB
* return TO MASTER
CLEAR READ
