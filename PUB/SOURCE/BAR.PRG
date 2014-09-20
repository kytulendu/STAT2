
**:*****************************************************************************
*:
*: Procedure file: D:\CAME\BAR.PRG
*:
*:         System: bar
*:         Author: nitana
*:      Copyright (c) 1993, nitana
*:  Last modified: 09/10/93      9:31
*:
*:  Procs & Fncts: ERR1
*:               : YOURCHOICE
*:               : REQ_PRINTER
*:               : REFER1
*:               : DESREFER
*:               : TIMEREFER1
*:               : TIMEREFER2
*:               : INST_REFER
*:               : R1_CAME
*:               : DESCAME
*:               : TIMEIN
*:               : ENTRYDATE()
*:               : CHKDATE()
*:               : INSTCAME
*:               : APPOINT1
*:               : SELECT_DATE
*:               : REPORT1
*:               : PRINT_RE1
*:               : REPORT2
*:               : PRINT_RE2
*:               : REPORT3
*:               : PRINT_RE3
*:               : PHEAD
*:               : APPOINT2
*:               : ERRHANDLE
*:               : COMPUTE1
*:               : COMPUTE2
*:               : COMPUTE31
*:               : COMPUTE32
*:               : COMPUTE5
*:               : COMPUTE7
*:               : TAKE
*:               : CAPTURE_FIELD
*:               : MANYANS
*:               : CHECKY()
*:               : DESAPPOINT
*:               : COMPUTE4
*:               : PRINT_TIME
*:               : INTVAR
*:               : LAB
*:               : INST_APP
*:               : RETRIVEFILE
*:               : MOVEPROC
*:               : OTHER1
*:               : CAPFILE
*:               : PROCESS
*:               : JOBNOTMEMO
*:               : PRINTOTHER
*:
*:          Calls: MESSAGE()          (function  in ?)
*:               : ERROR()            (function  in ?)
*:               : ERR1               (procedure in BAR.PRG)
*:               : YOURCHOICE         (procedure in BAR.PRG)
*:
*:      Documented 09/14/93 at 08:55               FoxDoc  version 2.10f
*:*****************************************************************************
******			program bar       	************
****** ต้องใช้ร่วมกับ แฟ้ม utility.prg		**********
****** diag.mem,lan.mem , R504.DBF                     **********
****** PROC req_printer, err1, yourchoice, REFER1, desREFER, inst_refer
****** timeREFER2, timeREFER1, R1_came, desCAME, timeIN, SELECT_DATE
****** appoint1, appoint2,inst_app,instCAME, REPORT1, PRINT_RE1
****** REPORT2,PRINT_RE2,REPORT3, PRINT_RE3, req_printer, PHEAD
****** desAPPOINT,retriveFILE,CAPTURE_field,MANYans,other1
deac popup all
deac window all
clea
close data
*on error do err1 with message(),error()
set print to
if file('opdfile.dat')
   dele file opdfile.dat
endi
define wind showmass from 4,10 to 9,50 shadow
define menu pickfile
define pad one of pickfile prompt ' came  ' at 1,3
define pad two of pickfile prompt '  appoint ' at 1,18
define pad thr of pickfile prompt '   refer  ' at 1,36
define pad fou of pickfile prompt '   other  ' at 1,54
define pad fiv of pickfile prompt 'QUIT   ' at 1,72
on pad one of pickfile activ popup came_list
on pad two of pickfile activ popup appo_list
on pad thr of pickfile activ popup refer_list
on pad fou of pickfile activ popup other_list
on pad fiv of pickfile activ popup quit_list

define popup came_list margin
define bar 1 of came_list prompt '1.optional report';
   message 'รายงานเผื่อเลือก ข้อมูลการมาตรวจ'
define bar 2 of came_list prompt '2.install';
   message  'ติดตั้งข้อกำหนด ข้อมูลการมาตรวจ'
define popup refer_list margin
define bar 1 of refer_list prompt '1.refer';
   message 'รายงานเผื่อเลือก ข้อมูลการ REFER'
define bar 2 of refer_list prompt '2.install';
   message 'ติดตั้งข้อกำหนด ข้อมูลการ REFER'
define popup appo_list margin 	&& เลือก REFER
define bar 1 of appo_list prompt '1.routine report';
   message 'รายงานประจำ ข้อมูลการนัดหมาย'
define bar 2 of appo_list prompt '2.optional report';
   message 'รายงานเผื่อเลือก ข้อมูลการนัดหมาย'
define bar 3 of appo_list prompt '3.install';
   message 'ติดตั้งข้อกำหนด ข้อมูลการนัดหมาย'
define popup other_list margin 	&& เลือก other
define bar 1 of other_list prompt 'fields';
   message 'crosstab ตัวแปร'
define popup quit_list margin
define bar 1 of quit_list prompt 'เลิกงาน'

on selection popup all do yourchoice
activ menu pickfile
*!*****************************************************************************
*!
*!      Procedure: YOURCHOICE
*!
*!      Called by: BAR.PRG
*!
*!          Calls: POPUP()            (function  in ?)
*!               : LEFT()             (function  in ?)
*!               : PROMPT()           (function  in ?)
*!               : APPOINT1           (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!               : INST_APP           (procedure in BAR.PRG)
*!               : R1_CAME            (procedure in BAR.PRG)
*!               : INSTCAME           (procedure in BAR.PRG)
*!               : REFER1             (procedure in BAR.PRG)
*!               : INST_REFER         (procedure in BAR.PRG)
*!               : OTHER1             (procedure in BAR.PRG)
*!
*!*****************************************************************************
proc yourchoice
clea
do case
CLOSE DATA
case popup() ='APPO_LIST'
   if left(prompt(),1)='1'
      hide menu pickfile
      hide popup appo_list
      do appoint1
      show menu pickfile
      show popup appo_list
   else
      if left(prompt(),1)='2'
         hide menu pickfile
         hide popup appo_list
         do appoint2
         show menu pickfile
         show popup appo_list
      else
         if left(prompt(),1)='3'
            hide menu pickfile
            hide popup appo_list
            do inst_app
            show menu pickfile
            show popup appo_list
         endi
      endi
   endi
case popup() ='CAME_LIST'
   if left(prompt(),1)='1'
      hide menu pickfile
      hide popup came_list
      do r1_came
      show menu pickfile
      show popup came_list
   else
      hide menu pickfile
      hide popup came_list
      do instcame
      show menu pickfile
      show popup came_list
   endi
case popup() ='REFER_LIST'
   if left(prompt(),1)='1'
      hide menu pickfile
      hide popup refer_list
      do refer1
      show menu pickfile
      show popup refer_list
   else
      if left(prompt(),1)='2'
         hide menu pickfile
         hide popup refer_list
         do inst_refer
         show menu pickfile
         show popup refer_list
      endi
   endi
case popup() ='OTHER_LIST'
   hide menu pickfile
   hide popup other_list
   do other1
   show menu pickfile
   show popup other_list
other
   deact menu
*   close data
endcase
close data
*do opencamedbf
retu   			&& end main program
*!*****************************************************************************
*!
*!      Procedure: ERR1
*!
*!      Called by: BAR.PRG
*!
*!          Calls: LTRIM()            (function  in ?)
*!               : STR()              (function  in ?)
*!               : MESSAGE()          (function  in ?)
*!               : LASTKEY()          (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!*****************************************************************************
proc err1
para message,errnum
deac wind all
@ 21,0 say message+ ' ERROR: '+ltrim(str(errnum))
do case
case errnum=10
   @ 22,5 say ' กลับไป install ก่อน'
case errnum=125
   set esca off
   wait message()+' กดปุ่ม [Esc] ถ้าไม่พิมพ์' wind nowa
   _mkey=lastkey()
   if _mkey=27
      set print off
      set cons on
   endi
   set esca on
case errnum=12
   wait ' กลับไป install ก่อน ' wind nowa
other
   *   @ 22,5 say message
endc
=inkey(4)
clea
retu  to master
*!*****************************************************************************
*!
*!      Procedure: REFER1
*!
*!      Called by: YOURCHOICE         (procedure in BAR.PRG)
*!
*!          Calls: REQ_PRINTER        (procedure in BAR.PRG)
*!               : FILE()             (function  in ?)
*!               : INKEY()            (function  in ?)
*!               : TAKE               (procedure in BAR.PRG)
*!               : DESREFER           (procedure in BAR.PRG)
*!               : RIGHT()            (function  in ?)
*!               : STR()              (function  in ?)
*!               : ENTRYDATE()        (function  in BAR.PRG)
*!               : SPACE()            (function  in ?)
*!               : LASTKEY()          (function  in ?)
*!               : LEFT()             (function  in ?)
*!               : RIGH()             (function  in ?)
*!               : INT()              (function  in ?)
*!               : VAL()              (function  in ?)
*!               : ERRHANDLE          (procedure in BAR.PRG)
*!               : IIF()              (function  in ?)
*!               : LTRIM()            (function  in ?)
*!               : TIMEREFER1         (procedure in BAR.PRG)
*!               : TIMEREFER2         (procedure in BAR.PRG)
*!               : MANYANS            (procedure in BAR.PRG)
*!               : COMPUTE4           (procedure in BAR.PRG)
*!               : PRINT_TIME         (procedure in BAR.PRG)
*!               : CHR()              (function  in ?)
*!               : COMPUTE5           (procedure in BAR.PRG)
*!               : CAPTURE_FIELD      (procedure in BAR.PRG)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : COMPUTE2           (procedure in BAR.PRG)
*!               : EOF()              (function  in ?)
*!               : COMPUTE1           (procedure in BAR.PRG)
*!
*!           Uses: &AAREFER               Alias: APPO
*!               : CLINIC.DBF             Alias: CLINIC
*!
*!   Memory Files: DIAG.MEM
*!
*!*****************************************************************************
proc refer1
close data
print_flag=.t.		&& printer
on key label ctrl+p do req_printer with print_flag
do req_printer with print_flag
store 0 to othervar
store 1 to selefield,fieldwide,fieldmax
fname=""
if ! file('diag.mem')
   @ 8,10 say 'ไม่มี file DIAG.MEMO ต้อง install ก่อน'
   =inkey(4)
   @ 8,2 clea
   return
else
   rest from diag addi
endi
nnn=aarefer+'.DBF'
if ! file(opddir+NNN)
   @ 8,10 say 'หา file REFER ไม่พบ ต้อง install ชื่อใหม่'
   =inkey(4)
   @ 8,2 clea
   return
endi
sele 0
dbfuse = opddir+aarefer
use (opddir+aarefer) alia appo
sele 0
dbfuse = codedir+'clinic'
use (codedir+'clinic') order 1 alia clinic
sele appo
dbfuse = ''
do take with selefield,fieldwide,fieldmax,fname  && เลือก เขตข้อมูล
do desrefer with fieldwide,fieldmax,fname
dime aa(fieldmax),bb(fieldmax),desaa(fieldmax),y(3)
heading='ข้อมูลการ REFER พ.ศ. 25'+right(aarefer,2)+' '
datefield=2   && refer date
if str(selefield,1) $'3,5,6,7,8'
   stor '0103' to be_date,to_date
   @ 18,10 say 'วันที่รับ/ส่ง REFER'
   @ 20,1 say 'ตั้งแต่ (DDMM)' get be_date pict '@R 99/99';
      mess 'พิมพ์ 99 ถ้าต้องการผลรวมตั้งแต่ต้นปี'
   @ 20,22 say 'ถึง (DDMM)' get to_date pict '@R 99/99';
      when entrydate(be_date) mess space(30)
   READ NOLOCK
   if lastkey()=27
      clea
      retu to master
   endi
   if left(be_date,2)<>'99'
      finddate=righ(be_date,2)+left(be_date,2)
      enddate=righ(to_date,2)+left(to_date,2)
      monthbe=tmonth(int(val(left(finddate,2))))
      monthto=tmonth(int(val(left(enddate,2))))
      heading=heading+' ('+left(be_date,2)+' '+;
         monthbe+'-'+left(to_date,2)+' '+monthto+')'
   endi
endi
go top
do case
case selefield=2			&& เลือกวัน refer (date)
   on readerror do errhandle
   choose=1
   @ 19,1 say 'พิมพ์เลขเดือน ถ้าต้องการผลเฉพาะเดือนนั้น '
   @ 20,8 say ' หรือ  '
   @ 21,1 say 'พิมพ์ "0" ถ้าต้องการผลทุกเดือน  '
   @ 22,8 get choose pict '99' range 0,12
   READ NOLOCK
   if choose>=1 .and. choose <=12
      mm_con=iif(choose > 9,ltrim(str(choose)),'0'+ltrim(str(choose)))
      heading=heading+'เดือน '+month&mm_con
      fname='วันที่ REFER'
      do timerefer1
   else
      set filt to type='1'
      seco_head=heading
      heading=heading+'['+'รับ REFER'+']'
      fname='เดือนที่ REFER'
      do timerefer2
      set filt to
      set filt to type='2'
      go top
      heading=seco_head+'['+'ส่ง REFER'+']'
      do timerefer2
      set filt to
   endi
case selefield=3		&& time
   condition2=2
   do manyans with condition2
   set filt to type='1'
   go top
   seco_head=heading
   heading=heading+'['+'รับ REFER'+']'
   do compute4             && เลือกเวลา refer (time)
   do print_time
   set filt to
   set filt to type='2'
   go top
   heading=seco_head+'['+'ส่ง REFER'+']'
   do compute4             && เลือกเวลา refer (time)
   do print_time
   set filt to
case selefield=4				&& PLACE
   @ 8,6 say 'ให้ใช้ภาษา query ทำรายงาน'
   ?? chr(7)
   =inkey(4)
   clea
case selefield=5             && diag
   fieldmax=aaa
   for k=1 to fieldmax
      desaa(k)=aa(k)
   endf
   set filt to type='1'
   visitdate=2	            && วันที่ refer
   seco_head=heading
   heading=space(6)+heading+'['+'รับ REFER'+']'
   do compute5
   set filt to
   set filt to type='2'
   heading=space(6)+seco_head+'['+'ส่ง REFER'+']'
   do compute5
   set filt to
case selefield=6	   	     && เหตุผล
   desaa(1)='1.วินิจฉัย ชันสูตรและส่งกลับ'
   desaa(2)='2.ด้านบุคคลากร'
   desaa(3)='3.ด้านเครื่องมือ สถานที่'
   desaa(4)='4.ทั้งข้อ 2 และ 3'
   desaa(5)='5.ด้านวิชาการ'
   desaa(6)='6.ไม่จำเป็น'
   desaa(7)='7.ผู้ป่วย/ญาติต้องการ'
   desaa(8)='8.ต้องการใช้สิทธิ'
   for k=1 to 8
      aa(k)=ltrim(str(k))
   endfor
   condition2=2
   textcon=space(10)
   do capture_field with condition2,textcon
   if condition2>1
      set filt to textcon $eval(field(condition2)) .and. type='1'
   else
      set filt to type='1'
   endi
   seco_head=heading
   heading=heading+'['+'รับ REFER'+']'
   do compute2
   heading=seco_head+'['+'ส่ง REFER'+']'
   if condition2>1
      set filt to textcon $eval(field(condition2)) .and. type='2'
   else
      set filt to type='2'
   endi
   do compute2
   set filt to
case selefield=7       && clinic
   sele clinic
   k=1
   do whil ! eof()
      aa(k)=eval(field(1))
      desaa(k)=left(name,25)
      skip
      k=k+1
   endd
   sele appo
   set filt to type='1'
   go top
   seco_head=heading
   heading=heading+'['+'รับ REFER'+']'
   do compute1
   set filt to
   set filt to type='2'
   go top
   heading=seco_head+'['+'ส่ง REFER'+']'
   do compute1
   set filt to
case selefield=8 					&& type
   aa(1)='1'
   aa(2)='2'
   desaa(1)='รับ REFER '
   desaa(2)='ส่ง REFER '
   do compute1
other
   ??chr(7)
   @ 8,5 say 'ให้ใช้ ภาษา query ทำรายงาน'
   =inkey(3)
   clea
endcase
retu
*!*****************************************************************************
*!
*!      Procedure: DESREFER
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!
*!          Calls: RECCOUNT()         (function  in ?)
*!
*!*****************************************************************************
proc desrefer
para fwide,fmax,namefield
do case
case selefield=2
   fwide=4
   namefield='วันที่'
   fmax=10
case selefield=3
   fwide=4
   namefield='เวลา REFER'
   fmax=24
case selefield=4
   fwide=12
   namefield='สถานที่'
   fmax=10
case selefield=5
   fwide=5
   namefield='การวินิจฉัย'
   fmax=10
case selefield=6
   namefield='สาเหตุการส่งต่อผู้ป่วย'
   fwide=2
   fmax=8
case selefield=7
   namefield='คลีนิค'
   fwide=3
   sele clinic
   fmax=reccount()
case selefield=8
   namefield='ประเภทการ REFER'
   fwide=1
   fmax=2
endcase
retu
*!*****************************************************************************
*!
*!      Procedure: TIMEREFER1
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!
*!          Calls: IIF()              (function  in ?)
*!               : STR()              (function  in ?)
*!               : EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : LEFT()             (function  in ?)
*!               : RIGHT()            (function  in ?)
*!               : VAL()              (function  in ?)
*!               : LTRIM()            (function  in ?)
*!               : SPAC()             (function  in ?)
*!               : LEN()              (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc timerefer1
clea
stor 0 to mtotal1,mtotal2
dime bb(31,2)
for j=1 to 31
   for k=1 to 2
      bb(j,k)=0
   next
endfor
chrchoose=iif(choose<10,'0'+str(choose,1),str(choose,2))
sele appo
do scale
do whil ! eof()
   if ! empty(hn)
      rr=eval(field(selefield))
      if left(rr,2)=chrchoose
         rr=right(rr,2)
         rr=val(rr)
         ty=val(type)
         bb(rr,ty)=bb(rr,ty)+1
         copytype=type
         mtotal&copytype=mtotal&copytype+1
      endi
   endi
   skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
enddo
deac wind keep
if print_flag	&& เครื่องพิมพ์
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
newhead=heading+'(รับ REFER)'
for t=1 to 2
   chrt=ltrim(str(t))
   ? spac(20),newhead
   ?
   ? spac(3),fname,spac(13-len(fname)),'จำนวนครั้ง ',' ร้อยละ'
   ?? spac(4),fname,spac(13-len(fname)),'จำนวนครั้ง ',' ร้อยละ'
   ?
   for i= 1 to 15
      ?space(5),tran(i,'##'),space(9),tran(bb(i,t),'####'),space(4)
      ??tran(100*bb(i,t)/mtotal&chrt,'#####.##'),'  |'
      ?? spac(4),tran(15+i,'##'),space(9),tran(bb(15+i,t),'####'),space(5)
      ??tran(100*bb(15+i,t)/mtotal&chrt,'#####.##')
   endfor
   ?space(36),'  |    ',tran(31,'##'),space(10),tran(bb(31,t),'###'),space(5)
   ??tran(100*bb(11,t)/mtotal&chrt,'#####.##')
   ?
   ?space(44),'รวม  ',spac(3),tran(mtotal&chrt,'###,###'),spac(9),'100'
   ?
   if print_flag .and. sys(102)='ON'
      eject
      set cons on
   else
      =inkey(4)
   endi
   clea
   newhead=heading+'(ส่ง REFER)'
next
set print off
set cons on
retu
*!*****************************************************************************
*!
*!      Procedure: TIMEREFER2
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!
*!          Calls: EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : LEFT()             (function  in ?)
*!               : VAL()              (function  in ?)
*!               : SPAC()             (function  in ?)
*!               : LEN()              (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc timerefer2
clea
mtotal=0
dime bb(12)
for j=1 to 12
   bb(j)=0
endfor
sele appo
do scale
do whil ! eof()
   if ! empty(hn)
      rr=eval(field(selefield))
      rr=left(rr,2)
      rr=val(rr)
      bb(rr)=bb(rr)+1
      mtotal=mtotal+1
   endi
   skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
enddo
deac wind keep
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
? spac(10),heading
?
? spac(5),fname,spac(17-len(fname)),'จำนวนครั้ง ',spac(10),'ร้อยละ'
?
for i= 1 to 12
   ? spac(7),tran(i,'##'),space(16),tran(bb(i),'####'),space(12)
   ??tran(100*bb(i)/mtotal,'#####.##')
endfor
?
? spac(7),'รวม  ',spac(13-len('รวม')),tran(mtotal,'###,###'),spac(13),'100.00'
?
if print_flag .and. sys(102)='ON'
   eject
else
   =inkey(4)
endi
clea
set print off
set cons on
retu
*!*****************************************************************************
*!
*!      Procedure: INST_REFER
*!
*!      Called by: YOURCHOICE         (procedure in BAR.PRG)
*!
*!          Calls: FILE()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : LTRIM()            (function  in ?)
*!               : STR()              (function  in ?)
*!               : LASTKEY()          (function  in ?)
*!               : IIF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!
*!   Memory Files: DIAG.MEM
*!
*!*****************************************************************************
proc inst_refer
clea
dime listmain(3)
listmain(1)=' แฟ้มข้อมูลการ REFER'
listmain(2)=' การวินิจฉัย'
listmain(3)=' เลิกงาน'
@5,10 menu listmain,3 title ' รายการกำหนดค่าตัวแปร  '
read menu to requ
clea
if requ=3
   retu
endi
if file('DIAG.MEM')
   rest from diag addi
endi
do case
case requ=1
   aarefer=space(7)
   @8,10 say 'พิมพ์ชื่อแฟ้มข้อมูล  ' get aarefer pict '@!' ;
      mess 'ตย. REFER36'
   READ NOLOCK
case requ=2
   *        publ aa(10)
   dime aa(10)
   k=1
   @3,6 to 24,71 double
   @3,6 to 20,71 double
   @21,10 say 'กำหนดได้สูงสุด 10 รายการ และต้องพิมพ์รหัส ICD10 เต็ม 5 หลัก'
   @22,10 say 'กด ESC เมื่อ ไม่ครบ 10 รายการ'
   @23,10 say 'ตย. "B0510,B0530,B1500-B1900" '
   do whil .t.
      aa(k)=space(24)
      @k+4,10 say 'no.'+ltrim(str(k))+space(5) get aa(k) pict '@!'
      READ NOLOCK
      k=k+1
      if lastkey()=5 .or. lastkey()=19 .or. lastkey()=18  && up,left,pgup
         k=k-2
      endi
      if k>=11 .or. lastkey()=27
         exit
      endi
   endd
   aaa=iif(lastkey()=27,k-2,k-1)
   de=0
   for p=aaa to 1 step -1
      de=iif(empty(aa(p)),de+1,de)
   next
   aaa=aaa-de
endca
dele file diag.mem
save to diag all like aa*
clea
retu
*!*****************************************************************************
*!
*!      Procedure: R1_CAME
*!
*!      Called by: YOURCHOICE         (procedure in BAR.PRG)
*!
*!          Calls: REQ_PRINTER        (procedure in BAR.PRG)
*!               : FILE()             (function  in ?)
*!               : INKEY()            (function  in ?)
*!               : TAKE               (procedure in BAR.PRG)
*!               : DESCAME            (procedure in BAR.PRG)
*!               : RIGHT()            (function  in ?)
*!               : STR()              (function  in ?)
*!               : CE2BE()            (function  in ?)
*!               : DATE()             (function  in ?)
*!               : ENTRYDATE()        (function  in BAR.PRG)
*!               : CHKDATE()          (function  in BAR.PRG)
*!               : SPACE()            (function  in ?)
*!               : LASTKEY()          (function  in ?)
*!               : LEFT()             (function  in ?)
*!               : BE2CE()            (function  in ?)
*!               : ERRHANDLE          (procedure in BAR.PRG)
*!               : COMPUTE31          (procedure in BAR.PRG)
*!               : COMPUTE32          (procedure in BAR.PRG)
*!               : EOF()              (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : COMPUTE1           (procedure in BAR.PRG)
*!               : MANYANS            (procedure in BAR.PRG)
*!               : TIMEIN             (procedure in BAR.PRG)
*!               : PRINT_TIME         (procedure in BAR.PRG)
*!               : COMPUTE5           (procedure in BAR.PRG)
*!               : LTRIM()            (function  in ?)
*!               : IIF()              (function  in ?)
*!               : AAGELOW()          (function  in ?)
*!               : AAGEUP()           (function  in ?)
*!               : COMPUTE7           (procedure in BAR.PRG)
*!               : CHR()              (function  in ?)
*!
*!           Uses: &AAFILENAME            Alias: APPO
*!               : CLINIC.DBF             Alias: CLINIC
*!               : DOCTOR.DBF             Alias: DOCTOR
*!               : SOCIAL.DBF             Alias: SOCIAL
*!
*!   Memory Files: DIAG.MEM
*!
*!*****************************************************************************
proc r1_came
close data
print_flag=.t.		&& printer
on key label ctrl+p do req_printer with print_flag
do req_printer with print_flag
store 0 to othervar
store 1 to selefield,fieldwide,fieldmax
fname=""
if ! file('diag.mem')
   @ 8,10 say 'ไม่มี file ข้อมูลการมาตรวจ ต้อง install ก่อน'
   =inkey(4)
   @ 8,2 clea
   return
else
   rest from diag addi
endi
if ! file(opddir+aafilename+".dbf")
   @ 8,10 say 'หา file ข้อมูลการมาตรวจ ไม่พบ ต้อง install ใหม่'
   =inkey(4)
   @ 8,2 clea
   return
endi
sele 0
dbfuse = opddir+aafilename
USE (opddir+aafilename) alia appo
sele 0
dbfuse = codedir+'clinic'
USE (codedir+'clinic') order 1 alia clinic
sele 0
dbfuse = codedir+'doctor'
USE (codedir+'doctor') alia doctor
sele 0
dbfuse = codedir+'social'
USE (codedir+'social') alia social
sele appo
dbfuse = ''
datefield=2       && วันที่มาตรวจ
do take with selefield,fieldwide,fieldmax,fname  && เลือก เขตข้อมูล
   if lastkey()=27
      clea
      retu to master
   endi
do descame with fieldwide,fieldmax,fname
dime aa(fieldmax),bb(fieldmax),desaa(fieldmax),y(3)
mmcame=right(aafilename,2)
heading='ข้อมูลการมาตรวจ เดือน'+month&mmcame
if str(selefield,1) $'3,4,5,6,7,8,9';
      .or. str(selefield,2) $'10,13,15,16'
   cdate = ce2be(date())
   stor cdate to be_date,to_date
   @ 19,3 say 'ตั้งแต่  ' get be_date pict '99/99/9999';
      mess 'พิมพ์ 99 ถ้าต้องการผลทั้งเดือน'
   @ 20,3 say 'ถึง      ' get to_date  pict '99/99/9999';
      when entrydate(be_date) valid chkdate(to_date)
   READ NOLOCK
* 24,0 clea
   if lastkey()=27
      clea
      retu to master
   endi
   if left(be_date,2) <> '99'
      finddate=be2ce(be_date)
      enddate =be2ce(to_date)
      heading=heading+' ('+be_date+'-'+to_date+')'
   endi
endi
defin wind caseper from 19,25 to 22,40 title 'นับแบบ'
acti wind caseper
  @0,3 prompt '1.CASE  '
  @1,3 prompt '2.PERSON'
  store 1 to choicecase
menu to choicecase
rele wind caseper
   if lastkey()=27
      clea
      retu to master
   endi
sele appo
if choicecase=2
   set filt to sequence=1	&& count person
   heading=heading+'(นับคน)'
else
   heading=heading+'(นับครั้ง)'
endi
go top
do case
case selefield=2                     && เลือกวันมาตรวจ  (date)
   on readerror do errhandle
   choose=1
   @ 19,1 say 'พิมพ์เลขเดือน ถ้าต้องการระบุเดือน  '
   @ 20,8 say ' หรือ  '
   @ 21,1 say 'พิมพ์ "0" ถ้าต้องการผลทุกเดือน  '
   @ 22,8 get choose pict '99' range 0,12
   READ NOLOCK
   if choose>=1 .and. choose <=12
      fname='วันที่มาตรวจ'
      do compute31
   else
      fname='เดือนที่มาตรวจ'
      do compute32
   endi
case selefield=3       && clinic
   sele clinic
   k=1
   do whil ! eof()
      aa(k)=eval(field(1))
      desaa(k)=left(name,25)
      skip
      k=k+1
   endd
   do compute1
case selefield=4                       && t_in
   condition2=2
   do manyans with condition2
   do timein
   fname='เวลาที่สูญเสีย'
   do print_time
case selefield=5
   condition2=2
   do manyans with condition2
   *        namefield='เวลาที่สูญเสีย'
   do timein                           && t_out
   fname='เวลาที่สูญเสีย'
   do print_time
case selefield=6                       && doctor
   sele doctor
   k=1
   do whil ! eof()
      aa(k)=eval(field(1))
      desaa(k)=left(name,25)
      skip
      k=k+1
   endd
   do compute1
case selefield=7             		&& diag
   fieldmax=aaa
   for k=1 to fieldmax
      desaa(k)=aa(k)
   endf
   visitdate=2		&& วันที่มา รพ.
   do compute5
case selefield=8            && rem_c
   desaa(1)='มาตามนัด'
   desaa(2)='มาเอง'
   desaa(3)='รับ consult'
   desaa(4)='รับ refer'
   for k=1 to 4
      aa(k)=ltrim(str(k))
   endfor
   do compute1
case selefield=9            && episode
   aa(1)='1'
   aa(2)='2'
   aa(3)='3'
   desaa(1)='ผู้ป่วยใหม่'
   desaa(2)='ผู้ป่วยเก่า'
   desaa(3)='ผู้ป่วยติดตามโรค'
   do compute1
case selefield=10                && result
   desaa(01)='รับไว้แผนกอายุรกรรม'
   desaa(02)='รับไว้แผนกศัลยกรรม'
   desaa(03)='รับไว้แผนกสูติกรรม'
   desaa(04)='รับไว้แผนกนรีเวชกรรม'
   desaa(05)='รับไว้แผนกกุมารเวชกรรม'
   desaa(06)='รับไว้แผนกหู คอ จมูก'
   desaa(07)='รับไว้แผนกจักษุ'
   desaa(08)='รับไว้แผนกศัลยกรรมกระดูก'
   desaa(09)='รับไว้แผนกจิตเวช'
   desaa(10)='รับไว้แผนกรังสีวิทยา'
   desaa(11)='รับไว้แผนกทันตกรรม'
   desaa(12)='รับไว้แผนกอื่น ๆ'
   desaa(13)='ตรวจและกลับบ้าน'   && 51
   desaa(14)='ตายที่โอพีดี'      && 52
   desaa(15)='CONSULT'           && 53
   desaa(16)='REFER'             && 54
   for k=1 to 9
      aa(k)='0'+ltrim(str(k))
   endfor
   for kk=10 to 16
      aa(kk)=iif(kk<=12,ltrim(str(kk)),ltrim(str(kk+38)))
   endfor
   do compute1
case selefield=12               && AGE
   fieldmax=aagegr
   for k=1 to fieldmax
      desaa(k)=ltrim(str(aagelow(k)))+' - '+ltrim(str(aageup(k)))
   endf
   condition2=2
   do manyans with condition2
   do compute7
case selefield=13               && FC สิทธิการรักษา
   sele social
   k=1
   do whil ! eof()
      aa(k)=eval(field(1))
      desaa(k)=left(name,25)
      skip
      k=k+1
   endd
   do compute1
case selefield=15          && เลือกวันเริ่มป่วย  (ill_date)
   if ! file('diag.mem')
      @1,20 say 'กลับไป INSTALL DIAG ก่อน'
   else
      rest from diag.mem addi
   endi
   fieldmax=aaa
   for k=1 to fieldmax
      desaa(k)=aa(k)
   endf
   if ! file('diag.mem')
      @1,20 say 'กลับไป INSTALL DIAG ก่อน'
   else
      rest from diag.mem addi
   endi
   fieldmax=aaa
   for k=1 to fieldmax
      desaa(k)=aa(k)
   endf
   visitdate=15	&&  วันที่เริ่มป่วย
   sele appo
   set filt to
   do compute5
case selefield=16
   aa(1)='1'
   aa(2)='2'
   desaa(1)='ในเขตจังหวัด'
   desaa(2)='นอกเขตจังหวัด'
   do compute1
other
   ??chr(7)
   @ 8,5 say 'ให้ใช้ ภาษา query ทำรายงาน'
   =inkey(3)
   clea
endcase
set filt to
retu
*!*****************************************************************************
*!
*!      Procedure: DESCAME
*!
*!      Called by: R1_CAME            (procedure in BAR.PRG)
*!
*!          Calls: RECCOUNT()         (function  in ?)
*!
*!*****************************************************************************
proc descame
para fwide,fmax,namefield
do case
case selefield=2
   fwide=8
   namefield='วันที่มาตรวจ'
   fmax=12
case selefield=3
   namefield='คลีนิค'
   fwide=3
   sele clinic
   fmax=reccount()
case selefield=4				&& t_in
   namefield='เวลาที่มาติดต่อ'
   fwide=4
   fmax=10
case selefield=5             && t_out
   fwide=4
   namefield='เวลาที่ตรวจเสร็จ'
   fmax=10
case selefield=6
   namefield='แพทย์ที่ให้การรักษา'
   fwide=5
   sele doctor
   fmax=reccount()
case selefield=7             && diag
   namefield='การวินิจฉัย'
   fwide=5
   fmax=10
case selefield=8
   namefield='การมาตรวจตามนัด'
   fwide=1
   fmax=4
case selefield=9
   namefield='ผู้ป่วยโรคเก่าหรือโรคใหม่'
   fwide=1
   fmax=3
case selefield=10			&& result
   namefield='ผลการมาตรวจ'
   fwide=2
   fmax=16
case selefield=11
   namefield='ประเภทอายุ'
   fwide=1
   fmax=3
case selefield=12
   namefield='อายุ'
   fwide=2
   fmax=10
case selefield=13
   namefield='สิทธิการรักษา'
   fwide=2
   sele social
   fmax=reccount()
case selefield=14
   namefield='ลำดับที่'
   fwide=1
   fmax=4
case selefield=15	&&  'วันเริ่มป่วย'
   namefield='การวินิจฉัย'
   fwide=8
   fmax=10
case selefield=16
   namefield='ที่อยู่ผู้ป่วย'
   fwide=1
   fmax=2
case selefield=17
   namefield='เพศ'
   fwide=1
   fmax=2
case selefield=18
   namefield=''
   fwide=1
   fmax=2
endcase
retu
*!*****************************************************************************
*!
*!      Procedure: TIMEIN
*!
*!      Called by: R1_CAME            (procedure in BAR.PRG)
*!
*!          Calls: EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : ASCAN()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : IIF()              (function  in ?)
*!               : INT()              (function  in ?)
*!
*!*****************************************************************************
proc timein
dime bb(25,3)
clea
for j=1 to 3
   for i=1 to 25
      bb(i,j)=0
   endfor
next
sele appo
go top
do scale
do whil ! eof()
   if ! empty(hn)
      if condition2 >1
         seat=ascan(y,eval(field(condition2)))
         if seat =0
            skip
            loop
         endi
      else
         seat=1
      endi
      rr=iif(t_out>t_in,int((t_out - t_in)/60),25)
      if rr=0
         rr=24
      endi
      bb(rr,seat)=bb(rr,seat)+1
   endi
   skip
   if recno()*10/retot >ten .and. ten <10
       do success
   endi
enddo
deac wind keep
retu
*!*****************************************************************************
*!
*!       Function: ENTRYDATE()
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: IIF()              (function  in ?)
*!               : LEFT()             (function  in ?)
*!
*!*****************************************************************************
func entrydate
para _begin
show gets
retu iif(left(_begin,2)='99',.f.,.t.)
*!*****************************************************************************
*!
*!       Function: CHKDATE()
*!
*!      Called by: R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: BE2CE()            (function  in ?)
*!               : FOUND()            (function  in ?)
*!               : LASTKEY()          (function  in ?)
*!
*!*****************************************************************************
func  chkdate
para todate
finddat=be2ce(be_date)
enddat =be2ce(to_date)
if enddat < finddat
     wait ' พิมพ์ช่วงวันที่ผิด ตรวจสอบแล้วพิมพ์ใหม่' wind nowait
     _curobj=_curobj-1
     retu
endi
if finddat = enddat
   sele appo
   loca for appo.date=finddat
   if ! found()
      go top
      wait ' ไม่มีการนัดคนไข้วันนี้  ' wind nowait
      _curobj=_curobj-1
   endi
endi
if lastkey()=4 .or. lastkey()=5
   _curobj=_curobj-1
endi
retu
*!*****************************************************************************
*!
*!      Procedure: INSTCAME
*!
*!      Called by: YOURCHOICE         (procedure in BAR.PRG)
*!
*!          Calls: FILE()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : LTRIM()            (function  in ?)
*!               : STR()              (function  in ?)
*!               : LASTKEY()          (function  in ?)
*!               : IIF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : TRAN()             (function  in ?)
*!
*!   Memory Files: DIAG.MEM
*!
*!*****************************************************************************
proc instcame
clea
dime listmain(4)
listmain(1)=' แฟ้มการมาตรวจ'
listmain(2)=' การวินิจฉัย'
listmain(3)=' อายุ'
listmain(4)=' เลิกงาน'
@5,10 menu listmain,4 title ' รายการกำหนดค่าตัวแปร  '
read menu to requ
clea
if requ=4
   retu
endi
if file('DIAG.MEM')
   rest from diag addi
endi
do case
case requ=1
   aafilename=space(4)
   @8,10 say 'พิมพ์ชื่อแฟ้มข้อมูล(CAME) ' get aafilename pict '@NN-NN';
      mess 'YYMM'
   READ NOLOCK
   aafilename='CAME'+aafilename
case requ=2
   dime aa(10)
   k=1
   @3,6 to 24,71 double
   @3,6 to 20,71 double
   @21,10 say 'กำหนดได้สูงสุด 10 รายการ และต้องพิมพ์รหัส ICD10 เต็ม 5 หลัก'
   @22,10 say 'กำหนดช่วงไดัเพียง 1 ช่วง ตย. "B0510,B0530,B1500-B1900" '
   @23,10 say 'กด ESC เมื่อ ไม่ครบ 10 รายการ'
   do whil .t.
      aa(k)=space(24)
      @k+4,10 say 'no.'+ltrim(str(k))+space(5) get aa(k) pict '@!'
      READ NOLOCK
      k=k+1
      if k>=11 .or. lastkey()=27
         exit
      endi
      if lastkey()=5 .or. lastkey()=19 .or. lastkey()=18  && up,left,pgup
         k=k-2
      endi
   endd
   aaa=iif(lastkey()=27,k-2,k-1)
   de=0
   for p=aaa to 1 step -1
      de=iif(empty(aa(p)),de+1,de)
   next
   aaa=aaa-de
case requ=3
   dime aagelow(10),aageup(10),aagetype(10)
   k=1
   @1,1 to 16,70 double
   @1,1 to 20,70 double
   @2,27 say 'กำหนดช่วงกลุ่มอายุ'
   @17,4 say 'หมายเหตุ 1. กำหนดได้สูงสุด 10 รายการ ค่าสูงสุดของแต่ละช่วง'
   @18,15 say 'ของกลุ่มวันหรือเดือนหรือปีต้องเรียงจากน้อยไปหามาก'
   @19,12 say '2. กด ESC เมื่อ ไม่ครบ 10 รายการ'
   @ k+3,5 say 'อันดับที่  ค่าต่ำสุด      ค่าสูงสุด    วัน(3)/เดือน(2)/ปี(1)'
   do whil .t.
      aageup(k)=iif(k>1,aageup(k-1)+10,10)
      aagelow(k)=iif(k >1,aageup(k-1)+1,0)
      aagetype(k)='1'
      @k+4,7 say tran(k,'##')
      @k+4,18 get aagelow(k) pict '99';
         mess 'พิมพ์ค่าต่ำสุด ของแต่ละช่วง เช่น 05'
      @k+4,33 get aageup(k) pict '99';
         mess 'พิมพ์ค่าสูงสุด ของแต่ละช่วง เช่น 10'
      @k+4,49 get aagetype(k) mess ''
      READ NOLOCK
      k=k+1
      if lastkey()=5 .or. lastkey()=19 .or. lastkey()=18  && up,left,pgup
         k=k-2
      endi
      if k>=11 .or. lastkey()=27
         exit
         *           else
         *           aageGR=k
      endi
   endd
   *        if lastkey()=27
   *           aageGR=k-2
   *        endi
   aagegr=iif(lastkey()=27,k-2,k-1)
endca
dele file diag.mem
save to diag all like aa*
clea
retu
*!*****************************************************************************
*!
*!      Procedure: APPOINT1
*!
*!      Called by: YOURCHOICE         (procedure in BAR.PRG)
*!
*!          Calls: FILE()             (function  in ?)
*!               : INKEY()            (function  in ?)
*!               : REQ_PRINTER        (procedure in BAR.PRG)
*!               : DATE()             (function  in ?)
*!               : CHR()              (function  in ?)
*!               : REPL()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : ALLTRIM()          (function  in ?)
*!               : CE2BE()            (function  in ?)
*!               : SELECT_DATE        (procedure in BAR.PRG)
*!               : LASTKEY()          (function  in ?)
*!               : REPORT1            (procedure in BAR.PRG)
*!               : REPORT2            (procedure in BAR.PRG)
*!               : REPORT3            (procedure in BAR.PRG)
*!
*!           Uses: &AAAPPOINT             Alias: APPO
*!               : CLINIC.DBF             Alias: CLINIC
*!
*!   Memory Files: DIAG.MEM
*!
*!*****************************************************************************
proc appoint1
close data
***************   เปิด 2 แพ้ม  / EXTERNAL CALL = UTILITY.PRG,SERVICE.PRG
clea
if ! file('diag.mem')
   @ 8,10 say 'ไม่มี file MEMO ต้อง install ก่อน'
   =inkey(3)
   @ 8,2 clea
   return
else
   rest from diag addi
   nnn=aaappoint+'.DBF'
endi
if ! file(opddir+nnn)
   @ 8,10 say 'หา file ข้อมูลการนัดหมาย ไม่พบ ต้อง install ใหม่ ?.'
   =inkey(3)
   @ 8,2 clea
   return
endi
sele 0
dbfuse = opddir+aaappoint
USE (opddir+aaappoint) alia appoint
sele 0
dbfuse = codedir+'clinic'
USE (codedir+'clinic') order 1 alia clinic
dbfuse = ''
************
print_flag=.t.   && .t.= แสดงผลทางเครื่องพิมพ์
on key label ctrl+p do req_printer with print_flag
finddate=date()
@ 3,17 to 17,60 chr(15)
@ 4,18 say repl(' ',42)
@ 5,18 say repl(' ',16)+'รายการ      '+repl(' ',14)
@ 6,18 say repl(' ',42)
@ 7,18 say repl(chr(31),42)
@ 09,20 say '1.พิมพ์รายงาน เรียงตาม HN '
@ 11,20 say '2.พิมพ์รายงาน เรียงตาม CLINIC,HN'
@ 13,20 say '3.พิมพ์รายงาน เรียงตาม CLINIC,HN,LAB'
@ 14,18 to 17,59 chr(15)
@ 16,24 say 'ตัวอย่างการเลือกรายการ ===> 123'
do req_printer with print_flag
sele_reports=space(3)
@20,18 say 'เลือกรายการที่ ==> ' get sele_reports
READ NOLOCK
******************
sele_reports=alltrim(sele_reports)
if ('1' $ sele_reports) .or. ('2' $ sele_reports) .or.;
      ('3' $ sele_reports)
   date_flag = ce2be(date())
   do select_date with date_flag
   if lastkey()=27
      retu
   endi
endi
if '1' $ sele_reports
   do report1
endi
if '2' $ sele_reports
   do report2
endi
if '3' $ sele_reports
   do report3
endi
close data
retu
*!*****************************************************************************
*!
*!      Procedure: SELECT_DATE
*!
*!      Called by: APPOINT1           (procedure in BAR.PRG)
*!
*!          Calls: LASTKEY()          (function  in ?)
*!               : BE2CE()            (function  in ?)
*!               : FOUND()            (function  in ?)
*!               : CE2CBE()           (function  in ?)
*!
*!*****************************************************************************
proc select_date		&& called by main prog
para cdate,print_ask
do whil .t.
   @19,43 to 23,76 double
   @21,45 say 'พิมพ์ วันที่นัด ' get cdate pict '99/99/9999'
   READ NOLOCK
   if lastkey()=27 .or. left(cdate,2)='99'
      clea
      retu to master
   endi
   finddate=be2ce(cdate)
   sele appoint
   loca for date=finddate
   if !found()
      saydate=ce2cbe(finddate)
      wait '  ไม่มีการนัดคนไข้วันที่ '+saydate window nowait
      loop
   endi
   exit
endd
return
*!*****************************************************************************
*!
*!      Procedure: REPORT1
*!
*!      Called by: APPOINT1           (procedure in BAR.PRG)
*!
*!          Calls: SPACE()            (function  in ?)
*!               : PRINT_RE1          (procedure in BAR.PRG)
*!
*!*****************************************************************************
proc report1
sele appoint
count for date=finddate .and. hn <> space(7) to c
dime a(c)
i=0
scan for date = finddate .and. hn <> space(7)
   i=i+1
   a(i)=hn
endscan
clea
do print_re1
*!*****************************************************************************
*!
*!      Procedure: PRINT_RE1
*!
*!      Called by: REPORT1            (procedure in BAR.PRG)
*!
*!          Calls: IIF()              (function  in ?)
*!               : INT()              (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : TRANS()            (function  in ?)
*!               : CE2CBE()           (function  in ?)
*!               : TRANSFORM()        (function  in ?)
*!               : ROW()              (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc print_re1
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
   @4,0 to 20,80 clea
endi
set print on
line_page=iif(print_flag,20,12)   && หน้าจอ=12 line, เครื่องพิมพ์=20 line
pageno=int(i/(line_page*5))
pageno=iif(pageno=0,1,pageno)
numcase=line_page*5
pageno =iif(i>pageno*numcase ,pageno+1,pageno)   && คำนวณ จำนวนหน้า
for page=1 to pageno      	    && ' LOOP พิมพ์ ทุกแผ่น'
   begpage = (page -1) *numcase +1
   endpage = page *numcase
   endpage =iif(i<=endpage,i,endpage)
   row=1
   ?space(67)+'หน้าที่'+trans(page,'##')
   if print_flag
      for blankline =1 to 5
         ?
      endfor
   endi
   ?space(30)+'วันที่นัดคนไข้ '+ce2cbe(finddate)
   ?
   for l= begpage to endpage step 5   &  'พิมพ์ 1 แผ่น'
      ?space(5)+trans(row,'###')+'.'
      for c=1 to 5
         if (l+c-1)>i
            ??space(13)
         else
            ??space(6)+transform(a(l+c-1),'9999999')
         endi
      endfor
      row=row+1
   endfor
   if (l+c-1)>i
      ?
      if ! print_flag
         cur_row=row()
         @ row()+2,0 to 24,80 clea
         @cur_row,0
      endi
      ?space(5)+'หมายเหตุ  นัดคนไข้รวม '+trans(i,'###')+' คน'
   endi
   if print_flag .and. sys(102)='ON'
      eject
   else
      =inkey(4)
      @ 4,0 to 20,80 clea
   endi
endfor
set print to
set print off
set cons on
retu
*!*****************************************************************************
*!
*!      Procedure: REPORT2
*!
*!      Called by: APPOINT1           (procedure in BAR.PRG)
*!
*!          Calls: SPACE()            (function  in ?)
*!               : IIF()              (function  in ?)
*!               : SUBST()            (function  in ?)
*!               : LEFT()             (function  in ?)
*!               : ASORT()            (function  in ?)
*!               : PRINT_RE2          (procedure in BAR.PRG)
*!
*!*****************************************************************************
proc report2
sele appoint
i=0
count for date=finddate .and. hn #space(7) to c
dime a(c)
scan for date= finddate .and. hn <> space(7)
   i=i+1
   xx=iif(subst(clinic,3,1)=' ',"0",subst(clinic,3,1))
   a(i)=left(clinic,2)+xx+hn
endscan
=asort(a)
clea
do print_re2
retu
*!*****************************************************************************
*!
*!      Procedure: PRINT_RE2
*!
*!      Called by: REPORT2            (procedure in BAR.PRG)
*!
*!          Calls: LEFT()             (function  in ?)
*!               : IIF()              (function  in ?)
*!               : FOUND()            (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : TRANS()            (function  in ?)
*!               : CE2CBE()           (function  in ?)
*!               : RTRIM()            (function  in ?)
*!               : LEN()              (function  in ?)
*!               : CHR()              (function  in ?)
*!               : TRANSFORM()        (function  in ?)
*!               : RIGHT()            (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc print_re2
if print_flag
   set cons off
else
   @4,0 to 20,80 clea
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
sele clinic
pclinic=left(a(1),3)
newclinic=pclinic
l=1						&& กำหนดค่าสะสมของจำนวนที่พิมพ์
page=1
line_page=iif(print_flag,20,12)
numcase=line_page*5
row=1
prpage=1
do whil l<=i
   seek pclinic
   row=1
   endpage = page *numcase
   endpage =iif(i<=endpage,i,endpage)
   seek pclinic
   if ! found()
      extclinic=left(pclinic,2)
      seek extclinic
   endi
   ?space(67)+'หน้าที่'+trans(prpage,'##')
   if print_flag
      for blankline =1 to 5
         ?
      endfor
   endi
   ?space(30)+'วันที่นัดคนไข้ '+ce2cbe(finddate)
   ?
   sayclinic='คลีนิค '+rtrim(name)
   ?space(40-len(sayclinic))+chr(14)+sayclinic
   ?
   notmat=0
   _newclinic=.f.
   do whil .t.
      if pclinic=left(a(l),3)
         ?space(5)+transform(row,'###')+'.'   && บรรทัดที่
      endi
      for c=1 to 5					&& พิมพ์ 1 บรรทัด
         if (l+c-1)>i .or. notmat>0 					&& i=#คนไข้ทั้งหมด
            notmat=notmat+1
            ??space(13)
         else
            newclinic=left(a(l+c-1),3)
            if newclinic = pclinic
               chn=right(a(l+c-1),7)
               ??space(6)+transform(chn,'9999999')
            else
               _newclinic=.t.
               pclinic=newclinic
               notmat=notmat+1
               ??space(13)
            endi
         endi
      endfor
      row=row+1
      l=l+5
      if l>endpage .or. notmat>0
         exit
      endi
   enddo
   prpage=iif(_newclinic,1,prpage+1)
   page=page+1
   l=iif(notmat>0,l-notmat,l+1)
   if print_flag .and. sys(102)='ON'
      eject
   else
      =inkey(4)
      @4,0 to 22,80 clea
   endi
endd
?
*?space(5)+'หมายเหตุ  นัดคนไข้รวม '+trans(i,'###')+' คน'
?
set print to
set print off
*!*****************************************************************************
*!
*!      Procedure: REPORT3
*!
*!      Called by: APPOINT1           (procedure in BAR.PRG)
*!
*!          Calls: FILE()             (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : PRINT_RE3          (procedure in BAR.PRG)
*!
*!           Uses: TEMP10.DBF
*!               : STEMP10.DBF            Alias: STEMP
*!
*!*****************************************************************************
proc report3
if file('temp10.dbf')
   dele file temp10.dbf
   dele file temp10.fpt
   dele file stemp10.dbf
endi
sele appoint
sort on clinic,hn to stemp10 for ! EMPTY(hn) .AND. date = finddate
sele 0
dbfuse = 'stemp10'
USE stemp10 alia stemp
dbfuse = ''
clea
do print_re3
*!*****************************************************************************
*!
*!      Procedure: PRINT_RE3
*!
*!      Called by: REPORT3            (procedure in BAR.PRG)
*!
*!          Calls: IIF()              (function  in ?)
*!               : RECCOUNT()         (function  in ?)
*!               : PHEAD              (procedure in BAR.PRG)
*!               : EOF()              (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : TRANSFORM()        (function  in ?)
*!               : RTRIM()            (function  in ?)
*!               : ROUND()            (function  in ?)
*!               : LEN()              (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc print_re3
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
   @4,0 to 20,80 clea
endi
set print on
line_page=iif(print_flag,20,12)
sele stemp
i=reccount()
pclinic=stemp->clinic
go top
row=1
page=1
_case=1
do phead
dbfuse = patientdir+'patient1'
USE (patientdir+'patient1') ORDER 1 IN 0
dbfuse = ''
sele stemp
SET RELA TO hn INTO patient1
do whil ! eof()
   if stemp->clinic = pclinic
      ?space(5)+transform(_case,'###')+'.'   && บรรทัดที่
      ??space(2)+transform(hn,'9999999'),SPACE(2),de_name(patient1.name)
      IF ! EMPTY(lab)
	      ?space(15)+rtrim(lab)
	  ENDI
      row=row+1+round(((len(rtrim(lab))+30)/60),0)
      _case=_case+1
      pclinic=stemp->clinic
      skip
   else
      if print_flag .and. sys(102)='ON'
         eject
      else
         =inkey(3)
         @ 5,0 to 18,80 clea
      endi
      page=1
      pclinic=stemp->clinic
      do phead			&& พิมพ์หัวตาราง
      row=1
      _case=1
   endi
enddo
if print_flag .and. sys(102)='ON'
   eject
else
   =inkey(3)
   @ 5,0 to 24,80 clea
endi
page=page+1
*?
*?space(5)+'หมายเหตุ  นัดคนไข้รวม '+trans(i,'###')+' คน'
*?
set print to
set print off
set cons on
retu
*!*****************************************************************************
*!
*!      Procedure: PHEAD
*!
*!      Called by: PRINT_RE3          (procedure in BAR.PRG)
*!
*!          Calls: SPACE()            (function  in ?)
*!               : TRANS()            (function  in ?)
*!               : CE2CBE()           (function  in ?)
*!               : RTRIM()            (function  in ?)
*!               : LEN()              (function  in ?)
*!               : CHR()              (function  in ?)
*!
*!*****************************************************************************
proc phead
sele clinic
seek pclinic
?space(67)+'หน้าที่'+trans(page,'##')
if print_flag
   for blankline =1 to 5
      ?
   endfor
endi
?space(30)+'วันที่นัดคนไข้ '+ce2cbe(finddate)
?
sayclinic='คลีนิค '+rtrim(clinic->name)
?space(40-len(sayclinic))+chr(14)+sayclinic
?
sele stemp
retu
*!*****************************************************************************
*!
*!      Procedure: REQ_PRINTER
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT1           (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!               : OTHER1             (procedure in BAR.PRG)
*!
*!          Calls: IIF()              (function  in ?)
*!
*!*****************************************************************************
proc req_printer
para print_f
print_f=iif(print_f=.t.,.f.,.t.)
if print_f=.t.
   set print on
   wait ' แสดงผลบนเครื่องพิมพ์ ' wind nowait
else
   set print off
   wait ' แสดงผลบนจอ       ' wind nowait
endi
retu
*!*****************************************************************************
*!
*!      Procedure: APPOINT2
*!
*!      Called by: YOURCHOICE         (procedure in BAR.PRG)
*!
*!          Calls: CE2BE()            (function  in ?)
*!               : DATE()             (function  in ?)
*!               : REQ_PRINTER        (procedure in BAR.PRG)
*!               : FILE()             (function  in ?)
*!               : INKEY()            (function  in ?)
*!               : TAKE               (procedure in BAR.PRG)
*!               : DESAPPOINT         (procedure in BAR.PRG)
*!               : STR()              (function  in ?)
*!               : ENTRYDATE()        (function  in BAR.PRG)
*!               : CHKDATE()          (function  in BAR.PRG)
*!               : SPACE()            (function  in ?)
*!               : LASTKEY()          (function  in ?)
*!               : LEFT()             (function  in ?)
*!               : BE2CE()            (function  in ?)
*!               : EOF()              (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : COMPUTE1           (procedure in BAR.PRG)
*!               : ERRHANDLE          (procedure in BAR.PRG)
*!               : LTRIM()            (function  in ?)
*!               : COMPUTE31          (procedure in BAR.PRG)
*!               : COMPUTE32          (procedure in BAR.PRG)
*!               : MANYANS            (procedure in BAR.PRG)
*!               : COMPUTE4           (procedure in BAR.PRG)
*!               : PRINT_TIME         (procedure in BAR.PRG)
*!               : LAB                (procedure in BAR.PRG)
*!               : CAPTURE_FIELD      (procedure in BAR.PRG)
*!               : COMPUTE2           (procedure in BAR.PRG)
*!               : CHR()              (function  in ?)
*!
*!           Uses: &AAAPPOINT             Alias: APPO
*!               : CLINIC.DBF             Alias: CLINIC
*!               : DOCTOR.DBF             Alias: DOCTOR
*!
*!   Memory Files: DIAG.MEM
*!
*!*****************************************************************************
proc appoint2
close data
cdate = ce2be(date())
print_flag=.t.
on key label ctrl+p do req_printer with print_flag
do req_printer with print_flag
if ! file('diag.mem')
   @ 8,10 say 'ไม่มี file MEMO ต้อง install ก่อน'
   =inkey(4)
   @ 8,2 clea
   return
else
   rest from diag addi
   nnn=aaappoint+'.DBF'
endi
if ! file(opddir+nnn)
   @ 8,10 say 'หา file ข้อมูลการนัดหมาย ไม่พบ ต้อง install ใหม่ ???'
   =inkey(4)
   @ 8,2 clea
   return
endi
sele 0
dbfuse = opddir+aaappoint
USE (opddir+aaappoint) alia appo
sele 0
dbfuse = codedir+'clinic'
USE (codedir+'clinic') order 1 alia clinic
sele 0
dbfuse = codedir+'doctor'
USE (codedir+'doctor') order 1
dbfuse = ''
clea
store 0 to othervar
store 1 to selefield,fieldwide,fieldmax
fname=""
datefield=3
sele appo
do take with selefield  && เลือก เขตข้อมูล
   if lastkey()=27
      clea
      retu to master
   endi
do desappoint with fieldwide,fieldmax,fname
dime aa(fieldmax),bb(fieldmax),desaa(fieldmax),y(3)
heading='แฟ้มข้อมูลการนัดหมาย'
if str(selefield,1) $'2,4,5,6,7'
   stor cdate to be_date,to_date
   @ 19,3 say 'ตั้งแต่  ' get be_date pict '99/99/9999';
      mess 'พิมพ์ 99 ถ้าต้องการผลรวมตั้งแต่ต้นปี'
   @ 20,3 say 'ถึง      ' get to_date  pict '99/99/9999';
      when entrydate(be_date) valid chkdate(to_date) mess space(30)
   READ NOLOCK
   if lastkey()=27
      clea
      retu to master
   endi
   if left(be_date,2) <> '99'
      finddate=be2ce(be_date)
      enddate =be2ce(to_date)
      heading=heading+' ('+be_date+'-'+to_date+')'
   endi
   sele appo
   go top
endi
do case
case selefield=2
   sele clinic
   k=1
   do whil ! eof()
      aa(k)=eval(field(1))
      desaa(k)=left(name,25)
      skip
      k=k+1
   endd
   do compute1
case selefield=3			&& เลือกวันนัด (date)
   on readerror do errhandle
   choose=1
   @ 19,1 say 'พิมพ์เลขเดือน ถ้าต้องการระบุเดือน  '
   @ 20,8 say ' หรือ  '
   @ 21,1 say 'พิมพ์ "0" ถ้าต้องการผลทุกเดือน  '
   @ 22,8 get choose pict '99' range 0,12
   READ NOLOCK
   if choose>=1 .and. choose <=12
      mmappo=ltrim(str(choose))
      mmappo=iif(len(mmappo)=1,'0'+mmappo,mmappo)
      heading=heading+' เดือน '+month&mmappo
      fname='วันที่นัด'
      do compute31
   else
      fname='เดือนที่นัด'
      do compute32
   endi
case selefield=4
   condition2=2
   do manyans with condition2
   do compute4					&& เลือกเวลานัด (time)
   do print_time
case selefield=5
   sele doctor
   k=1
   do whil ! eof()
      aa(k)=eval(field(1))
      desaa(k)=left(name,25)
      skip
      k=k+1
   endd
   do compute1
case selefield=6 					&& เลือก ตรวจสอบการมาตามนัด
   aa(1)=.t.
   aa(2)=.f.
   desaa(1)='มาตามนัด  '
   desaa(2)='ผิดนัด    '
   do compute1
case selefield=7					&& LAB
   do lab
   condition2=2
   textcon=space(10)
   do capture_field with condition2,textcon
   if condition2>1
      set filt to textcon $eval(field(condition2))
   endi
   do compute2
   set filt to
other
   ??chr(7)
   @ 8,5 say 'ให้ใช้ ภาษา query ทำรายงาน'
   =inkey(3)
   clea
endcase
retu
*!*****************************************************************************
*!
*!      Procedure: ERRHANDLE
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: REPL()             (function  in ?)
*!               : CHR()              (function  in ?)
*!
*!*****************************************************************************
proc errhandle
wait 'error กรุณาพิมพ์ใหม่'
@23,0 say repl(chr(6),77)
retu
*!*****************************************************************************
*!
*!      Procedure: COMPUTE1
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: LEFT()             (function  in ?)
*!               : EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : ASCAN()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : AT()               (function  in ?)
*!               : SPAC()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : SUBST()            (function  in ?)
*!               : LEN()              (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : INKEY()            (function  in ?)
*!               : SYS()              (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc compute1
clea
go top
for i=1 to fieldmax
   bb(i)=0
endf
mtotal=0
sele appo
do scale
if left(be_date,2)='99'	&& ประมวลผลทั้งแฟ้ม
   do whil ! eof()
      if ! empty(hn)
         seat=ascan(aa,eval(field(selefield)))
         if seat # 0
            bb(seat)=bb(seat)+1
         else
            othervar=othervar+1
         endi
         mtotal=mtotal+1
      endif
      skip
      if recno()*10/retot >ten .and. ten <10
         do success
      endi
   enddo
else            && ประมวลผลตามช่วงเวลาที่กำหนด
   do whil ! eof()
      if ! empty(hn) .and. eval(field(datefield))>=finddate .and. eval(field(datefield))<=enddate
         seat=ascan(aa,eval(field(selefield)))
         if seat # 0
            bb(seat)=bb(seat)+1
            mtotal=mtotal+1
         endi
      endif
      skip
      if recno()*10/retot >ten .and. ten <10
         do success
      endi
   enddo
endi
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
po= at('[',heading)
bettime= at('/',heading)
if bettime=0
   lmargin=20
   else
   lmargin=10
endi
deac wind keep
if po =0
   ? spac(lmargin),heading
else
   ? spac(15),left(heading,po-1)
   ? space(25),subst(heading,po)
endi
?
? spac(5),fname,spac(25-len(fname)),'จำนวนครั้ง',spac(10),'ร้อยละ'
?
for i= 1 to fieldmax
   ? spac(5),desaa(i),space(27-len(desaa(i))),tran(bb(i),'#####')
   ??space(12),tran(100*bb(i)/mtotal,'####.##')
   if i=12
      =inkey(4)
   endi
endfor
? space(5),'อื่นๆ',space(27-len('อื่นๆ')),tran(othervar,'#####')
??space(12),tran(100*othervar/mtotal,'####.##')
?
? spac(6),'รวม  ',spac(21),tran(mtotal,'#####'),spac(12),'100.00'
?
if print_flag .and. sys(102)='ON'
   eject
   set cons on
endi
=inkey(4)
clea
set print to
set print off
retu
*!*****************************************************************************
*!
*!      Procedure: COMPUTE2
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: LEFT()             (function  in ?)
*!               : EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : IIF()              (function  in ?)
*!               : AT()               (function  in ?)
*!               : SPAC()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : SUBST()            (function  in ?)
*!               : LEN()              (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc compute2
clea
for i=1 to fieldmax
   bb(i)=0
endf
mtotal=0
sele appo
go top
do scale
if left(be_date,2)='99'	&& ประมวลผลทั้งแฟ้ม
   do whil ! eof()
      if ! empty(hn)
         if ! empty(eval(field(selefield)))
            for j=1 to fieldmax
               bb(j)=iif(aa(j)$eval(field(selefield)),bb(j)+1,bb(j))
               mtotal=iif(aa(j)$eval(field(selefield)),mtotal+1,mtotal)
            endfor
         endi
      endif
      skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
enddo
else            && ประมวลผลตามช่วงเวลาที่กำหนด  ****
   do whil ! eof()
      if ! empty(hn) .and. eval(field(datefield))>=finddate .and. eval(field(datefield))<=enddate
         if ! empty(eval(field(selefield)))
            for j=1 to fieldmax
               bb(j)=iif(aa(j)$eval(field(selefield)),bb(j)+1,bb(j))
               mtotal=iif(aa(j)$eval(field(selefield)),mtotal+1,mtotal)
            endfor
         endi
      endif
      skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
   enddo
endi
deac wind keep
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
po= at('[',heading)
if po =0
   ? spac(20),heading
else
   ? spac(20),left(heading,po-1)
   ? space(30),subst(heading,po)
endi
?
? spac(5),fname,spac(27-len(fname)),'จำนวนครั้ง',spac(8),'ร้อยละ'
?
for i= 1 to fieldmax
   ? spac(5),left(desaa(i),29),space(29-len(desaa(i))),tran(bb(i),'#####')
   ??space(10),tran(100*bb(i)/mtotal,'####.##')
endfor
?
? spac(6),'รวม  ',spac(23),tran(mtotal,'#####'),spac(10),'100.00'
?
if condition2>1
   ?space(6),'หมายเหตุ กรณีกำหนดค่า field '+field(condition2)+'='+textcon
endi
if print_flag .and. sys(102)='ON'
   eject
   set cons on
endi
=inkey(4)
clea
set print to
set print off
retu
*!*****************************************************************************
*!
*!      Procedure: COMPUTE31
*!
*!      Called by: R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: IIF()              (function  in ?)
*!               : STR()              (function  in ?)
*!               : EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : SUBST()            (function  in ?)
*!               : DTOC()             (function  in ?)
*!               : VAL()              (function  in ?)
*!               : SPAC()             (function  in ?)
*!               : LEN()              (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc compute31
clea
mtotal=0
dime bb(31)
for j=1 to 31
   bb(j)=0
endfor
chrchoose=iif(choose<10,'0'+str(choose,1),str(choose,2))
sele appo
do scale
do whil ! eof()
   if ! empty(hn)
      rr=eval(field(selefield))
      if subst(dtoc(rr),4,2)=chrchoose
         rr=subst(dtoc(rr),1,2)
         rr=val(rr)
         bb(rr)=bb(rr)+1
         mtotal=mtotal+1
      endi
   endi
   skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
enddo
deac wind keep
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
? spac(20),heading
?
? spac(1),fname,spac(15-len(fname)),'จำนวนครั้ง ',' ร้อยละ'
?? spac(2),fname,spac(15-len(fname)),'จำนวนครั้ง ',' ร้อยละ'
?
for i= 1 to 15
   ? spac(5),tran(i,'##'),space(9),tran(bb(i),'####'),space(4)
   ??tran(100*bb(i)/mtotal,'#####.##'),'  |'
   ?? spac(4),tran(15+i,'##'),space(9),tran(bb(15+i),'####'),space(5)
   ??tran(100*bb(15+i)/mtotal,'#####.##')
endfor
? spac(36),'  |    ',tran(31,'##'),space(10),tran(bb(31),'###'),space(5)
??tran(100*bb(31)/mtotal,'#####.##')
?
? spac(44),'รวม  ',spac(3),tran(mtotal,'###,###'),spac(9),'100'
?
if print_flag .and. sys(102)='ON'
   eject
   set cons on
endi
=inkey(4)
clea
set print to
set print off
retu
*!*****************************************************************************
*!
*!      Procedure: COMPUTE32
*!
*!      Called by: R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : SUBST()            (function  in ?)
*!               : DTOC()             (function  in ?)
*!               : VAL()              (function  in ?)
*!               : SPAC()             (function  in ?)
*!               : LEN()              (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc compute32
clea
mtotal=0
dime bb(12)
for j=1 to 12
   bb(j)=0
endfor
sele appo
do scale
do whil ! eof()
   if ! empty(hn)
      rr=eval(field(selefield))
      rr=subst(dtoc(rr),4,2)
      rr=val(rr)
      bb(rr)=bb(rr)+1
      mtotal=mtotal+1
   endi
   skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
enddo
deac wind keep
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
? spac(20),heading
?
? spac(5),fname,spac(17-len(fname)),'จำนวนครั้ง ',spac(10),'ร้อยละ'
?
for i= 1 to 12
   ? spac(7),tran(i,'##'),space(16),tran(bb(i),'####'),space(12)
   ??tran(100*bb(i)/mtotal,'#####.##')
endfor
?
? spac(7),'รวม  ',spac(13-len('รวม')),tran(mtotal,'###,###'),spac(13),'100.00'
?
if print_flag .and. sys(102)='ON'
   eject
   set cons on
endi
=inkey(4)
clea
set print to
set print off
retu
*!*****************************************************************************
*!
*!      Procedure: COMPUTE5
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : R1_CAME            (procedure in BAR.PRG)
*!
*!          Calls: LEFT()             (function  in ?)
*!               : EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : RTRIM()            (function  in ?)
*!               : IIF()              (function  in ?)
*!               : AT()               (function  in ?)
*!               : SUBST()            (function  in ?)
*!               : BETW()             (function  in ?)
*!               : SPAC()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : LEN()              (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc compute5
clea
for i=1 to fieldmax
   bb(i)=0
endf
mtotal=0
sele appo
go top
do scale
if selefield=15
   selefield=7
   heading=heading+ '(วันเริ่มป่วย)'
endi
if left(be_date,2)='99' && ประมวลผลทั้งแฟ้ม
   do whil ! eof()
      if ! empty(hn)
         if ! empty(eval(field(selefield)))
            content=rtrim(eval(field(selefield)))
            for j=1 to fieldmax
               bb(j)=iif(content$aa(j),bb(j)+1,bb(j))
               mtotal=iif(content$aa(j),mtotal+1,mtotal)
               po= at('-',aa(j))
               if po >0 .and.! content$subst(aa(j),po-5,5) .and. !content$subst(aa(j),po+1,5)
                  if betw(content,subst(aa(j),po-5,5),subst(aa(j),po+1,5))
                     bb(j)=bb(j)+1
                     mtotal=mtotal+1
                  endi
               endi
            endfor
         endi
      endif
      skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
   enddo
else            && ประมวลผลตามช่วงเวลาที่กำหนด
   do whil ! eof()
      if ! empty(hn) .and. eval(field(visitdate))>=finddate .and. eval(field(visitdate))<=enddate
         if ! empty(eval(field(selefield)))
            content=rtrim(eval(field(selefield)))
            for j=1 to fieldmax
               bb(j)=iif(content$aa(j),bb(j)+1,bb(j))
               mtotal=iif(content$aa(j),mtotal+1,mtotal)
               po= at('-',aa(j))
               if po >0 .and.! content$subst(aa(j),po-5,5) .and. !content$subst(aa(j),po+1,5)
                  if betw(content,subst(aa(j),po-5,5),subst(aa(j),po+1,5))
                     bb(j)=bb(j)+1
                     mtotal=mtotal+1
                  endi
               endi
            endfor
         endi
      endif
      skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
   enddo
endi
deac wind keep
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
po= at('[',heading)
if po =0
   ? spac(8),heading
else
   ? spac(8),left(heading,po-1)
   ? space(28),subst(heading,po)
endi
?
? spac(5),fname,spac(27-len(fname)),'จำนวนครั้ง',spac(8),'ร้อยละ'
?
for i= 1 to fieldmax
   ? spac(5),left(desaa(i),29),space(29-len(desaa(i))),tran(bb(i),'#####')
   ??space(10),tran(100*bb(i)/mtotal,'####.##')
endfor
?
? spac(6),'รวม  ',spac(23),tran(mtotal,'#####'),spac(10),'100.00'
?
if print_flag .and. sys(102)='ON'
   eject
   set cons on
endi
=inkey(4)
clea
set print to
set print off
retu
*!*****************************************************************************
*!
*!      Procedure: COMPUTE7
*!
*!      Called by: R1_CAME            (procedure in BAR.PRG)
*!
*!          Calls: EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : ASCAN()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : SPAC()             (function  in ?)
*!               : LEN()              (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : TYPE()             (function  in ?)
*!               : IIF()              (function  in ?)
*!               : LEFT()             (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : SYS()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc compute7
xx=fieldmax+1
dime bb(xx,3)
clea
for j=1 to 3
   for i=1 to xx
      bb(i,j)=0
   endfor
next
go top
stor 0 to mtotal
sele appo
do scale
do whil ! eof()
   if empty(hn)
      skip
      loop
   endi
   i=1
   do whil i <=fieldmax
      if age <= aageup(i) .and. age_type=aagetype(i)
         exit
      endi
      i=i+1
   endd
   if condition2 >1
      seat=ascan(y,eval(field(condition2)))
      if seat =0
         skip
         loop
      endi
   else
      seat=1
   endi
   if i <= fieldmax  .and. age >=aagelow(i)
      bb(i,seat)=bb(i,seat)+1
   else
      bb(xx,seat)=bb(xx,seat)+1
   endi
   mtotal=mtotal+1
   skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
enddo
deac wind keep
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
if condition2>1
  ? spac(20),heading		&& start writing *******
else
  ? spac(10),heading
endi
?
if condition2>1
   ?spac(6),fname,spac(19-len(fname)),'รวม ',spac(5),'ร้อยละ'
   ??space(6),'เขตข้อมูล',field(condition2)
   do case
   case type('y(1)')='D'
      ?space(44),y(1),y(2),' ',y(3)
   case type('y(1)')='L'
      ? space(49),y(1),
      ??space(6),y(2)
   other
      ? space(52-len(left(y(1),9))),y(1),
      ??space(9-len(left(y(2),9))),y(2),
      ??space(9-len(left(y(3),9)))+y(3)
   endcase
else
   ?space(6),fname,spac(19-len(fname)),'รวม ',spac(5),'ร้อยละ'
endi
?
for i= 1 to xx
   if i<11
      do case
      case aagetype(i)='1'
         deaagetype='ปี'
      case aagetype(i)='2'
         deaagetype='เดือน'
      case aagetype(i)='3'
         deaagetype='วัน'
      other
         deaagetype=''
      endc
   endif
   if i<xx
      ? spac(5),desaa(i),deaagetype,space(18-len(desaa(i))-len(deaagetype))
   else
      ? space(5),'อื่นๆ',space(19-len('อื่นๆ'))
   endi
   if condition2>1
      sumcol=bb(i,1)+bb(i,2)+bb(i,3)
      ??tran(sumcol,'#####'),space(3),tran(100*sumcol/mtotal,'####.##')
      ??space(4),tran(bb(i,1),'#####'),space(3),tran(bb(i,2),'#####'),space(3)
      ??tran(bb(i,3),'#####')
   else
      sumcol=bb(i,1)
      ??tran(sumcol,'#####'),space(3),tran(100*sumcol/mtotal,'####.##')
   endi
next
store 0 to t1,t2,t3
if condition2>1
   for j=1 to xx
      t1=t1+bb(j,1)
      t2=t2+bb(j,2)
      t3=t3+bb(j,3)
   next
   subtotal=space(5)+tran(t1,'#####')+space(5)+tran(t2,'#####')+space(4)+tran(t3,'#####')
else
   subtotal=''
endi
?
? spac(5),'รวม  ',spac(13),tran(mtotal,'#####'),spac(4),'100.00'
??subtotal
?
if print_flag .and. sys(102)='ON'
   eject
   set cons on
endi
=inkey(4)
set print to
set print off
clea
retu
*!*****************************************************************************
*!
*!      Procedure: TAKE
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: FCOUNT()           (function  in ?)
*!               : REPL()             (function  in ?)
*!               : CHR()              (function  in ?)
*!               : FIELD()            (function  in ?)
*!
*!*****************************************************************************
proc take                       &&  เลือก FIELD
para sele_field,fwide,fmax,namefield
priv i,c,v,u,x
clea
c=fcount()
i=2
@1,2 say repl(chr(6),77)
@2,48 say ''
@3,48 say ''
for u=3 to 12
   @u,52-u*2 say ''
   @u,44+u*2 say ''
endf
for v=4 to 12
   @v,53-v*2 say ''
   @v,43+v*2 say ''
endf
@6,46 to 8,50 chr(19)
@10,34 to 22,62 chr(19)
@11,35 to 22,61 chr(19)
@23,2 say repl(chr(6),77)
c=fcount()
dime show(c)
for a=1 to c
   stor field(a) to show(a)
next
@12,35 get sele_field from show size 10,26
READ NOLOCK
retu
*!*****************************************************************************
*!
*!      Procedure: CAPTURE_FIELD
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: FCOUNT()           (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : FSIZE()            (function  in ?)
*!
*!*****************************************************************************
proc capture_field
para sfield,stext
c=fcount()
defi wind showfield from 14,50 to 23,77 title 'เลือกเงื่อนไข'
dime show(c)
stor 'ไม่มี เงื่อนไข' to show(1)
for a=2 to c
   stor field(a) to show(a)
next
acti wind showfield
sfield=1
@0,3 get sfield from show size 6,20
READ NOLOCK
if sfield # 1
   stext=space(fsize(field(sfield)))
   @7,3 say 'กำหนดค่า  ' get stext pict '@!'
   READ NOLOCK
endi
rele wind showfield
retu
*!*****************************************************************************
*!
*!      Procedure: MANYANS
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: FCOUNT()           (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : TYPE()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : IIF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : FSIZE()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : CHECKY()           (function  in BAR.PRG)
*!               : ALLTRIM()          (function  in ?)
*!
*!*****************************************************************************
proc manyans
para sfield
c=fcount()
defi wind showfield from 10,44 to 23,75 title 'เลือกเงื่อนไข'
dime show(c)
stor 'ไม่มี เงื่อนไข' to show(1)
for a=2 to c
   stor field(a) to show(a)
next
acti wind showfield
sfield=1
@0,3 get sfield from show size 6,26
READ NOLOCK
if type(field(sfield))='L'
   store .f. to y(1)
   store .t. to y(2)
   rele wind showfield
   retu
endi
if sfield # 1
   do case
   case type(field(sfield))='D'
      store date to y(1),y(2),y(3)
   case type(field(sfield))='M'
      store 'EKG         ' to y(1)
      store space(12) to y(2),y(3)
   other
      y(1)=iif(empty(field(sfield)),space(fsize(field(sfield))),eval(field(sfield)))
      store space(fsize(field(sfield))) to y(2),y(3)
   endcase
   @8,1 say 'กำหนดค่าที่ 1.  ' get y(1) pict '@!';
      defa eval(field(sfield)) valid checky(y(1))
   @9,1 say 'กำหนดค่าที่ 2.  ' get y(2) pict '@!';
      defa eval(field(sfield)) valid checky(y(2))
   @10,1 say 'กำหนดค่าที่ 3.  ' get y(3) pict '@!';
      defa eval(field(sfield)) valid checky(y(3))
   READ NOLOCK
   if type(field(sfield))='M'
      for mc=1 to 3
         y(mc)=alltrim(y(mc))
      next
   endi
endi
rele wind showfield
retu
*!*****************************************************************************
*!
*!       Function: CHECKY()
*!
*!      Called by: MANYANS            (procedure in BAR.PRG)
*!
*!          Calls: LASTKEY()          (function  in ?)
*!               : EMPTY()            (function  in ?)
*!
*!*****************************************************************************
func checky
para _y
if lastkey()=4 .or. lastkey()=5      && ถอยหลัง
   _curobj=_curobj -1
   retu
endi
if empty(_y)
   retu 4        && 4 gets
endi
retu
*!*****************************************************************************
*!
*!      Procedure: DESAPPOINT
*!
*!      Called by: APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: RECCOUNT()         (function  in ?)
*!
*!*****************************************************************************
proc desappoint
para fwide,fmax,namefield
do case
case selefield=2
   fwide=3
   namefield=' คลีนิค '
   sele clinic
   fmax=reccount()
case selefield=3
   fwide=8
   namefield='วันที่นัด'
   fmax=31
case selefield=4
   fwide=4
   namefield='เวลาที่นัด'
   fmax=24
case selefield=5
   namefield=' ชื่อแพทย์ผู้นัด'
   fwide=5
   sele doctor
   fmax=reccount()
case selefield=6
   namefield='การมาตรวจตามนัด'
   fwide=1
   fmax=2
case selefield=7
   namefield='ผลการชันสูตร'
   fwide=80
   fmax=12
endcase
retu
*!*****************************************************************************
*!
*!      Procedure: COMPUTE4
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: LEFT()             (function  in ?)
*!               : TYPE()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : EOF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : ASCAN()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : IIF()              (function  in ?)
*!               : VAL()              (function  in ?)
*!               : UPPE()             (function  in ?)
*!
*!*****************************************************************************
proc compute4
dime bb(24,3)
clea
for j=1 to 3
   for i=1 to 24
      bb(i,j)=0
   endfor
next
sele appo
do scale
do case
case left(be_date,2)='99' .and.type(field(condition2))<>'M' 	&& ประมวลผลทั้งแฟ้ม
   do whil ! eof()
      if ! empty(hn)
         if condition2 >1
            seat=ascan(y,eval(field(condition2)))
            if seat =0
               skip
               loop
            endi
         else
            seat=1
         endi
         **********
         rr=iif(left(time,2)<>'00',val(left(time,2)),24)
         if left(time,2)='24'
            rr=23
         endi
         bb(rr,seat)=bb(rr,seat)+1
      endi
      skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
   enddo
   deac wind keep
case left(be_date,2)='99' .and.type(field(condition2))='M' 	&& ประมวลผลทั้งแฟ้ม
   do whil ! eof()
      if ! empty(hn)
         rr=val(left(time,2))
         if rr=0
            rr=24
         endi
         for j=1 to 3
            bb(rr,j)=iif(y(j)$uppe(eval(field(condition2))),bb(rr,j)+1,bb(rr,j))
         endfor
      endi
      skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
   enddo
   deac wind keep
case left(be_date,2)<>'99' .and.type(field(condition2))<>'M' 	&& ประมวลผลทั้งแฟ้ม
   *****            && ประมวลผลตามช่วงเวลาที่กำหนด
   do whil ! eof()
      if ! empty(hn) .and. eval(field(datefield))>=finddate .and. eval(field(datefield))<=enddate
         if condition2 >1
            seat=ascan(y,eval(field(condition2)))
            if seat =0
               skip
               loop
            endi
         else
            seat=1
         endi
         rr=eval(field(selefield))
         if left(time,2)>'24'
            skip
            loop
         endi
         rr=val(left(time,2))
         if rr=0
            rr=24
         endi
         bb(rr,seat)=bb(rr,seat)+1
      endi
      skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
   enddo
   deac wind keep
case left(be_date,2)<>'99' .and.type(field(condition2))='M' 	&& ประมวลผลทั้งแฟ้ม
   do whil ! eof()
      if ! empty(hn) .and. eval(field(datefield))>=finddate .and. eval(field(datefield))<=enddate
         rr=val(left(time,2))
         if rr=0
            rr=24
         endi
         for j=1 to 3
            bb(rr,j)=iif(y(j)$uppe(eval(field(condition2))),bb(rr,j)+1,bb(rr,j))
         endfor
      endi
      skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
   enddo
   deac wind keep
endcase
*!*****************************************************************************
*!
*!      Procedure: PRINT_TIME
*!
*!      Called by: REFER1             (procedure in BAR.PRG)
*!               : R1_CAME            (procedure in BAR.PRG)
*!               : APPOINT2           (procedure in BAR.PRG)
*!
*!          Calls: IIF()              (function  in ?)
*!               : FCOUNT()           (function  in ?)
*!               : TYPE()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : SPAC()             (function  in ?)
*!               : LEN()              (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : LEFT()             (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : LTRIM()            (function  in ?)
*!               : STR()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!               : SYS()              (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc print_time		&& ใช้หลาย file r1_came,refer1
store 0 to gtotal,g1,g2,g3
*maxj=iif(condition2>1,3,1)
uprow=iif(fcount() > 18 .and. type(field(18))='L',25,24)      && came file
for i=1 to uprow
   g1=g1+bb(i,1)
   g2=g2+bb(i,2)
   g3=g3+bb(i,3)
next
gtotal=g1+g2+g3
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
ch='00:00-00:59'
?? spac(13),heading
?
if condition2>1
   ?spac(6),fname,spac(19-len(fname)),'รวม ',spac(5),'ร้อยละ'
   ??space(6),'เขตข้อมูล',field(condition2)
   do case
   case type('y(1)')='D'
      ?space(44),y(1),y(2),' ',y(3)
   case type('y(1)')='L'
      ? space(49),y(1)
      ??space(8),y(2)
   other
      ? space(51-len(left(y(1),9))),y(1),
      ??space(11-len(left(y(2),9))),y(2),
      ??space(9-len(left(y(3),9)))+y(3)
   endcase
else
   ?space(6),fname,spac(19-len(fname)),'รวม ',spac(5),'ร้อยละ'
endi
sum1row=iif(condition2>1,bb(24,1)+bb(24,2)+bb(24,3),bb(24,1))
?
?space(6),ch,space(6),tran(sum1row,'#####'),space(3),tran(100*sum1row/gtotal,'#####.##'),
if condition2>1
   ??space(3),tran(bb(24,1),'####'),space(6),tran(bb(24,2),'####'),
   if type('y(1)')#'L'
     ??space(4),tran(bb(24,3),'####')
   endi
endi
for i=1 to 23
   ch=ltrim(str(i))
   ch=iif(len(ch)=1,'0'+ch,ch)
   ch=ch+':00-'+ch+':59'
   if i=23
      ch='23:00-24:00'
   endi
   sum1row=iif(condition2>1,bb(i,1)+bb(i,2)+bb(i,3),bb(i,1))
   ?space(6),ch,space(6),tran(sum1row,'#####'),space(3),tran(100*sum1row/gtotal,'#####.##'),
   if condition2>1
      ??space(3),tran(bb(i,1),'####'),space(6),tran(bb(i,2),'####'),
      if type('y(1)')#'L'
        ??space(4),tran(bb(i,3),'####')
      endi
   endi
   if i=16
      =inkey(4)
   endi
endfor
if fcount() > 18 .and. type(field(18))='L'      && came file
   sum1row=iif(condition2>1,bb(25,1)+bb(25,2)+bb(25,3),bb(25,1))
   ?space(6),'     >24:00',space(6),tran(sum1row,'#####'),space(3),tran(100*sum1row/gtotal,'#####.##'),
   if condition2>1
      ??space(3),tran(bb(25,1),'####'),space(6),tran(bb(i,2),'####'),
      if type('y(1)')#'L'
        ??space(4),tran(bb(25,3),'####')
      endi
   endi
endi
***********
?
if condition2=1
   ?space(10),'รวม ',spac(8-len('รวม')),space(2),tran(gtotal,'######'),spac(5),'100.00',
else
   ?space(10),'รวม ',spac(8-len('รวม')),space(2),tran(gtotal,'######'),spac(5),'100.00',
   ??space(2),tran(g1,'#####'),space(5),tran(g2,'#####'),
   if type('y(1)')#'L'
    ??space(3),tran(g3,'#####')
   endi
endi
?
if print_flag .and. sys(102)='ON'
   eject
   set cons on
endi
=inkey(4)
set print to
set print off
clea
retu
*!*****************************************************************************
*!
*!      Procedure: INTVAR
*!
*!*****************************************************************************
proc intvar
i=1
go top
do whil i<=fieldmax
   bb(i)=0
   i=i+1
endd
aa(1)=.t.
aa(2)=.f.
retu
*!*****************************************************************************
*!
*!      Procedure: LAB
*!
*!      Called by: APPOINT2           (procedure in BAR.PRG)
*!
*!*****************************************************************************
proc lab
aa(1)='CBC'
aa(2)='UA'
aa(3)='CXR'
aa(4)='EKG'
aa(5)='BUN Cr'
aa(6)='Electrolyte'
aa(7)='LFT'
aa(8)='FBS'
aa(9)='VDRL'
aa(10)='Anti HIV'
aa(11)='Ultrasound'
aa(12)='HBsAg'
for i=1 to 12
   desaa(i)=aa(i)
endf
retu
**********************     inst_app    **********
*!*****************************************************************************
*!
*!      Procedure: INST_APP
*!
*!      Called by: YOURCHOICE         (procedure in BAR.PRG)
*!
*!          Calls: FILE()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!
*!   Memory Files: DIAG.MEM
*!
*!*****************************************************************************
proc inst_app
clea
dime listmain(2)
listmain(1)=' แฟ้มข้อมูลการนัดหมาย'
listmain(2)=' เลิกงาน'
@5,10 menu listmain,2 title ' รายการกำหนดค่าตัวแปร  '
read menu to requ
clea
if requ=2
   retu
endi
if file('DIAG.MEM')
   rest from diag addi
endi
aaappoint=space(7)
@8,10 say 'พิมพ์ชื่อแฟ้มข้อมูล  ' get aaappoint pict '@!';
   mess 'APPOINT'
READ NOLOCK
dele file diag.mem
save to diag all like aa*
clea
retu
*!*****************************************************************************
*!
*!      Procedure: RETRIVEFILE
*!
*!      Called by: CAPFILE            (procedure in BAR.PRG)
*!
*!          Calls: PROMPT()           (function  in ?)
*!               : MOVEPROC           (procedure in BAR.PRG)
*!               : LASTKEY()          (function  in ?)
*!
*!*****************************************************************************
proc retrivefile
para _filename
define popup movinpop from 2,7 to 20, 22 prompt files like *.dbf ;
   title 'Programs'
activate popup movinpop nowait

on selection popup movinpop do moveproc with prompt()
for count = 1 to 10
   size popup movinpop by 0,1 && Enlarge the popup
next
move popup movinpop to -20,50 && Move popup up above screen

for count = 1 to 22
   move popup movinpop by 1,0 && Move popup down
next

*FOR count = 1 TO 8
*	SIZE POPUP movinpop BY 0,-1 && Return popup to previous size
*NEXT

*FOR count = 1 TO 20
*	MOVE POPUP movinpop BY 0,-1 && Return popup to original position
*NEXT
activate popup movinpop
if lastkey()=27
   deactivate popup movinpop
else
   _filename=prompt()
endif
clea
retu
*!*****************************************************************************
*!
*!      Procedure: MOVEPROC
*!
*!      Called by: RETRIVEFILE        (procedure in BAR.PRG)
*!
*!          Calls: USED()             (function  in ?)
*!
*!           Uses: &CHOICE
*!
*!*****************************************************************************
procedure moveproc
parameters choice
deactivate popup movinpop
release popup    movinpop
if ! used(choice)
dbfuse = choice
USE &choice
dbfuse = ''
endi
return
******************   CROSSTAB
*!*****************************************************************************
*!
*!      Procedure: OTHER1
*!
*!      Called by: YOURCHOICE         (procedure in BAR.PRG)
*!
*!          Calls: SPACE()            (function  in ?)
*!               : REQ_PRINTER        (procedure in BAR.PRG)
*!               : CAPFILE            (procedure in BAR.PRG)
*!               : RECCOUNT()         (function  in ?)
*!               : PROCESS            (procedure in BAR.PRG)
*!
*!*****************************************************************************
proc other1
dime x(5),y(10),xy(10)
mtotal=0
for j=1 to 10
   xy(j)=0
endfor
large=10
sfield=1
filename=space(20)
sele 1
print_flag=.t.		&& printer
on key label ctrl+p do req_printer with print_flag
do req_printer with print_flag
do capfile with large,sfield,filename
if reccount()=0
   retu
endi
do process
*sele 2
*do capFILE WITH 5
return
*!*****************************************************************************
*!
*!      Procedure: CAPFILE
*!
*!      Called by: OTHER1             (procedure in BAR.PRG)
*!
*!          Calls: RETRIVEFILE        (procedure in BAR.PRG)
*!               : RECCOUNT()         (function  in ?)
*!               : CHR()              (function  in ?)
*!               : INKEY()            (function  in ?)
*!               : FCOUNT()           (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : TYPE()             (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : LEN()              (function  in ?)
*!               : DATE()             (function  in ?)
*!               : LTRIM()            (function  in ?)
*!               : STR()              (function  in ?)
*!               : LASTKEY()          (function  in ?)
*!               : IIF()              (function  in ?)
*!               : EMPTY()            (function  in ?)
*!               : ALLTRIM()          (function  in ?)
*!
*!*****************************************************************************
proc capfile
para amt,_sfield,file_name     && amt=large=10
do retrivefile with file_name
if reccount()=0
   ??chr(7)
   @19,18 to 21,40 double
   @20,20 say 'ไม่มีข้อมูลในแฟ้มนี้'
   =inkey(4)
   @19,1 to 21,80 clea
   retu
endi
c=fcount()
dime show(c)
for a=1 to c
   store field(a) to show(a)
next
@ 2,12 say file_name
@ 4,10 get _sfield from show size 10,26
READ NOLOCK
do case
case type(field(_sfield))='C'
   y(1)=eval(field(_sfield))
   for aa=2 to amt
      y(aa)=space(len(y(1)))
   next
case type(field(_sfield))='L'
   y(1)=.t.
   y(2)=.f.
   amt=2
   retu
case type(field(_sfield))='D'
   for aa=1 to amt
      y(aa)=date()
   next
case type(field(_sfield))='M'
   for aa=1 to amt
      y(aa)=space(10)
   next
case type(field(_sfield))='N'
   for aa=1 to amt
      y(aa)=0
   next
endcase
k=1
@3,53 say 'กำหนดค่าตัวแปร'
@4,40 to 15,72 double
@4,40 to 19,72 double
@16,42 say 'หมายเหตุ'
@17,42 say '1. กำหนดได้สูงสุด 10 รายการ'
@18,42 say '2. กด ESC เมื่อไม่ครบ 10 รายการ'
do while .t.
   @k+4,45 say 'no.'+ltrim(str(k))+space(2) get y(k) pict '@!'
   READ NOLOCK
   k=k+1
   if k>=11 .or. lastkey()=27
      exit
   endi
   if lastkey()=5 .or. lastkey()=19 .or. lastkey()=18  && up,left,pgup
      k=k-2
   endi
endd
amt=iif(lastkey()=27,k-2,k-1)
de=0
for p=amt to 1 step -1
   de=iif(empty(y(p)),de+1,de)
next
amt=amt-de
if type(field(_sfield))='M'
   for p=1 to amt
      y(p)=alltrim(y(p))
   next
endi
retu
*!*****************************************************************************
*!
*!      Procedure: PROCESS
*!
*!      Called by: OTHER1             (procedure in BAR.PRG)
*!
*!          Calls: TYPE()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : EOF()              (function  in ?)
*!               : IIF()              (function  in ?)
*!               : UPPE()             (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : JOBNOTMEMO         (procedure in BAR.PRG)
*!               : PRINTOTHER         (procedure in BAR.PRG)
*!
*!*****************************************************************************
proc process
clea
go top
do scale
if type(field(sfield))='M'
   do whil ! eof()
      for j=1 to large
         xy(j)=iif(y(j)$uppe(eval(field(sfield))),xy(j)+1,xy(j))
      next
      skip
      if recno()*10/retot >ten .and. ten <10
        do success
      endi
   enddo
else
   do jobnotmemo
endi
deac wind keep
do printother
retu
*!*****************************************************************************
*!
*!      Procedure: JOBNOTMEMO
*!
*!      Called by: PROCESS            (procedure in BAR.PRG)
*!
*!          Calls: EOF()              (function  in ?)
*!               : ASCAN()            (function  in ?)
*!               : EVAL()             (function  in ?)
*!               : FIELD()            (function  in ?)
*!
*!*****************************************************************************
proc jobnotmemo
do whil ! eof()
   *  if empty(hn)
   *     skip
   *     loop
   *  endi
   seat=ascan(y,eval(field(sfield)))
   if seat =0
      skip
      loop
   endi
   xy(seat)=xy(seat)+1
   skip
   if recno()*10/retot >ten .and. ten <10
      do success
   endi
enddo
retu
*!*****************************************************************************
*!
*!      Procedure: PRINTOTHER
*!
*!      Called by: PROCESS            (procedure in BAR.PRG)
*!
*!          Calls: LEN()              (function  in ?)
*!               : FIELD()            (function  in ?)
*!               : SPACE()            (function  in ?)
*!               : REPLI()            (function  in ?)
*!               : IIF()              (function  in ?)
*!               : TYPE()             (function  in ?)
*!               : TRAN()             (function  in ?)
*!               : INKEY()            (function  in ?)
*!
*!    Other Files: &DISKFILE
*!
*!*****************************************************************************
proc printother
clea		&& P R I N T I N G
if print_flag
   set cons off
else
   diskfile='opdfile'+'.dat'
   set print to &diskfile addi
endi
set print on
l=27-len(('เขตข้อมูล'+field(sfield)))
?space(10),filename
?
?space(2),repli('_',44)
?space(5),'เขตข้อมูล '+field(sfield),space(l),'รวม(ครั้ง)'
?space(2),repli('_',44)
sumall=0
leftmargin=8
for h=1 to large
  do case
   case type('y(h)')='L'
        ll=24
   case type('y(h)')='N'
        ll=l+9
        leftmargin=1
   case type('y(h)')='C'
        ll=27-len(y(h))
   case type('y(h)')='M'
        ll=l+5
        y(h)=iif(len(y(h))<11,y(h)+space(10-len(y(h))),y(h))
   other
        ll=l+5
  endc
   ?space(leftmargin),y(h),space(ll),tran(xy(h),'######')
   sumall=sumall+xy(h)
next
?space(2),repli('_',44)
?space(8),'รวม',space(24),tran(sumall,'######')
?space(2),repli('_',44)
?
=inkey(5)
set print to
set print off
clea
retu
proc scale
publ xscale,ten,retot
define wind keep from 4,10 to 8,55 shadow
acti window keep
@1,1 say '|-------|-------|-------|-------|-------|'
@2,1 say '0       2       4       6       8      10'
 retot=reccount()
 xscale=1
 ten=0
retu
proc success
@ 0,xscale say repl(chr(11),4)
xscale=xscale+4
ten=ten+1
retu
******************
*: EOF: BAR.PRG

