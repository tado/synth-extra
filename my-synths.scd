//---------- My Extra Synths --------------
(
SynthDef(\sync, {|out, sustain=1, pan, freq |
}).add
);

/*
(
SynthDef(\supersin, {|out, speed=1, decay=0, sustain=1, pan, accelerate, freq,
    voice=0.5, semitone=12, resonance=0.2, lfo=1, pitch1=1|
    //var env = EnvGen.ar(Env.pairs([[0,0],[0.01,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
	var env = EnvGen.ar(Env.perc(0.0, 1.0, 0.9, -48.0));
    var basefreq = freq* Line.kr(1, 1+accelerate, sustain);
    //var basefreq2 = basefreq / (2**(semitone/12));
    //var lfof1 = min(basefreq*10*pitch1, 22000);
    //var lfof2 = min(lfof1 * (lfo + 1), 22000);
    var sound = SinOsc.ar(basefreq);
    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);
*/
(
SynthDef("supersin",
	{
		arg out, decay=0.0, sustain=1.0, pan, accelerate, freq, lfo=1, detune=0.005;
		var env = EnvGen.ar(Env.pairs([[0,0],[0.0,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
		var sound = SinOsc.ar([freq, freq*(1 + detune)]);
		Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
	}
).add
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
);

(
SynthDef("superp5str", {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
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
SynthDef("superlaser", {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
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
    // freq = freq / 4.0;
    osc = Saw.ar(freq);
    filterenv = EnvGen.ar(Env.adsr(0.0,0.5,0.2,0.2),gate,doneAction:2);
    filter =  RLPF.ar(osc,cutoff*filterenv+100,rq);
    sound = Mix(filter);
    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);


(
SynthDef(\supermoog, {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
    gate=1, attackTime= 0.2, fenvamount=1.0, cutoff= 2000, voice=2.0|
    var sound;
    //var env = EnvGen.ar(Env.adsr(0.001,0.3,0.9,0.2),gate,doneAction:2, timeScale:sustain);
    var env = EnvGen.ar(Env.pairs([[0,0],[0.07,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
    var osc, filter, filterenv;
    // freq = freq / 4.0;
    freq = [freq, freq * 1.002];
    osc = Mix(Pulse.ar(freq.lag(0.05)*[1.0,1.001,2.0],Rand(0.45,0.5)!3,0.33));
    filterenv = EnvGen.ar(Env.adsr(attackTime,0.0,1.0,0.2),gate,doneAction:2);
    filter =  MoogFF.ar(osc,cutoff*(1.0+(fenvamount*filterenv)), 2.0);
    //sound = 0.5*filter+(0.5*filter.distort);
    //sound = (filter * voice).distort;
    sound = (filter * voice);
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

(
SynthDef("superfbk", {|out, speed=1, decay=0, sustain=1, pan, accelerate, freq, gate = 1,
    ratio = 1.5, detune = 1.01, rq = 0.5, gain = 1.0, distort = 0.5, wet = 0.5, flow = 400, fhigh = 20000|
    // var env = EnvGen.ar(Env.perc(0.5, 0.5), timeScale:sustain, doneAction:2);
    var env = EnvGen.ar(Env.pairs([[0,0],[0.5,1],[0.9,1-decay],[0.95,1-decay],[1,0]], -5), timeScale:sustain, doneAction:2);
    //var osc1 = Saw.ar([freq/4.0, freq/4.0*detune]);
    //var osc2 = Saw.ar([freq/4.0*ratio*detune, freq/4.0*ratio]);
    var osc1 = Saw.ar([freq, freq*detune]);
    var osc2 = Saw.ar([freq*ratio*detune, freq*ratio]);
    var mix = osc1 + osc2;
    var in = mix;
    var fbNode = FbNode(2, 0.5, 2);
    var signal = fbNode.delay;
    signal = RLPF.ar(signal * 0.5 + in, LFNoise1.kr(0.6).exprange(flow, fhigh), rq);
    signal = AnalogVintageDistortion.ar(signal, distort) * wet + (signal * (1.0 - wet));
    fbNode.write(signal);
    //signal = GVerb.ar(signal, 60, 10);
    signal = (CombN.ar(signal, 0.4, [0.4,0.35],2) * 0.3) + (signal * 0.7);
    //signal = CombN.ar(signal, 0.4, [0.4,0.35],2);
    OffsetOut.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef(\supersawfbk, {|out, rate=1, decay=0, sustain=1, pan, accelerate, freq,
    voice=0.5, semitone=12, resonance=0.2, lfo=1, pitch1=1, speed=1,
    distort = 0.5, rq = 0.5, flow = 200, fhigh = 20000|
    var env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
    var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
    var basefreq2 = basefreq * (2**(semitone/12));
    var lfof1 = min(basefreq*10*pitch1, 22000);
    var lfof2 = min(lfof1 * (lfo + 1), 22000);
    var sound = MoogFF.ar(
        (0.5 * Mix.arFill(3, {|i|  SawDPW.ar(basefreq * ((i-1)*voice/50+1), 0)})) + (0.5 * LFTri.ar(basefreq2, voice)),
        LFTri.ar(basefreq/64*rate, 0.5).range(lfof1,lfof2),
        resonance*4).tanh*2;
    // sound = sound.tanh*2;
    var in = sound;
    var fbNode = FbNode(2, 0.5, 2);
    var signal = fbNode.delay;
    signal = RLPF.ar(signal * 0.5 + in, LFNoise1.kr(0.3).exprange(flow, fhigh), rq);
    signal = AnalogVintageDistortion.ar(signal, distort);
    fbNode.write(signal);
    //signal = GVerb.ar(signal, 60, 10);
    signal = (CombN.ar(signal, 0.4, [0.4,0.35],2) * 0.4) + (signal * 0.5);
    Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);


(
SynthDef("superperc", {
    arg out = 0, sustain=1, gate = 1, amp = 1, freq, pitch1 = 0.666667, voice = 1000, clipAmount = 0.01, pan, decay=2.0;
    var carFreq = freq * 2.0;
    var modFreq = freq * pitch1;
    var modEnv = EnvGen.ar(Env.adsr(0.001, 0.2, 0.5, 0.0, peakLevel: voice), timeScale:sustain);
    var mod = SinOsc.ar([modFreq, modFreq * 1.01]) * modEnv;
    var car = SinOsc.ar(carFreq + mod);
    var env = EnvGen.ar(Env.perc(releaseTime: decay, level: amp), timeScale:sustain, doneAction: 2);
    //var env = EnvGen.ar(Env.perc(), -3), timeScale:sustain, doneAction:2);
    var clip = clipAmount * 500;
    OffsetOut.ar(out, DirtPan.ar(car, ~dirt.numChannels, pan, env));
    //Out.ar(out, (car * ampEnv * clip).clip(-0.7, 0.7) * 0.1);
}).add;
);

(
SynthDef("superdown", {
    arg out = 0, sustain=1, gate = 1, amp = 1, freq, pitch1 = 0.3333333, voice = 800, clipAmount = 0.01, pan, decay=0;
    var carFreq = freq;
    var modFreq = freq * pitch1;
    var modEnv = EnvGen.ar(Env.adsr(0.001, 0.2, 0.5, 0.0, peakLevel: voice), timeScale:sustain);
    var pitchenv = EnvGen.kr(Env.new(levels: [1, 0], times: [2], curve: [-5]), timeScale:sustain, doneAction:2);
    var mod = SinOsc.ar([modFreq, modFreq * 1.01]) * modEnv;
    var car = SinOsc.ar((carFreq + mod) * pitchenv);
    //var env = EnvGen.ar(Env.adsr(0.1, 0.3, 0.7, 0.2, peakLevel: amp), timeScale:sustain, doneAction: 2);
    var env = EnvGen.ar(Env.pairs([[0,0],[0.1,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
    var clip = clipAmount * 500;
    OffsetOut.ar(out, DirtPan.ar(car, ~dirt.numChannels, pan, env));
    //Out.ar(out, (car * ampEnv * clip).clip(-0.7, 0.7) * 0.1);
}).add;
);

(
SynthDef("superup", {
    arg out = 0, sustain=1, gate = 1, amp = 1, freq, pitch1 = 0.3333333, voice = 800, clipAmount = 0.01, pan, decay=0;
    var carFreq = freq;
    var modFreq = freq * pitch1;
    var modEnv = EnvGen.ar(Env.adsr(0.001, 0.2, 0.5, 0.0, peakLevel: voice), timeScale:sustain);
    var pitchenv = EnvGen.kr(Env.new(levels: [0.0, 1], times: [2], curve: [-5]), timeScale:sustain, doneAction:2);
    var mod = SinOsc.ar([modFreq, modFreq * 1.01]) * modEnv;
    var car = SinOsc.ar((carFreq + mod) * pitchenv);
    //var env = EnvGen.ar(Env.adsr(0.1, 0.3, 0.7, 0.2, peakLevel: amp), timeScale:sustain, doneAction: 2);
    var env = EnvGen.ar(Env.pairs([[0,0],[0.2,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
    var clip = clipAmount * 500;
    OffsetOut.ar(out, DirtPan.ar(car, ~dirt.numChannels, pan, env));
    //Out.ar(out, (car * ampEnv * clip).clip(-0.7, 0.7) * 0.1);
}).add;
);

(
SynthDef("superfmfbk", {
    arg out = 0, sustain=1, gate = 1, amp = 1, freq, pitch1 = 0.3333333, voice = 800, clipAmount = 0.01, pan, decay=0,
    rq = 0.5, gain = 1.0, distort = 0.5, wet = 1.0, flow = 200, fhigh = 20000;
    var carFreq = freq;
    var modFreq = freq * pitch1;
    var modEnv = EnvGen.ar(Env.adsr(0.001, 0.2, 0.5, 0.0, peakLevel: voice), timeScale:sustain);
    // var pitchenv = EnvGen.kr(Env.new(levels: [1, 0], times: [2], curve: [-5]), timeScale:sustain, doneAction:2);
    var mod = SinOsc.ar([modFreq, modFreq * 1.01]) * modEnv;
    var car = SinOsc.ar((carFreq + mod));
    //var env = EnvGen.ar(Env.adsr(0.1, 0.3, 0.7, 0.2, peakLevel: amp), timeScale:sustain, doneAction: 2);
    var env = EnvGen.ar(Env.pairs([[0,0],[0.1,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
    var clip = clipAmount * 500;
    var in = car;
    var fbNode = FbNode(2, 0.5, 2);
    var signal = fbNode.delay;
    signal = RLPF.ar(signal * 0.5 + in, LFNoise1.kr(0.2).exprange(flow, fhigh), rq);
    signal = AnalogVintageDistortion.ar(signal, distort);
    //signal = CombN.ar(signal, 0.4, [0.4,0.35],2);
    fbNode.write(signal * wet);
    //signal = GVerb.ar(signal, 60, 10);
    //signal = (CombN.ar(signal, 0.4, [0.4,0.35],2) * 0.3) + (signal * 0.7);
    OffsetOut.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan, env));
    //Out.ar(out, (car * ampEnv * clip).clip(-0.7, 0.7) * 0.1);
}).add;
);

(
SynthDef("supersawfbk", {|out, rate=1, decay=0, sustain=1, pan, accelerate, freq,
    voice=0.5, semitone=12, resonance=0.2, lfo=1, pitch1=1, speed=1,
    flow = 200, fhigh = 20000, rq = 0.5, distort = 0.5, wet = 0.5|
    var env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
    var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
    var basefreq2 = basefreq * (2**(semitone/12));
    var lfof1 = min(basefreq*10*pitch1, 22000);
    var lfof2 = min(lfof1 * (lfo + 1), 22000);
    var in = MoogFF.ar(
        (0.5 * Mix.arFill(3, {|i|  SawDPW.ar(basefreq * ((i-1)*voice/50+1), 0)})) + (0.5 * LFTri.ar(basefreq2, voice)),
        LFTri.ar(basefreq/64*rate, 0.5).range(lfof1,lfof2),
        resonance*4).tanh*2;
    var fbNode = FbNode(2, 1.0);
    var signal = Mix.fill(10, {fbNode.delay(1.0.rand)});
    signal = RLPF.ar(signal * 0.5 + in, LFNoise1.kr(0.2).exprange(flow, fhigh), rq);
    signal = AnalogVintageDistortion.ar(signal, distort);
    fbNode.write((in * (1.0 - wet)) + (signal * wet));
    //fbNode.write(in + (signal*0.12));
    //fbNode.write(in.dup);
    Out.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef("superfadehammond", {|out, sustain=1, decay=0, pan, freq, vibrato=0.5, vrate=7,
	voice=0, perc=0, percf=2, accelerate=0, speed=1|
	var freqs, amps, sound, click, env, ampscale, attrel;
	attrel = (sustain/2).clip(0,0.005);
	freq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
	//env = EnvGen.ar(Env.linen(attrel, sustain-(2*attrel), attrel), doneAction:2);
    env = EnvGen.ar(Env.pairs([[0,0],[0.5,1],[1,0]], -5), timeScale:sustain, doneAction:2);
	freqs = [0.5, 1.4988, 1, 2, 2.9976, 4, 5.0409, 5.9953, 8] * freq;
	freqs = 2**(freqs < 63) * freqs; // fold up bottom register
	freqs = freqs / (2**(freqs > 6000)); // fold down high harmonics
	freqs = freqs / (2**(freqs > 6000)); // do it again for the really high notes
	amps = SelectX.kr(voice, #[
		[1, 4, 5, 4, 3, 1, 0, 0, 0], // 0: bass violin 16'
		[0, 0, 8, 0, 4, 0, 0, 0, 0], // 1: tibia 8'
		[0, 7, 8, 1, 2, 0, 0, 0, 0], // 2: bassoon 8'
		[0, 0, 7, 8, 8, 8, 8, 7, 2], // 3: french trumpet 8'
		[4, 0, 5, 5, 4, 5, 3, 3, 6], // 4: string ensemble
		[8, 8, 5, 3, 2, 4, 5, 8, 8], // 5: Blues
		[8, 8, 8, 0 ,0, 0, 0, 0, 3], // 6: Jazz 1
		[8, 8, 8, 8, 8, 8, 8, 8, 8], // 7: Full Shout
		[8, 0, 0, 0, 0, 0, 8, 8, 8], // 8: Bro' Jack
		[0, 0, 8, 8, 0, 0, 0, 0, 0]  // 9: Jazz 2
	]);
	amps = amps - [0, 0, 0, 0, 0, 0, 0.5, 1, 1.5]; // damp brilliance a bit
	amps = 2**(amps-8);
	click = WhiteNoise.ar(1) * XLine.ar(1,1e-6, 0.1);
	sound = 0.5 * Mix.ar( SinOsc.ar(freqs*(2*click+1), (2pi ! 9).rand, amps/amps.sum) );
	sound = perc * 0.5 * SinOsc.ar(freq*percf, 2pi.rand) * XLine.ar(1,1e-6,2*decay+1) + sound;
	sound = sound + BAllPass.ar(sound, 1000*LFTri.kr(vrate,0,vibrato/2,1));
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);

(
SynthDef("super303", {|out, speed=1, decay=0, sustain=0.1, pan, accelerate, freq,
    gate=1, cutoff= 2000, rq = 0.2, voice = 50|
    var sound;
    var env = EnvGen.ar(Env.adsr(0.01, 0.0, 1.0, 0.05), gate, doneAction:2, timeScale:sustain);
    var osc, filter, filterenv;
    // freq = freq / 4.0;
	osc = Saw.ar([freq / 1.0005, freq * 1.0005]);
    filterenv = EnvGen.ar(Env.adsr(0.01, 1.0, 0.2, 0.2), gate, doneAction:2);
    // filter =  RLPFD.ar(osc, cutoff * filterenv + 2500, rq, voice, 1.0);
	filter =  RLPFD.ar(osc, cutoff * filterenv + 2000, rq, voice, 1.0);
    sound = Mix(filter);
    OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add
);