function getPatternLength(pattern)
  return #renoise.song().patterns[pattern].tracks[1].lines
end

function fillPattern(pattern,track,column,notes,instruments,volumes)
  local pattern_iter = renoise.song().pattern_iterator
  for pos,line in pattern_iter:lines_in_pattern_track(pattern,track) do  
    local note_column=line:note_column(column)
    local line=pos.line
    note_column:clear()
    if instruments[line]>-1 then
      note_column.note_value=notes[line]
      note_column.instrument_value=instruments[line]
      note_column.volume_value=volumes[line]
    end
  end
end

function fillPatternChords(pattern,track,chords,instruments,volumes)
  local pattern_iter = renoise.song().pattern_iterator
  for pos,line in pattern_iter:lines_in_pattern_track(pattern,track) do
    local lineNumber=pos.line
    if instruments[lineNumber]>-1 then
      for note=1,#chords[lineNumber] do
        local note_column=line:note_column(note)
        note_column:clear()
        note_column.note_value=chords[lineNumber][note]
        note_column.instrument_value=instruments[lineNumber]
        note_column.volume_value=volumes[lineNumber]
      end
    end
  end
end

function getPatternChords(pattern,track)
  local ret={}
  local pattern_iter = renoise.song().pattern_iterator
  for pos,line in pattern_iter:lines_in_pattern_track(pattern,track) do
    local lineIndex=pos.line
    if ret[lineIndex]==nil then ret[lineIndex]={} end
    for columnIndex,note_column in pairs(line.note_columns) do
      if note_column.note_value<120 then ret[lineIndex][columnIndex]=note_column.note_value%12 end
    end
    if lineIndex>1 and #ret[lineIndex]<1 then ret[lineIndex]=ret[lineIndex-1] end
  end
  return ret
end

function fillEffectColumn(pattern,track,column,numbers,amounts)
  local pattern_iter = renoise.song().pattern_iterator
  for pos,line in pattern_iter:lines_in_pattern_track(pattern,track) do  
    local effect_column=line:effect_column(column)
    local line=pos.line
    effect_column:clear()
    if type(numbers[line])=="number" then
      if numbers[line] > -1 then
        effect_column.number_value=numbers[line]
        effect_column.amount_value=amounts[line]
      end
    end
    if type(numbers[line])=="string" then
      if #numbers[line]>0 then
        effect_column.number_string=numbers[line]
        effect_column.amount_value=amounts[line]
      end
    end
  end
end

