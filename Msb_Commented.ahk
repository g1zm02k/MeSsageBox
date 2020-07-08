﻿Msb(m, d:=2, x:=-1, y:=-1, s:=1){	;Text, Secs, xPos, yPos, (set defaults)
	if (m="")						;No m value passed then
		m:="! Empty !"				;		display message to confirm working
	s:=RegExMatch(d,"0")			;Check position of first '0' in duration(d)
	if (d=0)						;If '0' is only parameter passed for d
		d:=2						;		set d as default '2'
	if (x=-1)						;No x value passed then
		x:=A_ScreenWidth/2			;		set x as centre screen x
	if (y=-1)						;No y value passed then
		y:=A_ScreenHeight/2			;		set y as centre screen y

	c:=0							;Character count for the longest line
	p:=1							;Position of newline character (`n)
	l:=1							;Line counter/total lines
	r:=0							;Length of current line/position in text(m)
	d*=1000							;Secs(d) into milliseconds (less typing)

	Loop							;Loop to find number of lines/max line length
	{
		p:=RegExMatch(m,"`n",,p+1)	;Get newline (`n) position(p)
		if (p > 0)					;If a linebreak has been found...
		{
			r:=p-r-1				;Current line length(r) is line up to 'n(p)
			if (r > c)				;If current line(r) is longer than max(c)
				c:=r				;		then max(c) updates to new longest(r)
			r:=p					;New line start pos(r) is old 'n position(p)
			l++						;Increment number of lines
		} Else {					;This is the last/only line found...
			r:=(StrLen(m)-r)		;Get (last) line length (by removing others)
			if (r = 0)				;If current length is a linebreak
				l--					;		don't count it/remove line from count
			if (r > c)				;If current line(r) is longer than max(c)
				c:=r				;		then max(c) updates to new longest(r)
			Break					;All lines are counted so exit the loop
		}
	}
	
	w:=c*12+6						;NumChars * FontWid + WinBorder = Width
	h:=l*24-2						;NumLines * FontHgt + WinBorder = Height
	x:=x-w/2						;xCentre = Width/2
	y:=y-h/2						;yCentre = Height/2
	
	Gui Msb:New, -SysMenu +AlwaysOnTop +ToolWindow -Caption +Owner 	;Create Gui
	Gui Font, s18, ProFontWindows	;Set fixed-width font and large text size
	Gui Add, Text, x4 y0 w%w% h%h%, % m		;Set text element size
	Gui Show, NoActivate x%x% y%y% w%w% h%h%, wMsb	;Set Gui size/position

	if (s=1)						;If stored '0' position(s) is first character
		SetTimer tMsb, -%d%			;		use timer (execution continues)
	else							;	otherwise
	{
		Sleep % d					;		use sleep (execution halts)
		Gui Msb:Destroy				;No idea what this does...
	}
}

tMsb:								;Timer sub-code label
	Gui Msb:Destroy					;It's here too - if only there was some hint!