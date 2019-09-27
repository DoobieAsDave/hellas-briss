BPM tempo;

Gain master;

SawOsc voice1 => master;
SawOsc voice2 => master;
SawOsc voice3 => master;
SawOsc voice4 => master;

master => ADSR adsr => Chorus chorus => NRev reverb => dac;

.175 => chorus.modFreq;
.05 => chorus.modDepth;
0.3 => chorus.mix;

.7 => reverb.mix;

(1.0 / 4.0) / 2.0 => master.gain;

///

function void runPad(dur stepDuration, int melody[], int harmony[], dur chordDurations[]) {
    while(true) {
        for (0 => int step; step < melody.cap(); step++) {
            setADSR(chordDurations[step]);

            melody[step] => Std.mtof => voice1.freq;
            melody[step] + 7 => Std.mtof => voice3.freq;
            if (harmony[step]) {
                melody[step] + 4 => Std.mtof => voice2.freq;
                melody[step] + 11 => Std.mtof => voice4.freq;
            }   
            else {
                melody[step] + 3 => Std.mtof => voice2.freq;
                melody[step] + 10 => Std.mtof => voice4.freq;
            }

            1 => adsr.keyOn;
            chordDurations[step] - adsr.releaseTime() => now;
            1 => adsr.keyOff;
            adsr.releaseTime() => now;

            if (chordDurations[step] < stepDuration) {
                stepDuration - chordDurations[step] => now;
            }
        }
    }
}
function void setADSR(dur noteDuration) {
    noteDuration * 6 => dur riseDuration;

    riseDuration * Math.random2f(.5, 1) => dur attack;
    riseDuration - attack => dur decay;
    Math.random2f(.6, 1) => float sustain;
    noteDuration * .4 => dur release;

    (attack, decay, sustain, release) => adsr.set;
}

///

tempo.bar * 4 => dur duration;

50 => int key;
[key] @=> int melodyA[];
[1] @=> int harmonyA[];
[
    duration * Math.random2f(.5, 1),
    duration * Math.random2f(.5, 1),
    (duration * 2) * .5,
    (duration / 2) * .5
] @=> dur chordDurationsA[];

///

tempo.bar * 16 => now;
spork ~ runPad(duration, melodyA, harmonyA, chordDurationsA);

while(true) second => now;