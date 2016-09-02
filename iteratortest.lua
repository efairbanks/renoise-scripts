-- generate a simple arp sequence (repeating in the current 
-- pattern & track from line 0 to the pattern end)
--[[
local pattern_iter = renoise.song().pattern_iterator

local pattern_index =  renoise.song().selected_pattern_index
local track_index =  renoise.song().selected_track_index
local instrument_index = renoise.song().selected_instrument_index

local EMPTY_VOLUME = renoise.PatternLine.EMPTY_VOLUME
local EMPTY_INSTRUMENT = renoise.PatternLine.EMPTY_INSTRUMENT

local arp_sequence = {
  {note="C-4", instrument = instrument_index, volume = 0x20}, 
  {note="E-4", instrument = instrument_index, volume = 0x40}, 
  {note="G-4", instrument = instrument_index, volume = 0x80}, 
  {note="OFF", instrument = EMPTY_INSTRUMENT, volume = EMPTY_VOLUME}, 
  {note="G-4", instrument = instrument_index, volume = EMPTY_VOLUME}, 
  {note="---", instrument = EMPTY_INSTRUMENT, volume = EMPTY_VOLUME}, 
  {note="E-4", instrument = instrument_index, volume = 0x40}, 
  {note="C-4", instrument = instrument_index, volume = 0x20}, 
}

for pos,line in pattern_iter:lines_in_pattern_track(pattern_index, track_index) do
  if not table.is_empty(line.note_columns) then

    local note_column = line:note_column(1)
    note_column:clear()
    
    local arp_index = math.mod(pos.line - 1, #arp_sequence) + 1
    note_column.note_string = arp_sequence[arp_index].note
    note_column.instrument_value = arp_sequence[arp_index].instrument
    note_column.volume_value = arp_sequence[arp_index].volume
  end
end
--]]

---[[
local pattern_iter = renoise.song().pattern_iterator
local pattern_index =  renoise.song().selected_pattern_index

for pos,line in pattern_iter:lines_in_pattern(pattern_index) do
  for _,note_column in pairs(line.note_columns) do
    oprint(note_column) 
    --if (note_column.is_selected and 
    --    note_column.note_string == "C-4") then
    --  note_column.note_string = "E-4"
    --end
  end
end
--]]
