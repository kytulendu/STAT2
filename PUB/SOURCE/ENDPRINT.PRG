PARA _heading,_file
SET PRINT OFF
SET PRINT TO
SET CONS ON
ON PAGE
DEFINE WIND browwin FROM 3,0 TO 20,79 SHAD TITLE _heading COLO W+/b
DO WHIL LASTKEY()#27
	ON KEY LABEL P KEYB CHR(23)+CHR(21) &&DO ToPrint
	ON KEY LABEL C KEYB CHR(23)+CHR(22)
	MODI COMM &_file  WIND browwin NOEDIT 
	ON KEY LABEL p
	ON KEY LABEL c
	IF LASTKEY()<>27
		WAIT WIND
		IF LASTKEY()=21
			DO ToPrint WITH _file
		ENDI
		IF LASTKEY()=22
			DO CopyFile WITH _file
		ENDI
	ENDI
ENDD

PROC HelpBrow
?? CHR(7)
msg2='���������á������ͷӧҹ���'
define window instr from 1,0 to 8,78 shadow title ;
'  ��§ҹ  ' COLO bg+/gr+
activate window instr
@ 1,1 say '������ '
@ row(),col() SAY '[P]' COLO r+/gr+
@ row(),COL() SAY ' ���;������§ҹŧ��д��'
@ 2,1 say '������ '
@ row(),col() SAY '[C] ' COLO r+/gr+
@ row(),col() SAY '��������§ҹŧ�����'
@ 3,1 say '������ '
@ row(),col() SAY '[Esc] 'COLO r+/gr+
@ row(),col() SAY '������ԡ��¡�ù��'
@ 5,Center(msg2) say msg2 color g+/gr+
wait '' window TIMEOUT 30
release window instr
RETU

PROC ToPrint
PARA _printfile
*DEAC WIND ALL
*KEYB CHR(23)
fhandle=FOPEN(_printfile)
IF fhandle<0
	?? CHR(7)
	WAIT '�������ö�Դ����Ҿ������ '+STR(fhandle,3) WIND NOWAIT
ELSE
	DEFINE WIND askprin FROM 10,20 TO 15,60 SHAD
	ACTI WIND askprin
	@ 1,5 PROMPT '1. ������д�ɷ�����'
	@ 2,5 PROMPT '2. ������д�ɵ�����ͧ'
	MENU TO chprin
	prcont =  IIF(chprin = 1,.F.,.T.)
	RELE WIND askprin
	SET CONS OFF
	SET PRINT ON
	DO WHIL ! FEOF(fhandle) .AND. ! CancelPrint()
			mp=FGETS(fhandle)
			?mp
			IF LEFT(mp,1)='' .AND. ! FEOF(fhandle)
			 	IF ! prcont
					?? CHR(7)
					WAIT '����¹��д�������� ���ǡ����� [ENTER] ����' WIND
				ELSE
					EJECT
				ENDI
			ENDI
	ENDD
	=FCLOSE(fhandle)
	IF printstatus()
		EJECT
	ENDI
	SET PRINT OFF
	SET CONS ON
ENDI

PROC CopyFile
PARA _copyfile
DEFINE WIND askname FROM 8,5 TO 12,74 SHAD COLO W+/b+
ACTI WIND askname
@ 1,5 SAY '�红����������������  ' GET targetfile DEFA SPAC(30) ;
PICT '@!'
READ
IF EMPTY(targetfile) .OR. LASTKEY()=27
	?? CHR(7)
	WAIT '¡��ԡ������ͧ��������ͧ���' WIND NOWA
ELSE
	filetarget=ALLTRIM(targetfile)
	COPY FILE &_copyfile TO (filetarget)
ENDI
RELE WIND askname

