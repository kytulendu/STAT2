*PROC PrintApp
DAY1='�ѹ�ҷԵ��'
DAY2='�ѹ�ѹ���'
DAY3='�ѹ�ѧ���'
DAY4='�ѹ�ظ'
DAY5='�ѹ�����'
DAY6='�ѹ�ء��'
DAY7='�ѹ�����'
SELE patient1
seek hn
cut_name=TRIM(De_Name(name))
SELE icd101
mseek=Con_ICD(TRIM(mdiag1))
SEEK mseek
sele appoint
aa=str(dow(date),1)
mday=DAY&aa+'��� '+CE2CBE(date)
mtime=left(time,2)+'.'+right(time,2)+' �.'
SET CONS OFF
SET PRINT ON
hospname=RTRIM(hosp_name)
IF ! CancelPrint()
	?
	?
	?SPACE(40-LEN(hospname)),CHR(14),hospname
	?
	?space(5),'�Ţ�������¹͡',CHR(14),hn
	?
	? space(5),'����',cut_name
 
	? space(5),'�Ѵ��Ǩ',mday,'����',mtime
	? space(5),'����ԹԨ����ä',TRIM(icd101.desc) &&CHR(14),
	? space(5),'�Ūѹ�ٵ÷���ͧ�� '
	? space(10),lab
	?
	? space(5),'ᾷ����Ѵ  ',rtrim(mdoctor) ,SPACE(5),'��չԤ',rtrim(mclinic)
	?

	eject
ENDI
SET PRINT OFF
SET CONS ON

