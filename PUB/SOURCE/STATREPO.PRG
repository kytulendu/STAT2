**************************************************************************
*  โมดูลสำหรับขึ้นเมนูให้เลือกว่าจะพิมพ์บัตรดัชนี                        *
*  หรือจะทำรายงานอะไรเกี่ยวกับเวชระเบียน                                 *
**************************************************************************

PRIVATE Colspace,PreScr,Chelp,EHelpMess,Ch_Help
#define numutil 7
@ 3,0 CLEA TO 20,80
DIME chelp(numutil),EHelpMess(numutil)
chelp[1]='1. บัตรดัชนี'
chelp[2]='2. ค้นหาตามเงื่อนไข'
chelp[3]='3. ค้นหา HN และชื่อตามเงื่อนไข'
chelp[4]='4. ค้นหาคนไข้ใหม่ในปีตามเงื่อนไข'
chelp[5]='5. ค้นหา HN และชื่อคนไข้ใหม่ในปีตามเงื่อนไข'
chelp[6]='6. หาจำนวนคนไข้รับไว้ในโรงพยาบาล'
chelp(numutil)='0. กลับรายการเดิม'

EhelpMess[1]='พิมพ์บัตรดัชนีไว้เวลาเครื่องไม่สามารถทำงานได้'
EhelpMess[2]='ค้นหาจำนวนเป็นตาราง 2 มิติ ตามเงื่อนไขที่กำหนด'
EhelpMess[3]='ค้นหาเลขที่ผู้ป่วยนอกและชื่อ ตามเงื่อนไขที่กำหนด'
EhelpMess[4]='ค้นหาจำนวนเป็นตาราง 2 มิติ ของคนไข้ใหม่ในปีตามเงื่อนไขที่กำหนด'
EhelpMess[5]='ค้นหาเลขที่ผู้ป่วยนอกและชื่อของคนไข้ใหม่ในปี ตามเงื่อนไขที่กำหนด'
EhelpMess[6]='ค้นหาจำนวนคนไข้ที่รับไว้ ตามเงื่อนไขที่กำหนด'
EHelpMess[numutil]='กลับไปสู่รายการหลัก'

DEFINE WIND help_menu FROM 4,5 TO 4+ALEN(chelp)+3,50 SHAD COLO gr+/BG TITLE '  แก้ไขค่าต่าง ๆ  '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	CLOSE DATA
	= ENGMODE()
	DO Title WITH 'รายการรายงานห้องบัตร'
	ACTI WIND help_menu
	FOR i=1 TO ALEN(chelp)
		@ i,3 PROMPT chelp(i) MESS EhelpMess[i]
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
			DO Pr_Index
		CASE Ch_help = 2
			DO StatRQBE
		CASE Ch_help = 3
			DO StatHN
		CASE Ch_help = 4
			DO NewRQBE
		CASE Ch_help = 5
			DO NewRqHN
		CASE Ch_help = 6
			DO AdmitNum
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_menu
CLOSE DATA