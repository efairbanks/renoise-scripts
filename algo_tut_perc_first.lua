dofile("Seq.lua")
dofile("PatternUtils.lua")

for i=1,100 do print("\n") end
overallStructure=Seq.genBjorkStructure(8,{8,4,3}):substitute({"C","B","A"})
print(overallStructure)
--print("overall structure:")
--print(overallStructure)
-- init list of song structures
songStructs={}
-- song structure A
songStructs["A"]=Seq.genBjorkStructure(64,{32,16,9,5,2})
songStructs["A"]=songStructs["A"]..Seq.genBjorkStructure(64,{32,16,13,4,2})
songStructs["A"]=songStructs["A"]..Seq.genBjorkStructure(64,{32,16,11,8,4})
songStructs["A"]=songStructs["A"]..Seq.genBjorkStructure(64,{32,20,14,7,4})
songStructs["A"]=songStructs["A"]..Seq.genBjorkStructure(64,{32,16,9,5,2})
songStructs["A"]=songStructs["A"]..Seq.genBjorkStructure(64,{32,16,11,4,2})
songStructs["A"]=songStructs["A"]..Seq.genBjorkStructure(64,{32,16,7,8,4})
songStructs["A"]=songStructs["A"]..Seq.genBjorkStructure(64,{32,20,14,7,4})
songStructs["A"]=songStructs["A"]+1
--print(songStructs["A"])
-- song structure B
songStructs["B"]=Seq.genBjorkStructure(64,{32,11,9,5,2})
songStructs["B"]=songStructs["B"]..Seq.genBjorkStructure(64,{32,13,7,4,2})
songStructs["B"]=songStructs["B"]..Seq.genBjorkStructure(64,{32,11,11,8,4})
songStructs["B"]=songStructs["B"]..Seq.genBjorkStructure(64,{32,20,14,7,4})
songStructs["B"]=songStructs["B"]..Seq.genBjorkStructure(64,{32,11,9,5,2})
songStructs["B"]=songStructs["B"]..Seq.genBjorkStructure(64,{32,13,7,4,2})
songStructs["B"]=songStructs["B"]..Seq.genBjorkStructure(64,{32,11,11,8,4})
songStructs["B"]=songStructs["B"]..Seq.genBjorkStructure(64,{32,20,14,7,4})
songStructs["B"]=songStructs["B"]+1
--print(songStructs["B"])
-- song structure C
songStructs["C"]=Seq.genBjorkStructure(64,{32,20,9,5,2})
songStructs["C"]=songStructs["C"]..Seq.genBjorkStructure(64,{32,20,7,4,2})
songStructs["C"]=songStructs["C"]..Seq.genBjorkStructure(64,{32,20,11,8,4})
songStructs["C"]=songStructs["C"]..Seq.genBjorkStructure(64,{32,23,14,7,4})
songStructs["C"]=songStructs["C"]..Seq.genBjorkStructure(64,{32,20,9,5,2})
songStructs["C"]=songStructs["C"]..Seq.genBjorkStructure(64,{32,20,7,4,2})
songStructs["C"]=songStructs["C"]..Seq.genBjorkStructure(64,{32,20,11,8,4})
songStructs["C"]=songStructs["C"]..Seq.genBjorkStructure(64,{32,25,14,7,4})
songStructs["C"]=songStructs["C"]+1
--print(songStructs["C"])
-- build base percussion
for i=1,#overallStructure do
  if overallStructure[i]=="A" then
    notes=songStructs[overallStructure[i]]:sequencedSubstitute({{5,15,7,6},{7,5},{15},{6},{4},{9}})+48
    instruments=songStructs[overallStructure[i]]:sequencedSubstitute({{-1},Seq.genBjork(7,11)-1,{0},{0},{0},{0}})
    volumes=((songStructs[overallStructure[i]]/6)^5)*0x80
  elseif overallStructure[i]=="B" then
    notes=songStructs[overallStructure[i]]:sequencedSubstitute({{5,15,7,6},{7,5},{15},{6},{4},{9}})+48
    instruments=songStructs[overallStructure[i]]:sequencedSubstitute({Seq.genBjork(3,11)-1,{0},{0},{0},{0},{0}})
    volumes=((songStructs[overallStructure[i]]/6)^1.7)*0x80
  elseif overallStructure[i]=="C" then
    notes=songStructs[overallStructure[i]]:sequencedSubstitute({{5,15,7,6},{7,5},{15},{6},{4},{9}})+48
    instruments=songStructs[overallStructure[i]]:sequencedSubstitute({Seq.genBjork(5,11)-1,{0},{0},{0},{0},{0}})
    volumes=((songStructs[overallStructure[i]]/6)^1.6)*0x80
  end
  fillPattern(i,1,1,notes,instruments,volumes)
end
-- Bidule FX percussion
for i=1,#overallStructure do
  if overallStructure[i]=="A" then
    notes=songStructs[overallStructure[i]]:sequencedSubstitute({{5,15,7,6},{7,5},{15},{6},{4},{9}})+48
    instruments=songStructs[overallStructure[i]]:sequencedSubstitute({{-1},Seq.genBjork(7,11)-1,{1},{1},{1},{1}})
    volumes=((songStructs[overallStructure[i]]/6)^5)*0x80
  elseif overallStructure[i]=="B" then
    notes=songStructs[overallStructure[i]]:sequencedSubstitute({{5,15,7,6},{7,5},{15},{6},{4},{4}})+48
    instruments=songStructs[overallStructure[i]]:sequencedSubstitute({{-1},{-1},{-1},{-1},{1},{1}})
    volumes=((songStructs[overallStructure[i]]/6)^1.8)*0x80
  elseif overallStructure[i]=="C" then
    notes=songStructs[overallStructure[i]]:sequencedSubstitute({{5,15,7,6},{7,5},{15},{6},{4},{9}})+48
    instruments=songStructs[overallStructure[i]]:sequencedSubstitute({Seq.genBjork(5,11)-1,{-1},{1,1,-1},{-1},{1},{1}})
    volumes=((songStructs[overallStructure[i]]/6)^1.6)*0x80
  end
  fillPattern(i,2,1,notes,instruments,volumes)
end
-- Hot Pants
for i=1,#overallStructure do
  inst=3
  --if overallStructure[i]=="A" then
    notes=songStructs[overallStructure[i]]:sequencedSubstitute({{2},{2},{2},{2},{2},{2}})+48
    instruments=songStructs[overallStructure[i]]:sequencedSubstitute({{-1},{inst},{inst},{inst},{inst},{inst}})
    volumes=((songStructs[overallStructure[i]]/6)^5)*0x80
  --elseif overallStructure[i]=="B" then
    notes=songStructs[overallStructure[i]]:sequencedSubstitute({{2},{2},{2},{2},{2},{2}})+48
    instruments=songStructs[overallStructure[i]]:sequencedSubstitute({{-1},{-1},{-1},{-1},{inst},{inst}})
    volumes=((songStructs[overallStructure[i]]/6)^1.8)*0x80
  --elseif overallStructure[i]=="C" then
    notes=songStructs[overallStructure[i]]:sequencedSubstitute({{3,2},{3,2},{3,2},{3,2},{3,2},{2,3}})+48
    notes=Seq.genDup(1,512):sequencedSubstitute({{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24}})+48
    instruments=songStructs[overallStructure[i]]:sequencedSubstitute({{-1},{inst},{inst},{inst},{inst},{inst}})
    volumes=((songStructs[overallStructure[i]]/6)^1.6)*0x80
  --end
  fillPattern(i,3,1,notes,instruments,volumes)
end
-- init song chords and degrees
songChords=Seq.new({})
songDegrees=Seq.new({})
-- Generate chords A
-- function fillPatternChords(pattern,track,chords,instruments,volumes)
tempStruct=songStructs["A"]:sequencedSubstitute({{0},{0},{0},{0},{0},{1}}):bjorkSelect(16):replace(0,-1):replace(1,4)
degreeList=(Seq.genDup(4,16):integrate()-4)%7
chordList=degreeList:degreesToChromatic():apply(function(index,value) return value+Seq.new({Seq.new({0,3,7}),Seq.new({0,4,7})}):wrapAt(index) end)
songDegrees["A"]=tempStruct:replace(-1,1):replace(4,2):sequencedSubstitute({{-1},degreeList}):repeatIf(-1)%7
songChords["A"]=tempStruct:replace(-1,1):replace(4,2):sequencedSubstitute({{{}},chordList})
for i=2,#songChords["A"] do if #songChords["A"][i]<1 then songChords["A"][i]=songChords["A"][i-1] end end
-- Generate chords B
-- function fillPatternChords(pattern,track,chords,instruments,volumes)
tempStruct=songStructs["B"]:sequencedSubstitute({{0},{0},{0},{0},{0},{1}}):bjorkSelect(16):replace(0,-1):replace(1,4)
degreeList=(Seq.genDup(5,16):integrate()-3)%7
chordList=degreeList:degreesToChromatic():apply(function(index,value) return value+Seq.new({Seq.new({0,3,7}),Seq.new({0,4,7})}):wrapAt(index) end)
songDegrees["B"]=tempStruct:replace(-1,1):replace(4,2):sequencedSubstitute({{-1},degreeList}):repeatIf(-1)%7
songChords["B"]=tempStruct:replace(-1,1):replace(4,2):sequencedSubstitute({{{}},chordList})
for i=2,#songChords["B"] do if #songChords["B"][i]<1 then songChords["B"][i]=songChords["B"][i-1] end end
-- Generate chords C
-- function fillPatternChords(pattern,track,chords,instruments,volumes)
tempStruct=songStructs["C"]:sequencedSubstitute({{0},{0},{0},{0},{0},{1}}):bjorkSelect(16):replace(0,-1):replace(1,4)
degreeList=(Seq.genDup(3,16):integrate()-0)%7
chordList=degreeList:degreesToChromatic():apply(function(index,value) return value+Seq.new({Seq.new({0,3,7}),Seq.new({0,4,7})}):wrapAt(index) end)
songDegrees["C"]=tempStruct:replace(-1,1):replace(4,2):sequencedSubstitute({{-1},degreeList}):repeatIf(-1)%7
songChords["C"]=tempStruct:replace(-1,1):replace(4,2):sequencedSubstitute({{{}},chordList})
for i=2,#songChords["C"] do if #songChords["C"][i]<1 then songChords["C"][i]=songChords["C"][i-1] end end
-----------------
-----------------
-----------------
-- gen melodies

for i=1,#overallStructure do
  local section,structure,degrees,chords,instruments,volumes,notes
---- chords
  section=overallStructure[i]
  structure=songStructs[section]
  degrees=songDegrees[section]
  chords=songChords[section]
  --------------------------
  instruments=structure:sequencedSubstitute({{0},{0},{0},{0},{0},{1}}):bjorkSelect(16):replace(0,-1):replace(1,4)
  chords=chords:apply(function(index,chord) return Seq.new(chord):transpose(60) end)
  volumes=Seq.genDup(0x80,512)
  fillPatternChords(i,4,chords,instruments,volumes)
--------------------------
----bass
  inst=5
  section=overallStructure[i]
  structure=songStructs[section]
  degrees=songDegrees[section]
  chords=songChords[section]
  ------------------------
  notes=chords:apply(function(index,chord) return chord[1] end)
  notes=(notes%12):transpose(15)
  instruments=structure:sequencedSubstitute({{-1},{-1},{-1},{-1},{-1},{inst}})
  volumes=Seq.genDup(0x80,512)
  fillPattern(i,5,1,notes,instruments,volumes)
--------------------------
  --pluck
  section=overallStructure[i]
  structure=songStructs[section]
  degrees=songDegrees[section]
  chords=songChords[section]
  ------------------------
  inst=6
  instruments=structure:sequencedSubstitute({{-1},Seq.genBjork(5,7):replace(0,-1):replace(1,inst),{inst},{inst},{inst},{inst}})
  --notes=(instruments:replace(-1,1):replace(inst,2):sequencedSubstitute({{-1},{4,0,2,0}}):repeatIf(-1)+degData):degreesToChromatic():transpose(48)
  notes=(structure:sequencedSubstitute({{4},{3},{0},{2},{4},{0}})+degrees):degreesToChromatic():transpose(44+12)
  volumes=Seq.genDup(0x80,512)--((songStructs["A"]/6)^2)*0x80
  fillPattern(i,6,1,notes,instruments,volumes)
--------------------------
  --TB303
  section=overallStructure[i]
  structure=songStructs[section]
  degrees=songDegrees[section]
  chords=songChords[section]
  ------------------------
  inst=8
  instruments=structure:sequencedSubstitute({{-1},Seq.genBjork(5,17):replace(0,-1):replace(1,inst),Seq.genBjork(11,13):replace(0,-1):replace(1,inst),{inst},{inst},{inst}})
  --notes=(instruments:replace(-1,1):replace(inst,2):sequencedSubstitute({{-1},{4,0,2,0}}):repeatIf(-1)+degData):degreesToChromatic():transpose(48)
  notes=(structure:sequencedSubstitute({{5},{6},{3},{2},{4},{0}})+degrees):degreesToChromatic():transpose(25)
  notes=notes+Seq.genBjork(5,13):replace(1,12)+Seq.genBjork(7,24):replace(1,-7)
  fillPattern(i,7,1,notes,instruments,volumes)
  if section=="C" then fillEffectColumn(i,7,1,Seq.genDup("16",512),Seq.genDup(1,512):integrate():normalize()*0x40)
  elseif section=="B" then fillEffectColumn(i,7,1,Seq.genDup("16",512),(1-Seq.genDup(1,512):integrate():normalize())*0x40) end
  if section=="A" then
    cutoff=Seq.genDup(1,512):integrate():normalize()
    cutoff=(cutoff*(1-cutoff)):normalize()
    fillEffectColumn(i,7,1,Seq.genDup("16",512),cutoff*0x40)
  end
--------------------------
  --Noise
  fillEffectColumn(i,8,1,Seq.genDup("0L",512),((1-Seq.genDup(1,512):integrate():normalize())^10)*0x80)
end


--[[
chords=Seq.new(degrees)
chords=chords:degreesToChromatic()%12
for i=1,#chords do
  chords[i]=((Seq.new({chords[i]})+Seq.new({Seq.new({0,4,7}),Seq.new({0,3,7})}):wrapAt(i))%12)
  for j=1,#chords[i] do
    while chords[i][j] < 60 do chords[i][j]=chords[i][j]+12 end
  end
end
-- note data
instData=songStructs["A"]:sequencedSubstitute({{0},{0},{0},{0},{0},{1}}):bjorkSelect(16):replace(0,-1):replace(1,4)
empty={Seq.new({})}
chordData=instData:replace(-1,1):replace(4,2):sequencedSubstitute({empty,chords})
degData=instData:replace(-1,1):replace(4,2):sequencedSubstitute({{-1},degrees}):repeatIf(-1)%7
print(degData)
fillPatternChords(1,4,chordData,instData,Seq.genDup(0x80,512))
-- bass (test pattern 1)
inst=5
notes=Seq.new({})
for i=1,#chordData do if #chordData[i]>0 then notes[i]=chordData[i][1] else notes[i]=notes[i-1] end end
notes=(notes%12):transpose(15)
instruments=songStructs["A"]:sequencedSubstitute({{-1},{-1},{-1},{-1},{-1},{inst}})
volumes=Seq.genDup(0x80,512)--((songStructs["A"]/6)^2)*0x80
fillPattern(1,5,1,notes,instruments,volumes)
-- melody
inst=6
instruments=songStructs["A"]:sequencedSubstitute({{-1},Seq.genBjork(5,7):replace(0,-1):replace(1,inst),{inst},{inst},{inst},{inst}})
--notes=(instruments:replace(-1,1):replace(inst,2):sequencedSubstitute({{-1},{4,0,2,0}}):repeatIf(-1)+degData):degreesToChromatic():transpose(48)
notes=(songStructs["A"]:sequencedSubstitute({{4},{3},{0},{2},{4},{0}})+degData):degreesToChromatic():transpose(44+12)
volumes=Seq.genDup(0x80,512)--((songStructs["A"]/6)^2)*0x80
fillPattern(1,6,1,notes,instruments,volumes)
--]]





--[[ EXAMPLE CODE FOR MY PERSONAL REFERENCE --]]
--[[
--------------------------------------------------
--workingPattern=1
--chords=getPatternChords(workingPattern,3)
--for i=1,#chords do print(Seq.new(chords[i])) end
--------------------------------------------------
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


