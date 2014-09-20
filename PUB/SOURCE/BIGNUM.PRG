* PROC BIGNUM
PARA NUM,NROW
@ NROW, 0 CLEA TO NROW + 5,79
SCHM = 3
SNUM = LTRIM(TRAN(NUM,'99,999,999.99'))
LENSNUM = LEN(SNUM)
NCOL = 77
FOR NUB = 1 TO LENSNUM
   SUBSNUM = SUBS(SNUM,LENSNUM - NUB + 1,1)
   DO CASE
   CASE SUBSNUM = '0'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 1 SAY '     ' COLO SCHE SCHM
   CASE SUBSNUM = '1'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 3 SAY   '  ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 2 SAY  '   ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 3 SAY   '  ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 3 SAY   '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 2 SAY  '    ' COLO SCHE SCHM
   CASE SUBSNUM = '2'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 1 SAY '     ' COLO SCHE SCHM
   CASE SUBSNUM = '3'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 1 SAY '     ' COLO SCHE SCHM
   CASE SUBSNUM = '4'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 0,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 1 SAY '      ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 4 SAY    '  ' COLO SCHE SCHM
   CASE SUBSNUM = '5'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 1 SAY '     ' COLO SCHE SCHM
   CASE SUBSNUM = '6'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 1 SAY '     ' COLO SCHE SCHM
   CASE SUBSNUM = '7'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 4 SAY    '  ' COLO SCHE SCHM
   CASE SUBSNUM = '8'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 4 SAY '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 4 SAY '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 1 SAY '     ' COLO SCHE SCHM
   CASE SUBSNUM = '9'
      NCOL = NCOL - 7
      @ NROW + 0,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 1 SAY '  ' COLO SCHE SCHM
      @ NROW + 1,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 2,NCOL + 1 SAY '     ' COLO SCHE SCHM
      @ NROW + 3,NCOL + 4 SAY    '  ' COLO SCHE SCHM
      @ NROW + 4,NCOL + 1 SAY '     ' COLO SCHE SCHM
   CASE SUBSNUM = '.'
      NCOL = NCOL - 2
      @ NROW + 4,NCOL     SAY '  ' COLO SCHE SCHM
   CASE SUBSNUM = ','
      NCOL = NCOL - 2
      @ NROW + 4,NCOL     SAY '  ' COLO SCHE SCHM
      @ NROW + 5,NCOL + 1 SAY  ' ' COLO SCHE SCHM
   ENDC
NEXT
RETU
