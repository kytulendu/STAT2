********************************************************************************
* ������ŷ�����Ǩ�ͺ��Ҫ��͹���繪�������������� ��                      *
* 1. ��Ǩ�ͺ�������繹��ʡ����������´�����ѡ����á�繪�ͧ��ҧ������� ���   *
*    �繹��ʡ�Ũд����������á����� �����������������                      *
* 2. ����繪��ͨФ�����Ҫ��͹����������� �������ը�������º���� 3 ����á   *
*    ����Ѻ���ʡ�� 3 ����á������������ ���������ʴ�������������             *
* 3. ����������Ҩҡ 2 ����á���ʴ����� ���ʡ�� ������ô�                    *
*    ����ѹ��͹���Դ ������� Procedure LISTNAME                             *
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