*procedure inter25
   parameter word, col
*  word is number to print such as '0123456789'
*  col is the number of inches right to the left margin
   set talk off
   private x, y, z, word1, num1, char1, char2, char, l, b, start, stop, t_bar
   DIMENSION bararr[10]
   clear
*  l is line and b is blank
   l        = chr(255)+chr(255)+CHR(255)+chr(255)+chr(255)+CHR(255)
   b        = chr(0)+chr(0)+CHR(0)+chr(0)+chr(0)+CHR(0)
*  start is startbar and stop is stopbar
   start    = l+b+l+b
   stop     = l+l+b+l
*  bararr is array of the coding of interleave 2 of 5
   bararr[1]   = '10001'
   bararr[2]   = '01001'
   bararr[3]   = '11000'
   bararr[4]   = '00101'
   bararr[5]   = '10100'
   bararr[6]   = '01100'
   bararr[7]   = '00011'
   bararr[8]   = '10010'
   bararr[9]   = '01010'
   bararr[10]  = '00110'
   word1    = alltrim(word)
   num1     = len(word1)
   if (num1 <> (int(num1/2)*2))
      ? 'The number must be even'
      wait
      return
   endif
   for x = 1 to num1
       if ! (substr(word1,x,1) $ '0123456789')
          ? 'This word is not numeric'
          wait
          return
       endif
   next
   set printer on
*  set line spacing -->  22/180 inches
   ??? chr(27)+'3'+chr(22)
*   print1() set print level to one level printing
*  b_num is the number of column
   b_num = (8+((num1/2)*14))*2
   bar2  = int(b_num/256)
   bar1  = b_num-(bar2*256)
   c_num = col*60
   col2  = int(c_num/256)
   col1  = c_num-(col2*256)
   for z = 1 to 3
       ?
*      move the print head at the horizontal position
*      and set the density of the graphic mode (120 dots per inch)
       ??? chr(27)+'$'+chr(col1)+chr(col2)+chr(27)+'*'+chr(33)+chr(bar1)+chr(bar2)
       ?? start
       for x = 1 to num1 step 2
           char1 = substr(word1,x,1)
           char2 = substr(word1,x+1,1)
           if (char1 = '0')
              char1 = bararr[10]
           else
              char1 = bararr[val(char1)]
           endif
           if (char2 = '0')
              char2 = bararr[10]
           else
              char2 = bararr[val(char2)]
           endif
           t_bar = ''
           for y = 1 to 5
               char = substr(char1,y,1)
               if (char = '1')
                  t_bar = t_bar+l+l
               else
                  t_bar = t_bar+l
               endif
               char = substr(char2,y,1)
               if (char = '1')
                  t_bar = t_bar+b+b
               else
                  t_bar = t_bar+b
               endif
           next
           ?? t_bar
       next
       ?? stop
   next
   ?

*   print2() set print level return to normal
   set printer off
*   set talk on
return
