PARA _agetype,_age,_birthday
_dayage=BE2CE(mdate)-_birthday
DO CASE
	CASE _dayage<30
		_agetype='3'
		_age=_dayage
	CASE _dayage<365
		_agetype='2'
		_age=INT(_dayage/30)
    OTHER
		_agetype='1'
		_age=INT(_dayage/365)
		_age=IIF(_age>99,99,_age)
ENDC
