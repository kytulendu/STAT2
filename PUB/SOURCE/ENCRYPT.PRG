**************************
Function Encrypt
**************************
parameter inputstr

inputstr=upper(inputstr)

strlength=len(inputstr)
password=''

for i=1 to strlength
	if i%2=0
		password=password+chr(asc(substr(inputstr,i,1))+10)
	else
		password=password+chr(asc(substr(inputstr,i,1))-10)
	endif
endfor

return password

*************************
Function Decrypt
*************************
parameter inputstr

inputstr=upper(inputstr)

strlength=len(inputstr)
password=''

for i=1 to strlength
	if i%2=0
		password=password+chr(asc(substr(inputstr,i,1))-10)
	else
		password=password+chr(asc(substr(inputstr,i,1))+10)
	endif
endfor

return password
