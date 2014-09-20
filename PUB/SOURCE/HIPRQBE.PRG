PARA _type
*****************************************************************
*	โปรแกรมสำหรับค้นหาโดยจะมีรายชื่อตัวแปรเป็นภาษาไทยให้เลือก   *
*	ลักษณะจะเป็นตาราง 2 มิติ โดย								*
*	ตัวแปรที่เลือกจะเป็นตัวแปรตามแนวแกนตั้ง 					*
*	ตัวแปรตัวที่สองจะเป็นตัวแปรตามแนวแกนนอน 					*
*	ตัวแปรทั้งหลายจะอยู่ในแฟ้ม ROBE.DBF และ RQBE.FPT			*
*	และสามารถกำหนดเงื่อนไขได้อีก 6 เงื่อนไข โดยตัวแปรเงื่อนไข	*
*	สามารถเลือกได้โดยกดปุ่ม [F1] หรือพิมพ์ตัวแปรเป็นภาษาไทย 	*
*	ตามใน LIST													*
*	ไม่ควรเลือกวันที่มาตรวจเป็นเงื่อนไข เพราะสามารถกำหนดได้จาก	*
*	การกำหนดว่าจะหาข้อมูลตั้งแต่วันไหนถึงวันไหนอยู่แล้ว			*
*****************************************************************
CLOSE DATA
DEAC WIND rp_menu
USE hiprqbe IN 0 ALIA rqbe
*diagcode = 'DG1,DG2,DG3,DG4,DG5,OP1,OP2,OP3,OP4,OP5'
*opcode = 'OP1,OP2,OP3,OP4,OP5'
SELE rqbe
DIME condition[3,2],offer[5,2],condtype[6]
condition[1,1]='และ  '
condition[2,1]='หรือ  '
condition[3,1]='หมดเงื่อนไข  '
condition[1,2]='.AND.'
condition[2,2]='.OR.'
condition[3,2]=' '
offer[1,1]='เท่ากับ  '
offer[2,1]='ไม่เท่ากับ  '
offer[3,1]='มากกว่า  '
offer[4,1]='น้อยกว่า  '
offer[5,1]='ระหว่าง  '
offer[1,2]=' = '
offer[2,2]=' # '
offer[3,2]='>'
offer[4,2]='<'
offer[5,2]=' BETWEEN'
DEFINE WINDOW toprqbe FROM 8,5 TO 23,40 SHADOW TITLE '  เลือกตัวแปร  '
DEFINE WINDOW bottrqbe FROM 1,2 TO 5,77 SHADOW TITLE '  คำสั่ง  '
DEFINE WINDOW condrqbe FROM 7,2 TO 16,77 SHADOW TITLE '  เงื่อนไข  '
DEFINE WINDOW timerqbe FROM 19,2 TO 23,77 SHADOW TITLE '  ระยะเวลา  '
ACTIVATE WINDOW bottrqbe
ACTIVATE WINDOW toprqbe
CLEA
mt1='ตัวแปรแนวตั้ง (แกน Y)'
mt2='ตัวแปรแนวนอน (แกน X)'
@ 1,Center(mt1) SAY mt1
xx=2
numshow = RECCOUNT()
DIME show(numshow),showrec[numshow]
GO TOP
i = 0
SCAN
	IF UPPE(_type) $ UPPE(callprg)
		i = i + 1
		stor name to show(i)
		STORE RECNO() TO showrec[i]
	ENDI
ENDS
numshow = i
DIME show(numshow),showrec[numshow]
xchoice=1
@ 2,5 GET xchoice from show
READ
IF LASTKEY() = 27
	DEAC WIND ALL
	CLOSE DATA
	RETU
ENDI
showcommand='ตารางเปรียบเทียบระหว่าง '+TRIM(show(xchoice))
ACTI WIND bottrqbe
@ 0,0 SAY showcommand
ACTI WIND toprqbe
ychoice=1
@ 1,0
@ 1,Center(mt2) SAY mt2
@ 2,5 GET ychoice from show
READ
IF LASTKEY() = 27
	DEAC WIND ALL
	CLOSE DATA
	RETU
ENDI
** กำหนดชื่อฟิลด์ในแกนนอน
showcommand=showcommand+' กับ '+TRIM(show(ychoice))
header=showcommand
ACTI WIND bottrqbe
@ 0,0 SAY showcommand

STOR '' TO xvar,xtype,xopen,xfile,xhelp1,xhelp2,;
yvar,ytype,yopen,yfile,yhelp1,yhelp2,xsqlcode,xsqlgroup,ysqlcode,ysqlgroup
DIME xcode(1),xcoded(1),ycode(1),ycoded(1),xmin(1),xmax(1),ymin(1),ymax(1)
STOR 0 TO xline,yline
go showrec[xchoice]
DO GetVariable WITH 'x'
go showrec[ychoice]
DO GetVariable WITH 'y'
DEAC WIND toprqbe
****************************  เลือกเงื่อนไขในการค้นหา
ACTI WIND condrqbe
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpcond WITH VARREAD()
numcond = 6		&& จำนวนเงื่อนไขสูงสุดที่มีได้
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
READ
IF LASTKEY() = 27
	DEAC WIND all
	CLOSE DATA
	RETU
ENDI
condcode1 = '.T.'
condcode = '.T.'
ON KEY LABEL F1 &mkeylabel
condmess=''
IF ! EMPTY(rqbecond(1))
	condcode='('
	FOR i = 1 TO numcond
		IF EMPTY(rqbecond(i))
			EXIT
		ENDI
		condmess = condmess+TRIM(rqbecond[i])+TRIM(cond1[i])+IIF(ISDIGIT(cond2[i]),' ','');
		+TRIM(cond2[i])+' '+TRIM(cond3[i])+[ ]
		IF TYPE('pcond2[i]') # 'L'
			pcond2[i] = IIF(EMPTY(pcond2[i]),cond2[i],pcond2[i])
		ENDI
		atcomma = IIF( TYPE('pcond2[i]') = 'L', 0, AT(',',pcond2[i]))
		IF atcomma = 0 .AND. pcond1[i] = ' BETWEEN'
			WAIT 'ต้องการหาค่าระหว่าง ต้องมีเครื่องหมาย , คั่น '  WIND NOWA
			?? CHR(7)
*			CLOSE DATA
			RETU
		ENDI
*******************************
		IF pcond1[i] = ' BETWEEN'
			condcode = condcode + pcond1[i] + '(' + prqbe[i] + ','
			DO CASE
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
				CASE condtype[i] = 'C'
					conval = '['+TRIM(pcond2[i])+']'
				CASE condtype[i] = 'L'
					conval = IIF( pcond2[i], '.T.', '.F.')
				OTHER
					conval = TRIM(pcond2[i])
			ENDC
		ENDI
		condcode = condcode + conval
		IF pcond3[i] = '.OR.'
			condcode = condcode + ')'
		ENDI
		condcode = condcode + pcond3[i] + IIF(pcond3[i] = '.OR.','(','')
	NEXT
	condcode = condcode + ')'
*	ACTI WIND bottrqbe
*	? condcode
ENDI
condcode = IIF(TYPE('condcode')='C' .AND. LEN(condcode)<5,'.T.',condcode)
**************************  กำหนดช่วงเวลาที่จะค้นหา
STORE SPACE(10) TO m.startdate, m.enddate
m.typedate = 1
DO RQBETime.spr
IF LASTKEY() = 27
	DEAC WIND all
	CLOSE DATA
	RETU
ENDI
DO CASE
	CASE m.typedate = 1
		date = 'datein'
		typeright = 'วันเริ่มมีสิทธิ์'
	CASE m.typedate = 2
		date = 'dateexp'
		typeright = 'วันหมดอายุใช้สิทธิ์'
	OTHER
		date = 'notedate'
		typeright = 'วันที่ออกบัตร'
ENDC

*************************	กำหนดตัวแปรที่จะใช้คำนวณ
startdate = BE2CE(m.startdate)
enddate = BE2CE(m.enddate)
*datestart = FullYear(RIGHT(mmyy,2)) + SUBS(mmyy,4,2) + LEFT(mmyy,2)
*dateend = FullYear(RIGHT(mmyy1,2)) + SUBS(mmyy1,4,2) + LEFT(mmyy1,2)
*dyy = LEFT(startfile,2)
*mm = RIGHT(startfile,2)
*yy1 = LEFT(endfile,2)
*mm1 = RIGHT(endfile,2)
STOR 0 TO xx,yy
showfile = SYS(3)
SELE 0
*********************	เริ่มวนลูปเพื่อคำนวณข้อมูล
EXTERNAL ARRAY Tmonth
test = SYS(3)
test1 = SYS(3)
*susp
dbfuse = patientdir + 'insure'
= Opendbf(dbfuse,'')
dbfuse = patientdir + 'patient1'
= Opendbf(dbfuse,'')
dbfuse = patientdir + 'patient2'
= Opendbf(dbfuse,'')
dbfuse = patientdir + 'contact'
= Opendbf(dbfuse,'')
dbfuse = ''
DO CalSQL WITH _type

RELE WIND toprqbe
RELE WIND bottrqbe
RELE WIND condrqbe
RELE WIND timerqbe
SELE showfile
IF RECCOUNT() = 0
	= ALARM1()
	WAIT 'ไม่มีข้อมูลคามที่กำหนด' WIND NOWA
	DEAC WIND ALL
	CLOSE DATA
	DELE FILE (showfile+'.dbf')
	RETU
ELSE
	SORT ON fieldx,fieldy TO (test) FOR ! EMPTY(fieldx) .AND. ! EMPTY(fieldy)
	USE (test) ALIA test
	DELE FILE (showfile+'.dbf')
	DELE FILE (showfile+'.cdx')
	INDEX ON fieldy TAG yvar
	DEAC WIND ALL
ENDI
GO TOP

n = 0
RELEASE condition,offer,condtype,showrec
RELEASE WINDOW toprqbe,bottrqbe,condrqbe,timerqbe
IF RECCOUNT() > 0
DIME xfind[xline+10],yfind[yline+10],result[xline+10,yline+10],xtotal[xline+10],;
ytotal[yline+10]
   FOR I = 1 TO XLINE+10
      STORE 0 TO XTOTAL( I)
      FOR J = 1 TO YLINE+10
	 STORE 0 TO RESULT( I, J), YTOTAL( J)
      ENDFOR
   ENDFOR

DO WHIL ! EOF()
	n = n+1
		DIME yfind[n]
		IF ALEN(ycoded) < n
			DIME ycoded[n]
		ENDI
	yfind[n] = fieldy
	IF 'จำนวนวันที่อยู่รักษา' $ show(ychoice)
		ycoded[n] = 'รักษาอยู่ ' + ALLTRIM(fieldy) + ' วัน'
		IF ALEN(ycode) < n
			DIME ycode[n]
		ENDI
		ycode[n] = yfind[n]
	ENDI
	DO WHIL fieldy = yfind[n] .AND. ! EOF()
		SKIP
	ENDD
ENDD
ycount = n
SET ORDER TO 0
GO TOP
n = 0
DO WHIL ! EOF()
	n = n+1
		DIME xfind[n]
	IF ALEN(xcoded) < n
		DIME xcoded[n]
	ENDI
	xfind[n] = fieldx
	IF 'จำนวนวันที่อยู่รักษา' $ show(xchoice)
		xcoded[n] = 'รักษาอยู่ ' + ALLTRIM(fieldx) + ' วัน'
		IF ALEN(xcode) < n
			DIME xcode[n]
		ENDI
		xcode[n] = xfind[n]
	ENDI
	DO WHIL fieldx = xfind[n] .AND. ! EOF()
		SKIP
	ENDD
ENDD
xcount = n
DIME xfind[xcount],yfind[ycount]

IF TYPE('xcoded')='L'
	DIME xcode[xcount],xcoded[xcount]
	SELE (xfile)
	FOR i = 1 TO xcount
		mseek=xfind(i)
		IF SEEK(mseek)
			STOR xfind[i] TO xcode(i)
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
	DIME ycode[ycount],ycoded[ycount]
	SELE (yfile)
*	xseek=IIF(yfile='ADDRESS','1','')
	FOR i = 1 TO ycount
		mseek=yfind(i)
		IF SEEK(mseek)
			STOR yfind[i] TO ycode(i)
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
=ACOPY(xcode,xdummy)
=ACOPY(ycode,ydummy)
SELE test
GO TOP
totalcase = 0
*susp
DO WHIL ! EOF()
	xpos = ASCAN(xcode,fieldx)
	ypos = ASCAN(ycode,fieldy)
	result[xpos,ypos] = number
	xtotal[xpos] = xtotal[xpos] + number
	ytotal[ypos] = ytotal[ypos] + number
	totalcase = totalcase + number
	SKIP
ENDD
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
reportfile=SYS(3)+'.txt'
SET PRINT TO &reportfile
SET PRINT ON
SET CONS OFF
_wrap=.F.
_plength=30
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
		mprint = IIF(xtype='D',xcoded(ii),IIF(ASCAN(xcode,xfind(ii))>0,xcoded(ASCAN(xcode,xfind(ii))),'รหัส '+xfind(ii)+xfind[ii]))
		mprint = TRIM(DE_name(mprint))
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
	? 'รวม'+SPAC(xlen-1)
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
		?? SPACE(mlen)+ TRANSFORM(ROUND(ytotal(ypos)*100/totalcase,2),'9999.99');
		+SPAC(LEN(ycoded(j))-LENTHAI(ycoded[j]))+'  '
	NEXT
	?? TRANSFORM(100,'9999.99')
	?
	? 'หมายเหตุ'
	? SPACE(10)+typeright+'ตั้งแต่วันที่ '+CE2CBE(startdate)+' ถึงวันที่ '+ CE2CBE(enddate)
	IF ! EMPTY(condmess)
		? SPACE(10)+'โดย ' + condmess
	ENDI
	?
ENDPRINTJOB
mkeylabel=ON('KEY','F1')
ON KEY LABEL F1 DO helpbrow
DO Endprint WITH '  รายงานแบบตาราง  ',reportfile
ON KEY LABEL F1 &mkeylabel
*CLOSE DATA
DELE FILE &reportfile
ELSE
	=ALARM1()
	WAIT WIND NOWA 'ไม่มีข้อมูลที่ตรงกับที่ได้เลือกไว้'
ENDI
CLOSE DATA

PROC Result1
EXTERNAL ARRAY xcode,ycode,xfind,yfind
IF RIGHT(xvar,4) $ '.AGE,.DG1,.OP1'
	=ACOPY(xcode,xfind)
ENDI
IF RIGHT(yvar,4)$'.AGE,.DG1,.OP1'
	=ACOPY(ycode,yfind)
ENDI
div_num=ROUND((RECCOUNT()/40)+.5,0)
recno = 0
DO ShowProgress

SCAN
	recno=recno+1
	@ 3,4+(ROUND(recno/div_num+.5,0)) SAY '' COLO gr+
	IF &condcode
		DO CASE
			CASE RIGHT(xvar,3) $ diagcode
				FOR vv = 1 TO 4
					vvv = STR(vv,1)
					xchar=IIF(RIGHT(xvar,3) = 'DG1', dg&vvv, op&vvv)
					IF ! EMPTY(xchar)
						xpos=GETVRQBE(xchar,xx,xfind,xcount,'x')
						ychar=&yvar
						ypos=GETVRQBE(ychar,yy,yfind,ycount,'y')
						IF xpos>0 .AND. ypos >0
							result(xpos,ypos)=result(xpos,ypos)+1
							xtotal(xpos)=xtotal(xpos)+1
							ytotal(ypos)=ytotal(ypos)+1
							totalcase = totalcase+1
						ENDI
					ELSE
						EXIT
					ENDI
				NEXT
			CASE RIGHT(yvar,3) $ 'DG1,OP1'
				FOR vv = 1 TO 4
					vvv = STR(vv,1)
					ychar=IIF(RIGHT(yvar,3) = 'DG1', dg&vvv, op&vvv)
					IF ! EMPTY(ychar)
						xchar=&xvar
						xpos=GETVRQBE(xchar,xx,xfind,xcount,'x')
						ypos=GETVRQBE(ychar,yy,yfind,ycount,'y')
						IF xpos>0 .AND. ypos >0
							result(xpos,ypos)=result(xpos,ypos)+1
							xtotal(xpos)=xtotal(xpos)+1
							ytotal(ypos)=ytotal(ypos)+1
							totalcase = totalcase+1
						ENDI
					ELSE
						EXIT
					ENDI
				NEXT
			OTHER
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
		ENDC
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
		mprint = TRIM(DE_NAME(mprint))
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
*
&_m.sqlcode = TRIM(sqlcode)
&_m.sqlgroup = TRIM(sqlgroup)
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
				STOR codedir + code TO &_m.file,&_m.xfile
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
					USE (&_m.xfile) ORDER 1
				ENDI
				&_m.help1=FIELD(1)
				&_m.help2=FIELD(2)
				&_m.line=IIF(UPPE(&_m.file) $ 'ADDRESS,HOSPCODE,OCCUPAT,NATION,',100,reccount())
			ENDI
		ENDI
		&_m.line = IIF(&_m.line > 0 ,&_m.line,1)
		DIME &_m.coded(&_m.line)
		SELE rqbe
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
	CASE RIGHT(&_m.var,4) $ '.DG1,.DG2,.DG3,.DG4,.OP1,.OP2,.OP3,.OP4'
		_mcount=&_m.line
		mpos= 0
		FOR in = 1 TO _mcount
			IF BETWEEN(_mtype,&_m.min(in),&_m.max(in))
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

PROC HELPCOND
PARA _varread
PUSH KEY CLEA
IF UPPE(LEFT(_varread,8))='RQBECOND'
	_row=ROW()
	ACTI WIND toprqbe
	vchoice=1
	@ 2,5 GET vchoice from show WIND toprqbe
	READ
	DEAC WIND toprqbe
	GO showrec(vchoice)
	&_varread=name
	STOR fieldtype TO condtype[_row]
	STOR TRIM(filename)+'.'+TRIM(fieldname) TO prqbe[_row]
ENDI
POP KEY
KEYB CHR(13)

FUNC INCOND1
_varread=VARREAD()
_level=VAL(SUBS(_varread,7,1))
mc=1
IF fieldtype='L'
	&_varread=offer[1]
ELSE
	DEFINE WIND test FROM _level+8,30 TO _level+17,60 SHAD TITLE ''
	ACTI WIND test
	mc=1
	@ 1,3 GET mc FROM offer
	READ
	&_varread=offer(mc,1)
	RELE WIND test
ENDI
STOR offer[mc,2] TO pcond1[_level]
SHOW GETS
RETU .F.

FUNC INCOND2
_varread=VARREAD()
_level=VAL(SUBS(_varread,7,1))
IF pcond1[_level]=' BETWEEN' .OR. EMPTY(desc) .OR. fieldname = 'T_IN'
	pcond2[_level] = ' '
	RETU .T.
ELSE
	numline=MEMLINES(desc)
	DIME showhelp[numline]
	FOR i=1 to numline
		STOR mline(desc,i) TO showhelp(i)
	NEXT
	mc=1
	DEFINE WIND test FROM _level+8,45 TO _level+15,70
	ACTI WIND test
	@ 1,3 GET mc FROM showhelp
	READ
	RELE WIND test
	&_varread=showhelp[mc]
	STOR mline(code,mc) TO pcond2[_level]
	IF fieldtype='L'
		pcond2[_level]=IIF(pcond2[_level]='1',.T.,.F.)
	ENDI
	SHOW GETS
	RETU .F.
ENDI

FUNC INCOND3
_varread=VARREAD()
_level=VAL(SUBS(_varread,7,1))
mc=1
DEFINE WIND test FROM _level+8,60 TO _level+15,78
ACTI WIND test
@ 1,3 GET mc FROM condition SIZE 5,10
READ
RELE WIND test
IF mc=3
	_CUROBj=1000
	STOR condition[mc,2] TO pcond3[_level]
ELSE
	STOR condition[mc,2] TO pcond3[_level]
	&_varread =  condition[mc,1]
	SHOW GETS
	RETU .F.
ENDI

FUNC NAMERQBE
PRIVATE _varread
_varread=VARREAD()
_key = LASTKEY()
IF EMPTY(&_varread) .AND. _key # 5
	_l = VAL(SUBS(_varread,10,1))
	IF _l > 1
		STOR '  ' TO pcond3[_l-1]
		STOR SPACE(10) TO cond3[_l-1]
	ENDI
	_CUROBJ=1000
ELSE
DO CASE
CASE _key=5 .AND. _CUROBJ > 1
	_CUROBJ = _CUROBJ - 4
CASE _key = 24
	_CUROBJ = _CUROBJ + 4
CASE _key = 13
	LOCA FOR name = &_varread
	IF ! FOUND() .OR. fieldtype='D'
		?? CHR(7)
		IF fieldtype = 'D'
			WAIT 'ตัวแปรเป็นวันที่ ให้เลือกระยะเวลาที่ค้นหาแทน' WIND NOWA
		ENDI
		_CUROBJ = _CUROBJ
	ELSE
		_row=ROW()
		STOR TRIM(filename)+'.'+TRIM(fieldname) TO prqbe[_row]
		STOR fieldtype TO condtype[_row]
	ENDI
ENDC
ENDI

FUNC SHOWDAY
PARA _show,_date
PRIVATE date
date=FULLYEAR(_date)
date=BE2CE(date)
_show=CE2CBE(date)
SHOW GETS
RETU .F.

FUNC CHECKDATE
PARA _date
IF ! TRUEDATE(_date)
	?? CHR(7)
	WAIT WIND 'ใส่วันที่ไม่ถูกต้อง' NOWA
	_CUROBJ = _CUROBJ
ELSE
	_varread=VARREAD()
	IF _varread='MMYY1' .AND. BE2CE(_date)<BE2CE(mmyy)
		?? CHR(7)
		WAIT WIND 'วันที่เริ่มต้นต้องน้อยกว่าวันที่สิ้นสุด  ' NOWA
		_CUROBJ = 1
	ENDI
ENDI
RETU

PROC CALSQL
PARA _typecal

*SET TALK ON
*IF UPPE(_typecal) = 'O'
		SELE &xsqlcode AS fieldx,&ysqlcode AS fieldy,COUNT(insure.hn) AS number ;
		FROM insure, patient1, patient2, contact ;
		WHERE insure.hn = patient1.hn .AND. insure.hn = patient2.hn .AND. ;
		insure.hn = contact.hn .AND.&condcode ;
		GROUP BY &xsqlgroup,&ysqlgroup ;
		HAVING BETWEEN(&date,startdate,enddate) ;
		INTO TABLE (showfile)
*ENDI
SET TALK OFF
	USE (showfile) ALIA showfile EXCL
	xindex = IIF(TYPE('fieldx') = 'D', 'DTOS(fieldx)', 'fieldx')
	yindex = IIF(TYPE('fieldy') = 'D', 'DTOS(fieldy)', 'fieldy')
	indexexp = xindex + yindex
	INDEX ON (indexexp) TAG one

