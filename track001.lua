dofile("Seq.lua")
dofile("PatternUtils.lua")


workingPattern=1
chords=getPatternChords(workingPattern,3)
--for i=1,#chords do print(Seq.new(chords[i])) end


---[[
notes=Seq.new({})
for i=1,getPatternLength(1) do
  notes[i]=Seq.new(chords[i]):wrapAt(math.floor(i/4))
end
instruments=Seq.genDup(1,getPatternLength(1))
temp=Seq.genDup(0,getPatternLength(1))
for i=8,1,-1 do
  instruments=instruments:bjorkSelect(2^i)
  temp=temp+instruments
end
temp=(temp+1):sequencedSubstitute({{-1},{-1},{-1},{2},{2},{2},{2},{2},{2},{2}})
instruments=temp
volumes=Seq.genDup(0x80,getPatternLength(1))
--function fillPattern(pattern,track,column,notes,instruments,volumes)
fillPattern(1,4,1,notes+24,instruments,volumes)
fillPattern(1,4,2,notes+36,instruments,volumes)
--]]


---[[
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


