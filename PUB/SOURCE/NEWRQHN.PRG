*****************************************************************
*	���������Ѻ���Ҫ��ͼ����µ�����͹�                    *
* 	�¨�����ª��͵������������������͡                    *
*	����÷�����¨��������� STATRQBE.DBF ��� STATRQBE.FPT			*
*	�������ö��˹����͹����ա 6 ���͹� �µ�������͹�	*
*	����ö���͡���¡����� [F1] ���;����������������		*
*	���� LIST													*
*	��������͡�ѹ����ҵ�Ǩ�����͹� ��������ö��˹���ҡ	*
*	��á�˹���Ҩ��Ң����ŵ�����ѹ�˹�֧�ѹ�˹��������			*
*****************************************************************
PRIV xline,yline,xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,;
yhelp1,yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess,goon
STOR '' TO xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,yhelp1,;
yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess
DIME xcode(1),xcoded(1),ycode(1),ycoded(1),xmin(1),xmax(1),ymin(1),ymax(1)
STOR 0 TO xline,yline
STORE .T. TO goon
DEAC WIND rp_menu
PRIV yyy
yyy= '  '
DEFINE WIND askyear FROM 10,20 TO 14,60 SHAD
ACTI WIND askyear
@ 1,3 SAY '��ͧ����Ҥ�������㹻�  ' GET yyy PICT '##'
READ NOLOCK
RELE WIND askyear
IF LASTKEY() = 27 .OR. EMPTY(yyy)
	WAIT WIND NOWA '¡��ԡ��ä��ҵ����ͧ���'
	RETU
ELSE
	IF ! FILE(patientdir+'new'+yyy+'.dbf') 
		=ALARM1()
		WAIT WIND NOWA '����������������㹻� ' + yyy
		RETU
	ELSE
		SELE 0
		dbfuse = patientdir+'new'+yyy
		USE (patientdir+'new'+yyy) ALIA newcase
	ENDI
	dbfuse = ''
ENDI
IF ! USED('STATrqbe')
	SELE 0
	IF FILE('statrqbe.dbf')
		dbfuse = 'statrqbe'
		USE statrqbe
	ELSE
		dbfuse = patientdir+'statrqbe'
		USE (patientdir+'statrqbe')
	ENDI
	dbfuse = ''
ELSE
	SELE statrqbe
ENDI
GO TOP
DIME condition[3,2],offer[5,2],condtype[6]
numshow = RECCOUNT()
DIME show(numshow)
DO GetCond WITH 2,2,'S'
*************************	��˹�����÷�����ӹǳ
STOR 0 TO xx,yy

dbfuse = patientdir+'patient2'
USE (patientdir+'patient2') order tag hn IN 0
dbfuse = patientdir+'contact'
USE (patientdir+'contact') order tag hn IN 0
dbfuse = patientdir+'patient1'
USE (patientdir+'patient1') ORDER TAG hn
dbfuse = ''
SELE newcase
SET RELA TO hn INTO patient2,hn INTO contact,hn INTO patient1
SELE 0

*********************	�����ǹ�ٻ���ͤӹǳ������
EXTERNAL ARRAY Tmonth
tablefile=tempdir+SYS(3)
dbfuse = tablefile
CREA TABLE (tablefile) ('HN' C(7),'NAME' C(35),'FC' C(2),'RESULT' C(2))
INDEX ON hn TAG hn
USE (tablefile) ALIA tablefile ORDER TAG hn
dbfuse = ''
SELE newcase
SET RELA TO hn INTO tablefile ADDI
div_num=ROUND((RECCOUNT()/40)+.5,0)
recno = 0
DO ShowProgress
ON KEY LABEL F10 STORE .F. TO goon
GO TOP
SCAN
	recno=recno+1
	@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '�' COLO gr+
	IF &condcode
		SELE tablefile
		IF EOF()
			APPE BLAN
			REPL hn WITH newcase.hn
		ENDI
		REPL name WITH De_Name(patient1.name),fc WITH patient1.class
		SELE patient1
	ENDI
	IF ! goon OR INKEY() = 27
		goon = .F.
		EXIT
	ENDI
ENDS
RELE WIND comment
ON KEY LABEL F10

**********************		�Ѵ���§�����ŵ���ӴѺ
DEAC WIND ALL
IF ! goon
	=ALARM1()
	WAIT WIND NOWA '¡��ԡ��äӹǳ�����ͧ���'
	DEAC WIND ALL
	CLOSE DATA
	DELE FILE (tablefile+'.dbf')
	DELE FILE (tablefile+'.cdx')
	RETU
ENDI
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
		? hn,'    ',name,'   ',fc,'           ' 
	ENDS
	?
	? '����ӹǹ��������� '+ALLTRIM(STR(RECCOUNT()))+' ��'
	? '�����˵�'
	? SPACE(10)+'�����ż���������� ' +yyy
	IF condcode # '.T.'
		? SPACE(10)+'�� ' + condmess
	ENDI
	?
ENDPRINTJOB
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpbrow
DO Endprint WITH '  ��§ҹẺ���ҧ  ',reportfile
ON KEY LABEL F1 &mkeylabel
CLOSE DATA
DELE FILE (reportfile)
DELE FILE (tablefile+'.dbf')
DELE FILE (tablefile+'.cdx')


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
?' �Ţ�������¹͡          ���� - ���ʡ��      �Է�ԡ���ѡ��'
?
IF _foreject
	?
ENDI

