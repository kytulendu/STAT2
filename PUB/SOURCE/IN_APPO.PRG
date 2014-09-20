PRIV goon
SELE appoint
pdoctor = SPACE(LEN(doctor))
pclinic = SPACE(LEN(clinic))
STOR SPACE(30) TO mclinic,mdoctor
STOR SPACE(4) TO mmtime
goon = .T.
DO WHIL goon
	SCAT MEMV MEMO BLANK
	STOR SPACE(7) TO m.hn
	STOR SPACE(10) TO mdateappo
	STOR SPACE(30) TO ptname
	m.clinic = pclinic
	m.doctor = pdoctor
	goobj = 1
	DO ClearScreen
	@ 10,10 SAY 'กรุณาใส่เลขที่ผู้ป่วยนอกที่จะนัด ' GET m.hn DEFA SPACE(7) ;
	PICT "#######" WHEN Checkobj() VALID CheckHn(m.hn);
	MESS 'ใส่หมายเลขผู้ป่วยนอก ไม่ต้องมี 0 นำหน้า'
	@ 11,40 GET ptname DEFA SPAC(30) DISA COLO ,,,,,,,,,/w
	@ 13,30 SAY 'ข้อมูลถูกต้องหรือไม่ ' GET m.correct DEFA 'Y' ;
	PICT '!' VALID CheckCorrect(m.correct)
	READ NOLOCK
	_printappoint = .F.
	goon = ! (LASTKEY() = 27 .OR. EMPTY(m.hn) .OR. m.correct # 'Y')
	IF goon
		DO Appointment with .T.
	ENDI
	pdoctor = m.doctor
	pclinic = m.clinic
ENDD