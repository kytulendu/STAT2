*****************************************************************
*	���������Ѻ�����¨�����ª��͵������������������͡   *
*	�ѡɳШ��繵��ҧ 2 �Ե� ��		 						*
*	����÷�����͡���繵���õ����᡹���						*
*	����õ�Ƿ���ͧ���繵���õ����᡹�͹						*
*	����÷�����¨��������� STATRQBE.DBF ��� STATRQBE.FPT			*
*	�������ö��˹����͹����ա 6 ���͹� �µ�������͹�	*
*	����ö���͡���¡����� [F1] ���;����������������		*
*	���� LIST													*
*	��������͡�ѹ����ҵ�Ǩ�����͹� ��������ö��˹���ҡ	*
*	��á�˹���Ҩ��Ң����ŵ�����ѹ�˹�֧�ѹ�˹��������			*
*****************************************************************
PRIV xline,yline,xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,;
yhelp1,yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess,xchoice,ychoice;
ystart,yend,ystep,xstart,xend,xstep,goon
STOR '' TO xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,yhelp1,;
yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess
DIME xcode(1),xcoded(1),ycode(1),ycoded(1),xmin(1),xmax(1),ymin(1),ymax(1)
STOR 0 TO xline,yline,xchoice,ychoice,ystart,yend,ystep,xstart,xend,xstep
DIME xdummy[1],ydummy[1]
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
DIME condition[3,2],offer[5,2],condtype[6]
numshow = RECCOUNT()
DIME show(numshow)
DO GetCond WITH 1,1,'S'
IF LASTKEY() = 27 .OR. EMPTY(mmyy) .OR. EMPTY(mmyy1)
	DEAC WIND all
	WAIT WIND NOWA '¡��ԡ��ä��ҵ����ͧ���'
	CLOSE DATA
	RETU
ENDI

*************************	��˹�����÷�����ӹǳ
DIME result(xline+10,yline+10),xtotal(xline+10),ytotal(yline+10)  && ��˹�������蹷����纤�Ҽ��Ѿ��
DIME xfind(xline),yfind(yline)  && ��˹�����������Ѻ�纤�����ʷ���ը�ԧ
**  ��˹������������� 0 ���ء���� array
		STOR 0 TO xcount,ycount   && ��˹��ӹǹ��辺��ԧ � 㹡���Ҽ��Ѿ��
		FOR i = 1 TO xline+10
			STOR 0 TO xtotal(i)
			FOR j = 1 TO yline+10
				STOR 0 TO result(i,j),ytotal(j)
			NEXT
		NEXT
startdate = BE2CE(mmyy)
enddate = BE2CE(mmyy1)
startfile=RIGHT(mmyy,2)+SUBS(mmyy,4,2)
endfile=RIGHT(mmyy1,2)+SUBS(mmyy1,4,2)
STOR 0 TO xx,yy
errmonth=''
dbfuse = patientdir+'patient2'
USE (patientdir+'patient2') ORDER 1 IN 0
dbfuse = patientdir+'contact'
USE (patientdir+'contact') ORDER 1 IN 0
SELE 0
dbfuse = patientdir+'patient1'
USE (patientdir+'patient1') ORDER TAG lastdate ASCEND
SET RELA TO hn INTO patient2,hn INTO contact
dbfuse = ''
*********************	�����ǹ�ٻ���ͤӹǳ������
EXTERNAL ARRAY Tmonth
totalcase = 0
EXTERNAL ARRAY xcode,ycode,xfind,yfind
IF RIGHT(xvar,4) $ '.AGE,DIAG'
	=ACOPY(xcode,xfind)
ENDI
IF RIGHT(yvar,4)$'.AGE,DIAG'
	=ACOPY(ycode,yfind)
ENDI
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
		xchar=&xvar
		xpos=GETVRQBE(xchar,xx,xfind,xcount,'x')
		ychar=&yvar
		ypos=GETVRQBE(ychar,yy,yfind,ycount,'y')
		IF xpos>0 .AND. ypos >0
			result(xpos,ypos)=result(xpos,ypos)+1
			xtotal(xpos)=xtotal(xpos)+1
			ytotal(ypos)=ytotal(ypos)+1
			totalcase = totalcase+1
		ENDI
	ENDI
	SKIP
ENDD
ON KEY LABEL F10
RELE WIND comment
IF ! goon
	=ALARM1()
	WAIT WIND NOWA '¡��ԡ��äӹǳ�����ͧ���'
	CLOSE DATA
	RETU
ENDI
IF ! SortRQBE()
	CLOSE DATA
	RETU
ENDI
DO ClearScreen
reportfile=tempdir+SYS(3)+'.txt'
SET PRINT TO &reportfile
SET PRINT ON
SET CONS OFF
_wra2p=.F.
_plength=41
_peject='NONE'
_pageno=1
_plineno=0
_PLOFFSET = 0
ON PAGE AT line _plength-2 DO rqbeheader WITH .T.,header
KEYB ' '
STOR 0 TO xlen,ylen
FOR i =1 TO xcount
	xcoded[i]=IIF(xtype='D',CE2CBE(xfind[i]),xcoded[i])
	xcoded[i]=IIF(xtype='D' .AND. AT(' ',xcoded[i])=2,' '+xcoded[i],xcoded[i])
	curlen = IIF(xtype='D', LEN(xcoded[i]), LEN(xcoded(ASCAN(xcode,xfind(i)))) )
	xlen=MAX(xlen,curlen)
NEXT
FOR i =1 TO ycount
	ycoded[i]=IIF(ytype='D',CE2CBE(yfind[i]),ycoded[i])
	ycoded[i]=IIF(ytype='D' .AND. AT(' ',ycoded[i])=2,' '+ycoded[i],ycoded[i])
	curlen = IIF(ytype='D', LEN(ycoded[i]), LEN(ycoded(ASCAN(ycode,yfind(i)))) )
	ylen=MAX(ylen,curlen)
NEXT
xlen=IIF(xlen>10,xlen,10)
ylen=IIF(ylen>10,ylen,10)
PRINTJOB
	DO rqbeheader WITH .F.,header
	Net=0
	FOR ii = xstart TO xend STEP xstep
		mprint = IIF(xtype='D',xcoded(ii),IIF(ASCAN(xcode,xfind(ii))>0,xcoded(ASCAN(xcode,xfind(ii))),'���� '+xfind(ii)+xfind[ii]))
		mprint = TRIM(mprint)
		? mprint+'  '+SPAC(xlen-LEN(mprint))
		xpos=ASCAN(xdummy,xfind(ii))
		FOR j= ystart TO yend STEP ystep
			ypos=ASCAN(ydummy,yfind(j))
			mlen = ylen-7+LENTHAI(ycoded[j])-LEN(ycoded(j))
			mlen = IIF(mlen>0,mlen,1)
			?? SPACE(mlen)+TRANSFORM(result(xpos,ypos),'999,999');
			+SPAC(LEN(ycoded(j))-LENTHAI(ycoded[j]))+'  '
*		?? SPACE(ylen-7+LENTHAI(ycoded(j))-LEN(ycoded(j)))+TRANSFORM(result(xpos,ypos),'999,999');
*		+SPAC(LEN(ycoded(j))-LENTHAI(ycoded(j)))+'  '
		NEXT
	?? TRANSFORM(xtotal(xpos),'999,999'),;
	TRANSFORM(ROUND(xtotal(xpos)*100/totalcase,2),'999,999.99')
		net=net+xtotal(xpos)
	NEXT
	?
	? '���'+SPAC(xlen-1)
	FOR j= ystart TO yend STEP ystep
		ypos=ASCAN(ydummy,yfind(j))
		mlen = ylen-7+LENTHAI(ycoded[j])-LEN(ycoded(j))
		mlen = IIF(mlen>0,mlen,1)
		?? SPACE(mlen)+TRANSFORM(ytotal(ypos),'999,999');
		+SPAC(LEN(ycoded(j))-LENTHAI(ycoded[j]))+'  '
*	?? SPACE(ylen-7+LENTHAI(ycoded(j))-LEN(ycoded(j)))+TRANSFORM(ytotal(ypos),'999,999');
*	+SPAC(LEN(ycoded(j))-LENTHAI(ycoded(j)))+'  '
	NEXT
	?? TRANSFORM(net,'999,999'),;
	TRANSFORM(100,'999,999.99')
	? ' % '+SPAC(xlen-1)
	FOR j= ystart TO yend STEP ystep
		ypos=ASCAN(ydummy,yfind(j))
		mlen = ylen-7+LENTHAI(ycoded[j])-LEN(ycoded(j))
		mlen = IIF(mlen>0,mlen,1)
		?? SPACE(mlen)+	TRANSFORM(ROUND(ytotal(ypos)*100/totalcase,2),'9999.99');
		+SPAC(LEN(ycoded(j))-LENTHAI(ycoded[j]))+'  '
	NEXT
	?? TRANSFORM(100,'9999.99')
	?
	? '�����˵�'
	? SPACE(10)+'������ѹ��� '+CE2CBE(startdate)+' �֧�ѹ��� '+CE2CBE(enddate)
	? '����� � �ѹ���' + CE2CBE(Date()) + ' ���� ' + Time()
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


PROC rqbeheader
PARA _foreject,_header
PRIVATE mprint,mhosp
mhosp=TRIM(hosp_name)
*mtime1='������ѹ��� '+CE2CBE(startdate)+' �֧ �ѹ��� '+CE2CBE(enddate)
IF _foreject
	eject page
	eject
ENDI
mpagep='˹�ҷ�� '+LTRIM(STR(_pageno))
numspace = CENTER(_header)-LEN(mpagep)
numspace = IIF(numspace>0,numspace,1)
?mpagep+SPACE(numspace)+_header
?SPAC(CENTER(mhosp))+mhosp
?
	? SPACE(xlen)+'  '
	dummy=xlen+2
	FOR iii= ystart TO yend STEP ystep
		mprint = IIF(ytype='D',ycoded(iii),IIF(ASCAN(ycode,yfind(iii))>0,ycoded(ASCAN(ycode,yfind[iii])),'���� '+yfind[iii]))
		mprint = TRIM(mprint)
		?? SPAC(ylen-LEN(mprint))+mprint+'  '
	NEXT
	?? SPAC(4)+'���'+'         %  '
?
IF _foreject
	?
ENDI


PROC GETVARIABLE
PARA _m
&_m.var=ALLTRIM(filename)+'.'+ALLTRIM(fieldname)
&_m.type = fieldtype
*SUSP
DO CASE
	CASE fieldname='AGE '
		DIME &_m.code(agecount),&_m.coded(agecount),&_m.min(agecount),&_m.max(agecount)
		STOR agecount TO &_m.line
		FOR in = 1 TO agecount
			STOR STR(in,2) TO &_m.code(in)
			STOR ((3-VAL(agemintype(in)))*100)+agemin(in) TO &_m.min(in)
			STOR ((3-VAL(agemaxtype(in)))*100)+agemax(in) TO &_m.max(in)
			STOR TRIM(agecoded(in)) TO &_m.coded(in)
		NEXT
	CASE fieldname='DIAG '
		DIME &_m.code(diagcount),&_m.coded(diagcount),&_m.min(diagcount),&_m.max(diagcount)
		STOR diagcount TO &_m.line
		FOR in = 1 TO diagcount
			STOR STR(in,2) TO &_m.code(in)
			STOR diagmin(in) TO &_m.min(in)
			STOR diagmax(in) TO &_m.max(in)
			STOR TRIM(diagcoded(in)) TO &_m.coded(in)
		NEXT
	OTHER
		m.fieldname = TRIM(fieldname)
		IF  EMPTY(code) .AND. desc = '������'
			&_m.line=100
			DIME &_m.coded[100]
		ELSE
			IF MEMLINES(code) > 1
				&_m.line=memlines(code)
				DIME &_m.code(&_m.line)
				fulllenght = LEN(mline(code,1))
				FOR i=1 to &_m.line
					STOR LEFT(mline(code,i)+'   ',fulllenght) TO &_m.code(i)
				NEXT
				i = i-1
				&_m.code[i] = IIF(&_m.code[i]='',SPACE(fulllenght),&_m.codee[i])
			ELSE
				STOR codedir+code TO &_m.file,&_m.xfile
				mat=AT('\',&_m.file)
				DO WHIL mat>0
					&_m.file=SUBS(&_m.file,mat+1)
					mat=AT('\',&_m.file)
				ENDD
				IF USED(&_m.file)
					SELE (&_m.file)
					SET ORDER TO 1
				ELSE
					SELE 0
					dbfuse = &_m.xfile
					USE (&_m.xfile) ORDER 1
				ENDI
				dbfuse = ''
				&_m.help1=FIELD(1)
				&_m.help2=FIELD(2)
				&_m.line=IIF(&_m.file = 'ADDRESS',100,reccount())
			ENDI
		ENDI
		DIME &_m.coded(&_m.line)
		SELE statrqbe
		IF ! EMPTY(desc)
			FOR i=1 to &_m.line
				STOR mline(desc,i) TO &_m.coded(i)
			NEXT
		ENDI
ENDC

FUNC GETVRQBE
PARA _mtype,_mx,_marray,_mcount,_m
EXTERNAL ARRAY _marray
DO CASE
	CASE RIGHT(&_m.var,4)='.AGE'
		_mcount=&_m.line
		mpos= 0
		FOR in = 1 TO _mcount
			IF BETWEEN(((3-VAL(age_type))*100)+age,&_m.min(in),&_m.max(in))
				mpos=in
				EXIT
			ENDI
		NEXT
	CASE RIGHT(&_m.var,4)='DIAG'
		_mcount=&_m.line
		mpos= 0
		FOR in = 1 TO _mcount
			IF BETWEEN(diag,&_m.min(in),&_m.max(in))
				mpos=in
				EXIT
			ENDI
		NEXT
	OTHER
		DO CASE
			CASE RIGHT(&_m.var,4)='T_IN'
				_mtype = STR(INT(t_in/60),2)
				IF &_m.code[1]='1'
					DO CASE
						CASE _mtype <' 8'
							_mtype='1'
						CASE _mtype <'16'
							_mtype='2'
						OTHER
							_mtype='3'
					ENDC
				ENDI
			CASE RIGHT(&_m.var,4)='TIME'
				_mtype = LEFT(time,2)
				IF &_m.code[1]='1'
					DO CASE
						CASE _mtype <' 8'
							_mtype='1'
						CASE _mtype <'16'
							_mtype='2'
						OTHER
							_mtype='3'
					ENDC
				ENDI
			CASE TYPE('_mtype')='L'
				_mtype=IIF(_mtype,'1','2')
			CASE TYPE('_mtype')='N'
				_mtype=STR(_mtype,1)
		ENDC
		mpos=ascan(_marray,_mtype)
		IF mpos=0
			_mx=_mx+1
			_mcount=_mcount+1
			IF _mcount > ALEN(_marray)
				DIME _marray[_mcount]
			ENDI
			STOR _mtype TO _marray(_mx)
			mpos=_mx
		ENDI
ENDC
RETU mpos
