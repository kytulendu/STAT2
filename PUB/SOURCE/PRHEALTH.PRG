********************************************************************************
*  โมดูลพิมพ์บัตรสวัสดิการรักษาพยาบาล
********************************************************************************
DO CLEARSCREEN
PRIVATE Colspace,PreScr,Chprint,numpr,;
		lcDate, lcYY, lcMM, lcDD, lcShowAge, lcTime,;
		lcChangwat,;
		lcname, lcage, lcoccNname , lcClass, lcclasName, lcClinic, lccliName
		
SET ESCA ON
ON ESCAPE STORE .T. TO exist
EXTERNAL ARRAY tmonth

	lcDate		=	ce2be(DATE())
	lcYY = RIGHT(lcDate,2)
	lcMM = SUBSTR(lcDate,4,2)
	lcDD = SUBSTR(lcDate,1,2)
	lcShowAge	=	SPACE(11)

*-- Open database

*	INSURE = 'insur'+lcYY

	=opendbf(patientdir+"insure",'insure','hn')

	=opendbf(patientdir+"patient1","patient1","hn")
	=opendbf(patientdir+"contact","contact","hn")
	=opendbf(codedir+"hospcode","hospcode",'code')
	=opendbf(codedir+"address","address",'typecode')
	=OpenDBF(patientdir+'social','social',1)

SELECT insure
SET RELATION TO hn INTO patient1, hn INTO contact

DO Pres2col

SET ESCA OFF
ON ESCAPE STORE .T. TO exist
ON KEY LABEL Alt+R DO prs_menu
*REST SCREEN FROM PreScr
CLOSE DATA

********************
PROC PRES2COL
********************
PRIVATE mstart,mend,lnNum, lnCount
mrow=0
DO ClearScreen
STORE SPACE(9) TO mstart,mend
@ 10,25 SAY 'เริ่มพิมพ์ตั้งแต่เลขที่  ' GET mstart PICT '!99999999' && valid mstart>0
@ 12,25 SAY ' พิมพ์ไปจนถึงเลขที่      ' GET mend PICT '!99999999'  VALID ;
LEFT(mend,1) = LEFT(mstart,1) .AND. SUBS(mend,2) >= SUBS(mstart,2)
READ
IF LASTKEY() = 27
	RETU
ENDI
NoStart = TRIM(mstart)
NoEndg = TRIM(mend)
numlen = LEN(NoStart) - 1
prefix = LEFT(nostart,1)
mstart = VAL(SUBS(mstart,2))
mend = VAL(SUBS(mend,2))
DO ClearScreen

*--Check จำนวนพิมพ์บัตรทั้งหมด
lnCount = mend - mstart + 1
*--ถ้าเลขคี่ พิมพ์ซ้าย
	*-- คู่
	llLeft = .F.
	dimension lst(1,8)
	lst[1,1]=" "

	if m.mstart/2 # int(m.mstart/2) 
		llLeft = .T.
		FOR lnNum=1 to lnCount
			SELECT insure
			SET ORDER TO tag cid
			IF ! SEEK(prefix + STRZERO(mstart+lnNum-1,numlen))
			  	?? CHR(7)
				WAIT 'ไม่มีเลขที่ '+ prefix + STR(mstart+lnNum) WINDOW TIMEOUT 1
			ELSE
*				IF BETWEEN(SUBSTR(insure.inscl,1,1),8,9)
					SCATTER MEMVAR
					select contact
					seek LEFT(m.hn,7)
					scatter memvar field changwat
					= SEEK(insure.inscl,'social')
					SELECT address
						SEEK '1'+m.changwat+'0000'
						lcChangwat = address.name 
					SELECT patient1
					seek LEFT(m.hn,7)
						lcPerson = SUBST(patient1.person_id, 1,1)+'-'+;
						SUBST(patient1.person_id, 2,4)+'-'+ ;
						SUBST(patient1.person_id, 6,4)+'-'+ ;
						SUBST(patient1.person_id,10,2)+'-'+ ;
						SUBST(patient1.person_id,12,1) 
					SELECT hospcode
						seek m.hospmain
						lcMain = de_name(hospcode.name) 
						SEEK m.hospsub
						lcsub  = de_name(hospcode.name) 
					= SEEK(insure.inscl,'social')
					IF EMPTY(lst[alen(lst,1),1])
						lst[alen(lst,1),1]=TRIM(social.name)
						lst[alen(lst,1),2]=ALLTRIM(de_name(m.name))
						lst[alen(lst,1),3]=ce2cbe(m.datein) 
						lst[alen(lst,1),4]=ce2cbe(m.dateexp)
						lst[alen(lst,1),5]=ALLTRIM(m.lcmain)
						lst[alen(lst,1),6]=ALLTRIM(m.lcsub)
						lst[alen(lst,1),7]=m.lcPerson
						lst[alen(lst,1),8]=ALLTRIM(m.lcChangwat)
					ELSE
						dimension lst[alen(lst,1)+1,8]
						lst[alen(lst,1),1]=TRIM(social.name)
						lst[alen(lst,1),2]=ALLTRIM(de_name(m.name))
						lst[alen(lst,1),3]=ce2cbe(m.datein) 
						lst[alen(lst,1),4]=ce2cbe(m.dateexp)
						lst[alen(lst,1),5]=ALLTRIM(m.lcmain)
						lst[alen(lst,1),6]=ALLTRIM(m.lcsub)
						lst[alen(lst,1),7]=m.lcPerson
						lst[alen(lst,1),8]=ALLTRIM(m.lcChangwat)
					ENDIF
*				ENDIF	
			ENDIF
		ENDFOR
	else
		lst[1,1]=" "
		lst[1,2]=" "
		lst[1,3]=" " 
		lst[1,4]=" "
		lst[1,5]=" "
		lst[1,6]=" "
		lst[1,7]=" "
		lst[1,8]=" "
		FOR lnNum=1 to lnCount
			SELECT insure
			SET ORDER TO tag cid
			IF ! SEEK(prefix + STRZERO(mstart+lnNum-1,numlen))
			  	?? CHR(7)
				WAIT 'ไม่มีเลขที่ '+ prefix + STR(lnNum) WINDOW TIMEOUT 1
			ELSE
*				IF BETWEEN(SUBSTR(insure.inscl,1,1),8,9)
					SCATTER MEMVAR
					select contact
					seek LEFT(m.hn,7)
						scatter memvar field changwat
					SELECT address
						SEEK '1'+m.changwat+'0000'
						lcChangwat = address.name 
					SELECT patient1
					seek LEFT(m.hn,7)
						lcPerson = SUBST(patient1.person_id, 1,1)+'-'+;
						SUBST(patient1.person_id, 2,4)+'-'+ ;
						SUBST(patient1.person_id, 6,4)+'-'+ ;
						SUBST(patient1.person_id,10,2)+'-'+ ;
						SUBST(patient1.person_id,12,1) 
					SELECT hospcode
						seek m.hospmain
						lcMain = de_name(hospcode.name) 
						SEEK m.hospsub
						lcsub  = de_name(hospcode.name) 
					= SEEK(insure.inscl,'social')
						dimension lst[alen(lst,1)+1,8]
						lst[alen(lst,1),1]=social.name
						lst[alen(lst,1),2]=ALLTRIM(de_name(m.name))
						lst[alen(lst,1),3]=ce2cbe(m.datein) 
						lst[alen(lst,1),4]=ce2cbe(m.dateexp)
						lst[alen(lst,1),5]=ALLTRIM(m.lcmain)
						lst[alen(lst,1),6]=ALLTRIM(m.lcsub)
						lst[alen(lst,1),7]=m.lcPerson
						lst[alen(lst,1),8]=ALLTRIM(m.lcChangwat)
*				ENDIF
			ENDIF
		ENDFOR
	endif

*-- Add for correct invalid subscribe bound
IF  alen(lst,1)/2 # INT(alen(lst,1)/2) 
	dimension lst[alen(lst,1)+1,8]
		lst[alen(lst,1),1]=" "
		lst[alen(lst,1),2]=" "
		lst[alen(lst,1),3]=" " 
		lst[alen(lst,1),4]=" "
		lst[alen(lst,1),5]=" "
		lst[alen(lst,1),6]=" "
		lst[alen(lst,1),7]=" "
		lst[alen(lst,1),8]=" "
		lncount = lncount + 1
ENDIF
SET CONSOLE OFF
set print on
*set device to printer

	?? CHR(27)+'3'+CHR(20) 		&& กำหนดระยะระหว่างบรรทัด
*	@ 0,0 SAY CHR(27)+'3'+CHR(40) 		&& กำหนดระยะระหว่างบรรทัด
    ?? CHR(27)+CHR(67)+CHR(0)+CHR(11)			&& Set page length 11 inches
	?? CHR(27)+CHR(103)						&&   15 cpi	
	?? CHR(27)+'x'							&& Quality mode

*			drow=0
			drow=1
			dcol=55
			j = 1
			i = 1
	FOR j=1 to m.lnCount step 2
*	?? CHR(27)+'3'+CHR(2) 		&& กำหนดระยะระหว่างบรรทัด
	? CHR(27)+'3'+CHR(35) 		&& กำหนดระยะระหว่างบรรทัด

		DO printprs with j,drow,dcol
*			drow=drow+6
			FOR mo = 1 TO 4
				?
			NEXT
	? CHR(27)+'3'+CHR(20) 		&& กำหนดระยะระหว่างบรรทัด
			
			i = i+1
*		IF i>4	  
*			eject
*			drow	= 1
*			i 		= 1
*		ENDIF	
	ENDFOR		

eject
Set print off
SET CONS ON
*set device to screen
_device = 'SCREEN'
*********************
Proc Printprs
*********************
Parameter _number, prow,pcol
private i

i=_number


*		prow=prow+2
?

? lst[i,1] AT 37
?? lst[i+1,1] AT 37+pcol 
*	@ prow,0 SAY "จังหวัด" 
*	@ prow,0+pcol SAY "จังหวัด" 
? lst[i,8] AT 15
?? lst[i+1,8] AT 15+pcol 
		prow=prow+1

*	@ prow,0 SAY "ชื่อ" 
*	@ prow,0+pcol SAY "ชื่อ" 
? lst[i,2] AT 15
?? lst[i+1,2] AT 15+pcol
		prow=prow+1

*	@ prow,0 SAY "เลขประจำตัวประชาชน" 
*	@ prow,0+pcol SAY "เลขประจำตัวประชาชน" 
? lst[i,7] AT 26
?? lst[i+1,7] AT 26+pcol 
		prow=prow+1

*	@ prow,25 SAY "1."
*	@ prow,25+pcol SAY "1."
? lst[i,5] AT 26
?? lst[i+1,5] AT 26+pcol 
		prow=prow+1
*	@ prow,25 SAY "2."
*	@ prow,25+pcol SAY "2."
? lst[i,6] AT 26
?? lst[i+1,6] AT 26+pcol
		prow=prow+1
? lst[i,3] AT 15
?? lst[i,4] AT 38
?? lst[i+1,3] AT 15+pcol
?? lst[i+1,4] AT 38+pcol
?

*	@ prow+ 1,pcol SAY ' '

