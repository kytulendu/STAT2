**************************************************************************
*  ���������Ѻ�������������͡��Ҩо����ѵôѪ��                        *
*  ���ͨз���§ҹ��������ǡѺ�Ǫ����¹                                 *
**************************************************************************

PRIVATE Colspace,PreScr,Chelp,EHelpMess,Ch_Help
#define numutil 7
@ 3,0 CLEA TO 20,80
DIME chelp(numutil),EHelpMess(numutil)
chelp[1]='1. �ѵôѪ��'
chelp[2]='2. ���ҵ�����͹�'
chelp[3]='3. ���� HN ��Ъ��͵�����͹�'
chelp[4]='4. ���Ҥ�������㹻յ�����͹�'
chelp[5]='5. ���� HN ��Ъ��ͤ�������㹻յ�����͹�'
chelp[6]='6. �Ҩӹǹ�����Ѻ�����ç��Һ��'
chelp(numutil)='0. ��Ѻ��¡�����'

EhelpMess[1]='�����ѵôѪ�������������ͧ�������ö�ӧҹ��'
EhelpMess[2]='���Ҩӹǹ�繵��ҧ 2 �Ե� ������͹䢷���˹�'
EhelpMess[3]='�����Ţ�������¹͡��Ъ��� ������͹䢷���˹�'
EhelpMess[4]='���Ҩӹǹ�繵��ҧ 2 �Ե� �ͧ��������㹻յ�����͹䢷���˹�'
EhelpMess[5]='�����Ţ�������¹͡��Ъ��ͧ͢��������㹻� ������͹䢷���˹�'
EhelpMess[6]='���Ҩӹǹ�������Ѻ��� ������͹䢷���˹�'
EHelpMess[numutil]='��Ѻ������¡����ѡ'

DEFINE WIND help_menu FROM 4,5 TO 4+ALEN(chelp)+3,50 SHAD COLO gr+/BG TITLE '  ��䢤�ҵ�ҧ �  '
Ch_help = 1
DO WHIL .T.
	ACTI SCREE
	CLOSE DATA
	= ENGMODE()
	DO Title WITH '��¡����§ҹ��ͧ�ѵ�'
	ACTI WIND help_menu
	FOR i=1 TO ALEN(chelp)
		@ i,3 PROMPT chelp(i) MESS EhelpMess[i]
	NEXT
	MENU TO Ch_help
	ACTI SCREE
	DO CASE
		CASE Ch_help = 1
			DO Pr_Index
		CASE Ch_help = 2
			DO StatRQBE
		CASE Ch_help = 3
			DO StatHN
		CASE Ch_help = 4
			DO NewRQBE
		CASE Ch_help = 5
			DO NewRqHN
		CASE Ch_help = 6
			DO AdmitNum
		OTHER
			EXIT
	ENDC
ENDD
RELE WIND help_menu
CLOSE DATA