*****************************************************************
*	���������Ѻ���Ҫ��ͼ����µ�����͹�                    *
* 	�¨�����ª��͵������������������͡                    *
*	����÷�����¨��������� ROBE.DBF ��� RQBE.FPT			*
*	�������ö��˹����͹����ա 6 ���͹� �µ�������͹�	*
*	����ö���͡���¡����� [F1] ���;����������������		*
*	���� LIST													*
*	��������͡�ѹ����ҵ�Ǩ�����͹� ��������ö��˹���ҡ	*
*	��á�˹���Ҩ��Ң����ŵ�����ѹ�˹�֧�ѹ�˹��������			*
*****************************************************************
PRIV xline,yline,xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,;
yhelp1,yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess
STOR '' TO xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,yhelp1,;
yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess
DIME xcode(1),xcoded(1),ycode(1),ycoded(1),xmin(1),xmax(1),ymin(1),ymax(1)
STOR 0 TO xline,yline
DEAC WIND rp_menu
IF ! USED('StatRQBE')
	SELE 0
	IF FILE('StatRQBE.dbf')
		dbfuse = 'statrqbe'
		USE StatRQBE
	ELSE
		dbfuse = patientdir+'StatRQBE'
		USE (patientdir+'StatRQBE')
	ENDI
ELSE
	SELE StatRQBE
ENDI
dbfuse = ''
numshow = RECCOUNT()
GO TOP
DIME condition[3,2],offer[5,2],condtype[6]
numshow = RECCOUNT()
DIME show(numshow)
DO GetCond WITH 2,1,'O'
	IF LASTKEY() = 27 .OR. EMPTY(mmyy) .OR. EMPTY(mmyy1)
		DEAC WIND all
		RETU
	ENDI
*************************	��˹�����÷�����ӹǳ
startdate = BE2CE(mmyy)
enddate = BE2CE(mmyy1)
startfile=RIGHT(mmyy,2)+SUBS(mmyy,4,2)
endfile=RIGHT(mmyy1,2)+SUBS(mmyy1,4,2)
STOR 0 TO xx,yy
errmonth=''
*SELE patient2
*SELE contact
SELE 0

*********************	�����ǹ�ٻ���ͤӹǳ������
EXTERNAL ARRAY Tmonth
tablefile=tempdir+SYS(3)
dbfuse = tablefile
CREA TABLE (tablefile) ('HN' C(7),'NAME' C(35),'FC' C(2),'RESULT' C(2))
INDEX ON hn TAG hn
USE (tablefile) ALIA tablefile ORDER TAG hn
dbfuse = ''
SELE 0
DO WHIL startfile <= endfile
	err=TMONTH(VAL(RIGHT(startfile,2)))+' '+FULLYEAR(LEFT(startfile,2))
	IF ! FILE(opddir+'CAME'+startfile+'.dbf')
		?? CHR(7)
		WAIT WIND '��辺�����͹'+err NOWAIT
		errmonth = errmonth+' '+err+','
	ELSE
		WAIT WIND '���ѧ�ӹǳ��������͹' + err NOWAIT
		dbfuse = opddir+'came'+startfile
		USE (opddir+'came'+startfile) ALIA came
		dbfuse = ''
		SET RELA TO hn INTO patient1
		SET RELA TO hn INTO tablefile ADDI
		DO resulthn			&& Module ���ӹǳ������������͹
		SELE came
		USE
	ENDI
	IF RIGHT(startfile,2)='12'	&& ������͹����˹����͹
		startfile=STRZERO(VAL(LEFT(startfile,2))+1,2)+'01'
	ELSE
		startfile=LEFT(startfile,2)+STRZERO(VAL(RIGHT(startfile,2))+1,2)
	ENDI
ENDD

**********************		�Ѵ���§�����ŵ���ӴѺ
DEAC WIND ALL
DO ClearScreen
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
header = '��ª��ͼ��������§����Ţ��Шӵ��'
ON PAGE AT line _plength-2 DO rqbehnheader WITH .T.,header
KEYB ' '
WAIT WIND NOWA '�ô����ա�ѡ���� ���ѧ�Ѵ����§ҹ����'
SELE tablefile
PRINTJOB
	DO rqbehnheader WITH .F.,header
	SCAN
		? hn,'    ',name,'   ',fc,'           ' ,result
	ENDS
	?
	? '����ӹǹ��������� '+ALLTRIM(STR(RECCOUNT()))+' ��'
	? '�����˵�'
	? SPACE(10)+'������ѹ��� '+CE2CBE(startdate)+' �֧�ѹ��� '+CE2CBE(enddate)
	IF condcode # '.T.'
		? SPACE(10)+'�� ' + condmess
	ENDI
	IF ! EMPTY(errmonth)
		? SPACE(10)+'��辺�����������͹' + LEFT(errmonth,LEN(errmonth)-1)
	ENDI
	?
ENDPRINTJOB
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpbrow
DO Endprint WITH '  ��§ҹẺ���ҧ  ',reportfile
ON KEY LABEL F1 &mkeylabel
*CLOSE DATA
DELE FILE &reportfile
SELE tablefile
USE
DELE FILE &tablefile..dbf
DELE FILE &tablefile..cdx
SELE patient1
SET RELA TO hn INTO patient2
SET RELA TO hn INTO contact ADDI

PROC ResultHN
div_num=ROUND((RECCOUNT()/40)+.5,0)
recno = 0
DO ShowProgress
SCAN FOR BETWEEN(date,startdate,enddate)
	recno=recno+1
	@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '�' COLO gr+
	IF &condcode
		SELE tablefile
		IF EOF()
			APPE BLAN
			REPL hn WITH came.hn
		ENDI
		REPL name WITH De_Name(patient1.name),fc WITH came.fc,result ;
		WITH came.result
		SELE came
	ENDI
ENDS
RELE WIND comment

PROC rqbehnheader
PARA _foreject,_header
PRIVATE mprint,mhosp
mhosp=TRIM(hosp_name)
*mtime1='������ѹ��� '+CE2CBE(startdate)+' �֧ �ѹ��� '+CE2CBE(enddate)
IF _foreject
	eject page
	eject
ENDI
mpagep='˹�ҷ�� '+LTRIM(STR(_pageno))
spacecol=CENTER(_header)
?SPACE(spacecol)+_header+SPACE(65-spacecol-LEN(_header))+mpagep
?SPAC(CENTER(mhosp))+mhosp
?
?' �Ţ�������¹͡          ���� - ���ʡ��      �Է�ԡ���ѡ��   �š���ѡ��'
?
IF _foreject
	?
ENDI

