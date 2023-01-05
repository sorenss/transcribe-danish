#!pip install torch
#!pip install datasets
#!pip install transformers
#!pip install librosa

import torch
import os
import argparse
from datasets import load_dataset, Audio
from datasets import Dataset
from transformers import Wav2Vec2ForCTC, Wav2Vec2Processor

#functions
def arg_inputs():
    arg_parser = argparse.ArgumentParser(description="A script that transcribes very roughly")
    #Arguments
    arg_parser.add_argument("-i","--input",type=str,required=True,help="The name of the sound file to transcribe")
    arg_parser.add_argument("-c","--conventions",type=str,required=False,default='default',help="The transcription conventions: basic or CLAN")
    args = arg_parser.parse_args()
    return args

def transcribe(filename):
    # load dataset and read soundfiles
    ds = Dataset.from_dict({"audio": [filename]}).cast_column("audio", Audio())

    # tokenize
    input_values = processor(
        ds[0]["audio"]["array"], return_tensors="pt", sampling_rate = 16000, padding="longest"
    ).input_values  # Batch size 1

    # retrieve logits
    logits = model(input_values).logits

    # take argmax and decode
    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = processor.batch_decode(predicted_ids)
    return transcription

arguments = arg_inputs()

# load model and tokenizer
processor = Wav2Vec2Processor.from_pretrained("chcaa/xls-r-300m-danish-nst-cv9")
model = Wav2Vec2ForCTC.from_pretrained("chcaa/xls-r-300m-danish-nst-cv9")

filelist = []
subdirname = "sounds"
for x in os.listdir("./"+subdirname):
    if x.endswith(".wav"):
        filelist.append(subdirname+"/"+x)

filelist.sort()

totaltranscript = []

#Time stamp creation
#open file
f = open('times.txt')
times = f.readlines()
f.close()

if arguments.conventions == "basic":
    transcripttype = "basic"
    print("Selected transcription conventions: "+transcripttype)
else:
    transcripttype = "default"
    print("Selected transcription conventions: "+transcripttype+" (CLAN)")

#Format times to list
timepairs = []

for file in times:
    if file == "basic\n":
        transcripttype = "basic"
    else:
        timepair = file[0:-5].split("_")
        if timepair[0] == "0000000":           #Skip the starting time
            timepair[0] = "0"
        else:
            while timepair[0][0] == "0":       #Remove leading 0s
                timepair[0] = timepair[0][1:]
        timepairs.append(timepair)

totallength = int(timepairs[-1][1])

#Transcribe
for no,file in enumerate(filelist):
    transcriptpart = transcribe(file)
    howfinished = round(int(timepairs[no][1])/totallength*100, 2)
    print(str(howfinished)+"% finished")
    totaltranscript.append(transcriptpart)

#Creat basic text file
if transcripttype == "basic":
    basictrans = ""
    for no, line in enumerate(totaltranscript):
        line = line[0]
        if no > 0:
            pausestart = int(timepairs[no-1][1])+1
            pauseend = int(timepairs[no][0])-1
            transition = pauseend-pausestart
            if transition < 300:                #Micropause
                basictrans = basictrans+""" (.) """+line
            else:                               #Proper pause
                pause = round(transition/1000, 1)
                basictrans = basictrans+" ("+str(pause)+") "+line
        else:
            basictrans = basictrans + line
    #save basic text file
    filetosave = arguments.input[:-3]+"txt"
    with open(filetosave, 'w') as f:
        f.write(basictrans)
else: #Create CLAN file
    clantrans = """@Font:	CAfont:15:0
@UTF8
@Begin
@Languages:2     	dan
@Participants:	SPE speaker,
@Options:	CA
@Media:	"""+arguments.input+""", audio
%com:	Transcription file created with https://github.com/sorenss/transcribe-danish"""
    string = "\n"
    for no, line in enumerate(totaltranscript):
        line = line[0] #I have no idea why this is necessary
        if no > 0:
            pausestart = int(timepairs[no-1][1])+1
            pauseend = int(timepairs[no][0])-1
            transition = pauseend-pausestart
            if transition < 300: #Micropause
                string = string+"""*\t(.)\n"""
            else:                #Proper pause
                pause = round(transition/1000, 1)
                string = string+"""\n*\t("""+str(pause)+")"+" " + str(pausestart) + "_" + str(pauseend) + "\n"
        if len(line)>60:
            splitplace = line[0:60].rfind(" ")
            partialline = line[0:splitplace]
            lineremainder = line[splitplace+1:]
            string = string+"""*SPE:\t""" + partialline
            while len(lineremainder)>60:
                splitplace = lineremainder[0:60].rfind(" ")
                partialline = lineremainder[0:splitplace]
                lineremainder = lineremainder[splitplace+1:]
                string = string+"""\n\t""" + partialline
            string = string+"\n\t" + lineremainder + " " + timepairs[no][0] + "_" + timepairs[no][1] + ""
        else:
            string = string+"""*SPE:\t""" + line + " " + timepairs[no][0] + "_" + timepairs[no][1] + ""
    clantrans = clantrans+string+"\n@End"
    #Save CLAN file
    filetosave = arguments.input[:-3]+"cha"
    with open(filetosave, 'w') as f:
        f.write(clantrans)
