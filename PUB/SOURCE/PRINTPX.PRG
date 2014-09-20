*********************
*Proc Printprs
*********************
PRIV pcid
prow = 0
E_on=chr(27)+chr(14)
E_off=chr(27)+chr(20)
B_on=chr(27)+chr(71)
B_off=chr(27)+chr(72)
set print on
SET CONS OFF
?? chr(27) + chr(33) + chr(1)				&& 12 cpi
?
? 'เลขที่ ' + e_on+b_on+m.mpn+b_off+e_off AT 37
? 'HN '+CHR(27)+'w1'+CHR(27)+'W1'+patient1.hn+CHR(27)+'w0'+CHR(27)+'W0'+'  ชื่อ '+TRIM(mname)+' อายุ '+ALLTRIM(m.mage) AT 2
= SEEK(patient1.clinic,'clinic')
? 'วันที่ '+ALLTRIM(m.mdate)+'  '+TRIM(clinic.name)+'  เวลา '+TIME()+' น.' AT 2
= SEEK(patient1.hn ,'insure')
DO WHIL patient1.class # insure.inscl AND ! EOF('insure')
	SKIP IN insure
ENDDO
IF patient1.hn = LEFT(insure.hn,7)
	pcid = TRIM(insure.cid)
	mdateexpire = insure.dateexp
ELSE
	pcid = ''
	mdateexpire = ''
ENDI
IF LEN(pcid) = 13
	pcid = TRANS(pcid, '@R #-####-#####-##-#')
ELSE
	pcid = pcid
ENDI
? 'สิทธิ ' + TRIM(m.mrights) + ' เลขที่ ' + IIF(!EMPTY(pcid),pcid,SPACE(8)) + ' หมดอายุ ';
+ IIF(!EMPTY(insure.dateexp), IIF(RIGHT(CE2CBE(insure.dateexp),4)='2599' OR RIGHT(CE2CBE(insure.dateexp),4)='9999','ตลอดชีพ',CE2CBE(insure.dateexp)), SPACE(8)) AT 2

*** พิมพ์ที่อยู่ ***
= SEEK('3' + contact.changwat + contact.ampur + contact.tambon,'address')
ptambon = TRIM(address.name)
= SEEK('2' + contact.changwat + contact.ampur,'address')
pampur = TRIM(address.name)
= SEEK('1' + contact.changwat,'address')
pchangwat = TRIM(address.name)
? 'บ้านเลขที่ '+TRIM(contact.address) + IIF(VAL(contact.village)>0,' หมู่ ' + contact.village,'') ;
+ IIF(!EMPTY(ptambon),' ต.' + ptambon,'') + ' ' + IIF(!EMPTY(pampur), IIF(LEFT(pampur,6)='เทศบาล', ;
+ pampur,'อ.' + pampur),'') + ' ' + IIF(LEFT(pchangwat,7)='กรุงเทพ', pchangwat,'จ.' + pchangwat) AT 2

pp_id = TRIM(patient1.person_id)
IF LEN(pp_id) = 0 THEN
	pp_id = SPACE(17)
ELSE
	pp_id = TRANS(pp_id, '@R #-####-#####-##-#')
ENDIF
? 'เลขประจำตัวประชาชน ' + pp_id + '       DF 20.-/40.-' AT 2

*** พิมพ์สถานพยาบาลหลัก
IF ! USED('hospcode')
	closehospcode = .T.
	USE (codedir + 'hospcode') IN 0
ELSE
	closehospcode = .F.
ENDI
SELE hospcode
SET ORDER TO 1
IF ! EMPTY(pcid)
	= SEEK(insure.hospmain,'hospcode')
	mhospmain = DE_name(hospcode.name)
*	= SEEK(insure.hospsub,'hospcode')
*	mhospsub = DE_NAME(hospcode.name)
ELSE
	STORE '' TO mhospmain
ENDI
SELE newcase
	IF VISITED = .T.
		mnew = 'เก่าของปี'
	ELSE
		mnew = 'ใหม่ของปี'
ENDI
? 'สถานพยาบาลหลัก : ' + LEFT(mhospmain+SPACE(29),29) + ' ' + mnew AT 2

? IIF((!EMPTY(insure.dateexp) and insure.dateexp < date()) or (EMPTY(insure.dateexp) and LEFT(patient1.class,1) <> '2'), LEFT('** ส่งศูนย์ประกันฯตรวจสอบสิทธิ **'+SPACE(45),45),SPACE(45)) ;
+ IIF(patient1.clinic='013',CHR(27)+'w1'+CHR(27)+'W1'+'FBS'+CHR(27)+'w0'+CHR(27)+'W0','') AT 5

*IF (patient1.class='30' or patient1.class='3C' or patient1.class='99') and patient1.clinic<>'031'
IF (patient1.class $ ucright+','+fwfright) and patient1.clinic<>'031'
	muc = 'UC'
	mucp = '30'
ELSE
	muc = ''
	mucp = ''
ENDI
? "การวินิจฉัยโรค................................ " + CHR(27)+'w1'+CHR(27)+'W1'+muc+CHR(27)+'w0'+CHR(27)+'W0' AT 8
IF closehospcode
	SELE hospcode
	USE
ENDI
? insure.note at 8

FOR i = 1 TO 23
	?
NEXT
? CHR(27)+'w1'+CHR(27)+'W1'+mucp+CHR(27)+'w0'+CHR(27)+'W0' AT 28
EJECT
set print off
SET CONS ON