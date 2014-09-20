day1 = 'วันอาทิตย์'
day2 = 'วันจันทร์'
day3 = 'วันอังคาร'
day4 = 'วันพุธ'
day5 = 'วันพฤหัส'
day6 = 'วันศุกร์'
day7 = 'วันเสาร์'
SELECT patient1
SEEK hn
cut_name = TRIM(de_name(name))
SELECT icd101
mseek = con_icd(TRIM(mdiag1))
SEEK mseek
SELECT appoint
aa = STR(DOW(date), 1)
mday=DAY&aa+'ที่ '+CE2CBE(date)
mtime = LEFT(time, 2)+'.'+RIGHT(time, 2)+' น.'
SET CONSOLE OFF
SET PRINTER ON
hospname = RTRIM(hosp_name)
IF .NOT. cancelprin()
	?
	? SPACE(25), CHR(14), hospname
	?
	? SPACE(25), 'เลขที่ผู้ป่วยนอก '+CHR(14)+hn
	?
	? SPACE(25), 'ชื่อ', cut_name
	? SPACE(25), 'นัดตรวจ', CHR(14), mday
	? SPACE(34), CHR(14), 'เวลา', mtime
	?
	? SPACE(25), 'การวินิจฉัยโรค', TRIM(icd101.desc)
	? SPACE(25), 'ผลชันสูตรที่ต้องใช้ '
	? SPACE(30), lab
	?
	? SPACE(25), 'แพทย์ผู้นัด  ', RTRIM(mdoctor)
	?
	? SPACE(25), 'คลีนิค', RTRIM(mclinic)
	?
	?
	?
	? CHR(14), '** กรุณายื่นใบนัดที่โต๊ะหน้าห้องประชาสัมพันธ์ ชั้น 1 **'
	EJECT
ENDIF
SET PRINTER OFF
SET CONSOLE ON
