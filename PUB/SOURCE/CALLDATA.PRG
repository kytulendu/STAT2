PARA _driveuse,_fileuse
PRIV type,yymm,reportfile,select
IF ! FILE(_driveuse+_fileuse+'.zip')
	=ALARM1()
	WAIT WIND NOWA 'ไม่พบแฟ้มข้อมูล '+_fileuse+' ในไดร์ฟ '+_driveuse
ELSE
	unzipfile = _driveuse+_fileuse
	RUN pkunzip -o &unzipfile
	type = LEFT(_fileuse,2)
	yymm = RIGHT(_fileuse,4)
	reportfile = 'report\'+type+'t'+yymm
	SELE 0
	IF ! FILE(reportfile+'.dbf')
		IF UPPE(type)='OP'
			CREA TABLE (reportfile) ;
				(HN C(7),CHANGWAT C(2),AMPUR C(2),TAMBON C(2),VILLAGE C(2),;
				SEX C(1),AGE_TYPE C(1),AGE N(2),MARRIAGE C(1),OCCUPA C(3),;
				NATION C(2),WARD C(3),DATE C(8),DG1 C(7),EPISODE1 C(1),;
				DG2 C(7),EPISODE2 C(1),DG3 C(7),EPISODE3 C(1),DG4 C(7),;
				EPISODE4 C(1),ONSET N(2),RESULT C(2),REFERIN C(12),REFEROUT ;
				C(12),CAUSEIN C(2),CAUSEOUT C(2),PTTYP C(2), SRV_CODE C(12))
		ELSE
			CREA TABLE (reportfile) ;
			(AN C(7), HN C(9), CHANGWAT C(2), AMPUR C(2),;
			SEX C(1), AGE_TYPE C(1),  AGE N(2,0), MARRIAGE C(1), OCCUPA C(3),;
			NATION C(2), WARD C(3), DATEADM C(8), DATEDSC C(8), DG1 C(7),;
			DG2 C(7), DG3 C(7), DG4 C(7),OP1 C(7), OP2 C(7), OP3 C(7), ;
			OP4 C(7), ONSET N(2,0),DISCHS C(1), DISCHT C(1), REFERIN C(12), ;
			REFEROUT C(12), CAUSEIN C(2),CAUSEOUT C(2), PTTYP C(2),SRV_CODE C(12))
		ENDI
		USE
	ENDI
	USE (reportfile) ALIA target EXCL
	USE (_fileuse) IN 0 ALIA source
	LOCA FOR srv_code = codehosp
	m.srv_code = codehosp
	IF ! EOF()
		ACTI SCREE
		CLEA
		ACTI WIND ask
		=ALARM1()
		CLEA
		@ 1,0 SAY 'มีข้อมูลของ '+namehosp+' อยู่แล้ว ท่านต้องการ'
		@ 3,10 PROMPT 'ยกเลิกการดึงข้อมูล'
		@ 4,10 PROMPT 'เพิ่มข้อมูลลงไป'
		@ 5,10 PROMPT 'เขียนทับข้อมูลเก่า'
		MENU TO select
		IF select > 1
			IF select = 3
				WAIT WIND NOWA 'โปรดคอย ! กำลังทำเครื่องหมายข้อมูลเก่าอยู่'
				DO WHIL srv_code = codehosp .AND. ! EOF()
					DELE
					SKIP
				ENDDO
*				DELE ALL FOR srv_code = codehosp
				KEYB '!'
				=INKEY()
			ENDI
			SELE source
			div_num=ROUND((RECCOUNT()/40)+.5,0)
			recno = 0
			DO ShowProgress WITH 'โปรดคอย กำลังเขียนข้อมูล'
			SCAN
				recno=recno+1
				@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
				SCAT MEMV
				INSERT INTO target FROM MEMV
			ENDS
			RELE WIND showprogress
			IF select = 3
				SELE target
				WAIT WIND NOWA 'โปรดคอย ! กำลังลบข้อมูลเดิมออก'
				PACK
				KEYB '!'
				= INKEY()
			ENDI
		ENDI
	ELSE
		SELE source
		div_num=ROUND((RECCOUNT()/40)+.5,0)
		recno = 0
		DO ShowProgress WITH 'โปรดคอย กำลังเขียนข้อมูล'
		SCAN
			recno=recno+1
			@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
			SCAT MEMV
			INSERT INTO target FROM MEMV
		ENDS
		RELE WIND showprogress
	ENDI
	SELE source
	USE
	SELE target
	USE
	DELE FILE (_fileuse+'.dbf')
ENDI