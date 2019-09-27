.8 => dac.gain;

BPM tempo;
tempo.setBPM(128.0);

Machine.add(me.dir() + "record.ck");

Machine.add(me.dir() + "arp.ck");
//Machine.add(me.dir() + "pad.ck");
Machine.add(me.dir() + "loop.ck");
//Machine.add(me.dir() + "bass.ck");