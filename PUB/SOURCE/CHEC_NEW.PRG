********************************************************************************
* เป็นโมดูลที่ใช้ตรวจสอบว่าชื่อนี้เป็นชื่อใหม่หรือไม่ โดย                      *
* 1. ตรวจสอบว่าใส่เป็นนามสกุลหรือไม่โดยดูว่าอักขระแรกเป็นช่องว่างหรือไม่ ถ้า   *
*    เป็นนามสกุลจะดูว่าสี่ตัวแรกมีไหม ถ้าไม่มีเป็นรายใหม่                      *
* 2. ถ้าเป็นชื่อจะค้นหาว่าชื่อนี้มีหรือไม่ ถ้าไม่มีจะหาโดยเทียบชื่อ 3 ตัวแรก   *
*    รวมกับนามสกุล 3 ตัวแรกว่ามีหรือไม่ ถ้าไม่มีแสดงว่าเป็นรายใหม่             *
* 3. ถ้าเป็นรายเก่าจาก 2 ข้อแรกจะแสดงชื่อ นามสกุล ชื่อมารดา                    *
*    และวันเดือนปีเกิด โดยอาศัย Procedure LISTNAME                             *
********************************************************************************
PARA _name,_new
PRIVATE mseek
SELE patient1
_new=.F.
IF LEFT(_name,1)=' '
   SET ORDER TO 3
   mseek=TRIM(SUBS(_name,2,4))
   IF SEEK(mseek)
      DO Listname WITH _new
   ELSE
      _new=.T.
   ENDI
ELSE
   SET ORDER TO 2
   mseek=TRIM(_name)
   IF ! SEEK(mseek)
      SET ORDER TO 4
      mseek=TRIM(LEFT(_name,4)+SUBS(_name,AT(" ",_name)+1,4))
      IF SEEK(mseek)
         DO Listname WITH _new
      ELSE
         _new=.T.
      ENDI
   ELSE
      DO Listname WITH _new
   ENDI
ENDI
IF _new
	IF FILE(patientdir + 'hipbuff.dbf')
		IF ! USED('hipbuff')
			USE (patientdir+'hipbuff') ORDER TAG person_id IN 0
		ENDI
		SELE hipbuff
		SET ORDER TO TAG name
		ms = AT(',',_name)
		mseek = IIF(ms = 0 ,TRIM(_name), LEFT(_name,ms-1) )
		IF SEEK(mseek,'hipbuff')
			DO showhip.spr
		ENDI
	ENDI
ENDI