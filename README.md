# transcribe-danish

Automatic rough transcription of Danish using [xls-r-300m-danish-nst-cv9](https://huggingface.co/chcaa/xls-r-300m-danish-nst-cv9/discussions) (ASR, automatic speech recognition), saving it as a CLAN (.cha) file or basic text, both with pauses. The transcript will be very rough and have weird spelling, but can be a help if you like to have a rough transcript with sound-linked bullets.

# How to install and use

The script requires [Praat](https://www.fon.hum.uva.nl/praat/), Python and Bash. I have descriptions below of how I run it on Linux and Windows.

## Linux

Praat has to be installed: `sudo apt install praat`

The python packages *torch*, *datasets*, *transformers* and *librosa* are required:

	pip install torch
	pip install datasets
	pip install transformers
	pip install librosa

Download this repository (`git clone https://github.com/sorenss/transcribe-danish.git`). The sound file you want to have transcribed must be placed in the repository folder with the filename `transcribeme.wav`. From a terminal in this folder, run the bash script: `bash transcribedanish.sh`, and wait as it will take some time. If you want the basic text transcript, run `bash transcribedanish.sh basic`. When finished, the transcript will be saved to a text file called *transcribeme.cha* or *transcription.txt*.

## Windows

There are probably multiple ways to run bash scripts on Windows. The potentially easiest way for this script (that I'm doing) is through WSL (Windows Subsystem for Linux). [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (in addition, I had to [run a command](https://github.com/microsoft/WSL/issues/5256#issuecomment-1122304369) to make it work on my machine), and then you have follow the steps in the [Linux guide](#Linux). Remember that Praat has to be installed *within* WSL as it cannot use the Windows installation, i.e. `sudo apt install praat`.

# How it works

The code consists of a bash script that runs a Praat script, a Python script and some file operations. The Praat script divides the sound file into smaller 16KHz parts divided by pauses and saves them to a subfolder with timestamps. The Python script sends each separate file to xls-r-300m-danish-nst-cv9 to get it transcribed, then uses the timestamps to format the transcription into the CHAT format used by CLAN (Computerized Language Analyzer), including calculation of pauses and insertion of bullets.

The transcript will be full of errors which are due to how xls-r-300m-danish-nst-cv9 works, and not this script. There is no speaker identification, and every line will use *SPE* as the speaker's name, and speaker changes may not be seen when there is no pause between speakers. Information about the automatic speech recognition, such as word error rate, can be found on the site of [xls-r-300m-danish-nst-cv9](https://huggingface.co/chcaa/xls-r-300m-danish-nst-cv9/discussions).
