EXTERNAL ARRAY show,xdummy,ydummy
**********************		จัดเรียงข้อมูลตามลำดับ
IF xcount = 0 .OR. ycount = 0
	?? CHR(7)
	mshow = IIF(xcount=0,TRIM(show(xchoice)),TRIM(show(ychoice)))
	WAIT 'ไม่มีข้อมูลของตัวแปร '+ mshow WIND NOWA
	DEAC WIND ALL
	RETU .F.
ENDI	
DIME xfind(xcount),yfind(ycount)
=ACOPY(xfind,xdummy)
=ACOPY(yfind,ydummy)
=ASORT(xfind)
=ASORT(yfind)
IF TYPE('xcoded')='L'
	DIME xcode[xcount],xcoded[xcount]
	SELE (xfile)
	xseek=IIF(xfile='ADDRESS','1','')
	FOR i = 1 TO xcount
		mseek=xseek+xfind(i)
		IF SEEK(mseek)
			STOR &xhelp1 TO xcode(i)
			STOR TRIM(&xhelp2) TO xcoded(i)
		ELSE
			STOR xfind(i) TO xcode(i)
			STOR 'รหัส '+IIF(TYPE('XFIND[i]')='D',DTOC(xfind[i]),xfind(i)) TO xcoded(i)
		ENDI
	NEXT
ELSE
	IF ALEN(xfind) > ALEN(xcode)	
		_xx = ALEN(xcode)
		FOR i = 1 TO ALEN(xfind)
			IF ASCAN(xcode,xfind(i)) = 0
				_xx = _xx+1
				DIME xcode(_xx),xcoded(_xx)
				STOR xfind(i) TO xcode[_xx]
				STOR 'รหัส '+IIF(TYPE('XFIND[i]')='D',DTOC(xfind[i]),xfind(i)) TO xcoded(_xx)
			ENDI
		NEXT
	ENDI
ENDI
IF TYPE('ycoded')='L'
	DIME ycode[ycount]
	SELE (yfile)
	xseek=IIF(yfile='ADDRESS','1','')
	FOR i = 1 TO ycount
		mseek=xseek+yfind(i)
		IF SEEK(mseek)
			STOR &yhelp1 TO ycode(i)
			STOR TRIM(&yhelp2) TO ycoded(i)
		ELSE
			STOR yfind(i) TO ycode(i)
			STOR 'รหัส '+IIF(TYPE('yfind[i]')='D',DTOC(yfind[i]),yfind(i)) TO ycoded(i)
		ENDI
	NEXT
ELSE
	IF ALEN(yfind) > ALEN(ycode)	
		_xx = ALEN(ycode)
		FOR i = 1 TO ALEN(yfind)
			IF ASCAN(ycode,yfind(i)) = 0
				_xx = _xx+1
				DIME ycode(_xx),ycoded(_xx)
				STOR yfind(i) TO ycode[_xx]
				STOR 'รหัส '+IIF(TYPE('yfind[i]')='D',DTOC(yfind[i]),yfind(i)) TO ycoded(_xx)
			ENDI
		NEXT
	ENDI
ENDI
DEAC WIND ALL
	IF UPPER(RIGHT(xvar,8)) $ 'AGE_TYPE,PROVINCE'
		xstart = xcount
		xstep = -1
		xend = 1
	ELSE
		xstart = 1
		xstep = 1
		xend = xcount
	ENDI
	IF UPPER(RIGHT(yvar,8)) $ 'AGE_TYPE,PROVINCE'
		ystart = ycount
		ystep = -1
		yend = 1
	ELSE
		ystart = 1
		ystep = 1
		yend = ycount
	ENDI
