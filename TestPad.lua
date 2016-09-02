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

function flatten(arr)
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

function bjork(nPegs,nHoles)
    local pegs,holes,lastPegIndex,work,pegs,holes
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

patternNo=2
basePattern=recursiveBjork({32,16,11,6,4},getPatternLength(patternNo))
notes=arrayadd(substituteValues(basePattern,{{1,22,23,7},{22,6},{1,3,7},{2,8,18},{4,12,20,26},{0}}),48)
instruments=substituteValues(basePattern,{{-1,-1,-1,-1,-1,-1,0},{0},{0},{0},{0},{0}})
volumes=arraymul(arrayadd(basePattern,1),0x80/6)
fillPatternPerc(patternNo,1,1,notes,instruments,volumes)

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

