PARA _rqbe,_rqbe1,_call   
* _rqbe = 1 ����ʴ�������͡����� 2 ������͡
* _rqbe1 = 1 ������͡��Ҩ��ҵ�����ѹ���������� �֧ �ѹ����������
* _call �繵���÷��к͡��Ҩ�����ʴ� record �˹
EXTERNAL ARRAY condition,offer,condtype,show,xcode,xcoded,ycode,ycoded,xmin,;
xmax,ymin,ymax
DIME recshow[numshow]
condition[1,1]='���  '
condition[2,1]='����  '
condition[3,1]='������͹�  '
condition[1,2]='.AND.'
condition[2,2]='.OR.'
condition[3,2]=' '
offer[1,1]='��ҡѺ  '
offer[2,1]='�����ҡѺ  '
offer[3,1]='�ҡ����  '
offer[4,1]='���¡���  '
offer[5,1]='�����ҧ  '
offer[1,2]=' = '
offer[2,2]=' # '
offer[3,2]='>'
offer[4,2]='<'
offer[5,2]=' BETWEEN'
DEFINE WINDOW toprqbe FROM 8,5 TO 23,40 SHADOW TITLE '  ���͡�����  '
DEFINE WINDOW bottrqbe FROM 1,2 TO 5,77 SHADOW TITLE '  �����  '
DEFINE WINDOW condrqbe FROM 7,2 TO 16,77 SHADOW TITLE '  ���͹�  '
DEFINE WINDOW timerqbe FROM 19,2 TO 23,77 SHADOW TITLE '  ��������  '
	GO TOP
	i = 0
	DO WHIL ! EOF()
		IF _call $ callprg
			i = i + 1
			stor name to show(i)
			STORE RECNO() TO recshow[i]
		ENDI
		SKIP
	ENDD
	DIME show[i],recshow[i]
IF _rqbe = 1
	ACTIVATE WINDOW bottrqbe
	ACTIVATE WINDOW toprqbe
	CLEA
	mt1='������ǵ�� (᡹ Y)'
	mt2='������ǹ͹ (᡹ X)'
	@ 1,Center(mt1) SAY mt1
	xx=2
	xchoice=1
	@ 2,5 GET xchoice from show
	READ NOLOCK
	IF LASTKEY() = 27
		DEAC WIND ALL
		RETU
	ENDI
	showcommand='���ҧ���º��º�����ҧ '+TRIM(show(xchoice))
	ACTI WIND bottrqbe
	@ 0,0 SAY showcommand
	ACTI WIND toprqbe
	ychoice=1
	@ 1,0
	@ 1,Center(mt2) SAY mt2
	@ 2,5 GET ychoice from show
	READ NOLOCK
	IF LASTKEY() = 27
		DEAC WIND ALL
		RETU
	ENDI
** ��˹����Ϳ�Ŵ��᡹�͹
	STOR '' TO xvar,xtype,xopen,xfile,xhelp1,xhelp2,;
	yvar,ytype,yopen,yfile,yhelp1,yhelp2
	showcommand=showcommand+' �Ѻ '+TRIM(show(ychoice))
	header=showcommand
	ACTI WIND bottrqbe	
	@ 0,0 SAY showcommand
	go recshow[xchoice]
	
	DO GetVariable WITH 'x'
	go recshow[ychoice]
	DO GetVariable WITH 'y'
	DEAC WIND toprqbe
ENDI
****************************  ���͡���͹�㹡�ä���
ACTI WIND condrqbe
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpcond WITH VARREAD()
numcond = 6		&& �ӹǹ���͹��٧�ش�������
DIME rqbecond(numcond),cond1(numcond),cond2(numcond),cond3(numcond),;
prqbe(numcond),pcond1(numcond),pcond2(numcond),pcond3(numcond)
mspace=SPAC(LEN(name))
FOR i = 1 TO numcond
	STOR mspace TO rqbecond(i)
	STOR SPACE(10) TO cond1(i),cond2(i),cond3(i)
NEXT
FOR i = 1 TO numcond
	@ i,2 SAY STR(i,1)+'. ' GET rqbecond(i) VALID NAMERQBE()
	@ i,30 GET cond1(i) WHEN INCOND1() PICT '@!'
	@ i,45 GET cond2(i) WHEN incond2() PICT '@!'
	@ i,60 GET cond3(i) WHEN Incond3() PICT '@!'
NEXT
READ NOLOCK
IF LASTKEY() = 27
	DEAC WIND all
	RETU
ENDI
ON KEY LABEL F1 &mkeylabel
condmess=''
IF ! EMPTY(rqbecond(1))
	condcode='('
	FOR i = 1 TO numcond
		IF EMPTY(rqbecond(i))
			EXIT
		ENDI
		IF TYPE('pcond2[i]') # 'L'
			pcond2[i] = IIF(EMPTY(pcond2[i]),cond2[i],pcond2[i])
		ENDI
		atcomma = IIF( TYPE('pcond2[i]') = 'L', 0, AT(',',pcond2[i]))
		IF atcomma = 0 .AND. pcond1[i] = ' BETWEEN'
			WAIT '��ͧ����Ҥ�������ҧ ��ͧ������ͧ���� , ��� '  WIND NOWA
			?? CHR(7)
			RETU
		ENDI
		condmess = condmess+TRIM(rqbecond[i])+' '+TRIM(cond1[i])+' '+IIF(ISDIGIT(cond2[i]),' ','');
		+TRIM(cond2[i])+' '+TRIM(cond3[i])+[ ]
		IF pcond1[i] = ' BETWEEN'
			condcode = condcode + pcond1[i] + '(' + prqbe[i] + ','
			DO CASE
				CASE TRIM(rqbecond[i]) = '���ҷ���ҵ�Ǩ'
					conval1 = LEFT(pcond2[i],4)
					conval2 = RIGHT(TRIM(pcond2[i]),4)
					conval=LTRIM(STR(VAL(LEFT(conval1,2))*60+VAL(RIGHT(conval1,2))))+;
					','+LTRIM(STR(VAL(LEFT(conval2,2))*60+VAL(RIGHT(conval2,2))))+')'
				CASE condtype[i]='C'
					conval = '['+LEFT(pcond2[i],atcomma-1)+'],['+;
					TRIM(SUBS(pcond2[i],atcomma+1))+'])'
				CASE condtype[i] = 'L'
					conval = IIF( pcond2[i], '.T.', '.F.')
				OTHER
					conval = TRIM(pcond2[i])+')'
			ENDC
		ELSE
			condcode = condcode + prqbe(i) +' ' + pcond1[i]
			DO CASE
				CASE TRIM(rqbecond[i]) = '���ҷ���ҵ�Ǩ'
					conval = LTRIM(STR(VAL(LEFT(pcond2[i],2))*60+VAL(RIGHT(pcond2[i],2))))
				CASE condtype[i] = 'C'
					conval = '['+TRIM(pcond2[i])+']'
				CASE condtype[i] = 'L'
					conval = IIF( pcond2[i], '.T.', '.F.')
				OTHER
					conval = TRIM(pcond2[i])
			ENDC
		ENDI
		condcode =  condcode + conval
		IF pcond3[i] = '.OR.'
			condcode = condcode + ')'
		ENDI
		condcode = condcode + pcond3[i] + IIF(pcond3[i] = '.OR.','(','')
	NEXT
	condcode = condcode + ')'
*	ACTI WIND bottrqbe
*	? condcode
ELSE
	condcode = '.T.'
ENDI
**************************  ��˹���ǧ���ҷ��Ф���
IF _rqbe1 = 1
	IF TYPE('xchoice')#'U' .AND. xchoice > 0 .AND. ychoice > 0
		IF TRIM(show(xchoice)) $ '�ѹ�������Ѻ��ҹ,�ѹ����ҹ͹�ç��Һ��' .OR. ;
		TRIM(show(ychoice)) $ '�ѹ�������Ѻ��ҹ,�ѹ����ҹ͹�ç��Һ��'
			=ALARM1()
			WAIT WIND NOWA '����ö��˹���������������Թ 3 ��͹'
		ENDI
	ENDI
	ACTI WIND timerqbe
	STOR SPAC(8) TO mmyy,mmyy1
	STOR SPACE(12) TO sh1,sh2
	@ 1,2 SAY '������ѹ��� ' GET mmyy PICT '##/##/##' COLO gr+/b,gr/bg VALID CHECKDATE(mmyy)
	@ 2,14 GET sh1  WHEN showday(sh1,mmyy) COLO ,,,,,,,,,/w
	@ 1,27 SAY  '�֧�ѹ��� ' GET mmyy1 PICT '##/##/##' COLO gr+/b,gr/bg VALID CHECKDATE(mmyy1)
	@ 2,35 GET sh2 WHEN showday(sh2,mmyy1) COLO ,,,,,,,,,/w
	READ NOLOCK
ENDI

