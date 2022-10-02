#! /bin/bash
praat --run dividesounds.praat
python3 transcribemultiple.py >> transcription.txt
