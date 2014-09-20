*PROC PrintApp
DAY1='วันอาทิตย์'
DAY2='วันจันทร์'
DAY3='วันอังคาร'
DAY4='วันพุธ'
DAY5='วันพฤหัส'
DAY6='วันศุกร์'
DAY7='วันเสาร์'
SELE patient1
seek hn
cut_name=TRIM(De_Name(name))
SELE icd101
mseek=Con_ICD(TRIM(mdiag1))
SEEK mseek
sele appoint
aa=str(dow(date),1)
mday=DAY&aa+'ที่ '+CE2CBE(date)
mtime=left(time,2)+'.'+right(time,2)+' น.'
SET CONS OFF
SET PRINT ON
hospname=RTRIM(hosp_name)
IF ! CancelPrint()
	?
	?
	?SPACE(40-LEN(hospname)),CHR(14),hospname
	?
	?space(5),'เลขที่ผู้ป่วยนอก',CHR(14),hn
	?
	? space(5),'ชื่อ',cut_name
 
	? space(5),'นัดตรวจ',mday,'เวลา',mtime
	? space(5),'การวินิจฉัยโรค',TRIM(icd101.desc) &&CHR(14),
	? space(5),'ผลชันสูตรที่ต้องใช้ '
	? space(10),lab
	?
	? space(5),'แพทย์ผู้นัด  ',rtrim(mdoctor) ,SPACE(5),'คลีนิค',rtrim(mclinic)
	?

	eject
ENDI
SET PRINT OFF
SET CONS ON

