*********************
*Proc Printprs
*********************
PRIV pcid
prow = 0
E_on=chr(27)+chr(14)
E_off=chr(27)+chr(20)
B_on=chr(27)+chr(71)
B_off=chr(27)+chr(72)
*set print to test.txt
set print on
SET CONS OFF
??  chr(27)+chr(33)+chr(1)				&& 12 cpi
*?  e_on+b_on+m.mpn+b_off+e_off
*? CHR(27) + 'C' + CHR(16)
*?
*@ row,35 SAY CHR(27)+'E'+'HN: '+hn+CHR(27)+'F'
? '���� ' + TRIM(mname) + '  ���� ' + TRIM(m.mage) + '  HN ' AT 2
?? CHR(27) + 'w1'+CHR(27) +'W1' + LEFT(patient1.hn,5)+' ' +RIGHT(patient1.hn,2) + ;
CHR(27) +'w0' + CHR(27)+'W0' 
= SEEK(patient1.clinic,'clinic')
? '�ѹ��� ' + ALLTRIM(m.mdate) + '  ��չԡ ' + TRIM(clinic.name) + '  ���� ' + TIME() AT 2
= SEEK(patient1.hn ,'insure')
DO WHIL patient1.class # insure.inscl AND ! EOF('insure')
	SKIP IN insure
ENDD
IF patient1.hn = LEFT(insure.hn,7)
	pcid = TRIM(insure.cid)
	mdateexpire = insure.dateexp
ELSE
	pcid = ''
	mdateexpire = ''
ENDI
DO CASE
	CASE LEN(pcid) = 15
		pcid = TRANS(pcid, '@R #####-#-####-#####')
	CASE LEN(pcid) = 10
		pcid = TRANS(pcid, '@R ##-#######-#')
	CASE LEN(pcid) = 12
		pcid = TRANS(pcid, '@R #####-#-#####-#')
	CASE LEN(pcid) = 9
		pcid = TRANS(pcid, '@R ##-#-#####-#')
	
ENDC
? '�Է�ԡ���ѡ�� ' + TRIM(m.mrights) + '  �Ţ���ѵ� ' + pcid  AT 2
? '�ѹ�������  ' + IIF(! EMPTY(mdateexpire), CE2CBE(insure.dateexp), SPACE(8)) AT 2
= SEEK('2' + contact.changwat + contact.ampur,'address')
pampur = TRIM(address.name)
= SEEK('1' + contact.changwat,'address')
pchangwat = TRIM(address.name)
?? '  ������� ' + IIF( ! EMPTY(pampur), '�.' + pampur + ' ', '') + '�.' + pchangwat
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
	= SEEK(insure.hospsub,'hospcode')
	mhospsub = DE_NAME(hospcode.name)
	? '1. ' + mhospmain AT 2
	? '2. ' + mhospsub AT 2
ELSE
	STORE '' TO mhospmain,mhospsub
	?
	?
ENDI
IF closehospcode
	SELE hospcode
	USE
ENDI
prinrow = 2
FOR i = prinrow TO 31 && ��������÷Ѵ������ա 31 ��÷Ѵ �������ʹ�˹��
	? ' '
NEXT
*EJECT
set print off
SET CONS ON

