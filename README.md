# transcribe-danish

Automatic rough transcription of Danish using [xls-r-300m-danish-nst-cv9](https://huggingface.co/chcaa/xls-r-300m-danish-nst-cv9) (a pretrained model for ASR, automatic speech recognition), saved to a CLAN (.cha) file or basic text, both with pause measurements. This cannot replace human hearing, and the transcript will be very rough with weird spelling and lots of errors, but can be a help if you like to have sound-linked bullets and a rough starting point. 

The code runs locally on your computer and the data is not sent to the cloud or elsewhere, but internet connection is needed on the first run to download the model and packages needed to run. Be aware that the transcription will not be anonymized.

# How to install and use

The script requires [Praat](https://www.fon.hum.uva.nl/praat/), Python and Bash. I have descriptions below of how I run it on Linux and Windows.

## Linux

Praat has to be installed: `sudo apt install praat`

The python packages *torch*, *datasets*, *transformers* and *librosa* are required:

	pip install torch
	pip install datasets
	pip install transformers
	pip install librosa

Download this repository (`git clone https://github.com/sorenss/transcribe-danish.git`). From a terminal in this folder, run the bash script:

	bash transcribedanish.sh FILENAMEHERE.wav

with the name of your file as specified, and wait as it will take some time. If you want a basic text transcript, run `bash transcribedanish.sh FILENAME.wav basic`. When finished, the transcript will be saved to a CLAN file (*.cha*) or text file (*.txt*).

## Windows

There are probably multiple ways to run bash scripts on Windows. The potentially easiest way for this script (that I'm doing) is through WSL (Windows Subsystem for Linux). [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (in addition, I had to [run a command](https://github.com/microsoft/WSL/issues/5256#issuecomment-1122304369) to make it work on my machine), and then you can follow the steps in the [Linux guide](#Linux). Remember that Praat has to be installed *within* WSL as it cannot use the Windows installation, i.e. `sudo apt install praat`.

# How it works

The code consists of a bash script that runs a Praat script, a Python script and some file operations. The Praat script divides the sound file into smaller 16 kHz parts divided by pauses and saves them to a subfolder with timestamps. The Python script sends each separate file to xls-r-300m-danish-nst-cv9 to get it transcribed, then uses the timestamps to format the transcription into the CHAT format used by CLAN (Computerized Language Analyzer), including calculation of pauses and insertion of bullets.

The transcript will only be a starting point, and will be full of errors which are due to how xls-r-300m-danish-nst-cv9 works, and not this script. There is no speaker identification, and every line will use *SPE* as the speaker's name. Speaker changes may not be seen when there is no pause between speakers. The pause detection does not take inbreaths into account. Names and other information you may want to be anonymized, will not be with this transcript. Information about the automatic speech recognition, such as word error rate, can be found on the site of [xls-r-300m-danish-nst-cv9](https://huggingface.co/chcaa/xls-r-300m-danish-nst-cv9/discussions).
