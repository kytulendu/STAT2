EXTERNAL ARRAY patient1,patient2,contact1,contact2
mat=AT(',',patient1(3))
@ 4,13 SAY ;
IIF(mat>0,SUBS(patient1(3),mat+1,LEN(TRIM(patient1(3)))-mat)+LEFT(patient1(3),mat-1)+SPAC(LEN(patient1(3))+1-LEN(TRIM(patient1(3)))-1),patient1(3));
 COLO gr+/b
@ 4,70 SAY patient1(1) COLO gr+/b
@ 5,5 SAY patient1(2)+' '+IIF(! patient1(2)$'12','    ',sex&patient1(2));
 COLO gr+/b
@ 5,34 SAY contact1(2) COLO gr+/b
SELE address
SEEK '1'+contact1(6)
@ 6,10 SAY contact1(6)+" "+name COLO gr+/b
SEEK '2'+contact1(6)+contact1(5)
@ 6,50 SAY contact1(5)+" "+name COLO gr+/b
SEEK '3'+contact1(6)+contact1(5)+contact1(4)
@ 7,10 SAY contact1(4)+" "+name COLO gr+/b
@ 7,50 SAY contact1(3) COLO gr+/b
@ 8,11 SAY patient2(7) COLO gr+/b
show_birth=Ce2Cbe(patient1(4))
@ 9,11 SAY SPAC(18)
show_age=NowAge(patient1(4),patient1.derive)
@ 9,11 SAY show_birth COLO gr+/b
@ 9,36 SAY show_age COLO gr+/b
@ 9,62 SAY patient1(5)+' '+IIF(! patient1(5)$'12',' ',derive&patient1(5)) ;
COLO gr+/b
@ 10,11 SAY patient2(3)+' '+IIF(! patient2(3)$'123456','    ',marry&patient2(3));
 COLO gr+/b
SELE occupat
SEEK patient2(4)
@ 10,30 SAY patient2(4)+' '+LEFT(name,44) COLO gr+/b
SELE nation
SEEK patient2(6)
@ 11,12 SAY patient2(6)+' '+name COLO gr+/b
SEEK patient2(5)
@ 12,12 SAY patient2(5)+' '+name COLO gr+/b
mat=AT(',',patient1(6))
@ 13,10 SAY ;
IIF(mat>0,SUBS(patient1(6),mat+1,LEN(TRIM(patient1(6)))-mat)+LEFT(patient1(6),mat-1)+SPAC(LEN(patient1(6))+1-LEN(TRIM(patient1(6)))-1),patient1(6));
 COLO gr+/b
mat=AT(',',patient1(10))
@ 14,10 SAY ;
IIF(mat>0,SUBS(patient1(10),mat+1,LEN(TRIM(patient1(10)))-mat)+LEFT(patient1(10),mat-1)+SPAC(LEN(patient1(10))+1-LEN(TRIM(patient1(10)))-1),patient1(10));
 COLO gr+/b
IF ! healthin
mat=AT(',',patient2(2))
@ 15,19 SAY ;
IIF(mat>0,SUBS(patient2(2),mat+1,LEN(TRIM(patient2(2)))-mat)+LEFT(patient2(2),mat-1)+SPAC(LEN(patient2(2))+1-LEN(TRIM(patient2(2)))-1),patient2(2));
 COLO gr+/b
@ 16,19 SAY contact2(2) COLO gr+/b
SELE address
SEEK '1'+contact2(6)
@ 17,10 SAY contact2(6)+' '+name COLO gr+/b
SEEK '2'+contact2(6)+contact2(5)
@ 17,50 SAY contact2(5)+' '+name COLO gr+/b
SEEK '3'+contact2(6)+contact2(5)+contact2(4)
@ 18,10 SAY contact2(4)+' '+name COLO gr+/b
@ 18,50 SAY contact2(3) COLO gr+/b
ENDI
= SEEK(patient1[8],'social')
@ 19,16 SAY patient1(8)+' '+social->name COLO gr+/b
IF ! healthin
	@ 20,16 SAY patient1(9)+' '+clinic->name COLO gr+/b
ENDI
@ 22,1 SAY 'ครั้งสุดท้ายมาวันที่ ' + CE2CBE(patient1(7)) + ' เวลา ' + ;
LEFT(patient1.time,2) + ':' + RIGHT(patient1.time,2) + ' น. กดปุ่ม [F9] เพื่อดูรายละเอียด'
=SEEK(mhn, 'previsit')
=SEEK(previsit.lastclinic,'clinic')
@ 24,1 SAY 'ก่อนหน้านี้มาวันที่ ' + CE2CBE(previsit.lastdate) + ' เวลา ' + ;
LEFT(previsit.lasttime,2) + ':' + RIGHT(previsit.lasttime,2) + ' น. ' + TRIM(clinic.name)
*IF Getperson_id
*	DEFINE WIND person FROM 0,5 TO 2,74 SHAD
*	ACTI WIND person
*	@ 0,5 SAY 'เลขที่บัตรประชาชน '
*	@ 0,25 SAY patient1[12] PICT '@R 9-9999-99999-99-9'
*ENDI
ACTI SCREE
