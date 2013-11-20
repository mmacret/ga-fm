function y = ModFMSynth( fc, fm, A,k, Ns, fs )
%ModFMSynth ModFM synthesis function
%   ModFMSynth generates a waveform using the general equation of the ModFM
%   synthesis method.
%
%y = ModFMSynth( fc, fm, A,k, Ns, fs )
% -fc is the carrier frequency, 
% -fm is the modulation frequency, 
% -I is the modulation index (vector), 
% -A is the time varying amplitude (vector).
% -Ns is the number of samples and fs the sampling frequency.

y = A.*exp(k.*mycos(fm,0,Ns,fs)).*mycos(fc,0,Ns,fs);


end
