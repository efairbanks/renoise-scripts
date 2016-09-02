local pattern_iter = renoise.song().pattern_iterator
local pattern_index =  renoise.song().selected_pattern_index

for pos,line in pattern_iter:lines_in_pattern(pattern_index) do
  for _,note_column in pairs(line.note_columns) do 
    if (note_column.is_selected and 
        note_column.note_string == "C-4") then
      note_column.note_string = "E-4"
    end
  end
end
