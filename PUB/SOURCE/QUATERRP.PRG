
parameter _lcQ, _lcYY

private startday, endday, lcMM1, lcMM2, lcStart, lcEnd

	do case
		case _lcQ ='1' 
			lcMM1 = '10'
			lcMM2 = '12'
			lcStart = '01/'+lcMM1+'/'+_lcYY
			lcEnd	= '31/'+lcMM2+'/'+_lcYY
		case _lcQ ='2'
			lcMM1 = '01'
			lcMM2 = '03'
			lcStart = '01/'+lcMM1+'/'+_lcYY
			lcEnd	= '31/'+lcMM2+'/'+_lcYY
		case _lcQ ='3'	
			lcMM1 = '04'
			lcMM2 = '06'
			lcStart = '01/'+lcMM1+'/'+_lcYY
			lcEnd	= '30/'+lcMM2+'/'+_lcYY
		case _lcQ ='4'
			lcMM1 = '07'
			lcMM2 = '09'
			lcStart = '01/'+lcMM1+'/'+_lcYY
			lcEnd	= '30/'+lcMM2+'/'+_lcYY
	endcase
	startday	=	be2ce(lcStart)
	endday 		= 	be2ce(lcEnd)
	
set DEVICE TO PRINTER

@ 0,0 SAY CHR(27)+CHR(40)+CHR(116)+CHR(3)+CHR(0)+CHR(48)+CHR(18)+CHR(0)	&& KU printer code
@ 0,0 SAY CHR(27)+CHR(67)+CHR(0)+CHR(11)			&& Set page length 11 inches
@ 0,0 SAY CHR(27)+'3'+CHR(36) 		&& กำหนดระยะระหว่างบรรทัด
@ 0,0 SAY CHR(27)+'!'+CHR(0)                                                                                  &&   10 cpi
@ 0,0 SAY CHR(27)+'x'+'0'		&& Draft mode

SELECT DISTINCT INSURE.INSCL, SOCIAL.NAME, INSURE.SUBTYPE,;
  INSURE.DATEEXP, INSURE.HOSPMAIN, INSURE.NOTEDATE;
 FROM INSURE, SOCIAL;
 WHERE SOCIAL.CLASS = INSURE.INSCL;
 HAVING INSURE.DATEEXP <> CTOD("  /  /  ");
   AND INSURE.NOTEDATE < endday+1;
   AND INSURE.INSCL BETWEEN "71" AND "88";
 ORDER BY INSURE.INSCL;
 INTO CURSOR RPHIO1
CREATE REPORT RPHIO1.FRX FROM RPHIO1 WIDTH 80 COLUMN NOOVERWRITE
REPORT FORM RPHIO1.FRX TO PRINTER NOCONSOLE NOEJECT

eject

SELECT DISTINCT SUBSTR(HOSPMAIN,5,2), HOSPCODE.NAME, INSURE.SUBTYPE,;
  INSURE.DATEEXP, INSURE.HOSPMAIN, INSURE.NOTEDATE;
 FROM INSURE, HOSPCODE;
 WHERE HOSPCODE.CODE = INSURE.HOSPMAIN;
 HAVING INSURE.DATEEXP#CTOD("  /  /  ");
  AND INSURE.NOTEDATE<endday+1;
  AND BETWEEN(INSURE.INSCL,"71","88");
 ORDER BY 1, INSURE.HOSPMAIN DESCENDING;
 INTO CURSOR RPHIO2
CREATE REPORT RPHIO2.FRX FROM RPHIO2 WIDTH 80 COLUMN NOOVERWRITE
REPORT FORM RPHIO2.FRX TO PRINTER NOCONSOLE NOEJECT

set DEVICE TO SCREEN

