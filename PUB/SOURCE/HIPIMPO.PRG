m.todrive = 1
m.exim = 'รับข้อมูลจาก'
DO todrive.spr
IF LASTKEY() = 27
	= ALARM1()
	WAIT WIND NOWA '  ยกเลิกการรับข้อมูลตามต้องการ  '
ELSE
	todrive = IIF(todrive = 1, 'A:', 'B:')
	IF ! FILE(todrive + 'hipdata.zip')
		= ALARM1()
		WAIT WIND NOWA '  ไม่มีข้อมูลที่ต้องการในไดร์ฟ ' + todrive
	ELSE
		importfile = todrive + 'hipdata'
		ACTI SCREE
		SAVE SCRE TO scrhip
		! PKUNZIP -o &importfile 
		REST SCRE FROM scrhip
		IF FILE('hipdata .dbf')
			m.typeimpo = 1
			DO Typeimpo.spr
			IF LASTKEY() = 27
				=ALARM1()
				WAIT WIND NOWA '  ยกเลิกการดึงข้อมูล  '
			ELSE
				IF typeimpo = 1
					dbfuse = patientdir + 'patient1'
					= OPENDBF(dbfuse,'patient1','person_id')
					dbfuse = patientdir + 'patient2'
					= OPENDBF(dbfuse,'patient2','hn')
					dbfuse = patientdir + 'contact'
					= OPENDBF(dbfuse,'contact','hn')
					dbfuse = patientdir + 'insure'
					= OPENDBF(dbfuse,'insure','hn')
					defadrive = LEFT(patientdir,AT('\',patientdir))
					dbfuse = defadrive + 'credit\data\insurlog'
					= OPENDBF(dbfuse,'insurlog','hn')
					dbfuse =  patientdir + 'hncount'
					= OPENDBF(dbfuse,'hncount')
					dbfuse =  'hipdata'
					= OPENDBF(dbfuse,'hipdata')
					SELE patient1
					SET RELA TO hn INTO patient2, hn INTO contact, ;
					hn INTO insure, hn INTO insurlog
					SELE hipdata
					SCAN
						SCAT MEMV
						IF ! SEEK(person_id,'patient1')
							newhn=IIF(hncount.lasthn<9999999,hncount.lasthn+1,1)
							m.hn=Padzero(STR(newhn),7)
							SELE patient1
							SET ORDER TO TAG hn
							DO WHILE SEEK(m.hn)
								newhn=newhn+1
	    		           		m.hn=STRZERO(newhn,7)
							ENDD
							REPL hncount.lasthn WITH newhn
							INSERT INTO patient1 FROM MEMV
							INSERT INTO patient2 FROM MEMV
							INSERT INTO contact FROM MEMV
							INSERT INTO insure FROM MEMV
							INSERT INTO insurlog FROM MEMV
							SELE patient1
							SET ORDER TO TAG person_id
						ELSE
							SELE hipdata
							SCAT MEMV
							toinsert = .T.
							insuhn = insure.hn
							SELE insure
							DO WHIL hn = insuhn
								IF cid = m.cid
									toinsert = .F.
									insuhn = 'ZZZZZZZ'
									IF subtype # m.subtype .OR. inscl # m.inscl ;
									.OR. datein # m.datein .OR. dateexp # m.dateexp ;
									.OR. hospmain # m.hospmain .OR. hospsub # m.hospsub 
										GATH MEMV
										INSERT INTO insurlog FROM MEMV
									ENDI
								ENDI
								SKIP
							ENDD
							IF toinsert
								INSERT INTO insure FROM MEMV
								INSERT INTO insurlog FROM MEMV
							ENDI
						ENDI
						SELE hipdata
					ENDS
				ELSE
					dbfuse = 'hipdata'
					= OpenDBF(dbfuse,'')
					IF ! FILE(patientdir + 'hipbuff.dbf')
						SELE hipdata
						dbfuse = patientdir + 'hipbuff'
						COPY TO (dbfuse)
						SELE 0
						USE (dbfuse) EXCL
						INDEX ON person_id TAG person_id
						INDEX ON name TAG name ADDI
						USE
					ELSE
						dbfuse = patientdir + 'hipbuff'
						= OPENDBF(dbfuse,'',1)
						SELE hipdata
						SCAN
							SCAT MEMV
							IF ! SEEK(m.person_id,'hipbuff')
								INSERT INTO hipbuff FROM MEMV
							ELSE
								SELE hipbuff
								STORE .T. TO toinsert
								insuhn = m.hn
								DO WHIL hn = insuhn
									IF cid = m.cid
										insuhn = 'ZZZZZZZ'
										toinsert = .F.
										IF subtype # m.subtype .OR. inscl # m.inscl ;
										.OR. datein # m.datein .OR. dateexp # m.dateexp ;
										.OR. hospmain # m.hospmain .OR. hospsub # m.hospsub 
											GATH MEMV
										ENDI
									ENDI
									SKIP
								ENDD
								IF toinsert
									INSERT INTO hipbuff FROM MEMV
								ENDI
							ENDI
							SELE hipdata
						ENDS
					ENDI
				ENDI
			ENDI
		ENDI
	WAIT WIND NOWA '  เรียบร้อยแล้ว ให้ทำงานต่อได้  '
	ENDI
	
ENDI