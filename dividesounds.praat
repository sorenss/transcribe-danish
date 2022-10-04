#from: https://gitlab.com/-/snippets/15746 

#open file
sound1Path$ = "transcribeme.wav"
sound1 = Read from file: sound1Path$

#Jeg vil gerne ændre det så den opdeler per pause

#maximum length of each file
max_duration = 15   
source_sound = selected("Sound")
sound_name$ = selected$("Sound")
silences = To TextGrid (silences): 100, 0, -25, 0.3, 0.1, "silent", "sounding"

#The script extracts the parts that praat has tagged as "sounding"
selectObject: source_sound, silences
Extract intervals where: 1, "yes", "is equal to", "sounding"
total_sounds = numberOfSelected("Sound")
for i to total_sounds
  sound[i] = selected("Sound", i)
endfor
removeObject: silences

#Rename all objects to starttime_endtime
for s to total_sounds
	selectObject: sound[s]
	startTime = Get start time
	endTime = Get end time
	ststr$ = fixed$: startTime*1000, 0
	etstr$ = fixed$: endTime*1000, 0
	newname$ =  ststr$ + "_" + etstr$
	Rename: newname$
endfor

#Removes original object
selectObject: 1
Remove

#Saves all objects
directory$ = "sounds/"
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
