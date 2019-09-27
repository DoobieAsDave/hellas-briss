BPM tempo;

Gain master;

SinOsc voice1 => master;
SinOsc voice2 => master;
SinOsc voice3 => master;

master => ADSR adsr => JCRev reverb => dac;

0.4 => reverb.mix;

.5 => voice1.gain => voice2.gain => voice3.gain;
(1.0 / 3.0) / 5.0 => master.gain;

///

function void playVoice(dur stepDuration, int melody[], int harmony[], dur noteDurations[]) {
    while(true) {
        for (0 => int beat; beat < 4; beat++) {
            for (0 => int step; step < melody.cap(); step++) {
                setADSR(noteDurations[step]);
                
                melody[step] => Std.mtof => voice1.freq;
                melody[step] + 7 => Std.mtof => voice3.freq;
                if (harmony[step]) melody[step] + 4 => Std.mtof => voice2.freq;
                else melody[step] + 3 => Std.mtof => voice2.freq;                
                
                1 => adsr.keyOn;
                noteDurations[step] - adsr.releaseTime() => now;            
                1 => adsr.keyOff;
                adsr.releaseTime() => now;                

                stepDuration - noteDurations[step] => now;
            }
        }
    }
}
function void setADSR(dur noteDuration) {
    noteDuration / 2 => dur riseTime;

    riseTime * Math.random2f(.6, .8) => dur attack;
    riseTime - attack => dur decay;
    Math.random2f(.5, 1) => float sustain;
    noteDuration * Math.random2f(.2, .5) => dur release;

    (attack, decay, sustain, release) => adsr.set;
}

///

tempo.eighthBar / 3 => dur duration;

[55, 59, 62, 66, 69, 71] @=> int melodyA[];
[ 0,  0,  0,  0,  0,  0] @=> int harmonyA[];
[
    duration * Math.random2f(.3, 1),
    duration * Math.random2f(.3, 1),
    duration * Math.random2f(.3, 1),
    duration * Math.random2f(.3, 1),
    duration * Math.random2f(.3, 1),
    duration * Math.random2f(.3, 1)
] @=> dur noteDurationsA[];

[50, 54, 57, 62, 66, 69] @=> int melodyB[];
[ 0,  0,  0,  0,  0,  0] @=> int harmonyB[];
[
    duration * Math.random2f(.3, .5),
    duration * Math.random2f(.3, .6),
    duration * Math.random2f(.3, 1),
    duration * Math.random2f(.3, .4),
    duration * Math.random2f(.3, .8),
    duration * Math.random2f(.3, .6)
] @=> dur noteDurationsB[];

///

Shred arpShred;

tempo.bar * 8 => now;

while(true) {
    spork ~ playVoice(duration, melodyA, harmonyA, noteDurationsA) @=> arpShred;
    tempo.bar * 1.5 => now;
    Machine.remove(arpShred.id());
    spork ~ playVoice(duration, melodyB, harmonyB, noteDurationsB) @=> arpShred;
    tempo.bar * .5 => now;
    Machine.remove(arpShred.id());
}