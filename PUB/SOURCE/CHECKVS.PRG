*:*********************************************************************
*:
*: Procedure file: \PUB\NEWHN.PRG
*:
*:         System: ----- Application
*:         Author: 
*:               : นายกัญช์         จันทร         โรงพยาบาลมหาราชนครศรีธรรมราช
*:               : นายสังสรรค์      สินบำรุง      โรงพยาบาลพระพุทธบาท สระบุรี
*:               : นางสาวรัตชนก     สวัสดิกุล     โรงพยาบาลสุราษฎร์ธานี
*:   	     Copyright (c) 2539, 
*:  Last modified: 14/04/2540     10:50
*:
*:  Procs & Fncts: FUNTION OPENDBF
*:
*:          Calls: none
*:
*:    Other Files: 
*:
*:*********************************************************************
*:	  PBH Modification
*:		1.APPEND appointed patient to file VSyymm ;
*:			and clear that record from appoint.dbf
*:			for control size of appoint.dbf
*:		2.APPEND unfinish visit older than today to file FailVSyy  
*:			for control size of VSyymm.dbf
*:
*:*********************************************************************

*************************************
** สร้างแฟ้มลำดับที่และแฟ้มข้อมูลการมาของผู้ป่วย
*************************************
private lcYY, lcMM, lcDD
	lcYY = RIGHT(CE2CBE(DATE()),2)
	lcMM = SUBSTR(DTOC(DATE()),4,2)
	lcDD = SUBSTR(DTOC(DATE()),1,2)

	DVISIT = OPDDIR+'visit'+lcYY
	DVS    = OPDDIR+'vs'+lcYY+lcMM
	DCN    = OPDDIR+'cn'+lcYY+lcMM+lcDD
	DCOME  = OPDDIR+'come'+lcYY+lcMM+lcDD
	DYear  = OPDDIR+'vs'+lcYY
	DFVS   = OPDDIR+'FailVs'+lcYY
	INSURE = PATIENTDIR+'insur'+lcYY

**--Yearly record for insurer identification .

**--Yearly record for visiting  number by date.
=opendbf(Dvisit,'Dvisit')
**--Monthly transaction record for each OPD by visit number.
=opendbf(Dvs,'Dvs')

**--Yearly locfile record for each OPD by visit number.
=opendbf(DYear,'DYear')

**--Yearly locfile record for unfinish visit for each OPD by visit number.
=opendbf(DFvs,'DFvs')

**-- Daily record for coming patient for each DOCTOR.
=opendbf(Dcome,'Dcome')
**-- Daily services by item for each patient in that date.
=opendbf(Dcn,'Dcn')

**---------------------------- Initialize first record for that day

SELECT Dvs
SET ORDER TO TAG DATE

IF ! SEEK(DATE())
	*-- Clear old unfinish record from Dvs to DFvs
	GO TOP
	SCAN FOR Dvs.DATE< DATE()
		IF EOF()
			EXIT
		ENDIF
		IF ! EMPTY(Dvs.DATE) 
			SCATTER MEMVAR
			INSERT INTO DFvs FROM MEMVAR
			SCATTER MEMVAR BLANK
			GATHER MEMVAR
		ENDIF
	ENDSCAN

	nvs_id=0
*	DO Queappo   && กรณีต้องการให้คิวคนไข้นัดก่อนโดยอัตโนมัติ
	* สร้างrecordแรก
	SELECT Dvisit
	SET ORDER TO TAG date
	SEEK DATE()
	IF !found()
    	go top
	    if !empty(date) .or. bof()
    	    appe blank
	    endif
    	repl date with DATE()
	    repl nvs_id with m.nvs_id
	ENDIF
	
ENDIF

PROC Queappo
	*-- ให้ลำดับคิวแรกแก่ผู้ป่วยนัด
	SELECT 0
	USE opddir+'appoint'

	SET FILTER TO date=DATE()
	GO TOP

	DO WHILE .NOT. EOF()
		IF EOF()
			EXIT
		ENDIF
		SCATTER MEMVAR
			nvs_id= nvs_id+1
			VS_ID = STRZERO(nvs_id,4)
			T_IN = SUBST(TIME(),1,2)+SUBST(TIME(),4,2)
			DATE = DATE()
			USER = 'APPOINT'
			PT_CLASS = patient1.Class
			TRFMODE = '1'
			PRIORITY = 'R'			
		SELECT Dvs
		GO TOP
		IF ! EMPTY(Dvs.DATE) .OR. BOF()
			APPEND BLANK
		ENDIF
		GATHER MEMVAR

		*--Delete record in appoint.dbf by append empty HN field.
		SELECT appoint
		m.hn = SPACE(LEN(HN))			
		GATHER MEMVAR				
		SKIP
	ENDDO


	SET FILTER TO
	SELECT appoint
	USE

