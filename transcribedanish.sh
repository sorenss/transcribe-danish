#! /bin/bash
mkdir sounds
#Hacky solution which should be changed so filename is passed to praat
mv $1 transcribeme.wav
praat --run dividesounds.praat
mv transcribeme.wav $1
ls sounds > times.txt
python3 speechrecognizemultiplefiles.py --input $1 --conventions $2
rm -r sounds
rm times.txt
echo "Your file has been transcribed!"
