EXTERNAL ARRAY PCOND3,COND3,CONDTYPE,PRQBE, OFFER ,PCOND1 ,PCOND2 ,CONDITION
#define numreport 8
DIME rp(numreport)
rp(1)='1. ทำรายงานประจำ'
rp(2)='2. ค้นหาตามเงื่อนไข'
rp[3] = '3. ค้นหา HN ตามเงื่อนไข'
rp[4] = '4. กำหนดค่า'
rp[5] = '5. ส่งข้อมูลตาม Standard Data Set  '
rp[6] = '6. หาผู้ป่วยตามสิทธิต่าง ๆ  '
rp[7] = '7. ตรวจสอบข้อมูล Standard Data Set  '
rp(numreport)='0. กลับรายการเดิม'
DEFINE WIND rp_menu FROM 4,5 TO 4+ALEN(rp)+3,44 SHAD TITLE 'รายงานผู้ป่วยใน' COLO gr+/bg
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
			@ 2,2 PROMPT '1. ใช้แฟ้มจำนวนผู้ป่วยในเป็นหลัก' MESS ;
			'ใช้แฟ้ม INyymm เป็นหลัก รับไว้หนึ่งครั้งมี 1 record'
			@ 3,2 PROMPT '2. ใช้แฟ้มการวินิจฉัยเป็นหลัก' MESS ;
			'ใช้แฟ้ม DIAGyymm เป็นหลัก รับไว้หนึ่งครั้งมีหลาย record'
			@ 4,2 PROMPT '3. ใช้แฟ้มการผ่าตัดเป็นหลัก' MESS ;
			'ใช้แฟ้ม DIAGyymm เป็นหลัก รับไว้หนึ่งครั้งมีหลาย record'
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
routine[1] = '1. รายงานส่งกระทรวง  '
routine[2] = '2. รายงาน 505  '
routine[3] = '3. รายงานอุบัติเหตุจราจร  '
routine[4] = '4. รายงานโรคที่พบบ่อย '
routine[5] = '5. รายงานแยกโรค  '
*routine[6] = '6. รายงานส่งสำนักงานประกันสุขภาพ'
routine[routrep] = '0. กลับรายการเดิม  '
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
installrp[1] = '1. กำหนดกลุ่มอายุ'
installrp[2] = '2. กำหนดกลุ่มโรค'
installrp[3] = '0. กลับรายการเดิม'
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
				reason = 'เปิดแฟ้มมากเกินไป ไม่สามารถทำได้'
			CASE FERROR() = 5
 				reason = 'ไม่สามารถอ่าน-เขียนได้'
 			CASE FERROR() = 8
 				reason = 'ความจำไม่เพียงพอ'
			CASE FERROR() = 29
				reason = 'ไม่มีที่ว่าง'
	    CASE FERROR() = 31
	    		reason = 'มีข้อผิดพลาดทั่ว ๆ ไป'
	 	ENDCASE
	_ret=.F.
ENDI
RETURN _ret

PROC INSTALLAGE
PUSH KEY
ON KEY LABEL F2 DO Saveage WITH '.age','age*'
ON KEY LABEL F3 DO Restoreage WITH '.age','age*'
DEFINE WIND installage FROM 3,15 TO 20,75 SHAD TITLE '  กำหนดกลุ่มอายุ  ';
FOOT '  [Esc]=เรียบร้อย  [F2]=เก็บข้อมูล  [F3]=เรียกข้อมูล  '
ACTI WIND installage
@ 0,0 SAY ' กลุ่มที่  ตั้งแต่อายุ  ถึงอายุ  ข้อความที่แสดง'
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
	DEFINE WIND choosefile FROM  3,4 TO 13,18 SHAD TITLE '  เลือก  '
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
@ 1,3 SAY 'ต้องการเก็บค่าไว้ในแฟ้มชื่อ ' GET filename DEFA SPACE(8)
READ NOLOCK
IF FILE(filename+_ext)
	?? CHR(7)
	overwrite = 'N'
	@ 2,3 SAY 'มีแฟ้มชื่อ '+TRIM(filename)+' อยู่แล้ว'
	@ 3,3 SAY 'ต้องการเขียนทับหรือไม่ ' GET overwrite PICT '!'
	READ NOLOCK
ENDI
IF overwrite $ 'ัํY' .AND. ! EMPTY(filename)
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
	@ in+1,12 GET agemintype(in)  PICT '#' MESS '1 = ปี  2 = เดือน  3 = วัน ' VALID Checkat()
	@ in+1,14 GET agemin(in) PICT '##'
	@ in+1,24 GET agemaxtype(in) PICT '#' MESS '1 = ปี  2 = เดือน  3 = วัน ' VALID Checkat()
	@ in+1,26 GET agemax(in) PICT '##'
	@ in+1,34 GET agecoded(in)
NEXT
READ NOLOCK CYCLE

PROC INSTALLDIAG
PUSH KEY
ON KEY LABEL F2 DO Saveage WITH '.dx','diag*'
ON KEY LABEL F3 DO Restoreage WITH '.dx','diag*'
DEFINE WIND installage FROM 3,15 TO 20,75 SHAD TITLE '  กำหนดกลุ่มโรค  ';
FOOT '  [Esc]=เรียบร้อย  [F2]=เก็บข้อมูล  [F3]=เรียกข้อมูล  '
ACTI WIND installage
@ 0,0 SAY ' กลุ่มที่  ตั้งแต่รหัส  ถึงรหัส  ข้อความที่แสดง'
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
	WAIT WIND '1 = ปี  2 = เดือน  3 = วัน ' NOWA
	_CUROBJ=_CUROBJ
ENDI