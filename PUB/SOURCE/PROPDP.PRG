	SET CONS OFF
	set prin on
	pagerow = 32
	sele patient1
	mage=nowage(patient1->birthday,patient1->derive)
	?
	?? CHR(27)+'J'+CHR(28)
	?
	? 'อายุ '+mage AT 50
	? chr(27)+'w1'+chr(27)+'W1'
	??spac(21)+hn	&& พิมพ์ HN บัตรเล็ก
	?chr(27)+'w0'+chr(27)+'W0' 
	mat=at(',',name)
	mname1=TRIM(De_Name(name))
	if seek(hn).and.lastdate#sysdate
		??chr(27)+'W1'
		thaid1=ce2cbe(lastdate)
		thaid=iif(len(thaid1)<=12,left(thaid1,7),left(thaid1,8))+righ(thaid1,4)
		??spac(7)+iif(len(thaid)<=11,' '+thaid+spac(12-len(thaid)),iif(lenthai(thaid)<=10,' '+thaid,thaid+' '))
		??chr(27)+'W0'
		??spac(2)
	else   
		??chr(27)+'W1'
		thaid1=ce2cbe(sysdate)
		thaid=iif(len(thaid1)<=12,left(thaid1,7),left(thaid1,8))+righ(thaid1,4)
		??spac(7)+iif(len(thaid)<=11,' '+thaid+spac(12-len(thaid)),iif(lenthai(thaid)<=10,' '+thaid,thaid+' '))
		??chr(27)+'W0'
		??spac(2)
	endi
	??chr(27)+'W1'
	if lenthai(mname1)<20
    	??mname1 AT 21
		??chr(27)+'W0'
	else
    	??chr(27)+'W0'    
		??spac(2)+mname1 AT 40
	endi
	?
	?
	?
	??chr(27)+'W0'    
	?
*	?
	? CHR(27)+'J'+CHR(10)
*	?
*  เริ่มต้นของการพิมพ์บัตรใหญ่
	?chr(27)+'W1'
	if lastdate#sysdate
		thaid=ce2cbe(lastdate)
	else   
		thaid=ce2cbe(sysdate)
	endi   
	??'พ.ศ.'+righ(thaid,4) AT 20
	??chr(27)+'W0'
	?

	??chr(27)+'w1'+chr(27)+'W1'     
	??hn AT 39
	??chr(27)+'w0'+chr(27)+'W0'
	? CHR(27)+'J'+ CHR(4)
	??chr(27)+'W1'
	if lenthai(mname1)<=30
		?spac(2)+spac(int((30-lenthai(mname1))/2))+mname1
	else
		??chr(27)+'W0'
		?spac(int((68-lenthai(mname1))/2))+mname1
	endi      
	?
	??chr(27)+'W0'
	?? CHR(27)+'J'+CHR(1)
	?? mage AT 53 &&อายุ
	? CHR(27)+'J'+ CHR(2)
	?
	thaidate=ce2cbe(patient1->birthday)
	??spac(10)+iif(patient1->derive='2','พ.ศ. '+right(thaidate,4)+spac(9),thaidate+spac(18-len(thaidate)))
	??'    '+iif(sex='1','ชาย ','หญิง')
	mmarriage=patient2->marriage
	??spac(14)+trim(contact->address)+iif(val(contact->village)>0,' หมู่ '+contact->village,'')
	m.mother=trim(patient1->mother)
	m.father=trim(patient1->father)
	mat=at(',',m.mother)
	mat1=at(',',m.father)
	mmot=iif(mat=0,m.mother,subs(m.mother,mat+1)+left(m.mother,mat-1))
	? spac(11)+mmot+spac(31-len(mmot))
	sele address
	seek '3'+contact->changwat+contact->ampur+contact->tambon
	??spac(7)+iif(name='    ','','ต.'+trim(name)) &&ตำบล
	mfat=iif(mat1=0,m.father,subs(m.father,mat1+1)+left(m.father,mat1-1))
	? spac(11)+mfat+spac(31-len(mfat))
	seek '2'+contact->changwat+contact->ampur
	??spac(7)+iif(name='    ','','อ.'+trim(name))  &&อำเภอ
	sele nation
	seek patient2->race
	? spac(11)+left(name,30)  &&เชื้อชาติ
	sele address
	seek '1'+contact->changwat
	??spac(8)+'จ.'+trim(name)   &&จังหวัด
	??iif(patient2->phone='   ','','   โทร.'+trim(patient2->phone))
	sele nation
	seek patient2->nation
	? spac(11)+left(name,30)   &&สัญชาติ
	sele occupat
	seek patient2->occupa
	? spac(11)+iif(lenthai(name)<=33.and.len(name)<=39,name+spac(40-len(name)),left(name,36)+spac(4))    &&อาชีพ
	sele social
	seek patient1.class
	??name
	? spac(11)+marry&mmarriage+spac(18-len(marry&mmarriage))  &&สภาพสมรส   &&&
	mat=at(',',patient2->contact)
	if mat>0
		mname1=subs(patient2->contact,mat+1,len(trim(patient2->contact))-mat)+left(patient2->contact,mat-1)
	else
		mname1=patient2->contact		
	endi
	? spac(11)+mname1  && ชื่อผู้ติดต่อ
	sele contact
	if owner='1'
		skip
	endi
	?
	? spac(11)+trim(contact->address)+iif(val(contact->village)>0,' หมู่ '+contact->village,'')
	sele address
	seek '3'+contact->changwat+contact->ampur+contact->tambon
	? spac(11)+iif(name='    ','','ต.'+trim(name))
	seek '2'+contact->changwat+contact->ampur
	? spac(11)+iif(name='    ','','อ.'+trim(name))
	seek '1'+contact->changwat
	? spac(11)+iif(name='    ','','จ.'+trim(name))
	?
*	?? CHR(27)+'J'+CHR(2)
	?
	set prin off
	SET CONS ON
	
