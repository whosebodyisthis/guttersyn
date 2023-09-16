Engine_GutterSynthesis : CroneEngine {
	// Define a getter for the synth variable
	var <synth;

	// Define a class method when an object is created
	*new { arg context, doneCallback;
		// Return the object from the superclass (CroneEngine) .new method
		^super.new(context, doneCallback);
	}
	alloc {
		// Define the synth variable, whichis a function
		SynthDef(\testgen, { arg inL, inR, out, amp, mod, omega, damp, rate, gain, smoothing, q, pitch, scale1, scale2, gain1, gain2;
			var freq1, freq2, snd1, snd2, scale, enableaudio=0;

			scale = [
				Array.fill(24,{ arg i; Scale.chromatic.degreeToFreq(i, 45.midicps, 0); }),
				Array.fill(24,{ arg i; Scale.chromatic24.degreeToFreq(i, 45.midicps, 0); }),
				Array.fill(24,{ arg i; Scale.major.degreeToFreq(i, 45.midicps, 0); }),
				Array.fill(24,{ arg i; Scale.minor.degreeToFreq(i, 45.midicps, 0); }),
				Array.fill(24,{ arg i; Scale.harmonicMajor.degreeToFreq(i, 45.midicps, 0); }),
				Array.fill(24,{ arg i; Scale.harmonicMinor.degreeToFreq(i, 45.midicps, 0); }),
				Array.fill(24,{ arg i; Scale.partch_o1.degreeToFreq(i, 45.midicps, 0); }),
				Array.fill(24,{ arg i; Scale.partch_u1.degreeToFreq(i, 45.midicps, 0); }),
				Array.fill(24,{ arg i; Scale.diminished.degreeToFreq(i, 45.midicps, 0); }),
				[50, 150, 250, 350, 455, 570, 700, 925, 1175, 1375, 1600, 1860, 2160, 2510, 2925, 3425, 4050, 4850, 5850, 7050, 8600, 10750, 13500] //Bark scale
			];

			freq1 = Lag3.kr(pitch * Select.kr(scale1, scale)); //Pitch 0.05 - 2.0
			freq2 = Lag3.kr(pitch * Select.kr(scale2, scale));

			snd1 = GutterSynth.ar(
				gamma:         Lag.kr(mod),
				omega:         Lag3.kr(omega,0.2),
				c:             Lag.kr(damp),
				dt:         Lag3.kr(rate,0.2),
				singlegain: Lag.kr(gain),
				smoothing:  Lag.kr(smoothing),
				togglefilters: 1,
				distortionmethod: 1,
				oversampling: 1,
				enableaudioinput: 0,
				audioinput: inL,
				gains1:     Lag.kr(gain1),
				gains2:     Lag.kr(gain2),
				freqs1:     `freq1,
				qs1:         Array.rand(24,0.95,1) * q,
				freqs2:     `freq2,
				qs2:         Array.rand(24,0.95,1) * q
			);

			snd2 = GutterSynth.ar(
				gamma:         Lag.kr(mod),
				omega:         Lag3.kr(omega,0.2),
				c:             Lag.kr(damp),
				dt:         Lag3.kr(rate,0.2),
				singlegain: Lag.kr(gain),
				smoothing:  Lag.kr(smoothing),
				togglefilters: 1,
				distortionmethod: 1,
				oversampling: 1,
				enableaudioinput: 0,
				audioinput: inR,
				gains1:     Lag.kr(gain1),
				gains2:     Lag.kr(gain2),
				freqs1:     `freq1,
				qs1:         Array.rand(24,0.95,1) * q,
				freqs2:     `freq2,
				qs2:         Array.rand(24,0.95,1) * q
			);

			Out.ar(out,Balance2.ar(snd1,snd2,0,amp));
		}).add;

		context.server.sync;

		synth = Synth.new(\testgen, [\inL, context.in_b[0].index, \inR, context.in_b[1].index, \out, context.out_b.index], context.xg);

		// Export argument symbols as modulatable paramaters
		// This could be extended to control the Lag time as additional params
		this.addCommand("amp", "f", { arg msg;
			synth.set(\amp, msg[1]);
		});

		this.addCommand("mod", "f", { arg msg;
			synth.set(\mod, msg[1]);
		});

		this.addCommand("omega", "f", { arg msg;
			synth.set(\omega, msg[1]);
		});

		this.addCommand("damp", "f", { arg msg;
			synth.set(\damp, msg[1]);
		});

		this.addCommand("rate", "f", { arg msg;
			synth.set(\rate, msg[1]);
		});

		this.addCommand("gain", "f", { arg msg;
			synth.set(\gain, msg[1]);
		});

		this.addCommand("smoothing", "f", { arg msg;
			synth.set(\smoothing, msg[1]);
		});

		this.addCommand("q", "f", { arg msg;
			synth.set(\q, msg[1]);
		});

		this.addCommand("pitch", "f", { arg msg;
			synth.set(\pitch, msg[1]);
		});

		this.addCommand("scale1", "f", { arg msg;
			synth.set(\scale1, msg[1]);
		});

		this.addCommand("scale2", "f", { arg msg;
			synth.set(\scale2, msg[1]);
		});

		this.addCommand("gain1", "f", { arg msg;
			synth.set(\gain1, msg[1]);
		});

		this.addCommand("gain2", "f", { arg msg;
			synth.set(\gain2, msg[1]);
		});
	}
	// define a function that is called when the synth is shut down
	free {
		synth.free;
	}
}
