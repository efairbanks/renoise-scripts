dofile("Seq.lua")
dofile("PatternUtils.lua")
for i=1,100 do print("\n\n\n\n\n\n\n\n") end
--[[


seq1=Seq.genBjork(8,16)
print(seq1)
seq2=seq1:bjorkSelect(7)
print(seq2)
seq3=seq2:bjorkSelect(4)
print(seq3)
print("\n");
struct=seq1+seq2+seq3
print(struct)
--]]
--[[
print(Seq.genBjorkStructure(16,{8,4,2}))

--function fillPattern(pattern,track,column,notes,instruments,volumes)
fillPattern(1,1,1,
  Seq.genDup(48,32),
  Seq.genBjorkStructure(32,{16,12,5,2}):replace(0,-1),
  Seq.genDup(0x80,32))
--]]
print(Seq.genBjork(6,8))
