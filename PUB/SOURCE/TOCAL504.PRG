DEFINE WIND report FROM 5,30 TO 15,77 SHAD
ACTI WIND report
SELE 0
IF ! FILE('CODE504.DBF')
	dbfuse = 'code504p'
	USE code504p ALIA code
ELSE
	dbfuse = 'code504'
	USE code504 ALIA code
ENDI
SELE 0
IF ! FILE('NAME504.DBF')
	dbfuse = 'name504p'
	USE name504p ALIA name
ELSE
	dbfuse = 'name504'
	USE name504 ALIA name
ENDI
dbfuse = ''
numrec = RECCOUNT()
CLEA
@ 2,5 SAY '��ͧ��÷���§ҹ 504 �ͧ��͹/��'
@ 4,8 GET mmyy DEFA SPAC(4) PICT '@R 99/99'
READ NOLOCK
mm=LEFT(mmyy,2)
yy=RIGHT(mmyy,2)
SELE 0
IF mm='25' .OR.  BETWEEN(mm,'01','12') .AND. AT(' ',yy)=0
	myear=FULLYEAR(yy)
	mthmsg=IIF(mm='25','�է�����ҳ '+myear,'��͹'+month&mm+' �.�.'+myear)
	IF FILE(opddir+'report\r504'+yy+mm+'.dbf')
		CLEA
		recal = 'N'
		??CHR(7)
		@ 1,1 SAY '������'+mthmsg+' �¤ӹǳ�ҡ�͹'
		@ 3,3 SAY '��ͧ��äӹǳ����������� ' GET recal PICT '!'
		READ NOLOCK
		IF recal $ 'Y��'
			IF mm = '25'
				DO Cal504Y
				DO Rep504 WITH mm,yy
			ELSE
				IF Cal504M(mm,yy)
					DO Rep504 WITH mm,yy
				ENDI
			ENDI
		ELSE
			DO Rep504 WITH mm,yy
		ENDI
	ELSE
		IF mm = '25'
			DO Cal504Y
			DO Rep504 WITH mm,yy
		ELSE
			IF Cal504M(mm,yy)
				DO Rep504 WITH mm,yy
			ENDI
		ENDI
	ENDI
ELSE
	=ALARM1()
	WAIT '����㨴��� ! �س�����͹���ͻ����١��ͧ �������ö�ӹǳ�����' WIND TIME 10
ENDI
RELE WIND report
RELE WIND progress
SELE code
USE
SELE name
USE
IF USED('sourcefile')
	SELE sourcefile
	USE
ENDI

PROC CAL504M
PARA _mm,_yy
IF ! FILE(opddir+'CAME'+_yy+_mm+'.dbf')
	?? CHR(7)
	WAIT WIND '����㨴���! �����'+mthmsg+' ��辺' NOWA
	RETU .F.
ENDI
SELE code
numcode=RECCOUNT()
DIME code504[numcode,3]
COPY TO ARRAY code504
SELE 0
IF USED('SOURCEFILE')
	SELE sourcefile
ENDI
dbfuse = opddir+'came'+_yy+_mm
USE (opddir+'came'+_yy+_mm) ALIA sourcefile
dbfuse = ''
DIME rbnum(numrec)
FOR i = 1 TO numrec
	STOR 0 TO rbnum(i)
NEXT
SELE sourcefile
div_num=ROUND((RECCOUNT()/40)+.5,0)
recno = 0
DO ShowProgress
SCAN
	recno=recno+1
	@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '�' COLO gr+
	IF episode<'3' .AND. LEFT(diag,1)#'*'
		mdiag = LEFT(diag,4)
		FOR nn = 1 TO numcode
			ret_code =IIF(BETWEEN(mdiag,code504[nn,2],code504[nn,3]),code504[nn,1],0)
			IF ret_code>0
				rbnum(ret_code) = rbnum(ret_code)+1
			ENDI
		NEXT
	ENDI
ENDS
IF ! FILE(opddir+'REPORT\R504'+_yy+_mm+'.DBF')
	DO Createrb	WITH _mm,_yy
ENDI
dbfuse = opddir+'report\r504'+_yy+_mm
USE (opddir+'report\r504'+_yy+_mm)
dbfuse = ''
IF FCOUNT() # numrec + 1
	USE
	DO Createrb WITH _mm,_yy
	dbfuse = opddir+'report\r504'+_yy+_mm
	USE (opddir+'report\r504'+_yy+_mm)
ENDI
dbfuse = ''
DIME rbnum[numrec+2]
=AINS(rbnum,1)
=AINS(rbnum,1)
STOR hosp_code TO rbnum(1)
STOR _yy+_mm TO rbnum[2]
IF RECCOUNT() = 0
	APPE FROM ARRAY rbnum
ELSE
	GATH FROM rbnum
	FLUSH
ENDI
USE
RELE WIND progress
RETU .T.

PROC REP504
PARA _mm,_yy
IF ! FILE(opddir+'REPORT\R504'+_yy+_mm+'.DBF')
	?? CHR(7)
	WAIT WIND '����㨤�Ѻ! �ѧ�������§ҹ 504 �ͧ'+mthmsg+' �������ö�������' NOWA
	RETU
ENDI
dbfuse = opddir+'report\r504'+_yy+_mm
USE (opddir+'report\r504'+_yy+_mm) ALIA r504 
dbfuse = ''
SCAT TO rbnum
IF RIGHT(hosp,1) = '*'
	?? CHR(7)
	WAIT '�ô���ѧ! �������������ó�' WIND NOWA
ENDI
CLEA
msgs='��ͧ�������§ҹ��ٻẺ�˹'
@ 2,Center(msgs) SAY msgs
@ 4,10 PROMPT '1.���繡�д��  '
@ 5,10 PROMPT '2.���繴�ʡ�   '
MENU TO send
IF send = 2
	CLEA
	msgs = '�蹴�ʡ����������˹'
	@ 2,Center(msgs) SAY msgs
	@ 4,10 PROMPT 'A:'
	@ 5,10 PROMPT 'B:'
	MENU TO send1
	SELE r504
	IF send1 = 2
		COPY TO b:r504&_yy&_mm
	ELSE
		COPY TO a:r504&_yy&_mm
	ENDI
	RELE WIND progress
ELSE	
	=ADEL(rbnum,1)
	=ADEL(rbnum,1)
	totalnum = 0
	FOR i = 1 TO numrec
		totalnum = totalnum + rbnum[i]
	NEXT
	reportfile=tempdir+SYS(3)+'.txt'
	SET PRINT TO &reportfile
	SET PRINT ON
	SET CONS OFF
	_wrap=.F.
	_plength=41
	_peject='NONE'
	_pageno=1
	_plineno=0
	_PLOFFSET = 0
	ON PAGE AT line _plength-2 DO rbheader WITH .T.
	CLEA
	shwmsg = '�ô��� ���ѧ�������§ҹ����'
	@ 3,Center(shwmsg) SAY shwmsg

	PRINTJOB
		mhosp=TRIM(hosp_name)
		IF ! USED('hospcode')
			dbfuse = codedir+'hospcode'
			USE (dbfuse) ORDER 1 IN 0
			usehospcode = .T.
		ELSE
			usehospcode = .F.
		ENDI
		= SEEK(hosp_code,'hospcode')
		IF ! USED('address')
			dbfuse = codedir+'address'
			USE (codedir+'address') ORDER 1 IN 0
			useadd = .T.
		ELSE
			useadd = .F.
		ENDI
		dbfuse = ''
		SELE address
		mchangwat='1'+hospcode.changwat
		mampur = '2'+ hospcode.changwat + hospcode.ampur
		dbfuse = ''
		SEEK mchangwat
		changwatname = ALLTRIM(name)
		SEEK mampur
		ampurname = ALLTRIM(name)
		SELE name
		GO TOP
		mpagep='- '+LTRIM(STR(_pageno))+' -'
		?SPACE(65)+'Ẻ ç.504'
		?'��§ҹ�����¹͡�����������˵� (������ä) ��Ш�'+mthmsg
		?'����˹��§ҹ  '+mhosp+'  '+'�����  '+ampurname+'  �ѧ��Ѵ  '+changwatname
		?'���ͼ����§ҹ ................................ ���˹� .......................'
		?'�ѹ��͹�շ����§ҹ  ' + CE2CBE(DATE())
		DO rbheader WITH .F.
	 
		? SPACE(50),'���������    ',TRANSFORM(totalnum,'999,999,999')
		FOR i = 1 TO numrec
			? STR(i,3)+'.',LEFT(desc,60),TRANSFORM(rbnum[i],'999,999,999')
			SKIP
		NEXT
		?
	ENDPRINTJOB
	IF useadd
		SELE address
		USE
	ENDI
	IF usehospcode
		SELE hospcode
		USE
	ENDI
	RELE WIND progress
	mkeylabel=ON('KEY','F1')
	ON KEY LABEL F1 DO helpbrow
	DO Endprint WITH '  ��§ҹ�ä 504  ',reportfile
	ON KEY LABEL F1 &mkeylabel
	DELE FILE &reportfile
ENDI
IF USED('r504')
	SELE r504
	USE
ENDI
*CLOSE DATA

PROC rbheader
PARA _foreject,_header
PRIVATE mprint,mhosp
IF _foreject
	eject page
	eject
	mpagep='- '+LTRIM(STR(_pageno))+' -'
	?SPACE(37)+mpagep
?
ENDI
?'..............................................................................'
?' �ӴѺ���            ���˵ء�û��� (������ä)                           �ӹǹ '
?'..............................................................................'

IF _foreject
	?
ENDI

PROC CREATERB
PARA _mmm,_yyy
	DIME rbstru[numrec+2,4]
	rbstru[1,1]='HOSP'
	rbstru[1,2]='C'
	rbstru[1,3]=5
	rbstru[1,4]=0
	rbstru[2,1]='DATE'
	rbstru[2,2]='C'
	rbstru[2,3]=4
	rbstru[2,4]=0
	FOR i = 1 TO numrec
		x=LTRIM(STR(i))
		rbstru[i+2,1]='CASE'+x
		rbstru[i+2,2]='N'
		rbstru[i+2,3]=6
		rbstru[i+2,4]=0
	NEXT
	dbfuse = opddir+'report\r504'+_yyy+_mmm
	CREAT TABLE (opddir+'report\r504'+_yyy+_mmm) FROM ARRAY rbstru
	dbfuse = ''
	
PROC CAL504Y
yy1=VAL(yy)-1
yy1 = IIF(yy1<0,'99',STRZERO(yy1,2))
mm1 = '10'
mm = '09'
DIME rbnum1(numrec),rbnum(numrec)
FOR i = 1 TO numrec
	STOR 0 TO rbnum1(i),rbnum(i)
NEXT
logerr=''
DO WHIL .T.
	mthmsg='��͹'+month&mm1+' �.�.'+ FullYear(yy1)
	IF ! FILE(opddir+'REPORT\R504'+yy1+mm1+'.DBF') .AND. ! FILE(opddir+'CAME'+yy1+mm1+'.DBF')
		?? CHR(7)
		WAIT WIND '����㨤�Ѻ! �������ö�Ң�����'+mthmsg NOWA
		logerr = logerr + month&mm1 + ' '+yy1 + ' '
	ELSE
		IF ! FILE(opddir+'REPORT\R504'+yy1+mm1+'.DBF') 
			FOR i = 1 TO numrec
				STOR 0 TO rbnum(i)
			NEXT
			=CAL504M(mm1,yy1)
		ELSE
			WAIT WIND '�֧������'+mthmsg+' �Һǡ' NOWA
			dbfuse = opddir+'report\r504'+yy1+mm1
			USE (opddir+'report\r504'+yy1+mm1)
			SCATT TO rbnum
		ENDI
		dbfuse = ''
	=ADEL(rbnum,1)
	=ADEL(rbnum,1)
		FOR i = 1 TO numrec
			rbnum1(i) = rbnum1[i] + rbnum[i]
		NEXT
	ENDI
	IF yy1=yy .AND. mm1=mm
		EXIT
	ELSE
		IF mm1 = '12'
			mm1 = '01'
			yy1 = STRZERO(VAL(yy1)+1,2)
		ELSE
			mm1 = STRZERO(VAL(mm1)+1,2)
		ENDI
	ENDI
ENDD
mm = '25'
myear=FULLYEAR(yy)
mthmsg=IIF(mm='25','�է�����ҳ '+myear,'��͹'+month&mm+' �.�.'+myear)
IF ! FILE(opddir+'REPORT\R504'+yy+mm+'.DBF')
	DO Createrb	WITH mm,yy
ENDI
dbfuse = opddir+'report\r504'+yy+mm
USE (opddir+'report\r504'+yy+mm)
dbfuse = ''
IF FCOUNT() # numrec + 1
	USE
	DO Createrb WITH mm,yy
	dbfuse = opddir+'report\r504'+yy+mm
	USE (opddir+'report\r504'+yy+mm)
ENDI
dbfuse = ''
DIME rbnum1[numrec+2]
=AINS(rbnum1,1)
=AINS(rbnum1,1)
IF ! EMPTY(logerr)
	?? CHR(7)
	WAIT WIND '�Ҵ��������͹ '+logerr TIME 5
	STOR LEFT(hosp_code,11)+'*' TO rbnum1(1)
ELSE
	STOR hosp_code TO rbnum1(1)
ENDI
STOR yy+mm TO rbnum1[2]
IF RECCOUNT() = 0
	APPE FROM ARRAY rbnum1
ELSE
	GATH FROM rbnum1
	FLUSH
ENDI
USE
	
