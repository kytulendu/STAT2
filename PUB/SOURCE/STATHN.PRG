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
DEAC WIND rp_menu
STORE .T. TO goon
IF ! USED('STATrqbe')
	SELE 0
	IF FILE('statrqbe.dbf')
		dbfuse = 'statrqbe'
		USE statrqbe
	ELSE
		dbfuse = patientdir+'statrqbe'
		USE (patientdir+'statrqbe')
	ENDI
ELSE
	SELE statrqbe
ENDI
dbfuse = ''
GO TOP
DIME condition[3,2],offer[5,2],condtype[6]
numshow = RECCOUNT()
DIME show(numshow)
DO GetCond WITH 2,1,'S'
*************************	��˹�����÷�����ӹǳ
IF EMPTY(mmyy) .OR. EMPTY(mmyy1) .OR. LASTKEY() = 27
	DEAC WIND ALL
	WAIT WIND NOWA '¡��ԡ��ä��ҵ����ͧ���'
	RETU
ENDI
startdate = BE2CE(mmyy)
enddate = BE2CE(mmyy1)
startfile=RIGHT(mmyy,2)+SUBS(mmyy,4,2)
endfile=RIGHT(mmyy1,2)+SUBS(mmyy1,4,2)
STOR 0 TO xx,yy
errmonth=''

dbfuse = patientdir+'patient2'
USE (patientdir+'patient2') order tag hn IN 0
dbfuse = patientdir+'contact'
USE (patientdir+'contact') order tag hn IN 0
SELE 0
dbfuse = patientdir+'patient1'
USE (patientdir+'patient1') ORDER TAG lastdate ASCE
SET RELA TO hn INTO patient2,hn INTO contact
SELE 0
dbfuse = ''
*********************	�����ǹ�ٻ���ͤӹǳ������
EXTERNAL ARRAY Tmonth
tablefile=tempdir+SYS(3)
dbfuse = tablefile
CREA TABLE (tablefile) ('HN' C(7),'NAME' C(35),'FC' C(2),'RESULT' C(2))
INDEX ON hn TAG hn
USE (tablefile) ALIA tablefile ORDER TAG hn
dbfuse = ''
SELE patient1
SET RELA TO hn INTO tablefile ADDI
div_num=ROUND((RECCOUNT()/40)+.5,0)
recno = 0
DO ShowProgress
GO TOP
mindate =  lastdate
GO BOTT
maxdate = lastdate
IF startdate>maxdate .OR. enddate<mindate
	=ALARM1()
	WAIT WIND NOWA '�ռ������ҷӺѵ������ҧ�ѹ��� '+CE2CBE(mindate)+' �֧�ѹ��� ';
	+ CE2CBE(maxdate)
	DEAC WIND ALL
	CLOSE DATA
	DELE FILE (tablefile+'.dbf')
	DELE FILE (tablefile+'.cdx')
	RETU
ENDI
IF startdate <mindate
	GO TOP
ELSE
	IF ! SEEK(startdate)
		GO RECNO(0)
		DO WHIL lastdate<startdate .AND. ! EOF()
			SKIP
		ENDD
	ENDI
ENDI
ON KEY LABEL F10 STORE .F. TO goon
DO WHIL BETWEEN(lastdate,startdate,enddate) .AND. ! EOF() .AND. goon
	recno=recno+1
	@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '�' COLO gr+
	IF &condcode
		SELE tablefile
		IF EOF()
			APPE BLAN
			REPL hn WITH patient1.hn
		ENDI
		REPL name WITH De_Name(patient1.name),fc WITH patient1.class
		SELE patient1
	ENDI
	SKIP
ENDD
ON KEY LABEL F10
RELE WIND comment

**********************		�Ѵ���§�����ŵ���ӴѺ
DEAC WIND ALL
IF ! goon
	=ALARM1()
	WAIT WIND NOWA '¡��ԡ��äӹǳ�����ͧ���'
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
