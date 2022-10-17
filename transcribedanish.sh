#! /bin/bash
mkdir sounds
praat --run dividesounds.praat
ls sounds > times.txt
python3 speechrecognizemultiplefiles.py
rm -r sounds
rm times.txt
echo "Your file has been transcribed!"
