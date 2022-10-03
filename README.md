# transcribe-danish

Automatic transcription of Danish using [xls-r-300m-danish-nst-cv9](https://huggingface.co/chcaa/xls-r-300m-danish-nst-cv9/discussions) (ASR, automatic speech recognition) and a Praat script.

# How to install and use

The script requires [Praat](https://www.fon.hum.uva.nl/praat/) and Python. I have descriptions below of how I run it on Linux and Windows.

## Linux

Praat has to be installed: `sudo apt install praat`

The python packages torch, datasets, transformers and librosa are needed:

	pip install torch
	pip install datasets
	pip install transformers
	pip install librosa

Download this repository (`git clone https://github.com/sorenss/transcribe-danish.git`). The sound file you want to have transcribed, must be a 16KHz wav-file. Put it in the repository folder with the filename `transcribeme.wav`. From a terminal in this folder, run the bash script: `bash transcribedanish.sh`, and wait as it will take some time.

The script will divide your sound file into separate parts and put them in the *split* folder, and when finished, will save the transcript to a text file called *transcript.txt*.

## Windows

There are probably multiple ways to run bash scripts on Windows. The potentially easiest way for this script (that I'm doing) is through WSL (Windows Subsystem for Linux). [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (in addition, I had to [run a command](https://github.com/microsoft/WSL/issues/5256#issuecomment-1221323804) to make it work on my machine), and then you have follow the steps in the [Linux guide](#Linux). Remember that Praat has to be installed *within* WSL, i.e. `sudo apt install praat`.

# How it works

The code consists of a bash script that runs a Praat script and a Python script. The Praat script divides the file into smaller portions so that the next script does not run out of RAM.

The other script performs Automatic Speech Recognition on the audio files, When it is finished, it saves the text to a file called *transcription.txt*.