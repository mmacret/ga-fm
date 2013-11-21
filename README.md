ga-fm
=====

[Classic and Modified FM](http://en.wikipedia.org/wiki/Frequency_modulation_synthesis) (modFM) are sound synthesis techniques that can be used to generate harmonic instrument sounds.

ga-fm is a genetic algorithm (GA) using a fitness function based on harmonics analysis that is able to automatize the calibration of FM  synthesis models for the reconstruction of harmonic instrument tones.

##Dependencies
ga-fm requires some MATLAB toolboxes:
* [Global optimization toolbox](www.mathworks.com/products/global-optimization/‎)
* [Parallel Computing Toolbox](www.mathworks.com/products/parallel-computing/‎) (to speed up the evolution)

##Getting start
* Put the WAV sound files you want to reconstruct in the sounds folder.
* Run matlabpool (start Parallel Computing Toolbox).
* Run scriptExpClassicFM.m (resp. scripExpModFM.m) to reconstruct your sounds using Classic FM (resp. ModFM).
* The results will be stored in classic.mat (resp. mod.mat) and the synthesized sounds written in the current folder.

##Limitations
* Neither the MATLAB code nor the GA parameters are optimized so be patient :).
* Limit yourself to short target sounds (around 2 seconds long).

##More info

* More information about the implementation can be find in this [paper](http://matthieumacret.com/pdf/SMC2012_MACRET.pdf) taken from the proceedings of [SMC2012](http://smc2012.smcnetwork.org/).
* The slides of the presentation are on [slideshare](http://www.slideshare.net/matthieumacret/smc2012).
* Some results are available to listen [here](http://www.sfu.ca/~mmacret/GA/).


