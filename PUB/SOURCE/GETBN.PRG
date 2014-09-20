* GETBN  GET Big Num
PARA NUM2SAY, MAXNUM, WRD, RW, CL
PUSH KEY CLEA
ACTI WIND WNUM
CLEA
= CT(WRD,78,0,10)
NUM = 0
DO BN WITH NUM2SAY, 2
ACTI WIND WO
@ RW,CL SAY TRAN(NUM2SAY,'9,999,999') COLO N/W
CLEA TYPE
DO WHIL .T.
   IK = INKE(0)
   DO CASE
   CASE IK = 27  && ESC
      NUM2SAY = 0
   CASE IK =  7 OR IK = 127  && DEL OR BSPACE
      NUM2SAY = INT(NUM2SAY / 10)
   CASE IK = 24  && DOWN
      EXIT
   CASE IK = 13  && ENTER
      EXIT
   CASE IK = 48  && 0
      NUM = 0
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 49  && 1
      NUM = 1
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 50  && 2
      NUM = 2
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 51  && 3
      NUM = 3
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 52  && 4
      NUM = 4
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 53  && 5
      NUM = 5
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 54  && 6
      NUM = 6
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 55  && 7
      NUM = 7
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 56  && 8
      NUM = 8
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 57  && 9
      NUM = 9
      NUM2SAY = NUM2SAY * 10 + NUM
   CASE IK = 22  && INS
      DO GETCHGA
      EXIT
   OTHE
      ?? CHR(7)
      LOOP
   ENDC
   IF NUM2SAY > MAXNUM              && ถ้าเกิน LIMIT
      ?? CHR(7)
      NUM2SAY = INT(NUM2SAY / 10)     && ถอยกลับมาเป็น ตัวเดิม
   ENDI
   ACTI WIND WNUM
   DO BN WITH NUM2SAY, 2
   ACTI WIND WO
   @ RW,CL SAY TRAN(NUM2SAY,'9,999,999') COLO N/W
ENDD
ACTI WIND WO
POP KEY
RETU (NUM2SAY)
