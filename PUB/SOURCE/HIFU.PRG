* HIFU  Follow Up
******************************************************************
*                ������ʴ�˹�Ҩ��繻�ԷԹ 6 ��͹             *
*                ����Ѻ���͡�ѹ�Ѵ ���� parameter 2 ��� ���     *
*       NOWDATE ����ѹ���Ѩ�غѹ                                *
*       SELDATE ��͵���÷����纤���ѹ�Ѵ������͡              *
*				 		�Ѳ����                                 *
*       ���ᾷ����ԭ                                            *
*       ���ᾷ�����ѵ�� ��������侺���� �繼��Ѵ�ŧ           *
******************************************************************
PARA NOWDATE, SELDATE
PRIV MM, YY
PUSH KEY CLEA
DEFI WIND WFU FROM  0, 0 TO 24,79 NONE
ACTI WIND WFU
SET CURS OFF
seldate = IIF(seldate <= nowdate, nowdate + 1, seldate)
bd = CHR(148) + CHR(146) + CHR(183) + CHR(129) + CHR(139) + CHR(146) + CHR(142) + CHR(129)
YY = YEAR(NOWDATE)
MM = MONTH(NOWDATE)
MM1 = IIF(MM > 11, MM - 11, MM + 1)   && present month + 1
MM2 = IIF(MM > 10, MM - 10, MM + 2)   && present month + 2
MM3 = IIF(MM >  9, MM -  9, MM + 3)   && present month + 3
MM4 = IIF(MM >  8, MM -  8, MM + 4)   && present month + 4
MM5 = IIF(MM >  7, MM -  7, MM + 5)   && present month + 5
MM6 = IIF(MM >  6, MM -  6, MM + 6)   && present month + 6 = OUT FRAME MONTH
YY1 = IIF(MM > 11, YY + 1, YY)        && THE YEAR OF PRESENT MONTH + 1
YY2 = IIF(MM > 10, YY + 1, YY)        && THE YEAR OF PRESENT MONTH + 2
YY3 = IIF(MM >  9, YY + 1, YY)        && THE YEAR OF PRESENT MONTH + 3
YY4 = IIF(MM >  8, YY + 1, YY)        && THE YEAR OF PRESENT MONTH + 4
YY5 = IIF(MM >  7, YY + 1, YY)        && THE YEAR OF PRESENT MONTH + 5
YY6 = IIF(MM >  6, YY + 1, YY)        && THE YEAR OF PRESENT MONTH + 6
@  1, 2, 3,38 BOX BA
@  3, 2,10,38 BOX bb
@ 10, 2,17,38 BOX bb
@ 17, 2,24,38 BOX bb
@  1,42, 3,78 BOX BA
@  3,42,10,78 BOX bb
@ 10,42,17,78 BOX bb
@ 17,42,24,78 BOX bb
@  2, 4 SAY "SUN  MON  TUE  WED  THU  FRI  SAT"
@  2,44 SAY "SUN  MON  TUE  WED  THU  FRI  SAT"
= SAYMY(NOWDATE, 1, 4)
= SAYMY(CTOD( '1'+'/'+STR(MM1) + '/' + STR(YY1) ),10, 4)
= SAYMY(CTOD( '1'+'/'+STR(MM2) + '/' + STR(YY2) ),17, 4)
= SAYMY(CTOD( '1'+'/'+STR(MM3) + '/' + STR(YY3) ), 1,44)
= SAYMY(CTOD( '1'+'/'+STR(MM4) + '/' + STR(YY4) ),10,44)
= SAYMY(CTOD( '1'+'/'+STR(MM5) + '/' + STR(YY5) ),17,44)

RUNDATE = CTOD('1'+SUBS(DTOC(NOWDATE),3))    && RUNning DATE
OUTDATE = CTOD( '1'+'/'+STR(MM6) + '/' + STR(YY6) )    && OUT frame DATE
OSELE = SELE()
***************
SELE HOLIDAY          && COPY �ѹ��ش㹪�ǧ 6 ��͹��� ARRAY
***************
COPY TO ARRA HLDDATE FOR BETW(DATE,NOWDATE,OUTDATE)
IF TYPE('hlddate') # 'D'
	DIME hlddate(1,2)
	hlddate[1,1] = {01/01/1700}
	hlddate[1,2] = '             '
ENDI
DO AddRoutHld WITH nowdate,hlddate
SELE (OSELE)

DO WHIL RUNDATE < OUTDATE          && SHOW ALL 6 MONTHS DATE
   DO CASE
   CASE DOW(RUNDATE) = 1                && �ѹ�ҷԵ��
      = SAYDAY(MM,RUNDATE,7)
   CASE DOW(RUNDATE) = 7                && �ѹ�����
      = SAYDAY(MM,RUNDATE,7)
   CASE ASCAN("HLDDATE",RUNDATE) # 0    && CASE  �ó����ѹ��ش
      = SAYDAY(MM,RUNDATE,7)              && SAY ������
   OTHE
      = SAYDAY(MM,RUNDATE,1)            && �ѹ������
   ENDC
   RUNDATE = RUNDATE + 1
ENDD

= SAYDAY(MM,SELDATE,5)           && ��¹�ѹ�Ѵ ���
   = SAYDAY(MM,NOWDATE,6)          && ��¹�ѹ�Ѩ�غѹ
	@  0,12 SAY LTRIM(STR(SELDATE - NOWDATE)) + ' �ѹ ' + ;
	IIF( MOD((SELDATE - NOWDATE),7) = 0, '(' + TRAN((SELDATE - NOWDATE)/7,'99') + ' �ѻ����)', ;
	SPACE(10)) + SPACE(2)
   = SAYDAYFU(SELDATE)               && ��¹�ӹǹ���Ѵ��ѹ���
	holidaypos = ASCAN("HLDDATE",SELDATE)     && CASE  �ó����ѹ��ش
	IF holidaypos > 0
		?? CHR(7) +  CHR(7)
		@ 0,35 SAY LEFT(hlddate[holidaypos + 1],40) COLO SCHE 7
	ELSE
		@ 0,35
	ENDI
DO WHIL .T.
   IK = INKE(0)
   DO CASE
   CASE DOW(SELDATE) = 1                && �ѹ�ҷԵ��
      = SAYDAY(MM,SELDATE,7)
   CASE DOW(SELDATE) = 7                && �ѹ�����
      = SAYDAY(MM,SELDATE,7)
   CASE ASCAN("HLDDATE",SELDATE) # 0    && CASE  �ó����ѹ��ش
      = SAYDAY(MM,SELDATE,7)              && SAY ������
   OTHE
      = SAYDAY(MM,SELDATE,1)            && �ѹ������
   ENDC
   DO CASE
   CASE IK = 18   && PGUP
      SELDATE = SELDATE - 35       && PAGE UP ��Ͷ��� 35 �ѹ
      IF SELDATE < NOWDATE + 1     && �ѹ�Ѵ��ͧ���ѹ�Ѵ� ��͹��ѧ�����
         ?? CHR(7)
         SELDATE = SELDATE + 35
      ENDI
   CASE IK =  3   && PGDN
      SELDATE = SELDATE + 35       && PAGE DOWN ��͹Ѻ��ա 35 �ѹ
      IF SELDATE >= OUTDATE
         ?? CHR(7)
         SELDATE = SELDATE - 35
      ENDI
   CASE IK =  5   && UP 5
      SELDATE = SELDATE - 7        && �١�� UP ��Ͷ��� 7 �ѹ
      IF SELDATE < NOWDATE + 1     && �ѹ�Ѵ��ͧ���ѹ�Ѵ� ��͹��ѧ�����
         ?? CHR(7)
         SELDATE = SELDATE + 7
      ENDI
   CASE IK = 24   && DOWN 24
      SELDATE = SELDATE + 7        && �١�� DOWN ��͹Ѻ� 7 �ѹ
      IF SELDATE >= OUTDATE
         ?? CHR(7)
         SELDATE = SELDATE - 7
      ENDI
   CASE IK = 19   && LEFT 19
      SELDATE = SELDATE - 1        && �١�� LEFT ��͹Ѻ���� 1 �ѹ
      IF SELDATE < NOWDATE + 1
         ?? CHR(7)
         SELDATE = SELDATE + 1     && �ѹ�Ѵ��ͧ���ѹ�Ѵ� ��͹��ѧ�����
      ENDI
   CASE IK =  4   && RIGHT 4
      SELDATE = SELDATE + 1        && �١�� RIGHT ��͹Ѻ� 1 �ѹ
      IF SELDATE >= OUTDATE
         ?? CHR(7)
         SELDATE = SELDATE - 1
      ENDI
   CASE IK = 13   && ENTER
      IF SELDATE = NOWDATE
         ?? CHR(7)
         LOOP
      ENDI
      MFUDATE = CE2CBE(SELDATE)
      EXIT
   CASE IK = 27   && ESCAPE
      MFUDATE = '  /  /  '
      EXIT
   ENDC
   = SAYDAY(MM,SELDATE,5)
	@  0,12 SAY LTRIM(STR(SELDATE - NOWDATE)) + ' �ѹ ' + ;
	IIF( MOD((SELDATE - NOWDATE),7) = 0, '(' + TRAN((SELDATE - NOWDATE)/7,'99') + ' �ѻ����)', ;
	SPACE(10)) + SPACE(2)
   = SAYDAYFU(SELDATE)               && ��¹�ӹǹ���Ѵ��ѹ���
	holidaypos = ASCAN("HLDDATE",SELDATE)     && CASE  �ó����ѹ��ش
	IF holidaypos > 0
		?? CHR(7) +  CHR(7)
		@ 0,35 SAY LEFT(hlddate[holidaypos + 1],40) COLO SCHE 7
	ELSE
		@ 0,35
	ENDI
ENDD
SET CURS ON
DEAC WIND WFU
* SHOW GET MFUDATE COLO SCHE 15
POP KEY
RETU

PROC SAYDAY
PARA MM, PDATE, SCHE
PRIV RW, CL
DOW_1D = DOW(CTOD('1'+SUBS(DTOC(PDATE),3))) && �ѹ�á�ͧ��͹ ���� COL �˹㹻�ԷԹ
DD  = DAY(PDATE)
TRW = INT( (DD + (DOW_1D - 1) - 1 ) / 7 )   && Table RoW 㹻�ԷԹ
TCL = MOD( DD + (DOW_1D - 1), 7 )           && Table CoLumn 㹻�ԷԹ
TCL = IIF(TCL = 0, 7, TCL)
DO CASE
CASE MONT(PDATE) = MM
   RW = TRW + 4                          && ROW ��˹�Ҩ�
   CL = 4 + 5 * (TCL - 1)                && COL ��˹�Ҩ�
CASE MONT(PDATE) = MM1
   RW = TRW + 4 + 7                      && ROW ��˹�Ҩ�
   CL = 4 + 5 * (TCL - 1)                && COL ��˹�Ҩ�
CASE MONT(PDATE) = MM2
   RW = TRW + 4 + 14                     && ROW ��˹�Ҩ�
   CL = 4 + 5 * (TCL - 1)                && COL ��˹�Ҩ�
CASE MONT(PDATE) = MM3
   RW = TRW + 4                          && ROW ��˹�Ҩ�
   CL = 44 + 5 * (TCL - 1)               && COL ��˹�Ҩ�
CASE MONT(PDATE) = MM4
   RW = TRW + 4 + 7                      && ROW ��˹�Ҩ�
   CL = 44 + 5 * (TCL - 1)               && COL ��˹�Ҩ�
CASE MONT(PDATE) = MM5
   RW = TRW + 4 + 14                     && ROW ��˹�Ҩ�
   CL = 44 + 5 * (TCL - 1)               && COL ��˹�Ҩ�
ENDC
@ RW,CL SAY ' ' + RIGH(' ' + LTRI(STR(DD)),2) + ' ' COLO SCHE SCHE
RETU

PROC SAYDAYFU
PARA PDATE
PRIV PDATE
IF USED("FUNUM")
   IF SEEK(PDATE,"FUNUM")
      @  0,43 SAY '�Ѵ���� ' + RIGH(' ' + LTRI(STR(NUM)),2) + ' ��' COLO SCHE 12
   ELSE
      @  0,43 SAY '�Ѵ���� ??' + ' ��'                              COLO SCHE 12
   ENDI
ENDI
RETU

PROC SAYMY
PARA SAYDATE, ROW, COL
PRIV          ROW, COL
TSD = CE2CBE(SAYDATE)
AT2 = AT(' ', TSD, 1)
AT3 = AT(' ', TSD, 2)
@ ROW,COL + 9 SAY ' ' + SUBS(TSD, AT2 + 1, AT3 - AT2) + ' ' + SUBS(TSD, AT3 + 1) + ' ' COLO SCHE 4
RETU

