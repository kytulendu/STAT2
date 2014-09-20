PRIVATE numfile,mstart,mfinish,choice,err_mess,wait_mess
IF ! GetPass('243800')
	=Alarm1()
	WAIT WINDOW '  คุณไม่มีสิทธิที่จะเบิกแฟ้มได้  ' timeout 1
	RETU
ENDI	
err_mess='ยกเลิกการเบิกแฟ้มตามที่ต้องการ'
wait_mess='กดปุ่มอะไรก็ได้เพื่อทำงานต่อ'
@ 3,0 CLEA TO 20,79
DO title WITH 'เบิกแฟ้มไปห้องฉุกเฉิน'
@ 22,0 CLEA
numfile=1
@ 10,30 SAY 'จำนวนแฟ้มที่จะเบิกไปไว้  ' GET numfile PICT '999' COLO gr+/b
READ NOLOCK
IF numfile>0
   @ 23,25 PROMPT 'Y = ถูกต้อง'
   @ 23,50 PROMPT 'N = ไม่ถูกต้อง'
   choice=2
   MENU TO choice
   @ 23,0
   IF choice=1
   		SELE 0
 	   dbfuse = patientdir+'er_hn'
 	   USE  (patientdir+'er_hn')
 	 dbfuse = ''
 	   mkey=0
 	  IF start2>0
 	  	?? CHR(7)
 	  	WAIT 'ยังมีแฟ้มเหลือที่ห้องฉุกเฉินอีกมาก ไม่ต้องเบิกอีก' WIND TIME 10
 	  	USE
 	  	RETU TO MASTER
 	  ENDI
      SELE hncount
 	  mkey=0
 	  DO WHILE ! FLOCK() .AND. mkey<>27
 	  	mkey=INKEY()
 	  ENDD
      IF ! FLOCK()
      	WAIT 'ไม่สามารถ Lock แฟ้ม HNCOUNT ได้' WIND TIME 10
      	USE
      	RETU TO MASTER
 	  ENDI
      m.start2=lasthn+1
      m.end2=lasthn+numfile
      REPL lasthn WITH lasthn+numfile
      FLUSH
      UNLOCK
      @ 16,30 SAY 'เริ่มเบิกจากแฟ้มหมายเลข '+STRZERO(m.start2,7) COLO r+/b
      @ 18,30 SAY '    สิ้นสุดที่แฟ้มหมายเลข '+STRZERO(m.end2,7) COLO r+/b
      SELE er_hn
		GATHER MEMV
		FLUSH
      UNLOCK
      USE
   ELSE
      _col=Center(err_mess)
      ?? CHR(7)
      @ 22,_col SAY err_mess COLO gr+/b
   ENDI
   _col=Center(wait_mess)
   @ 23,_col SAY wait_mess COLO gr+/b
   mkey=INKEY(0)
ENDI
