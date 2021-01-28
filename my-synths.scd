//---------- My Extra Synths --------------
(
SynthDef(\sync, {|out, sustain=1, pan, freq |
}).add
);

(
	SynthDef(\supersin, {|out, speed=1, decay=0, sustain=1, pan, accelerate, freq,
		voice=0.5, semitone=12, resonance=0.2, lfo=1, pitch1=1|
		var env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
		var basefreq = freq* Line.kr(1, 1+accelerate, sustain);
		var basefreq2 = basefreq / (2**(semitone/12));
		var lfof1 = min(basefreq*10*pitch1, 22000);
		var lfof2 = min(lfof1 * (lfo + 1), 22000);
    	var sound = SinOsc.ar(basefreq);
		OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
	}).add
);

(
SynthDef("myDrone", {
	arg out, speed=1, decay=0, sustain=1, pan, accelerate, freq,	voice=1.0, semitone=12, resonance=0.3, pitch1=1;
	var num = 1, detune = 0.001, ratio = 1.5, harm = 1.5, amp = 0.2;
	var env = EnvGen.ar(Env.perc(0.5, 0.5), timeScale:sustain, doneAction:2);
	var lfo = SinOsc.ar(rrand(0.03, 0.05), 0, 100, 600);
	var sound = Saw.ar([freq+detune.rand, freq+detune.rand] * (ratio ** voice)) * amp
	+ Saw.ar([freq*harm+detune.rand, freq*harm+detune.rand] * (ratio ** voice)) * amp;
	sound = RLPF.ar(sound, lfo * (1.5 ** voice), resonance).clip2;
	4.do({ sound = AllpassL.ar(sound, 0.1, LFNoise2.kr([rrand(0.0, 0.1),rrand(0.0, 0.1)],0.01,0.06), 2.0) });
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);

/*
(
SynthDef(\myMoog, {|out, sustain=1, pan, accelerate, freq, speed=1.0, voice=2.25|
	var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1, -3), timeScale:sustain, doneAction:2);
	var sound =  MoogFF.ar(
		Pulse.ar([freq * speed, freq*speed*2.02], 0.1),
		freq*speed*voice,
		128
	);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);
*/

(
SynthDef(\ike1, {
	arg out, sustain=1, pan, accelerate, freq, speed=1.0, voice=2.25, detune=1.1, pitch1=100;
	var env = EnvGen.ar(Env.perc(0.01, 0.01,1.0), timeScale:sustain*0.05, doneAction:2);
	var sound =  BPF.ar
		(
			PinkNoise.ar(),
			15000 * speed,
			0.9,
			25 * LFNoise1.ar(8).range(0, 1)
		).fold(-1, 1);
	OffsetOut.ar(out, DirtPan.ar(sound*16.0, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef(\ike2, {
	arg out, sustain=1, pan, accelerate, freq, speed=1.0, voice=2.25, detune=1.1, pitch1=100;
	var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1, -3), timeScale:sustain*0.1, doneAction:2);
	var sound =  LPF.ar
		(
			SinOsc.ar(44.midicps * speed, 0, 0.5) + SinOsc.ar(90.midicps * speed, 0, 0.6),
			32.midicps * 2
		) + HPF.ar(LPF.ar(WhiteNoise.ar(0.008), 12000), 2400);
	OffsetOut.ar(out, DirtPan.ar(sound*4.0, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef(\ike3, {
	arg out, sustain=1, pan, accelerate, freq, speed=1.0, voice=2.25, detune=1.1, pitch1=100;
	var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1, -3), timeScale:sustain*0.4, doneAction:2);
	var sound =  SinOsc.ar(0, (Sweep.ar(1.0, 2pi * [52.8, 740]) + (pi/3)).wrap(-pi, pi), [2, 0.05]).mean.tanh;
	OffsetOut.ar(out, DirtPan.ar(sound*4.0, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef("myblip", {|out, speed=1, sustain=1, pan, voice=0, freq |
	var env, sound;
	freq = freq / [4.0, 4.01];
	//freq = [freq, freq * 1.01];
	env = EnvGen.ar(Env.linen(0.00, 0, 1, 1, -3), timeScale:sustain, doneAction:2);
	sound = RLPF.ar(Pulse.ar(freq, 0.5), 9000, 0.2);
	sound = CompanderD.ar(sound*2.0);
	8.do({sound = AllpassL.ar(sound, 0.2, 0.005, 1.0, 1.0)});
	//sound = LeakDC.ar(sound);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
	}).add
);

(
	SynthDef(\mybass, {|out, speed=1, sustain=1, pan, voice=0, freq, decay=0|
	var env, sound;
	 freq = [freq / 2.0, freq / 2.01];
	//env = EnvGen.ar(Env.adsr(0.0, 0.0, 1.0, 0.01), timeScale:sustain, doneAction:2);
	env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
	//sound = LPF.ar(SinOscFB.ar(XLine.ar(freq.expexp(10, 2000, 1000, 8000), freq, 0.5/speed), voice), 9000);
	//sound = SyncSaw.ar(XLine.ar(80, freq*[12, 12.01], sustain), [freq, freq*1.01]/4.0);
	sound = BMoog.ar(
		LFSaw.ar([freq * 0.99, freq * 1.01], 0, 0.1) ! 2,
		SinOsc.kr(SinOsc.kr(0.1),1.5pi,1550,1800),
		0.1,1);
	(CombN.ar(sound, 0.4, [0.4,0.35],2) * 0.4) + (sound * 0.5);
	sound = CompanderD.ar(sound*1.5);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add
);

(
SynthDef(\myfm, {
	arg out, sustain=1, pan, accelerate, freq, speed=1.0, voice=1.0, detune=1.01, pitch1=0.3333, carPartial = 1, mul = 0.3, decay=0;
	var env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
	var car, mod, sound;
	mod = SinOsc.ar(freq * pitch1, 0, freq * voice * LFNoise1.kr(4.reciprocal).abs);
	car = SinOsc.ar(([freq, freq*detune] * carPartial) + mod, 0, mul);
	OffsetOut.ar(out, DirtPan.ar(car, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef("bfm", {
	arg out = 0, sustain=1, gate = 1, amp = 1, freq, pitch1 = 0.3333, voice = 1000, clipAmount = 0.01, pan, decay=0;
	var carFreq = freq;
	var modFreq = freq * pitch1;
	var modEnv = EnvGen.ar(Env.adsr(0.001, 0.2, 0.5, 0.0, peakLevel: voice), timeScale:sustain);
	var mod = SinOsc.ar([modFreq, modFreq * 1.01]) * modEnv;
	var car = SinOsc.ar(carFreq + mod);
	//var env = EnvGen.ar(Env.adsr(0.1, 0.3, 0.7, 0.2, peakLevel: amp), timeScale:sustain, doneAction: 2);
	var env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
	var clip = clipAmount * 500;
	OffsetOut.ar(out, DirtPan.ar(car, ~dirt.numChannels, pan, env));
	//Out.ar(out, (car * ampEnv * clip).clip(-0.7, 0.7) * 0.1);
}).add;
);

(
SynthDef("skick", {|out, freq=60, speed=1, sustain=0.1, voice=8, pan, n |
	var env, snd;
	freq = freq / 8.0;
	env = EnvGen.ar(Env.linen(0.01, 0, 1, 1, -3), timeScale:sustain, doneAction:2);
    snd = DC.ar(0);
    snd = snd + (SinOsc.ar(XLine.ar(1500, 800, 0.01)) * Env.perc(0.0005, 0.01, curve: \lin).ar);
    snd = snd + (BPF.ar(Impulse.ar(0) * SampleRate.ir / 48000, 6100, 1.0) * 3.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 300, 0.9) * Env.perc(0.001, 0.02).ar);
    //snd = snd + (SinOsc.ar(XLine.ar(472, freq, 0.045)) * Env.perc(0.0001, 1.0, curve: \lin).delay(0.005).ar(2));
	snd = snd + (SinOsc.ar(XLine.ar(472, freq, 0.045)));
	snd = snd * voice;
    snd = snd.tanh;
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env))
}).add
);

(
SynthDef("bmoog", {|out, speed=0.5, decay=0, sustain=1, pan, accelerate, freq,
		voice=0.5, semitone=7, resonance=0.2, lfo=1, pitch1=0.5|
		var env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
		var basefreq = freq * Line.kr(1, 1+accelerate, sustain);
		var basefreq2 = basefreq * (2**(semitone/12));
		var lfof1 = min(basefreq*10*pitch1, 22000);
		var lfof2 = min(lfof1 * (lfo + 1), 22000);
		var sound = BMoog.ar(
		LFSaw.ar([basefreq, basefreq*1.01], 0, 0.1) ! 2,
        SinOsc.kr(speed/sustain,1.5pi,1550,1800),
        pitch1,
        0);
	    //sound = (CombN.ar(sound, 0.4, [0.4,0.35],2) * 1.0);
	    sound = sound.tanh*2;
		OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
	}).add
);

(
SynthDef("gabkick", {
	arg out = 0, pan, freq;
    var snd, env;
	env = EnvGen.ar(Env([0, 1, 0.7, 0.7, 0], [0.001, 0.01, 0.3, 0.02]), doneAction:2);
    snd = SinOsc.ar(Env([1000, freq/3.0, freq/4.0], [0.015, 0.1], \exp).ar * [-0.1, 0, 0.1].midiratio);
    snd = Mix(snd);
    snd = (snd * 10).tanh;
    snd = (snd * 5.1).atan;
    snd = BPeakEQ.ar(snd, XLine.kr(2000, 100, 0.3), 2.0, 8);
    snd = snd + DelayC.ar(snd, 0.01, SinOsc.ar(4).range(0.0, 0.001));
    snd = RLPF.ar(snd, 8000, 0.7);
    //snd = snd * Env([0, 1, 0.7, 0.7, 0], [0.001, 0.01, 0.3, 0.02]).ar(2);
	snd = (snd*0.8).softclip(-0.7, 0.7);
	snd = snd.tanh*2;
    //Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env))
}).add;
)
