PARA _check
DEFINE WIND person FROM 0,5 TO 2,74 SHAD
EXTERNAL ARRAY hlpname,hlpcode,AmCode,AmName,TamCode,TamName,Tamnum,;
patient1,patient2,contact1,contact2
ON KEY LABEL F9 DO showward
ON KEY LABEL Alt+1 DO JUMP WITH 2
ON KEY LABEL Alt+2 DO JUMP WITH 6
ON KEY LABEL Alt+3 DO JUMP WITH 9
ON KEY LABEL Alt+4 DO JUMP WITH 13
ON KEY LABEL Alt+5 DO JUMP WITH 15
ON KEY LABEL Alt+6 DO JUMP WITH 17
ON KEY LABEL Alt+7 DO JUMP WITH 19
ON KEY LABEL Alt+8 DO JUMP WITH 23
Shift_f2=.T.
		STORE .F. TO usedhosp,usestatrqbe
		IF ! USED('hospcode')
			dbfuse = codedir+'hospcode'
			USE (codedir+'hospcode') ORDER 1 IN 0
			usedhosp = .T.
		ENDI
		IF ! healthin
			IF ! USED('StatRQBE')
				SELE 0
				IF FILE('StatRQBE.dbf')
					dbfuse = 'statrqbe'
					USE StatRQBE
				ELSE
					dbfuse = patientdir+'StatRQBE'
					USE (patientdir+'StatRQBE')
				ENDI
				usestatrqbe = .T.
			ELSE
				SELE StatRQBE
			ENDI
			dbfuse = ''
			LOCA FOR TRIM(UPPE(fieldname)) = 'DISC'
			numline = MEMLINES(code)
			DIME xcode(numline),xcoded(numline)
			FOR i=1 to numline
				STOR mline(desc,i) TO xcoded(i)
				STOR mline(code,i) TO xcode(i)
			NEXT
		ENDI
DO WHIL fq>0
	IF fq=1
		= THAIMODE()
		mess1='[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
		DO bottmess WITH mess1
		@ 4,13 GET patient1(3)
		DO GETKEY WITH patient1(3),4,13
		= EngMode()
		IF patient1(3)='      '
			= ENGMODE()
			ON KEY LABEL Shift+F1
			ON KEY LABEL Shift+F2
			Shift_f2=.F.
			RETU
		ENDI
		lenname = LEN(TRIM(patient1[3]))
		mat = AT(' ',patient1[3])
		DO WHIL mat < lenname .AND. SUBS(patient1[3],mat,2) = '  '
			patient1[3] = LEFT(patient1[3],mat)+SUBS(patient1[3],mat+2)+' '
			lenname = LEN(TRIM(patient1[3]))
			mat = AT(' ',patient1[3])
		ENDD
		IF mat > LEN(patient1[3]) - 6
			= ALARM1()
			WAIT WIND NOWA '  ชื่อใครจะยาวอะไรปานนั้น ใส่ผิดมั๊ง พิมพ์ใหม่อีกทีนะ  '
			fq = 1
		ELSE
			IF _check
				IF fq>0
					hipfound = .F.
					IF ISDIGIT(patient1(3))
						foundperson = .T.
						SELE patient1
						IF LEN(TRIM(patient1[3])) = 13
							SET ORDER TO TAG person_id
							mseek = TRIM(patient1[3])
							IF ! SEEK(mseek) .OR. EMPTY(hn)
								IF FILE(patientdir + 'hipbuff.dbf')
									IF ! USED('hipbuff')
										USE (patientdir+'hipbuff') ORDER TAG person_id IN 0
									ENDI
									IF ! SEEK(mseek,'hipbuff')
										=ALARM1()
										WAIT WIND NOWA 'ไม่มีผู้ป่วยเลขที่บัตรประชาชน ' ;
										+ mseek
										SET ORDER TO 1
										foundperson = .F.
									ELSE
										DO showhip.spr
									ENDI
								ENDI
							ENDI
						ELSE
	    	           		SET ORDER TO 1
    	    	            mhn=PADZERO(TRIM(patient1(3)),7)
        	    	   		IF ! SEEK(mhn)
            	    	  		?? CHR(7)
                	  			WAIT WIND NOWA 'ไม่มีผู้ป่วยเลขประจำตัว '+mhn
                	  			foundperson = .F.
	                	  	ENDI
						ENDI
						IF ! foundperson
            	      		fq=1
               			ELSE
               				DO ScatVar
               				mhn = patient1.hn
                  			DO showfull
	                  		fmax = 24
                  			IF ! hipfound
    		               		fq=fmax-1
        		          		fmin=fmax-1
            		      		new_one = .F.
            		      	ELSE
            		      		fq = 17
            		      	ENDI
               			ENDI
	            	ELSE
    	           		DO chec_new WITH patient1(3),new_one
        	       		IF ! new_one .OR. hipfound
            	   			DO SCatVar
        	       			mhn = patient1.hn
                	  		DO showfull
                  			fmax = 24
                  			IF ! hipfound
	                   			fq=fmax-1
		                  		fmin=fmax-1
		                  	ELSE
		                  		fq = 17
		                  		new_one = .T.
		                  	ENDI
    	           		ENDI
        	    	ENDI
        		 ENDI
	         ENDI
    	     msay=TRIM(patient1(3))
        	 mstype=IIF(AT(',',msay)>0,SUBS(msay,AT(',',msay)+1),' ')
	         @ 4,13 SAY IIF(mstype=' ',patient1(3),mstype+LEFT(msay,AT(',',msay)-1)+SPAC(37-LEN(msay)));
    	     COLO gr+/b
    	     mstype = ',' + TRIM(mstype)

        	 = ENGMODE()
        ENDI
      ENDI
      IF fq=2
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         patient1(2)=IIF(mstype+',' $ ismale,'1',patient1(2))
         patient1(2)=IIF(mstype+',' $ isfemale,'2',patient1(2))
         @ 5,7 SAY IIF(patient1(2) $ '12',sex&patient1(2),'    ') COLO gr+/b
         @ 5,5 GET patient1(2) PICT '9'
         DO getkey WITH patient1(2),5,5
		IF ! patient1(2) $ ' 12'
			?? CHR(7)
			fq=2
		ELSE
			IF (mstype+',' $ ismale .AND. patient1[2] = '2') .OR. ;
			(mstype+',' $ isfemale .AND. patient1[2] = '1')
				= Alarm1()
				WAIT WIND NOWA 'ผู้ป่วยเพศ' + sex&patient1[2] + ' ใช้คำนำหน้า ' + ;
				SUBS(mstype,2) + ' ไม่ได้'
				fq = 1
			ENDI
			@ 5,7 SAY IIF(patient1(2) $ '12',sex&patient1(2),'    ') COLO gr+/b
		ENDI
         @ 5,5 SAY patient1(2) COLO gr+/b
      ENDI
      IF fq=3
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         = THAIMODE()
         @ 5,34 GET contact1(2)
         DO getkey WITH contact1(2),5,34
         = ENGMODE()
         @ 5,34 SAY contact1(2) COLO gr+/b
      ENDI
      IF fq=4
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         mpro=contact1(6)
         @ 6,10 GET contact1(6) PICT '##'
         DO getkey WITH contact1(6),6,10
*        IF UPDATE() .OR. (contact1(6)='  ' .AND. LASTKEY() # 5 ;
*        .AND. LASTKEY() # 19)
            SELE address
            contact1(6)=province('1'+contact1(6),6,10)
            IF contact1(6)#mpro
               UtdPro=.T.
               IF contact1(6)='00'
                  STORE '  ' to contact1(5),contact1(4),contact1(3)
                  @ 6,50 SAY SPAC(28)
                  @ 7,10 SAY SPAC(28)
                  @ 7,50 SAY SPAC(28)
                  fq=IIF(fq=5,8,fq)
               ELSE
                  IF contact1(5)#'  '
                     SEEK '2'+contact1(6)+contact1(4)
                     @ 6,50 SAY contact1(4)+' '+name COLO gr+/b
                     IF contact1(4)#'  '
                        SEEK '3'+contact1(6)+contact1(5)+contact1(4)
                        @ 7,10 SAY contact1(4)+' '+name COLO gr+/b
                     ENDI
                  ENDI
               ENDI
            ENDI
*        ENDI
         @ 6,10 SAY contact1(6)  COLO gr+/b
      ENDI
      IF fq=5
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         mam=contact1(5)
         @ 6,50 GET contact1(5) PICT '##'
        DO getkey WITH contact1(5),6,50
         IF contact1(5)#mam
            IF contact1(5)='  '
               @ 6,53 SAY SPAC(25)
               @ 7,10 SAY SPAC(28)
               @ 7,50 SAY SPAC(28)
               STOR '  ' TO contact1(4),contact1(3)
            ELSE
               SELE address
               contact1(5)=ampur('2'+contact1(6)+contact1(5),6,50)
               IF contact1(5)#mam .AND. contact1(4)#'  '
                  SEEK '3'+contact1(6)+contact1(5)+contact1(4)
                  @ 7,10 SAY contact1(4)+' '+name COLO gr+/b
					ENDI
            ENDI
         ENDI
         @ 6,50 SAY contact1(5) PICT '##' COLO gr+/b
         fq=IIF(fq=6 .AND. contact1(5)='  ',7,fq)
      ENDI
      IF fq=6
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         mtam=contact1(4)
         @ 7,10 GET contact1(4) PICT '##'
         DO GETKEY WITH contact1(4),7,10
         IF contact1(4)#mtam
            IF contact1(4)='  '
               @ 7,10 SAY SPAC(28)
            ELSE
               SELE address
               contact1(4)=tambon('3'+contact1(6)+contact1(5)+contact1(4),7,10)
            ENDI
         ENDI
         @ 7,10 SAY contact1(4) PICT '##' COLO gr+/b
      ENDI
      IF fq=7
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         @ 7,50 GET contact1(3) PICT '##'
         DO getkey WITH contact1(3),7,50
         @ 7,50 SAY contact1(3) PICT '##' COLO gr+/b
         fq=IIF(fq=6 .AND. contact1(5)='  ',5,fq)
      ENDI
      IF fq=8
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         @ 8,11 GET patient2(7) PICT '#########'
         DO getkey WITH patient2(7),8,11
         @ 8,11 SAY patient2(7) PICT '#########' COLO gr+/b
         fq=IIF(contact1(6)='00'.AND.fq=7,4,fq)
      ENDI
      IF fq=9
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         @ 9,11 SAY SPAC(18)
         @ 9,11 GET mbirthday PICT '##/##/####'
         patient1(5)=IIF(patient1(5)=' ','1',patient1(5))
         DO getkey WITH mbirthday,9,11

         IF BE2CE(mbirthday)>DATE()
         	?? CHR(7)
         	WAIT WIND 'ใส่วันเกิดหลังวันนี้ไม่ได้' NOWA
         	fq = 9
         ELSE
         	patient1[5] = '1'
	         IF mbirthday='  ' .AND. LASTKEY() # 5
    	        mage=SPACE(6)
    	        patient1[5] = '2'
        	    valid_input=.F.
            	DO WHIL ! valid_input
            		@ 9,36 SAY SPACE(8)
	               @ 9,36 GET mage PICT '##/###'
    	           READ NOLOCK
        	       @ 9,36 SAY mage COLO gr+/b
            	   IF SUBS(mage,4,3) $ '12 ,365,   '  .AND. VAL(LEFT(mage,2))>0
                	  mbirthday=birthdat(mage)
	                  ce_age=Be2Ce(mbirthday)
    	              showdate=Ce2Cbe(Be2Ce(mbirthday))
        	          @ 9,11 SAY SPAC(18)
            	      @ 9,11 SAY showdate COLO gr+/b
                	  show_age=NowAge(ce_age,'2')
	                  @ 9,36 SAY show_age COLO gr+/b
    	              patient1(5)='2'
        	          valid_input=.T.
            	   ELSE
               			IF LASTKEY() = 5 .OR. LASTKEY() = 19
               				fq = 9
               				EXIT
	               		ELSE
							?? CHR(7)
						ENDI
        	   	   ENDI
            	ENDD
	         ELSE
    	     	IF LASTKEY() # 5
	    	        IF ! TrueDate(mbirthday)
    	    	       ?? CHR(7)
        	    	   fq=9
	            	ELSE
    	            	ce_age=Be2Ce(mbirthday)
	    	            showdate=Ce2Cbe(Be2Ce(mbirthday))
    	    	        show_age=NowAge(ce_age,'1')
        	    	    @ 9,11 SAY SPAC(18)
            	    	@ 9,11 SAY showdate COLO gr+/b
	                	@ 9,36 SAY show_age COLO gr+/b
    	            ENDI
        	     ELSE
       	    	    @ 9,11 SAY SPAC(18)
	             ENDI
    	     ENDI
    	 ENDI
		IF ((((YEAR(DATE()) - YEAR(BE2CE(mbirthday))) > 14) .AND. patient1[5] = '2' ) .OR. (((DATE() - BE2CE(mbirthday)) > 365.25*15) .AND. patient1[5] = '1')) .AND. (mstype+',' $ ischildren)
    		=ALARM1()
    		WAIT WIND NOWA 'เป็นผู้ใหญ่แล้ว ใช้คำนำหน้าว่า ' + SUBS(mstype,2) + ' ไม่ได้'
    		fq = 8
    	ELSE
		IF ((((YEAR(DATE()) - YEAR(BE2CE(mbirthday))) < 15) .AND. patient1[5] = '2' ) .OR. (((DATE() - BE2CE(mbirthday)) <= 365.25*15) .AND. patient1[5] = '1')) .AND. (mstype+',' $ isadult and mstype # ',นาง')
	    		=ALARM1()
    			WAIT WIND NOWA 'เป็นเด็กอยู่ ใช้คำนำหน้าว่า ' + SUBS(mstype,2) + ' ไม่ได้'
    			fq = 8
    		ENDI
    	ENDI
      ENDI
      IF fq=10
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         @ 9,62 GET patient1(5) PICT '9'
         @ 9,64 SAY IIF(patient1(5)$'12',derive&patient1(5),'              ');
          COLO gr+/b
         DO getkey WITH patient1(5),9,62
		IF ! patient1(5) $ '12'
			?? CHR(7)
			fq=10
		ELSE
			@ 9,64 SAY derive&patient1(5) COLO gr+/b
		ENDi
         @ 9,62 SAY patient1(5) PICT '9' COLO gr+/b
      ENDI
      IF fq=11
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         @ 10,11 GET patient2(3) PICT '9'
         @ 10,13 SAY IIF(patient2(3)$'123456',marry&patient2(3),'       ') COLO gr+/b
         DO getkey WITH patient2(3),10,11
         pfq = fq
		IF ! patient2(3) $ '123456 '
			?? CHR(7)
			fq=11
		ELSE
	         @ 10,13 SAY IIF(patient2(3)$'123456',marry&patient2(3),'       ') COLO gr+/b
		ENDI
         @ 10,11 SAY patient2(3) PICT '9' COLO gr+/b
         DO CASE
         	fq = 11
         	CASE patient2[3] $ '2345' .AND. mstype+',' $ ischildren
	         	= ALARM1()
    	     	WAIT WIND NOWA 'ยังเป็นเด็กอยู่เลย แต่งงานไม่ได้หรอก'
    	     CASE mstype+',' $ isbuddha .AND. ! patient2[3] $ ' 6'
    	     	= ALARM1()
    	     	WAIT WIND NOWA ' ' + SUBS(mstype,2) + ' เป็นคำนำหน้าของนักบวช'
    	     CASE mstype+',' $ ismarried .AND.  patient2[3] $ '1'
    	     	= ALARM1()
    	     	WAIT WIND NOWA ' ' + SUBS(mstype,2) + ' เป็นคำนำหน้าของคนที่แต่งงานแล้ว'
    	     OTHER
    	     	fq = pfq
        ENDC

      ENDI
      IF fq=12
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         SELE occupat
         @ 10,30 GET patient2(4)
         mtitle=' อาชีพ'
         DO getkey WITH patient2(4),10,30
         IF patient2(4) # ' '
            IF ! SEEK(patient2(4)) .AND. fq>0
               ?? CHR(7)
               fq=12
            ELSE
               @ 10,34 SAY LEFT(name,44) COLO gr+/b
            ENDI
		ELSE
			@ 10,34 SAY SPACE(44)
         ENDI
         @ 10,30 SAY patient2(4) COLO gr+/b
      ENDI
      IF fq=13
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         SELE nation
         @ 11,12 GET patient2(6)
         mtitle='เชื้อชาติ'
         DO getkey WITH patient2(6),11,12
         IF patient2(6) # ' '
            IF ! SEEK(patient2(6)) .AND. fq>0
               ?? CHR(7)
               fq=13
               @ 11,15 SAY SPACE(35)
            ELSE
               @ 11,15 SAY name COLO gr+/b
            ENDI
         ELSE
			@ 11,15 SAY SPACE(35)
         ENDI
         @ 11,12 SAY patient2(6) COLO gr+/b
      ENDI
      IF fq=14
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         SELE nation

         @ 12,12 GET patient2(5)
         mtitle=' สัญชาติ'
         DO getkey WITH patient2(5),12,12
         IF patient2(5) # ' '
            IF ! SEEK(patient2(5)) .AND. fq>0
               ?? CHR(7)
               fq=14
               @ 12,15 SAY SPACE(35)
            ELSE
               @ 12,15 SAY name COLO gr+/b

			   **-------------------------- เพิ่มตามคำสั่งกระทรวง 1 สค. 2539
			   DO vnation WITH patient2(5)

            ENDI
		ELSE
			@ 12,15 SAY SPACE(35)
		ENDI
         @ 12,12 SAY patient2(5) COLO gr+/b
      ENDI
      IF fq=15
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         = THAIMODE()
         @ 13,10 GET patient1(6)
         DO getkey WITH patient1(6),13,10
         = ENGMODE()
         msay=TRIM(patient1(6))
         mstype1=IIF(AT(',',msay)>0,SUBS(msay,AT(',',msay)+1),' ')
         @ 13,10 SAY IIF(mstype1=' ',patient1(6),mstype1+LEFT(msay,AT(',',msay)-1)+SPAC(37-LEN(msay)));
          COLO gr+/b
      ENDI
      IF fq=16
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         = THAIMODE()
         @ 14,10 GET patient1(10)
         DO getkey WITH patient1(10),14,10

         = ENGMODE() COLO gr+/b
         msay=TRIM(patient1(10))
         mstype2=IIF(AT(',',msay)>0,SUBS(msay,AT(',',msay)+1),' ')
         @ 14,10 SAY IIF(mstype2=' ',patient1(10),mstype2+LEFT(msay,AT(',',msay)-1)+SPAC(37-LEN(msay)));
          COLO gr+/b
          fq = IIF(fq = 17 .AND. healthin,23,fq)
      ENDI
      IF fq=17
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         = THAIMODE()
         @ 15,19 GET patient2(2)
         DO getkey WITH patient2(2),15,19
         first_loop=.F.
		= EngMode()
         DO case
            case patient2(2)='1'
                patient2(2)=patient1(6)
            case patient2(2)='2'
                patient2(2)=patient1(10)
         ENDC
         msay=TRIM(patient2(2))
         mstype3=IIF(AT(',',msay)>0,SUBS(msay,AT(',',msay)+1),' ')
         @ 15,19 SAY IIF(mstype3=' ',patient2(2),mstype3+LEFT(msay,AT(',',msay)-1)+SPAC(37-LEN(msay)));
          COLO gr+/b
         = ENGMODE()
      ENDI
      IF fq=18
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         = THAIMODE()
         @ 16,19 GET contact2(2)
         DO getkey WITH contact2(2),16,19
		= EngMode()
         IF contact2(2)='บ.ด.ก.'
         	fq=IIF(fq=19,23,fq)
         	@ 16,19 SAY 'บ.ด.ก.'+SPACE(19) COLO gr+/b
         	@ 17,10 SAY SPAC(28)
         	@ 17,50 SAY SPAC(28)
         	@ 18,10 SAY SPAC(28)
         	@ 18,50 SAY SPAC(2)
         ELSE
         	@ 16,19 SAY contact2(2) COLO gr+/b
         ENDI
         = ENGMODE()
      ENDI
      IF fq=19
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         mpro=contact2(6)
         @ 17,10 GET contact2(6) PICT '##'
         DO getkey WITH contact2(6),17,10
         IF UPDATE() .OR. contact2(6)='  '
            SELE address
            contact2(6)=province('1'+contact2(6),17,10)
            IF contact2(6)#mpro
               IF contact2(6)='00'
                  STORE '  ' to contact2(5),contact2(4),contact2(3)
                  @ 17,50 SAY SPAC(28)
                  @ 18,10 SAY SPAC(28)
                  @ 18,50 SAY SPAC(28)
                  fq=IIF(fq=20,23,fq)
               ELSE
                  IF contact2(5)#'  '
                     SEEK '2'+contact2(6)+contact2(4)
                     @ 17,50 SAY contact2(4)+' '+name COLO gr+/b
                     IF contact2(4)#'  '
                        SEEK '3'+contact2(6)+contact2(5)+contact2(4)
                        @ 18,10 SAY contact2(4)+' '+name COLO gr+/b
                     ENDI
                  ENDI
               ENDI
            ENDI
         ENDI
         @ 17,10 SAY contact2(6) PICT '##' COLO gr+/b
      ENDI
      IF fq=20
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         mam=contact2(5)
         @ 17,50 GET contact2(5) PICT '##'
         DO getkey WITH contact2(5),17,50
         IF contact2(5)#mam
            IF contact2(5)='  '
               @ 17,53 SAY SPAC(25)
               @ 18,10 SAY SPAC(28)
               @ 18,50 SAY SPAC(28)
               STOR '  ' TO contact2(4),contact2(3)
            ELSE
               SELE address
               contact2(5)=Ampur('2'+contact2(6)+contact2(5),17,50)
               IF contact2(5)#mam .AND. contact2(4)#'  '
                  SEEK '3'+contact2(6)+contact2(5)+contact2(4)
                  @ 18,10 SAY contact2(4)+' '+name COLO gr+/b
		       ENDI
            ENDI
         ENDI
         @ 17,50 SAY contact2(5) PICT '##' COLO gr+/b
         fq=IIF(fq=21 .AND. contact2(5)='  ',22,fq)
      ENDI
      IF fq=21
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         mtam=contact2(4)
         @ 18,10 GET contact2(4) PICT '##'
         DO GETKEY WITH contact2(4),18,10
         IF contact2(4)#mtam
            IF contact2(4)='  '
               @ 18,10 SAY SPAC(28)
            ELSE
               SELE address
               contact2(4)=tambon('3'+contact2(6)+contact2(5)+contact2(4),18,10)
            ENDI
         ENDI
         @ 18,10 SAY contact2(4) PICT '##' COLO gr+/b
      ENDI
      IF fq=22
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         @ 18,50 GET contact2(3) PICT '##'
         DO getkey WITH contact2(3),18,50
         @ 18,50 SAY contact2(3) PICT '##' COLO gr+/b
         fq=IIF(fq=21 .AND. contact2(5)='  ',20,fq)
      ENDI
      IF fq=23
         DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
         SELE social
         mtitle='สิทธิการรักษา'
         @ 19,16 GET patient1(8)
         DO getkey WITH patient1(8),19,16
         IF patient1(8) # ' '
*        susp
            IF ! SEEK(patient1(8)) .AND. fq>0
               ?? CHR(7)
               WAIT 'ไม่พบชื่อสิทธิการรักษา' WIND NOWAIT
               fq=23
            ELSE
            	IF ! new_one
            		SELE insure
            		SET ORDER TO TAG hncl
            		= SEEK(LEFT(mhn,7) + patient1[8] )
            		precid = m.cid
            		SCAT MEMV
            		m.startdate = CE2BE(datein,4)
            		m.enddate = CE2BE(dateexp,4)
            		m.namestart = CE2CBE(datein)
            		m.nameend = CE2CBE(dateexp)
            		= SEEK(hospmain,'hospcode')
            		m.namemain =hospcode.name
            		= SEEK(hospsub,'hospcode')
            		m.namesub =hospcode.name
*            		SET ORDER TO TAG hn
*           		m.cid = IIF( ! EMPTY(precid), precid, m.cid)
            	ENDI
               @ 19,19 SAY social.name COLO gr+/b
               m.birth = BE2CE(mbirthday)

* udc cx 12*12 to 12*13
               IF (patient1[8] $ youngright .AND. DATE() > GOMONTH(m.birth,12*13) - 1) ;
               OR (patient1[8] $ oldright AND DATE() < GOMONTH(m.birth,12*60) ) ;
               OR (patient1[8] $ poorright+','+disableright+','+studentright+','+warright ;
               AND ! BETWEEN(DATE(),GOMONTH(m.birth,12*12),GOMONTH(m.birth,12*60) - 1) ) ;
               OR (patient1[8] $ monkright AND (patient2[3] # '6' OR ! BETWEEN(DATE(),GOMONTH(m.birth,12*12),GOMONTH(m.birth,12*60) - 1) ))
               		=ALARM1()
               		WAIT WIND NOWA 'อายุกับสิทธิ์ที่แจ้งไม่ถูกต้อง กรุณาตรวจสอบใหม่' ;
               		+ IIF(patient1[8] $ monkright AND patient2[3] # '6' AND ;
               		BETWEEN(DATE(),GOMONTH(m.birth,12*13),GOMONTH(m.birth,12*60) - 1), CHR(13) + ;
               		'สิทธิภิกษุ/ผู้นำศาสนา ต้องใส่สภาพสมรสเป็น 6 = ภิกษุ', IIF( ! patient1[8] $ monkright ;
               		AND patient2[3] = '6' AND BETWEEN(DATE(),GOMONTH(m.birth,12*13),GOMONTH(m.birth,12*60) - 1), ;
               		CHR(13) + 'สภาพสมรสเป็นภิกษุ ต้องใส่สิทธิภิกษุ/ผู้นำศาสนา', '') )
               		fq = 23
               	ELSE
					DO insure.spr
				ENDI
            ENDI
		ELSE
			@ 19,19 SAY SPAC(LEN(name))
		ENDI
         @ 19,16 SAY patient1(8) COLO gr+/b
	     fq = IIF(fq = 24 .AND. healthin,-1,IIF(healthin,16,fq))
         fq=IIF(fq=22 .AND. TRIM(contact2(2))='บ.ด.ก.',18,fq)
      ENDI
	IF fq=24
		DO bottmess WITH '[Esc] = สิ้นสุดการใส่ข้อมูล  [F1]=ขอความช่วยเหลือ'
		SELE clinic
		@ 20,16 GET patient1(9)
		mtitle='คลีนิคตรวจ'
		DO getkey WITH patient1(9),20,16
		IF LASTKEY() = 5 .OR. LASTKEY() = 19
			fq = 23
			@ 20,16 SAY patient1(9)
		ELSE
			IF ! SEEK(patient1(9))
				?? CHR(7)
				WAIT 'ไม่พบชื่อคลีนิคที่มาตรวจ' WIND NOWAIT
					fq=24
			ELSE
				@ 20,20 SAY name COLO gr+/b
			ENDI
			@ 20,16 SAY patient1(9) COLO gr+/b
		ENDI
	ENDI
ENDD
ON KEY LABEL Shift+F1
ON KEY LABEL Shift+F2
ON KEY LABEL Alt+1
ON KEY LABEL Alt+2
ON KEY LABEL Alt+3
ON KEY LABEL Alt+4
ON KEY LABEL Alt+5
ON KEY LABEL Alt+6
ON KEY LABEL Alt+7
ON KEY LABEL Alt+8
ON KEY LABEL F9
Shift_f2=.F.
		IF USEstatrqbe
			SELE statrqbe
			USE
		ENDI
		IF usedhosp
			SELE hospcode
			USE
		ENDI

PROC JUMP
PARA _where
KEYB "{ENTER}"
fq=IIF(_where>=fmin .AND. _where<=fmax,_where-1,fq)

PROC ShowWard
IF ! healthin
PRIV nowalia,mdateadm,mhn,nowrec,mward_adm,numline,i,useother,yearopen,admit
nowalia = ALIAS()
mhn = patient1.hn
useother = .F.
tempdbf = SYS(3)
STORE .F. TO admit
SELE iptrana
COPY TO (tempdbf) STRU CDX
USE (tempdbf) IN 0 ORDER TAG an ALIA tempdbf
SET ORDER TO TAG hn
SET RELA TO an INTO tempdbf
IF SEEK(mhn)
	DO WHIL hn = mhn
		IF EOF('tempdbf')
			SCAT MEMV
			INSERT INTO tempdbf FROM MEMV
		ENDI
		SKIP
	ENDD
ENDI

yearopen = RIGHT(CE2BE(DATE()),2)
SELE 0
IF ! FILE(ipddir+'data\adm'+yearopen+'.dbf')
	yearopen = STRZERO(VAL(yearopen)-1,2)
ENDI
DO WHIL FILE(ipddir+'data\adm'+yearopen+'.dbf') AND RECCOUNT('tempdbf') < 10
	useother = .T.
	USE (ipddir+'data\adm'+yearopen) ORDER TAG hn ALIA last
	SET RELA TO an INTO tempdbf
	IF SEEK(mhn)
		DO WHIL hn = mhn
			IF EOF('tempdbf')
				SCAT MEMV
				INSERT INTO tempdbf FROM MEMV
			ENDI
			SKIP
		ENDD
	ENDI
	yearopen = STRZERO(VAL(yearopen)-1,2)
ENDD
SELE tempdbf
IF RECCOUNT() > 0
	SET ORDER TO TAG AN
	IF RECCOUNT() <= 5
		GO TOP
	ELSE
		GO BOTT
		SKIP -4
	ENDI
	DEFINE WIND notice1 FROM 0,2 TO 2,78 NONE COLO r+/w
	DEFINE WIND notice FROM 3,2 TO 21,78 NONE COLO r+/w
	DEFINE WIND notice2 FROM 22,2 TO 24,78 NONE COLO r+/w
	ACTI WIND notice1
*	@ 0,0
	? ' ผู้ป่วย'+TRIM(DE_NAME(patient1.name))
	ACTI WIND notice
	numadmit = 1
	DO WHIL ! EOF()
		SCAT MEMV
		mward_adm = ward_adm
		sdatedsc=datedsc
		sward_now = ward_now
		m.disc = LEFT(disc,2)
		?
		? '   เลขที่ผู้ป่วยใน ' + RIGHT(m.an,5)+'-'+LEFT(m.an,2)
		?? '   รับไว้วันที่ '+ TRIM(CE2CBE(m.dateadm)) + SPACE(1)
		SELE WARD
		SEEK sward_now
		? '   อยู่ที่ตึก ' + TRIM(name)
		IF ! EMPTY(sdatedsc)
			? '   ออกจากโรงพยาบาลเมื่อวันที่ ' + CE2CBE(sdatedsc) + SPACE(2)
			nameresult =xcoded[ASCAN(xcode,m.disc)]
			nameresult  = TRIM(nameresult)
			IF RIGHT(m.disc,1)='4'
				SELE hospcode
				SEEK m.place
				nameresult = TRIM(nameresult)+;
				IIF(EMPTY(name),'ไม่ได้ระบุรพ.ที่ส่งต่อ',TRIM(De_name(name)))
			ENDI
			? '   ผลการรักษา '+ nameresult
		ENDI
		SELECT tempdbf
		SKIP
		numadmit = numadmit + 1
		IF numadmit = 5 AND ! EOF()
			ACTI WIND notice2
			@ 1,5 SAY 'กดปุ่มอะไรก็ได้เพื่อทำงานต่อ'
			WAIT ''
			ACTI WIND notice
		ENDI
	ENDD
	ACTI WIND notice2
	@ 1,5 SAY 'กดปุ่มอะไรก็ได้เพื่อทำงานต่อ'
	WAIT ''
	DEACTI WIND notice, notice1, notice2
ELSE
	WAIT WIND NOWA 'ผู้ป่วยไม่เคยมีประวัติรับไว้ในโรงพยาบาล'
ENDI
IF useother
	SELE last
	USE
ENDI
SELE tempdbf
USE
DELE FILE (tempdbf+'.dbf')
DELE FILE (tempdbf + '.cdx')
SELE (nowalia)
ACTI SCREE
ENDI

****************
PROCEDURE VNATION
****************
PARAMETER _nation
PRIVATE ftype,nation

dbfuse = patientdir+'foreign'
= OpenDBF(dbfuse,'foreign')
dbfuse = ''
SELECT foreign
GO TOP
IF EOF()
	APPEND BLANK
ENDIF
IF _nation <> '99'
	fcode = SPACE(2)
	@ 12,52 SAY 'ประเภท'
	@ 12,62 GET ftype PICTURE '#' COLOR gr+/b
		READ NOLOCK
ENDIF
RETURN