PARA _pass
*on error
PRIV goon,NumMain,Chmain,ColSpace,Userright,m.username
UserRight = ' '
m.username = ''
NotUsePass = PARAMETER() = 1 .AND.  _pass
IF ! NotUsePass
	Userright = GetUser(m.username)
	cando = ('SUP' $ userright .OR. 'S' $ userright)
	IF ! cando
		=ALARM1()
		WAIT WIND NOWA '����� ! �س������Է�Էӧҹ��ͧ�ѵ�'
		RETU
	ENDI
ENDI
#DEFINE UpArrow 5
#DEFINE LeftArrow 19
dbfuse = patientdir+'patient1'
USE (patientdir+'patient1')
dbfuse = ''
getperson_id = (m.person_id = 'YES') .AND. FCOUNT()>11
hosp_prs = prescription = 'YES'
fromhelp = .F.
USE
SET FUNC 2 TO ',���;'
SET FUNC 3 TO ',�ҧ;'
SET FUNC 4 TO ',��.;'
SET FUNC 5 TO ',��.;'
SET FUNC 6 TO ',��.;'
ON KEY LABEL F1 DO HELP WITH SYS(18),SYS(16)
ON KEY LABEL SHIFT+F2
ON KEY LABEL Alt+P DO Pr_Each
ON KEY LABEL Alt+N DO Pr_New
Shift_f2=.F.
CLEA
@ 2,0 SAY REPL('-',80)
@ 21,0 SAY REPL('-',80)
hosp_dir=''
mhosp_name=LTRIM(TRIM(hosp_name))
col=Center(mhosp_name)
@ 0,col SAY mhosp_name COLO g+/b

******************************************************************************
*                    ��˹����������鹷����繵�ҧ � ���                     *
******************************************************************************

SET MESSAGE TO 24
NumMain=7            && �ӹǹ��¡����ѡ
DIME StatMain(7),StatMainMess(7)
StatMain(1)='ŧ����¹'
StatMain(2)='�����ѵ�'
StatMain(3)='�ԡ���'
StatMain(4)='���/�׹���'
StatMain(5)='���ا�ѡ��'
StatMain(6)='��§ҹ'
StatMain(7)='������ѡ'
StatMainMess(1)='ŧ����¹����������,��� �鹺ѵ� ��Ǩ�ͺ����������ѵ�������� ��о����ѵ�'
StatMainMess(2)='�����ѵü����¹͡  ������Ţ���Ѵ'
StatMainMess(3)='�ԡ�����������ͧ�ء�Թ'
StatMainMess(4)='�������Ѻ�׹���������'
StatMainMess(5)='������������������������͵�ҧ� ����к�'
StatMainMess(6)='�����ѵôѪ�� ��з���§ҹ��ҧ �'
StatMainMess(7)='��Ѻ�����¡����ѡ  �ջѭ�ҵԴ����ٹ����������� FAX.5918630'
ColSpace=78/NumMain    && ������ҧ�����ҧ������¡��
ChMain=1               && ��¡�÷�����͡
DO mainscr
dbfuse = codedir+'clinic'
USE (codedir+'clinic') IN 0
dbfuse = codedir+'ward'
USE (codedir+'ward') IN 0
dbfuse = codedir+'doctor'
USE (codedir+'doctor') IN 0
dbfuse = ''
toedithelp = reccount('CLINIC')<16 .OR. reccount('WARD')<14 .OR. ;
RECCOUNT('DOCTOR') = 0
goon = .T.
****************************************************************
****************************************************************
DO WHIL goon
	ON KEY LABEL F1 DO HELP WITH SYS(18),SYS(16)
	CLOSE DATA
	sysdate=DATE()
	thaiday=Ce2Cbe(sysdate)
	@ 1,4 SAY thaiday COLO gr+/b
	@ 22,0 CLEA
	DO title WITH '�ҹ��ͧ�ѵ�'
	xx=1
	@ 2,0 SAY REPL('-',80)
	@ 21,0 SAY REPL('-',80)
	@ 22,0
	DO WHIL xx<=NumMain
		@ 22,Col()+2 PROMPT StatMain(xx) MESSAGE StatMainMess(xx)
		xx=xx+1
	ENDD
	= THAIMODE()
	Chmain = IIF( toedithelp ,5, ChMain)
	MENU TO ChMain
	@ 22,0 CLEA
	IF toedithelp .AND. ChMain < 5
		?? CHR(7)
		WAIT WIND NOWA '��ͧ���͡��¡�ú��ا�ѡ���к���͹'
	ELSE
		DO CASE
		CASE ChMain=1
			DO NewHn
		CASE Chmain=2
			DO OpenLanMaster
			DO pr_menu
		CASE Chmain=3
			DO OpenLanMaster
			DO er_hn
		CASE ChMain=4
			DO OpenLanMaster
			DO Medrec
		CASE ChMain=5
			DO Edithelp
		CASE ChMain = 6
			DO StatRepo
		CASE ChMain=nummain
			CLOSE DATA
			ON ERROR
			goon = .F.
			IF NotUsePass
				CANC
			ENDI
		OTHER
			Chmain = nummain
		ENDC
	ENDI
	DO mainScr
ENDD
= ENGMODE()
? CHR(155)+'KE'
DO ClearScreen

PROC PR_EACH
EXTERNAL ARRAY patient1
IF TYPE('patient1(1)')='U' .OR. patient1(1)='       '
	=ALARM1()
ELSE
	IF FILE(tempdir+'nowview.vue')
		=ALARM1()
		WAIT WIND NOWA '�ô����ѡ����'
		CREA VIEW (tempdir+'audit')
		SET VIEW TO (tempdir+'nowview.vue')
		KEYB '!'
	ENDI
	SET ESCA ON
	ON ESCAPE STORE .T. TO exist
	exist=.F.
	DO WHIL ! PRINTSTATUS() .AND. ! exist
  		?? CHR(7)
  		WAIT '����ͧ������ѧ�������  �ô��Ǩ�ͺ������º����' WINDOW
	ENDD
	IF ! exist
		SELE PATIENT1
		SET ORDER TO 1
		SEEK patient1(1)
		IF FILE('printopd.fxp')
			DO ('printopd')
		ELSE
			DO propdp
		ENDI
	ENDI
	SET ESCA OFF
	IF FILE(tempdir+'audit.vue')
		SET VIEW TO (tempdir+'audit')
		DELE FILE (tempdir+'audit.vue')
	ENDI
ENDI

PROC PR_NEW
m.currarea = SELECT()
m.rec=IIF(! EOF(),RECNO(),RECCOUNT())
	IF FILE(tempdir+'nowview.vue')
		=ALARM1()
		WAIT WIND NOWA '�ô����ѡ����'
		CREA VIEW (tempdir+'audit')
		SET VIEW TO (tempdir+'nowview.vue')
*		KEYB '!'
	ENDI
SELE printque
SET ORDER TO TAG hn
go top
exist=.F.
IF ! ISDIGIT(hn)
   ?? CHR(7)
   WAIT WINDOW '�ѵä��������������������º��������' TIME 5
*   mkey=INKEY(5)
ELSE
	 DO WHIL ISDIGIT(hn) .AND. ! exist .AND. ! CancelPrint()
		SET ESCA ON
		ON ESCAPE STORE .T. TO exist
		SELE patient1
      	SET ORDER TO 1
      	IF SEEK(printque->hn)
      	IF FILE('printopd.fxp')
        		DO ('Printopd')
        	ELSE
        		DO propdp
        	ENDI
      	ENDI
      	SELE printque
      	REPL hn WITH 'AAAAAAA'
      	FLUSH
      	GO TOP
   	ENDD
ENDI
	IF FILE(tempdir+'audit.vue')
		SET VIEW TO (tempdir+'audit')
		DELE FILE (tempdir+'audit.vue')
	ENDI
SELECT (m.currarea)
GO m.rec
SET ESCA OFF


PROC OpenLanMaster
SELE 2
dbfuse = patientdir+'contact'
USE (patientdir+'contact') ORDER 1
SELE 3
dbfuse = codedir+'clinic'
USE (codedir+'clinic') ORDER 1
SELE 4
dbfuse = codedir+'occupat'
USE (codedir+'occupat') ORDER 1
SELE 5
dbfuse = codedir+'nation'
USE (codedir+'nation') ORDER 1
SELE 6
dbfuse = patientdir+'patient2'
USE (patientdir+'patient2') ORDER 1
SELE 7
dbfuse = codedir+'social'
USE (codedir+'social') ORDER 1
SELE 8
dbfuse = patientdir+'printque'
USE (patientdir+'printque') ORDER 1
SELE 9
dbfuse = codedir+'address'
USE (codedir+'address') ORDER 1
SELE 10
dbfuse = patientdir+'hncount'
USE (patientdir+'hncount')
dbfuse = patientdir+'medrec'
USE (patientdir+'medrec') ORDER TAG hn IN 0
SELE 0
dbfuse = codedir+'ward'
USE (codedir+'ward') ORDER 1 IN 0
dbfuse = ipddir+'ancount'
USE (dbfuse) IN 0
dbfuse = ipddir+'data\iptrana'
USE (dbfuse) ORDER 1 IN 0
dbfuse = codedir+'doctor'
USE (codedir+'doctor') ORDER 1 IN 0
dbfuse = ipddir+'cancelan'
USE (dbfuse) ORDER 1 IN 0
myy = RIGHT(CE2BE(DATE()),2)
IF USED('newcase')
	SELE newcase
	USE
ENDI
SELE 0
mfile=patientdir+'new'+myy
dbfuse = mfile
IF ! FILE(mfile+'.dbf')
	CREATE TABLE (mfile) (HN C(7),VISITED L)
	INDEX ON hn TAG hn
ENDI
USE (mfile) ORDER TAG hn ALIA newcase
IF FCOUNT() = 1
	DO WarnNew WITH mfile
ENDI
SELE 0
if !file(patientdir+'previsit.dbf')
	Create table (patientdir+'previsit') ;
	(hn c(7), lastdate D, lastclinic c(3), lasttime C(4) )
	index on hn tag hn
	use
endif
USE (patientdir + 'previsit') ORDER 1 IN 0
dbfuse = patientdir+'patient1'
SELE 0
USE (patientdir+'patient1') ORDER 1
SET RELA TO hn INTO patient2,hn INTO contact,clinic INTO clinic,;
class INTO social,hn INTO medrec,hn INTO newcase,hn INTO iptrana, ;
hn INTO previsit
IF audit
	dbfuse = patientdir+'hnchange'
	USE (patientdir+'hnchange') ORDER 1 IN 0
	SET RELA TO hn INTO hnchange ADDI
ENDI
*IF hosp_prs
	SELE 0
mmm=padl(alltrim(str(month(date()),2)),2,'0')
ddd=padl(alltrim(str(day(date()),2)),2,'0')
	target=pharmdir+'presc'+myy+'.DBF'
	dbfuse = target
	if !file(target)
		create table &target ;
		(pn c(7), hn c(7), date d, time c(4), class c(2), dtime c(4), dr c(6), printed L)
		index on pn tag pn
		index on hn tag hn additive
		INDEX ON date TAG date ADDI
		use
	endif
	use (target) order tag pn in 0 alias presc
	target2=patientdir+'pxrec.dbf'
	dbfuse = target2
	if !file(target2)
		select presc
		copy stru to (target2) with cdx
	endif
	use (target2) order tag pn in 0 alias prtoday
	SELE prtoday
	APPE BLAN
	SELE 0


	dbfuse = patientdir+'queer'
	if !file(patientdir+'queer.dbf')
		Create table (patientdir+'queer') ;
		(HN C(7))
		INDEX ON hn TAG hn
		use
	endif
	dbfuse = patientdir+'pque'
	if !file(patientdir+'pque.dbf')
		Create table (patientdir+'pque') ;
		(pn c(7), new L)
		index on pn tag pn
		use
	endif
	dbfuse = patientdir+'pqueo'
	if !file(patientdir+'pqueo.dbf')
		Create table (patientdir+'pqueo') ;
		(pn c(7), new L)
		index on pn tag pn
		use
	endif
	if !file(patientdir+'pqueer.dbf')
		Create table (patientdir+'pqueer') ;
		(pn c(7), new L)
		index on pn tag pn
		use
	endif
	if !file(patientdir+'pqueero.dbf')
		Create table (patientdir+'pqueero') ;
		(pn c(7), new L)
		index on pn tag pn
		use
	endif
	IF ER
		use (patientdir+'pqueer') order tag pn in 0 ALIA pque
		USE (patientdir + 'pqueero') ORDER tag pn IN 0 ALIA pqueo
	ELSE
		use (patientdir+'pque') order tag pn in 0
		USE (patientdir + 'pqueo') ORDER tag pn IN 0
	ENDI
	dbfuse = patientdir+'pncount'
	if !file(patientdir+'pncount.dbf')
		create table (patientdir+'pncount') ;
		(lastpn n(7,0))
		APPE BLAN
		USE
	endif
	use (patientdir+'pncount') IN 0
*ENDI
dbfuse = ''

PROC MAINSCR
@ 3,0 CLEA TO 20,80
@ 2,0
TEXT
                        ���������Ѻ�ҹ��ͧ�ѵ�����Ǫ����¹
                                STAT Version <<statversion>>
                                 ��з�ǧ�Ҹ�ó�آ
ENDTEXT
? SPAC(Center(programdate))+programdate

PROC WORKSCR
TEXT
                               ��зӧҹ�Ѳ�������
    ���ᾷ���д�ɰ�  ǧ�줳��ѵ����        �ç��Һ�����ͧ��ط�
    ���ᾷ��Ե�      �Ѳ��Ө�              �ç��Һ�������ɮ��
    ���ᾷ��͹��Ѳ��  ����صԡ��            ʶҺѹ�Ԩ���к��Ҹ�ó�آ
    ���ᾷ�����ѵ��   ��������侺����       �ç��Һ����þ�Է�Ի��ʧ�� �غ��
    ���ᾷ���ط�����  ����ǧ                �ç��Һ���ʹ� ��ظ��
    ���ᾷ�����      ʡ�žҳԪ��           �ç��Һ�ž�оط��ҷ ��к���
    �ҧ��ǹԵ��       ����ɪ�¹��ó�        ʶҺѹ�Ҫ�ѯ �ǹ�عѹ��
    �ҧ��������       �ԧ������ҧ           ����Ҹ�ó�آ��ʵ�� ��Դ�
    �ҧ�������ó�     ����๵�              �ӹѡ෤��������ʹ��
    �ҧ��ɳ���        ���õ���������       �ͧ�ç��Һ�������Ҥ
����֡��... ���ᾷ���تҵ� �óʶҾ�        �ç��Һ�����ҸԺ��
��Ѻ��ا��... �����Թ��� �Ԣ�Թ��ҹ���     �ç��Һ�������� ���
             ��.�ش�⪤ ����ѧ  �ç��Һ�����稾���ѧ��Ҫ ͧ���� 17 �ؾ�ó����
ENDTEXT

PROC SCATVAR
SELE patient1
mhn = hn
SCATTER TO patient1
mbirthday=IIF(EMPTY(birthday),'  /  /    ',STR(DAY(birthday),2)+'/'+STR(MONTH(birthday),2)+'/'+STR(YEAR(birthday)+543,4))
SELE patient2
SCATTER TO patient2
SELE contact
SCATTER TO contact1
IF owner='1'
	SKIP
	IF hn # contact1[1]
		SKIP -1
	ENDI
ENDI
SCATTER TO contact2