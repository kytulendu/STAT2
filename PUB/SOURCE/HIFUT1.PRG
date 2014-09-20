* HIFUT1     FOLLOW UP IN WHICH CLINIC AND WHAT SERVICE
EXTE ARRA FU_SV, FU_SVN
@  0, 2 SAY 'หน่วยบริการ  ' COLO SCHE 13
@  1, 2 SAY 'หน่วยบริการ  ' COLO SCHE 13
@  2, 2 SAY 'หน่วยบริการ  ' COLO SCHE 13
@  3, 2 SAY 'หน่วยบริการ  ' COLO SCHE 13
@  4, 2 SAY 'หน่วยบริการ  ' COLO SCHE 13
@  0,15 GET FU_SV(1) WHEN LFU AND WFU() AND SHOWGET("FU_SV(1)",1) ;
                     PICT '9' ;
                     VALI VCLN(1,0,17) AND SHOWGET("FU_SV(1)",2) ;
                     COLO SCHE 15
@  0,37 GET FU_SVN(1) WHEN LFU AND (! EMPT(FU_SV(1))) AND FU_SV(1) $ '78' AND ;
                           SHOWGET("FU_SVN(1)",1) ;
                      PICT REPL('!',30) ;
                      VALI VFU_SVN(1) AND SHOWGET("FU_SVN(1)",2) ;
                      COLO SCHE 15
@  1,15 GET FU_SV(2) WHEN LFU AND (! EMPT(FU_SV(1))) AND SHOWGET("FU_SV(2)",1) ;
                     PICT '9' ;
                     VALI VCLN(2,1,17) AND SHOWGET("FU_SV(2)",2) ;
                     COLO SCHE 15
@  1,37 GET FU_SVN(2) WHEN LFU AND (! EMPT(FU_SV(2))) AND FU_SV(2) $ '78' AND ;
                           SHOWGET("FU_SVN(2)",1) ;
                      PICT REPL('!',30) ;
                      VALI VFU_SVN(2) AND SHOWGET("FU_SVN(2)",2) ;
                      COLO SCHE 15
@  2,15 GET FU_SV(3) WHEN LFU AND (! EMPT(FU_SV(2))) AND SHOWGET("FU_SV(3)",1) ;
                     PICT '9' ;
                     VALI VCLN(3,2,17) AND SHOWGET("FU_SV(3)",2) ;
                     COLO SCHE 15
@  2,37 GET FU_SVN(3) WHEN LFU AND (! EMPT(FU_SV(3))) AND FU_SV(3) $ '78' AND ;
                           SHOWGET("FU_SVN(3)",1) ;
                      PICT REPL('!',30) ;
                      VALI VFU_SVN(3) AND SHOWGET("FU_SVN(3)",2) ;
                      COLO SCHE 15
@  3,15 GET FU_SV(4) WHEN LFU AND (! EMPT(FU_SV(3))) AND SHOWGET("FU_SV(4)",1) ;
                     PICT '9' ;
                     VALI VCLN(4,3,17) AND SHOWGET("FU_SV(4)",2) ;
                     COLO SCHE 15
@  3,37 GET FU_SVN(4) WHEN LFU AND (! EMPT(FU_SV(4))) AND FU_SV(4) $ '78' AND ;
                           SHOWGET("FU_SVN(4)",1) ;
                      PICT REPL('!',30) ;
                      VALI VFU_SVN(4) AND SHOWGET("FU_SVN(4)",2) ;
                      COLO SCHE 15
@  4,15 GET FU_SV(5) WHEN LFU AND (! EMPT(FU_SV(4))) AND SHOWGET("FU_SV(5)",1) ;
                     PICT '9' ;
                     VALI VCLN(5,4,17) AND SHOWGET("FU_SV(5)",2) ;
                     COLO SCHE 15
@  4,37 GET FU_SVN(5) WHEN LFU AND (! EMPT(FU_SV(5))) AND FU_SV(5) $ '78' AND ;
                           SHOWGET("FU_SVN(5)",1) ;
                      PICT REPL('!',30) ;
                      VALI VFU_SVN(5) AND SHOWGET("FU_SVN(5)",2) ;
                      COLO SCHE 15
RETU
