PARA _header
PRIV m.totalnum
SELE opdiag
mostchoice = 1
WAIT WIND NOWA '�ô��� ! ���ѧ�Ѻ�ӹǹ����������'
COUNT FOR ISALPHA(diag) .AND. LEFT(diag,1) # '*' TO diagcount
opercount = RECCOUNT()-diagcount
DO WHIL mostchoice > 0
	DEFI WIND rep2 FROM 9,10 TO 17,70 SHAD
	ACTI WIND rep2
	CLEA
	@ 1,3 PROMPT '1. ��§ҹ�ä'
	@ 2,3 PROMPT '2. ��§ҹ�ѵ����'
	@ 3,3 PROMPT '3. ��§ҹ�ä੾�м����µ��'
	@ 4,3 PROMPT '4. ��§ҹ�ѵ����੾�м����µ��'
	@ 5,3 PROMPT '0. ��Ѻ��¡�����'
	MENU TO mostchoice
	mostchoice = IIF(mostchoice = 5, 0 ,mostchoice)
	IF mostchoice > 0
		CLEA
		typereport = 1
		@ 1,3 PROMPT '1. ��§ҹ���§������� ICD10'
		@ 2,3 PROMPT '2. ��§ҹ���§��������ä'
		MENU TO typereport
		IF typereport > 0
			DO CASE
			CASE mostchoice = 1 .OR. mostchoice = 3
				header = _header +'����ä�¡������������'+;
				IIF(mostchoice = 3,'੾���ռ�����ª��Ե','')+;
				IIF(typereport=1,'���§������� ICD ','���§������� ')+ IIF(yearly,'��Шӻէ�����ҳ '+myear,;
				'������ѹ��� '+CE2CBE(mstartdate)+' �֧�ѹ��� '+CE2CBE(menddate))
				IF mostchoice = 1
					SET FILT TO ISALPHA(diag) .AND. LEFT(diag,1) # '*'
				ELSE
					SET FILT TO ISALPHA(diag) .AND. LEFT(diag,1) # '*' .AND. ;
					dead > 0
				ENDI
				IF typereport = 1
					SET ORDER TO TAG diagsex
				ELSE
					SET ORDER TO TAG desc
				ENDI
				numrec = diagcount
			CASE mostchoice = 2 .OR. mostchoice = 4
				header = _header +'����ѵ�����¡������������'+;
				IIF(mostchoice = 4,'੾���ռ�����ª��Ե','')+;
				IIF(typereport=1,'���§������� ICD ','���§������� ')+ IIF(yearly,'��Шӻէ�����ҳ '+myear,;
				'������ѹ��� '+CE2CBE(mstartdate)+' �֧�ѹ��� '+CE2CBE(menddate))
				IF mostchoice = 2
					SET FILT TO ISDIGIT(diag) .OR. LEFT(diag,1) = '*'
				ELSE
					SET FILT TO ISDIGIT(diag) .OR. LEFT(diag,1) = '*' ;
					.AND. dead > 0
				ENDI
				IF typereport = 1
					SET ORDER TO TAG diagsex
				ELSE
					SET ORDER TO TAG desc
				ENDI
				numrec = opercount
			ENDC
			WAIT WIND NOWA '�ô��Һ ! ��ͧ������ͧ����������� ��е�駵���ѡ�â�Ҵ 15 ��ǵ�͹���'
			DO CodePrint
			DEAC WIND rep2
		ENDI
		SET FILT TO
	ENDI
ENDD

PROC CODEPRINT
PRIVATE filename
filename = SPACE(30)
GO TOP
set margin to 15
mpage=1
mend=999
nopage=str(numrec/33+.5,4)
CLEA
@ 01,1 say '�������շ�����    '+nopage+' ˹��'
@ 2,1 say '������������˹��  ' get mpage pict '999'
@ 3,1 say '����ش���˹��     ' get mend pict '999'
READ NOLOCK
CLEA
@ 2,5 PROMPT '�����ŧ��д��'
@ 3,5 PROMPT '�����ŧ��������š�͹'
MENU TO typeprint
CLEA
IF typeprint = 2
	@ 2,1 SAY '����������������Ū���  ' GET filename
	READ NOLOCK
	IF EMPTY(filename)
		RETU
	ENDI
	filename = TRIM(filename)
	SET PRIN TO &filename
ELSE		
	IF  CancelPrint()
		RETU
	ENDI
ENDI
CLEA
@ 2,Center('���ѧ����� ������ [Esc] ��ҵ�ͧ�����ԡ�����');
 SAY '���ѧ����� ������ [Esc] ��ҵ�ͧ�����ԡ�����'
line=1
num=mpage
end=mend
rec=33*(num-1)+1
skip rec-1
no=LTRIM(str(num))
pa=1
set print on
SET CONS ON
@ 3,10 SAY '˹�ҷ�� ' + no
SET CONS OFF
?'  ˹�ҷ�� '+no+space(31)+header
?'--------------------------------------------------------------------------------------------------------------------------------------------------------'+repl('-',30)
?space(31)+'                        �ѹ  ��͹    ��'
?'           �����ä               ����   ��   �ӹǹ     0-    1-     1-    5-   10-   15-   20-   25-   30-   35-   40-   45-   50-   55-   60-   65-   70-   75-   80-   85+    ���'
?space(31)+'                         27    11     4     9    14    19    24    29    34    39    44    49    54    59    64    69    74    79    84  '
?'--------------------------------------------------------------------------------------------------------------------------------------------------------'+repl('-',30)
mkey = 13

DO WHILE ! EOF() .and. num<=end .AND. mkey <>27
	msex=iif(sex ='1','�','�')
	msex = IIF(sex = ' ',' ',msex)
	m.totalnum = 0
	FOR t = 1 TO 20
		_t = LTRIM(STR(t))
		m.totalnum = m.totalnum + a&_t
	NEXT
	? desc,' ',LEFT(SHOWICD(diag)+SPACE(6),6),'',msex,' ',TRANS(m.totalnum,'99,999'),'',a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,' ',dead
	mdiag=diag
	skip
	line=line+1
	if line >= 34
		 ?
		eject
		line=1
		num=num+1
		no=LTRIM(STR(num))
		new_page=.t.
		if num <= end
SET CONS ON
@ 3,10 SAY '˹�ҷ�� ' + no
SET CONS OFF
?'  ˹�ҷ�� '+no+space(31)+header
?'--------------------------------------------------------------------------------------------------------------------------------------------------------'+repl('-',30)
?space(31)+'                        �ѹ  ��͹    ��'
?'           �����ä               ����   ��   �ӹǹ     0-    1-     1-    5-   10-   15-   20-   25-   30-   35-   40-   45-   50-   55-   60-   65-   70-   75-   80-   85+    ���'
?space(31)+'                         27    11     4     9    14    19    24    29    34    39    44    49    54    59    64    69    74    79    84  '
?'--------------------------------------------------------------------------------------------------------------------------------------------------------'+repl('-',30)
		endif
	else
		if diag=mdiag
			msex=iif(sex ='1','�','�')
			msex = IIF(sex = ' ',' ',msex)
			m.totalnum = 0
			FOR t = 1 TO 20
				_t = LTRIM(STR(t))
				m.totalnum = m.totalnum + a&_t
			NEXT
			? SPACE(LEN(desc)),' ',LEFT(SHOWICD(diag)+SPACE(6),6),'',msex,' ',TRANS(m.totalnum,'99,999'),'',a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,' ',dead
			mdiag=diag
			skip
			line=line+1
		endi
		if line >= 34
			?
			eject
			line=1
			num=num+1
			no=LTRIM(str(num))
			new_page=.t.
			if num <= end
SET CONS ON
@ 3,10 SAY '˹�ҷ�� ' + no
SET CONS OFF
?'  ˹�ҷ�� '+no+space(31)+header
?'--------------------------------------------------------------------------------------------------------------------------------------------------------'+repl('-',30)
?space(31)+'                        �ѹ  ��͹    ��'
?'           �����ä               ����   ��   �ӹǹ     0-    1-     1-    5-   10-   15-   20-   25-   30-   35-   40-   45-   50-   55-   60-   65-   70-   75-   80-   85+    ���'
?space(31)+'                         27    11     4     9    14    19    24    29    34    39    44    49    54    59    64    69    74    79    84  '
?'--------------------------------------------------------------------------------------------------------------------------------------------------------'+repl('-',30)
			endif
		endi
	endif
	mkey = INKEY()
enddo
if eof()
?
?
?'========================================================================================================================================================'
??'================================'
eject
endi
?
?
set print off
SET PRIN TO
SET CONS ON
set margin to 0
set filter to
return
