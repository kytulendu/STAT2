********************************************************************************
*  โมดูลสำหรับแสดงข้อความช่วยเหลือเมื่อผู้ใช้กดคีย์ [F1]                       *
*  โดยดูจาก Field ที่ทำงานอยู่ในขณะนั้น                                        *
********************************************************************************
PARA _field,_callprg
PRIVATE PreScr,mchoice
?? chr(7)
*IF Shift_f2
*	WAIT '  [SHIFT+F2] = แก้ไขข้อมูลผู้ป่วย  ' WINDOW NOWAIT
*ENDI
IF fromhelp
	WAIT WIND 'คุณอยู่ในโปรแกรมช่วยเหลืออยู่แล้ว' NOWA
	RETU
ENDI
fromhelp = .T.
*SET COLO TO w+/b
DO CASE
	CASE _field='WARD_ADM' .OR. _field = 'PATIENT1(9)'
		IF _field = 'WARD_ADM'
			SELE WARD
			set filter to subst(clinic,3,1) <> ' '  .AND. ! EMPTY(name)
		ELSE
			SELE clinic
			SET FILT TO ! EMPTY(name)
		ENDI
		SET ORDER TO TAG name
		= THAIMODE()
		DO SearchHelp
		&_field=clinic
		SET FILT TO
		SET ORDER TO 1
		ACTI SCREE
		KEYB CHR(13)
   CASE _field='CONTACT1(6)' .OR. _field='CONTACT2(6)'
		= THAIMODE()
   		KEYB '  '
   CASE _field='CONTACT1(5)' .OR. _field='CONTACT2(5)'
		= THAIMODE()
      KEYB '00'
   CASE _field='CONTACT1(4)' .OR. _field='CONTACT2(4)'
		= THAIMODE()
      KEYB '00'
   CASE _field='PATIENT1(3)'
      IF RIGHT(_callprg,11)='EDITOLD.PRG'
         DO bottmess WITH ;
'ใส่ชื่อพร้อมนามสกุล  หรือเว้นหนึ่งช่องตามด้วยนามสกุล  หรือใส่เลขที่ผู้ป่วยนอก'
      ELSE
         DO bottmess WITH ;
         'ชื่อและนามสกุลแยกกันด้วย 1 ช่องว่าง ต่อด้วย,และคำนำหน้า หรือใส่เลขที่ผู้ป่วยนอก'
      ENDI
   CASE _field='CONTACT1(2)' 
      DO bottmess WITH 'ใส่บ้านเลขที่ ซอย และถนน'
   CASE _field='CONTACT1(3)' .OR. _field='CONTACT2(3)'
      DO bottmess WITH 'ใส่หมู่ที่เท่าไหร่'
   CASE _field='PATIENT1(6)'
      DO bottmess WITH 'ใส่ชื่อมารดาของผู้ป่วย'
   CASE _field='PATIENT1(10)'
      DO bottmess WITH 'ใส่ชื่อบิดาของผู้ป่วย'
   CASE _field='PATIENT2(2)'
      DO bottmess WITH 'ใส่ชื่อผู้ที่จะสามารถติดต่อได้  1=ชื่อแม่  2=ชื่อพ่อ'
   CASE _field='CONTACT2(2)'
      DO bottmess WITH 'ใส่ที่อยู่ของผู้ที่จะติดต่อได้  บ.ด.ก.=บ้านเดียวกัน'
   CASE _field='PATIENT2(7)'
      DO bottmess WITH 'ใส่รหัสทางไกลและหมายเลขโทรศัพท์ ถ้ามี'
   CASE _field='MBIRTHDAY'
      DO bottmess WITH 'ใส่วันเดือนปีเกิด ให้ใช้ปีพุทธศักราช'
   CASE _field='MAGE'
      DO bottmess WITH 'ใส่อายุเป็น ปี หรือ เดือน/12 หรือ วัน/365'
	CASE _field = 'RECEIPT'
		SELE user
		SET ORDER TO TAG fullname
		DO POPUP WITH 10,40,12,'user','fullname'
		IF ! EOF()
			&_field = name
		ENDI
		SHOW GETS
		KEYB CHR(13)
   CASE _field $ 'HOSPMAIN,HOSPSUB,HOSP_CODE,PLACE'
   		nowwindow = WONTOP()
   		IF ! EMPTY(nowwindow)
   			SAVE SCREE TO prewin
   			DEAC WIND (nowwindow)
   		ENDI
		SELE hospcode
		SET ORDER TO TAG name
		DO POPUP WITH 10,40,12,'hospcode','name'
		IF ! EOF()
			&_field = off_id
		ENDI
		IF ! EMPTY(nowwindow)
			ACTI WIND (nowwindow)
			REST SCREE FROM prewin
		ENDI
		SHOW GETS
   		KEYB CHR(13)
   OTHER
      SAVE SCREEN TO PreScr
      DO CASE
         CASE _field='PATIENT1(2)'
            @ 9,20 CLEA TO 14,50
            @ 9,20 TO 14,50
            @ 11,33 PROMPT '1 = ชาย'
            @ 12,33 PROMPT '2 = หญิง'
            MENU TO mchoice
            KEYB STR(mchoice,1)
         CASE _field='PATIENT1(5)'
            @ 9,20 CLEA TO 14,50
            @ 9,20 TO 14,50
            @ 11,28 PROMPT '1 = เชื่อถือได้แน่'
            @ 12,28 PROMPT '2 = ไม่แน่ใจ'
            MENU TO mchoice
            KEYB STR(mchoice,1)
         CASE _field='PATIENT2(3)'
            @ 8,20 CLEA TO 17,50
            @ 8,20 TO 17,50
            @ 10,32 PROMPT '1 = โสด'
            @ 11,32 PROMPT '2 = สมรส'
            @ 12,32 PROMPT '3 = หม้าย'
            @ 13,32 PROMPT '4 = หย่า'
            @ 14,32 PROMPT '5 = แยก'
            @ 15,32 PROMPT '6 = สมณะ'
            MENU TO mchoice
            KEYB STR(mchoice,1)
         CASE _FIELD $ 'PATIENT2(4),PATIENT2(6),PATIENT2(5),PATIENT1(8)'
			= THAIMODE()
			DO SearchHelp
			_m=field(1)
			SET ORDER TO 1
			ACTI SCREE
			KEYB &_m
      ENDC
      REST SCREE FROM PreScr
ENDC
fromhelp = .F.
*SET COLO TO bg+/b