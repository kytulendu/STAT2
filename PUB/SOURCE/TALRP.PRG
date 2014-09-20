DEFINE WIND report FROM 5,30 TO 15,77 SHAD
ACTI WIND report
dbfuse = ''
numrec = RECCOUNT()
CLEA
@ 2,5 SAY 'ทำรายงานการรับบริการ ของเดือน/ปี'
@ 4,8 GET mmyy DEFA SPAC(4) PICT '@R 99/99'
READ NOLOCK
mm=LEFT(mmyy,2)
yy=RIGHT(mmyy,2)
		dir = '\opd\rpstat\'
		dirrep = '\opd\report\rpstat\'
		came1=dir+'came'+yy+mm
if !file(dir+'came'+yy+mm+'.dbf')
	=ALARM1()
	wait '   ยังไม่ได้ทำการตัดยอดผู้ป่วยเดือนนี้ ' wind
	wait '   กำลังจะทำการตัดยอดเดือนให้ ' wind
	RELE WIND report
	RELE WIND progress
	do rpopdst
	retu 0
else
if !file(dirrep+'RPN'+yy+mm+'.dbf')
	sele 1
		use\pub\rpstat\rpn
		copy stru to dirrep+'rpn'+yy+mm
		use dirrep+'rpn'+yy+mm excl
		appe blank
		use
	sele 2
		use dirrep+'rpn'+yy+mm excl

	=ALARM1()
wait '    โปรดรอ... กำลังคำนวณข้อมูล      ' wind nowa
SELE * FROM &CAME1 ;
	order by date,hn INTO  CURS CAME1
count for betw(allt(diag),'A00','B9999') .or. betw(allt(diag),'C00','C4999') .or. ;
	betw(allt(diag),'C59','C9999') .or. betw(allt(diag),'D00','E9999') .or. ;
	betw(allt(diag),'F00','G9999') .or. betw(allt(diag),'I00','I9999') .or. ;
	betw(allt(diag),'J60','J9999') .or. betw(allt(diag),'K11','K3199') .or. ;
	betw(allt(diag),'K50','K9399') .or. betw(allt(diag),'L00','N5199') .or. ;
	betw(allt(diag),'R00','R9999') .or. betw(allt(diag),'X40','X6999') .or. ;
	betw(allt(diag),'X85','X9099') .or. betw(allt(diag),'Y10','Y1999') .or. ;
	betw(allt(diag),'Y40','Y5999') .or. betw(allt(diag),'Y700','Y9899') .or.;
	betw(allt(diag),'Z71','Z719') .or. betw(allt(diag),'N99','N9999') .and. age => 15 to med

DEFINE WIND pgsc FROM 8,10 TO 14,70 SHAD
ACTI WIND pgsc
xx = 1
go top
do whil !eof()
	@ 0,0 say 'ประมวลผล.....:'
	@ 2,0 say repl('',int(xx/med*20))
	@ 4,0 say 'Complted ... :> '+str(xx/med*100,3,2)
	xx = xx+1
	skip
enddo
rele wind pgsc
count for betw(allt(diag),'A00','B9999') .or. betw(allt(diag),'C00','C4999') .or. ;
	betw(allt(diag),'C59','C9999') .or. betw(allt(diag),'D00','E9999') .or. ;
	betw(allt(diag),'F00','G9999') .or. betw(allt(diag),'I00','I9999') .or. ;
	betw(allt(diag),'J60','J9999') .or. betw(allt(diag),'K11','K3199') .or. ;
	betw(allt(diag),'K50','K9399') .or. betw(allt(diag),'L00','N5199') .or. ;
	betw(allt(diag),'R00','R9999') .or. betw(allt(diag),'X40','X6999') .or. ;
	betw(allt(diag),'X85','X9099') .or. betw(allt(diag),'Y10','Y1999') .or. ;
	betw(allt(diag),'Y40','Y5999') .or. betw(allt(diag),'Y700','Y9899') .or.;
	betw(allt(diag),'Z71','Z719') .or. betw(allt(diag),'N99','N9999') .and. age < 15 to P_med
DEFINE WIND pgsc FROM 8,10 TO 14,70 SHAD
ACTI WIND pgsc
xx = 1
go top
do whil !eof()
	@ 0,0 say 'ประมวลผล.....:'
	@ 2,0 say repl('',int(xx/P_med*20))
	@ 4,0 say 'Complted ... :> '+str(xx/P_med*100,3,2)
	xx = xx+1
	skip
enddo
rele wind pgsc
count for betw(allt(diag),'K35','K4699') .or. betw(allt(diag),'V00','X3999') .or. ;
		betw(allt(diag),'X70','X8499') .or. betw(allt(diag),'X91','Y0999') .or. ;
		betw(allt(diag),'Y20','Y3699') .or. betw(allt(diag),'Y60','Y6999') .or. ;
		betw(allt(diag),'Z48','Z4899') to sur
count for betw(allt(diag),'S02','S0299') .or. betw(allt(diag),'S12','S1299') .or. ;
			betw(allt(diag),'S22','S2299') .or. betw(allt(diag),'S32','S3299') .or. ;
			betw(allt(diag),'S42','S4299') .or. betw(allt(diag),'S52','S5299') .or. ;
			betw(allt(diag),'S62','S6299') .or. betw(allt(diag),'S72','S7299') .or. ;
			betw(allt(diag),'S82','S8299') .or. betw(allt(diag),'S92','S9299') .or. ;
			betw(allt(diag),'T02','T0299') .or. betw(allt(diag),'Z47','Z4799') to orth

count for betw(allt(diag),'H00','H5999') .and. age>=15 to Eye

count for betw(allt(diag),'H00','H5999') .and. age <15 to P_Eye
count for betw(allt(diag),'H60','H9999') .or. betw(allt(diag),'J00','J4799') .and. age>= 15 to ENT
count for betw(allt(diag),'H60','H9999') .or. betw(allt(diag),'J00','J4799') .and. age < 15 to p_ENT
count for betw(allt(diag),'K00','K1099') to Dent
count for betw(alltr(diag),'F20','F399') .or. betw(alltr(diag),'F50','F699');
          .or. betw(alltr(diag),'F80','F999') to jit
count for betw(allt(diag),'C50','C5899') .or. ;
		betw(allt(diag),'O00','O9999') to Obs
count for betw(allt(diag),'N70','N7799') .or. ;
		betw(allt(diag),'N80','N9899') to Gyn
count for betw(allt(diag),'P00','P9699') .or. ;
		betw(allt(diag),'Q00','Q9999') to ped
count for betw(allt(diag),'Z00','Z4699') .or. ;
		betw(allt(diag),'Z49','Z7099') .or. ;
		betw(allt(diag),'Z72','Z9999') to Other
count for sequence = 1 .and. t_in <= 1600 .and. t_in >= 801 to c120
count for sequence = 1 .and. t_in <= 2359 .and. t_in >= 1601  to c130_91
count for sequence = 1 .and. t_in <= 800 .and. t_in >= 0 to  c130_92
count for sequence = 1 to m.su2
count for sequence = 1 .and. sex = '1' to m.se1
count for sequence = 1 .and. sex = '2' to m.se2
count for sequence = 1 .and. new = .T. to m.new12
m.med=med
m.Sur=sur
m.Orth=orth
m.Ped=ped+p_med+p_eye+p_ent
m.EYE=eye
m.ENT=ent
m.Obs=Obs
m.gyn = gyn
m.Dent=dent
m.jit = jit
mmm = (m.su2/30)
sele 2
	repl c1 with m.su2,c2 with m.se1,c3 with m.se2,c4 with m.new12;
	,cl1 with m.med,cl2 with m.sur,cl3 with m.sur,cl4 with m.ped;
	,cl5 with m.ent,cl6 with m.obs,cl7 with m.dent,cl8 with m.jit,sc with mmm;
	,sc1 with m.c120,sc2 with m.c130_91,sc3 with m.c130_92,sc4 with m.gyn
RELE WIND report
do new_kk1
		ELSE
			CLEA
			recal = 'N'
			??CHR(7)
			@ 1,1 SAY 'ข้อมูลเคยคำนวณมาก่อน'
			@ 3,3 SAY 'ต้องการคำนวณใหม่หรือไม่ ' GET recal PICT '!'
				READ NOLOCK
		IF recal $ 'Yัํ'
				=ALARM1()
wait '    โปรดรอ... กำลังคำนวณข้อมูล      ' wind nowa
SELE * FROM &CAME1 ;
	order by date,hn where diag>'A00' INTO  CURS CAME1
count for betw(allt(diag),'A00','B9999') .or. betw(allt(diag),'C00','C4999') .or. ;
	betw(allt(diag),'C59','C9999') .or. betw(allt(diag),'D00','E9999') .or. ;
	betw(allt(diag),'F00','G9999') .or. betw(allt(diag),'I00','I9999') .or. ;
	betw(allt(diag),'J60','J9999') .or. betw(allt(diag),'K11','K3199') .or. ;
	betw(allt(diag),'K50','K9399') .or. betw(allt(diag),'L00','N5199') .or. ;
	betw(allt(diag),'R00','R9999') .or. betw(allt(diag),'X40','X6999') .or. ;
	betw(allt(diag),'X85','X9099') .or. betw(allt(diag),'Y10','Y1999') .or. ;
	betw(allt(diag),'Y40','Y5999') .or. betw(allt(diag),'Y700','Y9899') .or.;
	betw(allt(diag),'Z71','Z719') .or. betw(allt(diag),'N99','N9999') .and. age => 15 to med

DEFINE WIND pgsc FROM 8,10 TO 14,70 SHAD
ACTI WIND pgsc
xx = 1
go top
do whil !eof()
	@ 0,0 say 'ประมวลผล.....:'
	@ 2,0 say repl('',int(xx/med*20))
	@ 4,0 say 'Complted ... :> '+str(xx/med*100,3,2)
	xx = xx+1
	skip
enddo
rele wind pgsc
count for betw(allt(diag),'A00','B9999') .or. betw(allt(diag),'C00','C4999') .or. ;
	betw(allt(diag),'C59','C9999') .or. betw(allt(diag),'D00','E9999') .or. ;
	betw(allt(diag),'F00','G9999') .or. betw(allt(diag),'I00','I9999') .or. ;
	betw(allt(diag),'J60','J9999') .or. betw(allt(diag),'K11','K3199') .or. ;
	betw(allt(diag),'K50','K9399') .or. betw(allt(diag),'L00','N5199') .or. ;
	betw(allt(diag),'R00','R9999') .or. betw(allt(diag),'X40','X6999') .or. ;
	betw(allt(diag),'X85','X9099') .or. betw(allt(diag),'Y10','Y1999') .or. ;
	betw(allt(diag),'Y40','Y5999') .or. betw(allt(diag),'Y700','Y9899') .or.;
	betw(allt(diag),'Z71','Z719') .or. betw(allt(diag),'N99','N9999') .and. age < 15 to P_med
DEFINE WIND pgsc FROM 8,10 TO 14,70 SHAD
ACTI WIND pgsc
xx = 1
go top
do whil !eof()
	@ 0,0 say 'ประมวลผล.....:'
	@ 2,0 say repl('',int(xx/P_med*20))
	@ 4,0 say 'Complted ... :> '+str(xx/P_med*100,3,2)
	xx = xx+1
	skip
enddo
rele wind pgsc
count for betw(allt(diag),'K35','K4699') .or. betw(allt(diag),'V00','X3999') .or. ;
		betw(allt(diag),'X70','X8499') .or. betw(allt(diag),'X91','Y0999') .or. ;
		betw(allt(diag),'Y20','Y3699') .or. betw(allt(diag),'Y60','Y6999') .or. ;
		betw(allt(diag),'Z48','Z4899') to sur
count for betw(allt(diag),'S02','S0299') .or. betw(allt(diag),'S12','S1299') .or. ;
			betw(allt(diag),'S22','S2299') .or. betw(allt(diag),'S32','S3299') .or. ;
			betw(allt(diag),'S42','S4299') .or. betw(allt(diag),'S52','S5299') .or. ;
			betw(allt(diag),'S62','S6299') .or. betw(allt(diag),'S72','S7299') .or. ;
			betw(allt(diag),'S82','S8299') .or. betw(allt(diag),'S92','S9299') .or. ;
			betw(allt(diag),'T02','T0299') .or. betw(allt(diag),'Z47','Z4799') to orth

count for betw(allt(diag),'H00','H5999') .and. age>=15 to Eye

count for betw(allt(diag),'H00','H5999') .and. age <15 to P_Eye
count for betw(allt(diag),'H60','H9999') .or. betw(allt(diag),'J00','J4799') .and. age>= 15 to ENT
count for betw(allt(diag),'H60','H9999') .or. betw(allt(diag),'J00','J4799') .and. age < 15 to p_ENT
count for betw(allt(diag),'K00','K1099') to Dent
count for betw(alltr(diag),'F20','F399') .or. betw(alltr(diag),'F50','F699');
          .or. betw(alltr(diag),'F80','F999') to jit
count for betw(allt(diag),'C50','C5899') .or. ;
		betw(allt(diag),'O00','O9999') to Obs
count for betw(allt(diag),'N70','N7799') .or. ;
		betw(allt(diag),'N80','N9899') to Gyn
count for betw(allt(diag),'P00','P9699') .or. ;
		betw(allt(diag),'Q00','Q9999') to ped
count for betw(allt(diag),'Z00','Z4699') .or. ;
		betw(allt(diag),'Z49','Z7099') .or. ;
		betw(allt(diag),'Z72','Z9999') to Other
count for sequence = 1 .and. t_in <= 1600 .and. t_in >= 801 to c120
count for sequence = 1 .and. t_in <= 2359 .and. t_in >= 1601  to c130_91
count for sequence = 1 .and. t_in <= 800 .and. t_in >= 0 to  c130_92
count for sequence = 1 to m.su2
count for sequence = 1 .and. sex = '1' to m.se1
count for sequence = 1 .and. sex = '2' to m.se2
count for sequence = 1 .and. new = .T. to m.new12
m.med=med
m.Sur=sur
m.Orth=orth
m.Ped=ped+p_med+p_eye+p_ent
m.EYE=eye
m.ENT=ent
m.obs=obs
m.Obs=Obs
m.Dent=dent
m.jit = jit
mmm = (m.su2/30)
sele 2
	use dirrep+'rpn'+yy+mm excl
	repl c1 with m.su2,c2 with m.se1,c3 with m.se2,c4 with m.new12;
	,cl1 with m.med,cl2 with m.sur,cl3 with m.sur,cl4 with m.ped;
	,cl5 with m.ent,cl6 with m.obs,cl7 with m.dent,cl8 with m.jit,sc with mmm;
	,sc1 with m.c120,sc2 with m.c130_91,sc3 with m.c130_92,sc4 with m.gyn
RELE WIND report
do new_kk1

		ELSE
			sele 2
			use dirrep+'rpn'+yy+mm
	m.su2 = c1
	m.se1 = c2
	m.se2 = c3
	m.new12 = c4
	m.med = cl1
	m.sur = cl2
	m.orth = cl3
	m.ped = cl4
	m.ent = cl5
	m.obs = cl6
	m.gyn=sc4
	m.dent = cl7
	m.jit = cl8
	mmm = sc
	m.c120 = sc1
	m.c130_91 = sc2
	m.c130_92 = sc3
	RELE WIND report
	do new_kk1
		ENDIF
	ENDIF
ENDIF
*********
proc new_kk1
*********
DEFINE WIND report1 FROM 00,00 TO 24,79 SHAD
ACTI WIND report1
@00,00 clear to 24,78
@02,02 say '  รายงานผู้ป่วยที่มารับบริการ' color g+/b
@03,02 say '  ----------------------------------------' color g+/b
@05,01 to 13,42
@07,02 say 'ผู้ป่วยรับบริการทั้งหมด(ราย)' color gr+/b
@07,30 say m.su2
@08,02 say 'เพศ ชาย(ราย)' color gr+/b
@08,30 say m.se1
@09,02 say 'เพศ หญิง(ราย)' color gr+/b
@09,30 say m.se2
@10,02 say 'ผู้ป่วยใหม่(ราย)' color gr+/b
@10,30 say m.new12
@11,02 say 'ผู้ป่วยรับบริการ(NO Z)' color gr+/b
ms = m.su2-other
@11,30 say ms
@13,01 to 19,41
@14,02 say 'ผู้ป่วยเฉลี่ย ราย/วัน' color gr+/b
mmM = (m.su2/30)
@15,15 say mmM
@05,42 to 14,78
@05,44 say 'ผู้ป่วยแยกแผนก' color br+/b
@06,45 say 'อายุรกรรม...........' color gr+/b
@06,67 say m.med
@07,45 say 'ศัลยกรรม - ทั่วไป ....' color gr+/b
@07,67 say m.sur
@08,45 say '        - กระดูก....' color gr+/b
@08,67 say m.orth
@09,45 say 'เด็ก................' color gr+/b
@09,67 say m.ped
@10,45 say 'หู คอ จมูก...........' color gr+/b
@10,67 say m.ent
@11,45 say 'สูติ.................' color gr+/b
@11,67 say m.Obs
@12,45 say 'นรีเวช..............' color gr+/b
@12,67 say m.gyn
@13,45 say 'ทันตกรรม............' color gr+/b
@13,67 say m.dent
@15,43 to 20,78
@15,45 say 'การรับบริการ' color br+/b
@16,46 say 'เวรเช้า' color gr+/b
@16,56 say 'เวรบ่าย' color gr+/b
@16,66 say 'เวรดึก' color gr+/b
@17,43 say m.c120
@17,53 say m.c130_91
@17,63 say m.c130_92
wait 'เรียบร้อย...ตรวสอบรายงาน ' wind nowa
@21,30 say ' กดปุ่มใด ๆเพื่อทำงานต่อ ' color gr+/b
wait ' '
RELE WIND report1
close data
retu 0