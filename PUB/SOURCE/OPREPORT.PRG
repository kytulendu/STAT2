*........PROCEDURE UTILITY
PARA _util
DO CASE
   CASE _util='1'
     DO GetIndividual WITH _util
   CASE _util='2'
     DO GetIndividual WITH _util
   CASE _util='3'
     DO PhRQBE WITH 'o'
   CASE _util='4'
     DO PhRQBE WITH 'i'
   CASE _util='5'
     DO InstallAge
   CASE _util='6'
     DO InstallDiag
     CLEA
ENDCASE
RETURN

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
	READ
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
READ
IF FILE(filename+_ext)
	?? CHR(7)
	overwrite = 'N'
	@ 2,3 SAY 'มีแฟ้มชื่อ '+TRIM(filename)+' อยู่แล้ว'
	@ 3,3 SAY 'ต้องการเขียนทับหรือไม่ ' GET overwrite PICT '!'
	READ
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
READ CYCLE

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
READ CYCLE
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