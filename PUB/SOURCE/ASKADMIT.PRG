PARA _fromstat2
PRIV goon
ON KEY LABEL F10 DO NumCopy WITH .T.
fromstat2 = IIF(PARAMETERS()>0 .AND. _fromstat2 , .T. , .F. )
DIME printrp[6]
printrp(1)= 'พิมพ์501' 
printrp(2)= 'พิมพ์502'
printrp(3)= 'พิมพ์503'
printrp(4)= 'บันทึก/ไม่พิมพ์'
printrp(5)= 'แก้ไข'
printrp(6)= 'ยกเลิก'
prinLEVEL=6
prinSpace=75/prinLEVEL	
DEFINE WIND admit FROM 10,1 TO 16,78 SHAD TITLE '  รับผู้ป่วย  '
ACTI WIND admit
goon = .t.
mward=SPACE(25)
DO WHILE goon
	goon = .F.
	@ 1,3 SAY 'รับผู้ป่วยไว้ในหอ ' get m.ward_adm WHEN Inputward(m.ward_adm) VALID CheckWard(m.ward_adm,mward) ;
	MESS 'ใส่รหัสหอผู้ป่วย' DEFA SPACE(3)
	@ 2,3 get mward DISA COLO ,,,,,,,,,/w
	READ NOLOCK
	ACTI SCREE
	@ 24,0
	IF ! EMPTY(m.ward_adm)
		SELE iptrana
		SET ORDER TO 1
		IF seek(m.hn)
			mward_adm = m.ward_adm
			SELE ward
			SEEK iptrana.ward_now
			SELE iptrana
			DEFINE WIND notice FROM 3,5 TO 11,70 SHAD COLO gr+/w 
			ACTI WIND notice
  			@ 1,1 say "          ตรวจพบชื่อผู้ป่วยอยู่ในโรงพยาบาล กรุณาตรวจสอบอีกครั้ง"
  			@ 2,1 say "    ถ้าไม่ต้องการทำ ADMIT ต่อ ให้กดปุ่ม Esc เพื่อยกเลิกการ Admit" 
  			@ 4,1 say "    HN       AN           WARD                     ADMIT"
			@ 5,1 say hn+'   '+RIGHT(an,5)+'-'+LEFT(an,2)+'     '+ward->name+' '+ce2cbe(dateadm)
				wait ' '			
			m.ward_adm = mward_adm
			RELE WIND notice
		 	IF lastkey()=27
				DO clearscreen
				on key label PGUP
				deac wind admit
				return 
			ENDIF
	  	ENDIF
		IF fromstat2
			m.dateadm = DATE()
			m.dep = LEFT(patient1.clinic,2)
		ELSE
			m.dateadm=m.date
		ENDI
		m.dateadm = IIF( EMPTY(m.dateadm),DATE(),m.dateadm)
		m.timeadm=substr(time(),1,2)+substr(time(),4,2)
		IF TYPE('mdate') # 'U' AND TYPE('mt_out') # 'U'
			m.dateadm = BE2CE(mdate)
			m.timeadm = mt_out
		ENDI
		*m.ssn=substr(m.mssn,1,2)+substr(m.mssn,4,7)+substr(m.mssn,12,1)
		*m.facn=m.facn1
		m.ward_now=m.ward_adm
		m.date_now=m.dateadm
		m.time_now=m.timeadm
		m.pttyp = patient1.class
		myears = IIF(fromstat2,RIGHT(CE2BE(DATE()),2),RIGHT(mdate,2))
		xx=1
		
		ACTI WIND admit
		col = 0
		DO NumCopy WITH .F.
		DO WHIL xx<=prinlevel
			@ 4,col+2 PROMPT printrp(xx)
			col = COL()
			xx=xx+1
		ENDD
		MENU TO Chprin
		IF ! BETWEEN(chprin,1,prinlevel-1)
			EXIT
		ENDI
		IF BETWEEN(chprin,1,4)
			SELE cancelan
			GO TOP
			DO WHIL ! RLOCK() .AND. ! EOF()
				SKIP
			ENDD
			IF ISDIGIT(an) .AND. LEFT(an,2) # myears
				REPL an WITH 'ZZZZZZZ'
				FLUSH
			ENDI
			IF ! EOF() .AND. ISDIGIT(an) 
				m.an = an
				REPL an WITH 'ZZZZZZZ'
				FLUSH
			ELSE
				SELE ancount
				DO WHIL ! LASTKEY() = 27 .AND. ! FLOCK()
					WAIT WIND NOWA 'กำลังเรียกหมายเลข AN อยู่ โปรดคอยสักครู่'
				ENDD
				IF FLOCK()
					IF myears > year
						REPL year WITH myears,lastan WITH 0
						FLUSH
					ENDI
					newan=IIF(lastan<99999,lastan+1,1)
					m.an = year+STRZERO(newan,5)
					REPL lastan WITH newan
					FLUSH
				ELSE
					WAIT WIND 'ไม่สามารถออกเลขที่ผู้ป่วยในได้ ยกเลิกการ Admit ' TIME 2
					UNLOCK ALL
					RETU
				ENDI
			ENDI
			UNLOCK ALL
			IF LASTKEY() # 27
				WAIT WIND NOWA 'คนไข้ได้เลขที่ AN '+RIGHT(m.an,5)+'-'+LEFT(m.an,2)
				SELE iptrana
				GO TOP
				oldtag = TAG()
				m.onset = IIF( fromstat2, 1, ill_d)
				IF ! EMPTY(hn)
					SET ORDER TO TAG datedsc
					SET FILT TO ! EMPTY(datedsc) AND dx_stat
					GO TOP
					IF EOF() OR (datedsc + 7  > DATE())
						APPE BLANK
					ENDI
					SET FILT TO
					SET ORDER TO TAG hn
				ELSE
					IF EOF()
						APPE BLANK
					ENDI
				ENDI
				GATH MEMV
				FLUSH
				IF ! USED('newcase')
					dbfuse = patientdir+'new'+myears
					USE (patientdir+'new'+myears) ORDER 1 IN 0 ALIA newcase
					opennew = .T.
				ELSE
					opennew = .F.
				ENDI
				dbfuse = ''
				SELE newcase
				IF ! SEEK(m.hn)
					IF ! _fromstat2
						INSERT INTO newcase FROM MEMVAR
					ENDI
					FLUSH
				ENDI
				IF opennew
					USE
				ENDI
				DO CASE
					CASE ChPrin=1
						FOR i = 1 TO hosp_rp
							IF FILE('rp501.fxp')
								DO ('rp501')
							ELSE
								DO RP501p
							ENDI
						NEXT
					CASE ChPrin=2
						FOR i = 1 TO hosp_rp
							IF FILE('rp502.fxp')
								DO ('rp502')
							ELSE
								DO RP502p
							ENDI
						NEXT
					CASE ChPrin=3
						FOR i = 1 TO hosp_rp
							IF FILE('rp503.fxp')
								DO ('rp503')
							ELSE
								DO RP503p
							ENDI
						NEXT
				ENDC
				SELE medrec
				SEEK m.hn
				DO WHIL hn = m.hn .AND. status
					SKIP
				ENDD
				IF hn = m.hn
					REPL who WITH 'W'+m.ward_adm
					FLUSH
				ENDI
			ELSE
				?? CHR(7)
				WAIT 'ไม่สามารถเรียกหมายเลขผู้ป่วยในได้ ไม่ได้ทำ Admit' WINDOW TIME 10
			ENDI
		ELSE
			goon = .T.
			@ 4,0
		ENDI
	ENDI
ENDD
UNLOCK ALL
RELE WIND admit
ON KEY LABEL F10

PROC NUMCOPY
PARA _ask
KEYB '!'
IF TYPE('hosp_rp') = 'U'
	PUBL hosp_rp
	hosp_rp = 1
ENDI
IF _ask
	DEFINE WIND Ask FROM 3,20 TO 6,60
	ACTI WIND ask
	@ 1,3 SAY 'ต้องการพิมพ์กี่ชุด  ' GET hosp_rp PICT '9'
	READ NOLOCK
	RELE WIND ask
ENDI
CLEA TYPE
WAIT WIND NOWA 'พิมพ์ใบรง.5 จำนวน '+STR(hosp_rp,1)+' ชุด กด [F10] เพื่อแก้ไข'
