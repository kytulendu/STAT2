***************************************************************
**							*  �����  DISCH  *             **
***************************************************************
PRIV goon
DEAC WIND HELP_ADM
_printappoint=.T.

dr='999999'
mhn=0
man=0
anyy=subst(mdate,9,2)
mdatedsc=ce2be(date(),2)
dr='999999'
refc='1'
hospt='            '
dr1='999999'
timedsc='0001'
dcstatus='2'
dctype='1'
mhn=space(7)
m.an = SPACE(7)
STOR SPAC(2) TO outcause
STOR SPAC(3) TO clinic,wardnow,m.clinic,nowclinic
STOR SPAC(4) TO outtime
STOR SPAC(6) TO m.doctor
STOR SPAC(5) TO outplace
STOR SPAC(25) TO mward,mclinic
STOR SPAC(30) TO referoutplace,mdoctor

dimension wmenu(3)
 wmenu(1)='    �ѹ�֡  '
 wmenu(2)='    ���   '
 wmenu(3)='    ¡��ԡ  '
hdr1='�ҹ��˹��¼������ '

***** MAIN LOOP *******

DO WHILE .T.

	FLUSH
	store .F. to mexit

	@ 0,0 clea to 1,80
	DO CLEARSCR

	@ 0,(wcols()-len(hdr1))/2 say hdr1 color g+/b
	@ 2,0 SAY REPL('-',80)
	@ 21,0 SAY REPL('-',80)
	@ 1,15 say '�Ţ�������¹͡'
	@ 1,37 get mhn  picture '!999999' ;
	mess '�� ESC ��ҵ�ͧ�����ԡ�ҹ  ��� W ��˹�Ҷ�ҵ�ͧ����ҵ���ͼ�����'
	READ NOLOCK
	IF LASTKEY() = 27 .OR. EMPTY(mhn)
		WAIT WIND '¡��ԡ��è�˹��¼�����' TIME 2
		@ 0,0 CLEA TO 1,79
		RETU
	ENDI
	IF ISDIGIT(mhn)
		m.hn=PADZERO(mhn,7)
		SELE iptrana
		set order to tag hn
		dummyan=' '
		nowrec=recno()
		IF seek(m.hn)
			DO WHILE hn=m.hn
				nowrec  = IIF(an>dummyan,recno(),nowrec)
				dummyan = IIF(an>dummyan,an,dummyan)
				skip
			ENDDO
		ELSE
			wait '����� HN ������������Ť���� ' window timeout 2
			return to adm_cen
		ENDIF
		go nowrec
		scat memvar
		SELE patient1
		SET ORDER TO TAG hn
		SEEK m.hn
		SCAT MEMV
		IF ! EMPTY( m.datedsc)
			?? CHR(7)
			WAIT WIND NOWA '��������¹����ŧ discharge �����'
		ELSE
			DO INPUTDISC
		ENDI
	ELSE
		SELE IPTRANA
		wardnow = SUBS(mhn,2,3)
		SELE ward
		SET ORDER TO 1
		SEEK wardnow
		mward = TRIM(name)
		disctemp = tempdir+SYS(3)
		SELE iptrana
		COPY TO (DISCTEMP) FIELD hn,an,doctor,dateadm FOR ward_now = wardnow ;
		.AND. EMPTY(datedsc)
		dbfuse = disctemp
		use (disctemp) IN 0 alia disctemp
		SELE disctemp
		REPL ALL doctor WITH '����'
		dbfuse = ''
		FLUSH
		SET RELA TO hn INTO patient1
		GO TOP
		DEFINE WIND BrowFull FROM 3,1 TO 20,78 SHAD TITLE '  ��ª��ͼ��������'+mward+'  '
		msg = '[Enter] = ����¹ʶҹ������ҧ ���� ��� ��Ѻ  [Esc] = �������º����'
		@ 24,0
		@ 24,Center(msg) SAY msg COLO R+
		ON KEY LABEL ENTER REPL doctor WITH IIF(doctor='����','��Ѻ','����')
		BROW FIELD hn :H= '�Ţ��� HN' ,aan =right(an,5)+'-'+left(an,2) :H='�Ţ��� AN',named = DE_NAME(patient1.name) : H = '���ͼ�����' ,;
		datea = CE2BE(dateadm,2) :H = '�ѹ����Ѻ���',doctor :H='ʶҹ�' NOMO WIND browfull FREE hn
		RELE WIND browfull
		ON KEY LABEL ENTER
		@ 23,0
		LOCA FOR doctor = '��Ѻ'
		DO WHIL ! EOF() &&SUSP
			SELE patient1
			SET ORDER TO TAG hn
			seek disctemp.hn
			scatter memvar
			m.doctor = SPACE(LEN(m.doctor))
			mhn=subst(hn,1,7)
			SELE iptrana
			SET ORDER TO TAG an
			SEEK disctemp.an
			scatter memvar
			DO InputDisc
			SELE disctemp
			CONT
		ENDD
		SELE disctemp
		USE
		DELE FILE (disctemp+'.dbf')
		STOR SPAC(3) TO wardnow
		STOR SPACE(25) TO mward
		STOR SPACE(7) TO mhn
	ENDI
ENDDO
FLUSH
on key label PGUP
on key label Alt+1
on key label Alt+2
on key label Alt+3
return

*********************************
PROC newins_d
*********************************
sele  iptrana
	gather  memvar
	FLUSH
IF dctype = '4' .AND. ! EMPTY(outplace)
	SELE refer
	mday=DTOC(m.datedsc)
	m.day=SUBS(mday,4,2)+LEFT(mday,2)
	m.type='2'  && ���¶֧ refer out
	m.place=outplace
	m.cause=outcause
	GO TOP
	IF ! EMPTY(an) .OR. BOF()
		APPE BLANK
	ENDI
	GATHE MEMV
	FLUSH
ENDI
IF ! dctype $ '3489'
	dbfuse = codedir+'icd101'
	USE (codedir+'icd101') ORDER 1 IN 0
	dbfuse = ''
	mdiag1 = '  '
	DO AskAppoint  			&& �ͺ�������ա�ùѴ�����������
	SELE icd101
	USE
ENDI
*dr='999999'
*mssn='99-       - '
mhn=0
man=0
*dep='  '
*ward='   '
dcstatus='2'
dctype='1'
mhn=space(7)
STOR SPAC(2) TO outcause
STOR SPAC(3) TO clinic,wardnow,m.clinic,nowclinic
STOR SPAC(4) TO outtime
STOR SPAC(6) TO m.doctor
STOR SPAC(5) TO outplace
STOR SPAC(25) TO mward,mclinic
STOR SPAC(30) TO referoutplace,mdoctor

@ 0,0 clear to 1,78
DO CLEARSCR
return

PROC INPUTDISC
@ 1,0 clea to 1,78
@ 1,2 say 'HN.'
@ 1,23 say 'AN.'
@ 1,34 say '/'
@ 1,45 say '����'
@ 1,8 say m.hn color gr+/b
@ 1,50 say De_Name(m.name)
@ 1,28 say subs(m.an,3,5)+'-'+subs(m.an,1,2)
store .T. TO mexit
@ 4,0 say '2' color gr+/r
@ 4,2 say '�Է�ԡ���ѡ��'
SELE social
SEEK m.pttyp
@ 4,16 SAY  social->name
@ 11,2 say '�ѹ����Ѻ�����ç��Һ��'
@ 11,30 say CE2CBE(m.dateadm)
@ 13,2 say '�ѹ����˹��¨ҡ�ç��Һ��'
goon = .T.
m.dr = SPACE(LEN(m.dr))
m.timedsc=substr(time(),1,2)+substr(time(),4,2)
DO WHIL goon
	@ 13,30 get mdatedsc  PICT '99/99/99' VALID TRUEDATE(mdatedsc) and BETWEEN(be2ce(mdatedsc),m.dateadm,DATE()) ;
	MESS '����ѹ ��͹ �� �繻վط��ѡ�Ҫ'
	@ 13,45 get mmdate defa space(12) when showbe(mdatedsc,mmdate)
	@ 13,60 SAY '���� ' GET m.timedsc PICT '@R ##:##'
	@ 15,0 say '3' color gr+/r
	@ 15,2 say 'Discharge status : '
	@ 15,21 get dcstatus picture '9' valid v_dc()
	@ 15,30 say 'Discharge type   : '
	@ 15,49 get dctype picture '9' valid v_refer()
	@ 15,52 say 'ᾷ����Ңͧ��'
	@ 15,68 get m.dr WHEN InputDoctor(m.dr) VALID CheckDoctor(m.dr,mdoctor) ;
	MESS '�������ᾷ����ӡ���ѡ�Ҽ�����'
	@ 16,49 GET mdoctor DISA
	READ NOLOCK
	m.disc=dcstatus+dctype
	m.datedsc=BE2CE(mdatedsc)
	@ 22,0 clear
	n=1
	for n=1 to 3
	@ 22,(n-1)*20+5 prompt wmenu(n)
	endfor
	menu to choice
	@ 22,0
	do case
		case choice=1   && �ѹ�֡ ��з���¡�õ���
			do newins_d
			goon =.F.
			m.timedsc=substr(time(),1,2)+substr(time(),4,2)
		case choice=2	&& ���
			@ 22,0
		case choice=3	&& ¡��ԡ ���ѹ�֡
			@ 0,0 clear to 1,78
			DO CLEARSCR
			goon = .F.
	endcase
ENDD
dcstatus='2'
dctype='1'
mhn=space(7)
STOR SPAC(2) TO outcause
STOR SPAC(3) TO clinic,wardnow,m.clinic,nowclinic
STOR SPAC(4) TO outtime
STOR SPAC(6) TO m.doctor
STOR SPAC(5) TO outplace
STOR SPAC(25) TO mward,mclinic
STOR SPAC(30) TO referoutplace,mdoctor
