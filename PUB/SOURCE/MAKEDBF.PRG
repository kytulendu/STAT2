PARA _makedbf
PRIV namedbf, mret
STORE .T. TO mret
dbfuse = _makedbf
namedbf = IIF( AT('\',_makedbf) > 0 , SUBS(_makedbf,RAT('\',_makedbf)+1), _makedbf)
namedbf = UPPER(namedbf)
IF ! FILE(patientdir+'patient1.dbf')
	DO Patient1_Make
ENDI
IF ! FILE(patientdir+'patient2.dbf')
	DO Patient2_Make
ENDI
IF ! FILE(patientdir+'contact.dbf')
	DO Contact_Make
ENDI
IF ! FILE(patientdir+'hncount.dbf')
	DO Hncount_Make
ENDI
IF ! FILE(patientdir+'er_hn.dbf')
	DO Er_hn_Make
ENDI
IF ! FILE(patientdir+'printque.dbf')
	DO Printque_Make
ENDI
IF ! FILE(codedir+'clinic.dbf')
	DO Clinic_Make
ENDI
IF ! FILE(codedir+'occupat.dbf')
	DO Occupat_Make
ENDI
IF ! FILE(codedir+'nation.dbf')
	DO Nation_Make
ENDI
IF ! FILE(codedir+'social.dbf')
	DO Social_Make
ENDI
IF ! FILE(codedir+'address.dbf')
	DO Address_Make
ENDI
IF ! FILE(patientdir+'medrec.dbf')
	DO Medrec_Make
ENDI
IF ! FILE(codedir+'doctor.dbf')
	DO Doctor_Make
ENDI
IF ! FILE(codedir+'ward.dbf')
	DO Ward_Make
ENDI
IF ! FILE(ipddir+'ancount.dbf') .AND. ! healthin
	DO Ancount_Make
ENDI
IF ! FILE(ipddir+'data\iptrana.dbf') .AND. ! healthin
	DO Iptrana_Make
ENDI
IF ! FILE(patientdir+'countapp.dbf')
	DO CountApp_make
ENDI
IF ! FILE(patientdir+'holiday.dbf')
	DO Holiday_Make
ENDI
IF ! FILE(opddir+'appoint.dbf') .AND. ! healthin
	DO Appoint_Make
ENDI
IF ! FILE(ipddir+'data\transfer.dbf') .AND. ! healthin
	DO Transfer_MAKE
ENDI
IF ! FILE(ipddir+'cancelan.dbf') .AND. ! healthin
	DO CancelAn_MAKE
ENDI
IF audit .AND. ! FILE(patientdir+'hnchange.dbf')
	DO HnChange_MAKE
ENDI
IF ! FILE(billdir+'all\chrgitem.dbf')
	DO IpdChrg_MAKE
ENDI
IF ! FILE(billdir+'opd\chrgitem.dbf')
	DO OpdChrg_MAKE
ENDI
SELE 0
DO CASE
	CASE namedbf = 'PATIENT1'

	CASE namedbf = 'PTTYP'
		CREA TABLE (_makedbf) ;
		( pttyp C(2), typname C(40) )
		INDEX ON pttyp TAG pttyp
		APPE BLANK
		REPL pttyp WITH 'A1', typname WITH 'ชำระเงินเองโดยไม่มีสิทธิเบิกคืน'
		APPE BLANK
		REPL pttyp WITH 'A2', typname WITH 'ใช้สิทธิเบิกหน่วยงานต้นสังกัดราชการ'
		APPE BLANK
		REPL pttyp WITH 'A3', typname WITH 'สิทธิลดหย่อนประเภท ก *'
		APPE BLANK
		REPL pttyp WITH 'A4', typname WITH 'สิทธิลดหย่อนประเภท ข *'
		APPE BLANK
		REPL pttyp WITH 'A5', typname WITH 'สิทธิลดหย่อนประเภท ค *'
		APPE BLANK
		REPL pttyp WITH 'A6', typname WITH 'สิทธิลดหย่อนประเภท ง *'
		APPE BLANK
		REPL pttyp WITH 'A7', typname WITH 'ผู้ประกันตนตาม พ.ร.บ.ประกันสังคม'
		APPE BLANK
		REPL pttyp WITH 'A8', typname WITH 'กองทุนเงินทดแทน'
		APPE BLANK
		REPL pttyp WITH 'A9', typname WITH 'ประกันภัยรถตาม พรบ.บุคคลที่ 3'
		APPE BLANK
		REPL pttyp WITH 'AA', typname WITH 'เด็ก 0 - 12 ปี'
		APPE BLANK
		REPL pttyp WITH 'AB', typname WITH 'ผู้มีรายได้น้อย'
		APPE BLANK
		REPL pttyp WITH 'AC', typname WITH 'นักเรียน'
		APPE BLANK
		REPL pttyp WITH 'AD', typname WITH 'ผู้พิการ'
		APPE BLANK
		REPL pttyp WITH 'AE', typname WITH 'ทหารผ่านศึก'
		APPE BLANK
		REPL pttyp WITH 'AF', typname WITH 'ภิกษุผู้นำศาสนา'
		APPE BLANK
		REPL pttyp WITH 'AG', typname WITH 'ผู้สูงอายุ'
		APPE BLANK
		REPL pttyp WITH 'AH', typname WITH 'บัตรชั่วคราว'
		APPE BLANK
		REPL pttyp WITH 'AI', typname WITH 'ประกันสุขภาพ ประชาชนทั่วไป'
		APPE BLANK
		REPL pttyp WITH 'AJ', typname WITH 'ประกันสุขภาพ อาสาสมัครสาธารณสุข'
		APPE BLANK
		REPL pttyp WITH 'AK', typname WITH 'ประกันสุขภาพ ผู้นำชุมชน'
		APPE BLANK
		REPL pttyp WITH 'AL', typname WITH 'ประกันสุขภาพ คนต่างด้าว'
		APPE BLANK
		REPL pttyp WITH 'UC', typname WITH 'ประกันสุขภาพถ้วนหน้า'

	CASE LEFT(namedbf,5) = 'INSUR'		&& แฟ้มเก็บข้อมูลบริษัทที่จำหน่าย
		CREA TABLE (_makedbf) ;
		( HN C(9), INSCL C(2), SUBTYPE C(2), CID C(16), ;
		NAME C(32), DATEIN D, DATEEXP D, HOSPMAIN C(5), ;
		HOSPSUB C(5), NOTEDATE D, NOTE C(50), RECORDBY C(8), VERIFYBY C(8) )
		INDEX ON hn TAG hn
		INDEX ON inscl TAG inscl ADDI
		INDEX ON cid TAG cid ADDI
		INDEX ON dateexp TAG dateexp ADDI
		INDEX ON LEFT(hn,7) + inscl TAG hncl

	CASE LEFT(namedbf,5) = 'VISIT'
	    CREA TABLE (_makedbf) (DATE D,nVS_ID N(4,0),STATUS L)
    	INDEX ON date TAG date
	    INDEX ON nVS_ID TAG vi_id
	    INDEX ON status TAG status

	CASE LEFT(namedbf,3) = 'INS' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) (HN C(9), INSCL C(2), SUBTYPE C(2), ;
	    CID C(16), DATEIN D, DATEEXP D, HOSPMAIN C(5), HOSPSUB C(5) )
	    INDEX ON hn TAG hn

	CASE LEFT(namedbf,3) = 'PAT' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) (HCODE C(5), HN C(9), CHANGWAT C(2), AMPHUR C(2), ;
	    DOB D, SEX C(1), MARRIAGE C(1), OCCUPA C(3), NATION C(2), PERSON_ID C(13), NAMEPAT C(35) )
	    INDEX ON hn TAG hn

	CASE LEFT(namedbf,3) = 'OPD' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( HN C(9), CLINIC C(4), DATEOPD D )
	    INDEX ON hn + DTOS(dateopd) + clinic TAG hndate

	CASE LEFT(namedbf,3) = 'ORF' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( HN C(9), DATEOPD D, CLINIC C(4), REFER C(5), ;
	    REFERTYPE C(1) )

	CASE LEFT(namedbf,3) = 'ODX' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( HN C(9), DATEDX D, CLINIC C(4), DIAG C(7), ;
	    DXTYPE C(1), DRDX C(6) )

	CASE LEFT(namedbf,3) = 'IDX' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( AN C(9), DIAG C(7), DXTYPE C(1), DRDX C(6) )

	CASE LEFT(namedbf,3) = 'OOP' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( HN C(9), DATEOP D, CLINIC C(4), OPER C(7), ;
	    DROP C(6) )

	CASE LEFT(namedbf,3) = 'IOP' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( AN C(9), OPER C(7), OPTYPE C(1), DROP C(6), ;
	    DATEIN D, TIMEIN C(4), DATEOUT D, TIMEOUT C(4) )

	CASE LEFT(namedbf,3) = 'CHT' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( HN C(9), AN C(9), DATE D, TOTAL N(7), PAID N(7), ;
	    PTTYPE C(2) )

	CASE LEFT(namedbf,3) = 'CHA' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( HN C(9), AN C(9), DATE D, CHRGITEM C(2), AMOUNT N(7) )

	CASE LEFT(namedbf,3) = 'IPD' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( HN C(9), AN C(9), DATEADM D, TIMEADM C(4), ;
	    DATEDSC D, TIMEDSC C(4), DISCHS C(1), DISCHT C(1), WARDDSC C(4), DEPT C (2), ADM_W N(7,3) )

	CASE LEFT(namedbf,3) = 'IRF' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( AN C(9), REFER C(5), REFERTYPE C(1) )

* - เพิ่มโครงสร้างแฟ้มที่ 14 AERyymm
	CASE LEFT(namedbf,3) = 'AER' .AND. VAL(SUBS(namedbf,4)) > 0
	    CREA TABLE (_makedbf) ( AN C(9), AUTHAE C(12), SVDOM N(1),;
	    AEDATE D, AETIME C(4), AETYPE C(1), AUTHREFI C(12), REFMAINI C(5),;
	    IREFTYPE C(4), AUTHREFO C(12), REFMAINO C(5), OREFTYPE C(4),;
	    UCAE C(1), EMTYPE C(1), FLAG C(1), DZ8 C(10), HC9 C(1), NAMEPAT C(36) )

	CASE LEFT(namedbf,2) = 'VS' .AND. ISDIGIT(SUBS(namedbf,3,1)) .AND. ;
	ISDIGIT(SUBS(namedbf,4,1))
	    CREA TABLE (_makedbf) (HN C(7),VS_ID C(4),DATE D,T_IN C(8),T_OUT C(8),;
    	CLINIC C(3),DOCTOR C(6),TRFMODE C(4),PT_CLASS C(2),USER C(8),;
	    PRIORITY C(1))
    	INDEX ON HN TAG HN
	    INDEX ON VS_ID tag vs_id addi
    	INDEX ON HN+DTOC(DATE) TAG hndate addi
	    INDEX ON VS_ID+DTOC(DATE) TAG vs_iddate addi
    	INDEX ON date TAG date addi
		INDEX ON clinic TAG clinic
		INDEX ON doctor TAG doctor
	    INDEX ON trfmode TAG trfmode
	CASE LEFT(namedbf,6) = 'FAILVS'
	    CREA TABLE (_makedbf) (HN C(7),VS_ID C(4),DATE D,T_IN C(8),T_OUT C(8),;
	    CLINIC C(3),DOCTOR C(6),TRFMODE C(4),PT_CLASS C(2),USER C(8),;
    	PRIORITY C(1))
	CASE LEFT(namedbf,4) = 'COME' .AND. ISDIGIT(SUBS(namedbf,5,1)) .AND. ;
	ISDIGIT(SUBS(namedbf,6,1))
	    CREA TABLE (_makedbf) (HN C(7),VS_ID C(4),CLINIC C(3),DOCTOR C(6),;
    	PRIORITY C(1))
	    INDEX ON HN TAG HN
    	INDEX ON VS_ID tag vs_id
	    INDEX ON PRIORITY tag PRIORITY
    	INDEX ON HN+VS_ID TAG hnvi_id addi
	CASE LEFT(namedbf,2) = 'CN' .AND. ISDIGIT(SUBS(namedbf,3,1)) .AND. ;
	ISDIGIT(SUBS(namedbf,4,1)) .AND. ISDIGIT(SUBS(namedbf,5,1)) .AND. ;
	ISDIGIT(SUBS(namedbf,6,1)) .AND. ISDIGIT(SUBS(namedbf,7,1)) .AND. ;
	ISDIGIT(SUBS(namedbf,8,1))
	    CREA TABLE (_makedbf) (HN C(7),VS_ID C(4),USRVID C(9),TIME C(8),VALUE C(15))
    	INDEX ON HN tag hn
	    INDEX ON VS_ID tag vs_id
    	INDEX ON USRVID tag USRVID
    CASE namedbf = 'FOREIGN'
		CREA TABLE (patientdir+'foreign') ;
			(HN C(7),FTYPE C(1),NATION C(2))
			INDEX ON hn TAG hn
			INDEX ON ftype TAG ftype
			INDEX ON nation TAG nation
	OTHER
		WAIT WIND 'ไม่สามารถสร้างแฟ้ม ' + _makedbf
		mret = .F.
ENDC
USE
dbfuse = ''
RETU mret

PROC PATIENT1_MAKE
	dbfuse = patientdir+'patient1'
	CREA TABLE (patientdir+'patient1') ;
	(HN C(7),SEX C(1),NAME C(36),BIRTHDAY D(8),DERIVE C(1),;
	MOTHER C(36),LASTDATE D(8),CLASS C(2),CLINIC C(3),FATHER C(36),;
	TIME C(4),PERSON_ID C(13))
	INDEX ON hn TAG hn
	INDEX ON name TAG name ADDI
	INDEX ON SUBS(name,AT(' ',name)+1,4) TAG last ADDI
	INDEX ON LEFT(name,4)+SUBS(name,AT(' ',name)+1,4) TAG namelast ADDI
	INDEX ON clinic TAG clinic ADDI
	INDEX ON lastdate TAG lastdate ADDI
	FOR i = 1 TO FCOUNT()
		IF FIELD(i) = 'PERSON_ID'
			INDEX ON person_id TAG person_id ADDI
			EXIT
		ENDI
	NEXT
	dbfuse = ''
	USE

PROC PATIENT2_MAKE
	dbfuse = patientdir+'patient2'
	CREA TABLE (patientdir+'patient2') ;
	(HN C(7),CONTACT C(30),MARRIAGE C(1),OCCUPA C(3),NATION C(2),;
	RACE C(2),PHONE C(9))
	INDEX ON hn TAG hn
	dbfuse = ''
USE

PROC CONTACT_MAKE
dbfuse = patientdir+'contact'
CREA TABLE (patientdir+'contact') ;
	(HN C(7),ADDRESS C(25),VILLAGE C(2),TAMBON C(2),AMPUR C(2),;
	CHANGWAT C(2),OWNER C(1))
	INDEX ON hn TAG hn
dbfuse = ''
USE

PROC HNCOUNT_MAKE
dbfuse = patientdir+'hncount'
	CREA TABLE (patientdir+'hncount') (lasthn N(7))
	APPE BLANK
	REPL lasthn WITH 0
dbfuse = ''
USE

PROC ER_HN_MAKE
dbfuse = patientdir+'er_hn'
	CREA TABLE (patientdir+'er_hn') ;
	(START1 N(7),END1 N(7),START2 N(7),END2 N(7))
	APPE BLANK
	REPL start1 WITH 0,end1 WITH 0,start2 WITH 0,end2 WITH 0
dbfuse = ''
USE

PROC PRINTQUE_MAKE
dbfuse = patientdir+'printque'
	CREA TABLE (patientdir+'printque') (HN C(7))
	INDEX ON hn TAG hn
dbfuse = ''
USE

PROC CLINIC_MAKE
dbfuse = codedir+'clinic'
	CREA TABLE (codedir+'clinic') (CLINIC C(3),NAME C(25))
	APPE BLANK
	REPL clinic WITH 'ZZZ',name WITH 'ห้องเก็บแฟ้มเวชระเบียน'
	APPE BLANK
	REPL clinic WITH '01',name WITH 'แผนกอายุรกรรม'
	REPL clinic WITH 'ZZZ',name WITH 'ห้องเก็บแฟ้มเวชระเบียน'
	APPE BLANK
	REPL clinic WITH '01',name WITH 'แผนกอายุรกรรม'
	INDEX ON clinic TAG clinic
	INDEX ON name TAG name ADDI
dbfuse = ''
USE

PROC OCCUPAT_MAKE
dbfuse = codedir+'OCCUPAT'
	CREA TABLE (codedir+'OCCUPAT') (OCCUPA C(3),NAME C(50))
	APPE BLANK
	REPL occupa WITH '000',name WITH '(-)'
	INDEX ON occupa TAG occupa
dbfuse = ''
USE

PROC NATION_MAKE
dbfuse = codedir+'nation'
	CREA TABLE (codedir+'nation') (CODE C(2),NAME C(30))
	APPE BLANK
	REPL code WITH '99',name WITH 'ไทย'
	INDEX ON code TAG code
dbfuse = ''
USE

PROC SOCIAL_MAKE
dbfuse = codedir+'social'
	CREA TABLE (codedir+'social') (CLASS C(2),NAME C(30), pttyp C(2))
	APPE BLANK
	REPL class WITH '10',name WITH 'ชำระเงินครบ'
	INDEX ON class TAG class
dbfuse = ''
USE

PROC ADDRESS_MAKE
dbfuse = codedir+'address'
	CREA TABLE (codedir+'address') (CODE C(6),NAME C(25),TYPE C(1))
	APPE BLANK
	REPL code WITH '340000',name WITH 'อุบลราชธานี',type WITH '1'
	APPE BLANK
	REPL code WITH '340100',name WITH 'เมือง',type WITH '2'
	APPE BLANK
	REPL code WITH '340101',name WITH 'ในเมือง',type WITH '3'
	INDEX ON type+code TAG typecode
dbfuse = ''
USE

PROC MEDREC_MAKE
dbfuse = patientdir+'MEDREC'
	CREA TABLE (patientdir+'MEDREC') ;
	(HN C(7),DATE D,TIME C(4),AGE C(5),WHO C(6),STATUS L)
	INDEX ON hn TAG hn
	INDEX ON date TAG date ADDI
	INDEX ON status TAG status
dbfuse = ''
USE

PROC DOCTOR_MAKE
dbfuse = codedir+'doctor'
	CREA TABLE (codedir+'doctor') (DOCTOR C(6),NAME C(30),STATUS L)
	INDEX ON DOCTOR TAG DOCTOR
	INDEX ON name TAG name
	APPE BLANK
	REPL doctor WITH '000000', name WITH 'ไม่ทราบรหัสแพทย์'
dbfuse = ''
USE

PROC WARD_MAKE
dbfuse = codedir+'ward'
	CREA TABLE (codedir+'ward') (CLINIC C(3),NAME C(25))
	INDEX ON clinic TAG clinic
	INDEX ON name TAG name ADDI
	APPE BLANK
dbfuse = ''
USE

PROC IPTRANA_MAKE
dbfuse = ipddir+'DATA\IPTRANA'
	CREATE TABLE (ipddir+'DATA\IPTRANA') ;
	(HN C(7),AN C(7),PTTYP C(2),DEP C(2),WARD_ADM C(3),DATEADM D,;
	TIMEADM C(4),WARD_NOW C(3),DATE_NOW D,TIME_NOW C(4),BED_NO C(2),;
	BED_TYPE C(1),TRANSFER L,DATEDSC D,TIMEDSC C(4),DISC C(4),;
	DR C(6),SENT L,DX_STAT L,PLACE C(5), CAUSE C(2), ONSET N(2))
	INDEX ON hn TAG hn
	INDEX ON an TAG an
	INDEX ON WARD_ADM TAG WARD_ADM
	INDEX ON DATEADM TAG DATEADM
	INDEX ON WARD_NOW TAG WARD_NOW
	INDEX ON DATEDSC TAG DATEDSC
dbfuse = ''
USE

PROC ANCOUNT_MAKE
dbfuse = ipddir+'ancount'
	CREATE TABLE (ipddir+'ancount') (LASTAN N(5,0),YEAR C(2))
	APPE BLANK
dbfuse = ''
USE

PROC COUNTAPP_MAKE
dbfuse = patientdir+'countapp'
	CREA TABLE (patientdir+'countapp') ;
	(DATE D,CLINIC C(3),NUMBER N(3),MAX N(3))
	INDEX ON DTOS(date)+clinic TAG countapp
	dbfuse = ''
USE

PROC HOLIDAY_MAKE
dbfuse = patientdir+'holiday'
	CREA TABLE (patientdir+'holiday') (DATE D,HOLINAME C(60))
	INDEX ON date TAG date
	dbfuse = ''
USE

PROC APPOINT_MAKE
dbfuse = opddir+'appoint'
	CREAT TABLE (opddir+'appoint') ;
      (HN C(7),CLINIC C(3),DATE D,TIME C(4),DOCTOR C(6),APPOINT L,LAB  M, FROMCLINIC C(3))
	INDEX ON hn+fromclinic TAG hnclinic
dbfuse = ''
USE

PROC TRANSFER_MAKE
dbfuse = ipddir+'data\transfer'
	CREATE TABLE (ipddir+'data\transfer') ;
	(AN C(7),DATE_IN D,TIME_IN C(4),WARDFROM C(3),DATE_OUT D,;
	TIME_OUT C(4),WARD_TO C(3))
	INDEX ON an TAG an
dbfuse = ''
USE

PROC CANCELAN_MAKE
dbfuse = ipddir+'cancelan'
	CREATE TABLE (ipddir+'cancelan') ;
	(AN C(7))
	INDEX ON an TAG an
dbfuse = ''
USE

PROC HNCHANGE_MAKE
dbfuse = patientdir+'hnchange'
	CREATE TABLE (patientdir+'hnchange') ;
	(hn C(7))
	INDEX ON hn TAG hn
dbfuse = ''
USE

PROC OPDCHRG_MAKE
dbfuse = billdir+'opd\chrgitem'
	CREA TABLE (billdir+'opd\chrgitem') ;
	(CHRGITEM C(2),CHR_NAME C(25))
	APPE BLANK
	REPL CHRGITEM WITH '00',CHR_name WITH 'ค่ายา'
	APPE BLANK
	REPL CHRGITEM WITH '01',CHR_name WITH 'ค่าบริการทางการแพทย์'
	APPE BLANK
	REPL CHRGITEM WITH '02',CHR_name WITH 'ค่าบริการทางทันตกรรม'
	APPE BLANK
	REPL CHRGITEM WITH '03',CHR_name WITH 'ค่าตรวจทางห้องปฏิบัติการ'
	APPE BLANK
	REPL CHRGITEM WITH '04',CHR_name WITH 'ค่า X-Ray'
	APPE BLANK
	REPL CHRGITEM WITH '05',CHR_name WITH 'ค่าวัสดุการแพทย์'
	APPE BLANK
	REPL CHRGITEM WITH '06',CHR_name WITH 'ค่าห้อง'
	APPE BLANK
	REPL CHRGITEM WITH '07',CHR_name WITH 'ค่าบำรุง'
	APPE BLANK
	REPL CHRGITEM WITH '08',CHR_name WITH 'ใบรับรองแพทย์'
	APPE BLANK
	REPL CHRGITEM WITH '09',CHR_name WITH 'บริจาค'
	APPE BLANK
	REPL CHRGITEM WITH '10',CHR_name WITH 'อื่น ๆ'
dbfuse = ''
USE

PROC IPDCHRG_MAKE
dbfuse = billdir+'all\chrgitem'
	CREA TABLE (billdir+'all\chrgitem') ;
	(CHRGITEM C(2),CHR_NAME C(25))
	APPE BLANK
	REPL CHRGITEM WITH '00',CHR_name WITH 'ชันสูตรห้องปฏิบัติการ'
	APPE BLANK
	REPL CHRGITEM WITH '01',CHR_name WITH 'X-Ray'
	APPE BLANK
	REPL CHRGITEM WITH '02',CHR_name WITH 'ตรวจชันสูตรอื่น ๆ'
	APPE BLANK
	REPL CHRGITEM WITH '03',CHR_name WITH 'ผ่าตัด'
	APPE BLANK
	REPL CHRGITEM WITH '04',CHR_name WITH 'การรักษาอื่น ๆ'
	APPE BLANK
	REPL CHRGITEM WITH '05',CHR_name WITH 'ยาและเวชภัณฑ์'
	APPE BLANK
	REPL CHRGITEM WITH '06',CHR_name WITH 'ICU'
	APPE BLANK
	REPL CHRGITEM WITH '07',CHR_name WITH 'ค่าห้อง'
	APPE BLANK
	REPL CHRGITEM WITH '08',CHR_name WITH 'ค่าอาหาร'
	APPE BLANK
	REPL CHRGITEM WITH '09',CHR_name WITH 'อื่น ๆ'
	APPE BLANK
dbfuse = ''
USE