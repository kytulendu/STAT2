set talk off
set echo off
set exclusive off
set date british
close all

set proc to \pub\source\utility
restore from eye

dimension tmonth(12)
tmonth(1)='���Ҥ�'
tmonth(2)='����Ҿѹ��'
tmonth(3)='�չҤ�'
tmonth(4)='����¹'
tmonth(5)='����Ҥ�'
tmonth(6)='�Զع�¹'
tmonth(7)='�á�Ҥ�'
tmonth(8)='�ԧ�Ҥ�'
tmonth(9)='�ѹ��¹'
tmonth(10)='���Ҥ�'
tmonth(11)='��Ȩԡ�¹'
tmonth(12)='�ѹ�Ҥ�'

mdate=date()-30
mmo=padl(alltrim(str(month(mdate),2)),2,'0')
myr=str(year(mdate)+543-2500,2)

clear
define window ask from 5,5 to 10,75 double shadow
activate window ask
msg1='���͡��͹����ͧ��� ��Ǩ�Ҽ������ä�� ��������§ҹ'
@ 1,(wcols()-len(msg1))/2 say msg1
@ 3,16 say '��͹'
@ 3,22 get mmo picture '99' valid between(val(mmo),1,12)
@ 3,28 say '�.�.25'
@ 3,34 get myr picture '99' valid between(val(myr),37,50)
read
if readkey()=12 or readkey()=268
	wait '¡��ԡ��÷ӧҹ' window timeout 3
	return
endif
release window ask

yy=2500+val(myr)-543
mm=val(mmo)
opdfile='\OPD\CAME'+myr+mmo+'.DBF'

select 0
use (opdfile) order tag hdate
temp=sys(3)+'.DBF'
clear
@ 10,30 say 'Copying and Scanning..'
copy to (temp) field hn,date,diag,sex for year(date)=yy and month(date)=mm
use &temp alias came

totalcase=reccount()

dimension mcase(11,2)
mcase=0
i=0
scan
	pos=ascan(eyedis,diag)
	if pos>0 or (substr(diag,1,1)='H' and between(val(substr(diag,2,2)),0,59))
		do case
			case inlist(rtrim(diag),'H25','H250','H251','H252','H258','H259','H26','H260','H261','H262','H263','H264','H268','H269')
				mcase(1,val(sex))=mcase(1,val(sex))+1
			case inlist(rtrim(diag),'H40','H400','H401','H402','H403','H404','H405','H406','H408','H409')
				mcase(2,val(sex))=mcase(2,val(sex))+1
			case inlist(rtrim(diag),'H10','H100','H101','H102','H103','H104','H105','H108','H109','B023')
				mcase(3,val(sex))=mcase(3,val(sex))+1
			case rtrim(diag)='P391'
				mcase(4,val(sex))=mcase(4,val(sex))+1
			case rtrim(diag)='H160'
				mcase(5,val(sex))=mcase(5,val(sex))+1
			case inlist(rtrim(diag),'A71','A710','A711','A719')
				mcase(6,val(sex))=mcase(6,val(sex))+1
			case rtrim(diag)='H110'
				mcase(7,val(sex))=mcase(7,val(sex))+1
			case inlist(rtrim(diag),'E500','E501','E502','E503','E504','E505','E506','E507')
				mcase(8,val(sex))=mcase(8,val(sex))+1
			case inlist(rtrim(diag),'S05','S050','S051','S052','S053','S054','S055','S056','S057','S058','S059')
				mcase(9,val(sex))=mcase(9,val(sex))+1
			case inlist(rtrim(diag),'H52','H520','H521','H522','H523','H524','H525','H526','H527')
				mcase(10,val(sex))=mcase(10,val(sex))+1
			otherwise
				mcase(11,val(sex))=mcase(11,val(sex))+1
		endcase
	endif
	i=i+1
	=ShwProg(totalcase,i,12,10,60)
endscan

clear
@ 1,2 say '��§ҹ�������ä��' color g+/b
@ 1,50 say '��͹'
@ 1,60 say tmonth(val(mmo))+' 25'+myr color gr+/b
@ 2,2 say '�ä'
@ 2,55 say '���'
@ 2,65 say '˭ԧ'
@ 2,75 say '���'
@ 3,2 say replicate('-',76)
@ 4,2 say '1. Cataract'
@ 5,2 say '2. Glaucoma'
@ 6,2 say '3. Conjuctivitis'
@ 7,2 say '4. Neonatal Ophthalmia'
@ 8,2 say '5. Corneal Ulcer'
@ 9,2 say '6. Trachoma'
@ 10,2 say '7. Pterygium'
@ 11,2 say '8. Eye diseases due to Malnutrition'
@ 12,2 say '9. Eye injuries'
@ 13,2 say '10. Refractive error'
@ 14,2 say '11. Other'
@ 15,2 say replicate('-',76)
mtotal=0
for i=1 to alen(mcase,1)
	@ i+3,55 say str(mcase(i,1),3) color g+/b
	@ i+3,65 say str(mcase(i,2),3) color gr+/b
	@ i+3,75 say str(mcase(i,1)+mcase(i,2),3) color w+/b
	mtotal=mtotal+mcase(i,1)+mcase(i,2)
endfor
@ 16,2 say '�ѹ����͡��§ҹ'
@ 16,20 say date()
@ 16,60 say '����'
@ 16,65 say time()

ans='Y'
@ 18,10 say ' ��ͧ��þ���� ��§ҹ������� '
@ 18,45 get ans valid ans$'YyNn����'
read

if ans$'Yy��'
	wait '�Դ����ͧ�����-����д�� ����������;����' window
*print routine
	set device to printer
	maxcol=96
	row=prow()
	row=row+1
	@ row,90 say '�.101'
	row=row+2
	@ row,40 say '��§ҹ�����¹͡�ä��'
	row=row+1
	@ row,37 say '����Ѻ�ç��Һ�ŷ������ըѡ��ᾷ��'
	row=row+2
	@ row,5 say '�ç��Һ�� �ʹ�'
	@ row,30 say '����� �ʹ�'
	@ row,50 say '�ѧ��Ѵ ��й�������ظ��'
	@ row, 85 say '|_|_|_|_|'
	row=row+1
	@ row,5 say '��Ш���͹'
	@ row,18 say tmonth(mm)
	@ row,40 say '�.�.'
	@ row,45 say str(yy+543,4)
	@ row,85 say '|_|_|_|_|'
	row=row+1
	@ row,5 say '�����§ҹ ........................'
	@ row,40 say '���˹� ..............................'
	row=row+1
	@ row,5 say '�ӹǹ�����¹͡�ä�ҷ����͹ (���˭ԧ��Ъ��)'
	@ row,45 say str(mtotal,4)
	@ row,52 say '��'
	@ row,80 say '|_|_|_|'
	row=row+1
	@ row,2 say replicate('-',92)
	row=row+1
	@ row,73 say '�ӹǹ�ä'
	row=row+1
	@ row,25 say '�ä'
	@ row,60 say replicate('-',34)
	row=row+1
	@ row,65 say '���'
	@ row,75 say '˭ԧ'
	@ row,85 say '���'
	row=row+1
	@ row,2 say replicate('-',92)
	row=row+1
	@ row,5 say ' 1. ��͡�Ш� Cataract'
	@ row,65 say IIF(mcase(1,1)>0,str(mcase(1,1),3),'  -')
	@ row,75 say IIF(mcase(1,2)>0,str(mcase(1,2),3),'  -')
	@ row,85 say IIF(mcase(1,1)+mcase(1,2)>0,str(mcase(1,1)+mcase(1,2),3),'  -')
	row=row+1
	@ row,5 say ' 2. ����Թ Glaucoma'
	@ row,65 say IIF(mcase(2,1)>0,str(mcase(2,1),3),'  -')
	@ row,75 say IIF(mcase(2,2)>0,str(mcase(2,2),3),'  -')
	@ row,85 say IIF(mcase(2,1)+mcase(2,2)>0,str(mcase(2,1)+mcase(2,2),3),'  -')
	row=row+1
	@ row,5 say ' 3. ����͵��ѡ�ʺ Conjunctivitis'
	@ row,65 say IIF(mcase(3,1)>0,str(mcase(3,1),3),'  -')
	@ row,75 say IIF(mcase(3,2)>0,str(mcase(3,2),3),'  -')
	@ row,85 say IIF(mcase(3,1)+mcase(3,2)>0,str(mcase(3,1)+mcase(3,2),3),'  -')
	row=row+1
	@ row,5 say ' 4. ����͵��ѡ�ʺ����á�Դ Neonatal Ophthalmia'
	@ row,65 say IIF(mcase(4,1)>0,str(mcase(4,1),3),'  -')
	@ row,75 say IIF(mcase(4,2)>0,str(mcase(4,2),3),'  -')
	@ row,85 say IIF(mcase(4,1)+mcase(4,2)>0,str(mcase(4,1)+mcase(4,2),3),'  -')
	row=row+1
	@ row,5 say ' 5. ��㹵Ҵ� Corneal ulcer'
	@ row,65 say IIF(mcase(5,1)>0,str(mcase(5,1),3),'  -')
	@ row,75 say IIF(mcase(5,2)>0,str(mcase(5,2),3),'  -')
	@ row,85 say IIF(mcase(5,1)+mcase(5,2)>0,str(mcase(5,1)+mcase(5,2),3),'  -')
	row=row+1
	@ row,5 say ' 6. �Դ�մǧ�� Trachoma'
	@ row,65 say IIF(mcase(6,1)>0,str(mcase(6,1),3),'  -')
	@ row,75 say IIF(mcase(6,2)>0,str(mcase(6,2),3),'  -')
	@ row,85 say IIF(mcase(6,1)+mcase(6,2)>0,str(mcase(6,1)+mcase(6,2),3),'  -')
	row=row+1
	@ row,5 say ' 7. ������� Pterygium'
	@ row,65 say IIF(mcase(7,1)>0,str(mcase(7,1),3),'  -')
	@ row,75 say IIF(mcase(7,2)>0,str(mcase(7,2),3),'  -')
	@ row,85 say IIF(mcase(7,1)+mcase(7,2)>0,str(mcase(7,1)+mcase(7,2),3),'  -')
	row=row+1
	@ row,5 say ' 8. �ä�Ҩҡ��âҴ����� Eye diseases due to Malnutrition'
	@ row,65 say IIF(mcase(8,1)>0,str(mcase(8,1),3),'  -')
	@ row,75 say IIF(mcase(8,2)>0,str(mcase(8,2),3),'  -')
	@ row,85 say IIF(mcase(8,1)+mcase(8,2)>0,str(mcase(8,1)+mcase(8,2),3),'  -')
	row=row+1
	@ row,5 say ' 9. �Ҵ�纷��� Eye injuries'
	@ row,65 say IIF(mcase(9,1)>0,str(mcase(9,1),3),'  -')
	@ row,75 say IIF(mcase(9,2)>0,str(mcase(9,2),3),'  -')
	@ row,85 say IIF(mcase(9,1)+mcase(9,2)>0,str(mcase(9,1)+mcase(9,2),3),'  -')
	row=row+1
	@ row,5 say '10. ��µҼԴ���� Refractive error'
	@ row,65 say IIF(mcase(10,1)>0,str(mcase(10,1),3),'  -')
	@ row,75 say IIF(mcase(10,2)>0,str(mcase(10,2),3),'  -')
	@ row,85 say IIF(mcase(10,1)+mcase(10,2)>0,str(mcase(10,1)+mcase(10,2),3),'  -')
	row=row+1
	@ row,5 say '11. ���� Others'
	@ row,65 say IIF(mcase(11,1)>0,str(mcase(11,1),3),'  -')
	@ row,75 say IIF(mcase(11,2)>0,str(mcase(11,2),3),'  -')
	@ row,85 say IIF(mcase(11,1)+mcase(11,2)>0,str(mcase(11,1)+mcase(11,2),3),'  -')
	row=row+1
	@ row,2 say replicate('-',92)

	eject
	set device to screen
endif

clear
use
dele file &temp
wait '����÷ӧҹ' window timeout 3

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

@ 0,0 say replicate('�',int(now/total*long)) color gr+/b

if now=total
	release window progress
endif

return
