#! /bin/bash
if [ -z "$1" ]; then
    echo "You have not successfully specified a file to transcribe."
elif [ ${1: -4} != ".wav" ]; then
    echo "The filename needs to end with .wav"
else
    fileinput=$1
    fileoutput=${fileinput//.wav/.cha}
    fileoutputb=${fileinput//.wav/.txt}
    if [ -f "$fileoutput" ] && [ -z "$2" ]; then
        echo "There already is a transcription named $fileoutput. Please delete, rename or move this file. This script will not overwrite it."
        exit 1
    elif [ -f "$fileoutputb" ] && [ "$2" == "basic" ]; then
        echo "There already is a transcription named $fileoutputb. Please delete, rename or move this file. This script will not overwrite it."
        exit 1
    else
        if [ -d "sounds" ]; then
            echo "Deleting temporary files from earlier, interrupted runs..."
            rm -r sounds
            rm times.txt
        fi
        echo "Preparing to transcribe file:" $fileinput
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
    fi
    if [ -z "$2" ]; then
        if [ -f "$fileoutput" ]; then
            echo "Your file has been transcribed and saved as $fileoutput."
        else
            if [ -f "$fileoutputb" ]; then
                echo "Your file has been transcribed and saved as $fileoutputb."
            else
                echo "Something went wrong, a."
            fi
        fi
    else
        if [ "$2" == "basic" ]; then
            if [ -f "$fileoutputb" ]; then
                echo "Your file has been transcribed and saved as $fileoutputb."
            else
                echo "Something went wrong, b."
            fi
        fi
    fi
fi
echo "The script has ended."
