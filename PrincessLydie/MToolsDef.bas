'=========DEF FN=============================
'MToolsDef (c)2017 Marco A. Marrero

'---Reset sprites
DEF FN ResetSprites(start,finish) = tx=start:ty=finish:GOSUB ResetSprites_

'--Packed string reader
DEF FN ReadPacked(label,index,byte1,byte2) = byte1=label(index)/256:byte2=label(index) AND 255
DEF FN PeekPacked(address,byte1,byte2) = byte1=PEEK(address)/256:byte2=PEEK(address) AND 255

'---Hex Print----
DEF FN Hex16(Number)=#tc=Number:GOSUB HEX16_
DEF FN Hex8(Number)=#tc=Number:GOSUB HEX8_

'---Print lines----
DEF FN PrintLineHere(PrintAt,Length,BackTabCharColor) = FOR #ta=PrintAt TO PrintAt+Length:#BACKTAB(#ta)=BackTabChar:Next #ta
DEF FN PrintLine(PrintAt,Length,BackTabCharColor) = #tc=BackTabCharColor:tx=PrintAt:ty=PrintAt+Length:GOSUB PrintLine_ 

'Print Horizontal Line, #tc must be 3 sequential chars (left/middle/end)
DEF FN PrintLineRound(PrintAt,Length,BackTab3Char) = tx=PrintAt:ty=PrintAt+Length-2:#tc=BackTab3Char:GOSUB PrintLineRound_
DEF FN PrintLineRoundCS(PrintAt,Length,BackTab3Char) = tx=PrintAt:ty=PrintAt+Length-2:#tc=BackTab3Char:GOSUB PrintLineRoundCS_

'CardStackPrint. Prints rounded objects, using card stack. Will use blank squares (FillerCard) to void 
DEF FN CardStackPrint(PrintAt, Length,BackTab3Char, StackNo, FillerCard)= ti=StackNo:tx=PrintAt-ti:ty=PrintAt+Length-2:#tc=BackTab3Char:GOSUB CardStackPrint_

'--sleep
DEF FN Sleep(Frames)= tx=Frames:GOSUB Sleep_

'--Sprite2Card
DEF FN Sprite2Card(SpriteX,SpriteY,outCardX,outCardY)=outCardX=((SpriteX+4)/8)-1:outCardY=((SpriteY+4)/8)-1
DEF FN Draw(Address,xpos_,ypos_,CardAndColor)= #ta=Address:tx=xpos_:ty=ypos_:#tc=CardAndColor:GOSUB Draw_

'--print numbers, princess font---
DEF FN PriNum(position,num,zeroes,tcolor) = tx=position:#ta=num:ti=zeroes:#tm=tcolor:GOSUB PriNum_

'--cls with fg/bg card
DEF FN CLSC(colorcard) = #ts=colorcard:GOSUB CLSC_
DEF FN HLine(yposition,colorcard)= #ts=colorcard:ti=yposition:GOSUB HLine_
DEF FN FillZeroes(where) = tx=where:GOSUB FillZeroes_