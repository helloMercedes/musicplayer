#!/bin/bash

STATEFILE="state.txt"

settozero(){
    indexline=$(pacmd list-sink-inputs | egrep -B 21 "$pidtokill" | egrep "index")
    length=${#indexline}
    let l=length-11
    index=${indexline:11:$l}
    pacmd set-sink-input-volume "$index" "1"
}


fadeout(){
    count=32767
    for i in {1..40} 
    do
        indexline=$(pacmd list-sink-inputs | egrep -B 21 "$pidtokill" | egrep "index")
        length=${#indexline}
        let l=length-11
        index=${indexline:11:$l}
        pacmd set-sink-input-volume "$index" "$count"
        let count=count-760
        sleep .1
    done
}

fadein(){
    
    count=1
    for i in {1..40} 
    do
        indexline=$(pacmd list-sink-inputs | egrep -B 21 "$pidtokill" | egrep "index")
        length=${#indexline}
        let l=length-11
        index=${indexline:11:$l}
        pacmd set-sink-input-volume "$index" $count
        let count=count+819
        sleep .1
    done
}
amixer -q sset Master 50%

statevariable="base"
pidtokill=0

#precondition: volume is up at working vol
while true; do
    if  grep -q "AMG" $STATEFILE && ! [ "$statevariable" == "AMG" ]; then
        fadeout
        kill -9 "$pidtokill"
        aplay ~/musicplayer/AMG_Musik_def.wav &
        pidtokill="$!"
        statevariable="AMG"
        indexline=$(pacmd list-sink-inputs | egrep -B 21 "$pidtokill" | egrep "index")
        length=${#indexline}
        let l=length-11
        index=${indexline:11:$l}
        echo "$index"
        pacmd set-sink-input-volume "$index" "65500"
    fi

    if grep -q "EQC" $STATEFILE && ! [ "$statevariable" == "EQC" ]; then
        fadeout
        kill -9 "$pidtokill"
        
        statevariable="EQC"
        amixer -q sset Master 0%
        aplay ~/musicplayer/'EQC-Sound2-wind - 20.03.21, 12.wav' &
        pidtokill="$!"
        settozero
        amixer -q sset Master 100%
        fadein
    fi

    if grep -q "LOUNGE" $STATEFILE && ! [ "$statevariable" == "LOUNGE" ]; then
        
        statevariable="LOUNGE"
        amixer -q sset Master 0%
        aplay ~/musicplayer/Lounge_Musik_def.wav &
        pidtokill="$!"
        settozero
        amixer -q sset Master 100%
        fadein
    fi
    sleep .1
done
