********************************************************************************
* ������ŷ�����ʴ����� ���ʡ�� ������� ����ѹ�Դ �¨��ʴ����� 13 ����     *
* ����ö����¹�٪��͡�͹˹�ҹ���¡��١�â��                                 *
* ����ö�٪��ͶѴ��¡��١��ŧ                                                *
* ����ö���͡����ʴ���������´�ͧ�����˹�����¡�����ѡ��˹�Ҫ��͹��         *
********************************************************************************
PARA _isnew
PRIVATE Pre_page,mkey,valid_key,bott_mess
bott_mess='[PgUp]=���͡�͹˹�ҹ��  [PgDn]=���ͶѴ�  [Esc]=������͡  [A]-['
SAVE SCREEN TO Pre_page
DO ClearScreen
@ 3,0
?'        ���� ���ʡ��                   �������                  �Ţ��Шӵ��'
nn=0
DO WHIL nn=0
   @ 5,0
   mkey=0
   DO WHIL nn<14 .AND. ! EOF()
      ? CHR(nn+65)+' '+DE_NAME(name)+SPAC(2)+LEFT(DE_NAME(mother),25);
      +SPACE(4)+hn
      nn=nn+1
      SKIP
   ENDD
   valid_key=.F.
   DO Bottmess WITH bott_mess+CHR(nn+64)+']=���͡'
   DO WHIL ! valid_key
      mkey=inkey(10)
      DO Bottmess WITH bott_mess+CHR(nn+64)+']=���͡'
      DO CASE
      CASE mkey=27 .OR. mkey=13     && [Esc] or [Enter]
         valid_key=.T.
      CASE mkey=5  .OR. mkey=18              &&  Up arrow
         SKIP -nn-1
         IF BOF()
            ?? CHR(7)
            DO Bottmess WITH '����繪����á��������'
            SKIP nn
         ELSE
            SKIP -(27-nn)
            valid_key=.T.
            nn=0
            IF BOF()
               GO TOP
            ENDI
         ENDI
      CASE mkey=24  .OR. mkey=3             &&  Down arrow
         IF ! EOF()
            valid_key=.T.
            nn=0
         ELSE
            ?? CHR(7)
            DO bottmess WITH '�����ª��ͷ����ʴ�����'
         ENDI
      OTHER
         mm= ROUND(AT(UPPE(CHR(mkey)),'A�B�C�D�E�F�G�H�I�J�K�L�M�N�')/2,0)
         IF mm>0 .AND. mm<=nn+1
            valid_key=.T.
         ENDI
      ENDC
   ENDD
   @ 5,0 CLEA TO 20,79
ENDD
IF mkey=27
   _isnew=.T.
   mm=0
ELSE
   mm=IIF(mkey=13,1,mm)
   SKIP -(nn+1-mm)
   _isnew=.F.
ENDI
REST SCREE FROM Pre_page

