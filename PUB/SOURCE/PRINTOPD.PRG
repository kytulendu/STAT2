FS=CHR(28)
Underline=CHR(27)+'-1'
C_underline=CHR(27)+'-0'
Mode_df=CHR(27)+'x0'
Mode_lq=CHR(27)+'x1'
Double_ht=CHR(27)+'w1'
C_double_ht=CHR(27)+'w0'
Shadow=CHR(27)+'q2'
Outline=CHR(27)+'q1'
Out_shadow=CHR(27)+'q3'
C_out_sha=CHR(27)+'q0'
V_enlarge=CHR(14)
C_v_enlarge=FS+'V0'
SET DEVI TO PRINT
SELE patient1
row=PROW()
@ row,71 SAY V_enlarge+hn
row=row+3
mat=AT(',',name)
IF mat>0
   mname1=SUBS(name,mat+1,LEN(TRIM(name))-mat)+LEFT(name,mat-1)
ELSE
   mname1=name
ENDI
@ row,13 SAY mname1
row=row+1
@ row,15 SAY IIF(sex='1','ชาย','หญิง')
mage=Nowage(patient1->birthday,patient1.derive)
thaidate=Ce2Cbe(patient1->birthday)
@ row,36 SAY IIF(patient1->derive='2','พ.ศ. '+RIGHT(thaidate,4),thaidate)
@ row,64 SAY mage
row=row+1
@ row,15 SAY TRIM(contact->address)+;
IIF(VAL(contact->village)>0,' หมู่ '+contact->village,'')
row=row+1
SELE address
SEEK '3'+contact->changwat+contact->ampur+contact->tambon
@ row,15 SAY IIF(name='    ','','ต.'+TRIM(name))
SEEK '2'+contact->changwat+contact->ampur
@ row,PCOL() SAY IIF(name='    ','',' อ.'+TRIM(name))
SEEK '1'+contact->changwat
@ row,PCOL()+1 SAY 'จ.'+TRIM(name)+;
IIF(patient2->phone='   ','',' โทร.'+TRIM(patient2->phone))
mmarriage=patient2->marriage
row=row+1
@ row,20 SAY marry&mmarriage
SELE occupat
SEEK patient2->occupa
@ row,43 SAY TRIM(name)
SELE nation
SEEK patient2->race
row=row+1
@ row,16 SAY LEFT(name,30)
SEEK patient2->nation
@ row,46 SAY LEFT(name,30)
row=row+1
m.mother=TRIM(patient1->mother)
m.father=TRIM(patient1->father)
mat=AT(',',m.mother)
mat1=AT(',',m.father)
@ row,19 SAY IIF(mat=0,m.mother,SUBS(m.mother,mat+1)+LEFT(m.mother,mat-1));
+'/'+ IIF(mat1=0,m.father,SUBS(m.father,mat1+1)+LEFT(m.father,mat1-1))
row=row+1
mat=AT(',',patient2->contact)
IF mat>0
   mname1=SUBS(patient2->contact,mat+1,LEN(TRIM(patient2->contact))-mat)+LEFT(patient2->contact,mat-1)
ELSE
   mname1=patient2->contact
ENDI
@ row,19 SAY mname1
SELE contact
IF owner='1'
   SKIP
ENDI
row=row+1
@ row,19 SAY TRIM(contact->address)+;
IIF(VAL(contact->village)>0,' หมู่ '+contact->village,'')
row=row+1
SELE address
SEEK '3'+contact->changwat+contact->ampur+contact->tambon
@ row,19 SAY IIF(name='    ','','ต.'+TRIM(name))
SEEK '2'+contact->changwat+contact->ampur
@ row,PCOL() SAY IIF(name='    ','',' อ.'+TRIM(name))
SEEK '1'+contact->changwat
@ row,PCOL()+1 SAY 'จ.'+TRIM(name)
row=row+1
@ row,0 SAY '  '
row=row+11
@ row,0 SAY ' '
SET DEVI TO SCREE

