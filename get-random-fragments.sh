#!/usr/bin/env bash

LENGTH=500
MINLENGTH=500
OVERLAP=0
REMOVE=

usage()
{
echo "
Description: $0 is a pipeline that shreds sequences using shred.sh from BBtools and randomly selects one fragment for each sequence

Usage: [$0 <-f fasta> [-l length] [-m minimum length] [-o overlap] [-r]  | [-h]]
-f | --fasta            Input fasta file
-l | --length           Fragment length ; default = 500
-m | --minlength        Minimum fragment length. The last fragment of each input sequence may be shorter than desired length. Default = 500
-o | --overlap          Number of bases overlapping between fragments; default = 0 (no overlap)
-r | --remove           Remove the file produced by shred.sh after the selection of the random fragments; default to keep
-h | --help             Display this help message and exit
"
}

if [[ $# -eq 0 ]] ; then
    usage
    exit 1
fi

while [ "$1" != "" ]; do
    case $1 in
        -f | --fasta )           shift
                                FASTA=$1
                                ;;
        -l | --length )                 shift
                                LENGTH=$1
                                ;;
        -m | --minlength )              shift
                                MINLENGTH=$1
                                ;;
        -o | --overlap )              shift
                                OVERLAP=$1
                                ;;
        -r | --remove )         REMOVE=1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     echo >&2 "Invalid option(s)"
                                usage
                                exit 1
    esac
    shift
done

#check if required executables are in PATH
type shred.sh >/dev/null 2>&1 || { echo >&2 "shred.sh is not in your PATH.  Aborting..."; exit 1; }
type subsample.py >/dev/null 2>&1 || { echo >&2 "subsample.py is not in your PATH.  Aborting..."; exit 1; }

#check if input fasta file exists and not empty
if [ ! -f $FASTA ]; then
    echo >&2 "$FASTA does not exist"
    usage
    exit 1
elif [ ! -s $FASTA ]; then
    echo >&2 "$FASTA is empty"
    usage
    exit 1
fi
shred.sh in=$FASTA out=${FASTA%.*}_shred.fa length=${LENGTH} minlength=${MINLENGTH} overlap=${OVERLAP}
subsample.py ${FASTA%.*}_shred.fa ${FASTA%.*}_shred_subsampled.fa

if [ "$REMOVE" == 1 ]; then
    rm ${FASTA%.*}_shred.fa
fi
