DEAC WIND ALL
numdirec = 6
DIME backdir[numdirec],targetdir[numdirec]
backdir[1] = patientdir
backdir[2] = '\credit\data\'
backdir[3] = opddir
backdir[4] = ipddir+'data\'
backdir[5] = pharmdir
backdir[6] = codedir
numdirec = IIF(UPPE(patientdir) = UPPE(codedir), numdirec -1, numdirec)
n=1
rowshow = 6
fileerror = 0
toscan = 5000
DO WHIL n <= numdirec
	WAIT WIND NOWA 'โปรดคอย ! กำลังตรวจสอบแฟ้มที่จะสำรองใน Directory ' + backdir[n] + '  '
	numfile = ADIR(dbffile,backdir[n]+'*.cdx')
	=ASORT(dbffile)
	FOR i = 1 TO numfile
		IF ! ISDIGIT(dbffile[i,1])
			filesele = LEFT(dbffile[i,1],AT('.',dbffile[i,1])-1)
			dbfuse = backdir[n] + filesele
			IF FILE(dbfuse + '.dbf')
				WAIT WIND NOWA 'กำลังตรวจเช็คดัชนีของแฟ้ม ' + dbfuse + '  '
				USE (dbfuse) ORDER 1
**UDC			WAIT WIND NOWA 'กำลังตรวจเช็คดัชนีของแฟ้ม ' + dbfuse + '  ' && ย้ายขึ้นไป
				field1 = KEY(1)
				GO BOTT
				prehn = &field1
				prerec = 0
				numscan = 0
				@ 4,0
				DO WHIL ! BOF() .AND. INKEY() # 27 .AND. prerec = 0 .AND. numscan < toscan
					@ 4,5 SAY &field1
					IF &field1 > prehn
						@ rowshow,2 SAY 'มีปัญหาที่แฟ้มดัชนีของแฟ้ม ' + dbfuse + ' กรุณาซ่อมแฟ้มดัชนีใหม่  '
						prerec = 1
						rowshow = IIF(rowshow < 19, rowshow +1,6)
						fileerror = fileerror  + 1
					ELSE
						prehn = &field1
						numscan = numscan + 1
					ENDI
					skip -1
				ENDD
			ELSE
				DELE FILE (dbfuse + '.cdx')
			ENDI
		ENDI
	NEXT
	n = n + 1
ENDD
CLOSE DATA
=ALARM1()
IF ! EMPTY(fileerror)
	WAIT WIND 'มีแฟ้มที่แฟ้มดัชนีเสียจำนวน ' + LTRIM(STR(fileerror)) + ' แฟ้ม  '
ELSE
	WAIT WIND NOWAIT 'ไม่มีแฟ้มดัชนีขัดข้อง  '
ENDI
DO CLEARSCREEN