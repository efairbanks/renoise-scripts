-- add your test snippets and other code here, that you want to quickly
-- try out without writing a full blown 'tool'...

-- dummy: recursively prints all available functions and classes

function printarray(ary)
    local out = "[ "
    for i=1,#ary do
        if i>1 then out = out..", " end
        out = out..ary[i]
    end
    print(out.." ]")
end

function genarray(n,size)
    local ary = {}
    for i=1, size, 1 do
        ary[i]=n
    end
    return ary
end

function selectrange(ary,a,b)
    local ret = {}
    for i=a,b,1 do
        ret[#ret+1]=ary[i]
    end
    return ret
end

function arrayconcat(t1,t2)
    if t1==nil then return t2 end
    if t2==nil then return t1 end
    local ret={}
    for i=1,#t1 do
        ret[#ret+1] = t1[i]
    end
    for i=1,#t2 do
        ret[#ret+1] = t2[i]
    end
    return ret
end

function bjork(nPegs,nHoles)
    local pegs,holes,lastPegIndex,work,pegs,holes
    local flatten=function(arr)
      local result = { }
      local function flatten(arr)
        for _, v in ipairs(arr) do
          if type(v) == "table" then
            flatten(v)
          else
            table.insert(result, v)
          end
        end
      end
      flatten(arr)
      return result
    end
    if nPegs<1 then return genarray(0,nHoles) end
    nHoles=nHoles-nPegs
    pegs=genarray({1},nPegs)
    holes=genarray({0},nHoles)
    lastPegIndex=0
    work=function()
        if (lastPegIndex~=0) then
            holes=selectrange(pegs,lastPegIndex,#pegs)
            pegs=selectrange(pegs,1,lastPegIndex-1)
        end
        nPegs=#pegs
        nHoles=#holes
        for inc=0,nHoles-1,1 do
            pegs[(inc%nPegs)+1]=arrayconcat(pegs[(inc%nPegs)+1],holes[inc+1])
        end
        lastPegIndex=(nHoles%nPegs)+1
    end
    work()
    while (lastPegIndex~=1) and (lastPegIndex~=(nPegs)) do
        work()
    end
    return flatten(pegs)
end

function arraysum(ary)
    local sum=0
    for i=1,#ary do
        sum=sum+ary[i]
    end
    return sum
end

function bjorkselect(select,pattern)
    local selectIndex,selectPattern,outPattern
    selectIndex=1
    selectPattern=bjork(select,arraysum(pattern))
    outPattern={}
    for i=1,#pattern do outPattern[i]=pattern[i] end
    for i=1,#outPattern do
        if outPattern[i]>0 then
            outPattern[i]=outPattern[i]*selectPattern[selectIndex]
            selectIndex=selectIndex+1
        end
    end
    return outPattern
end

function getsummedpatterns(pats)
  local ret={}
  for i=1,#pats[1] do ret[i]=0 end
  for i=1,#pats do
    for j=1,#pats[i] do
      ret[j]=ret[j]+pats[i][j]
    end
  end
  return ret
end

function wrapat(ary,index)
  return ary[((index-1) % #ary)+1]
end

function getPatternLength(pattern)
  return #renoise.song().patterns[pattern].tracks[1].lines
end

function recursiveBjork(patternSelects,patternLength)
  local tempPattern=bjork(patternLength,patternLength)
  local patterns={}
  for i=1,#patternSelects do
    tempPattern=bjorkselect(patternSelects[i],tempPattern)
    patterns[i]=tempPattern
  end
  tempPattern=getsummedpatterns(patterns)
  return tempPattern
end

function arraymul(ary,mul)
  local ret={}
  for i=1,#ary do
    ret[i]=ary[i]*mul
  end
  return ret
end

function arrayadd(ary,add)
  local ret={}
  for i=1,#ary do
    ret[i]=ary[i]+add
  end
  return ret
end 

function substituteValues(ary,values)
  local valuesIndices={}
  local ret={}
  for i=1,#ary do
    local indicesIndex=ary[i]+1
    if valuesIndices[indicesIndex]==nil then valuesIndices[indicesIndex]=1 end
    ret[i]=wrapat(wrapat(values,indicesIndex),valuesIndices[indicesIndex])
    valuesIndices[indicesIndex]=valuesIndices[indicesIndex]+1
  end
  return ret
end

function fillPatternPerc(pattern,track,column,notes,instruments,volumes)
  for i=1,#notes do
    if instruments[i]>=0 then
      renoise.song().patterns[pattern].tracks[track].lines[i].note_columns[column].note_value=notes[i]
      renoise.song().patterns[pattern].tracks[track].lines[i].note_columns[column].instrument_value=instruments[i]
      renoise.song().patterns[pattern].tracks[track].lines[i].note_columns[column].volume_value=volumes[i]
    end
  end
end

function clearPattern(pattern,track)
  for lineIndex=1,#renoise.song().patterns[pattern].tracks[track].lines do
    for noteColumnIndex=1,#renoise.song().patterns[pattern].tracks[track].lines[lineIndex].note_columns do
      renoise.song().patterns[pattern].tracks[track].lines[lineIndex].note_columns[noteColumnIndex].note_value=121
      renoise.song().patterns[pattern].tracks[track].lines[lineIndex].note_columns[noteColumnIndex].volume_value=0xFF
      renoise.song().patterns[pattern].tracks[track].lines[lineIndex].note_columns[noteColumnIndex].instrument_value=0xFF
    end
  end
end

function customGeneratePercPattern(patternNo,bjorkLevels,percOnValues)
  basePattern=recursiveBjork(bjorkLevels,getPatternLength(patternNo))
  notes=arrayadd(substituteValues(basePattern,{{1,22,23,7},{22,6},{1,3,7},{2,8,18},{4,12,20,26},{0}}),48)
  instruments=substituteValues(basePattern,percOnValues)
  volumes=arraymul(arrayadd(basePattern,1),0x80/6)
  fillPatternPerc(patternNo,2,1,notes,instruments,volumes)
  notes=genarray(48,getPatternLength(patternNo))
  instruments=substituteValues(basePattern,{{-1},{-1},{-1},{-1},{-1},{1}})
  volumes=arraymul(arrayadd(basePattern,1),0x80/6)
  fillPatternPerc(patternNo,1,1,notes,instruments,volumes)
end

function getLastChord(patternNo,trackNo,lineNo)
  local ret={}
  local retIndex=1
  for lineIndex=lineNo,1,-1 do
    for columnIndex=1,#renoise.song().patterns[patternNo].tracks[trackNo].lines[lineIndex].note_columns do
      if renoise.song().patterns[patternNo].tracks[trackNo].lines[lineIndex].note_columns[columnIndex].note_value<120 then
        ret[retIndex]=renoise.song().patterns[patternNo].tracks[trackNo].lines[lineIndex].note_columns[columnIndex].note_value
        retIndex=retIndex+1
      end
    end
    if #ret>0 then break end
  end
  return ret
end

function generateCustomMelodyPattern(patternNo,sourceTrack,destTrack,bjorkLevels,onValues,targetMidiNote)
  basePattern=recursiveBjork(bjorkLevels,getPatternLength(patternNo))
  instruments=substituteValues(basePattern,onValues)
  volumes=arraymul(arrayadd(basePattern,1),0x80/6)
  notes={}
  for i=1,#basePattern do
    if instruments[i]>=0 then
      notes[i]=wrapat(getLastChord(patternNo,sourceTrack,i),basePattern[i]+1)
      while notes[i]>targetMidiNote do notes[i]=notes[i]-12 end
      while notes[i]<targetMidiNote do notes[i]=notes[i]+12 end
    else
      notes[i]=121
    end
  end
  fillPatternPerc(patternNo,destTrack,1,notes,instruments,volumes)
end


--[[
-- pattern 1
percValues={{-1,-1,-1,-1,-1,-1,0},{0},{0},{0},{0},{0}}
onValues={{-1},{-1},{2},{2},{2},{2}}
bjorkValues={32,16,13,5,3}
customGeneratePercPattern(1,bjorkValues,percValues)
generateCustomMelodyPattern(1,3,4,bjorkValues,onValues,20)
-- pattern 2
bjorkValues={32,16,11,6,4}
customGeneratePercPattern(2,bjorkValues,percValues)
generateCustomMelodyPattern(2,3,4,bjorkValues,onValues,20)
-- pattern 3
bjorkValues={32,16,11,5,3}
customGeneratePercPattern(3,bjorkValues,percValues)
generateCustomMelodyPattern(3,3,4,bjorkValues,onValues,20)
-- pattern 4
bjorkValues={32,16,13,6,3}
customGeneratePercPattern(4,bjorkValues,percValues)
generateCustomMelodyPattern(4,3,4,bjorkValues,onValues,20)
-- pattern 5
bjorkValues={32,16,13,5,3}
percValues={{-1,-1,-1,-1,0,0,-1},{-1,-1,-1,0,0},{0},{0},{0},{0}}
customGeneratePercPattern(5,bjorkValues,percValues)
generateCustomMelodyPattern(5,3,4,bjorkValues,onValues,20)
-- pattern 6
bjorkValues={32,16,11,6,4}
customGeneratePercPattern(6,bjorkValues,percValues)
generateCustomMelodyPattern(6,3,4,bjorkValues,onValues,20)
-- pattern 7
bjorkValues={32,16,11,5,3}
customGeneratePercPattern(7,bjorkValues,percValues)
generateCustomMelodyPattern(7,3,4,bjorkValues,onValues,20)
-- pattern 8
bjorkValues={32,16,13,6,3}
customGeneratePercPattern(8,bjorkValues,percValues)
generateCustomMelodyPattern(8,3,4,bjorkValues,onValues,20)
--]]

--[[
patterns={}
patternSelects={8,4,2,1}
tempPattern=bjork(16,16)
for i=1,#patternSelects do
    tempPattern=bjorkselect(patternSelects[i],tempPattern)
    patterns[i]=tempPattern
    --printarray(tempPattern)
end
--]]

--printarray(getsummedpatterns(patterns))

--for i=1,#patterns do
--    printarray(patterns[i])
--end

-- renoise.song().patterns[1].tracks[1].lines[1].note_columns[1].note_value=60
-- renoise.song().patterns[1].tracks[1].lines[1].note_columns[1].instrument_value=1
-- renoise.song().patterns[1].tracks[1].lines[1].note_columns[1].volume_value=0x40

--[[
function count(ary)
  return #ary
end
print(count(renoise.song().patterns[1].tracks[1].lines))
--]]

