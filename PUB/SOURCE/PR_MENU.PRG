********************************************************************************
*  ���������Ѻ�������������͡��Ҩо����ѵü��������;����㺹Ѵ              *
********************************************************************************

PRIVATE Colspace,PreScr
SET ESCA ON
ON ESCAPE STORE .T. TO exist
DIME PrintMenu(5),PrintMess(5)
PrintMenu(1)='N=����ء��'
PrintMenu(2)='E=����˹�觤�'
PrintMenu(3)='O=���������'
PrintMenu(4)='S=Summary'
PrintMess(1)='�����ѵü����¹͡����ء��'
PrintMess(2)='�����ѵü����¹͡������Ф�'
PrintMess(3)='�����ѵü����¹͡���'
PrintMess(4)='��������� Summary (ç.501 ç.502 ç.503)'
NumPr=4              && �ӹǹ��¡����ѡ
ColSpace=78/NumPr    && ������ҧ�����ҧ������¡��
ChPrint=1               && ��¡�÷�����͡
@ 22,0 CLEA
SAVE SCREEN TO PreScr
DO WHIL ChPrint>0
   DO title WITH '��¡�þ����'
	@ 2,0 SAY REPL('-',80)
   xx=1
   DO WHIL xx<=NumPr
      @ 22,1+ColSpace*(xx-1) PROMPT PrintMenu(xx) MESSAGE PrintMess(xx)
      xx=xx+1
   ENDD
   = ENGMODE()
   MENU TO ChPrint
   @ 22,0
   DO CASE
      CASE ChPrint=0
         RETU
      CASE ChPrint=1
         DO Pr_card WITH .T.
      CASE ChPrint=2
         DO Pr_card WITH .F.
      CASE ChPrint=3
         DO PrOld
      CASE ChPrint=4
         DO PrSumary
   ENDC
   DO MainScr
ENDD
SET ESCA OFF
ON ESCAPE STORE .T. TO exist
REST SCREEN FROM PreScr

PROC PR_CARD
PARA PrintAll
PRIVATE printkey,retrykey,mkey
@ 22,0 CLEA
@ 3,0 CLEA TO 20,79
printkey=1
exist=.F.
DO WHIL ! PRINTSTATUS() .AND. ! exist
   ?? CHR(7)
   WAIT '����ͧ������ѧ�������  �ô��Ǩ�ͺ������º����' WINDOW
ENDD
IF exist
	RETU
ENDI
@ 3,0 CLEA TO 20,79
SELE printque
SET ORDER TO TAG hn
go top
IF ! ISDIGIT(hn)
   ?? CHR(7)
   @ 12,25 SAY '�ѵä��������������������º��������'
   mkey=INKEY(5)
ELSE
   DO WHIL ISDIGIT(hn) .AND. ! exist
      SELE patient1
      SET ORDER TO 1
      IF SEEK(printque->hn)
         @ 12,25 SAY '���ѧ�����ѵ��Ţ��� '+hn
         IF FILE('printopd.fxp')
         	DO ('Printopd')
         ELSE
         	DO propdp
         ENDI
      ENDI
      SELE printque
      REPL NEXT 1 hn WITH 'AAAAAAA'
      FLUSH
      GO TOP
      IF ! PrintAll
         exist=.T.
      ENDI
   ENDD
ENDI

PROC PROLD
PRIVATE mstart,mend
@ 3,0 CLEA TO 20,79
STORE SPACE(7) TO mstart,mend
@ 10,25 SAY '���������������Ţ���  ' GET mstart PICT '9999999'
@ 12,25 SAY ' �����仨��֧�Ţ���      ' GET mend PICT '9999999' VALID mend>=mstart
READ NOLOCK
exist=.F.
DO WHIL ! PRINTSTATUS() .AND. ! exist
   ?? CHR(7)
   WAIT '����ͧ������ѧ�������  �ô��Ǩ�ͺ������º����' WINDOW
ENDD
IF exist
	RETU
ENDI
DO WHIL mstart<=mend .AND. ! exist
	SELE patient1
	SET ORDER TO 1
	mseek=PADZERO(mstart,7)
	IF ! SEEK(mseek)
	  	?? CHR(7)
		WAIT '����պѵü������Ţ��� '+mseek WINDOW TIMEOUT 1
	ELSE
	IF FILE('printopd.fxp')
			DO ('printopd')
		ELSE
			DO propdp
		ENDI
	ENDI
	mstart=LTRIM(STR(VAL(mstart)+1))
ENDD

PROC PRAPPO
