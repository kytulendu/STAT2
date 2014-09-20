*****************************************************************
*	โปรแกรมสำหรับค้นหาโดยจะมีรายชื่อตัวแปรเป็นภาษาไทยให้เลือก   *
*	ลักษณะจะเป็นตาราง 2 มิติ โดย		 						*
*	ตัวแปรที่เลือกจะเป็นตัวแปรตามแนวแกนตั้ง						*
*	ตัวแปรตัวที่สองจะเป็นตัวแปรตามแนวแกนนอน						*
*	ตัวแปรทั้งหลายจะอยู่ในแฟ้ม ipdrqbe.DBF และ ipdrqbe.FPT			*
*	และสามารถกำหนดเงื่อนไขได้อีก 6 เงื่อนไข โดยตัวแปรเงื่อนไข	*
*	สามารถเลือกได้โดยกดปุ่ม [F1] หรือพิมพ์ตัวแปรเป็นภาษาไทย		*
*	ตามใน LIST													*
*	ไม่ควรเลือกวันที่มาตรวจเป็นเงื่อนไข เพราะสามารถกำหนดได้จาก	*
*	การกำหนดว่าจะหาข้อมูลตั้งแต่วันไหนถึงวันไหนอยู่แล้ว			*
*****************************************************************
PARA _ChRqbe
PRIV xline,yline,xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,;
yhelp1,yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess,xchoice,ychoice;
ystart,yend,ystep,xstart,xend,xstep
STOR '' TO xvar,yvar,condcode,xfile,yfile,xhelp1,xhelp2,yhelp1,;
yhelp2,xtype,ytype,header,mmyy,mmyy1,condmess
DIME xcode(1),xcoded(1),ycode(1),ycoded(1),xmin(1),xmax(1),ymin(1),ymax(1)
STOR 0 TO xline,yline,xchoice,ychoice,ystart,yend,ystep,xstart,xend,xstep
DIME xdummy[1],ydummy[1]
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
DIME condition[3,2],offer[5,2],condtype[6]
numshow = RECCOUNT()
DIME show(numshow)
DO GetCond WITH 1,1,'I'
IF LASTKEY() = 27 .OR. EMPTY(mmyy) .OR. EMPTY(mmyy1)
	DEAC WIND all
	RETU
ENDI

*************************	กำหนดตัวแปรที่จะใช้คำนวณ
DIME result(xline+10,yline+10),xtotal(xline+10),ytotal(yline+10)  && กำหนดไดเมนชั่นที่จะเก็บค่าผลลัพธ์
DIME xfind(xline),yfind(yline)  && กำหนดอะเรย์สำหรับเก็บค่ารหัสที่มีจริง
errorage = 0
**  กำหนดค่าเริ่มต้นเป็น 0 ให้ทุกค่าใน array
		STOR 0 TO xcount,ycount   && กำหนดจำนวนที่พบจริง ๆ ในการหาผลลัพธ์
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
STOR 0 TO xx,yyy
errmonth=''
SELE 0
*********************	เริ่มวนลูปเพื่อคำนวณข้อมูล
EXTERNAL ARRAY Tmonth
mm1 = mm
yy1 = yy
IF ! USED('patient2')
	dbfuse = patientdir+'patient2'
	USE (patientdir+'patient2') ORDER 1 IN 0
ENDI
IF ! USED('contact')
	dbfuse = patientdir+'contact'
	USE (patientdir+'contact') ORDER 1 IN 0
ENDI
IF ! USED('patient1')
	dbfuse = patientdir+'patient1'
	USE (patientdir+'patient1') ORDER 1 IN 0
ENDI
dbfuse = ''
totalcase = 0
DO WHIL startfile <= endfile
	err=TMONTH(VAL(RIGHT(startfile,2)))+' '+FULLYEAR(LEFT(startfile,2))
	yy = LEFT(startfile,2)
	mm = RIGHT(startfile,2)
	IF ! FILE(ipddir+'\data\in'+startfile+'.dbf')
		=ALARM1()
		WAIT WIND 'ไม่พบแฟ้มเดือน'+err NOWAIT
		errmonth = errmonth+' '+err+','
	ELSE
		WAIT WIND 'กำลังคำนวณข้อมูลเดือน' + err NOWAIT
		DO OpenFile1
		DO CASE
			CASE _ChRqbe = 1
				SELE inp
				SET RELA TO hn INTO patient2,hn INTO contact,an INTO ;
				diagnosis,an INTO operation,an INTO DEATH_YR,hn INTO ;
				patient1,an INTO refer
			CASE _ChRQBE = 2
				SELE diagnosis
				SET RELA TO an INTO inp,an INTO operation,an INTO DEATH_YR,;
				an INTO refer
				SELE inp
				SET RELA TO hn INTO patient2,hn INTO patient1,hn INTO ;
				contact ADDI
				SELE diagnosis
			CASE _ChRQBE = 3
				SELE operation
				SET RELA TO an INTO inp,an INTO diagnosis,an INTO DEATH_YR,;
				an INTO refer
				SELE inp
				SET RELA TO hn INTO patient1,hn INTO patient2,hn INTO ;
				contact ADDI
				SELE operation
		ENDC
		DO result1			&& Module ที่คำนวณข้อมูลแต่ละเดือน
	ENDI
	IF RIGHT(startfile,2)='12'	&& เพิ่มเดือนทีละหนึ่งเดือน
		startfile=STRZERO(VAL(LEFT(startfile,2))+1,2)+'01'
	ELSE
		startfile=LEFT(startfile,2)+STRZERO(VAL(RIGHT(startfile,2))+1,2)
	ENDI
ENDD
mm = mm1
yy = yy1

**********************		จัดเรียงข้อมูลตามลำดับ
IF xcount = 0 .OR. ycount = 0
	?? CHR(7)
	mshow = IIF(xcount=0,TRIM(show(xchoice)),TRIM(show(ychoice)))
	WAIT 'ไม่มีข้อมูลของตัวแปร '+ mshow WIND NOWA
	DEAC WIND ALL
	RETU
ENDI	
DIME xfind(xcount),yfind(ycount)
=ACOPY(xfind,xdummy)
=ACOPY(yfind,ydummy)
=ASORT(xfind)
=ASORT(yfind)
IF TYPE('xcoded')='L'
	DIME xcode[xcount]
	SELE (xfile)
	xseek=IIF(xfile='ADDRESS','1','')
	FOR i = 1 TO xcount
		mseek=xseek+xfind(i)
		IF SEEK(mseek)
			STOR &xhelp1 TO xcode(i)
			STOR TRIM(&xhelp2) TO xcoded(i)
		ELSE
			STOR xfind(i) TO xcode(i)
			STOR 'รหัส '+IIF(TYPE('XFIND[i]')='D',DTOC(xfind[i]),xfind(i)) TO xcoded(i)
		ENDI
	NEXT
ELSE
	IF ALEN(xfind) > ALEN(xcode)	
		_xx = ALEN(xcode)
		FOR i = 1 TO ALEN(xfind)
			IF ASCAN(xcode,xfind(i)) = 0
				_xx = _xx+1
				DIME xcode(_xx),xcoded(_xx)
				STOR xfind(i) TO xcode[_xx]
				STOR 'รหัส '+IIF(TYPE('XFIND[i]')='D',DTOC(xfind[i]),xfind(i)) TO xcoded(_xx)
			ENDI
		NEXT
	ENDI
ENDI
IF TYPE('ycoded')='L'
	DIME ycode[ycount]
	SELE (yfile)
	xseek=IIF(yfile='ADDRESS','1','')
	FOR i = 1 TO ycount
		mseek=xseek+yfind(i)
		IF SEEK(mseek)
			STOR &yhelp1 TO ycode(i)
			STOR TRIM(&yhelp2) TO ycoded(i)
		ELSE
			STOR yfind(i) TO ycode(i)
			STOR 'รหัส '+IIF(TYPE('yfind[i]')='D',DTOC(yfind[i]),yfind(i)) TO ycoded(i)
		ENDI
	NEXT
ELSE
	IF ALEN(yfind) > ALEN(ycode)	
		_xx = ALEN(ycode)
		FOR i = 1 TO ALEN(yfind)
			IF ASCAN(ycode,yfind(i)) = 0
				_xx = _xx+1
				DIME ycode(_xx),ycoded(_xx)
				STOR yfind(i) TO ycode[_xx]
				STOR 'รหัส '+IIF(TYPE('yfind[i]')='D',DTOC(yfind[i]),yfind(i)) TO ycoded(_xx)
			ENDI
		NEXT
	ENDI
ENDI
DEAC WIND ALL
	IF UPPER(RIGHT(xvar,8)) $ 'AGE_TYPE,PROVINCE'
		xstart = xcount
		xstep = -1
		xend = 1
	ELSE
		xstart = 1
		xstep = 1
		xend = xcount
	ENDI
	IF UPPER(RIGHT(yvar,8)) $ 'AGE_TYPE,PROVINCE'
		ystart = ycount
		ystep = -1
		yend = 1
	ELSE
		ystart = 1
		ystep = 1
		yend = ycount
	ENDI
DO ClearScreen
IF errorage > 0
	=ALARM1()
	numerror = LTRIM(STR(errorage))
	WAIT WIND NOWA 'มีคนไข้ที่ไม่สามารถหาอายุได้ ' + numerror + ' ราย' TIME 10
ENDI
reportfile=tempdir+sys(3)+'.txt'
SET PRINT TO &reportfile
SET PRINT ON
SET CONS OFF
_wrap=.F.
_plength=41
_peject='NONE'
_pageno=1
_plineno=0
_PLOFFSET = 0
ON PAGE AT line _plength-2 DO rqbeheader WITH .T.,header
KEYB ' '
STOR 0 TO xlen,ylen
*susp
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
		mprint = IIF(xtype='D',xcoded(ii),IIF(ASCAN(xcode,xfind(ii))>0,xcoded(ASCAN(xcode,xfind(ii))),'รหัส '+xfind(ii)+xfind[ii]))
		mprint = TRIM(mprint)
		? mprint+'  '+SPAC(xlen-LEN(mprint))
		xpos=ASCAN(xdummy,xfind(ii))
		FOR j= ystart TO yend STEP ystep
			ypos=ASCAN(ydummy,yfind(j))
*			?? SPACE(ylen-7+LENTHAI(ycoded(j))-LEN(ycoded(j)))+TRANSFORM(result(xpos,ypos),'999,999');
*			+SPAC(LEN(ycoded(j))-LENTHAI(ycoded(j)))+'  '
			mlen = ylen-7+LENTHAI(ycoded[j])-LEN(ycoded(j))
			mlen = IIF(mlen>0,mlen,1)
			?? SPACE(mlen)+TRANSFORM(result(xpos,ypos),'999,999');
			+SPAC(LEN(ycoded(j))-LENTHAI(ycoded[j]))+'  '
		NEXT
	?? TRANSFORM(xtotal(xpos),'999,999'),;
	TRANSFORM(ROUND(xtotal(xpos)*100/totalcase,2),'999,999.99')
		net=net+xtotal(xpos)
	NEXT
	?
	? 'รวม'+SPAC(xlen-1)
	FOR j= ystart TO yend STEP ystep
		ypos=ASCAN(ydummy,yfind(j))
		mlen = ylen-7+LENTHAI(ycoded[j])-LEN(ycoded(j))
		mlen = IIF(mlen>0,mlen,1)
		?? SPACE(mlen)+TRANSFORM(ytotal(ypos),'999,999');
		+SPAC(LEN(ycoded(j))-LENTHAI(ycoded[j]))+'  '
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
	? 'หมายเหตุ'
	? SPACE(10)+'ตั้งแต่วันที่ '+CE2CBE(startdate)+' ถึงวันที่ '+CE2CBE(enddate)
	IF condcode # '.T.'
		? SPACE(10)+'โดย ' + condmess
	ENDI
	IF ! EMPTY(errmonth)
		? SPACE(10)+'ไม่พบแฟ้มข้อมูลเดือน' + LEFT(errmonth,LEN(errmonth)-1)
	ENDI
	IF errorage > 0
		? SPACE(10) +'มีคนไข้ที่ไม่สามารถหาอายุได้ ' + numerror + ' ราย'
	ENDI
	?
ENDPRINTJOB
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpbrow
DO Endprint WITH '  รายงานผู้ป่วยในแบบตาราง  ',reportfile
ON KEY LABEL F1 &mkeylabel
*CLOSE DATA
DELE FILE &reportfile
SET RELA TO

PROC Result1
EXTERNAL ARRAY xcode,ycode,xfind,yfind
IF RIGHT(xvar,4) $ '.AGE,DIAG,CD10,USE1,USE2,';
 .OR. (RIGHT(xvar,4)='EDSC' .AND. xtype # 'D')
	=ACOPY(xcode,xfind)
ENDI
IF RIGHT(yvar,4)$'.AGE,DIAG,CD10,USE1,USE2,EDSC' ;
 .OR. (RIGHT(yvar,4)='EDSC' .AND. ytype # 'D')
	=ACOPY(ycode,yfind)
ENDI
div_num=ROUND((RECCOUNT()/40)+.5,0)
recno = 0
DO ShowProgress
*SUSP
SCAN
	recno=recno+1
	@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
	IF &condcode .AND. BETWEEN(inp.datedsc,startdate,enddate)
		xchar=&xvar
		xchar = IIF(RIGHT(xvar,4)$'N.OP',LEFT(xchar,4),xchar)
		xpos=GETVRQBE(xchar,xx,xfind,xcount,'x')
		ychar=&yvar
		ychar = IIF(RIGHT(yvar,4)$'N.OP',LEFT(ychar,4),ychar)
		ypos=IIF(xpos>0,GETVRQBE(ychar,yyy,yfind,ycount,'y'),0)
		IF xpos>0 .AND. ypos >0
			result(xpos,ypos)=result(xpos,ypos)+1
			xtotal(xpos)=xtotal(xpos)+1
			ytotal(ypos)=ytotal(ypos)+1
			totalcase = totalcase+1
		ENDI
	ENDI
ENDS
RELE WIND comment

PROC rqbeheader
PARA _foreject,_header
PRIVATE mprint,mhosp
mhosp=TRIM(hosp_name)
*mtime1='ตั้งแต่วันที่ '+CE2CBE(startdate)+' ถึง วันที่ '+CE2CBE(enddate)
IF _foreject
	eject page
	eject
ENDI
mpagep='หน้าที่ '+LTRIM(STR(_pageno))
numspace = CENTER(_header)-LEN(mpagep)
numspace = IIF(numspace>0,numspace,1)
?mpagep+SPACE(numspace)+_header
?SPAC(CENTER(mhosp))+mhosp
?
	? SPACE(xlen)+'  '
	dummy=xlen+2
	FOR iii= ystart TO yend STEP ystep
		mprint = IIF(ytype='D',ycoded(iii),IIF(ASCAN(ycode,yfind(iii))>0,ycoded(ASCAN(ycode,yfind[iii])),'รหัส '+yfind[iii]))
		mprint = TRIM(mprint)
		?? SPAC(ylen-LEN(mprint))+mprint+'  '
	NEXT
	?? SPAC(4)+'รวม'+'         %  '
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
	CASE LEFT(fieldname,4) $ 'AGE ,DATED'
		IF EMPTY(agecount)
			=ALARM1()
			WAIT WIND NOWA 'จะต้องกำหนดค่ากลุ่มอายุก่อน'
			DEAC WIND ALL
			RETU TO irp_menu
		ENDI
		DIME &_m.code(agecount),&_m.coded(agecount),&_m.min(agecount),&_m.max(agecount)
		STOR agecount TO &_m.line
		FOR in = 1 TO agecount
			STOR STR(in,2) TO &_m.code(in)
			STOR ((3-VAL(agemintype(in)))*100)+agemin(in) TO &_m.min(in)
			STOR ((3-VAL(agemaxtype(in)))*100)+agemax(in) TO &_m.max(in)
			STOR TRIM(agecoded(in)) TO &_m.coded(in)
		NEXT
	CASE LEFT(fieldname,4) $ 'DIAG ,ICD1,' .OR. (LEFT(fieldname,4) = 'CAUS' .AND. filename # 'REFER')
		IF EMPTY(diagcount)
			=ALARM1()
			WAIT WIND NOWA 'จะต้องกำหนดค่ากลุ่มโรคก่อน'
			DEAC WIND ALL
			RETU TO irp_menu
		ENDI
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
		IF  EMPTY(code) .AND. desc = 'ดัมมี่'
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
					dbfuse = ''
				ENDI
				&_m.help1=FIELD(1)
				&_m.help2=FIELD(2)
				&_m.line=IIF(&_m.file $ 'ADDRESS,HOSPCODE,ICDCM1',100,reccount())
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
PRIV var,alianame
var = &_m.var
mmtype = &_m.type
*SUSP
mpos = 0
alianame = LEFT(var,AT('.',var)-1)
IF ! EOF(alianame)
DO CASE
	CASE RIGHT(var,4)$'.AGE,EDSC' .AND. mmtype # 'D'
		_mcount=&_m.line
		mpos= 0
		age_type = ' '
		age = 0
		DO ConvAge WITH age_type,age,inp.datedsc-patient1.birthday
		IF ! EMPTY(age_type)
			FOR in = 1 TO _mcount
				IF BETWEEN(((3-VAL(age_type))*100)+age,&_m.min(in),&_m.max(in))
					mpos=in
					EXIT
				ENDI
			NEXT
		ELSE
			errorage = errorage + 1
		ENDI
	CASE RIGHT(var,4)$'DIAG,CD10,USE1,USE2'
		_mcount=&_m.line
		mpos= 0
		FOR in = 1 TO _mcount
			vari = &var
			vmin = &_m.min(in)
			vmax = &_m.max(in)
*			IF BETWEEN(&var,&_m.min(in),&_m.max(in))
			IF BETWEEN(vari,vmin,vmax)
				mpos=in
				EXIT
			ENDI
		NEXT
	OTHER
		DO CASE
			CASE RIGHT(var,4)='T_IN'
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
ENDI
RETU mpos
PROC CONVAGE
PARA _agetype,_age,_daybirth
DO CASE
	CASE _daybirth > 365
		_agetype = '1'
		_age = INT(_daybirth/365)
	CASE _daybirth >= 30
		_agetype = '2'
		_age = INT(_daybirth/30)
	CASE _daybirth > 0
		_agetype = '3'
		_age = _daybirth
	OTHER
		_agetype = ' '
		_age = 0
ENDC
