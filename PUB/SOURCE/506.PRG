**************************
* 506 list generating program
**************************
PRIVATE goon,prepage
SAVE SCREE TO prepage
DEAC WIND ALL
goon = .T.
SELE 0
IF ! FILE('CODE506.DBF')
	dbfuse = 'code506p'
	USE code506p ALIA code
ELSE
	dbfuse = 'code506'
	USE code506 ALIA code
ENDI
SELE 0
IF ! FILE('NAME506.DBF')
	dbfuse = 'name506'
	USE name506p ALIA name
ELSE
	dbfuse = 'name506p'
	USE name506 ALIA name
ENDI
dbfuse = ''
numrec = RECCOUNT()
mdate = CE2BE(DATE(),2)
mreporter=space(40)
do while goon

	define window ask from 5,10 to 12,70 shadow double color w++/r
	activate window ask
	@ 0,10 say 'เลือกวันที่ ที่ต้องการตรวจหาผู้ที่ต้องรายงาน 506' 
	@ 1,0 say replicate('-',wcols())
	@ 2,10 say '(วัน/เดือน/พ.ศ.)'
	@ 4,2 say 'ผู้รายงาน'
	@ 5,24 say 'Esc to EXIT' color gr+/r
	@ 2,28 get mdate VALID TRUEDATE(mdate) .OR. LASTKEY() = 27 PICT '99/99/99'
	@ 4,14 get mreporter
	READ NOLOCK
	release window ask
	if LASTKEY() # 27
		yy=right(mdate,2)
		mm=SUBS(mdate,4,2)
		mcdate = BE2CE(mdate)
		opdfile=opddir+'came'+yy+mm+'.dbf'
		if !files(opdfile)
			?? chr(7)
			wait 'ไม่มีข้อมูลของ เดือน '+mm+'/'+yy window timeout 5
		ELSE

			if used('OPD')
				select ('OPD')
			else
				select 0
				dbfuse = opdfile
				use (opdfile) alias opd
			endif
			dbfuse = ''
			temp=tempdir+sys(3)+'.DBF'
			clear
			@ 10,30 say 'กำลังนับจำนวน .... โปรดคอยสักครู่' color g+/b
			@ 12,27 say 'แฟ้มชั่วคราวคือ :  '+temp color r+/b
			copy to (temp) for date=mcdate

			dbfuse = TEMP
			if used('CAME')
				select came
				use
				select 0 
				use (temp) alias came
			else
				SELE 0
				use (temp) alias came
			endif
			dbfuse = ''
			dimension mcase(1,17)
			mcase=' '
SELE code
numcode=RECCOUNT()
DIME code506[numcode,3]
COPY TO ARRAY code506

			select came
			totalcase=reccount()
			j=0
			go top
			i=1
			scan FOR episode $ '12'
				mdiag=diag
				FOR nn = 1 TO numcode
					pos =IIF(BETWEEN(mdiag,code506[nn,2],code506[nn,3]),code506[nn,1],0)
					IF pos>0
						EXIT
					ENDI
				NEXT
				if pos>0
					mcase(i,1)=came.diag
					mcase(i,4)=came.hn
				
					select name
					GO pos
					mcase(i,2)=rtrim(substr(desc,1,55))
			
					select patient1
					seek(mcase(i,4))
					mcase(i,3)=De_name(patient1.name)
					mcase(i,7)=nowage(patient1.birthday)
					mmom=DE_name(patient1.mother)
					mcase(i,5)=IIF(val(mcase(i,7))<15,mmom,' ')
					mcase(i,6)=IIF(patient1.sex='1','ชาย','หญิง')
		
					select patient2
					seek(mcase(i,4))
					mmarry=patient2.marriage
					do case
						case mmarry='1'
							mcase(i,8)='โสด'
						case mmarry='2'
							mcase(i,8)='คู่'
						case mmarry='3'
							mcase(i,8)='หม้าย'
						case mmarry='4'
							mcase(i,8)='หย่าร้าง'
						case mmarry='5'
							mcase(i,8)='แยก'
						case mmarry='6'
							mcase(i,8)='สมณะ'
						otherwise
							mcase(i,8)=' '
					endcase
					mrace=patient2.race
					mocc=patient2.occupa
					select nation
					SEEK mrace
					mcase(i,9)=alltrim(nation.name)
					select occupat
					SEEK mocc
					mcase(i,10)=alltrim(occupat.name)
		
					select contact
					seek(mcase(i,4))
					madd=contact.address
					mvil=contact.village
					mtam=contact.tambon
					mamp=contact.ampur
					mcha=contact.changwat
					IF ! USED('address')
						dbfuse = codedir + 'address'
						USE (codedir+'address') ORDER 1 IN 0
						dbfuse = ''
					ENDI
					select address
					SEEK '1'+mcha
					mcase(i,11)=' จ.'+alltrim(address.name)
					SEEK '2'+mcha+mamp
					mcase(i,11)=' อ.'+alltrim(address.name)+mcase(i,11)
					SEEK '3'+mcha+mamp+mtam
					mcase(i,11)=alltrim(madd)+' หมู่ '+alltrim(mvil)+' ต.'+alltrim(address.name)+mcase(i,11)
	
					select came
					mcase(i,12)=CE2CBE(came.ill_date)
					mcase(i,13)=CE2CBE(came.date)
					mcase(i,14)='ผู้ป่วยนอก'
					mcase(i,15)=rtrim(mreporter)
					mcase(i,16)=rtrim(m.hosp_name)
					mcase(i,17)=mcase(i,13)
					i=i+1
					dimension mcase(i,17)
				endif
				j=j+1
				=ShwProg(totalcase,j,13,10,60)
			endscan
			if alen(mcase,1)>1
				dimension mcase(i-1,17)
				=asort(mcase,4)
			endif

			ans='1'
			DO WHIL .T.
				DEAC WIND ALL
				clear
				@ 7,10 say 'พบ case ที่ต้องรายงาน จำนวน'
				@ 7,45 say IIF(empty(mcase(1,1)),'0',str(alen(mcase,1),3)) color gr+/b
				@ 7,50 say 'ราย'
				@ 9,10 say 'เลือก  1. ดูรายชื่อและ HN ทางจอภาพ (ไม่เกิน 20 ราย)'
				@ 10,10 say '       2. ดูรายละเอียดทางจอภาพ'
				@ 11,10 say '       3. พิมพ์ออกทางเครื่องพิมพ์'
				@ 12,10 say '       4. พิมพ์เฉพาะรายชื่อและ HN'
				@ 13,10 SAY '       5. ดูวันอื่นอีก'
				@ 14,10 say '       6. Exit'
				@ 16,10 say 'โปรดเลือก ->>'
				@ 16,30 get ans picture '9' valid ans$'123456'
				READ NOLOCK
	
				do case
				case ans='1'
				SET CLOCK OFF
				clear
				@ 0,2 say 'รายชื่อ ผู้มารับบริการที่จะต้องทำรายงาน 506' color g+/b
				@ 0,60 say 'วันที่ '+CE2CBE(mcdate) color gr+/b
				@ 1,4 say 'HN'
				@ 1,16 say 'ชื่อ'
				@ 1,48 say 'Diagnosis'
				@ 2,1 say replicate('-',78)
				row=2
				if alen(mcase,1)>=20
					for i=1 to 20
						@ row+i,1 say mcase(i,4)
						@ row+i,9 say mcase(i,3)
						@ row+i,39 say mcase(i,1)
						@ row+i,45 say substr(mcase(i,2),1,34)
					endfor
				else
					for i=1 to alen(mcase,1)
						@ row+i,1 say str(val(mcase(i,4)),7)
						@ row+i,9 say mcase(i,3)
						@ row+i,39 say mcase(i,1)
						@ row+i,45 say substr(mcase(i,2),1,34)
					endfor
				endif	
				@ 23,1 say replicate('-',78)
				@ 24,1 say CE2CBE(date())
				@ 24,20 say IIF(alen(mcase,1)>20,'มีรายชื่อมากกว่า 20 ราย',' ') color gr+/b
				@ 24,70 say time()
				wait '' window
				clear
				SET CLOCK ON

			case ans='2'
				for i=1 to alen(mcase,1)
				clear
				@ 2,1 say 'Diagnosis :'
				@ 2,13 say mcase(i,1) color r+/b
				@ 2,20 say mcase(i,2) color gr+/b
				@ 3,1 say 'ชื่อผู้ป่วย'
				@ 3,15 say mcase(i,3) color gr+/b
				@ 3,60 say 'HN.'
				@ 3,63 say mcase(i,4) color r+/b
				@ 4,1 say 'ชื่อมารดา'
				@ 4,15 say mcase(i,5) color gr+/b
				@ 5,1 say 'เพศ'
				@ 5,5 say mcase(i,6) color gr+/b
				@ 5,15 say 'อายุ'
				@ 5,20 say mcase(i,7) color gr+/b
				@ 5,30 say 'ภาวะสมรส'
				@ 5,40 say mcase(i,8) color gr+/b
				@ 5,50 say 'เชื้อชาติ'
				@ 5,62 say mcase(i,9) color gr+/b
				@ 6,1 say 'อาชีพ'
				@ 6,10 say mcase(i,10) color gr+/b
				@ 7,1 say 'ที่อยู่'
				@ 7,10 say mcase(i,11) color gr+/b
				@ 8,1 say 'วันที่เริ่มป่วย'
				@ 8,20 say mcase(i,12) color g+/b
				@ 8,40 say 'วันที่พบผู้ป่วย'
				@ 8,60 say mcase(i,13) color g+/b
				@ 9,1 say 'ประเภทผู้ป่วย'
				@ 9,15 say mcase(i,14) color bg+/b
				@ 10,1 say 'ผู้รายงาน'
				@ 10,15 say mcase(i,15) color gr+/b
				@ 10,40 say mcase(i,16) color gr+/b
	
				wait '' window
			endfor
			clear
			case ans='3'
				set device to printer
				out=.F.
				for i=1 to alen(mcase,1)
				wait 'ใส่แบบฟอร์ม 506 และ กดแป้นเมื่อพร้อม' window
				on escape do letmeout
			if ! out .AND. ! CancelPrint()
				row=prow()
				row=row+4
				@ row,0 say chr(27)+'J'+chr(11)
				row=row+1
				@ row,15 say mcase(i,1)+' : '
				@ row,25 say mcase(i,2)
				row=row+15
				@ row,0 say chr(27)+'J'+chr(11)
				row=row+1	
				@ row,15 say mcase(i,3)
				@ row,55 say mcase(i,4)
				row=row+1
				@ row,55 say mcase(i,5)
				row=row+2
				@ row,15 say mcase(i,6)
				@ row,30 say mcase(i,7)
				@ row,50 say mcase(i,8)
				@ row,68 say mcase(i,9)
				row=row+5
				@ row,10 say mcase(i,11)
				row=row+4
				@ row,7 say mcase(i,12)
				@ row,25 say mcase(i,13)
				row=row+4
				@ row,55 say mcase(i,16)
				@ row,85 say mcase(i,17)
				row=row+2
				@ row,0 say chr(27)+'J'+chr(11)
				row=row+1
				@row,0 say ' '
			ELSE
				EXIT
			ENDI
			endfor
			set device to screen
			
			case ans='4'
				set device to printer
				wait 'เตรียมเครื่องพิมพ์ให้พร้อม แล้วกดแป้น' window
				IF ! CancelPrint()				
				row=prow()
				row=row+2
				@ row,20 say 'รายชื่อ ผู้มารับบริการที่จะต้องทำรายงาน 506'
				row=row+1
				@ row,20 say 'วันที่ '+CE2CBE(date()-1)
				row=row+1
				@ row,6 say 'HN'
				@ row,16 say 'ชื่อ'
				@ row,48 say 'Diagnosis'
				row=row+1
				@ row,3 say replicate('-',90)
				for i=1 to alen(mcase,1)
					@ row+i,3 say mcase(i,4)
					@ row+i,11 say mcase(i,3)
					@ row+i,41 say mcase(i,1)
					@ row+i,47 say substr(mcase(i,2),1,45)
				endfor
				row=row+i+1
				@ row,3 say replicate('-',90)
				row=row+1
				@ row,70 say CE2CBE(date())
				@ row,85 say time()
				row=row+1
				eject
			ENDI
				set device to screen
			CASE ans = '5'
				EXIT
			case ans = '6'
				clear
				restore screen from prepage
				SELE code
				USE
				SELE name
				use
				select came
				use
				dele file (temp)
				IF USED('opd')
					SELE opd
					USE
				ENDI
				return
			endcase
			ENDD
		ENDI
	ELSE
		goon = .F.
	ENDI

enddo
REST SCREE FROM prepage
SELE code
USE
SELE name
use
*IF USED('opd')
	SELE opd
	USE
*ENDI

delete file (temp)
set device to screen

Proc LetMeOut
out=.T.
on escape
set device to screen
return

**********************************
Function ShwProg
**********************************
Parameters total,now,mrow,mcol,long

if mcol+long>80
	long=80-mcol
endif
if mrow>22
	mrow=22
endif
if !wexist('progress')
	define window progress from mrow,mcol to mrow+2,mcol+long;
		double shadow title ' Progress ' color gr+/bg
	activate window progress
else
	activate window progress
endif

@ 0,0 say replicate('',int(now/total*long)) color gr+/b

if now=total
	release window progress
endif

return
