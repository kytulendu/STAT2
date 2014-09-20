PARA _askfile
toaskfile = IIF(PARAMETERS()=0, .T., _askfile)
PRIV choice,firstfield
firstfield = ' '
choice = 1
IF ! toaskfile
	nowdbf = DBF()
	nowalias = ALIAS()
ENDI
mfile = IIF(toaskfile,GETFILE('DBF','เลือกแฟ้มที่จะซ่อมดัชนี','เลือก'), DBF())
mfile1 =LEFT(mfile,AT('.',mfile)-1)
IF ! EMPTY(mfile)
	DO WHIL AT('\',mfile) > 0
	mfile = SUBS(mfile,AT('\',mfile)+1)
	ENDD
	mfile = LEFT(mfile,AT('.',mfile)-1)
	IF toaskfile
		=Alarm1()
		DEFINE WIND Ask FROM 9,5 TO 15,75
		ACTI WIND Ask
		@ 1,3 SAY 'คุณต้องการซ่อมดัชนีของแฟ้ม '+mfile
		@ 2,3 SAY 'บุคคลอื่นในระบบจะต้องไม่ได้ใช้แฟ้มนี้อยู่ โปรดตรวจสอบให้แน่ใจ'
		@ 4,3 PROMPT 'แน่ใจที่จะทำงานต่อ'
		@ 4,30 PROMPT 'ยกเลิกการซ่อมดัชนี'
		choice = 2
		MENU TO choice
		RELE WIND Ask
	ELSE
		USE
	ENDI
	IF Choice = 1
		DEFINE WIND echo FROM 1,50 TO 4,78 SHAD
		ACTI WIND echo
		DO CASE
			CASE mfile = 'PATIENT1'
				DO DeleCDX
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
			CASE mfile $ 'PATIENT2,CONTACT'
				DO DeleCDX
				INDEX ON hn TAG hn
			CASE mfile = 'ADDRESS'
				DO DeleCDX
				INDEX ON type+code TAG typecode
			CASE mfile = 'PTTYP'
				DO DeleCDX
				INDEX ON pttyp TAG pttyp
			CASE mfile $ 'CLINIC,WARD'
				DO DeleCDX
				INDEX ON clinic TAG clinic
				INDEX ON name TAG name ADDI
			CASE mfile = 'MEDREC'
				DO DeleCDX
				INDEX ON hn TAG hn
				INDEX ON date TAG date ADDI
				INDEX ON status TAG status
			CASE mfile = 'DOCTOR'
				DO DeleCDX
				INDEX ON DOCTOR TAG DOCTOR
				INDEX ON name TAG name
			CASE mfile = 'IPTRANA'
				DO DeleCDX
				INDEX ON hn TAG hn
				INDEX ON an TAG an
				INDEX ON WARD_ADM TAG WARD_ADM
				INDEX ON DATEADM TAG DATEADM
				INDEX ON WARD_NOW TAG WARD_NOW
				INDEX ON DATEDSC TAG DATEDSC
			CASE mfile = 'COUNTAPP'
				DO DeleCDX
				INDEX ON DTOS(date)+clinic TAG countapp
			CASE mfile = 'APPOINT'
				DO DeleCDX
				INDEX ON hn+fromclinic TAG hnclinic
			CASE mfile = 'ASK_REQ'
				DO DeleCDX
				INDEX ON who+hn TAG whohn
			CASE LEFT(mfile,4) = 'CAME' .AND. VAL(RIGHT(mfile,4)) > 0
				DO DeleCDX
				INDEX ON hn+STR(DAY(date),2)+clinic+STR(t_in,4)+STR(sequence,1) TAG hdate
			CASE LEFT(mfile,6) = 'APPOIN' .AND. ISDIGIT(RIGHT(mfile,2))
				DO DeleCDX
				INDEX ON hn+clinic TAG hnclinic
			CASE mfile = 'SHORTICD'
				DO DeleCDX
				INDEX ON UPPE(desc) TAG desc
				INDEX ON code TAG code ADDI
			CASE LEFT(mfile,4) $ 'MOSE,MOST' .AND. ISDIGIT(RIGHT(mfile,4))
				DO DeleCDX
				INDEX ON DIAG TAG diag
				INDEX ON number TAG number ADDI
			CASE LEFT(mfile,3) = 'ADM' .AND. ISDIGIT(RIGHT(mfile,2))
				DO DeleCDX
				INDEX ON an TAG an
				INDEX ON hn TAG hn ADDI
			CASE LEFT(mfile,2) = 'IN' .AND. ISDIGIT(RIGHT(mfile,4))
				DO DeleCDX
				INDEX ON an TAG an
			CASE LEFT(mfile,5) = 'DEATH' .AND. ISDIGIT(RIGHT(mfile,2))
				DO DeleCDX
				INDEX ON an TAG an
			CASE mfile = 'HOLIDAY'
				DO DeleCDX
				INDEX ON date TAG date
			CASE mfile = 'ICD101'
				DO DeleCDX
				INDEX ON code TAG code
			CASE mfile = 'ICD102'
				DO DeleCDX
				INDEX ON kwcode TAG kwcode
				INDEX ON code TAG code ADDI
			CASE mfile = 'ICD103'
				DO DeleCDX
				INDEX ON kwcode TAG kwcode
				INDEX ON UPPE(desc) TAG desc ADDI
			CASE mfile = 'ICDCM1'
				DO DeleCDX
				INDEX ON code TAG code
			CASE mfile = 'ICDCM2'
				DO DeleCDX
				INDEX ON kwcode TAG kwcode
			CASE mfile = 'ICDCM3'
				DO DeleCDX
				INDEX ON kwcode TAG kwcode
				INDEX ON UPPE(desc) TAG desc ADDI
			CASE mfile = 'HOSPCODE'
				DO DeleCDX
				INDEX ON off_id TAG off_id
				INDEX ON name TAG name ADDI
			CASE mfile = 'SOCIAL'
				DO DeleCDX
				INDEX ON class TAG class
			CASE mfile = 'NATION'
				DO DeleCDX
				INDEX ON code TAG code
				INDEX ON name TAG name ADDI
			CASE mfile = 'OCCUPAT'
				DO DeleCDX
				INDEX ON occupa TAG occu
				INDEX ON name TAG name ADDI
			CASE LEFT(mfile+SPACE(5),5)$ 'PRESC,PXREC'
				DO DeleCDX
				INDEX ON pn TAG pn
				INDEX ON hn TAG hn ADDI
				INDEX ON date TAG date ADDI
			CASE mfile = 'PQUE'
				DO DeleCDX
				INDEX ON pn TAG pn
			CASE mfile = 'CODEFILE'
				DO DeleCDX
				INDEX ON code TAG code
				INDEX ON varname TAG varname ADDI
			CASE mfile = 'USER'
				DO DeleCDX
				INDEX ON name TAG name
			CASE LEFT(mfile,5) = 'INSUR'		&& แฟ้มเก็บข้อมูลบริษัทที่จำหน่าย
				DO DeleCDX
				INDEX ON hn TAG hn
				INDEX ON inscl TAG inscl ADDI
				INDEX ON cid TAG cid ADDI
				INDEX ON dateexp TAG dateexp ADDI
				INDEX ON LEFT(hn,7) + inscl TAG hncl
			CASE LEFT(mfile,5) = 'VISIT'
				DO DeleCDX
		    	INDEX ON date TAG date
	    		INDEX ON nVS_ID TAG vi_id
			    INDEX ON status TAG status
			CASE LEFT(mfile,2) = 'VS' .AND. ISDIGIT(SUBS(mfile,3,1)) .AND. ;
			ISDIGIT(SUBS(mfile,4,1))
				DO DeleCDX
		    	INDEX ON HN TAG HN
	    		INDEX ON VS_ID tag vs_id addi
		    	INDEX ON HN+DTOC(DATE) TAG hndate addi
	    		INDEX ON VS_ID+DTOC(DATE) TAG vs_iddate addi
		    	INDEX ON date TAG date addi
				INDEX ON clinic TAG clinic
				INDEX ON doctor TAG doctor
	    		INDEX ON trfmode TAG trfmode
			CASE LEFT(mfile,4) = 'COME' .AND. ISDIGIT(SUBS(mfile,5,1)) .AND. ;
			ISDIGIT(SUBS(mfile,6,1))
				DO DeleCDX
			    INDEX ON HN TAG HN
    			INDEX ON VS_ID tag vs_id
			    INDEX ON PRIORITY tag PRIORITY
		    	INDEX ON HN+VS_ID TAG hnvi_id addi
			CASE LEFT(mfile,2) = 'CN' .AND. ISDIGIT(SUBS(mfile,3,1)) .AND. ;
			ISDIGIT(SUBS(mfile,4,1)) .AND. ISDIGIT(SUBS(mfile,5,1)) .AND. ;
			ISDIGIT(SUBS(mfile,6,1)) .AND. ISDIGIT(SUBS(mfile,7,1)) .AND. ;
			ISDIGIT(SUBS(mfile,8,1))
				DO DeleCDX
		    	INDEX ON HN tag hn
	    		INDEX ON VS_ID tag vs_id
		    	INDEX ON USRVID tag USRVID
		    CASE mfile = 'FOREIGN'
				DO DeleCDX
				INDEX ON hn TAG hn
				INDEX ON ftype TAG ftype
				INDEX ON nation TAG nation
		    CASE mfile = 'RCPD'
				DO DeleCDX
				INDEX ON an TAG an
				INDEX ON RC_NO TAG RC_NO ADDI &&udc
 		    CASE mfile = 'DTPD'
				DO DeleCDX
				INDEX ON an TAG an
				INDEX ON RC_NO TAG RC_NO ADDI &&udc
		    CASE mfile = 'CREDITPD'
				DO DeleCDX
				INDEX ON an TAG an
				INDEX ON rc_no TAG rc_no
		    CASE mfile = 'RCOPD'
				DO DeleCDX
				INDEX ON hn TAG hn
				INDEX ON rc_no TAG rc_no
 		    CASE mfile = 'DTOPD'
				DO DeleCDX
				INDEX ON hn TAG hn
				INDEX ON rc_no TAG rc_no
		    CASE mfile = 'CREDOPD'
				DO DeleCDX
				INDEX ON hn TAG hn
				INDEX ON rc_no TAG rc_no
			OTHER
				USE (mfile1)
				firstfield = field(1)
				secondfield = FIELD(2)
				USE
				DO CASE
					CASE UPPE(firstfield) = 'HN'
						DO DeleCDX
						INDEX ON hn TAG hn
						IF UPPE(secondfield) = 'AN'
							INDEX ON an TAG an ADDI
						ENDI
					CASE UPPE(firstfield) = 'AN'
						DO DeleCDX
						INDEX ON an TAG an
					CASE UPPE(firstfield) = 'PN'
						DO DeleCDX
						INDEX ON pn TAG pn
					OTHER
						=ALARM1()
						WAIT WIND TIME 5 ;
						'ไม่ทราบว่าแฟ้ม '+mfile+'.DBF ใช้ Field อะไร กรุณา INDEX เอง'
				ENDC
		ENDC
		SET TALK OFF
		RELE WIND echo
		USE
	ENDI
	IF ! toaskfile
		USE (nowdbf) ORDER 1 ALIAS (nowalias)
	ENDI
ENDI

PROC DeleCDX
		SELE 0
		IF FILE(mfile1+'.cdx')
			DELE FILE (mfile1+'.cdx')
		ENDI
		dbfuse = mfile1
		USE (mfile1) EXCL
		SET TALK ON
		dbfuse = ''
