#no form, but the filename must be "soundfile.wav"
sound1Path$ = "soundfile.wav"
sound1 = Read from file: sound1Path$

#This and below is identical to "dividesounds.praat"
Resample: 16000, 50
source_sound = selected("Sound")
sound_name$ = selected$("Sound")
silences = To TextGrid (silences): 100, 0, -25, 0.3, 0.1, "silent", "sounding"

#The script extracts parts annotated as "sounding"
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
	startstr$ = fixed$: startTime*1000, 0
	#Add zeroes to keep starttimes equal length for correct sorting, only works for up to ca. 3 hour files
	while length(startstr$)<7
		startstr$ = "0" + startstr$
	endwhile
	endstr$ = fixed$: endTime*1000, 0
	newname$ =  startstr$ + "_" + endstr$
	Rename: newname$
endfor

#Removes non-divided files
selectObject: 1
Remove
selectObject: 2
Remove

#Saves all objects
directory$ = "sounds/"
select all
numberOfSelectedSounds = numberOfSelected ("Sound")

# Assign an object number to each sound
for thisSelectedSound to numberOfSelectedSounds
	sound'thisSelectedSound' = selected("Sound",thisSelectedSound)
endfor

# Loop through the sounds
for thisSound from 1 to numberOfSelectedSounds
    select sound'thisSound'
	name$ = selected$("Sound") 
	do ("Save as WAV file...", directory$ + name$ + ".wav")
endfor
