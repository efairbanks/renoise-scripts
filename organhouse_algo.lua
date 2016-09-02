dofile("Seq.lua")
dofile("PatternUtils.lua")


workingPattern=6
chords=getPatternChords(workingPattern,6)
--for i=1,#chords do print(Seq.new(chords[i])) end

instruments=Seq.genDup(1,getPatternLength(1))
temp=Seq.genDup(0,getPatternLength(1))
for i=8,1,-1 do
  instruments=instruments:bjorkSelect(2^i)
  temp=temp+instruments
end
notes=Seq.new({})
for i=1,getPatternLength(1) do
  notes[i]=Seq.new(chords[i]):wrapAt(temp[i])
end
temp=(temp+1):sequencedSubstitute({{-1},{-1},{-1},{-1},Seq.genDup(3,2)..Seq.genDup(-1,2),{3},{3},{3},{3},{3}})
instruments=temp
volumes=Seq.genDup(0x80,getPatternLength(1))
--function fillPattern(pattern,track,column,notes,instruments,volumes)
fillPattern(workingPattern,8,1,notes+36,instruments,volumes)


instruments=Seq.genDup(1,getPatternLength(1))
temp=Seq.genDup(0,getPatternLength(1))
for i=8,1,-1 do
  instruments=instruments:bjorkSelect(2^i)
  temp=temp+instruments
end
notes=Seq.new({})
for i=1,getPatternLength(1) do
  notes[i]=Seq.new(chords[i]):wrapAt(temp[i])
end
notes=notes+(Seq.genDup(0,24)..Seq.genDup(12,8))
notes=notes+(Seq.genDup(0,8)..Seq.genDup(12,12))
temp=(temp+1):sequencedSubstitute({{-1},{-1},{-1},Seq.genDup(-1,4)..Seq.genDup(2,5),{2},{2},{2},{2},{2},{2}})
instruments=temp
volumes=Seq.genDup(0x80,getPatternLength(1))
--function fillPattern(pattern,track,column,notes,instruments,volumes)
fillPattern(workingPattern,7,1,notes+36,instruments,volumes)


--[[
notes=Seq.new({})
for i=1,getPatternLength(1) do
  notes[i]=(Seq.new(chords[i])..(Seq.new(chords[i])+12)..(Seq.new(chords[i])+24)..(Seq.new(chords[i])+36)):wrapAt(math.floor(i/2))
end
instruments=Seq.genDup(1,getPatternLength(1))
temp=Seq.genDup(0,getPatternLength(1))
for i=8,1,-1 do
  instruments=instruments:bjorkSelect(2^i)
  temp=temp+instruments
end
volumes=(Seq.new(temp)+4)*0x0a
temp=(temp+1):sequencedSubstitute({{-1},{-1,5,-1,5},{5,-1,5,-1,5},{-1,5,5,-1,5,5,5},{5,-1,5},{5,-1,5,5,5},{5},{5},{5},{5}})
instruments=temp
--volumes=Seq.genDup(0x80,getPatternLength(1))
fillPattern(1,6,1,notes+48,instruments,volumes)
--]]


