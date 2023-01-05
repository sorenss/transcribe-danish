#! /bin/bash
mkdir sounds
praat --run dividesounds.praat $1
ls sounds > times.txt
if [ -z "$2" ]
then
    python3 speechrecognizemultiplefiles.py --input $1
else
    python3 speechrecognizemultiplefiles.py --input $1 --conventions $2
fi
rm -r sounds
rm times.txt
echo "Your file has been transcribed!"
