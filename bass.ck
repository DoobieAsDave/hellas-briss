BPM tempo;

Gain master;

SinOsc bass => master;
SinOsc sub => master;

master => ADSR adsr => dac;

(1.0 / 2.0) / 2.0 => master.gain;

///

function void runBass(dur stepDuration, int melody[], dur noteDurations[]) {
    while(true) {
        for (0 => int step; step < melody.cap(); step++) {
            setADSR(noteDurations[step]);

            melody[step] => Std.mtof => bass.freq;
            melody[step] - 12 => Std.mtof => sub.freq;  

            if (step % 3 == 1)       {
                stepDuration / 2 => now;
            }

            if (step == melody.cap() - 1) {
                stepDuration / 4 => now;
            }

            1 => adsr.keyOn;
            noteDurations[step] - adsr.releaseTime() => now;
            1 => adsr.keyOff;
            adsr.releaseTime() => now;
        }
    }
}
function void setADSR(dur noteDuration) {
    noteDuration * .2 => dur riseDuration;

    riseDuration * Math.random2f(.5, 1) => dur attack;
    riseDuration - attack => dur decay;
    Math.random2f(.9, 1) => float sustain;
    noteDuration * .2 => dur release;

    (attack, decay, sustain, release) => adsr.set;
}

///

tempo.halfBar => dur duration;

38 => int key;
[key, key, key - 5, key, key, key - 7] @=> int melodyA[];
[
    duration,
    duration * .25,
    duration * .75,
    (duration / 4) * 1,
    (duration / 4) * 3,
    duration - (duration / 4)
] @=> dur chordDurationsA[];

///

tempo.bar * 4 => now;

spork ~ runBass(duration, melodyA, chordDurationsA);

while(true) second => now;