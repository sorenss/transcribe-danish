# transcribe-danish

Automatic transcription of Danish using [xls-r-300m-danish-nst-cv9](https://huggingface.co/chcaa/xls-r-300m-danish-nst-cv9/discussions) (ASR, automatic speech recognition), saving it as a CLAN (.cha) file.

# How to install and use

The script requires [Praat](https://www.fon.hum.uva.nl/praat/) and Python.

## Linux

Praat has to be installed: `sudo apt install praat`.

The python packages torch, datasets, transformers and librosa are needed:

	pip install torch
	pip install datasets
	pip install transformers
	pip install librosa`

Download this repository (`git clone https://github.com/sorenss/transcribe-danish.git`). The sound file you want to have transcribed, must be a 16KHz wav-file. Put it in the repository folder with the filename `transcribeme.wav`. From a terminal in this folder, run the bash script: `bash transcribedanish.sh`, and wait as it will take some time.

When finished, the transcript will be saved to a text file called *transcribeme.cha*.

## Windows

There are probably multiple ways to run bash scripts on Windows. The potentially easiest way for this script (that I'm doing) is through WSL (Windows Subsystem for Linux). [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (in addition, I had to [run a command](https://github.com/microsoft/WSL/issues/5256#issuecomment-1122304369) to make it work on my machine), and then you have follow the steps in the [Linux guide](#Linux). Remember that Praat has to be installed within WSL, i.e. `sudo apt install praat`.

# How it works

The code consists of a bash script that runs a Praat script, a Python script and some file operations. The Praat script divides the sound file into smaller bits divided by pauses and saves them to a subfolder with timestamps. The Python script sends each separate file to xls-r-300m-danish-nst-cv9 to get it transcribed, then uses the timestamps to format the transcription into the CHAT format used by CLAN (Computerized Language Analyzer), including calculation of pauses between turns.
