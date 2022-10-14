#!pip install torch
#!pip install datasets
#!pip install transformers
#!pip install librosa

import torch
import os
from datasets import load_dataset, Audio
from datasets import Dataset
from transformers import Wav2Vec2ForCTC, Wav2Vec2Processor

# load model and tokenizer
processor = Wav2Vec2Processor.from_pretrained("chcaa/xls-r-300m-danish-nst-cv9")
model = Wav2Vec2ForCTC.from_pretrained("chcaa/xls-r-300m-danish-nst-cv9")

filelist = []
subdirname = "sounds"
for x in os.listdir("./"+subdirname):
    if x.endswith(".wav"):
        filelist.append(subdirname+"/"+x)

filelist.sort()

def transcribe(filename):
    # load dataset and read soundfiles
    ds = Dataset.from_dict({"audio": [filename]}).cast_column("audio", Audio())

    # tokenize
    input_values = processor(
        ds[0]["audio"]["array"], return_tensors="pt", padding="longest"
    ).input_values  # Batch size 1

    # retrieve logits
    logits = model(input_values).logits

    # take argmax and decode
    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = processor.batch_decode(predicted_ids)
    return transcription

totaltranscript = []

for file in filelist:
    transcriptpart = transcribe(file)
    totaltranscript.append(transcriptpart)

#Time stamp creation
#open file
f = open('times.txt')
times = f.readlines()
f.close()
#Format times to list
timepairs = []
for file in times:
    timepair = file[0:-5].split("_")
    if timepair[0] == "0000000":           #Skip the starting time
        timepair[0] = "0"
    else:
        while timepair[0][0] == "0":       #Remove leading 0s
            timepair[0] = timepair[0][1:]
    timepairs.append(timepair)

#Creat CLAN file

clantrans = """@Font:	CAfont:15:0
@UTF8
@Begin
@Languages:2     	dan
@Participants:	SPE speaker,
@Options:	CA
@Media:	transcribeme, audio"""

string = "\n"

for no, line in enumerate(totaltranscript):
    if no > 0:
        transition = int(timepairs[no][0])-int(timepairs[no-1][1])
        if transition < 300: #Micropause
            string = string+"""*ps\t(.)\n"""
        else:                #Proper pause
            pause = transition/1000
            string = string+"""\n*ps\t("""+str(pause)[:-2]+")\n"
    string = string+"""*SPE:\t""" + line[0] + " " + timepairs[no][0] + "_" + timepairs[no][1] + ""
clantrans = clantrans+string+"\n@End"

#Save CLAN file
with open('transcribeme.cha', 'w') as f:
    f.write(clantrans)
