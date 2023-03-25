#! /bin/bash
if [ -z "$1" ]; then
    echo "You have not successfully specified a sound file."
else
    echo "Preparing to transcribe file..."
    mkdir sounds
    praat --run dividesounds.praat $1
    ls sounds > times.txt
    if [ -z "$2" ]; then
        python3 speechrecognizemultiplefiles.py --input $1
	else
        python3 speechrecognizemultiplefiles.py --input $1 --conventions $2
	fi
	rm -r sounds
	rm times.txt
	echo "Your file has been transcribed!"
fi
echo "The script has ended."
