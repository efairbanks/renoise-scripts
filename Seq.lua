Seq={}    -- Seq Class
Seq.mt={} -- Seq Metatable
Seq.pt={} -- Seq Prototype
Seq.mt.__index=Seq.pt
------------------------------
function Seq.new(t)
  local seq={}
  setmetatable(seq, Seq.mt)
  for i=0,#t do seq[i]=t[i] end
  return seq
end
------------------------------
function Seq.genDup(n,size)
    local seq=Seq.new({})
    for i=1,size do
        seq[i]=n
    end
    return seq
end
------------------------------
function Seq.genBjorkStructure(size,selects)
  local currentLevel=Seq.genDup(1,size)
  local ret=Seq.genDup(0,size)
  for i=1,#selects do
    currentLevel=currentLevel:bjorkSelect(selects[i])
    ret=ret+currentLevel
  end
  return ret
end
------------------------------
function Seq.genBjork(nPegs,nHoles)
    local pegs,holes,lastPegIndex,work,pegs,holes
    local flatten=function(arr)
      local result=Seq.new({})
      local function flatten(arr)
        for _, v in ipairs(arr) do
          if type(v)=="table" then
            flatten(v)
          else
            table.insert(result,v)
          end
        end
      end
      flatten(arr)
      return result
    end
    if nPegs<1 then return Seq.genDup(0,nHoles) end
    nHoles=nHoles-nPegs
    pegs=Seq.genDup({1},nPegs)
    holes=Seq.genDup({0},nHoles)
    lastPegIndex=0
    work=function()
        if (lastPegIndex~=0) then
            holes=Seq.selectRange(pegs,lastPegIndex,#pegs)
            pegs=Seq.selectRange(pegs,1,lastPegIndex-1)
        end
        nPegs=#pegs
        nHoles=#holes
        for inc=0,nHoles-1,1 do
            pegs[(inc%nPegs)+1]=Seq.concat(pegs[(inc%nPegs)+1],holes[inc+1])
        end
        lastPegIndex=(nHoles%nPegs)+1
    end
    work()
    while (lastPegIndex~=1) and (lastPegIndex~=(nPegs)) do
        work()
    end
    return Seq.new(flatten(pegs))
end
------------------------------
function Seq.tostring(seq)
    local out = "[ "
    for i=1,#seq do
        if i>1 then out=out..", " end
        out=out..seq[i]
    end
    return (out.." ]")
end
Seq.mt.__tostring=Seq.tostring
------------------------------
function Seq.concat(self,seq)
    if seq==nil then return self end
    local ret=Seq.new({})
    for i=1,#self do ret[#ret+1]=self[i] end
    for i=1,#seq do ret[#ret+1]=seq[i] end
    return ret
end
Seq.mt.__concat=Seq.concat
------------------------------
function Seq.add(a,b)
  return Seq.combine(a,b,function(a,b) return a+b end)
end
Seq.mt.__add=Seq.add
------------------------------
function Seq.sub(a,b)
  return Seq.combine(a,b,function(a,b) return a-b end)
end
Seq.mt.__sub=Seq.sub
------------------------------
function Seq.mul(a,b)
  return Seq.combine(a,b,function(a,b) return a*b end)
end
Seq.mt.__mul=Seq.mul
------------------------------
function Seq.div(a,b)
  return Seq.combine(a,b,function(a,b) return a/b end)
end
Seq.mt.__div=Seq.div
------------------------------
function Seq.mod(a,b)
  return Seq.combine(a,b,function(a,b) return a%b end)
end
Seq.mt.__mod=Seq.mod
------------------------------
function Seq.pow(a,b)
  return Seq.combine(a,b,function(a,b) return a^b end)
end
Seq.mt.__pow=Seq.pow
------------------------------
function Seq.unm(self)
  return Seq.combine(0,self,function(a,b) return a-b end)
end
Seq.mt.__unm=Seq.unm
------------------------------
function Seq.wrapAt(self,index)
  return self[((index-1)%#self)+1]
end
Seq.pt.wrapAt=Seq.wrapAt
------------------------------
function Seq.selectRange(self,from,to)
    local ret=Seq.new({})
    for i=from,to,1 do ret[#ret+1]=self[i] end
    return ret
end
Seq.pt.selectRange=Seq.selectRange
------------------------------
function Seq.sum(self)
    local sum=0
    for i=1,#self do sum=sum+self[i] end
    return sum
end
Seq.pt.sum=Seq.sum
------------------------------
function Seq.combine(a,b,operator)
  local ret=Seq.new({})
  if type(a)=="table" and type(b)=="table" then
    for i=1,math.max(#a,#b) do ret[i]=operator(Seq.wrapAt(a,i),Seq.wrapAt(b,i)) end
  elseif type(a)=="number" and type(b)=="table" then
    for i=1,#b do ret[i]=operator(a,Seq.wrapAt(b,i)) end
  elseif type(a)=="table" and type(b)=="number" then
    for i=1,#a do ret[i]=operator(Seq.wrapAt(a,i),b) end
  end
  return ret
end
------------------------------
function Seq.substitute(self,values)
  local ret=Seq.new({})
  for i=1,#self do ret[i]=Seq.wrapAt(values,self[i]) end
  return ret
end
Seq.pt.substitute=Seq.substitute
------------------------------
function Seq.sequencedSubstitute(self,values)
  local valuesIndices={}
  local ret=Seq.new({})
  for i=1,#self do
    local indicesIndex=self[i]
    if valuesIndices[indicesIndex]==nil then valuesIndices[indicesIndex]=1 end
    ret[i]=Seq.wrapAt(Seq.wrapAt(values,indicesIndex),valuesIndices[indicesIndex])
    valuesIndices[indicesIndex]=valuesIndices[indicesIndex]+1
  end
  return ret
end
Seq.pt.sequencedSubstitute=Seq.sequencedSubstitute
------------------------------
function Seq.bjorkSelect(self,select)
    local selectIndex,selectPattern,outPattern
    selectIndex=1
    selectPattern=Seq.genBjork(select,Seq.sum(self))
    outPattern=Seq.new({})
    for i=1,#self do outPattern[i]=self[i] end
    for i=1,#outPattern do
        if outPattern[i]>0 then
            outPattern[i]=outPattern[i]*selectPattern[selectIndex]
            selectIndex=selectIndex+1
        end
    end
    return outPattern
end
Seq.pt.bjorkSelect=Seq.bjorkSelect
------------------------------
function Seq.degreesToChromatic(self)
  local ret=Seq.new({})
  local ionian=Seq.new({0,2,4,5,7,9,11})
  for i=1,#self do
    local degree=self[i]
    local note=ionian:wrapAt(degree+1)
    while degree>=7 do
      degree=degree-7
      note=note+12
    end
    ret[i]=note
  end
  return ret
end
Seq.pt.degreesToChromatic=Seq.degreesToChromatic
------------------------------
function Seq.expand(self,by)
  local ret=Seq.new({})
  local retIndex=1
  for i=1,#self do
    for j=1,by do
      ret[retIndex]=self[i]
      retIndex=retIndex+1
    end
  end
  return ret
end
Seq.pt.expand=Seq.expand
------------------------------
function Seq.replace(self,a,b)
  local ret=Seq.new({})
  for i=1,#self do
    ret[i]=self[i]
    if ret[i]==a then ret[i]=b end
  end
  return ret
end
Seq.pt.replace=Seq.replace
------------------------------
function Seq.repeatIf(self,n)
  local ret=Seq.new({})
  for i=1,#self do
    if self[i]==n and i>1 then ret[i]=ret[i-1] else ret[i]=self[i] end
  end
  return ret
end
Seq.pt.repeatIf=Seq.repeatIf
-----------------------------
function Seq.transpose(self,pitch)
  local ret=Seq.new({})
  for i=1,#self do
    ret[i]=self[i]
    while ret[i]<pitch do ret[i]=ret[i]+12 end
  end
  return ret
end
Seq.pt.transpose=Seq.transpose
-----------------------------
function Seq.integrate(self)
  local ret=Seq.new({})
  for i=1,#self do
    ret[i]=self[i]
    if i>1 then ret[i]=ret[i]+ret[i-1] end
  end
  return ret
end
Seq.pt.integrate=Seq.integrate
-----------------------------
function Seq.derive(self)
  local ret=Seq.new({})
  for i=1,#self do
    ret[i]=self[i]
    if i>1 then ret[i]=ret[i]-self[i-1] end
  end
  return ret
end
Seq.pt.derive=Seq.derive
-----------------------------
function Seq.apply(self,func)
  local ret=Seq.new({})
  for i=1,#self do
    ret[i]=func(i,self[i])
  end
  return ret
end
Seq.pt.apply=Seq.apply
-----------------------------
function Seq.max(self,func)
  local ret=self[1]
  for i=1,#self do
    if self[i]>ret then ret=self[i] end
  end
  return ret
end
Seq.pt.max=Seq.max
-----------------------------
function Seq.min(self,func)
  local ret=self[1]
  for i=1,#self do
    if self[i]<ret then ret=self[i] end
  end
  return ret
end
Seq.pt.min=Seq.min
-----------------------------
function Seq.normalize(self,func)
  local ret=Seq.new({})
  local min=self:min()
  local max=self:max()
  for i=1,#self do
    ret[i]=(self[i]-min)/(max-min)
  end
  return ret
end
Seq.pt.normalize=Seq.normalize

