#! /bin/bash
mkdir sounds
praat --run dividesounds.praat
python3 speechrecognizemultiplefiles.py >> transcription.txt
rm -r sounds
