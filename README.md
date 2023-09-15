# guttersyn
norns implementation of Tom Mudd's GutterSynthesis

<img width="1782" alt="Screenshot 2023-09-15 at 20 06 38" src="https://github.com/whosebodyisthis/guttersyn/assets/133358060/d429278b-5dc7-4b73-a54b-bb757d2af756">

about
=====
this norns script implements the SuperCollider version of Tom Mudd's 
*Gutter Synthesis* with a simple and neat UI.

*Gutter Synthesis* "combines chaotic synthesis based on the Duffing Oscillator dynamical system with modal-like resonances"
(https://www.research.ed.ac.uk/en/publications/between-chaotic-synthesis-and-physical-modelling-intrumentalizing, 2019). 

a forced Duffing Osciallator is passed through a bank of 24 resonant bandpass filters. The interaction between filters 
and the chaotic nature of the Duffing oscillator offers the listener a beautiful unstable system that shifts between swarms 
of noise and beautiful textures, with the unqiue timbres provided by physical modelling. 

controls
========
-- K2 - Switch control pages
-- K3 - Switches control collection

-- E1/E2/E3 - Adjust respective control

to install
==========
this script requires an additional SuperCollider extension to be compiled for this script to work.

to install:

ssh into your norns with:

```
ssh we@norns.local
```

clone the SuperCollider source code:

```
git clone https://github.com/supercollider/supercollider.git
```

clone the SC version of GutterSynthesis and make build directories:

```
git clone https://github.com/madskjeldgaard/guttersynth-sc
cd guttersynth-sc
mkdir build
cd build
```

Use CMake to build the GutterSynthesis into the extension folder:
```
cmake .. -DCMAKE_BUILD_TYPE=Release -DSC_PATH=../supercollider -DCMAKE_INSTALL_PREFIX=/home/we/.local/share/SuperCollider/Extensions/
cmake --build . --config Release
cmake --build . --config Release --target install
cd ..
```

Remove source code folders:
```
rm -rf guttersynth-sc
rm -rf supercollider
```

todo:
=====
-- enable control to switch between internal/external osc for GutterSynthesis sound source.

-- lua LFOs to modulate parameters

-- more scales

references
==========
Tom Mudd's Gutter Synthesis for Max/MSP / Java:

https://github.com/tommmmudd/guttersynthesis

Mads Kjeldgaard and Scot Carver's SuperCollider version:

https://github.com/madskjeldgaard/guttersynth-sc
