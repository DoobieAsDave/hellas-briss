BPM tempo;

Gain master;

SndBuf kick => LPF kickFilter => master;
SndBuf snare => BPF snareFilter => master;
SndBuf percussion => HPF percFilter => BRF rejectFilter => master;

master => dac;

///

me.dir() + "audio/loop.wav" => kick.read;
me.dir() + "audio/loop.wav" => snare.read;
me.dir() + "audio/loop.wav" => percussion.read;
kick.samples() => kick.pos;
snare.samples() => snare.pos;
percussion.samples() => percussion.pos;

//80 => Std.mtof => kickFilter.freq;
111 => Std.mtof => kickFilter.freq;
8.0 => kickFilter.Q;

150 => Std.mtof => snareFilter.freq;
10.0 => snareFilter.Q;
0.8 => snareFilter.gain;

90 => Std.mtof => percFilter.freq;
5.0 =>  percFilter.Q;
0.8 => percFilter.gain;

.5 => percussion.rate;
.5 => percussion.gain;

100 => Std.mtof => rejectFilter.freq;
3.0 =>  rejectFilter.Q;
1.0 => rejectFilter.gain;

1.0 / 3.0 => master.gain;

///

function void playKick() {
    while(true) {        
        for (0 => int beat; beat < 4; beat++) {
            for (0 => int step; step < 4; step++) {                 
                if (beat % 2 != 1 || step != 3) {                    
                    0 => kick.pos;       
                    tempo.bar => now;                    
                }
                else {                    
                    0 => kick.pos;       
                    tempo.bar / 2 => now;                    
                    
                    int rep;                    
                    if (Math.random2(0, 1)) 4 => rep;
                    else 6 => rep;

                    repeat(rep) {
                        0 => kick.pos;       
                        (tempo.bar / 2) / rep => now;
                    }
                }
            }
        }
    }
}

function void playSnare() {
    while(true) {
        for (0 => int beat; beat < 4; beat++) {
            for (0 => int step; step < 4; step++) {
                if (beat == 3 && step == 0) {
                    0 => percussion.pos;       
                    tempo.bar / 2 => now;

                    repeat(2) {
                        percussion.samples() * .25 => Std.ftoi => percussion.pos;
                        (tempo.bar * .5) / 2 => now;
                    }   
                }
                else {                
                    0 => percussion.pos;       
                    tempo.bar * .5 => now;                            
                }                
            }
        }
    }
}

function void playPerc() {
    while(true) {
        for (0 => int beat; beat < 4; beat++) {
            for (0 => int step; step < 4; step++) {
                0 => percussion.pos;      
                tempo.bar => now;                  
            }
        }
    }
}

///

Shred kickShred, snareShred, percShred;

spork ~ playKick() @=> kickShred;
tempo.bar * 8 => now;
spork ~ playSnare() @=> snareShred;
tempo.bar * 16 => now;
spork ~ playPerc() @=> percShred;
tempo.bar * 8 => now;
Machine.remove(percShred.id());
tempo.bar * 8 => now;
Machine.remove(snareShred.id());
tempo.bar * 8 => now;
Machine.remove(kickShred.id());