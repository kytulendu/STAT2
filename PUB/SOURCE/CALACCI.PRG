DEFINE WIND report FROM 5,12 TO 15,77 SHAD
ACTI WIND report
IF ! FILE('CODEACCI.DBF')
	dbfuse = 'codeaccp'
	USE codeaccp IN 0 ALIA code
ELSE
	dbfuse = 'codeacci'
	USE codeacci IN 0 ALIA code
ENDI
IF ! FILE('NAMEACCI.DBF')
	dbfuse = 'nameaccp'
	USE nameaccp IN 0 ALIA name
ELSE
	dbfuse = 'nameacci'
	USE nameacci IN 0 ALIA name
ENDI
dbfuse = ''
SELE name
numrec = RECCOUNT()
CLEA
@ 2,5 SAY '��ͧ��÷���§ҹ�������غѵ��˵ب�Ҩ� �ͧ��͹/��'
@ 4,8 GET mmyy DEFA SPAC(4) PICT '@R 99/99'
READ NOLOCK
mm=LEFT(mmyy,2)
yy=RIGHT(mmyy,2)
SELE 0
IF mm='25' .OR.  BETWEEN(mm,'01','12')
	myear=FULLYEAR(yy)
	mthmsg=IIF(mm='25','�է�����ҳ '+myear,'��͹'+month&mm+' �.�.'+myear)
	IF FILE(opddir+'report\racc'+yy+mm+'.dbf')
		CLEA
		recal = 'N'
		??CHR(7)
		@ 1,1 SAY '������'+mthmsg+' �¤ӹǳ�ҡ�͹'
		@ 3,3 SAY '��ͧ��äӹǳ����������� ' GET recal PICT '!'
		READ NOLOCK
		IF recal $ 'Y��'
			IF mm = '25'
				DO CalaccY
				DO Repacc WITH mm,yy
			ELSE
				IF CalaccM(mm,yy)
					DO Repacc WITH mm,yy
				ENDI
			ENDI
		ELSE
			DO Repacc WITH mm,yy
		ENDI
	ELSE
		IF mm = '25'
			DO CalaccY
			DO Repacc WITH mm,yy
		ELSE
			IF CalaccM(mm,yy)
				DO Repacc WITH mm,yy
			ENDI
		ENDI
	ENDI
ELSE
	IF mm # '  '
		?? Chr(7)
		WAIT '����㨴��� ! �س�����͹���١��ͧ �������ö�ӹǳ�����' WIND TIME 10
	ENDI
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

PROC CALaccM
PARA _mm,_yy
IF ! FILE(opddir+'CAME'+_yy+_mm+'.dbf')
	?? CHR(7)
	WAIT WIND '����㨴���! �����'+mthmsg+' ��辺' NOWA
	RETU .F.
ENDI
SELE code
numcode=RECCOUNT()
DIME codeacc[numcode,3]
COPY TO ARRAY codeacc
SELE 0
IF USED('SOURCEFILE')
	SELE sourcefile
ENDI
dbfuse = opddir+'came'+_yy+_mm
USE (opddir+'came'+_yy+_mm) ALIA sourcefile
dbfuse = ''
DIME rbnum(numrec*2)
FOR i = 1 TO numrec
	STOR 0 TO rbnum(i),rbnum[i+numrec]
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
			ret_code =IIF(BETWEEN(mdiag,codeacc[nn,2],codeacc[nn,3]),codeacc[nn,1],0)
			IF ret_code>0
				psex = IIF(sex='1',0,1)
				rbnum(ret_code+(psex*numrec)) = rbnum(ret_code+(psex*numrec))+1
			ENDI
		NEXT
	ENDI
ENDS
dbfuse = opddir+'report\racc'+_yy+_mm
IF ! FILE(opddir+'REPORT\Racc'+_yy+_mm+'.DBF')
	DO Createrb	WITH _mm,_yy
ENDI
USE (opddir+'report\racc'+_yy+_mm)
IF FCOUNT() # numrec*2 + 2
	USE
	DO Createrb WITH _mm,_yy
	USE (opddir+'report\racc'+_yy+_mm)
ENDI
dbfuse = ''
DIME rbnum[numrec*2+2]
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

PROC REPacc
PARA _mm,_yy
IF ! FILE(opddir+'REPORT\Racc'+_yy+_mm+'.DBF')
	?? CHR(7)
	WAIT WIND '����㨤�Ѻ! �ѧ�������§ҹ�������غѵ��˵ب�Ҩ� �ͧ'+mthmsg+' �������ö�������' NOWA
	RETU
ENDI
dbfuse = opddir+'report\racc'+_yy+_mm
USE (opddir+'report\racc'+_yy+_mm) ALIA racc 
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
	SELE racc
	IF send1 = 2
		COPY TO b:racc&_yy&_mm
	ELSE
		COPY TO a:racc&_yy&_mm
	ENDI
	RELE WIND progress
ELSE	
	=ADEL(rbnum,1)
	=ADEL(rbnum,1)
	totalnum = 0
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
			USE (codedir+'hospcode') ORDER 1 IN 0
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
		?SPACE(40)+'Ẻ ç.�������غѵ��˵ب�Ҩ�'
		?'��§ҹ�����¹͡���������آѵ��˵ب�Ҩ� ��Ш�'+mthmsg
		?'����˹��§ҹ '+mhosp+'  ����� '+ampurname+'  �ѧ��Ѵ '+changwatname
		?'���ͼ����§ҹ ................................ ���˹� .......................'
		?'�ѹ��͹�շ����§ҹ  ' + CE2CBE(DATE())
		DO rbheader WITH .F.
		STOR 0 TO totalmale,totalfemal
		FOR i = 1 TO numrec
			? LEFT(desc,50)+TRANSFORM(rbnum[i],'999,999')+;
			TRANSFORM(rbnum[i+numrec],'999,999')+;
			TRANSFORM(rbnum[i]+rbnum[i+numrec],'999,999,999')
			totalmale = rbnum[i]+totalmale
			totalfemale = rbnum[i+numrec]+totalfemale
			SKIP
		NEXT
		?
		? SPACE(40),'���  '+SPACE(4)+TRANSFORM(totalmale,'999,999')+;
			TRANSFORM(totalfemale,'999,999')+;
			TRANSFORM(totalmale+totalfemale,'999,999,999')
		?
	ENDPRINTJOB
	RELE WIND progress
	mkeylabel=ON('KEY','F1')
	ON KEY LABEL F1 DO helpbrow
	DO Endprint WITH '  ��§ҹ�ä�������غѵ��˵ب�Ҩ�  ',reportfile
	ON KEY LABEL F1 &mkeylabel
	DELE FILE &reportfile
	IF useadd
		SELE address
		USE
	ENDI
	IF usehospcode
		SELE hospcode
		USE
	ENDI
ENDI
IF USED('racc')
	SELE racc
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
?'..........................................................................'
?' �ӴѺ���            ���˵ء�û��� (������ä)         ���    ˭ԧ      ���'
?'..........................................................................'

IF _foreject
	?
ENDI

PROC CREATERB
PARA _mmm,_yyy
	DIME rbstru[numrec*2+2,4]
	rbstru[1,1]='HOSP'
	rbstru[1,2]='C'
	rbstru[1,3]=5
	rbstru[1,4]=0
	rbstru[2,1]='DATE'
	rbstru[2,2]='C'
	rbstru[2,3]=4
	rbstru[2,4]=0
	FOR i = 1 TO numrec*2
		x=LTRIM(STR(i))
		rbstru[i+2,1]='CASE'+x
		rbstru[i+2,2]='N'
		rbstru[i+2,3]=6
		rbstru[i+2,4]=0
	NEXT
	dbfuse = opddir+'report\racc'+_yyy+_mmm
	CREAT TABLE (opddir+'report\racc'+_yyy+_mmm) FROM ARRAY rbstru
	dbfuse = ''
PROC CALaccY
yy1=VAL(yy)-1
yy1 = IIF(yy1<0,'99',STRZERO(yy1,2))
mm1 = '10'
mm = '09'
DIME rbnum1(numrec*2),rbnum(numrec*2)
FOR i = 1 TO numrec*2
	STOR 0 TO rbnum1(i),rbnum(i)
NEXT
logerr=''

DO WHIL .T.
	mthmsg='��͹'+month&mm1+' �.�.'+ FullYear(yy1)
	IF ! FILE(opddir+'REPORT\Racc'+yy1+mm1+'.DBF') .AND. ! FILE(opddir+'CAME'+yy1+mm1+'.DBF')
		?? CHR(7)
		WAIT WIND '����㨤�Ѻ! �������ö�Ң�����'+mthmsg NOWA
		logerr = logerr + month&mm1 + ' '+yy1 + ' '
	ELSE
		IF ! FILE(opddir+'REPORT\Racc'+yy1+mm1+'.DBF') 
			FOR i = 1 TO numrec
				STOR 0 TO rbnum(i),rbnum[i+numrec]
			NEXT
			=CALaccM(mm1,yy1)
		ELSE
			WAIT WIND '�֧������'+mthmsg+' �Һǡ' NOWA
			dbfuse = opddir+'report\racc'+yy1+mm1
			USE (opddir+'report\racc'+yy1+mm1)	
			dbfuse = ''
			SCATT TO rbnum
		ENDI
	=ADEL(rbnum,1)
	=ADEL(rbnum,1)
		FOR i = 1 TO numrec
			rbnum1(i) = rbnum1[i] + rbnum[i]
			rbnum1[i+numrec] = rbnum1[i+numrec]+rbnum[i+numrec]
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
dbfuse = opddir+'report\racc'+yy+mm
IF ! FILE(opddir+'REPORT\Racc'+yy+mm+'.DBF')
	DO Createrb	WITH mm,yy
ENDI
USE (opddir+'report\racc'+yy+mm)
IF FCOUNT() # numrec*2+2
	USE
	DO Createrb WITH mm,yy
	USE (opddir+'report\racc'+yy+mm)
ENDI
dbfuse = ''
DIME rbnum1[numrec*2+2]
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
	
