#!bin/sh

fadeout(){
    for i in {1..15}
    do
        amixer -q sset Master 3%-
        sleep .8
    done
}

fadein(){
    for i in {1..15}
    do
        amixer -q sset Master 3%+
        sleep .8
    done
}
amixer -q sset Master 100%
Pathtofile="~/hellomercedes/state.txt"
statevariable="base"
pidtokill=0
#precondition: volume is up at working vol
while true; do

    if  grep -q "sportcar" "/home/kilian/hellomercedes/state.txt" && [ "$statevariable" != "sportcar" ]; then
        fadeout
        kill -9 "$pidtokill"
        aplay ~/hellomercedes/file_example_WAV_1MG.wav &
        pidtokill="$!"
        statevariable="sportcar"
        fadein
    fi

    if grep -q "familycar" "/home/kilian/hellomercedes/state.txt" && [ "$statevariable" != "familycar" ]; then
        fadeout
        kill -9 "$pidtokill"
        aplay ~/hellomercedes/organfinale.wav &
        pidtokill="$!"
        statevariable="familycar"
        fadein
    fi

done
