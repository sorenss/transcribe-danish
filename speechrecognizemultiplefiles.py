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

print(totaltranscript)
