IF USED('inp')
	SELE INP
	USE
	SELE DIAGNOSIS
	USE
	SELE OPERATION
	USE
	reopen = .T.
	pmm = mm
	pyy = yy
ELSE
	reopen = .F.
ENDI

DEFINE WIND mostcommon FROM 8,20 TO 13,60 SHAD
STOR SPAC(8) TO startdate,enddate
ACTI WIND mostcommon
CLEA
@ 1,4 SAY '��ͧ����ҵ�����ѹ���  ' get startdate PICT '##/##/##' ;
VALID TRUEDATE(startdate)
@ 2,4 SAY '          �֧�ѹ���     ' get enddate PICT '##/##/##' ;
VALID TRUEDATE(enddate)
READ NOLOCK
mstartdate = BE2CE(startdate)
menddate = BE2CE(enddate)
IF menddate < mstartdate
	= SWAP(mstartdate,menddate)
	= SWAP(startdate,enddate)
ENDI
mm = RIGHT(startdate,2)
yy = SUBS(startdate,4,2)
mm1 = RIGHT(enddate,2)
yy1 = SUBS(enddate,4,2)

RELE WIND mostcommon
startfile=RIGHT(startdate,2)+SUBS(startdate,4,2)
endfile=RIGHT(enddate,2)+SUBS(enddate,4,2)
err_mth=''
many = startfile # endfile
STOR .F. TO monthly,yearly
IF startfile = endfile ;
.AND. DAY(mstartdate) = 1 .AND. DAY(menddate+1) = 1
	monthly = .T.
ELSE
	IF DAY(mstartdate) = 1 .AND. MONTH(mstartdate) = 10 .AND. ;
	DAY(menddate) = 30 .AND. MONTH(menddate) = 9 .AND. YEAR(menddate) ;
	= YEAR(mstartdate) + 1
		yearly = .T.
	ENDI
ENDI
DEFINE WIND rep2 FROM 10,10 TO 15,70 SHAD
ACTI WIND rep2
goon1=IIF(LASTKEY() = 27 ,'N', 'Y')
myear = FULLYEAR(menddate)
IF yearly .AND. FILE(ipddir+'report\most'+myear+'.dbf')
   =TONE(600,10)
   goon1='N'
   CLEA
   @ 1,5 SAY '����է�����ҳ '+myear+'����������'
   @ 3,6 SAY '��ͧ��äӹǳ�����������  ' GET goon1 PICT '!'
   READ NOLOCK
ENDI
IF goon1='Y'
	CLEA
	goon = 'Y'
	IF many
		@ 0,Center('�ô����ѡ����') SAY '�ô����ѡ����'
      	@ 1,Center('���ѧ��Ǩ�ͺ�������������') SAY '���ѧ��Ǩ�ͺ�������������'
      	has_err=.F.                 && �������԰ҹ���������ú�ء��͹
      	DO chec_rep
      	IF has_err
         	goon='N'
         	yearly = .F.
         	?
         	@ ROW(),2 SAY '��ͧ��÷ӧҹ������  ' GET goon PICT '!'
         	READ NOLOCK
      	ENDI
	ELSE
    	IF ! FILE(ipddir+"data\diag"+startfile+'.dbf') .AND. ! ;
    	FILE(ipddir+"report\most"+startfile+'.dbf')
        	=TONE(600,10)
        	CLEA
			@ 1,2 SAY "����������������§ҹ"+_type+" "+month&mm+' '+Fullyear(yy)
      		mkey=INKEY(30)
      		goon = 'N'
     	ENDI
   	ENDI
   	IF goon = 'Y'
	   	CLEA
	   	SELE 0
	   	mfile = tempdir+sys(3)
	   	dbfuse = mfile
		CREA TABLE (mfile) (diag C(7),male N(10),female N(10),number N(10))
		INDEX ON DIAG TAG diag
		INDEX ON number TAG number ADDI
   		USE (mfile) ORDER 1 ALIA mostrep
   		dbfuse = ''
		@ 0,Center('�ô����ѡ����') SAY '�ô����ѡ����'
		@ 2,Center('���ѧ����������ŷ���§ҹ') SAY '���ѧ����������ŷ���§ҹ'
    	IF yearly
	    	SELE 0
		    	dbfuse = ipddir+'report\most'+myear
	    	IF ! FILE(ipddir+'report\most'+myear+'.dbf')
				CREA TABLE (ipddir+'report\most'+myear) (diag C(7),male N(10),female N(10),number N(10))
				INDEX ON DIAG TAG diag
				INDEX ON number TAG number ADDI
	    		USE (ipddir+'report\most'+myear) ORDER 1 ALIA yearrep
	    	ELSE
	    		USE (ipddir+'report\most'+myear) ORDER 1 ALIA yearrep
				REPL ALL number WITH 0,male WITH 0,female WITH 0
				FLUSH
	    	ENDI
	    	dbfuse = ''
	    ENDI
	    SELE 0
	    Calfile = startfile
		DO WHIl calfile <= endfile
			IF FILE(ipddir+'data\diag'+calfile+'.dbf') .OR. FILE(ipddir+'report\most'+calfile+'.dbf')
				IF calfile = startfile
					IF DAY(mstartdate) = 1
						IF calfile # endfile
							DO calmost WITH .T.
						ELSE
							DO calmost WITH DAY(menddate+1) = 1
						ENDI
					ELSE
						DO calmost WITH .F.
					ENDI
				ELSE
					IF calfile = endfile
						DO calmost WITH DAY(menddate+1) = 1
					ELSE
						DO calmost WITH .T.
					ENDI
				ENDI
			ENDI
			calfile = IIF( RIGHT(calfile,2)='12', ;
			RIGHT(STRZERO(VAL(LEFT(calfile,2))+1,3),2)+'01', ;
			STRZERO(VAL(calfile)+1,4) )
		ENDD
		RELE WIND progress
		KEYB '{HOME}'
		DO ShowReport
		SELE mostrep
		USE
		DELE FILE (mfile+'.dbf')
		DELE FILE (mfile+'.cdx')
		IF yearly
   			SELE yearrep
			USE
   		ENDI
    ENDI
ELSE
	IF yearly .AND. FILE(ipddir+'report\most'+myear+'.dbf')
		dbfuse = ipddir+'report\most'+myear
		USE (ipddir+'report\most'+myear) ORDER 1 IN 0 ALIA mostrep
		dbfuse = ''
		DO ShowReport
		SELE mostrep
		USE
	ENDI
ENDI
RELE WIND rep2
IF reopen
	mm = pmm
	yy = pyy
	DO Openfile1
ENDI

PROC SHOWREPORT
		SELE mostrep
		SET ORDER TO TAG number DESC
		mostchoice = 1
		DO WHIL mostchoice > 0
			ACTI WIND rep2
			CLEA
			@ 1,3 PROMPT '1. ��§ҹ�ä'
			@ 2,3 PROMPT '2. ��§ҹ�ѵ����'
			@ 3,3 PROMPT '0. ��Ѻ��¡�����'
			MENU TO mostchoice
			mostchoice = IIF(mostchoice = 3, 0 ,mostchoice)
			IF mostchoice > 0
				CLEA
				@ 1,2 SAY '��ͧ�����§ҹ����ӴѺ ' GET numrep DEFA 10
				READ NOLOCK
				IF mostchoice = 1
					header = '��§ҹ�ä��辺����'
					fileseek = 'icd101'
					SET FILT TO LEFT(diag,1) # '*' .AND. ! ISDIGIT(diag)
				ELSE
					header = '��§ҹ�ѵ���÷�辺����'
					fileseek = 'icdcm1'
					SET FILT TO LEFT(diag,1) = '*' .OR. ISDIGIT(diag)
				ENDI
				DEAC WIND rep2
				ACTI SCREE
				reportfile=tempdir+sys(3)+'.txt'
				SET PRINT TO &reportfile
				SET PRINT ON
				SET CONS OFF
				_wrap=.F.
				_plength=41
				_peject='NONE'
				_pageno=1
				_plineno=0
				_PLOFFSET = 0
				ON PAGE AT line _plength-2 DO mostheader WITH .T.,header
				PRINTJOB
					DO mostheader WITH .F.,header
					GO TOP
					numdisp = 1
					DO WHIL ! EOF() .AND. numdisp <= numrep
						SELE (fileseek)
						SEEK IIF(fileseek = 'icd101', mostrep.diag, ;
						IIF(LEFT(mostrep.diag,1)='*',SUBS(mostrep.diag,2,4),LEFT(mostrep.diag,4)))
*					SEEK mostrep.diag
						? STR(numdisp,4)+'. '+LEFT(ShowICD(mostrep.diag)+SPACE(7),7)+LEFT(desc,45)+;
						TRANSFORM(mostrep.number,'99,999,999,999')+TRANSFORM(mostrep.male,'9,999,999,999')+;
						TRANSFORM(mostrep.female,'9,999,999,999')
						SELE mostrep
						SKIP
						numdisp = numdisp+1
					ENDD
					?
					? '�����˵�'
					? SPAC(10)+'�����ŵ�����ѹ��� '+CE2CBE(mstartdate)+' �֧�ѹ��� '+CE2CBE(menddate)
					IF ! EMPTY(err_mth)
						? SPAC(10)+'��辺��������͹ '+err_mth
					ENDI
					?
				ENDPRINTJOB
				mkeylabel=ON('KEY','F1')
				ON KEY LABEL F1 DO helpbrow
				DO Endprint WITH '  ��§ҹ�ä��辺����  ',reportfile
				ON KEY LABEL F1 &mkeylabel
				DELE FILE &reportfile
	    	ENDI
	    ENDD

PROC CHEC_REP
checkfile = startfile
DO WHIL checkfile <= endfile
	yyy = LEFT(checkfile,2)
	mmm = RIGHT(checkfile,2)
	IF ! FILE(ipddir+'data\diag'+checkfile+'.dbf') .AND. ;
		! FILE(ipddir+'report\most'+checkfile+'.dbf')
		=TONE(400,4)
		? '��辺�����͹'+month&mmm+' '+FULLYEAR(yyy)
		has_err=.T.               && ��Ǩ�����������ҧ��͹�Ҵ����
		err_mth = err_mth + month&mmm+' '+FullYear(yyy) + ','
		=INKEY(.5)
	ENDI
   checkfile = IIF(mmm = '12', STRZERO(VAL(yyy)+1,2)+'01',yyy+STRZERO(VAL(mmm)+1,2))
ENDD
IF  has_err
	err_mth = LEFT(err_mth,LEN(err_mth)-1)
ENDI
*RELE WIND err_check

PROC CALMOST
PARA _makefile
PRIVATE _update
_update = .F.
SELE 0
IF _makefile
	openfile = ipddir+'report\most'+calfile
	m1 = ADIR(arr1,openfile+'.dbf')
	m2 = ADIR(arr2,ipddir+'data\diag'+calfile+'.dbf')
	IF ! EMPTY(m1) .AND. ! EMPTY(m2)
		_update = DTOS(arr2[3])+arr2[4] > DTOS(arr1[3])+arr1[4]
		IF _update
			dbfuse = ipddir+'data\diag'+calfile
			USE (ipddir+'data\diag'+calfile) ORDER 1 ALIA source
			dbfuse = ipddir+'data\in'+calfile
			USE (ipddir+'data\in'+calfile)  in 0 ALIA in
			dbfuse = ipddir+'data\oper'+calfile
			USE (ipddir+'data\oper'+calfile) ORDER 1 IN 0 ALIA oper
		ELSE
			dbfuse = openfile
			USE (openfile) ORDER 1 ALIA source
		ENDI
		dbfuse = ''
	ELSE
		IF EMPTY(m1)
			dbfuse = openfile
			CREA TABLE (openfile) (diag C(7),male N(10),female N(10),number N(10))
			INDEX ON DIAG TAG diag
			INDEX ON number TAG number ADDI
			dbfuse = ipddir+'data\diag'+calfile
			USE (ipddir+'data\diag'+calfile) ORDER 1 ALIA source
			dbfuse = ipddir+'data\in'+calfile
			USE (ipddir+'data\in'+calfile)  in 0 ALIA in
			dbfuse = ipddir+'data\oper'+calfile
			USE (ipddir+'data\oper'+calfile) ORDER 1 IN 0 ALIA oper
			_update = .T.
		ELSE
			dbfuse = openfile
			USE (openfile) ORDER 1 ALIA source
		ENDI
		dbfuse = ''
	ENDI
	IF _update
		dbfuse = openfile
		USE (openfile) ORDER 1 IN 0 ALIA target
	ENDI
	dbfuse = ''
ELSE
	dbfuse = ipddir+'data\diag'+calfile
	USE (ipddir+'data\diag'+calfile) ORDER 1 ALIA source
	dbfuse = ipddir+'data\in'+calfile
	USE (ipddir+'data\in'+calfile)  in 0 ALIA in
	dbfuse = ipddir+'data\oper'+calfile
	USE (ipddir+'data\oper'+calfile) ORDER 1 IN 0 ALIA oper
ENDI
dbfuse = ''
IF ! _update
	SELE source
	SET RELA TO diag INTO mostrep
	IF yearly
		SET RELA TO diag INTO yearrep ADDI
	ENDI
ENDI
IF _update .OR. (! _update .AND. ! _makefile)
	SELE in
	SET RELA TO hn INTO patient1 ADDI
*	SET RELA TO an INTO source ADDI
*	SET RELA TO an INTO oper ADDI
ENDI
div_num=ROUND((RECCOUNT()/40)+.5,0)
recno = 0
DO ShowProgress
calmm = RIGHT(calfile,2)
calyy = LEFT(calfile,2)
WAIT WIND NOWA '���ѧ�ӹǳ��������͹ '+month&calmm+' �.�. '+FULLYEAR(calyy)
SCAN
	recno=recno+1
	@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '�' COLO gr+
	m.diag = source.diag
	IF _update
		DO ProcessCal
		SELE in
	ELSE
		IF _makefile
			IF EMPTY(mostrep.diag)
				INSERT INTO mostrep FROM MEMV
				FLUSH
			ENDI
			REPL mostrep.male WITH mostrep.male+source.male, ;
			mostrep.female WITH mostrep.female+source.female, ;
			mostrep.number WITH mostrep.number+source.number
			FLUSH
			IF yearly
				IF EMPTY(yearrep.diag)
					INSERT INTO yearrep FROM MEMV
					FLUSH
				ENDI
				REPL yearrep.male WITH yearrep.male+male, yearrep.female ;
				WITH yearrep.female+female, yearrep.number WITH ;
				yearrep.number+number
				FLUSH
			ENDI
		ELSE
			DO ProcessCal
			SELE in
		ENDI
	ENDI
ENDS
@ 3,4 SAY SPAC(40)
SELE source
USE
IF _update
	SELE target
	USE
	SELE in
	USE
	SELE oper
	USE
ELSE
	IF ! _makefile
		SELE in
		USE
		SELE oper
		USE
	ENDI
ENDI

PROC MOSTHEADER
PARA _foreject,_header
PRIVATE mprint,mhosp
mhosp=TRIM(hosp_name)
*mtime1='������ѹ��� '+CE2CBE(startdate)+' �֧ �ѹ��� '+CE2CBE(enddate)
IF _foreject
	eject page
	eject
ENDI
mpagep='˹�ҷ�� '+LTRIM(STR(_pageno))
?mpagep+SPACE(CENTER(_header)-LEN(mpagep))+_header
?SPAC(CENTER(mhosp))+mhosp
?
? '�ӴѺ��� �����ä          �����ä                                    ���          ���          ˭ԧ'
?
IF _foreject
	?
ENDI

PROC PROCESSCAL
IF BETWEEN(datedsc,mstartdate,menddate)
	m.an = an
	SELE source
	SEEK m.an
	DO WHIL an = m.an
		m.diag = diag
		IF yearly
			SELE yearrep
			IF ! SEEK(m.diag)
				INSERT INTO yearrep FROM MEMV
				FLUSH
			ENDI
		ENDI
		IF _makefile
			SELE target
			IF ! SEEK(m.diag)
				INSERT INTO target FROM MEMV
				FLUSH
			ENDI
		ENDI
		SELE mostrep
		IF ! SEEK(m.diag)
			INSERT INTO mostrep FROM MEMV
			FLUSH
		ENDI
		IF patient1.sex = '1'
			REPL mostrep.male WITH mostrep.male+1, ;
			mostrep.number WITH mostrep.number+1
			FLUSH
			IF _makefile
				REPL target.male WITH target.male+1, ;
				target.number WITH target.number+1
				FLUSH
			ENDI
			IF yearly
				REPL yearrep.male WITH yearrep.male+1, ;
				yearrep.number WITH yearrep.number+1
				FLUSH
			ENDI
		ELSE
			REPL mostrep.female WITH mostrep.female+1, ;
			mostrep.number WITH mostrep.number+1
			FLUSH
			IF _makefile
				REPL target.female WITH target.female+1, ;
				target.number WITH target.number+1
				FLUSH
			ENDI
			IF yearly
				REPL yearrep.female WITH yearrep.female+1, ;
				yearrep.number WITH yearrep.number+1
				FLUSH
			ENDI
		ENDI
		SELE source
		SKIP
	ENDD
	SELE oper
	SEEK m.an
	DO WHIL an = m.an
		m.diag = op
		IF yearly
			SELE yearrep
			IF ! SEEK(m.diag)
				INSERT INTO yearrep FROM MEMV
				FLUSH
			ENDI
		ENDI
		IF _makefile
			SELE target
			IF ! SEEK(m.diag)
				INSERT INTO target FROM MEMV
				FLUSH
			ENDI
		ENDI
		SELE mostrep
		IF ! SEEK(m.diag)
			INSERT INTO mostrep FROM MEMV
			FLUSH
		ENDI
		IF patient1.sex = '1'
			REPL mostrep.male WITH mostrep.male+1, ;
			mostrep.number WITH mostrep.number+1
			FLUSH
			IF _makefile
				REPL target.male WITH target.male+1, ;
				target.number WITH target.number+1
				FLUSH
			ENDI
			IF yearly
				REPL yearrep.male WITH yearrep.male+1, ;
				yearrep.number WITH yearrep.number+1
				FLUSH
			ENDI
		ELSE
			REPL mostrep.female WITH mostrep.female+1, ;
			mostrep.number WITH mostrep.number+1
			FLUSH
			IF _makefile
				REPL target.female WITH target.female+1, ;
				target.number WITH target.number+1
				FLUSH
			ENDI
			IF yearly
				REPL yearrep.female WITH yearrep.female+1, ;
				yearrep.number WITH yearrep.number+1
				FLUSH
			ENDI
		ENDI
		SELE oper
		SKIP
	ENDD
ENDI
