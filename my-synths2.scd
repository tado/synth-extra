(
SynthDef(\superp5str, {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
	gate=1, pitch1 = 2, voice = 0.5, cutoff= 20000, rq=0.5|
	var sound;
	//var env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
	var env = EnvGen.ar(Env.pairs([[0,0],[0.07,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	var lfo, pulse, filter;
	freq = freq / 2.0;
	lfo = LFTri.kr(pitch1*[1,1.01],Rand(0,2.0)!2);
	pulse = Pulse.ar(freq*[1,1.01],lfo*voice+0.5);
	filter = RLPF.ar(pulse,cutoff,rq);
	sound = Mix(filter) * 0.5;
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef(\superlaser, {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
	voice = 0.03, pitch1 = 4, gate=1|
	var sound;
	var env = EnvGen.ar(Env.pairs([[0,0],[0.07,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	var osc1, freqenv, ampenv;
	freqenv = EnvGen.ar(Env([pitch1,0.1,1,1],[voice,0.01,1.0]));
	osc1 = LFTri.ar(freq*freqenv);
	sound = osc1*0.5;
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef(\superost, {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
	gate = 1, lforate = 3, lfowidth= 0.1|
	var sound;
	var env = EnvGen.ar(Env.adsr(0.01,0.05,0.5,0.1), gate, doneAction:2, timeScale:sustain);
	var lfo, pulse, filter;
	freq = freq / 2.0;
	lfo = LFTri.kr(lforate,Rand(0,2.0)!3);
	pulse = Pulse.ar(freq*[1,1.01,0.5],lfo*lfowidth+0.5);
	sound = Mix(pulse);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef(\superbass, {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
	gate=1, cutoff= 800, rq=0.2|
	var sound;
	var env = EnvGen.ar(Env.adsr(0.01,0.0,0.9,0.05),gate,doneAction:2, timeScale:sustain);
	var osc, filter, filterenv;
	freq = freq / 4.0;
	osc = Saw.ar(freq);
	filterenv = EnvGen.ar(Env.adsr(0.0,0.5,0.2,0.2),gate,doneAction:2);
	filter =  RLPF.ar(osc,cutoff*filterenv+100,rq);
	sound = Mix(filter);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);


(
SynthDef(\supermoog2, {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
	gate=1, attackTime= 0.2, fenvamount=1.0, cutoff= 10000, voice=2.0|
	var sound;
	//var env = EnvGen.ar(Env.adsr(0.001,0.3,0.9,0.2),gate,doneAction:2, timeScale:sustain);
	var env = EnvGen.ar(Env.pairs([[0,0],[0.07,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	var osc, filter, filterenv;
	freq = freq / 4.0;
	freq = [freq, freq * 1.001];
	osc = Mix(Pulse.ar(freq.lag(0.05)*[1.0,1.001,2.0],Rand(0.45,0.5)!3,0.33));
	filterenv = EnvGen.ar(Env.adsr(attackTime,0.0,1.0,0.2),gate,doneAction:2);
	filter =  MoogFF.ar(osc,cutoff*(1.0+(fenvamount*filterenv)), 2.0);
	//sound = 0.5*filter+(0.5*filter.distort);
	sound = (filter * voice).distort;
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);


(
SynthDef(\superwho, {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
	amp = 0.5, gate=1, cutoff=8000, rq=0.8|
	var sound, fx;
	var env = EnvGen.ar(Env.pairs([[0,0],[0.07,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	var osc, filter;
	var basefreq =  (((freq/2.0).cpsmidi)+[0,0.1]).midicps;
  	osc = Mix.fill(10,{|i| SinOsc.ar(basefreq*(i+1),0.0,(0.25+(0.75*LFNoise0.kr(10.1+i,0.5,0.5)))/(1.0+(0.5*i)))})*0.2;
	filter =  BLowPass.ar(osc,2000+(amp*cutoff),rq);
	sound = Mix(filter);
	fx = BLowPass.ar(BLowPass.ar(sound,SinOsc.ar(0.25,0,5000,5500),0.4),(200+(5000*SinOsc.ar(4.01,0.5,0.5,0.5))),0.6);
	sound = (sound * 0.7) + (fx * 0.3);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef(\superrhodes, {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
	gate=1, lforate = 4.85, lfowidth= 0.5, cutoff= 2000, rq=0.5|
	var sound;
	var pulse, filter, env;
	pulse = Pulse.ar(freq*[1,33.5.midiratio],[0.2,0.1],[0.7,0.3]);
	env = EnvGen.ar(Env.adsr(0.0,1.0,0.8,3.0),gate,doneAction:2, timeScale:sustain);
	filter = BLowPass4.ar(pulse,(cutoff*(env.squared))+200+freq,rq);
	sound = Mix(filter);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);

