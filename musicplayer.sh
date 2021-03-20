#!/bin/bash

STATEFILE="/home/pi/state"

fadeout(){
    count=65535
    for i in {1..50}
    do
        indexline=$(pacmd list-sink-inputs | egrep -B 21 "$pidtokill" | egrep "index")
        length=${#indexline}
        echo "$indexline"
        let l=length-11
        index=${indexline:11:$l}
        echo "$index"
        len=${#index}
        echo "$len"
        pacmd set-sink-input-volume "$index" "$count"
        let count=count-1000
        sleep .1
    done
}

fadein(){
    for i in {1..90}
    do
        amixer -q sset Master 3%+
        sleep .1
    done
}
amixer -q sset Master 100%
Pathtofile="~/hellomercedes/state.txt"
statevariable="base"
pidtokill=0
aplay ~/hellomercedes/file_example_WAV_1MG.wav &
#precondition: volume is up at working vol
while true; do

    if  grep -q "AMG" $STATEFILE && ! [ "$statevariable" == "AMG" ]; then
        fadeout
        kill -9 "$pidtokill"
        aplay ~/hellomercedes/file_example_WAV_1MG.wav &
        pidtokill="$!"
        statevariable="AMG"
        fadein
    fi

    if grep -q "EQC" $STATEFILE && ! [ "$statevariable" == "EQC" ]; then
        fadeout
        kill -9 "$pidtokill"
        aplay ~/hellomercedes/organfinale.wav &
        pidtokill="$!"
        statevariable="EQC"
        fadein
    fi

done
