EXTERNAL ARRAY PCOND3,COND3,CONDTYPE,PRQBE, OFFER ,PCOND1 ,PCOND2 ,CONDITION
#define numreport 8
DIME rp(numreport)
rp(1)='1. ����§ҹ��Ш�'
rp(2)='2. ���ҵ�����͹�'
rp[3] = '3. ���� HN ������͹�'
rp[4] = '4. ��˹����'
rp[5] = '5. �觢����ŵ�� Standard Data Set  '
rp[6] = '6. �Ҽ����µ���Է�Ե�ҧ �  '
rp[7] = '7. ��Ǩ�ͺ������ Standard Data Set  '
rp(numreport)='0. ��Ѻ��¡�����'
DEFINE WIND rp_menu FROM 4,5 TO 4+ALEN(rp)+3,44 SHAD TITLE '��§ҹ�������' COLO gr+/bg
IF FILE('DEFAULT.AGE')
	REST FROM default.age ADDI
ELSE
	DIME agecode(14),agecoded(14),agemax(14),agemin(14),agemaxtype(14),agemintype(14)
	STOR 0 TO agecount
	FOR in = 1 TO 14
		STOR SPACE(1) TO agemaxtype(in),agemintype(in)
		STOR SPACE(15) TO agecoded(in)
		STOR 0 TO agemax(in),agemin(in)
	NEXT
ENDI
IF FILE('DEFAULT.DX')
	REST FROM default.dx ADDI
ELSE
	DIME diagcode(14),diagcoded(14),diagmax(14),diagmin(14)
	STOR 0 TO diagcount
	FOR in = 1 TO 14
		STOR SPACE(5) TO diagmax(in),diagmin(in)
		STOR SPACE(15) TO diagcoded(in)
	NEXT
ENDI
DO WHIL .T.
	ACTI WIND rp_menu
	ON KEY LABEL CTRL+P
	CLEA
	IF USED('rqbe')
		SELE rqbe
		USE
	ENDI
	FOR i=1 TO numreport
		@ i,3 PROMPT rp(i)
	NEXT
	MENU TO Ch_rp
	DO CASE
		CASE Ch_Rp = 1
			DO RoutRep
		CASE BETWEEN(Ch_Rp,2,3)
			DEFINE WIND askch FROM 7,42 TO 15,78 SHAD
			ACTI WIND askch
			@ 2,2 PROMPT '1. ������ӹǹ�����������ѡ' MESS ;
			'����� INyymm ����ѡ �Ѻ���˹�觤����� 1 record'
			@ 3,2 PROMPT '2. ���������ԹԨ�������ѡ' MESS ;
			'����� DIAGyymm ����ѡ �Ѻ���˹�觤��������� record'
			@ 4,2 PROMPT '3. �������ü�ҵѴ����ѡ' MESS ;
			'����� DIAGyymm ����ѡ �Ѻ���˹�觤��������� record'
			MENU TO askch
			RELE WIND askch
			IF askch>0
				IF ch_rp = 2
					DO ipdrqbe WITH askch
				ELSE
					DO ihnrqbe WITH askch
				ENDI
			ENDI
		CASE Ch_RP = 4
			DO InstallRP
		CASE ch_rp = 5
			DO SendHip
		CASE ch_rp = 6
			DO Cardirep
		CASE ch_rp = 7
			DO HIPEdit
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND Rp_Menu
*SET COLO TO bg+/b

PROC RoutRep
ACTI SCREEN
routrep = 6
DIME routine[routrep]
routine[1] = '1. ��§ҹ�觡�з�ǧ  '
routine[2] = '2. ��§ҹ 505  '
routine[3] = '3. ��§ҹ�غѵ��˵ب�Ҩ�  '
routine[4] = '4. ��§ҹ�ä��辺���� '
routine[5] = '5. ��§ҹ�¡�ä  '
*routine[6] = '6. ��§ҹ���ӹѡ�ҹ��Сѹ�آ�Ҿ'
routine[routrep] = '0. ��Ѻ��¡�����  '
ch_rout = 1
DO WHIL .T.
	ACTI SCREEN
	DO ClearScreen
	@ 13,45 GET ch_rout FROM routine
	READ NOLOCK
	DO CASE
		CASE LASTKEY() = 27
			EXIT
		CASE ch_rout = 1
			DO c_rep
		CASE ch_rout = 2
			DO ToCal505
  		CASE ch_rout = 3
			DO IPAcci
  		CASE ch_rout = 4
			DO MostIPD
  		CASE ch_rout = 5
  			DO IpDiag
		OTHER
			EXIT
	ENDC
ENDD
DO ClearScreen
*DO MAINSCR

PROC INSTALLRP
ACTI SCREEN
DIME installrp[3]
installrp[1] = '1. ��˹����������'
installrp[2] = '2. ��˹�������ä'
installrp[3] = '0. ��Ѻ��¡�����'
ch_inst = 1
DO WHIL .T.
	ACTI SCREE
	DO ClearScreen
	@ 13,45 GET ch_inst FROM installrp
	READ NOLOCK
	DO CASE
		CASE LASTKEY() = 27
			EXIT
		CASE ch_inst = 1
			DO InstallAge
		CASE ch_inst = 2
			DO InstallDiag
		OTHER
			EXIT
	ENDC
ENDD
DO ClearScreen

FUNC NoError
PARA _handle,reason
_ret=.T.
IF _handle < 0                &&Error generated creating file
   	DO CASE 						     && Determine which error
			CASE FERROR() = 4
				reason = '�Դ����ҡ�Թ� �������ö����'
			CASE FERROR() = 5
 				reason = '�������ö��ҹ-��¹��'
 			CASE FERROR() = 8
 				reason = '�����������§��'
			CASE FERROR() = 29
				reason = '����շ����ҧ'
	    CASE FERROR() = 31
	    		reason = '�բ�ͼԴ��Ҵ���� � �'
	 	ENDCASE
	_ret=.F.
ENDI
RETURN _ret

PROC INSTALLAGE
PUSH KEY
ON KEY LABEL F2 DO Saveage WITH '.age','age*'
ON KEY LABEL F3 DO Restoreage WITH '.age','age*'
DEFINE WIND installage FROM 3,15 TO 20,75 SHAD TITLE '  ��˹����������  ';
FOOT '  [Esc]=���º����  [F2]=�红�����  [F3]=���¡������  '
ACTI WIND installage
@ 0,0 SAY ' ��������  ���������  �֧����  ��ͤ�������ʴ�'
DO Editage
ACTI SCREE
@ 24,0
agecount=ASCAN(agemintype,' ')
agecount=IIF(agecount = 0,ALEN(agemintype),agecount-1)
IF ! FILE('default.age')
	SAVE ALL LIKE age* TO default.age
ENDI
RELE WIND installage
POP KEY

PROC RESTOREAGE
PARA _ext,_wild
DIME filefound[1,1]
PUSH KEY CLEA
wildcard = '*'+_ext
IF ADIR(filefound,wildcard)>0
	FOR i = 1 TO ALEN(filefound) STEP 5
		filefound[i] = LEFT(filefound[i],AT('.',filefound[i])-1)
	ENDF
	choosefile = 1
	DEFINE WIND choosefile FROM  3,4 TO 13,18 SHAD TITLE '  ���͡  '
	ACTI WIND choosefile
	@ 1,1 GET choosefile FROM filefound && SIZE 8,11
*	KEYB '{HOME} '
	READ NOLOCK
	RELE WIND choosefile
	IF ! EMPTY(choosefile)
		choosefile = filefound[choosefile+(4*(choosefile-1))]
		REST FROM (choosefile+_ext) ADDI
		SHOW GETS
	ENDI
ENDI
POP KEY

PROC SAVEAGE
PARA _ext,_wild
DEFINE WIND Asksave FROM 10,20 TO 15,65 SHAD
PUSH KEY CLEA
ACTI WIND asksave
CLEA
overwrite = 'Y'
@ 1,3 SAY '��ͧ����纤������������� ' GET filename DEFA SPACE(8)
READ NOLOCK
IF FILE(filename+_ext)
	?? CHR(7)
	overwrite = 'N'
	@ 2,3 SAY '��������� '+TRIM(filename)+' ��������'
	@ 3,3 SAY '��ͧ�����¹�Ѻ������� ' GET overwrite PICT '!'
	READ NOLOCK
ENDI
IF overwrite $ '��Y' .AND. ! EMPTY(filename)
	IF UPPE(_wild) = 'AGE*'
		agecount=ASCAN(agemintype,' ')
		agecount=IIF(agecount = 0,ALEN(agemintype),agecount-1)
	ELSE
		diagcount = ASCAN(diagmin,'  ')
		diagcount = IIF(diagcount = 0, ALEN(diagmin), diagcount-1)
	ENDI
	SAVE ALL LIKE (_wild) TO (filename+_ext)
ENDI
RELE WIND asksave
POP KEY

PROC EDITAGE
FOR in = 1 TO 14
	@ in+1,2 SAY STR(in,2)+'.'
	@ in+1,12 GET agemintype(in)  PICT '#' MESS '1 = ��  2 = ��͹  3 = �ѹ ' VALID Checkat()
	@ in+1,14 GET agemin(in) PICT '##'
	@ in+1,24 GET agemaxtype(in) PICT '#' MESS '1 = ��  2 = ��͹  3 = �ѹ ' VALID Checkat()
	@ in+1,26 GET agemax(in) PICT '##'
	@ in+1,34 GET agecoded(in)
NEXT
READ NOLOCK CYCLE

PROC INSTALLDIAG
PUSH KEY
ON KEY LABEL F2 DO Saveage WITH '.dx','diag*'
ON KEY LABEL F3 DO Restoreage WITH '.dx','diag*'
DEFINE WIND installage FROM 3,15 TO 20,75 SHAD TITLE '  ��˹�������ä  ';
FOOT '  [Esc]=���º����  [F2]=�红�����  [F3]=���¡������  '
ACTI WIND installage
@ 0,0 SAY ' ��������  ���������  �֧����  ��ͤ�������ʴ�'
FOR in = 1 TO 14
	@ in+1,2 SAY STR(in,2)+'.'
	@ in+1,12 GET diagmin(in) PICT '@!'
	@ in+1,24 GET diagmax(in) PICT '@!'
	@ in+1,34 GET diagcoded(in)
NEXT
READ NOLOCK CYCLE
ACTI SCREE
@24,0
diagcount=ASCAN(diagmin,' ')
diagcount=IIF(diagcount = 0,ALEN(diagmin),diagcount-1)
IF ! FILE('default.dx')
	SAVE ALL LIKE diag* TO default.dx
ENDI
RELE WIND installage
POP KEY

FUNC CHECKAT
xxx=VARREAD()
IF ! &xxx $ ' 123'
	?? CHR(7)
	WAIT WIND '1 = ��  2 = ��͹  3 = �ѹ ' NOWA
	_CUROBJ=_CUROBJ
ENDI