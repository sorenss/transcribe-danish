#from: https://gitlab.com/-/snippets/15746 

#wd$ = homeDirectory$ + "/syncfolders/mappe/python/sound/multiple/"
#inDir$ = wd$
sound1Path$ = "transcribeme.wav"
sound1 = Read from file: sound1Path$

#Jeg vil gerne ændre det så den opdeler per pause

max_duration = 15
source_sound = selected("Sound")
sound_name$ = selected$("Sound")
silences = To TextGrid (silences): 100, 0, -25, 0.3, 0.1, "silent", "sounding"

selectObject: source_sound, silences
Extract intervals where: 1, "no", "is equal to", "sounding"
total_sounds = numberOfSelected("Sound")
for i to total_sounds
  sound[i] = selected("Sound", i)
endfor
removeObject: silences

new = 0
nocheck selectObject: undefined
for s to total_sounds
  selectObject: sound[s]
  current = Copy: selected$("Sound")
  removeObject: sound[s]

  nocheck selectObject: previous ; Might be undefined
  plus current
  chain = Concatenate

  # If the current chunk is longer than the maximum,
  # break into smaller pieces
  @divide_to_length: max_duration
  for p to numberOfSelected()-1
    new += 1
    final[new] = divide_to_length.return[p]
  endfor
  removeObject: chain, current
  nocheck removeObject: previous ; Might be undefined

  # Final chunk is shorter than maximum
  previous = divide_to_length.return[divide_to_length.length]
  selectObject: previous
endfor
new += 1
final[new] = previous

nocheck selectObject: undefined
padding = length(string$(new))
for i to new
  @zeropad: i, padding
  selectObject: final[i]
  Rename: sound_name$ + "_" + zeropad.return$
endfor
nocheck selectObject: undefined
for i to new
  plusObject: final[i]
endfor

procedure divide_to_length: .max
  .snd = selected("Sound")
  .snd$ = selected$("Sound")
  .i = 0
  .end = 0
  .total = Get total duration
  .duration = .total
  while .duration > .max
    selectObject: .snd
    .snd$ = selected$("Sound")
    .zeroes = To PointProcess (zeroes): 1, "yes", "yes"
    .start = .end
    .index = Get low index: .start + .max
    .end = Get time from index: .index
    removeObject: .zeroes

    selectObject: .snd
    .i += 1
    .return[.i] = Extract part: .start, .end, "rectangular", 1, "no"
    .duration = .total - .end
  endwhile
  if .end < .total
    selectObject: .snd
    .i += 1
    .return[.i] = Extract part: .end, .total, "rectangular", 1, "no"
  endif
  .length = .i

  nocheck selectObject: undefined
  for .i from 1 to .length
    plusObject: .return[.i]
  endfor
endproc

# Pad a number with zeroes to the left.
# Make sure that the .length is large enough to hold the padded string!
# Taken from the utils CPrAN package
# Available at http://cpran.net/plugins/utils
#
procedure zeropad (.n, .length)
  .n$ = string$(abs(.n))
  .sign$ = if .n < 0 then "-" else "" fi
  .pad$ = ""
  for .i to .length
    .pad$ = .pad$ + "0"
  endfor
  .return$ = .sign$ + right$(.pad$ + .n$, .length)
endproc

#Removes original object, I hope
selectObject: 1
Remove

#Saves all objects
directory$ = "split/"
select all
numberOfSelectedSounds = numberOfSelected ("Sound")

#Below is based on: https://raw.githubusercontent.com/ListenLab/Praat/master/Save_multiple_sounds.txt

# Assign an object number to each sound
for thisSelectedSound to numberOfSelectedSounds
	sound'thisSelectedSound' = selected("Sound",thisSelectedSound)
endfor

# Loop through the sounds
for thisSound from 1 to numberOfSelectedSounds
    select sound'thisSound'
	name$ = selected$("Sound")

	# Old style of Praat coding, but it still works
	do ("Save as WAV file...", directory$ + name$ + ".wav")

endfor

#re-select the sounds
select sound1
for thisSound from 2 to numberOfSelectedSounds
    plus sound'thisSound'
endfor
