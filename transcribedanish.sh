#! /bin/bash
mkdir sounds
praat --run dividesounds.praat
ls sounds > times.txt
if [ -n "$1" ]; then
    echo "$1" >> times.txt
    echo "Basic text transcription requested"
else
    echo "Default: CLAN transcript"
fi
python3 speechrecognizemultiplefiles.py
rm -r sounds
rm times.txt
echo "Your file has been transcribed!"
