day1 = '�ѹ�ҷԵ��'
day2 = '�ѹ�ѹ���'
day3 = '�ѹ�ѧ���'
day4 = '�ѹ�ظ'
day5 = '�ѹ�����'
day6 = '�ѹ�ء��'
day7 = '�ѹ�����'
SELECT patient1
SEEK hn
cut_name = TRIM(de_name(name))
SELECT icd101
mseek = con_icd(TRIM(mdiag1))
SEEK mseek
SELECT appoint
aa = STR(DOW(date), 1)
mday=DAY&aa+'��� '+CE2CBE(date)
mtime = LEFT(time, 2)+'.'+RIGHT(time, 2)+' �.'
SET CONSOLE OFF
SET PRINTER ON
hospname = RTRIM(hosp_name)
IF .NOT. cancelprin()
	?
	? SPACE(25), CHR(14), hospname
	?
	? SPACE(25), '�Ţ�������¹͡ '+CHR(14)+hn
	?
	? SPACE(25), '����', cut_name
	? SPACE(25), '�Ѵ��Ǩ', CHR(14), mday
	? SPACE(34), CHR(14), '����', mtime
	?
	? SPACE(25), '����ԹԨ����ä', TRIM(icd101.desc)
	? SPACE(25), '�Ūѹ�ٵ÷���ͧ�� '
	? SPACE(30), lab
	?
	? SPACE(25), 'ᾷ����Ѵ  ', RTRIM(mdoctor)
	?
	? SPACE(25), '��չԤ', RTRIM(mclinic)
	?
	?
	?
	? CHR(14), '** ��س����㺹Ѵ������˹����ͧ��Ъ�����ѹ�� ��� 1 **'
	EJECT
ENDIF
SET PRINTER OFF
SET CONSOLE ON
